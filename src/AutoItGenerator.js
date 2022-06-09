/* eslint-disable no-magic-numbers */
const version = process.env.npm_package_version || require("../package.json").version;
const fs = require("fs");
const sysPath = require("path");
const {spawn} = require("child_process");
const cpus = require("os").cpus().length;
const eachOfLimit = require("async/eachOfLimit");
const series = require("async/series");
const waterfall = require("async/waterfall");
const eol = require("eol");
const { convertExpression } = require("node-autoit-binding-utils/src/autoit-expression-converter");

const [VERSION_MAJOR, VERSION_MINOR] = version.split(".");

const LF = "\n";

const {removeNamespaces} = require("./alias");
const knwon_ids = require("./ids");
const conversion = require("./conversion");
const custom_conversions = require("./custom_conversions");
const map_conversion = require("./map_conversion");
const vector_conversion = require("./vector_conversion");
const FunctionDeclaration = require("./FunctionDeclaration");
const PropertyDeclaration = require("./PropertyDeclaration");
const doctoc = require("./doctoc");

const {
    IDL_TYPES,
    CPP_TYPES,
    IGNORED_CLASSES,
    ARRAY_CLASSES,
    ARRAYS_CLASSES,
    PTR,
} = require("./constants");

const CoClass = require("./CoClass");
const {orderDependencies} = require("./dependencies");

class AutoItGenerator {
    constructor() {
        this.classes = new Map();
        this.enums = new Map();
        this.typedefs = new Map();

        // for inheritance tree computation
        this.bases = new Map();
        this.derives = new Map();

        this.dependents = new Map();
        this.dependencies = new Map();

        this.docs = [];
    }

    generate({decls, namespaces, generated_include}, options = {}, cb = undefined) {
        const {APP_NAME, LIB_UID, LIBRARY, shared_ptr} = options;

        this.namespaces = new Set();

        this.namespace = options.namespace;

        this.options = options;

        for (const namespace of namespaces) {
            this.namespaces.add(namespace.split(".").join("::"));
        }

        for (const decl of decls) {
            const [name] = decl;

            if (name.startsWith("class ") || name.startsWith("struct ")) {
                this.add_class(decl);
            } else if (name.startsWith("enum ")) {
                this.add_enum(decl);
            } else {
                this.add_func(decl);
            }
        }

        this.add_vector("vector<_variant_t>", {}, options);
        this.namedParameters = this.classes.get(this.add_map("map<string, _variant_t>", {}, options));

        for (const fqn of IGNORED_CLASSES) {
            if (this.classes.has(fqn)) {
                this.classes.delete(fqn);
            }
        }

        const files = new Map();
        const libs = [];
        const resources = [];

        for (const fqn of this.classes.keys()) {
            const docid = this.docs.length;

            const is_test = options.test && !options.notest.has(fqn);

            const coclass = this.classes.get(fqn);
            const cotype = coclass.getClassName();
            const is_idl_class = !coclass.noidl && (coclass.is_class || coclass.is_struct);

            const signatures = this.getSignatures(coclass, options);

            // Add a default constructor
            if (coclass.has_default_constructor === 0) {
                coclass.addMethod([
                    `${ coclass.fqn }.${ coclass.name }`,
                    "",
                    [],
                    []
                ]);
            }

            // inherit methods
            for (const pfqn of coclass.parents) {
                if (!this.classes.has(pfqn)) {
                    continue;
                }

                const parent = this.classes.get(pfqn);

                for (const fname of parent.methods.keys()) {
                    if (fname === "create") {
                        continue;
                    }

                    const overrides = parent.methods.get(fname);

                    for (const decl of overrides) {
                        const [name, return_value_type, func_modifiers, list_of_arguments] = decl;

                        const signature = this.getSignature(coclass, fname, decl, options);

                        if (signatures.has(signature)) {
                            // console.log("duplicated", signature);
                            continue;
                        }

                        const modifiers = func_modifiers.slice();

                        if (!func_modifiers.some(modifier => modifier.startsWith("/Cast="))) {
                            modifiers.push(`/Cast=static_cast<${ parent.fqn }*>`);
                        }

                        coclass.addMethod([`${ fqn }.${ name.split(".").pop() }`, return_value_type, modifiers, list_of_arguments]);

                        signatures.add(signature);
                    }
                }
            }

            const idnames = new Set();

            let id = 0;
            const iidl = [];
            const iprivate = [];
            const ipublic = [];
            const iglobal = [];
            const impl = [];

            const constructor = [];
            const destructor = [];

            if (is_idl_class) {
                if (idnames.has("self".toLowerCase())) {
                    throw new Error(`duplicated idl name ${ "self" }`);
                }
                idnames.add("self".toLowerCase());

                id++;
                constructor.push(`this->__self = new ${ shared_ptr }<${ coclass.fqn }>();`);

                if (coclass.has_default_constructor) {
                    constructor.push(`this->__self->reset(new ${ coclass.fqn }());`);
                }

                destructor.push("delete this->__self;");
                destructor.push("this->__self = nullptr;");

                iidl.push(`[propget, id(${ id })] HRESULT self([out, retval] VARIANT* pVal);`);
                iidl.push(`[propput, id(${ id })] HRESULT self([in] ULONGLONG ptr);`);
                ipublic.push("STDMETHOD(get_self)(VARIANT* pVal);");
                ipublic.push("STDMETHOD(put_self)(ULONGLONG ptr);");
                impl.push(`
                    STDMETHODIMP C${ cotype }::get_self(VARIANT* pVal) {
                        if (this->__self) {
                            V_VT(pVal) = VT_UI8;
                            V_UI8(pVal) = reinterpret_cast<ULONGLONG>(this->__self->get());
                            return S_OK;
                        }
                        return E_FAIL;
                    }

                    STDMETHODIMP C${ cotype }::put_self(ULONGLONG ptr) {
                        if (this->__self) {
                            *this->__self = ${ shared_ptr }<${ coclass.fqn }>(${ shared_ptr }<${ coclass.fqn }>{}, reinterpret_cast<${ coclass.fqn }*>(ptr));
                            return S_OK;
                        }
                        return E_FAIL;
                    }`.replace(/^ {20}/mg, "")
                );
            }

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return !modifiers.includes("/Enum");
            }).forEach(idlname => {
                PropertyDeclaration.writeProperty(this, iidl, impl, ipublic, iprivate, idnames, fqn, idlname, ++id, is_test, options);
            });

            // methods
            for (const fname of Array.from(coclass.methods.keys()).sort((a, b) => {
                if (a === "create") {
                    return -1;
                }

                if (b === "create") {
                    return 1;
                }

                return a > b ? 1 : a < b ? -1 : 0;
            })) {
                if (idnames.has(fname.toLowerCase())) {
                    throw new Error(`duplicated idl name ${ fqn }::${ fname }`);
                }
                idnames.add(fname.toLowerCase());

                const overrides = coclass.methods.get(fname);
                FunctionDeclaration.declare(this, coclass, overrides, fname, fname, ++id, iidl, ipublic, impl, is_test, options);
            }

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return modifiers.includes("/Enum");
            }).forEach(idlname => {
                PropertyDeclaration.writeProperty(this, iidl, impl, ipublic, iprivate, idnames, fqn, idlname, ++id, is_test, options);
            });

            if (is_idl_class) {
                const cpptype = this.typedefs.has(fqn) ? this.typedefs.get(fqn) : this.getCppType(fqn, coclass, options);

                iglobal.push(`
                    template<>
                    struct TypeToImplType<${ cpptype }> {
                        typedef C${ cotype } type;
                    };
                `.replace(/^ {20}/mg, "").trim());

                iglobal.push("");
            }

            // enums
            for (const ename of coclass.enums) {
                if (!ename.endsWith("<unnamed>")) {
                    conversion.enum(ename, iglobal, impl, options);
                }
            }

            // converter
            conversion.convert(coclass, iglobal, impl, options);

            if (coclass.generate) {
                coclass.generate(iglobal, iidl, impl, ipublic, iprivate, idnames, id, is_test, options);
            }

            const hdr_id = `_${ coclass.getObjectName().toUpperCase() }_OBJECT_`;

            const definition = `
                [
                    object,
                    uuid(${ coclass.iid }),
                    dual,
                    nonextensible,
                    pointer_default(unique)
                ]

                interface I${ cotype } : ${ coclass.interface }
                {
                    ${ iidl.join("\n").split("\n").join(`\n${ " ".repeat(20) }`) }
                };
            `.replace(/^ {16}/mg, "");

            coclass.iface = {
                cotype,
                hdr_id,
                filename: `i${ coclass.getObjectName() }.idl`,
                definition
            };

            if (coclass.noidl) {
                coclass.iface.header = `
                    // C${ cotype }

                    ${ iglobal.join("\n").split("\n").join(`\n${ " ".repeat(20) }`) }
                `.replace(/^ {20}/mg, "");
            } else {
                libs.push(`
                    [
                        uuid(${ coclass.clsid })
                    ]
                    coclass ${ cotype }
                    {
                        [default] interface I${ cotype };
                    };`.replace(/^ {20}/mg, "")
                );

                // resource.h
                resources.push(`#define IDR_${ cotype.toUpperCase().padEnd(44, " ") } ${ coclass.idr }`);

                if (iglobal.length !== 0) {
                    iglobal.unshift("");
                }

                iglobal.unshift(`OBJECT_ENTRY_AUTO(__uuidof(${ cotype }), C${ cotype })`);

                const bases = [
                    "public CComObjectRootEx<CComSingleThreadModel>",
                    `public CComCoClass<C${ cotype }, &CLSID_${ cotype }>`,
                    `public IDispatchImpl<I${ coclass.dispimpl ? coclass.dispimpl : cotype }, &IID_I${ cotype }, &LIBID_${ LIBRARY }, /*wMajor =*/ ${ VERSION_MAJOR }, /*wMinor =*/ ${ VERSION_MINOR }>`,
                ];

                if (is_idl_class) {
                    if (ARRAY_CLASSES.has(coclass.fqn)) {
                        if (coclass.dispimpl) {
                            bases[bases.length - 1] = bases[bases.length - 1].replace("AutoItObject", "IVariantArrayImpl");
                        } else {
                            bases.push(`public IVariantArrayImpl<${ coclass.fqn }>`);
                        }
                    } else if (ARRAYS_CLASSES.has(coclass.fqn)) {
                        if (coclass.dispimpl) {
                            bases[bases.length - 1] = bases[bases.length - 1].replace("AutoItObject", "IVariantArraysImpl");
                        } else {
                            bases.push(`public IVariantArraysImpl<${ coclass.fqn }>`);
                        }
                    } else if (!coclass.dispimpl) {
                        bases.push(`public AutoItObject<${ coclass.fqn }>`);
                    }
                }

                coclass.iface.header = `
                    class ATL_NO_VTABLE C${ cotype } :
                        ${ bases.join(`,\n${ " ".repeat(24) }`) }
                    {
                    public:
                        C${ cotype }()
                        {
                        }

                    DECLARE_REGISTRY_RESOURCEID(IDR_${ cotype.toUpperCase() })


                    BEGIN_COM_MAP(C${ cotype })
                        COM_INTERFACE_ENTRY(I${ cotype })
                        COM_INTERFACE_ENTRY(${ coclass.interface })
                    END_COM_MAP()

                        DECLARE_PROTECT_FINAL_CONSTRUCT()

                        HRESULT FinalConstruct();

                        void FinalRelease();

                    private:
                        ${ iprivate.join("\n").split("\n").join(`\n${ " ".repeat(24) }`) }

                    public:
                        ${ ipublic.join("\n").split("\n").join(`\n${ " ".repeat(24) }`) }
                    };

                    ${ iglobal.join("\n").split("\n").join(`\n${ " ".repeat(20) }`) }
                `.replace(/^ {20}/mg, "");

                constructor.push("return S_OK;");

                if (!coclass.is_rexternal) {
                    impl.unshift(`
                        void C${ cotype }::FinalRelease() {
                            ${ destructor.join(`\n${ " ".repeat(28) }`) }
                        }
                    `.replace(/^ {24}/mg, ""));
                }

                if (!coclass.is_cexternal) {
                    impl.unshift(`
                        HRESULT C${ cotype }::FinalConstruct() {
                            ${ constructor.join(`\n${ " ".repeat(28) }`) }
                        }
                    `.replace(/^ {24}/mg, ""));
                }
            }

            coclass.iface.impl = impl.join("\n");

            if (docid !== this.docs.length) {
                this.docs.splice(docid, 0, `## ${ fqn }\n`);
            }
        }

        const rgs = [];
        const objects = [];

        for (const fqn of this.classes.keys()) {
            const coclass = this.classes.get(fqn);
            const { iface } = coclass;
            const { cotype, hdr_id } = iface;
            const className = coclass.getClassName();

            objects.push(`#include "${ className }.h"`);

            if (options.rgs !== false && !coclass.noidl) {
                rgs.push(`IDR_${ cotype.toUpperCase().padEnd(44, " ") } REGISTRY    "${ cotype }.rgs"`);

                files.set(sysPath.join(options.output, `${ cotype }.rgs`), `
                    HKCR
                    {
                        ${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR } = s '${ cotype } class'
                        {
                            CLSID = s '{${ coclass.clsid }}'
                        }
                        ${ APP_NAME }.${ coclass.progid } = s '${ cotype } class'
                        {       
                            CurVer = s '${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR }'
                        }
                        NoRemove CLSID
                        {
                            ForceRemove {${ coclass.clsid }} = s '${ cotype } class'
                            {
                                ProgID = s '${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR }'
                                VersionIndependentProgID = s '${ APP_NAME }.${ coclass.progid }'
                                ForceRemove Programmable
                                InprocServer32 = s '%MODULE%'
                                {
                                    val ThreadingModel = s 'Apartment'
                                }
                                TypeLib = s '{${ LIB_UID }}'
                                Version = s '${ VERSION_MAJOR }.${ VERSION_MINOR }'
                            }
                        }
                    }
                `.replace(/^ {20}/mg, "").trim().replace(/[^\S\n]+$/mg, "") + LF);
            }

            const dependencies = this.dependencies.has(fqn) ?
                this.getOrderedDependencies(new Set(this.dependencies.get(fqn).values()))
                : [];

            const idl_deps = dependencies.filter(dependency => !dependency.noidl).map(dependency => {
                return `import "${ dependency.iface.filename }";\ncpp_quote("#include \\"${ dependency.iface.filename.replace(".idl", ".h") }\\"")`;
            });

            if (dependencies.length !== 0) {
                idl_deps.unshift("");
                idl_deps.unshift(...dependencies.map(dependency => `interface I${ dependency.iface.cotype };`));
            }

            const content = `
                // ${ fqn }
                #ifndef ${ hdr_id }IDL_FILE_
                #define ${ hdr_id }IDL_FILE_

                #ifndef _OAI_IDL_
                #define _OAI_IDL_
                import "oaidl.idl";
                import "ocidl.idl";
                #endif

                ${ idl_deps.join(`\n${ " ".repeat(16) }`) }

                ${ iface.definition.trim().split("\n").join(`\n${ " ".repeat(16) }`) }
                #endif //  ${ hdr_id }IDL_FILE_
            `.replace(/^ {16}/mg, "");

            if (options.idl !== false && !coclass.noidl) {
                files.set(sysPath.join(options.output, `${ iface.filename }`), content.trim().replace(/[^\S\n]+$/mg, "") + LF);
            }

            const includes = dependencies.map(dependency => `#include "${ dependency.getClassName() }.h"`);

            if (coclass === this.namedParameters) {
                includes.push(`\ntypedef ${ this.namedParameters.fqn } NamedParameters;\n`);
            } else if (!coclass.is_vector && !coclass.is_stdmap) {
                includes.push(`#include "${ this.namedParameters.getClassName() }.h"`);
            }

            if (options.hdr !== false) {
                const using = new Set([
                    "ATL",
                    this.namespace,
                ]);

                if (coclass.namespace) {
                    // using.add(coclass.namespace);
                }

                if (coclass.include && coclass.include.namespace && coclass.include.namespace !== coclass.namespace) {
                    // using.add(coclass.include.namespace);
                }

                coclass.cpp_quotes.unshift(`// C${ cotype }`);

                files.set(sysPath.join(options.output, `${ className }.h`), `
                    #pragma once
                    #ifndef ${ hdr_id }
                    #define ${ hdr_id }

                    #include "autoit_bridge.h"

                    ${ coclass.cpp_quotes.join(`\n${ " ".repeat(20) }`) }

                    #if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
                    #error "Les objets COM monothread ne sont pas correctement pris en charge par les plateformes Windows CE, notamment les plateformes Windows Mobile qui ne prennent pas totalement en charge DCOM. Définissez _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA pour forcer ATL à prendre en charge la création d'objets COM monothread et permettre l'utilisation de leurs implémentations. Le modèle de thread de votre fichier rgs a été défini sur 'Libre', car il s'agit du seul modèle de thread pris en charge par les plateformes Windows CE non-DCOM."
                    #endif

                    ${ Array.from(using).map(namespace => `using namespace ${ namespace };`).join(`\n${ " ".repeat(20) }`) }

                    ${ iface.header.split("\n").join(`\n${ " ".repeat(20) }`).trim() }

                    ${ includes.join(`\n${ " ".repeat(20) }`) }
                    #endif // ${ hdr_id }
                `.replace(/^ {20}/mg, "").trim().replace(/[^\S\n]+$/mg, "") + LF);
            }

            if (!coclass.is_external && options.impl !== false) {
                files.set(sysPath.join(options.output, `${ className }.cpp`), [
                    `#include "${ className }.h"`,
                    "",
                    iface.impl,
                ].join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
            }
        }

        const _conversions = custom_conversions.map(fn => fn([], [], options));

        if (options.hdr !== false) {
            files.set(sysPath.join(options.output, "generated_include.h"), generated_include.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

            const bridge_header = [
                `
                #pragma once

                #ifndef NOMINMAX
                #define NOMINMAX
                #endif

                #ifndef STRICT
                #define STRICT
                #endif

                #include "targetver.h"

                #define _ATL_APARTMENT_THREADED

                #define _ATL_NO_AUTOMATIC_NAMESPACE

                #define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS  // certains constructeurs CString seront explicites


                #include <comsvcs.h>

                #define ATL_NO_ASSERT_ON_DESTROY_NONEXISTENT_WINDOW

                #include "resource.h"
                #include "${ LIBRARY }.h"
                #include "generated_include.h"

                using namespace ${ this.namespace };

                ${ Array.from(this.typedefs).map(([fqn, cpptype]) => `typedef ${ cpptype } ${ fqn };`).join(`\n${ " ".repeat(16) }`) }

                `.replace(/^ {16}/mg, ""),
                conversion.number.declare("char", "CHAR", options), "",
                conversion.number.declare("uchar", "BYTE", options), "",
                conversion.number.declare("short", "SHORT", options), "",
                conversion.number.declare("ushort", "USHORT", options), "",
                conversion.number.declare("int", "LONG", options), "",
                conversion.number.declare("uint", "ULONG", options), "",
                conversion.number.declare("long", "LONG", options), "",
                conversion.number.declare("unsigned long", "ULONG", options), "",
                conversion.number.declare("float", "float", options), "",
                conversion.number.declare("double", "double", options), "",
                conversion.number.declare("int64", "LONGLONG", options), "",
                conversion.number.declare("size_t", "ULONGLONG", options), "",
            ];

            _conversions.forEach(cvt => {
                bridge_header.push(cvt[0], "");
            });

            bridge_header.push("");

            files.set(sysPath.join(options.output, "autoit_bridge_generated.h"), bridge_header.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        const bridge_impl = [
            "#pragma once\n",
            "#include \"autoit_bridge_generated.h\"\n",
            conversion.number.define("char", "CHAR", options), "",
            conversion.number.define("uchar", "BYTE", options), "",
            conversion.number.define("short", "SHORT", options), "",
            conversion.number.define("ushort", "USHORT", options), "",
            conversion.number.define("int", "LONG", options), "",
            conversion.number.define("uint", "ULONG", options), "",
            conversion.number.define("long", "LONG", options), "",
            conversion.number.define("unsigned long", "ULONG", options), "",
            conversion.number.define("float", "float", options), "",
            conversion.number.define("double", "double", options), "",
            conversion.number.define("int64", "LONGLONG", options), "",
            conversion.number.define("size_t", "ULONGLONG", options), "",
            ""
        ];

        _conversions.forEach(cvt => {
            bridge_impl.push(cvt[1], "");
        });

        bridge_impl.push("");

        files.set(sysPath.join(options.output, "autoit_bridge_generated.cpp"), bridge_impl.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

        if (options.rgs !== false) {
            files.set(sysPath.join(options.output, "registries.rgs"), rgs.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        for (const fqn of Object.keys(knwon_ids)) {
            if (!this.classes.has(fqn) || this.classes.get(fqn).noidl) {
                delete knwon_ids[fqn];
            }
        }
        files.set(sysPath.join(__dirname, "ids.json"), JSON.stringify(knwon_ids, null, 4));

        const ifaces = this.getOrderedDependencies();

        if (options.idl !== false) {
            const idl = `
                #ifndef _OAI_IDL_
                #define _OAI_IDL_
                import "oaidl.idl";
                import "ocidl.idl";
                #endif

                ${ ifaces.map(({ cotype }) => `interface I${ cotype };`).join(`\n${ " ".repeat(16) }`) }

                ${ ifaces.map(({ filename }) => `import "${ filename }";`).join(`\n${ " ".repeat(16) }`) }

                [
                    uuid(${ LIB_UID }),
                    version(${ VERSION_MAJOR }.${ VERSION_MINOR }),
                ]
                library ${ LIBRARY }
                {
                    importlib("stdole2.tlb");
                    ${ libs.join("\n").split("\n").join(`\n${ " ".repeat(16) }`) }
                };

                import "shobjidl.idl";
                `.replace(/^ {16}/mg, "");

            files.set(sysPath.join(options.output, `${ LIBRARY }.idl`), idl.trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        if (options.hdr !== false) {
            files.set(sysPath.join(options.output, "resource.h"), `
                #pragma once

                //{{NO_DEPENDENCIES}}
                // fichier Include Microsoft Visual C++.
                // Utilisé par ${ LIBRARY }.rc
                //
                #define IDS_PROJNAME                    100
                #define IDR_${ this.namespace.toUpperCase() }                          101
                ${ resources.join(`\n${ " ".repeat(16) }`) }

                // Next default values for new objects
                // 
                #ifdef APSTUDIO_INVOKED
                #ifndef APSTUDIO_READONLY_SYMBOLS
                #define _APS_NEXT_RESOURCE_VALUE        201
                #define _APS_NEXT_COMMAND_VALUE         32768
                #define _APS_NEXT_CONTROL_VALUE         201
                #define _APS_NEXT_SYMED_VALUE           110
                #endif
                #endif
            `.replace(/^ {16}/mg, "").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        // enums

        const globals = options.globals ? new Set(options.globals) : new Set();
        const constReplacer = options.constReplacer  || new Map();

        const getPrefixVariableName = prefix => {
            prefix = prefix.split(".").join("_").replace(/[a-z][A-Z]/g, match => `${ match[0] }_${ match[1] }`).toUpperCase();
            return (options.global_prefix ? options.global_prefix : "") + prefix;
        };

        const etext = Array.from(this.enums.keys()).map(ename => {
            const [, , , enums] = this.enums.get(ename);
            const path = ename.split("::");

            const values = new Map(enums.map(([name, value]) => [name.slice("const ".length), value]));

            const expansionRe = new RegExp(`\\b(?:${ Array.from(values).map(([name, value]) => name.split(".").pop()).join("|") })\\b`, "g");

            const getVariableName = (prefix, vname) => {
                return values.has(`${ prefix }.${ vname }`) ? `$${ getPrefixVariableName(prefix) }_${ vname }` : vname;
            };

            ename = path[path.length - 1];

            return `; ${ ename === "<unnamed>" ? "anonymous" : ename }\n${ Array.from(values).map(([name, value]) => {
                const pos = name.lastIndexOf(".");
                const prefix = name.slice(0, pos);
                const vkey = name.slice(pos + 1);
                const vname = getVariableName(prefix, vkey);

                if (globals.has(vname)) {
                    console.log("skip already defined global", vname);
                    return null;
                }

                globals.add(vname);

                value = convertExpression(value, options).replace(expansionRe, getVariableName.bind(null, prefix)).replace(/\b(?<!\$)(?=CV_)/g, "$");

                for (const [substr, newSubstr] of constReplacer) {
                    value = value.replaceAll(substr, newSubstr);
                }

                return `Global Const ${ vname } = ${ value }`;
            }).join("\n") }`;
        }).join("\n\n");

        files.set(sysPath.resolve(options.output, "..", "udf", `${ this.namespace }_enums.au3`), `${ `
            #include-once
            #include "${ this.namespace }_interface.au3"

            ${ etext.split("\n").join(`\n${ " ".repeat(12) }`) }
        `.replace(/^ {12}/mg, "").trim() }\n`);

        if (options.toc !== false) {
            this.docs.unshift("");
            this.docs.unshift(`
                ## Table Of Contents

                <!-- START doctoc -->
                <!-- END doctoc -->
            `.replace(/^ {16}/mg, "").trim());
        }

        this.docs.unshift("");
        this.docs.unshift(`
            # AutoIt ${ options.APP_NAME } UDF
        `.replace(/^ {12}/mg, "").trim());

        files.set(sysPath.resolve(options.output, "..", "udf", "docs.md"), this.docs.join("\n"));

        let vs_generate = false;
        const idls_to_generate = new Set();
        const doctoc_to_generate = new Set();

        series([
            next => {
                // write files
                eachOfLimit(files.keys(), cpus, (filename, i, next) => {
                    if (options.save === false) {
                        next();
                        return;
                    }

                    waterfall([
                        next => {
                            fs.readFile(filename, (err, buffer) => {
                                if (err && err.code === "ENOENT") {
                                    vs_generate = true;
                                    err = null;
                                    buffer = Buffer.from([]);
                                }
                                next(err, buffer);
                            });
                        },

                        (buffer, next) => {
                            const content = eol.crlf(files.get(filename));
                            const str = buffer.toString();

                            if (content === str) {
                                next();
                                return;
                            }

                            console.log("write file", options.output, sysPath.relative(options.output, filename));
                            fs.writeFile(filename, content, next);
                        },

                        next => {
                            if (options.toc !== false && filename.endsWith(".md")) {
                                doctoc_to_generate.add(filename);
                            }

                            if (!filename.endsWith(".idl")) {
                                next();
                                return;
                            }

                            fs.stat(filename, (err, stats) => {
                                if (err) {
                                    next(err);
                                    return;
                                }

                                const dirname = sysPath.dirname(filename);
                                const basename = sysPath.basename(filename, ".idl");
                                const header = sysPath.join(dirname, `${ basename }.h`);

                                fs.stat(header, (err, hstats) => {
                                    if (err && err.code === "ENOENT") {
                                        err = null;
                                    }

                                    if (options.build.has("idl") || !hstats || hstats.mtime < stats.mtime) {
                                        idls_to_generate.add(filename);

                                        // tlb must be regenerated on any idl change
                                        idls_to_generate.add(sysPath.join(options.output, `${ LIBRARY }.idl`));
                                    }

                                    next(err);
                                });
                            });
                        },
                    ], next);
                }, next);
            },

            next => {
                // generate doctoc
                doctoc.transformAndSave(doctoc_to_generate, next);
            },

            next => {
                // compile idls
                // manual compilation is necessary because
                // vs will loop indefinetely due to circular dependencies
                eachOfLimit(idls_to_generate, cpus, (filename, i, next) => {
                    const dirname = sysPath.dirname(filename);
                    const basename = sysPath.basename(filename, ".idl");

                    const child = spawn("midl.exe", options.includes.map(path => `/I${ path }`).concat([
                        `/I${ dirname }`,
                        "/W1", "/nologo",
                        "/char", "signed",
                        "/env", "x64",
                        "/h", `${ basename }.h`,
                        "/iid", `${ basename }_i.c`,
                        "/proxy", `${ basename }_p.c`,
                        "/tlb", `${ basename }.tlb`,
                        "/target", "NT60",
                        `/out${ dirname }`,
                        filename
                    ]), {
                        stdio: "inherit"
                    });

                    child.on("error", next);
                    child.on("close", next);
                }, next);
            },

            next => {
                // generate visual studio solution
                if (!vs_generate || options.skip.has("vs")) {
                    next();
                    return;
                }

                const child = spawn("cmd.exe", ["/c", options.make, "-g"], {
                    stdio: [0, "pipe", "pipe"]
                });

                child.stdout.on("data", chunk => {
                    process.stdout.write(chunk);
                });

                child.stderr.on("data", chunk => {
                    process.stderr.write(chunk);
                });

                child.on("close", code => {
                    if (code !== 0) {
                        console.log(`build exited with code ${ code }`);
                        process.exit(code);
                    }
                    next();
                });
            }
        ], cb);
    }

    add_class(decl) {
        const [name, base, list_of_modifiers, properties] = decl;
        const path = name.slice(name.indexOf(" ") + 1).split(".");
        const fqn = path.join("::");

        const coclass = this.getCoClass(fqn);

        coclass.is_class = name.startsWith("class ");
        coclass.is_struct = name.startsWith("struct ");
        coclass.is_simple = list_of_modifiers.includes("/Simple");
        coclass.is_map = list_of_modifiers.includes("/Map");
        coclass.is_external = list_of_modifiers.includes("/External");
        coclass.is_cexternal = list_of_modifiers.includes("/CExternal");
        coclass.is_rexternal = list_of_modifiers.includes("/RExternal");
        if (list_of_modifiers.includes("/Ptr")) {
            coclass.is_ptr = true;
        }

        if ((coclass.is_map || coclass.is_struct && coclass.is_simple || list_of_modifiers.includes("/DC")) && !coclass.has_default_constructor) {
            coclass.has_default_constructor = 0;
        }

        coclass.noidl = list_of_modifiers.includes("/noidl");

        for (const modifier of list_of_modifiers) {
            if (modifier.startsWith("/idl=")) {
                coclass.idl = modifier.slice("/idl=".length);
            } else if (modifier.startsWith("/cpp_quote=")) {
                coclass.cpp_quotes.push(modifier.slice("/cpp_quote=".length));
            } else if (modifier.startsWith("/interface=")) {
                coclass.interface = modifier.slice("/interface=".length);
            }
        }

        for (const property of properties) {
            coclass.addProperty(property);
        }

        const parents = base ? base.slice(": ".length).split(", ") : [];

        this.bases.set(fqn, new Set());

        for (const parent of parents) {
            if (parent === fqn || parent === "") {
                continue;
            }

            coclass.addParent(parent);

            this.bases.get(fqn).add(parent);

            if (!this.derives.has(parent)) {
                this.derives.set(parent, new Set());
            }

            this.derives.get(parent).add(fqn);
        }
    }

    add_enum(decl) {
        const [name, , , enums] = decl;

        let start = 0;

        while (true) { // eslint-disable-line no-constant-condition
            if (name.startsWith("enum ", start)) {
                start += "enum ".length;
                continue;
            }

            if (name.startsWith("struct ", start)) {
                start += "struct ".length;
                continue;
            }

            if (name.startsWith("class ", start)) {
                start += "class ".length;
                continue;
            }

            break;
        }

        const path = name.slice(start).split(".");
        const fqn = path.join("::");

        if (this.enums.has(fqn)) {
            this.enums.get(fqn)[3].push(...enums);
        } else {
            this.enums.set(fqn, decl);
        }

        this.getCoClass(path.slice(0, -1).join("::")).addEnum(fqn);

        for (const edecl of enums) {
            const [ename] = edecl;
            if (!ename.startsWith("const ")) {
                throw new Error(`enum ${ ename } is not supported`);
            }

            const epath = ename.slice("const ".length).split(".");

            // known invalid enum
            if (epath.join("::") === "cv::detail::ArgKind::OPAQUE") {
                continue;
            }

            if (this.options.noEnumExport) {
                continue;
            }

            // Make enumerations available via a COM property.
            // Because com properties and methods are case insensitive,
            // an enum name cannot be the same as a property or a method.
            // To workaround this limitation, an underscore is added a the end of the enum name.
            // More over, office vba does not allow names to start with an underscore.
            // Therefore, putting the underscore at the end is also to workaround this limitation
            // For exemple, cv::FileNode as a method 'real' and an enum 'REAL'
            // The enum will be named REAL_
            //
            // Sources:
            // https://docs.microsoft.com/en-us/windows/win32/com/com-technical-overview
            // https://docs.microsoft.com/it-ch/office/vba/language/reference/user-interface-help/bad-interface-for-implements-method-has-underscore-in-name
            const basename = epath[epath.length - 1];
            const coclass = this.getCoClass(epath.slice(0, -1).join("::"));
            coclass.addProperty(["int", `${ basename }_`, `static_cast<int>(${ epath.join("::") })`, ["/R", "/S", "/Enum", `=${ basename }`]]);
        }
    }

    add_custom_type(fqn, parent, options = {}) {
        const objectName = CoClass.getObjectName(fqn);

        if (this.classes.has(objectName)) {
            return this.classes.get(objectName);
        }

        const coclass = this.getCoClass(objectName);
        coclass.is_simple = true;
        coclass.is_class = true;

        const cpptype = this.getCppType(fqn, parent, options);
        this.typedefs.set(coclass.fqn, cpptype);

        return coclass;
    }

    add_map(type, parent, options = {}) {
        return map_conversion.declare(this, type, parent, options);
    }

    add_vector(type, parent, options = {}) {
        return vector_conversion.declare(this, type, parent, options);
    }

    add_func(decl) {
        const [name, , list_of_modifiers, properties] = decl;
        const path = name.split(".");
        const coclass = this.getCoClass(path.slice(0, -1).join("::"));
        if (list_of_modifiers.includes("/Properties")) {
            for (const property of properties) {
                coclass.addProperty(property);
            }
        } else {
            coclass.addMethod(decl);
        }
    }

    getCoClass(fqn) {
        if (this.classes.has(fqn)) {
            return this.classes.get(fqn);
        }

        const path = fqn.split("::");
        let coclass = null;

        for (let i = 0; i < path.length; i++) {
            const prefix = path.slice(0, i + 1).join("::");

            if (!this.classes.has(prefix)) {
                this.classes.set(prefix, new CoClass(prefix));

                if (typeof this.options.progid === "function") {
                    const progid = this.options.progid(this.classes.get(prefix).progid);
                    if (progid) {
                        this.classes.get(prefix).progid = progid;
                    }
                }

                for (let j = i; j >= 0; j--) {
                    const namespace = path.slice(0, j + 1).join("::");
                    if (this.namespaces.has(namespace)) {
                        this.classes.get(prefix).namespace = namespace;
                        break;
                    }
                }

                if (coclass !== null) {
                    // coclass.addProperty([prefix, path[i], "", ["/R"]]);
                }
            }

            coclass = this.classes.get(prefix);
        }

        return coclass;
    }

    getIDLType(type, coclass, options = {}) {
        const shared_ptr = removeNamespaces(options.shared_ptr, options);
        type = PropertyDeclaration.restoreOriginalType(removeNamespaces(type, options), options);

        if (type === "IUnknown*" || type === "IEnumVARIANT*" || type === "VARIANT*" || type === "VARIANT") {
            return type;
        }

        if (type.startsWith(`${ shared_ptr }<`) && type.endsWith(">")) {
            // Add dependency
            this.getIDLType(type.slice(`${ shared_ptr }<`.length, -">".length), coclass, options);
            return "VARIANT";
        }

        if (type.startsWith("vector<")) {
            // Add dependency
            this.getIDLType(type.slice("vector<".length, -">".length), coclass, options);
            this.addDependency(coclass.fqn, this.add_vector(type, coclass, options));
            return "VARIANT";
        }

        if (type.startsWith("tuple<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("tuple<".length, -">".length));
            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }
            return "VARIANT";
        }

        if (type.startsWith("map<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("map<".length, -">".length));

            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }

            this.addDependency(coclass.fqn, this.add_map(type, coclass, options));
            return "VARIANT";
        }

        if (type.startsWith("pair<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("pair<".length, -">".length));
            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }
            return "VARIANT";
        }

        if (type === "_variant_t" || type.startsWith("VectorOf")) {
            return "VARIANT";
        }

        if (type.startsWith("GArray<") || type.startsWith("GOpaque<")) {
            const custom_type = this.add_custom_type(type, coclass, options);
            this.addDependency(coclass.fqn, custom_type.fqn);
            const pos = type.indexOf("<");

            // Add dependency
            this.getIDLType(type.slice(pos + 1, -">".length), coclass, options);
            return custom_type.getIDLType();
        }

        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        for (const fqn of this.getTypes(type, include)) {
            if (this.enums.has(fqn)) {
                const pos = fqn.lastIndexOf("::");
                this.addDependency(coclass.fqn, fqn.slice(0, pos));
                this.addDependency(include.fqn, fqn.slice(0, pos));
                return "LONG";
            }

            if (PTR.has(fqn) || options.variantTypeReg && options.variantTypeReg.test(fqn)) {
                return "VARIANT";
            }

            if (IDL_TYPES.has(fqn)) {
                return IDL_TYPES.get(fqn);
            }

            if (this.classes.has(fqn)) {
                this.addDependency(coclass.fqn, fqn);
                this.addDependency(include.fqn, fqn);
                return this.classes.get(fqn).getIDLType();
            }
        }

        if (type.endsWith("*")) {
            return this.getIDLType(type.slice(0, -1), coclass, options);
        }

        return type.toUpperCase();
    }

    getCppType(type, coclass, options = {}) {
        const {shared_ptr} = options;
        const shared_ptr_ = removeNamespaces(shared_ptr, options);

        const type_ = type;
        type = PropertyDeclaration.restoreOriginalType(removeNamespaces(type, options), options);

        if (type === "IUnknown*" || type === "IEnumVARIANT*" || type === "VARIANT*" || type === "VARIANT" || type === "_variant_t") {
            return type;
        }

        if (type.startsWith(`${ shared_ptr_ }<`) && type.endsWith(">")) {
            return `${ shared_ptr }<${ this.getCppType(type.slice(`${ shared_ptr_ }<`.length, -">".length), coclass, options) }>`;
        }

        if (type.startsWith("vector<")) {
            return `std::vector<${ this.getCppType(type.slice("vector<".length, -">".length), coclass, options) }>`;
        }

        if (type.startsWith("tuple<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("tuple<".length, -">".length));
            return `std::tuple<${ types.map(itype => this.getCppType(itype, coclass, options)).join(", ") }>`;
        }

        if (type.startsWith("map<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("map<".length, -">".length));
            return `std::map<${ types.map(itype => this.getCppType(itype, coclass, options)).join(", ") }>`;
        }

        if (type.startsWith("pair<")) {
            const types = PropertyDeclaration.getTupleTypes(type.slice("pair<".length, -">".length));
            return `std::pair<${ types.map(itype => this.getCppType(itype, coclass, options)).join(", ") }>`;
        }

        if (type.startsWith("GArray<") || type.startsWith("GOpaque<")) {
            const pos = type.indexOf("<");
            return `cv::${ type.slice(0, pos) }<${ this.getCppType(type.slice(pos + 1, -">".length), coclass, options) }>`;
        }

        if (type.endsWith("*")) {
            return `${ this.getCppType(type.slice(0, -1), coclass, options) }*`;
        }

        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        for (const fqn of this.getTypes(type, include)) {
            if (this.enums.has(fqn)) {
                return "int";
            }

            if (options.variantTypeReg && options.variantTypeReg.test(fqn)) {
                return fqn;
            }

            if (CPP_TYPES.has(fqn)) {
                return CPP_TYPES.get(fqn);
            }

            if (this.classes.has(fqn)) {
                return fqn;
            }
        }

        return options.implicitNamespaceType && options.implicitNamespaceType.test(type) ? `${ this.namespace }::${ type }` : type_;
    }

    castAsEnumIfNeeded(type, value, coclass) {
        for (const fqn of this.getTypes(type, coclass)) {
            if (this.enums.has(fqn)) {
                return `static_cast<${ fqn }>(${ value })`;
            }
        }

        return value;
    }

    castFromEnumIfNeeded(type, value, coclass) {
        if (this.getTypes(type, coclass).some(fqn => this.enums.has(fqn))) {
            return `static_cast<int>(${ value })`;
        }

        return value;
    }

    setReturn(returns, idltype, argname) {
        if (returns.length === 0) {
            returns.push(idltype, argname);
            return;
        }

        if (returns[0] === idltype) {
            return;
        }

        if (returns[0][0] === "I" && idltype[0] === "I") {
            returns[0] = "IDispatch*";
            return;
        }

        returns[0] = "VARIANT";
    }

    addDependency(dependent, dependency) {
        if (dependent === dependency || !dependency || !dependent) {
            return;
        }

        if (!this.dependents.has(dependency)) {
            this.dependents.set(dependency, new Set());
        }

        if (!this.dependencies.has(dependent)) {
            this.dependencies.set(dependent, new Set());
        }

        this.dependents.get(dependency).add(dependent);
        this.dependencies.get(dependent).add(dependency);
    }

    getSignatures(coclass, options) {
        const signatures = new Set();

        for (const fname of coclass.methods.keys()) {
            const overrides = coclass.methods.get(fname);

            for (const decl of overrides) {
                const signature = this.getSignature(coclass, fname, decl, options);

                if (signatures.has(signature)) {
                    // console.log("duplicated", signature);
                }

                signatures.add(signature);
            }
        }

        return signatures;
    }

    getSignature(coclass, fname, decl, options) {
        const [, , , list_of_arguments] = decl;
        const signature = [fname];

        for (const [argtype] of list_of_arguments) {
            signature.push(this.getCppType(argtype, coclass, options));
        }

        return signature.join(", ");
    }

    getTypes(type, coclass) {
        const types = new Set([type, `${ this.namespace }::${ type }`]);

        if (coclass.fqn) {
            coclass.fqn.split("::").forEach((el, i, arr) => {
                types.add(`${ arr.slice(0, arr.length - i).join("::") }::${ type }`);
            });
        }

        if (coclass.namespace) {
            types.add(`${ coclass.namespace }::${ type }`);
        }

        for (const namespace of this.namespaces) {
            const itype = `${ namespace }::${ type }`;
            if (this.classes.has(itype)) {
                types.add(itype);
            }
        }

        return Array.from(types);
    }

    getOrderedDependencies(dependencies = null) {
        const _dependencies = new Map(this.dependencies);
        const _dependents = new Map(this.dependents);

        if (dependencies !== null) {
            for (const fqn of _dependencies.keys()) {
                if (!dependencies.has(fqn)) {
                    _dependencies.delete(fqn);
                    continue;
                }

                const newvalues = new Set();
                _dependencies.set(fqn, newvalues);

                for (const dep of _dependencies.get(fqn)) {
                    if (dependencies.has(dep)) {
                        newvalues.add(dep);
                    }
                }
            }

            for (const fqn of _dependents.keys()) {
                if (!dependencies.has(fqn)) {
                    _dependents.delete(fqn);
                    continue;
                }

                const newvalues = new Set();
                _dependents.set(fqn, newvalues);

                for (const dep of _dependents.get(fqn)) {
                    if (dependencies.has(dep)) {
                        newvalues.add(dep);
                    }
                }
            }

            for (const fqn of dependencies) {
                if (!_dependencies.has(fqn)) {
                    _dependencies.set(fqn, new Set());
                }
            }
        } else {
            for (const fqn of this.classes.keys()) {
                if (!_dependencies.has(fqn)) {
                    _dependencies.set(fqn, new Set());
                }
            }
        }

        const ordered = orderDependencies(_dependencies, _dependents);

        const result = [];

        for (const fqn of ordered) {
            if (dependencies !== null) {
                result.push(this.classes.get(fqn));
            } else if (!this.classes.get(fqn).noidl) {
                result.push(this.classes.get(fqn).iface);
            }
        }

        return result;
    }
}

module.exports = AutoItGenerator;
