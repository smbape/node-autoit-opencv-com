/* eslint-disable no-magic-numbers */
const version = process.env.npm_package_version || require("../package.json").version;
const fs = require("node:fs");
const sysPath = require("node:path");
const waterfall = require("async/waterfall");
const { convertExpression } = require("node-autoit-binding-utils/src/autoit-expression-converter");

const [VERSION_MAJOR, VERSION_MINOR] = version.split(".");

const LF = "\n";

const knwon_ids = require("./ids");
const conversion = require("./conversion");
const custom_conversions = require("./custom_conversions");
const FunctionDeclaration = require("./FunctionDeclaration");
const PropertyDeclaration = require("./PropertyDeclaration");
const FileUtils = require("./FileUtils");
const CoClass = require("./CoClass");
const { getAlias } = require("./alias");
const map_conversion = require("./map_conversion");
const vector_conversion = require("./vector_conversion");

const {
    IDL_TYPES,
    CPP_TYPES,
    PTR,
    ARRAY_CLASSES,
    ARRAYS_CLASSES,
    TEMPLATED_TYPES,
} = require("./constants");

const countInstances = (str, searchString) => {
   return str.split(searchString).length - 1;
};

const escapeHTML = str => {
    return str
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll("\"", "&quot;")
        .replaceAll("'", "&#039;");
};

const proto = {
    getIDLType(type, coclass, options = {}) {
        if (type.includes("(") || type.includes(")") || type.includes("<") && !type.endsWith(">") || countInstances(type, "<") !== countInstances(type, ">")) {
            // invalid type, most likely comming from defval
            return type;
        }

        type = getAlias(type);

        if (!IDL_TYPES.has(type) && CPP_TYPES.has(type)) {
            type = CPP_TYPES.get(type);
        }

        const type_ = type;
        type = CoClass.restoreOriginalType(type, options);

        if (type === "IUnknown*" || type === "IEnumVARIANT*" || type === "IDispatch*" || type === "VARIANT*" || type === "VARIANT") {
            return type;
        }

        if (type.startsWith(`${ options.shared_ptr }<`)) {
            // Add dependency
            this.getIDLType(type.slice(`${ options.shared_ptr }<`.length, -">".length), coclass, options);
            return "VARIANT";
        }

        if (type.startsWith("std::optional<")) {
            // Add dependency
            this.getIDLType(type.slice("std::optional<".length, -">".length), coclass, options);
            return "VARIANT";
        }

        if (type.startsWith("std::vector<")) {
            // Add dependency
            this.getIDLType(type.slice("std::vector<".length, -">".length), coclass, options);
            this.addDependency(coclass.fqn, this.add_vector(type, coclass, options));
            return "VARIANT";
        }

        if (type.startsWith("std::tuple<")) {
            const types = CoClass.getTupleTypes(type.slice("std::tuple<".length, -">".length));
            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }
            return "VARIANT";
        }

        if (type.startsWith("std::map<")) {
            const types = CoClass.getTupleTypes(type.slice("std::map<".length, -">".length));

            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }

            this.addDependency(coclass.fqn, this.add_map(type, coclass, options));
            return "VARIANT";
        }

        if (type.startsWith("std::pair<")) {
            const types = CoClass.getTupleTypes(type.slice("std::pair<".length, -">".length));
            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass, options);
            }
            return "VARIANT";
        }

        if (type === "_variant_t" || type.startsWith("VectorOf")) {
            return "VARIANT";
        }

        if (type.includes("<") && type.endsWith(">")) {
            const pos = type.indexOf("<");
            const tpl = this.getCppType(type.slice(0, pos), coclass, options);
            const types = CoClass.getTupleTypes(type.slice(pos + 1, -">".length)).map(itype => this.getCppType(itype, coclass, options));

            if (TEMPLATED_TYPES.has(tpl)) {
                const custom_type = this.add_custom_type(`${ tpl }<${ types.join(", ") }>`, coclass, options);
                this.addDependency(coclass.fqn, custom_type.fqn);

                // Add dependency
                for (const itype of types) {
                    this.getIDLType(itype, coclass, options);
                }

                return custom_type.getIDLType();
            }
        }

        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        for (const fqn of this.getMaybeTypes(type_, include)) {
            if (this.enums.has(fqn)) {
                const pos = fqn.lastIndexOf("::");

                const enum_class = this.classes.has(fqn) ? this.classes.get(fqn) : this.classes.get(fqn.slice(0, pos));
                this.addDependency(coclass.fqn, enum_class.fqn);
                this.addDependency(include.fqn, enum_class.fqn);

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
    },

    makeDependent(type, coclass, options) {
        let pos = type.length;

        while (pos >= 0 && type[pos - 1] === "*") {
            pos--;
        }

        if (pos !== -1 && pos !== type.length) {
            type = type.slice(0, pos);
        }

        this.getIDLType(type, coclass, options);
        this.getCppType(type, coclass, options);
    },

    preprocess(config, options) {
        const {key_type, value_type} = this.classes.get(this.add_map("std::map<string, _variant_t>", {}, options));
        const coclass = this.classes.get("NamedParameters");
        const {fqn} = coclass;

        // allow NamedParameters simple creation
        coclass.is_simple = true;
        coclass.is_class = true;
        coclass.is_stdmap = true;
        coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [], "", ""], options);

        coclass.addMethod([`${ fqn }.create`, `${ options.shared_ptr }<${ coclass.name }>`, ["/External", "/S"], [
            [`std::vector<std::pair<${ key_type }, ${ value_type }>>`, "pairs", "", []],
        ], "", ""], options);

        // make NamedParameters to be recognized as a collection
        coclass.key_type = key_type;
        coclass.value_type = value_type;
        this.as_stl_enum(coclass, `std::pair<const ${ key_type }, ${ value_type }>`, options);

        this.namedParameters = coclass;
    },

    add_map(type, parent, options = {}) {
        return map_conversion.declare(this, type, parent, options);
    },

    add_vector(type, parent, options = {}) {
        return vector_conversion.declare(this, type, parent, options);
    },

};

class COMGenerator {
    static proto = proto;

    generate(processor, configuration, options, cb) {
        const { generated_include } = configuration;
        const { APP_NAME, LIB_UID, LIBRARY, shared_ptr } = options;

        const files = new Map();
        const libs = [];
        const resources = [];

        for (const fqn of processor.classes.keys()) {
            const coclass = processor.classes.get(fqn);

            const docid = processor.docs.length;

            const is_test = options.test && !options.notest.has(fqn);

            const cotype = coclass.getClassName();
            const is_idl_class = !coclass.noidl && (coclass.is_class || coclass.is_struct);

            const iidl = [];
            const iprivate = [];
            const ipublic = [];
            const iglobal = [];
            const impl = [];

            const constructor = [];
            const destructor = [];

            if (is_idl_class) {
                constructor.push(`__self = new ${ shared_ptr }<${ coclass.fqn }>();`);

                if (coclass.has_default_constructor) {
                    constructor.push(`__self->reset(new ${ coclass.fqn }());`);
                }

                destructor.push("delete __self;");
                destructor.push("__self = nullptr;");

                coclass.addIDLName("self", "get_self");
                coclass.addIDLName("self", "put_self");
                const id = coclass.getIDLNameId("self");

                iidl.push(`[id(${ id }), propget] HRESULT self([out, retval] VARIANT* pVal);`);
                iidl.push(`[id(${ id }), propput] HRESULT self([in] ULONGLONG ptr);`);
                ipublic.push("STDMETHOD(get_self)(VARIANT* pVal);");
                ipublic.push("STDMETHOD(put_self)(ULONGLONG ptr);");
                impl.push(`
                    STDMETHODIMP C${ cotype }::get_self(VARIANT* pVal) {
                        if (__self) {
                            V_VT(pVal) = VT_UI8;
                            V_UI8(pVal) = reinterpret_cast<ULONGLONG>(__self->get());
                            return S_OK;
                        }
                        return E_FAIL;
                    }

                    STDMETHODIMP C${ cotype }::put_self(ULONGLONG ptr) {
                        if (__self) {
                            if (ptr > 0) {
                                *__self = ::autoit::reference_internal(reinterpret_cast<${ coclass.fqn }*>(ptr));
                            } else {
                                __self->reset();
                            }
                            return S_OK;
                        }
                        return E_FAIL;
                    }`.replace(/^ {20}/mg, "")
                );
            }

            const has_disid_val = Array.from(coclass.properties.keys()).some(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                for (const modifier of modifiers) {
                    if (modifier.startsWith("/id=") && modifier.slice("/id=".length) === "DISPID_VALUE") {
                        return true;
                    }
                }
                return false;
            }) || Array.from(coclass.methods.keys()).some(fname => {
                const overrides = coclass.methods.get(fname);
                for (const decl of overrides) {
                    const [, , func_modifiers] = decl;
                    for (const modifier of func_modifiers) {
                        if (modifier.startsWith("/id=") && modifier.slice("/id=".length) === "DISPID_VALUE") {
                            return true;
                        }
                    }
                }
                return false;
            });

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return !modifiers.includes("/Enum");
            }).forEach(idlname => {
                PropertyDeclaration.writeProperty(processor, iidl, impl, ipublic, iprivate, fqn, idlname, is_test, options);
            });

            // methods
            for (let fname of Array.from(coclass.methods.keys()).sort((a, b) => {
                if (a === "create") {
                    return -1;
                }

                if (b === "create") {
                    return 1;
                }

                return a > b ? 1 : a < b ? -1 : 0;
            })) {
                const idlname = fname;
                const overrides = coclass.methods.get(fname);

                // set constructor as the default behaviour of the object
                if (fname === "create" && !has_disid_val && !coclass.methods.has("get_create")) {
                    let set_dispid_value = true;

                    for (const decl of overrides) {
                        if (!set_dispid_value) {
                            break;
                        }

                        const [, , func_modifiers] = decl;
                        for (const modifier of func_modifiers) {
                            if (!set_dispid_value) {
                                break;
                            }

                            if (modifier.startsWith("/attr=")) {
                                set_dispid_value = modifier.slice("/attr=".length) !== "propput";
                            } else if (modifier.startsWith("/id=")) {
                                set_dispid_value = modifier.slice("/id=".length) === "DISPID_VALUE";
                            } else if (modifier.startsWith("/idlname=")) {
                                set_dispid_value = modifier.slice("/idlname=".length) === "create";
                            } else if (modifier.startsWith("=")) {
                                set_dispid_value = modifier.slice("=".length) === "get_create";
                            }
                        }
                    }

                    if (set_dispid_value) {
                        fname = "get_create";

                        for (const decl of overrides) {
                            const [, , func_modifiers] = decl;
                            for (const modifier of ["/attr=propget", "=get_create", "/idlname=create", "/id=DISPID_VALUE"]) {
                                if (!func_modifiers.includes(modifier)) {
                                    func_modifiers.push(modifier);
                                }
                            }
                        }
                    }
                }

                FunctionDeclaration.declare(processor, coclass, overrides, fname, idlname, iidl, ipublic, impl, is_test, options);
            }

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return modifiers.includes("/Enum");
            }).forEach(idlname => {
                PropertyDeclaration.writeProperty(processor, iidl, impl, ipublic, iprivate, fqn, idlname, is_test, options);
            });

            if (is_idl_class) {
                const cpptype = processor.typedefs.has(fqn) ? processor.typedefs.get(fqn) : processor.getCppType(fqn, coclass, options);

                iglobal.push(`
                    template<>
                    struct TypeToImplType<${ cpptype }> {
                        using type = C${ cotype };
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
            conversion.convert(processor, coclass, iglobal, impl, options);

            if (coclass.generate) {
                coclass.generate(iglobal, iidl, impl, ipublic, iprivate, coclass.idlnames, is_test, options);
            }

            const hdr_id = `_${ coclass.getObjectName().toUpperCase() }_OBJECT_`;

            // sort iidl by id
            iidl.sort((a, b) => {
                a = CoClass.getDispId(a);
                b = CoClass.getDispId(b);
                return a - b;
            });

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
                filename: coclass.getIDLFileName(options),
                definition: options.idl !== false && !coclass.noidl ? definition : null,
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

                const dispimpl = coclass.dispimpl ? coclass.dispimpl : `I${ cotype }`;

                const bases = [
                    "public CComObjectRootEx<CComSingleThreadModel>",
                    `public CComCoClass<C${ cotype }, &CLSID_${ cotype }>`,
                    `public ATL::IDispatchImpl<
                        ${ dispimpl.split("\n").join(`\n${ " ".repeat(24) }`) },
                        &IID_I${ cotype },
                        &LIBID_${ LIBRARY },
                        /*wMajor =*/ ${ VERSION_MAJOR },
                        /*wMinor =*/ ${ VERSION_MINOR }
                    >`.replace(/^ {20}/mg, ""),
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
                        ${ bases.join(",\n").split("\n").join(`\n${ " ".repeat(24) }`) }
                    {
                    public:
                        C${ cotype }()
                        {
                        }
                        STDMETHOD(GetTypeInfo)(
                            UINT itinfo,
                            LCID lcid,
                            _Outptr_result_maybenull_ ITypeInfo** pptinfo)
                        {
                            CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);
                            return _tih.GetTypeInfo(itinfo, lcid, pptinfo);
                        }
                        STDMETHOD(GetIDsOfNames)(
                            _In_ REFIID riid,
                            _In_reads_(cNames) _Deref_pre_z_ LPOLESTR* rgszNames,
                            _In_range_(0,16384) UINT cNames,
                            LCID lcid,
                            _Out_ DISPID* rgdispid)
                        {
                            CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);
                            return _tih.GetIDsOfNames(riid, rgszNames, cNames, lcid, rgdispid);
                        }
                        STDMETHOD(Invoke)(
                            _In_ DISPID dispidMember,
                            _In_ REFIID riid,
                            _In_ LCID lcid,
                            _In_ WORD wFlags,
                            _In_ DISPPARAMS* pdispparams,
                            _Out_opt_ VARIANT* pvarResult,
                            _Out_opt_ EXCEPINFO* pexcepinfo,
                            _Out_opt_ UINT* puArgErr)
                        {
                            CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);
                            return _tih.Invoke((IDispatch*)this, dispidMember, riid, lcid, wFlags, pdispparams, pvarResult, pexcepinfo, puArgErr);
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

            if (docid !== processor.docs.length) {
                processor.docs.splice(docid, 0, `## ${ fqn.replaceAll("_", "\\_") }\n`);
            }
        }

        const rgs = [];
        const objects = [];
        const comClasses = [];
        const comInterfaceExternalProxyStubs = [];

        for (const fqn of processor.classes.keys()) {
            const coclass = processor.classes.get(fqn);
            const { iface } = coclass;
            const { cotype, hdr_id } = iface;
            const className = coclass.getClassName();
            const description = `${ processor.typedefs.has(fqn) ? processor.typedefs.get(fqn) : fqn } ${ coclass.is_class ? "class" : coclass.is_struct ? "struct" : "namespace" }`;

            objects.push(`#include "${ className }.h"`);

            if (options.rgs !== false && !coclass.noidl) {
                const progid = `${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR }`;
                const versionIndependentProgID = `${ APP_NAME }.${ coclass.progid }`;

                rgs.push(`IDR_${ cotype.toUpperCase().padEnd(44, " ") } REGISTRY    "${ cotype }.rgs"`);

                comClasses.push(`
                    <comClass
                        description="${ escapeHTML(description) }"
                        clsid="{${ coclass.clsid }}"
                        threadingModel="Apartment"
                        progid="${ progid }"
                        tlbid="{${ LIB_UID }}" >
                        <progid>${ versionIndependentProgID }</progid>
                    </comClass>
                `.replace(/^ {20}/mg, "").trim());

                comInterfaceExternalProxyStubs.push(`
                    <comInterfaceExternalProxyStub
                        name="I${ cotype }"
                        iid="{${ coclass.iid }}"
                        proxyStubClsid32="{00020424-0000-0000-C000-000000000046}"
                        baseInterface="{00000000-0000-0000-C000-000000000046}"
                        tlbid="{${ LIB_UID }}" />
                `.replace(/^ {20}/mg, "").trim());

                files.set(sysPath.join(options.output, `${ cotype }.rgs`), `
                    HKCR
                    {
                        ${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR } = s '${ description }'
                        {
                            CLSID = s '{${ coclass.clsid }}'
                        }
                        ${ APP_NAME }.${ coclass.progid } = s '${ description }'
                        {       
                            CurVer = s '${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR }'
                        }
                        NoRemove CLSID
                        {
                            ForceRemove {${ coclass.clsid }} = s '${ description }'
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

            if (processor.namedParameters && !coclass.is_vector && !coclass.is_stdmap && coclass !== processor.namedParameters) {
                processor.addDependency(fqn, processor.namedParameters.fqn);
            }

            const dependencies = processor.dependencies.has(fqn) ?
                processor.getOrderedDependencies(new Set(processor.dependencies.get(fqn).values()))
                : [];

            const idl_deps = dependencies.filter(dependency => !dependency.noidl).map(dependency => {
                const { filename, hdr_id: _hdr_id } = dependency.iface;
                return [
                    `#ifndef ${ _hdr_id }IDL_FILE_`,
                    `import "${ filename }";`,
                    `cpp_quote("#include \\"${ filename.replace(".idl", ".h") }\\"")`,
                    "#endif\n"
                ].join("\n");
            });

            if (dependencies.length !== 0) {
                idl_deps.unshift("");
                idl_deps.unshift(...dependencies.map(dependency => `interface I${ dependency.iface.cotype };`));
            }

            if (options.idl !== false && !coclass.noidl) {
                const content = `
                    // ${ fqn }
                    #ifndef ${ hdr_id }IDL_FILE_
                    #define ${ hdr_id }IDL_FILE_

                    #ifndef _OAI_IDL_
                    #define _OAI_IDL_
                    import "oaidl.idl";
                    import "ocidl.idl";
                    #endif

                    ${ idl_deps.join(`\n${ " ".repeat(20) }`).trim() }

                    ${ iface.definition.trim().split("\n").join(`\n${ " ".repeat(20) }`) }
                    #endif //  ${ hdr_id }IDL_FILE_
                `.replace(/^ {20}/mg, "");

                files.set(sysPath.join(options.output, `${ iface.filename }`), content.trim().replace(/[^\S\n]+$/mg, "") + LF);
            }

            const includes = dependencies.map(dependency => `#include "${ dependency.getClassName() }.h"`);

            if (options.hdr !== false) {
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

                    ${ iface.header.split("\n").join(`\n${ " ".repeat(20) }`).trim() }

                    ${ includes.join(`\n${ " ".repeat(20) }`) }
                    #endif // ${ hdr_id }
                `.replace(/^ {20}/mg, "").trim().replace(/[^\S\n]+$/mg, "") + LF);
            }

            if (!coclass.is_external && options.impl !== false) {
                files.set(sysPath.join(options.output, coclass.getCPPFileName(options)), [
                    `#include "${ className }.h"`,
                    "",
                    iface.impl,
                ].join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
            }
        }

        const _conversions = custom_conversions.map(fn => fn([], [], options));

        if (options.hdr !== false) {
            files.set(
                sysPath.join(options.output, "generated_include.h"),
                `#pragma once\n\n${ generated_include.join("\n").trim().replace(/[^\S\n]+$/mg, "") }${ LF }`
            );

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
                #include "autoit_bridge_common.h"

                #define _ATL_APARTMENT_THREADED

                #define _ATL_NO_AUTOMATIC_NAMESPACE

                #define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS  // certains constructeurs CString seront explicites


                #include <comsvcs.h>

                #define ATL_NO_ASSERT_ON_DESTROY_NONEXISTENT_WINDOW

                #include "resource.h"
                #include "${ LIBRARY }.h"
                #include "generated_include.h"

                ${ Array.from(processor.typedefs).map(([fqn, cpptype]) => {
                    const parts = fqn.split("::");
                    const last = parts.length - 1;
                    const begin = new Array(last);
                    const end = new Array(last);
                    for (let i = 0; i < last; i++) {
                        const indent = " ".repeat(4 * i);
                        begin[i] = `${ indent }namespace ${ parts[i] } {`;
                        end[last - 1 - i] = `${ indent }}`;
                    }

                    const name = parts[last];
                    const indent = " ".repeat(4 * (last));
                    return begin.concat(`${ indent }using ${ name } = ${ cpptype };`, end).join("\n");
                }).join("\n").split("\n").join(`\n${ " ".repeat(16) }`) }

                `.replace(/^ {16}/mg, ""),

                conversion.number.declare("char", "CHAR", options), "",
                conversion.number.declare("unsigned char", "BYTE", options), "",
                conversion.number.declare("short", "SHORT", options), "",
                conversion.number.declare("unsigned short", "USHORT", options), "",
                conversion.number.declare("int", "LONG", options), "",
                conversion.number.declare("unsigned int", "ULONG", options), "",
                conversion.number.declare("long", "LONG", options), "",
                conversion.number.declare("unsigned long", "ULONG", options), "",
                conversion.number.declare("float", "float", options), "",
                conversion.number.declare("double", "double", options), "",
                conversion.number.declare("int64_t", "LONGLONG", options), "",
                conversion.number.declare("size_t", "ULONGLONG", options), "",
            ];

            _conversions.forEach(([header]) => {
                const text = header.trim();
                if (text.length !== 0) {
                    bridge_header.push(text, "");
                }
            });

            bridge_header.push("");

            files.set(sysPath.join(options.output, "autoit_bridge_generated.h"), bridge_header.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

            const pch_header = [
                "#pragma once\n",
                "#include \"autoit_bridge.h\"\n",
            ];
            pch_header.push(...Array.from(processor.classes.entries()).map(([, coclass]) => {
                return `#include "${ coclass.getClassName() }.h"`;
            }).sort());

            files.set(sysPath.join(options.output, "autoit_bridge_generated_pch.h"), pch_header.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        const bridge_impl = [
            "#include \"autoit_bridge.h\"", "",
            conversion.number.define("char", "CHAR", options), "",
            conversion.number.define("unsigned char", "BYTE", options), "",
            conversion.number.define("short", "SHORT", options), "",
            conversion.number.define("unsigned short", "USHORT", options), "",
            conversion.number.define("int", "LONG", options), "",
            conversion.number.define("unsigned int", "ULONG", options), "",
            conversion.number.define("long", "LONG", options), "",
            conversion.number.define("unsigned long", "ULONG", options), "",
            conversion.number.define("float", "float", options), "",
            conversion.number.define("double", "double", options), "",
            conversion.number.define("int64_t", "LONGLONG", options), "",
            conversion.number.define("size_t", "ULONGLONG", options), "",
            ""
        ];

        _conversions.forEach(([, impl]) => {
            const text = impl.trim();
            if (text.length !== 0) {
                bridge_impl.push(text, "");
            }
        });

        bridge_impl.push("");

        files.set(sysPath.join(options.output, "autoit_bridge_generated.cpp"), bridge_impl.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

        if (options.rgs !== false) {
            files.set(sysPath.join(options.output, "registries.rgs"), rgs.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        if (options.manifest !== false) {
            const {OUTPUT_NAME, OUTPUT_DIRECTORY_DEBUG, OUTPUT_DIRECTORY_RELEASE} = options;
            files.set(sysPath.join(OUTPUT_DIRECTORY_DEBUG, `${ OUTPUT_NAME }d.sxs.manifest`), this.genManifest(comClasses, comInterfaceExternalProxyStubs, "d", options));
            files.set(sysPath.join(OUTPUT_DIRECTORY_RELEASE, `${ OUTPUT_NAME }.sxs.manifest`), this.genManifest(comClasses, comInterfaceExternalProxyStubs, "", options));
        }

        for (const fqn of Object.keys(knwon_ids)) {
            if (!processor.classes.has(fqn) || processor.classes.get(fqn).noidl) {
                delete knwon_ids[fqn];
            }
        }
        files.set(sysPath.join(__dirname, "ids.json"), JSON.stringify(knwon_ids, null, 4));

        const ifaces = processor.getOrderedDependencies();

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
                #define IDR_${ processor.namespace.toUpperCase() }                          101
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
        const constReplacer = options.constReplacer || new Map();

        const getPrefixVariableName = prefix => {
            prefix = prefix.replaceAll(".", "_").replace(/[a-z][A-Z]/g, match => `${ match[0] }_${ match[1] }`).toUpperCase();
            return (options.global_prefix ? options.global_prefix : "") + prefix;
        };

        const etext = Array.from(processor.enums.keys()).map(ename => {
            const [, , , enums] = processor.enums.get(ename);
            const path = ename.split("::");

            const values = new Map(enums.map(([name, value]) => [name.slice("const ".length), value]));

            const expansionRe = new RegExp(`\\b(?:${ Array.from(values).map(([name, value]) => name.split(".").pop()).join("|") })\\b`, "g");

            const getVariableName = (prefix, vname) => {
                return values.has(`${ prefix }.${ vname }`) ? `$${ getPrefixVariableName(prefix) }_${ vname }` : vname;
            };

            ename = path[path.length - 1];

            return `; ${ path.slice(0, -1).join("::") }::${ ename === "<unnamed>" ? "anonymous" : ename }\n${ Array.from(values).map(([name, value]) => {
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

        files.set(sysPath.resolve(options.output, "..", "udf", `${ processor.namespace }_enums.au3`), `${ `
            #include-once
            #include "${ processor.namespace }_interface.au3"

            ${ etext.split("\n").join(`\n${ " ".repeat(12) }`) }
        `.replace(/^ {12}/mg, "").trim() }\n`);

        const docs = sysPath.resolve(options.output, "..", "udf", "docs.md");

        if (options.toc !== false) {
            processor.docs.unshift("");

            try {
                fs.accessSync(docs, fs.constants.R_OK);
                const content = fs.readFileSync(docs).toString();
                const start = content.indexOf("<!-- START doctoc ");
                const endpos = content.indexOf("<!-- END doctoc ", start + 1);
                const prev_doctoc = content.slice(start, content.indexOf(" -->", endpos + 1) + " -->".length);
                processor.docs.unshift(prev_doctoc);
            } catch (err) {
                processor.docs.unshift("<!-- END doctoc -->");
                processor.docs.unshift("<!-- START doctoc -->");
            }

            processor.docs.unshift("");
            processor.docs.unshift("## Table Of Contents");
        }

        processor.docs.unshift("");
        processor.docs.unshift(`
            # AutoIt ${ options.APP_NAME } UDF
        `.replace(/^ {12}/mg, "").trim());

        files.set(docs, processor.docs.join("\n"));

        waterfall([
            next => {
                FileUtils.writeFiles(files, options, next);
            },

            next => {
                FileUtils.deleteFiles(options.output, files, options, next);
            },
        ], cb);
    }

    genManifest(comClasses, comInterfaceExternalProxyStubs, debugPostFix, options) {
        const { LIB_UID, OUTPUT_NAME, updateAssembly } = options;

        const assemblies = [`
            <assemblyIdentity
                type="win32"
                name="${ OUTPUT_NAME }${ debugPostFix }.sxs"
                version="${ version }.0" />
        `.replace(/^ {12}/mg, "").trim()];

        if (typeof updateAssembly === "function") {
            updateAssembly(assemblies, debugPostFix, options);
        }

        return `
            <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
            <assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
                ${ assemblies.join("\n").split("\n").join(`\n${ " ".repeat(16) }`) }

                <file xmlns="urn:schemas-microsoft-com:asm.v1" name="${ OUTPUT_NAME }${ debugPostFix }.dll">
                    ${ comClasses.map(comClass => comClass.split("\n").join(`\n${ " ".repeat(20) }`)).join(`\n\n${ " ".repeat(20) }`) }

                    <typelib tlbid="{${ LIB_UID }}"
                        version="${ VERSION_MAJOR }.${ VERSION_MINOR }"
                        helpdir="." />
                </file>

                ${ comInterfaceExternalProxyStubs.map(comClass => comClass.split("\n").join(`\n${ " ".repeat(16) }`)).join(`\n\n${ " ".repeat(16) }`) }
            </assembly>
        `.replace(/^ {12}/mg, "").trim();
    }
}

module.exports = COMGenerator;
