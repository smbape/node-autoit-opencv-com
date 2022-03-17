const {
    SIMPLE_ARGTYPE_DEFAULTS,
    PTR,
} = require("./constants");

Object.assign(exports, {
    declare: (generator, coclass, overrides, fname, idlname, id, iidl, ipublic, impl, is_test, options = {}) => {
        const {shared_ptr} = options;
        const fqn = coclass.fqn;
        const cotype = coclass.getClassName();
        const has_override = overrides.length !== 1;
        const varprefix = "pVarArg";
        const is_method_test = is_test && !options.notest.has(`${ fqn }::${ fname }`);
        const attrs = [];

        let maxargc = 0;
        let minopt = Number.POSITIVE_INFINITY;
        const bodies = [];
        const indent = " ".repeat(has_override ? 4 : 0);
        // const parameterNames = [];

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
            const cindent = indent + " ".repeat(4);

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
                // if (parameterNames[j] !== undefined && parameterNames[j] !== argname) {
                //     debugger;
                // } else {
                //     parameterNames[j] = argname;
                // }

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

                const idltype = generator.getIDLType(argtype, coclass, options);
                const cpptype = generator.getCppType(argtype, coclass, options);

                let callarg = parg + argname;
                let other_default;

                for (const modifier of arg_modifiers) {
                    if (modifier.startsWith("/Cast=")) {
                        callarg = `${ modifier.slice("/Cast=".length) }(${ callarg })`;
                    } else if (modifier.startsWith("/Expr=")) {
                        callarg = modifier.slice("/Expr=".length).replace(/\$(?:0\b|\{0\})/g, callarg);
                    } else if (modifier.startsWith("/default=")) {
                        other_default = modifier.slice("/default=".length);
                    }
                }

                if (arg_modifiers.includes("/RRef")) {
                    callarg = `std::move(${ callarg })`;
                }

                callargs[j] = generator.castAsEnumIfNeeded(argtype, callarg, coclass);

                const is_vector = argtype.startsWith("vector_") || argtype.startsWith("vector<") || argtype.startsWith("VectorOf");
                const has_ptr = is_ptr || cpptype.startsWith(`${ shared_ptr }<`);
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
                        ${ shared_ptr }<_${ arrtype }> ${ pointer };
                    `.replace(/^ {24}/mg, "");

                    if (!is_vector) {
                        cvt_body += `\n${ shared_ptr }<cv::Scalar> ${ scalar_pointer };`;
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
                        }`.replace(/^ {24}/mg, "");

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
                        }`.replace(/^ {24}/mg, "");
                    }

                    if (is_vector) {
                        cvt_body += ` else if ((V_VT(${ in_val }) & VT_ARRAY) == VT_ARRAY && (V_VT(${ in_val }) ^ VT_ARRAY) == VT_VARIANT) {
                            hr = autoit_to(${ in_val }, ${ placeholder_name });
                            if (FAILED(hr)) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return hr;
                            }
                            ${ is_scalar_variant } = true;
                        }`.replace(/^ {24}/mg, "");
                    } else {
                        cvt_body += ` else if (is_variant_scalar(${ in_val })) {
                            ${ scalar_pointer }.reset(new cv::Scalar());
                            hr = autoit_to(${ in_val }, *${ scalar_pointer }.get());
                            if (FAILED(hr)) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return hr;
                            }
                            ${ is_scalar_variant } = true;
                            ${ pointer }.reset(new _${ arrtype }(*${ scalar_pointer }.get()));
                            ${ set_from_pointer } = true;
                        }`.replace(/^ {24}/mg, "");
                    }

                    if (!is_optional) {
                        cvt_body += ` else if (PARAMETER_MISSING(${ in_val })) {
                            printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                            return E_INVALIDARG;
                        }`.replace(/^ {24}/mg, "");
                    }

                    cvt_body += "\n";
                    cvt_body += `\n_${ arrtype } _${ placeholder_name }(${ placeholder_name });`;
                    cvt_body += `\nauto& ${ argname } = ${ set_from_pointer } ? *${ pointer }.get() : _${ placeholder_name };`;

                    cvt.push(...cvt_body.trim().split("\n"));
                } else if (is_vector && !has_ptr) {
                    cvt.push(...`
                        auto* ${ pointer } = &${ placeholder_name };

                        if (V_VT(${ in_val }) == VT_DISPATCH) {
                            const auto& obj = dynamic_cast<TypeToImplType<${ cpptype }>::type*>(getRealIDispatch(${ in_val }));
                            if (!obj) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return E_INVALIDARG;
                            }

                            ${ pointer } = obj->__self->get();
                            hr = S_OK;
                        } else {
                            hr = autoit_to(${ in_val }, ${ placeholder_name });
                            if (FAILED(hr)) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return hr;
                            }
                            ${ is_scalar_variant } = true;
                        }

                        auto& ${ argname } = *${ pointer };
                    `.replace(/^ {24}/mg, "").trim().split("\n"));
                } else if (is_by_ref) {
                    cvt.push(...`
                        ${ shared_ptr }<${ cpptype }> ${ pointer };
                        hr = autoit_to(${ in_val }, ${ pointer });
                        if (FAILED(hr) && !PARAMETER_MISSING(${ in_val })) {
                            printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                            return hr;
                        }
                        auto& ${ argname } = SUCCEEDED(hr) && !PARAMETER_MISSING(${ in_val }) ? *${ pointer }.get() : ${ placeholder_name };
                        hr = S_OK;
                    `.replace(/^ {24}/mg, "").trim().split("\n"));
                } else if (cpptype === "_variant_t") {
                    cvt.push(`${ argname } = *${ in_val };`);
                } else if (cpptype === "VARIANT*") {
                    cvt.push(`${ argname } = ${ in_val };`);
                } else {
                    cvt.push(...`
                        hr = autoit_to(${ in_val }, ${ argname });
                        if (FAILED(hr)) {
                            printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                            return hr;
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n"));
                }

                if (argtype === "_variant_t" || argtype === "VARIANT*") {
                    conditions[j] = is_optional ? "true" : `!PARAMETER_MISSING(${ in_val })`;
                } else if (is_array) {
                    conditions[j] = `(is_array${ is_vector ? "s" : "" }_from(${ in_val }, ${ is_optional })`;
                    conditions[j] += `|| is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional }))`;
                } else {
                    conditions[j] = `is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional })`;
                }

                declarations[j] = `${ indent }${ cpptype } ${ placeholder_name }${ defval === "" ? "" : ` = ${ generator.castFromEnumIfNeeded(argtype, defval, coclass) }` };`;
                conversions[j] = `\n${ cindent }${ is_method_test ? "// " : "" }${ cvt.join(`\n${ cindent }${ is_method_test ? "// " : "" }`) }`;

                if (other_default) {
                    conversions[j] = `\n${ cindent }${ is_method_test ? "// " : "" }${ placeholder_name } = ${ other_default };${ conversions[j] }`;
                }

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
            const no_external_decl = func_modifiers.includes("/ExternalNoDecl");
            const is_external = no_external_decl || func_modifiers.includes("/External");

            const path = name.split(is_constructor ? "::" : ".");
            const is_static = !coclass.is_class && !coclass.is_struct || func_modifiers.includes("/S");
            const is_entry_test = is_test && !options.notest.has(path.join("::"));
            const cindent = indent + (maxargc !== 0 ? " ".repeat(4) : "");

            body.push("");

            if (has_override) {
                body.push("{");
            }

            if (!is_static) {
                body.push(`${ indent }${ is_entry_test ? "// " : "" }${ options.assert }(this->__self->get() != NULL);`);
            }

            for (let j = conditions.length; j < maxargc; j++) {
                conditions.push(`PARAMETER_NOT_FOUND(${ varprefix }${ j })`);
            }

            body.push(...declarations);
            if (conditions.length !== 0) {
                const start = conditions.length === 1 ? "" : `\n${ indent }    `;
                const end = conditions.length === 1 ? "" : `\n${ indent }`;
                body.push(`${ indent }if (${ is_entry_test ? "true/* " : "" }${ start }${ conditions.join(` &&\n${ indent }    `) }${ end }${ is_entry_test ? " */" : "" }) {`);
                body.push(`${ cindent }hr = S_OK;`);
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

                if (!is_external && callargs.length === 1 && /^operator(?:[/*+-]=?|\+\+)$/.test(path[path.length - 1])) {
                    const operator = path[path.length - 1].slice("operator".length);
                    callee = `(*${ callee }) ${ operator } `;
                } else {
                    callee = `${ callee }->${ path[path.length - 1] }`;
                }
            }

            let expr = `${ callargs.concat(is_external ? ["hr"] : []).join(", ") }`;

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/Expr=")) {
                    expr = modifier.slice("/Expr=".length).replace(/\$(?:0\b|\{0\})/g, expr);
                } else if (modifier.startsWith("/Call=")) {
                    callee = modifier.slice("/Call=".length).replace(/\$(?:0\b|\{0\})/g, callee);
                } else if (modifier.startsWith("/attr=")) {
                    attrs.push(modifier.slice("/attr=".length));
                } else if (modifier.startsWith("/id=")) {
                    id = modifier.slice("/id=".length);
                }
            }

            callee = `${ callee }(${ expr })`;

            if (is_constructor && !is_external) {
                callee = `${ shared_ptr }<${ fqn }>(new ${ callee })`;
            }

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/WrapAs=")) {
                    callee = `${ modifier.slice("/WrapAs=".length) }(${ callee })`;
                } else if (modifier.startsWith("/idlname=")) {
                    idlname = modifier.slice("/idlname=".length);
                }
            }

            if (is_external && !no_external_decl) {
                const type = [generator.getCppType(return_value_type === "" ? "void" : return_value_type, coclass, options)];

                if (is_constructor) {
                    type[0] = `${ shared_ptr }<${ type[0] }>`;
                }

                ipublic.push(`${ [
                    is_static ? "static" : null,
                    return_value_type !== "" && return_value_type !== "void" ? "const" : null,
                    type.join(""),
                    path[path.length - 1]
                ].filter(text => text !== null).join(" ") }(${ list_of_arguments.map(([argtype, argname]) => {
                    const idltype = generator.getIDLType(argtype, coclass, options);
                    const cpptype = generator.getCppType(argtype, coclass, options);
                    const byref = !PTR.has(cpptype) && (idltype === "VARIANT" || idltype[0] === "I");
                    return `${ cpptype }${ byref ? "&" : "" } ${ argname }`;
                }).concat(["HRESULT& hr"]).join(", ") });`);
            }

            if (return_value_type !== "void") {
                if (PTR.has(generator.getCppType(return_value_type, coclass, options))) {
                    callee = `reinterpret_cast<ULONGLONG>(${ callee })`;
                }

                if (is_external) {
                    const idltype = generator.getIDLType(return_value_type, coclass, options);
                    const cpptype = generator.getCppType(return_value_type, coclass, options);
                    const byref = !PTR.has(cpptype) && (idltype === "VARIANT" || idltype[0] === "I");

                    const ebody = cindent + `
                        {
                            const auto${ byref ? "&" : "" } tmp = ${ callee };
                            if (FAILED(hr)) {
                                return hr;
                            }
                            hr = autoit_from(tmp, _retval);
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n").map(line => `${ is_entry_test ? "// " : "" }${ line }`).join(`\n${ cindent }`);
                    body.push(ebody);
                } else {
                    body.push(`${ cindent }${ is_entry_test ? "// " : "" }hr = autoit_from(${ callee }, _retval);`);
                }
            } else {
                body.push(`${ cindent }${ is_entry_test ? "// " : "" }${ callee };`);
            }

            body.push(cindent + `
                if (FAILED(hr)) {
                    return hr;
                }
            `.replace(/^ {16}/mg, "").trim().split("\n").join(`\n${ cindent }`));

            if (return_value_type !== "void") {
                const idltype = is_constructor ? coclass.idl : generator.getIDLType(return_value_type, coclass, options);
                generator.setReturn(returns, idltype, "_retval");
                retval.unshift([returns[0], "_retval", returns[0], false]);
            } else if (retval.length !== 0) {
                const [, argname, argtype] = retval[0];
                const idltype = generator.getIDLType(argtype, coclass, options);
                generator.setReturn(returns, idltype, "_retval");
                outputs.get(argname).push("_retval"); // mark _retval as an output of argname
            }

            // populate global retarr array
            body.push(`\n${ cindent }ExtendedHolder::SetLength(${ retval.length });`);

            if (retval.length !== 0) {
                body.push("");
                body.push(cindent + retval.map(([idltype, argname, argtype, in_val], i) => {
                    const lines = [];
                    const is_array = argtype.endsWith("Array") || argtype.endsWith("ArrayOfArrays");
                    const is_vector = argtype.startsWith("vector_") || argtype.startsWith("vector<") || argtype.endsWith("OfArrays");

                    let value;

                    if (argtype === "VARIANT") {
                        value = argname;
                    } else {
                        let cvt = argname;

                        if (argname === "_retval") {
                            cvt = "autoit_from(*_retval, p_retarr_el)";
                        } else if (is_array) {
                            cvt = `V_VT(${ in_val }) == VT_DISPATCH ? autoit_out(V_DISPATCH(${ in_val }), p_retarr_el) : `;

                            if (!is_vector) {
                                cvt += `${ argname }_is_scalar ? autoit_from(*p_${ argname }_placeholder_s.get(), p_retarr_el) : `;
                            }

                            cvt += `autoit_from(${ argname }_placeholder, p_retarr_el)`;
                        } else {
                            cvt = `autoit_from(${ argname }, p_retarr_el)`;
                        }

                        lines.push(...`
                            VariantInit(p_retarr_el);
                            ${ is_entry_test ? "// " : "" }hr = ${ cvt };
                            if (FAILED(hr)) {
                                printf("unable to write extended ${ i } of type ${ argtype }\\n");
                                return hr;
                            }
                        `.replace(/^ {28}/mg, "").trim().split("\n"));
                        lines.push("");

                        value = "p_retarr_el";
                    }

                    lines.push(...`
                        hr = ExtendedHolder::SetAt(${ i }L, *${ value });
                        if (FAILED(hr)) {
                            printf("unable to set extended ${ i }\\n");
                            return hr;
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n"));

                    for (const rargname of outputs.has(argname) ? outputs.get(argname) : []) {
                        lines.push("");
                        const out = `
                            ${ is_entry_test ? "// " : "" }hr = autoit_out(${ value }, ${ rargname });
                            if (FAILED(hr)) {
                                printf("unable to write extended ${ i } of type ${ idltype } to ${ rargname }\\n");
                                return hr;
                            }
                        `.replace(/^ {28}/mg, "").trim().split("\n");

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
                            ${ lines.join(`\n${ " ".repeat(28) }`) }
                        }
                    `.replace(/^ {24}/mg, "").trim();
                }).join("\n\n").split("\n").join(`\n${ cindent }`));
            }

            if (maxargc !== 0) {
                body.push(`${ cindent }return hr;`);
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

        attrs.unshift(`id(${ id })`);

        iidl.push(`[${ Array.from(new Set(attrs)).join(", ") }] HRESULT ${ idlname }(${ idlargs.join(", ") });`);

        ipublic.push(`STDMETHOD(${ fname })(${ implargs.join(", ") });`);

        if (bodies.length !== 0) {
            impl.push(`
                STDMETHODIMP C${ cotype }::${ fname }(${ implargs.join(", ") }) {
                    ${ body.join("\n").replace(/argument (\d+)/g, (match, j) => `argument ${ j }`).trim().split("\n").join(`\n${ " ".repeat(20) }`) }
                    ${ maxargc !== 0 ? "fprintf(stderr, \"Overload resolution failed: in %s, file %s, line %d\\n\", AutoIt_Func, __FILE__, __LINE__); fflush(stdout); fflush(stderr);" : "" }
                    return hr;
                }`.replace(/^ {16}/mg, "")
            );
        }
    }
});
