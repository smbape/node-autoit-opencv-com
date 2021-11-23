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

const LIB_UID = "fc210206-673e-4ec8-82d5-1a6ac561f3de";
const APP_NAME = "OpenCV";
const [VERSION_MAJOR, VERSION_MINOR] = version.split(".");

const LF = "\n";

const knwon_ids = require("./ids");
const conversion = require("./conversion");
const point_conversion = require("./point_conversion")();
const rect_conversion = require("./rect_conversion")();
const size_conversion = require("./size_conversion")();
const vec_conversion = require("./vec_conversion")();

const {
    SIMPLE_ARGTYPE_DEFAULTS,
    IDL_TYPES,
    CPP_TYPES,
    IGNORED_CLASSES,
    ARRAY_CLASSES,
    ARRAYS_CLASSES,
} = require("./constants");

const CoClass = require("./CoClass");

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

        this.namespace = "cv";
    }

    generate({decls, namespaces, generated_include}, options = {}, cb = undefined) {
        this.namespaces = new Set();

        if (options.namespace) {
            this.namespace = options.namespace;
        }

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

        for (const fqn of IGNORED_CLASSES) {
            if (this.classes.has(fqn)) {
                this.classes.delete(fqn);
            }
        }

        const files = new Map();
        const libs = [];
        const resources = [];
        const manifest = {
            files: [],
            proxies: [],
        };

        for (const fqn of this.classes.keys()) {
            const is_test = options.test && !options.notest.has(fqn);

            const coclass = this.classes.get(fqn);
            const cotype = coclass.getClassName();
            const is_idl_class = !coclass.noidl && (coclass.is_class || coclass.is_struct);

            const signatures = this.getSignatures(coclass);

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

                        const signature = this.getSignature(coclass, fname, decl);

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
                constructor.push(`this->__self = new cv::Ptr<${ coclass.fqn }>();`);

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
                            this->__self->reset(reinterpret_cast<${ coclass.fqn }*>(ptr));
                            return S_OK;
                        }
                        return E_FAIL;
                    }`.replace(/^ {20}/mg, "")
                );
            }

            const writeProperty = idlname => {
                if (idnames.has(idlname.toLowerCase())) {
                    throw new Error(`duplicated idl name ${ fqn }::${ idlname }`);
                }
                idnames.add(idlname.toLowerCase());

                id++;

                const is_prop_test = is_test && !options.notest.has(`${ fqn }::${ idlname }`);

                const {type, modifiers} = coclass.properties.get(idlname);
                const propidltype = this.getIDLType(type, coclass);
                const is_static = !coclass.is_class && !coclass.is_struct || modifiers.includes("/S");
                const is_enum = modifiers.includes("/Enum");
                const is_external = modifiers.includes("/External");

                let propname = idlname;
                for (const modifier of modifiers) {
                    if (modifier[0] === "=") {
                        propname = modifier.slice(1);
                    }
                }

                const propval = `${ is_static ? `${ fqn }::` : "this->__self->get()->" }${ propname }`;

                if (is_static || is_enum || modifiers.includes("/R") || modifiers.includes("/RW")) {
                    iidl.push(`[propget, id(${ id })] HRESULT ${ idlname }([out, retval] ${ propidltype }* pVal);`);
                    ipublic.push(`STDMETHOD(get_${ idlname })(${ propidltype }* pVal);`);

                    if (is_enum) {
                        impl.push(`
                            STDMETHODIMP C${ cotype }::get_${ idlname }(${ propidltype }* pVal) {
                                *pVal = static_cast<LONG>(${ `${ fqn }::${ propname }` });
                                return S_OK;
                            }`.replace(/^ {28}/mg, "")
                        );
                    } else {
                        const cvt = this.convertToIdl(
                            type, propval,
                            propidltype, "pVal",
                            modifiers
                        );

                        impl.push(`
                            STDMETHODIMP C${ cotype }::get_${ idlname }(${ propidltype }* pVal) {
                                ${ is_prop_test ? "return S_OK; /* " : "" }${ cvt.split("\n").join(`\n${ " ".repeat(32) }`) }${ is_prop_test ? " */" : "" }
                            }`.replace(/^ {28}/mg, "")
                        );
                    }

                    // implementation of external is in another file
                    if (is_external) {
                        impl.pop();
                    }
                }

                if (modifiers.includes("/W") || modifiers.includes("/RW")) {
                    const idltype = propidltype === "VARIANT" ? "VARIANT*" : propidltype;

                    iidl.push(`[propput, id(${ id })] HRESULT ${ idlname }([in] ${ idltype } newVal);`);
                    ipublic.push(`STDMETHOD(put_${ idlname })(${ idltype } newVal);`);

                    const cvt = this.convertFromIdl(idltype, "newVal", type, propval);
                    impl.push(`
                        STDMETHODIMP C${ cotype }::put_${ idlname }(${ idltype } newVal) {
                            ${ is_prop_test ? "return S_OK; /* " : "" }${ cvt.split("\n").join(`\n${ " ".repeat(28) }`) }${ is_prop_test ? " */" : "" }
                        }`.replace(/^ {24}/mg, "")
                    );

                    // implementation of external is in another file
                    if (is_external) {
                        impl.pop();
                    }
                }
            };

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return !modifiers.includes("/Enum");
            }).forEach(writeProperty);

            const varprefix = "pVarArg";
            const include = coclass.include ? coclass.include : coclass;

            // methods
            for (const fname of coclass.methods.keys()) {
                if (idnames.has(fname.toLowerCase())) {
                    throw new Error(`duplicated idl name ${ fqn }::${ fname }`);
                }
                idnames.add(fname.toLowerCase());

                id++;

                const is_method_test = is_test && !options.notest.has(`${ fqn }::${ fname }`);
                const overrides = coclass.methods.get(fname);
                const has_override = overrides.length !== 1;

                let maxargc = 0;
                let minopt = Number.POSITIVE_INFINITY;
                const bodies = [];
                const indent = " ".repeat(has_override ? 4 : 0);
                const parameterNames = [];

                for (const decl of overrides) {
                    const [, , , list_of_arguments] = decl;

                    const argc = list_of_arguments.length;

                    maxargc = Math.max(maxargc, argc);
                    minopt = Math.min(minopt, argc);

                    const declarations = new Array(argc);
                    const conditions = new Array(argc);
                    const conversions = new Array(argc);
                    const callargs = new Array(argc);
                    const outputs = new Map();
                    const retval = [];
                    const cindent = " ".repeat(4);

                    bodies.push({
                        decl,
                        declarations,
                        conditions,
                        conversions,
                        callargs,
                        outputs,
                        retval,
                    });

                    const in_args = new Array(argc).fill(false);
                    const out_args = new Array(argc).fill(false);

                    for (let j = 0; j < argc; j++) {
                        const [argtype, , defval, arg_modifiers] = list_of_arguments[j];
                        const is_ptr = argtype.endsWith("*");
                        const is_in_array = /^Input(?:Output)?Array(?:OfArrays)?$/.test(argtype);
                        const is_out_array = /^(?:Input)?OutputArray(?:OfArrays)?$/.test(argtype);
                        const is_in_out = arg_modifiers.includes("/IO");
                        in_args[j] = is_in_array || is_in_out || arg_modifiers.includes("/I");
                        out_args[j] = is_out_array || is_in_out || arg_modifiers.includes("/O") || is_ptr && defval === "" && SIMPLE_ARGTYPE_DEFAULTS.has(argtype.slice(0, -1));
                    }

                    const indexes = Array.from(new Array(argc).keys()).sort((a, b) => {
                        const a_is_out = out_args[a] && !in_args[a];
                        const b_is_out = out_args[b] && !in_args[b];

                        if (a_is_out) {
                            if (b_is_out) {
                                return a - b;
                            }
                            return 1;
                        }

                        if (b_is_out) {
                            return -1;
                        }

                        return a - b;
                    });

                    for (let i = 0, is_first_optional = true; i < argc; i++) {
                        const j = indexes[i];

                        const [, argname, , arg_modifiers] = list_of_arguments[j];
                        if (parameterNames[j] !== undefined && parameterNames[j] !== argname) {
                            // debugger;
                        } else {
                            parameterNames[j] = argname;
                        }

                        let [argtype, , defval] = list_of_arguments[j];

                        const in_val = `${ varprefix }${ i }`;
                        const is_ptr = argtype.endsWith("*");
                        const is_out = out_args[j];
                        const is_optional = defval !== "" || is_out;

                        let is_array = false;
                        let arrtype = "";
                        let parg = "";

                        if (argtype === "InputArray") {
                            is_array = true;
                            arrtype = "InputArray";
                            argtype = "Mat";
                        } else if (argtype === "InputOutputArray") {
                            is_array = true;
                            arrtype = "InputOutputArray";
                            argtype = "Mat";
                        } else if (argtype === "OutputArray") {
                            is_array = true;
                            arrtype = "OutputArray";
                            argtype = "Mat";
                        } else if (argtype === "InputArrayOfArrays") {
                            is_array = true;
                            arrtype = "InputArray";
                            argtype = "vector_Mat";
                        } else if (argtype === "InputOutputArrayOfArrays") {
                            is_array = true;
                            arrtype = "InputOutputArray";
                            argtype = "vector_Mat";
                        } else if (argtype === "OutputArrayOfArrays") {
                            is_array = true;
                            arrtype = "OutputArray";
                            argtype = "vector_Mat";
                        }

                        if (is_array) {
                            defval = defval
                                .replace("InputArrayOfArrays", "std::vector<cv::Mat>")
                                .replace("InputOutputArrayOfArrays", "std::vector<cv::Mat>")
                                .replace("OutputArrayOfArrays", "std::vector<cv::Mat>")
                                .replace("InputArray", "Mat")
                                .replace("InputOutputArray", "Mat")
                                .replace("OutputArray", "Mat")
                                .replace("noArray", argtype);
                        }

                        if (defval === "" && SIMPLE_ARGTYPE_DEFAULTS.has(argtype)) {
                            defval = SIMPLE_ARGTYPE_DEFAULTS.get(argtype);
                        } else if (defval === `${ argtype }()`) {
                            defval = "";
                        } else if (is_ptr && is_out) {
                            parg = "&";
                            argtype = argtype.slice(0, -1);
                            defval = SIMPLE_ARGTYPE_DEFAULTS.has(argtype) ? SIMPLE_ARGTYPE_DEFAULTS.get(argtype) : "";
                        }

                        const idltype = this.getIDLType(argtype, include);
                        const cpptype = this.getCppType(argtype, include);

                        let callarg = parg + argname;

                        for (const modifier of arg_modifiers) {
                            if (modifier.startsWith("/Cast=")) {
                                callarg = `${ modifier.slice("/Cast=".length) }(${ callarg })`;
                            }
                        }

                        if (arg_modifiers.includes("/RRef")) {
                            callarg = `std::move(${ callarg })`;
                        }

                        callargs[j] = this.callCast(argtype, callarg, coclass);

                        const is_vector = argtype.startsWith("vector_") || argtype.startsWith("VectorOf");
                        const has_ptr = is_ptr || cpptype.startsWith("cv::Ptr<");
                        const is_by_ref = idltype[0] === "I" && idltype !== "IDispatch*" && !has_ptr;
                        const placeholder_name = is_array || is_by_ref || is_vector && !has_ptr ? `${ argname }_placeholder` : argname;
                        const pointer = `p_${ placeholder_name }`;
                        const scalar_pointer = `${ pointer }_s`;
                        const arg_double = `${ argname }_d`;
                        const is_scalar_variant = `${ argname }_is_scalar`;
                        const set_from_pointer = `set_${ argname }_from_ptr`;
                        const cvt = [];

                        if (is_vector || is_array) {
                            cvt.push(`bool ${ is_scalar_variant } = false;`);
                        }

                        if (is_array) {
                            let cvt_body = `
                                bool ${ set_from_pointer } = false;
                                cv::Ptr<_${ arrtype }> ${ pointer };
                            `.replace(/^ {32}/mg, "");

                            if (!is_vector) {
                                cvt_body += `\ncv::Ptr<cv::Scalar> ${ scalar_pointer };`;
                            }

                            cvt_body += `
                                if (V_VT(${ in_val }) == VT_NULL) {
                                    // Nothing to do
                                } else if (V_VT(${ in_val }) == VT_DISPATCH) {
                                    auto obj = dynamic_cast<IVariantArray${ is_vector ? "s" : "" }*>(getRealIDispatch(${ in_val }));
                                    if (!obj) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return E_INVALIDARG;
                                    }

                                    ${ pointer }.reset(obj->create${ arrtype }());
                                    ${ set_from_pointer } = true;
                                }`.replace(/^ {32}/mg, "");

                            if (arrtype === "InputArray" && !is_vector) {
                                cvt_body += ` else if (is_variant_number(${ in_val })) {
                                    double ${ arg_double } = 0.0;
                                    hr = get_variant_number<double>(${ in_val }, ${ arg_double });
                                    if (FAILED(hr)) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return hr;
                                    }
                                    ${ pointer }.reset(new _${ arrtype }(${ arg_double }));
                                    ${ set_from_pointer } = true;
                                }`.replace(/^ {32}/mg, "");
                            }

                            if (is_vector) {
                                cvt_body += ` else if((V_VT(${ in_val }) & VT_ARRAY) == VT_ARRAY && (V_VT(${ in_val }) ^ VT_ARRAY) == VT_VARIANT) {
                                    hr = autoit_opencv_to(${ in_val }, ${ placeholder_name });
                                    if (FAILED(hr)) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return hr;
                                    }
                                    ${ is_scalar_variant } = true;
                                }`.replace(/^ {32}/mg, "");
                            } else {
                                cvt_body += ` else if(is_variant_scalar(${ in_val })) {
                                    ${ scalar_pointer }.reset(new cv::Scalar());
                                    hr = autoit_opencv_to(${ in_val }, *${ scalar_pointer }.get());
                                    if (FAILED(hr)) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return hr;
                                    }
                                    ${ is_scalar_variant } = true;
                                    ${ pointer }.reset(new _${ arrtype }(*${ scalar_pointer }.get()));
                                    ${ set_from_pointer } = true;
                                }`.replace(/^ {32}/mg, "");
                            }

                            if (!is_optional) {
                                cvt_body += ` else if (PARAMETER_MISSING(${ in_val })) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return E_INVALIDARG;
                                }`.replace(/^ {32}/mg, "");
                            }

                            cvt_body += `\n\nauto& ${ argname } = ${ set_from_pointer } ? *${ pointer }.get() : _${ arrtype }(${ placeholder_name });`;

                            cvt.push(...cvt_body.trim().split("\n"));
                        } else if (is_vector && !has_ptr) {
                            cvt.push(...`
                                auto* ${ pointer } = &${ placeholder_name };

                                if (V_VT(${ in_val }) == VT_DISPATCH) {
                                    auto obj = dynamic_cast<TypeToImplType<${ cpptype }>::type*>(getRealIDispatch(${ in_val }));
                                    if (!obj) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return E_INVALIDARG;
                                    }

                                    ${ pointer } = obj->__self->get();
                                    hr = S_OK;
                                } else {
                                    hr = autoit_opencv_to(${ in_val }, ${ placeholder_name });
                                    if (FAILED(hr)) {
                                        printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                        return hr;
                                    }
                                    ${ is_scalar_variant } = true;
                                }

                                auto& ${ argname } = *${ pointer };
                            `.replace(/^ {32}/mg, "").trim().split("\n"));
                        } else if (is_by_ref) {
                            cvt.push(...`
                                auto* ${ pointer } = &${ placeholder_name };
                                hr = autoit_opencv_out(${ in_val }, ${ pointer });
                                if (!PARAMETER_MISSING(${ in_val }) && FAILED(hr)) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return hr;
                                }
                                auto& ${ argname } = SUCCEEDED(hr) ? *${ pointer } : ${ placeholder_name };
                                hr = S_OK;
                            `.replace(/^ {32}/mg, "").trim().split("\n"));
                        } else {
                            cvt.push(...`
                                hr = autoit_opencv_to(${ in_val }, ${ argname });
                                if (FAILED(hr)) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return hr;
                                }
                            `.replace(/^ {32}/mg, "").trim().split("\n"));
                        }

                        if (is_array) {
                            conditions[j] = `(is_array${ is_vector ? "s" : "" }_from(${ in_val }, ${ is_optional })`;
                            conditions[j] += `|| is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional }))`;
                        } else {
                            conditions[j] = `is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional })`;
                        }

                        declarations[j] = `${ indent }${ cpptype } ${ placeholder_name }${ defval === "" ? "" : ` = ${ this.valueCast(argtype, defval, coclass) }` };`;
                        conversions[j] = `\n${ indent }${ cindent }${ is_method_test ? "// " : "" }${ cvt.join(`\n${ indent }${ cindent }${ is_method_test ? "// " : "" }`) }`;

                        if (is_out) {
                            retval.push([idltype, argname, is_array ? arrtype + (is_vector ? "OfArrays" : "") : argtype, in_val]);

                            if (!outputs.has(argname)) {
                                outputs.set(argname, []);
                            }

                            if (!is_by_ref) {
                                outputs.get(argname).push(`${ in_val }`); // mark ${ in_val } as an output of argname
                            }
                        }

                        if (is_optional && is_first_optional) {
                            minopt = Math.min(minopt, i);
                            is_first_optional = false;
                        }
                    }
                }

                if (minopt === Number.POSITIVE_INFINITY) {
                    minopt = -1;
                }

                const returns = [];
                const body = [];

                for (let i = 0; i < maxargc; i++) {
                    body.push(`PARAMETER_IN(${ varprefix }${ i });`);
                }

                if (maxargc !== 0) {
                    body.push("");
                }

                if (coclass.namespace) {
                    body.push(`using namespace ${ coclass.namespace };`);
                }

                if (coclass.include && coclass.include.namespace && coclass.include.namespace !== coclass.namespace) {
                    body.push(`using namespace ${ coclass.include.namespace };`);
                }

                body.push(`HRESULT hr = ${ maxargc !== 0 ? "E_INVALIDARG" : "S_OK" };`);

                for (const {
                    decl,
                    declarations,
                    conditions,
                    conversions,
                    callargs,
                    outputs,
                    retval,
                } of bodies) {
                    const [name, return_value_type, func_modifiers, list_of_arguments] = decl;

                    const is_constructor = func_modifiers.includes("/CO");
                    const is_external = func_modifiers.includes("/External");

                    const path = name.split(is_constructor ? "::" : ".");
                    const is_static = !coclass.is_class && !coclass.is_struct || func_modifiers.includes("/S");
                    const is_entry_test = is_test && !options.notest.has(path.join("::"));
                    const cindent = maxargc !== 0 ? " ".repeat(4) : "";

                    body.push("");

                    if (has_override) {
                        body.push("{");
                    }

                    for (let j = conditions.length; j < maxargc; j++) {
                        conditions.push(`PARAMETER_NOT_FOUND(${ varprefix }${ j })`);
                    }

                    body.push(...declarations);
                    if (conditions.length !== 0) {
                        const start = conditions.length === 1 ? "" : `\n${ indent }    `;
                        const end = conditions.length === 1 ? "" : `\n${ indent }`;
                        body.push(`${ indent }if (${ is_entry_test ? "true/* " : "" }${ start }${ conditions.join(` &&\n${ indent }    `) }${ end }${ is_entry_test ? " */" : "" }) {`);
                        body.push(`${ indent + cindent }hr = S_OK;`);
                    }

                    if (conversions.length !== 0) {
                        body.push(...conversions);
                        body.push("");
                    }

                    let callee;

                    if (is_external) {
                        callee = (is_static ? `C${ cotype }::` : "this->") + path[path.length - 1];
                    } else if (is_static) {
                        callee = path.join("::");
                    } else {
                        callee = "this->__self->get()";

                        for (const modifier of func_modifiers) {
                            if (modifier.startsWith("/Cast=")) {
                                callee = `${ modifier.slice("/Cast=".length) }(${ callee })`;
                            }
                        }

                        callee = `${ callee }->${ path[path.length - 1] }`;
                    }

                    let expr = `(${ callargs.concat(is_external ? ["hr"] : []).join(", ") })`;

                    for (const modifier of func_modifiers) {
                        if (modifier.startsWith("/Expr=")) {
                            expr = modifier.slice("/Expr=".length);
                        }
                    }

                    callee = `${ callee }${ expr }`;

                    if (is_constructor && !is_external) {
                        callee = `cv::Ptr<${ fqn }>(new ${ callee })`;
                    }

                    if (is_external) {
                        const type = [this.getCppType(return_value_type === "" ? "void" : return_value_type, include)];

                        if (is_constructor) {
                            type[0] = `cv::Ptr<${ type[0] }>`;
                        }

                        ipublic.push(`${ [
                            is_static ? "static" : null,
                            return_value_type !== "" && return_value_type !== "void" ? "const" : null,
                            type.join(""),
                            path[path.length - 1]
                        ].filter(text => text !== null).join(" ") }(${ list_of_arguments.map(([argtype, argname]) => {
                            const idltype = this.getIDLType(argtype, include);
                            const cpptype = this.getCppType(argtype, include);
                            const byref = cpptype !== "void*" && cpptype !== "uchar*" && (idltype === "VARIANT" || idltype[0] === "I");
                            return `${ cpptype }${ byref ? "&" : "" } ${ argname }`;
                        }).concat(["HRESULT& hr"]).join(", ") });`);
                    }

                    if (return_value_type !== "void") {
                        if (return_value_type === "void*") {
                            callee = `reinterpret_cast<ULONGLONG>(${ callee })`;
                        }
                        body.push(`${ indent + cindent }${ is_entry_test ? "// " : "" }hr = autoit_opencv_from(${ callee }, _retval);`);
                    } else {
                        body.push(`${ indent + cindent }${ is_entry_test ? "// " : "" }${ callee };`);
                    }

                    body.push(indent + cindent + `
                        if (FAILED(hr)) {
                            return hr;
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n").join(`\n${ indent }${ cindent }`));

                    if (return_value_type !== "void") {
                        const idltype = is_constructor ? coclass.idl : this.getIDLType(return_value_type, include);
                        this.setReturn(returns, idltype, "_retval");
                        retval.unshift([returns[0], "_retval", returns[0], false]);
                    } else if (retval.length !== 0) {
                        const [, argname, argtype] = retval[0];
                        const idltype = this.getIDLType(argtype, include);
                        this.setReturn(returns, idltype, "_retval");
                        outputs.get(argname).push("_retval"); // mark _retval as an output of argname
                    }

                    // populate global retarr array
                    body.push(`\n${ indent }${ cindent }ExtendedHolder::SetLength(${ retval.length });`);
                    if (retval.length !== 0) {
                        body.push("");
                        body.push(indent + cindent + retval.map(([idltype, argname, argtype, in_val], i) => {
                            const lines = [];
                            const is_array = argtype.endsWith("Array") || argtype.endsWith("ArrayOfArrays");
                            const is_vector = argtype.startsWith("vector_") || argtype.endsWith("OfArrays");

                            let value;

                            if (argtype === "VARIANT") {
                                value = argname;
                            } else {
                                let cvt = argname;

                                if (argname === "_retval") {
                                    cvt = "autoit_opencv_from(*_retval, p_retarr_el)";
                                } else if (is_array) {
                                    cvt = `V_VT(${ in_val }) == VT_DISPATCH ? autoit_opencv_out(V_DISPATCH(${ in_val }), p_retarr_el) : `;

                                    if (!is_vector) {
                                        cvt += `${ argname }_is_scalar ? autoit_opencv_from(*p_${ argname }_placeholder_s.get(), p_retarr_el) : `;
                                    }

                                    cvt += `autoit_opencv_from(${ argname }_placeholder, p_retarr_el)`;
                                } else {
                                    cvt = `autoit_opencv_from(${ argname }, p_retarr_el)`;
                                }

                                lines.push(...`
                                    VariantInit(p_retarr_el);
                                    ${ is_entry_test ? "// " : "" }hr = ${ cvt };
                                    if (FAILED(hr)) {
                                        printf("unable to write extended ${ i } of type ${ argtype }\\n");
                                        return hr;
                                    }
                                `.replace(/^ {36}/mg, "").trim().split("\n"));
                                lines.push("");

                                value = "p_retarr_el";
                            }

                            lines.push(...`
                                hr = ExtendedHolder::SetAt(${ i }L, *${ value });
                                if (FAILED(hr)) {
                                    printf("unable to set extended ${ i }\\n");
                                    return hr;
                                }
                            `.replace(/^ {32}/mg, "").trim().split("\n"));

                            for (const rargname of outputs.has(argname) ? outputs.get(argname) : []) {
                                lines.push("");
                                const out = `
                                    ${ is_entry_test ? "// " : "" }hr = autoit_opencv_out(${ value }, ${ rargname });
                                    if (FAILED(hr)) {
                                        printf("unable to write extended ${ i } of type ${ idltype } to ${ rargname }\\n");
                                        return hr;
                                    }
                                `.replace(/^ {36}/mg, "").trim().split("\n");

                                if (rargname !== "_retval") {
                                    const rconditions = [`!PARAMETER_MISSING(${ rargname })`];

                                    if (rargname.startsWith(varprefix) && (is_vector || is_array)) {
                                        rconditions.push(`${ argname }_is_scalar`);
                                    }

                                    lines.push(`if (${ rconditions.join(" && ") }) {`);

                                    // indent
                                    out.forEach((line, j) => {
                                        out[j] = " ".repeat(4) + line;
                                    });
                                }

                                lines.push(...out);

                                if (rargname !== "_retval") {
                                    lines.push("}");
                                }
                            }

                            return `
                                {
                                    _variant_t _retarr_el;
                                    VARIANT* p_retarr_el = &_retarr_el;
                                    ${ lines.join(`\n${ " ".repeat(36) }`) }
                                }
                            `.replace(/^ {32}/mg, "").trim();
                        }).join("\n\n").split("\n").join(`\n${ indent }${ cindent }`));
                    }

                    if (maxargc !== 0) {
                        body.push(`${ indent }${ cindent }return hr;`);
                        body.push(`${ indent }}`);
                    }

                    if (has_override) {
                        body.push("}");
                    }
                }

                const indexes = Array.from(new Array(maxargc).keys());

                const idlargs = indexes.map(i => {
                    const attributes = ["in"];

                    // if (out_args[i]) {
                    //     attributes.push("out");
                    // }

                    if (i >= minopt) {
                        attributes.push("optional");
                    }

                    return `[${ attributes.join(", ") }] VARIANT* ${ varprefix }${ i }`;
                });

                const implargs = indexes.map(i => `VARIANT* ${ varprefix }${ i }`);

                if (returns.length !== 0) {
                    const [idltype, argname] = returns;
                    idlargs.push(`[out, retval] ${ idltype }* ${ argname }`);
                    implargs.push(`${ idltype }* ${ argname }`);
                }

                iidl.push(`[id(${ id })] HRESULT ${ fname }(${ idlargs.join(", ") });`);

                ipublic.push(`STDMETHOD(${ fname })(${ implargs.join(", ") });`);

                if (bodies.length !== 0) {
                    impl.push(`
                        STDMETHODIMP C${ cotype }::${ fname }(${ implargs.join(", ") }) {
                            ${ body.join("\n").replace(/argument (\d+)/g, (match, j) => `argument ${ j }`).trim().split("\n").join(`\n${ " ".repeat(28) }`) }
                            ${ maxargc !== 0 ? "printf(\"Overload resolution failed\\n\");" : "" }
                            return hr;
                        }`.replace(/^ {24}/mg, "")
                    );
                }
            }

            Array.from(coclass.properties.keys()).filter(idlname => {
                const {modifiers} = coclass.properties.get(idlname);
                return modifiers.includes("/Enum");
            }).forEach(writeProperty);

            if (is_idl_class) {
                const cpptype = this.typedefs.has(fqn) ? this.typedefs.get(fqn) : this.getCppType(fqn, coclass);

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
                    conversion.enum(ename, iglobal, impl);
                }
            }

            // converter
            conversion.convert(coclass, iglobal, impl);

            manifest.files.push(`
                <comClass
                    clsid="{${ coclass.clsid }}"
                    threadingModel="Apartment"
                    tlbid="{${ LIB_UID }}"
                    progid="${ APP_NAME }.${ coclass.progid }"
                    description="${ APP_NAME }.${ coclass.progid }" >
                    <progid>${ APP_NAME }.${ coclass.progid }.${ VERSION_MAJOR }</progid>
                </comClass>
            `.replace(/^ {16}/mg, "").trim());

            manifest.proxies.push(`
                <comInterfaceExternalProxyStub
                    name="I${ cotype }"
                    iid="{${ coclass.iid }}"
                    tlbid="{${ LIB_UID }}"
                    proxyStubClsid32="{00020424-0000-0000-C000-000000000046}" />
            `.replace(/^ {16}/mg, "").trim());

            const hdr_id = `_${ coclass.getFilename().toUpperCase() }_OBJECT_`;

            const definition = `
                [
                    object,
                    uuid(${ coclass.iid }),
                    dual,
                    nonextensible,
                    pointer_default(unique)
                ]

                interface I${ cotype } : IDispatch
                {
                    ${ iidl.join("\n").split("\n").join(`\n${ " ".repeat(20) }`) }
                };
            `.replace(/^ {16}/mg, "");

            coclass.iface = {
                cotype,
                hdr_id,
                filename: `i${ coclass.getFilename() }.idl`,
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
                    `public IDispatchImpl<I${ cotype }, &IID_I${ cotype }, &LIBID_cvLib, /*wMajor =*/ ${ VERSION_MAJOR }, /*wMinor =*/ ${ VERSION_MINOR }>`,
                ];

                if (is_idl_class) {
                    if (ARRAY_CLASSES.has(coclass.fqn)) {
                        bases.push(`public IVariantArrayImpl<${ coclass.fqn }>`);
                    } else if (ARRAYS_CLASSES.has(coclass.fqn)) {
                        bases.push(`public IVariantArraysImpl<${ coclass.fqn }>`);
                    } else {
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
                        COM_INTERFACE_ENTRY(IDispatch)
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

            const dependencies = this.dependencies.has(fqn) ? Array.from(this.dependencies.get(fqn).values()) : [];

            const idl_deps = dependencies.filter(dependency => {
                return !this.classes.get(dependency).noidl;
            }).map((dependency, i) => `import "${ this.classes.get(dependency).iface.filename }";`);

            if (dependencies.length !== 0) {
                idl_deps.unshift("");
                idl_deps.unshift(...dependencies.map((dependency, i) => `interface I${ this.classes.get(dependency).iface.cotype };`));
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

            const includes = dependencies.map((dependency, i) => `#include "${ this.classes.get(dependency).getClassName() }.h"`);

            if (options.hdr !== false) {
                const using = new Set([
                    "ATL",
                    "cv",
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

        if (options.hdr !== false) {
            files.set(sysPath.join(options.output, "generated_include.h"), generated_include.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

            files.set(sysPath.join(options.output, "autoit_bridge_generated.h"), [
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
                #include "cvLib.h"
                #include <atlbase.h>
                #include <atlcom.h>
                #include <atlctl.h>
                #include <atlsafe.h>
                #include <iostream>
                #include <OleAuto.h>
                #include <string>
                #include <comutil.h>
                #include <codecvt>
                #include "generated_include.h"

                using namespace cv;

                ${ Array.from(this.typedefs).map(([fqn, cpptype]) => `typedef ${ cpptype } ${ fqn };`).join(`\n${ " ".repeat(16) }`) }

                `.replace(/^ {16}/mg, ""),
                conversion.number.declare("char", "CHAR"), "",
                conversion.number.declare("uchar", "BYTE"), "",
                conversion.number.declare("short", "SHORT"), "",
                conversion.number.declare("ushort", "USHORT"), "",
                conversion.number.declare("int", "LONG"), "",
                conversion.number.declare("uint", "ULONG"), "",
                conversion.number.declare("long", "LONG"), "",
                conversion.number.declare("unsigned long", "ULONG"), "",
                conversion.number.declare("float", "float"), "",
                conversion.number.declare("double", "double"), "",
                conversion.number.declare("int64", "LONGLONG"), "",
                conversion.number.declare("size_t", "ULONGLONG"), "",
                point_conversion[0], "",
                rect_conversion[0], "",
                size_conversion[0], "",
                vec_conversion[0], "",
                ""
            ].join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        files.set(sysPath.join(options.output, "autoit_bridge_generated.cpp"), [
            "#pragma once\n",
            "#include \"autoit_bridge_generated.h\"\n",
            conversion.number.define("char", "CHAR"), "",
            conversion.number.define("uchar", "BYTE"), "",
            conversion.number.define("short", "SHORT"), "",
            conversion.number.define("ushort", "USHORT"), "",
            conversion.number.define("int", "LONG"), "",
            conversion.number.define("uint", "ULONG"), "",
            conversion.number.define("long", "LONG"), "",
            conversion.number.define("unsigned long", "ULONG"), "",
            conversion.number.define("float", "float"), "",
            conversion.number.define("double", "double"), "",
            conversion.number.define("int64", "LONGLONG"), "",
            conversion.number.define("size_t", "ULONGLONG"), "",
            point_conversion[1], "",
            rect_conversion[1], "",
            size_conversion[1], "",
            vec_conversion[1], "",
            ""
        ].join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);

        if (options.rgs !== false) {
            files.set(sysPath.join(options.output, "registries.rgs"), rgs.join("\n").trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        for (const fqn of Object.keys(knwon_ids)) {
            if (!this.classes.has(fqn) || this.classes.get(fqn).noidl) {
                delete knwon_ids[fqn];
            }
        }
        files.set(sysPath.join(__dirname, "ids.json"), JSON.stringify(knwon_ids, null, 4));

        const ifaces = [];
        const stack = [];

        for (const fqn of this.classes.keys()) {
            if (!this.dependencies.has(fqn)) {
                stack.push(fqn);
            }
        }

        while (stack.length !== 0) {
            const fqn = stack.shift();

            if (!this.classes.get(fqn).noidl) {
                ifaces.push(this.classes.get(fqn).iface);
            }

            if (!this.dependents.has(fqn)) {
                continue;
            }

            for (const dependent of this.dependents.get(fqn)) {
                const dependencies = this.dependencies.get(dependent);
                dependencies.delete(fqn);

                if (dependencies.size === 0) {
                    stack.push(dependent);
                    this.dependencies.delete(dependent);
                }
            }

            this.dependents.delete(fqn);
        }

        // Circular dependencies
        for (const fqn of this.dependencies.keys()) {
            if (!this.classes.get(fqn).noidl) {
                ifaces.push(this.classes.get(fqn).iface);
            }
        }

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
                library cvLib
                {
                    importlib("stdole2.tlb");
                    ${ libs.join("\n").split("\n").join(`\n${ " ".repeat(16) }`) }
                };

                import "shobjidl.idl";
                `.replace(/^ {16}/mg, "");

            files.set(sysPath.join(options.output, "cvLib.idl"), idl.trim().replace(/[^\S\n]+$/mg, "") + LF);
        }

        if (options.hdr !== false) {
            files.set(sysPath.join(options.output, "resource.h"), `
                #pragma once

                //{{NO_DEPENDENCIES}}
                // fichier Include Microsoft Visual C++.
                // Utilisé par cvLib.rc
                //
                #define IDS_PROJNAME                    100
                #define IDR_CV                          101
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

        const globals = new Set(["$CV_MAT_DEPTH_MASK", "$CV_MAT_TYPE_MASK"]);

        const getPrefixVariableName = prefix => {
            return prefix.split(".").join("_").replace(/[a-z][A-Z]/g, match => `${ match[0] }_${ match[1] }`).toUpperCase();
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
                return `Global Const ${ vname } = ${ value }`;
            }).join("\n") }`;
        }).join("\n\n");

        files.set(sysPath.resolve(options.output, "..", "udf", "cv_enums.au3"), `${ `
            #include-once
            #include "cv_interface.au3"

            ${ etext.split("\n").join(`\n${ " ".repeat(12) }`) }
        `.replace(/^ {12}/mg, "").trim() }\n`);

        files.set(sysPath.resolve(options.output, "..", "udf", "sxs.manifest"), `${ `
            <?xml version="1.0" encoding="UTF-8"?>
            <assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
                <file name="E:\\development\\git\\node-autoit-opencv-com\\autoit-opencv-com\\build_x64\\Release\\autoit_opencv_com454.dll" hashalg="SHA1">
                    ${ manifest.files.map(text => text.split("\n").join(`\n${ " ".repeat(20) }`)).join(`\n\n${ " ".repeat(20) }`) }
                    <typelib tlbid="{${ LIB_UID }}" version="${ VERSION_MAJOR }.${ VERSION_MINOR }" helpdir="" flags="HASDISKIMAGE" />
                </file>
                ${ manifest.proxies.map(text => text.split("\n").join(`\n${ " ".repeat(16) }`)).join(`\n\n${ " ".repeat(16) }`) }
            </assembly>
        `.replace(/^ {12}/mg, "").trim() }\n`);

        let vs_generate = false;
        const idls_to_generate = new Set();

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
                            if (content !== buffer.toString()) {
                                console.log("write file", filename);
                                fs.writeFile(filename, content, next);
                            } else {
                                next();
                            }
                        },

                        next => {
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
                                        idls_to_generate.add(sysPath.join(options.output, "cvLib.idl"));
                                    }

                                    next(err);
                                });
                            });
                        },
                    ], next);
                }, next);
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
        if (list_of_modifiers.includes("/DC")) {
            coclass.has_default_constructor = true;
        }
        coclass.noidl = list_of_modifiers.includes("/noidl");

        for (const modifier of list_of_modifiers) {
            if (modifier.startsWith("/idl=")) {
                coclass.idl = modifier.slice("/idl=".length);
            } else if (modifier.startsWith("/cpp_quote=")) {
                coclass.cpp_quotes.push(modifier.slice("/cpp_quote=".length));
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

            // make enumerations available via a COM property
            // because com properties and methods are case insensitive,
            // an enum name cannot be the same as a property or a method.
            // To workaround this limitation, an underscore is added a the end of the enum name.
            // More over, office vba does not allow names to start with an underscore.
            // Therefore, putting the underscore at the end is also to workaround this limitation
            // For exemple, cv::FileNode as a method 'real' and an enum 'REAL'
            // The enum will be names REAL_
            //
            // Sources:
            // https://docs.microsoft.com/en-us/windows/win32/com/com-technical-overview
            // https://docs.microsoft.com/it-ch/office/vba/language/reference/user-interface-help/bad-interface-for-implements-method-has-underscore-in-name
            const basename = epath[epath.length - 1];
            const coclass = this.getCoClass(epath.slice(0, -1).join("::"));
            coclass.addProperty(["int", `${ basename }_`, `static_cast<int>(${ epath.join("::") })`, ["/R", "/S", "/Enum", `=${ basename }`]]);
        }
    }

    add_custom_type(fqn, parent) {
        if (fqn.endsWith("_end_")) {
            fqn = fqn.slice(0, -"_end_".length);
        }

        if (this.classes.has(fqn)) {
            return this.classes.get(fqn);
        }

        const cpptype = this.getCppType(fqn, parent);
        this.typedefs.set(fqn, cpptype);

        const coclass = this.getCoClass(fqn);
        coclass.className = `${ fqn }_Object`;
        coclass.idl = `I${ coclass.className }*`;
        coclass.is_simple = true;
        coclass.is_class = true;

        return coclass;
    }

    add_vector(type, parent) {
        const cpptype = this.getCppType(type, parent);

        const fqn = cpptype
            .replace(/std::vector/g, "VectorOf")
            .replace(/\w+::/g, "")
            .replace(/\b[a-z]/g, m => m.toUpperCase())
            .replace(/[<>]/g, "");

        if (this.classes.has(fqn)) {
            return fqn;
        }

        const vtype = type.slice("vector_".length);
        const coclass = this.getCoClass(fqn);
        this.typedefs.set(fqn, cpptype);

        coclass.className = `${ fqn }_Object`;
        coclass.idl = `I${ coclass.className }*`;
        coclass.is_simple = true;
        coclass.is_class = true;
        coclass.is_vector = true;
        coclass.cpptype = cpptype.slice("std::vector<".length, -">".length);
        coclass.vtype = vtype;
        coclass.idltype = this.getIDLType(vtype, {
            fqn,
            namespace: parent.namespace,
        });
        coclass.include = parent;

        coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [], "", ""]);

        coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
            ["size_t", "size", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
            [fqn, "other", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.push_back`, "void", [], [
            [vtype, "value", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.at`, vtype, [], [
            ["size_t", "index", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.at`, "void", ["/External"], [
            ["size_t", "index", "", []],
            [vtype, "value", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.size`, "size_t", [], [], "", ""]);
        coclass.addMethod([`${ fqn }.empty`, "bool", [], [], "", ""]);
        coclass.addMethod([`${ fqn }.clear`, "void", [], [], "", ""]);

        coclass.addMethod([`${ fqn }.push_vector`, "void", ["/External"], [
            [fqn, "other", "", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.push_vector`, "void", ["/External"], [
            [fqn, "other", "", []],
            ["size_t", "count", "", []],
            ["size_t", "start", "0", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.slice`, fqn, ["/External"], [
            ["size_t", "start", "0", []],
            ["size_t", "count", "this->__self->get()->size()", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.sort`, "void", ["/External"], [
            ["void*", "comparator", "", []],
            ["size_t", "start", "0", []],
            ["size_t", "count", "this->__self->get()->size()", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.sort_variant`, "void", ["/External"], [
            ["void*", "comparator", "", []],
            ["size_t", "start", "0", []],
            ["size_t", "count", "this->__self->get()->size()", []],
        ], "", ""]);

        coclass.addMethod([`${ fqn }.start`, "void*", ["/External"], [], "", ""]);
        coclass.addMethod([`${ fqn }.end`, "void*", ["/External"], [], "", ""]);

        return fqn;
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

    isNativeType(type) {
        switch (type) {
            case "char":
            case "uchar":
            case "BYTE":
            case "short":
            case "SHORT":
            case "ushort":
            case "USHORT":
            case "int":
            case "long":
            case "LONG":
            case "ULONG":
            case "float":
            case "FLOAT":
            case "double":
            case "DOUBLE":
            case "int64":
            case "LONGLONG":
            case "size_t":
            case "ULONGLONG":
                return true;
            default:
                return false;
        }
    }

    convertToIdl(in_type, in_val, out_type, out_val, modifiers, set_hr = false) {
        for (const modifier of modifiers) {
            if (modifier.startsWith("/Cast=")) {
                in_val = `${ modifier.slice("/Cast=".length) }(${ in_val })`;
            }
        }

        if (in_type === out_type) {
            const cvt = `*${ out_val } = ${ in_val };`;
            return set_hr ? cvt : `${ cvt }\nreturn S_OK;`;
        }

        if (this.isNativeType(in_type) && this.isNativeType(out_type)) {
            const cvt = `*${ out_val } = static_cast<${ out_type }>(${ in_val });`;
            return set_hr ? cvt : `${ cvt }\nreturn S_OK;`;
        }

        if (in_type === "void*" && out_type === "VARIANT") {
            const cvt = `
                V_VT(out_val) = VT_UI8;
                V_UI8(out_val) = reinterpret_cast<ULONGLONG>(${ in_val });
            `.replace(/^ {16}/mg, "").trim();
            return set_hr ? cvt : `${ cvt }\nreturn S_OK;`;
        }

        const cvt = `autoit_opencv_from(${ in_val }, ${ out_val });`;
        return set_hr ? `hr = ${ cvt }` : `return ${ cvt }`;
    }

    convertFromIdl(in_type, in_val, out_type, out_val) {
        if (in_type.toLowerCase() === out_type.toLowerCase()) {
            return `${ out_val } = ${ in_val };\nreturn S_OK;`;
        }

        if (this.isNativeType(in_type) && this.isNativeType(out_type)) {
            return `${ out_val } = static_cast<${ out_type }>(${ in_val });\nreturn S_OK;`;
        }

        return `return autoit_opencv_to(${ in_val }, ${ out_val });`;
    }

    getIDLType(type, coclass) {
        if (type.startsWith("Ptr_")) {
            // Add dependency
            this.getIDLType(type.slice("Ptr_".length), coclass);
            return "VARIANT";
        }

        if (type.startsWith("vector_")) {
            // Add dependency
            this.getIDLType(type.slice("vector_".length), coclass);
            this.addDepency(coclass.fqn, this.add_vector(type, coclass));
            return "VARIANT";
        }

        if (type === "_variant_t" || type.startsWith("VectorOf")) {
            return "VARIANT";
        }

        if (type.startsWith("GArray_") || type.startsWith("GOpaque_")) {
            const custom_type = this.add_custom_type(type, coclass);
            this.addDepency(coclass.fqn, custom_type.fqn);
            const pos = type.indexOf("_");

            // Add dependency
            this.getIDLType(type.slice(pos + 1), coclass);
            return custom_type.getIDLType();
        }

        if (type.startsWith("tuple_")) {
            const types = type.slice("tuple_".length).split("_and_");
            // Add dependency
            for (const itype of types) {
                this.getIDLType(itype, coclass);
            }
            return "VARIANT";
        }

        for (const fqn of this.getTypes(type, coclass)) {
            if (this.enums.has(fqn)) {
                const pos = fqn.lastIndexOf("::");
                this.addDepency(coclass.fqn, fqn.slice(0, pos));
                return "LONG";
            }

            if (/^cv::(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/.test(fqn)) {
                return "VARIANT";
            }

            if (IDL_TYPES.has(fqn)) {
                return IDL_TYPES.get(fqn);
            }

            if (this.classes.has(fqn)) {
                this.addDepency(coclass.fqn, fqn);
                return this.classes.get(fqn).getIDLType();
            }
        }

        if (type.endsWith("*")) {
            return this.getIDLType(type.slice(0, -1), coclass);
        }

        return type.toUpperCase();
    }

    getCppType(type, coclass) {
        if (type.startsWith("Ptr_")) {
            return `cv::Ptr<${ this.getCppType(type.slice("Ptr_".length), coclass) }>`;
        }

        if (type.startsWith("vector_")) {
            return `std::vector<${ this.getCppType(type.slice("vector_".length), coclass) }>`;
        }

        if (type.startsWith("tuple_")) {
            const types = type.slice("tuple_".length).split("_and_");
            return `std::tuple<${ types.map(itype => this.getCppType(itype, coclass)).join(", ") }>`;
        }

        if (type.startsWith("GArray_") || type.startsWith("GOpaque_")) {
            const pos = type.indexOf("_");
            return `cv::${ type.slice(0, pos) }<${ this.getCppType(type.slice(pos + 1), coclass) }>`;
        }

        if (type.endsWith("*")) {
            return `${ this.getCppType(type.slice(0, -1), coclass) }*`;
        }

        for (const fqn of this.getTypes(type, coclass)) {
            if (this.enums.has(fqn)) {
                return "int";
            }

            if (CPP_TYPES.has(type)) {
                return CPP_TYPES.get(type);
            }

            if (this.classes.has(fqn)) {
                return fqn;
            }
        }

        return /^(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/.test(type) ? `${ this.namespace }::${ type }` : type;
    }

    callCast(type, value, coclass) {
        for (const fqn of this.getTypes(type, coclass)) {
            if (this.enums.has(fqn)) {
                return `static_cast<${ fqn }>(${ value })`;
            }
        }

        return value;
    }

    valueCast(type, value, coclass) {
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

    addDepency(dependent, dependency) {
        if (dependent === dependency) {
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

    getSignatures(coclass) {
        const signatures = new Set();

        for (const fname of coclass.methods.keys()) {
            const overrides = coclass.methods.get(fname);

            for (const decl of overrides) {
                const signature = this.getSignature(coclass, fname, decl);

                if (signatures.has(signature)) {
                    // console.log("duplicated", signature);
                }

                signatures.add(signature);
            }
        }

        return signatures;
    }

    getSignature(coclass, fname, decl) {
        const [, , , list_of_arguments] = decl;
        const signature = [fname];

        for (const [argtype] of list_of_arguments) {
            signature.push(this.getCppType(argtype, coclass));
        }

        return signature.join(", ");
    }

    getTypes(type, coclass) {
        return [
            type,
            `${ coclass.fqn }::${ type }`,
            `${ this.namespace }::${ type }`,
            `${ coclass.namespace }::${ type }`,
        ];
    }
}

module.exports = AutoItGenerator;
