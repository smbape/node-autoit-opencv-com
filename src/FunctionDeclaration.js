const {
    SIMPLE_ARGTYPE_DEFAULTS,
    PTR,
} = require("./constants");

const {makeExpansion, useNamespaces} = require("./alias");

Object.assign(exports, {
    declare: (generator, coclass, overrides, fname, idlname, iidl, ipublic, impl, is_test, options = {}) => {
        const {shared_ptr, APP_NAME} = options;
        const {fqn} = coclass;
        const cotype = coclass.getClassName();
        const has_override = overrides.length !== 1;
        const varprefix = "pArg";
        const is_method_test = is_test && !options.notest.has(`${ fqn }::${ fname }`);
        const attrs = [];
        const has_docs = !fqn.endsWith("AndVariant");

        let maxargc = 0;
        let minout = Number.POSITIVE_INFINITY;
        let minopt = Number.POSITIVE_INFINITY;
        let idl_only = false;
        const entries = [];
        const indent = " ".repeat(has_override ? 4 : 0);

        if (has_docs) {
            // generate docs header
            generator.docs.push(`### ${ fqn }::${ fname }\n`.replaceAll("_", "\\_"));
        }

        for (const decl of overrides) {
            const [, return_value_type, func_modifiers, list_of_arguments] = decl;
            const is_constructor = func_modifiers.includes("/CO");
            const no_external_decl = func_modifiers.includes("/ExternalNoDecl");
            const is_external = no_external_decl || func_modifiers.includes("/External");

            const argc = list_of_arguments.length;

            maxargc = Math.max(maxargc, argc);
            minopt = Math.min(minopt, argc);

            const declarations = new Array(argc);
            const conditions = new Array(argc);
            const conversions = new Array(argc);
            const callargs = new Array(argc);
            const optionals = new Array(argc);
            const outputs = new Map();
            const retval = [];
            const cindent = indent + " ".repeat(4);
            const entry = {
                decl,
                declarations,
                conditions,
                conversions,
                callargs,
                optionals,
                outputs,
                retval,
            };

            entries.push(entry);

            const in_args = new Array(argc).fill(false);
            const out_args = new Array(argc).fill(false);
            const out_array_args = new Array(argc).fill(false);

            const getArgWeight = j => {
                if (!in_args[j]) {
                    // is OutputArray
                    if (out_array_args[j]) {
                        return 2;
                    }

                    // out arg which is not an output array
                    if (out_args[j]) {
                        return 3;
                    }
                }

                // has a default value
                if (list_of_arguments[j][2] !== "") {
                    return 2;
                }

                // is non optional value
                return 1;
            };

            const outlist = [];

            if (return_value_type !== "" && return_value_type !== "void") {
                outlist.push("retval");
            } else if (is_constructor) {
                outlist.push("self");
            }

            for (let j = 0; j < argc; j++) {
                const [argtype, argname, defval, arg_modifiers] = list_of_arguments[j];
                const is_ptr = argtype.endsWith("*");
                const is_in_array = /^Input(?:Output)?Array(?:OfArrays)?$/.test(argtype);
                const is_out_array = /^(?:Input)?OutputArray(?:OfArrays)?$/.test(argtype);
                const is_in_out = arg_modifiers.includes("/IO");
                in_args[j] = is_in_array || is_in_out || arg_modifiers.includes("/I");
                out_args[j] = is_out_array || is_in_out || arg_modifiers.includes("/O") || is_ptr && defval === "" && SIMPLE_ARGTYPE_DEFAULTS.has(argtype.slice(0, -1));
                out_array_args[j] = is_out_array;

                if (out_args[j]) {
                    outlist.push(`$${ argname }`);
                }
            }

            const indexes = Array.from(new Array(argc).keys()).sort((a, b) => {
                const diff = getArgWeight(a) - getArgWeight(b);
                return diff === 0 ? a - b : diff;
            });

            entry.indexes = indexes;

            let firstoptarg = argc;

            for (let i = 0, is_first_optional = true; i < argc; i++) {
                const j = indexes[i];

                const [, argname, , arg_modifiers] = list_of_arguments[j];

                let [argtype, , defval] = list_of_arguments[j];

                const in_val = `${ varprefix }${ i }`;
                const is_ptr = argtype.endsWith("*");
                const is_out = out_args[j];
                const is_optional = defval !== "" || is_out && !in_args[j];
                const is_input_array = argtype === "InputArray";

                optionals[j] = is_optional;

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
                } else if (defval.endsWith("()") && generator.getIDLType(defval.slice(0, -"()".length), coclass, options) === generator.getIDLType(argtype, coclass, options)) {
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
                    } else if (!is_external && modifier.startsWith("/Expr=")) {
                        callarg = makeExpansion(modifier.slice("/Expr=".length), callarg);
                    } else if (modifier.startsWith("/default=")) {
                        other_default = modifier.slice("/default=".length);
                    }
                }

                if (arg_modifiers.includes("/RRef")) {
                    callarg = `std::move(${ callarg })`;
                }

                callargs[j] = callarg;

                const is_vector = argtype.startsWith("vector_") || argtype.startsWith("vector<") || argtype.startsWith("VectorOf");
                const has_ptr = is_ptr || cpptype.startsWith(`${ shared_ptr }<`);
                const is_by_ref = idltype[0] === "I" && idltype !== "IDispatch*" && !has_ptr;
                const placeholder_name = is_array || is_by_ref || is_vector && !has_ptr ? `${ argname }_placeholder` : argname;
                const pointer = `p_${ placeholder_name }`;
                const scalar_pointer = `${ pointer }_s`;
                const is_scalar_variant = `${ argname }_is_scalar`;
                const set_from_pointer = `set_${ argname }_from_ptr`;
                const argname_double = `${ argname }_double`;
                const cvt = [`bool ${ set_from_pointer } = false;`];
                let is_shared_ptr = false;

                if (is_vector || is_array) {
                    cvt.push(`bool ${ is_scalar_variant } = false;`);
                }

                if (is_array) {
                    let cvt_body = `
                        ${ shared_ptr }<cv::_${ arrtype }> ${ pointer };
                    `.replace(/^ {24}/mg, "");

                    if (!is_vector) {
                        cvt_body += `\n${ shared_ptr }<cv::Scalar> ${ scalar_pointer };`;
                    }

                    const dispatchConditions = [`V_VT(${ in_val }) == VT_DISPATCH`];
                    const dynamicCast = `dynamic_cast<IVariantArray${ is_vector ? "s" : "" }*>(getRealIDispatch(${ in_val }))`;

                    if (is_optional) {
                        dispatchConditions.push(`${ dynamicCast } != NULL`);
                    }

                    cvt_body += `
                        if (PARAMETER_NULL(${ in_val })) {
                            // Nothing to do
                        } else if (${ dispatchConditions.join(" && ") }) {
                            auto obj = ${ dynamicCast };
                            if (obj) {
                                ${ pointer }.reset(obj->create${ arrtype }());
                                ${ set_from_pointer } = true;
                            } else {
                                hr = autoit_to(${ in_val }, ${ placeholder_name });
                                if (FAILED(hr)) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return hr;
                                }
                            }
                        }`.replace(/^ {24}/mg, "");

                    // do not take numbers as Array because
                    // it is impossible to call the override with double
                    // in case there is a function with an override with double and Array
                    // Ex: method(InputArray input) + method(double precision)

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
                            ${ pointer }.reset(new cv::_${ arrtype }(*${ scalar_pointer }.get()));
                            ${ set_from_pointer } = true;
                        }`.replace(/^ {24}/mg, "");

                        if (is_input_array) {
                            cvt_body += ` else if (V_VT(${ in_val }) == VT_R4 || V_VT(${ in_val }) == VT_R8) {
                                double ${ argname_double } = 0.0;
                                hr = get_variant_number(${ in_val }, ${ argname_double });
                                if (FAILED(hr)) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return hr;
                                }
                                ${ pointer }.reset(new cv::_${ arrtype }(${ argname_double }));
                                ${ set_from_pointer } = true;
                            }`.replace(/^ {28}/mg, "");
                        }
                    }

                    cvt_body += ` else if (!PARAMETER_MISSING(${ in_val })) {
                        hr = autoit_to(${ in_val }, ${ placeholder_name });
                        if (FAILED(hr)) {
                            printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                            return hr;
                        }
                    }`.replace(/^ {20}/mg, "");

                    if (!is_optional) {
                        cvt_body += ` else {
                            printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                            return E_INVALIDARG;
                        }`.replace(/^ {24}/mg, "");
                    }

                    cvt_body += "\n";
                    cvt_body += `\ncv::_${ arrtype } _${ placeholder_name }(${ placeholder_name });`;
                    cvt_body += `\nauto& ${ argname } = ${ set_from_pointer } ? *${ pointer }.get() : _${ placeholder_name };`;

                    cvt.push(...cvt_body.trim().split("\n"));
                } else if (is_vector && !has_ptr) {
                    const dispatchConditions = [`V_VT(${ in_val }) == VT_DISPATCH`];
                    const dynamicCast = `dynamic_cast<TypeToImplType<${ cpptype }>::type*>(getRealIDispatch(${ in_val }))`;

                    if (is_optional) {
                        dispatchConditions.push(`${ dynamicCast } != NULL`);
                    }

                    cvt.push(...`
                        auto* ${ pointer } = &${ placeholder_name };

                        if (${ dispatchConditions.join(" && ") }) {
                            const auto& obj = ${ dynamicCast };
                            if (!obj) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return E_INVALIDARG;
                            }

                            ${ pointer } = obj->__self->get();
                            ${ set_from_pointer } = true;
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
                    if (is_optional) {
                        cvt.push(...`
                            ${ shared_ptr }<${ cpptype }> ${ pointer };
                            hr = autoit_to(${ in_val }, ${ pointer });
                            if (FAILED(hr) && !PARAMETER_MISSING(${ in_val })) {
                                printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                return hr;
                            }
                            ${ set_from_pointer } = SUCCEEDED(hr) && !PARAMETER_MISSING(${ in_val });
                            auto& ${ argname } = ${ set_from_pointer } ? *${ pointer }.get() : ${ placeholder_name };
                            hr = S_OK;
                        `.replace(/^ {28}/mg, "").trim().split("\n"));
                    } else {
                        is_shared_ptr = true;

                        cvt.push(...`
                            ${ shared_ptr }<${ cpptype }> ${ pointer };

                            if (V_VT(${ in_val }) == VT_DISPATCH) {
                                ${ pointer } = ::autoit::cast<${ cpptype }>(getRealIDispatch(${ in_val }));
                                if (!${ pointer }) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return E_INVALIDARG;
                                }

                                ${ set_from_pointer } = true;
                            } else if (V_VT(${ in_val }) == VT_UI8) {
                                const auto& ptr = V_UI8(${ in_val });
                                ${ pointer } = ::autoit::reference_internal(reinterpret_cast<${ cpptype }*>(ptr));
                                ${ set_from_pointer } = true;
                            } else {
                                hr = autoit_to(${ in_val }, ${ placeholder_name });
                                if (FAILED(hr)) {
                                    printf("unable to read argument ${ j } of type %hu into ${ cpptype }\\n", V_VT(${ in_val }));
                                    return hr;
                                }
                            }

                            auto& ${ argname } = ${ pointer } ? *${ pointer }.get() : *${ placeholder_name }.get();
                            hr = S_OK;
                        `.replace(/^ {28}/mg, "").trim().split("\n"));
                    }
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
                    const iconditions = [
                        `is_array${ is_vector ? "s" : "" }_from(${ in_val }, ${ is_optional })`,
                        `is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional })`,
                    ];

                    if (is_input_array) {
                        iconditions.push(`V_VT(${ in_val }) == VT_R4`);
                        iconditions.push(`V_VT(${ in_val }) == VT_R8`);
                    }

                    conditions[j] = `(${ iconditions.join(" || ") })`;
                } else {
                    conditions[j] = `is_assignable_from(${ placeholder_name }, ${ in_val }, ${ is_optional })`;
                }

                if (is_shared_ptr) {
                    declarations[j] = `${ indent }${ shared_ptr }<${ cpptype }> ${ placeholder_name };`;
                } else {
                    declarations[j] = `${ indent }${ cpptype } ${ placeholder_name }`;
                    if (defval !== "") {
                        declarations[j] += ` = ${ defval }`;
                    }
                    declarations[j] += ";";
                }

                conversions[j] = `\n${ cindent }${ is_method_test ? "// " : "" }${ cvt.join(`\n${ cindent }${ is_method_test ? "// " : "" }`) }`;

                if (other_default) {
                    conversions[j] = `\n${ cindent }${ is_method_test ? "// " : "" }${ placeholder_name } = ${ other_default };${ conversions[j] }`;
                }

                if (is_out) {
                    retval.push([idltype, argname, is_array ? arrtype + (is_vector ? "OfArrays" : "") : argtype, in_val, j]);

                    if (!outputs.has(argname)) {
                        outputs.set(argname, []);
                    }

                    outputs.get(argname).push(`${ in_val }`); // mark ${ in_val } as an output of argname
                    minout = Math.min(minout, j);
                }

                if (is_optional && is_first_optional) {
                    minopt = Math.min(minopt, i);
                    firstoptarg = Math.min(firstoptarg, i);
                    is_first_optional = false;
                }
            }

            let has_idlname_changed = false;
            let id = null;

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/idlname=")) {
                    const new_idlname = modifier.slice("/idlname=".length);
                    if (!has_idlname_changed) {
                        idlname = new_idlname;
                        has_idlname_changed = true;
                    } else if (idlname !== new_idlname) {
                        throw new Error(`different idlnames for ${ fname } : ${ idlname } != ${ new_idlname }`);
                    }
                } else if (modifier.startsWith("/id=")) {
                    const new_id = modifier.slice("/id=".length);
                    if (id === null) {
                        id = new_id;
                    } else if (id !== new_id) {
                        throw new Error(`different ids for function ${ fname } : ${ id } != ${ new_id }`);
                    }
                } else if (modifier.startsWith("/attr=")) {
                    attrs.push(modifier.slice("/attr=".length));
                }
            }

            id = coclass.addIDLName(idlname, fname, id);

            entry.id = id;
            entry.idlname = idlname;

            if (!has_docs) {
                continue;
            }

            // generate docs body

            const argnamelist = indexes.map(j => `$${ list_of_arguments[j][1] }`);
            const proput = id === "DISPID_VALUE" && attrs.includes("propput") ? argnamelist.pop() : false;

            let argstr = argnamelist.slice(0, firstoptarg).join(", ");
            argstr = [argstr].concat(argnamelist.slice(firstoptarg)).join("[, ");
            argstr += "]".repeat(argc - firstoptarg);
            if (argstr.startsWith("[, ")) {
                argstr = `[${ argstr.slice("[, ".length) }`;
            }

            let outstr;

            if (is_constructor) {
                outstr = `<${ fqn.replaceAll("::", ".") } object>`;
            } else if (outlist.length !== 0) {
                outstr = outlist.join(", ");
            } else {
                outstr = "None";
            }

            const is_idl_class = !coclass.noidl && (coclass.is_class || coclass.is_struct);
            const is_static = func_modifiers.includes("/S");
            const autoit_caller = !is_idl_class || is_static ? `_${ APP_NAME }_ObjCreate("${ coclass.progid }")` : `$o${ coclass.name }`;
            let autoit_description = `${ autoit_caller }.${ idlname }( ${ argstr } )${ proput ? ` = ${ proput }` : ` -> ${ outstr }` }`;

            if (id === "DISPID_VALUE" && argnamelist.length !== 0 && attrs.includes("propget")) {
                autoit_description += `\n    $o${ coclass.name }( ${ argstr } ) -> ${ outstr }`;
            }

            let cppsignature = `${ generator.getCppType(return_value_type, coclass, options) } ${ fqn }::${ fname }`;

            if (is_static) {
                cppsignature = `static ${ cppsignature }`;
            }

            let maxlength = 0;

            const typelist = list_of_arguments.map(([argtype, , , arg_modifiers]) => {
                let str = "";

                if (arg_modifiers.includes("/C")) {
                    str += "const ";
                }

                const is_in_array = /^Input(?:Output)?Array(?:OfArrays)?$/.test(argtype);
                const is_out_array = /^(?:Input)?OutputArray(?:OfArrays)?$/.test(argtype);
                str += is_in_array || is_out_array ? argtype : generator.getCppType(argtype, coclass, options);

                if (arg_modifiers.includes("/Ref")) {
                    str += "&";
                } else if (arg_modifiers.includes("/RRef")) {
                    str += "&&";
                }
                maxlength = Math.max(maxlength, str.length);
                return str;
            });

            cppsignature = `${ cppsignature }( ${ list_of_arguments.map(([, argname, defval], i) => {
                let str = typelist[i] + " ".repeat(maxlength + 1 - typelist[i].length) + argname;
                if (defval !== "") {
                    str += ` = ${ defval }`;
                }
                return str;
            }).join(`,\n${ " ".repeat(cppsignature.length + "( ".length) }`) } )`;

            if (func_modifiers.includes("/C")) {
                cppsignature = `${ cppsignature } const`;
            }

            cppsignature += ";";

            generator.docs.push([
                "```cpp",
                cppsignature,
                // "",
                "AutoIt:",
                " ".repeat(4) + autoit_description,
                "```",
                ""
            ].join("\n").replace(/\s*\( {2}\)/g, "()").replace(/\s*\[ +\]/g, "[]"));
        }

        if (minopt === Number.POSITIVE_INFINITY) {
            minopt = -1;
        }

        const returns = [];
        const body = [];

        for (let i = 0; i < maxargc; i++) {
            body.push(`PARAMETER_IN(${ varprefix }${ i });`);
        }

        if (attrs.includes("propput") && maxargc >= 2) {
            // setted value is the last parameter
            // however its expected position is maxargc - 2
            // if only maxargc - 1 parameters has been given
            body.push(`
                if (PARAMETER_NOT_FOUND(${ varprefix }${ maxargc - 2 })) {
                    std::swap(${ varprefix }${ maxargc - 2 }, ${ varprefix }${ maxargc - 1 });
                }
            `.trim().replace(/^ {16}/mg, ""));
        }

        if (maxargc !== 0) {
            body.push("");
        }

        useNamespaces(body, "push", generator, coclass);

        const hr = maxargc !== 0 ? "E_INVALIDARG" : "S_OK";
        const enableNamedParameters = maxargc !== 0 && coclass !== generator.namedParameters && !coclass.is_vector && !coclass.is_stdmap;

        body.push(`HRESULT hr = ${ hr };`);

        const vars = Array.from(new Array(maxargc).keys());

        if (enableNamedParameters) {
            body.push("");
            body.push(`
                _variant_t vtDefault;
                V_VT(&vtDefault) = VT_ERROR;
                V_ERROR(&vtDefault) = DISP_E_PARAMNOTFOUND;

                int argc = ${ maxargc };
                bool has_kwarg = false;
                NamedParameters kwargs;

                ${ vars.map(j => {
                    const i = maxargc - 1 - j;
                    return `
                        if (!PARAMETER_MISSING(${ varprefix }${ i })) {
                            if (V_VT(${ varprefix }${ i }) != VT_UI8) {
                                HRESULT ohr = autoit_to(${ varprefix }${ i }, kwargs);
                                has_kwarg = SUCCEEDED(ohr);
                                argc = ${ i };
                            }
                        }
                    `.trim().replace(/^ {24}/mg, "");
                }).join(" else ").split("\n").join(`\n${ " ".repeat(16) }`) }
            `.replace(/^ {16}/mg, "").trim());
            body.push("");
        }

        let kwdone = 0;

        for (const {
            decl,
            declarations,
            conditions,
            conversions,
            callargs,
            optionals,
            outputs,
            retval,
            indexes,
        } of entries) {
            const [name, return_value_type, func_modifiers, list_of_arguments] = decl;

            // Add dependency to return_value_type
            generator.getIDLType(return_value_type, coclass, options);

            const is_constructor = func_modifiers.includes("/CO");
            const no_external_decl = func_modifiers.includes("/ExternalNoDecl");
            const is_external = no_external_decl || func_modifiers.includes("/External");
            if (!idl_only) {
                idl_only = func_modifiers.includes("/IDL");
            } else if (!func_modifiers.includes("/IDL")) {
                throw new Error(`${ fqn }::${ fname } is declared as idl only but has a body`);
            }

            const path = name.split(is_constructor ? "::" : ".");
            const is_static = !coclass.is_class && !coclass.is_struct || func_modifiers.includes("/S");
            const is_entry_test = is_test && !options.notest.has(path.join("::"));
            const cindent = indent + (maxargc !== 0 ? " ".repeat(4) : "");

            for (let j = conditions.length; j < maxargc; j++) {
                conditions.push(`PARAMETER_NOT_FOUND(${ varprefix }${ j })`);
            }

            body.push("");

            if (has_override) {
                body.push(`${ is_static ? "" : "if (__self->get() != NULL) " }{`);
            } else if (!is_static) {
                body.push(`${ indent }${ is_entry_test ? "// " : "" }${ options.assert }(__self->get() != NULL);`);
            }

            body.push(...declarations);

            if (enableNamedParameters) {
                const label = `label${ ++kwdone }`;

                body.push(indent + `
                HRESULT ohr = S_OK;

                {
                    int usedkw = 0;
                    ${ indexes.map(i => {
                        const in_val = `${ varprefix }${ i }`;
                        return `VARIANT* _${ in_val } = ${ in_val };`;
                    }).join(`\n${ " ".repeat(20) }`) }

                    ${ indexes.map(i => {
                        const j = indexes[i];
                        const [, argname] = list_of_arguments[j];
                        const in_val = `${ varprefix }${ i }`;

                        return `
                            // get argument ${ argname }
                            if (!has_kwarg || argc > ${ i }) {
                                // positional parameter
                                if (!${ conditions[j] }) {
                                    ohr = E_INVALIDARG;
                                    goto ${ label };
                                }

                                // should not be a named parameter
                                if (has_kwarg && kwargs.count("${ argname }")) {
                                    ohr = E_INVALIDARG;
                                    goto ${ label };
                                }
                            } else {
                                // named parameter
                                if (kwargs.count("${ argname }")) {
                                    auto& kwarg = kwargs.at("${ argname }");
                                    VARIANT* pkwarg = &kwarg;
                                    if (${ conditions[j].replaceAll(in_val, "pkwarg") }) {
                                        _${ in_val } = &kwarg;
                                        usedkw++;
                                    } else {
                                        ohr = E_INVALIDARG;
                                        goto ${ label };
                                    }
                                } else {
                                    ${ optionals[j] ? `_${ in_val } = &vtDefault` : `ohr = E_INVALIDARG;\n${ " ".repeat(36) }goto ${ label }` };
                                }
                            }
                        `.trim().replace(/^ {28}/mg, "");
                    }).join("\n\n").split("\n").join(`\n${ " ".repeat(20) }`) }

                    if (has_kwarg) {
                        if (argc > ${ indexes.length }) {
                            ohr = E_INVALIDARG;
                        }
                    }${ conditions.length <= indexes.length ? "" : ` else ${ conditions.slice(indexes.length).map((condition, i) => {
                        return `
                            if (!${ condition }) {
                                ohr = E_INVALIDARG;
                            }
                        `.trim().replace(/^ {28}/mg, "");
                    }).join(" else ").split("\n").join(`\n${ " ".repeat(20) }`) }` }

                    if (has_kwarg && SUCCEEDED(ohr)) {
                        // all named parameters should have been used
                        if (usedkw != kwargs.size()) {
                            AUTOIT_ERROR("there are " << (kwargs.size() - usedkw) << " unknown named parameters");
                            ohr = E_INVALIDARG;
                        } else {
                            ${ indexes.map(i => `${ varprefix }${ i } = _${ varprefix }${ i };`).join(`\n${ " ".repeat(28) }`) }
                        }
                    }
                }`.replace(/^ {16}/mg, "").trim().split("\n").join(`\n${ indent }`));

                body.push(`${ indent }${ label }:`);
                body.push("");

                if (conditions.length !== 0) {
                    conditions[0] = "SUCCEEDED(ohr)";
                    conditions.length = 1;
                } else {
                    body.push("if FAILED(ohr) return ohr;\n");
                }
            }

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
                callee = `::${ path.join("::") }`;
            } else {
                callee = "__self->get()";

                for (const modifier of func_modifiers) {
                    if (modifier.startsWith("/Cast=")) {
                        callee = `${ modifier.slice("/Cast=".length) }(${ callee })`;
                    } else if (modifier.startsWith("/Prop=")) {
                        callee = `${ callee }->${ modifier.slice("/Prop=".length) }`;
                    }
                }

                // [+\-*/%\^&|!=<>]=?|[~,]|(?:<<|>>)=?|&&|\|\||\+\+|--|->\*?
                if (!is_external && callargs.length === 1 && /^operator\s*(?:[/*+<>-]=?|\+\+|[!=]=)$/.test(path[path.length - 1])) {
                    const operator = path[path.length - 1].slice("operator".length).trim();
                    callee = `(*${ callee }) ${ operator } `;
                } else {
                    callee = `${ callee }->${ path[path.length - 1] }`;
                }
            }

            let expr = `${ callargs.concat(is_external ? ["hr"] : []).join(", ") }`;

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/Expr=")) {
                    expr = makeExpansion(modifier.slice("/Expr=".length), expr);
                } else if (modifier.startsWith("/Call=")) {
                    callee = makeExpansion(modifier.slice("/Call=".length), callee);
                }
            }

            callee = `${ callee }(${ expr })`;

            if (is_constructor && !is_external) {
                callee = `${ shared_ptr }<${ fqn }>(new ${ callee })`;
            }

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/WrapAs=")) {
                    callee = `${ modifier.slice("/WrapAs=".length) }(${ callee })`;
                }
            }

            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/Output=")) {
                    callee = makeExpansion(modifier.slice("/Output=".length), callee);
                }
            }

            let has_body = false;
            for (const modifier of func_modifiers) {
                if (modifier.startsWith("/Body=")) {
                    callee = makeExpansion(modifier.slice("/Body=".length), callee);
                    has_body = true;
                }
            }

            if (is_external && !no_external_decl) {
                let ext_type = generator.getCppType(return_value_type === "" ? "void" : return_value_type, coclass, options);

                if (is_constructor) {
                    ext_type = `${ shared_ptr }<${ ext_type }>`;
                }

                ipublic.push(`${ [
                    is_static ? "static" : null,
                    ext_type !== "" && ext_type !== "void" ? "const" : null,
                    ext_type,
                    path[path.length - 1]
                ].filter(text => text !== null).join(" ") }(${ list_of_arguments.map(([argtype, argname, , arg_modifiers]) => {
                    const idltype = generator.getIDLType(argtype, coclass, options);
                    const cpptype = generator.getCppType(argtype, coclass, options);
                    const enumtype = generator.getEnumType(argtype, coclass, options);

                    let str = "";

                    if (arg_modifiers.includes("/C")) {
                        str += "const ";
                    }

                    const is_in_array = /^Input(?:Output)?Array(?:OfArrays)?$/.test(argtype);
                    const is_out_array = /^(?:Input)?OutputArray(?:OfArrays)?$/.test(argtype);

                    if (is_in_array || is_out_array) {
                        str += `cv::${ argtype }`;
                    } else if (enumtype !== null) {
                        str += enumtype;
                    } else {
                        str += cpptype;
                    }

                    if (arg_modifiers.includes("/Ref") || !PTR.has(cpptype) && (idltype === "VARIANT" || idltype[0] === "I")) {
                        str += "&";
                    } else if (arg_modifiers.includes("/RRef")) {
                        str += "&&";
                    }

                    return `${ str } ${ argname }`;
                }).concat(["HRESULT& hr"]).join(", ") });`);
            }

            if (!has_body && return_value_type !== "void") {
                if (PTR.has(generator.getCppType(return_value_type, coclass, options))) {
                    callee = `reinterpret_cast<ULONGLONG>(${ callee })`;
                }

                const autoit_from = `autoit_from(${ generator.castFromEnumIfNeeded(return_value_type, "$1", coclass, options) }, $2)`;

                if (is_external) {
                    const idltype = generator.getIDLType(return_value_type, coclass, options);
                    const cpptype = generator.getCppType(return_value_type, coclass, options);
                    const byref = !PTR.has(cpptype) && (idltype === "VARIANT" || idltype[0] === "I");

                    const ebody = cindent + `
                        {
                            const auto${ byref ? "&" : "" } tmp = ${ callee.trim().split("\n").join(`\n${ " ".repeat(28) }`) };
                            if (FAILED(hr)) {
                                return hr;
                            }
                            hr = ${ makeExpansion(autoit_from, "tmp", "_retval") };
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n").map(line => `${ is_entry_test ? "// " : "" }${ line }`).join(`\n${ cindent }`);
                    body.push(ebody);
                } else {
                    body.push(`${ cindent }${ is_entry_test ? "// " : "" }hr = ${
                        makeExpansion(autoit_from, callee.trim().split("\n").join(`\n${ cindent }`), "_retval")
                    };`);
                }
            } else {
                body.push(`${ cindent }${ is_entry_test ? "// " : "" }${ callee.trim().split("\n").join(`\n${ cindent }`) };`);
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
                body.push(cindent + retval.sort((a, b) => {
                    a = a[4] === undefined ? -1 : a[4];
                    b = b[4] === undefined ? -1 : b[4];
                    return a - b;
                }).map(([idltype, argname, argtype, in_val], i) => {
                    const lines = [];
                    const is_array = argtype.endsWith("Array") || argtype.endsWith("ArrayOfArrays");
                    const is_vector = argtype.startsWith("vector_") || argtype.startsWith("vector<") || argtype.endsWith("OfArrays");
                    const placeholder_name = `${ argname }_placeholder`;
                    const pointer = `p_${ placeholder_name }`;
                    const scalar_pointer = `${ pointer }_s`;
                    const is_scalar_variant = `${ argname }_is_scalar`;
                    const set_from_pointer = `set_${ argname }_from_ptr`;

                    let out_val;

                    if (argtype === "VARIANT") {
                        out_val = argname;
                    } else {
                        let cvt;

                        if (argname === "_retval") {
                            cvt = "autoit_from(*_retval, p_retarr_el)";
                        } else if (is_array) {
                            cvt = `V_VT(${ in_val }) == VT_DISPATCH && ${ set_from_pointer } ? autoit_out(V_DISPATCH(${ in_val }), p_retarr_el) : `;

                            if (!is_vector) {
                                cvt += `${ is_scalar_variant } ? autoit_from(*${ scalar_pointer }.get(), p_retarr_el) : `;
                            }

                            cvt += `autoit_from(${ placeholder_name }, p_retarr_el)`;
                        } else {
                            cvt = `autoit_from(${ argname }, p_retarr_el)`;
                        }

                        lines.push(...`
                            VariantInit(p_retarr_el);
                            ${ is_entry_test ? "// " : "" }hr = ${ cvt };
                            if (FAILED(hr)) {
                                printf("unable to write extended ${ i } of type ${ generator.getCppType(argtype, coclass, options) }\\n");
                                return hr;
                            }
                        `.replace(/^ {28}/mg, "").trim().split("\n"));
                        lines.push("");

                        out_val = "p_retarr_el";
                    }

                    lines.push(...`
                        hr = ExtendedHolder::SetAt(${ i }L, *${ out_val });
                        if (FAILED(hr)) {
                            printf("unable to set extended ${ i }\\n");
                            return hr;
                        }
                    `.replace(/^ {24}/mg, "").trim().split("\n"));

                    for (const rargname of outputs.has(argname) ? outputs.get(argname) : []) {
                        lines.push("");
                        const out = `
                            ${ is_entry_test ? "// " : "" }hr = autoit_out(${ out_val }, ${ rargname });
                            if (FAILED(hr)) {
                                printf("unable to write extended ${ i } of type ${ idltype } to ${ rargname }\\n");
                                return hr;
                            }
                        `.replace(/^ {28}/mg, "").trim().split("\n");

                        if (rargname !== "_retval" && rargname.startsWith(varprefix)) {
                            out.unshift(`VariantClear(${ rargname });`);
                        }

                        lines.push(...out);
                    }

                    return `
                        {
                            _variant_t _retarr_el;
                            VARIANT* p_retarr_el = &_retarr_el;
                            ${ lines.join(`\n${ " ".repeat(28) }`) }
                        }
                    `.replace(/^ {24}/mg, "").trim();
                }).join("\n\n").split("\n").join(`\n${ cindent }`));

                body.push("");
            }

            if (maxargc !== 0) {
                body.push(`${ cindent }return hr;`);
                body.push(`${ indent }}`);
            }

            if (has_override) {
                body.push("}");
            }
        }

        const is_propput = attrs.includes("propput");

        const idlargs = vars.map(i => {
            const attributes = ["in"];

            if (i >= minout) {
                attributes.push("out");
            }

            if (
                // NamedParameters can be the only parameter of the function
                (minopt === 0 || i > 0)

                // proput last parameter cannot be optional
                && (!is_propput || i !== maxargc - 1)
            ) {
                attributes.push("optional");
            }

            return `[${ attributes.join(", ") }] VARIANT* ${ varprefix }${ i }`;
        });

        const implargs = vars.map(i => `VARIANT* ${ varprefix }${ i }`);

        if (returns.length !== 0) {
            const [idltype, argname] = returns;
            idlargs.push(`[out, retval] ${ idltype }* ${ argname }`);
            implargs.push(`${ idltype }* ${ argname }`);
        }

        const id = coclass.getIDLNameId(idlname);
        attrs.unshift(`id(${ id })`);

        iidl.push(`[${ Array.from(new Set(attrs)).join(", ") }] HRESULT ${ idlname }(${ idlargs.join(", ") });`);

        if (!idl_only) {
            ipublic.push(`STDMETHOD(${ fname })(${ implargs.join(", ") });`);

            if (entries.length !== 0) {
                impl.push(`
                    STDMETHODIMP C${ cotype }::${ fname }(${ implargs.join(", ") }) {
                        ${ body.join("\n").replace(/argument (\d+)/g, (match, j) => `argument ${ j }`).trim().split("\n").join(`\n${ " ".repeat(24) }`) }
                        ${ maxargc !== 0 ? "fprintf(stderr, \"Overload resolution failed: in %s, file %s, line %d\\n\", AutoIt_Func, __FILE__, __LINE__); fflush(stdout); fflush(stderr);" : "" }
                        return hr;
                    }`.replace(/^ {20}/mg, "")
                );
            }
        }
    }
});
