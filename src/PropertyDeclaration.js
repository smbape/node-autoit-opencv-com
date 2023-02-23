const {makeExpansion, useNamespaces, removeNamespaces} = require("./alias");
const { PTR } = require("./constants");

Object.assign(exports, {
    getTupleTypes: type => {
        const separators = /[,<>]/g;
        const types = [];

        let lastIndex = 0;
        let match;
        let open = 0;

        while (match = separators.exec(type)) { // eslint-disable-line no-cond-assign
            if (match[0] === "<") {
                open++;
            } else if (match[0] === ">") {
                open--;
            } else if (open === 0 && match[0] === ",") {
                types.push(type.slice(lastIndex, match.index).trim());
                lastIndex = separators.lastIndex;
            }
        }

        if (lastIndex !== type.length) {
            types.push(type.slice(lastIndex).trim());
        }

        return types;
    },

    restoreOriginalType: (type, options = {}) => {
        const shared_ptr = removeNamespaces(options.shared_ptr, options);

        type = type
            .replace(/_and_/g, ", ")
            .replace(/_end_/g, ">");

        const replacer = new RegExp(`\\b(?:${ ["map", "pair", "tuple", "vector", "GArray", "GOpaque", shared_ptr].join("|") })_`, "g");

        while (replacer.test(type)) {
            replacer.lastIndex = 0;
            type = type.replace(replacer, match => `${ match.slice(0, -1) }<`);
            replacer.lastIndex = 0;
        }

        const tokenizer = new RegExp(`(?:[,>]|\\b(?:${ ["map", "pair", "tuple", "vector", "GArray", "GOpaque", shared_ptr].join("|") })<)`, "g");

        let match;
        const path = [];
        let lastIndex = 0;
        let str = "";

        while (match = tokenizer.exec(type)) { // eslint-disable-line no-cond-assign
            str += type.slice(lastIndex, match.index);

            if (match[0] === ",") {
                while (path.length !== 0 && !["map", "pair", "tuple"].some(tmpl => path[path.length - 1] === tmpl)) {
                    str += ">";
                    path.pop();
                }
            } else if (match[0] === ">") {
                path.pop();
            } else {
                path.push(match[0].slice(0, -1));
            }

            str += match[0];
            lastIndex = tokenizer.lastIndex;
        }

        if (lastIndex !== type.length) {
            str += type.slice(lastIndex);
        }

        const open = str.split("<").length - 1;
        const close = str.split(">").length - 1;

        return str + ">".repeat(open - close);
    },

    isNativeType: type => {
        switch (type) {
            case "bool":
            case "BOOL":
            case "char":
            case "uchar":
            case "BYTE":
            case "short":
            case "SHORT":
            case "ushort":
            case "USHORT":
            case "int":
            case "INT":
            case "unsigned":
            case "uint":
            case "UINT":
            case "long":
            case "LONG":
            case "ULONG":
            case "float":
            case "FLOAT":
            case "double":
            case "DOUBLE":
            case "int64":
            case "LONGLONG":
            case "SSIZE_T":
            case "size_t":
            case "ULONGLONG":
                return true;
            default:
                return false;
        }
    },

    convertToIdl(generator, coclass, in_type, in_val, out_type, out_val, modifiers, is_by_ref, options) {
        if (in_val.endsWith("::this") && out_type.startsWith("I")) {
            const cotype = out_type.slice("I".length, -1);
            return `hr = CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(${ out_val }));`;
        }

        for (const modifier of modifiers) {
            if (modifier.startsWith("/Cast=")) {
                in_val = `${ modifier.slice("/Cast=".length) }(${ in_val })`;
            }
        }

        if (in_type === out_type) {
            return `*${ out_val } = ${ in_val };`;
        }

        if (this.isNativeType(in_type) && this.isNativeType(out_type)) {
            return `*${ out_val } = static_cast<${ out_type }>(${ in_val });`;
        }

        if (PTR.has(in_type) && out_type === "VARIANT") {
            return `
                V_VT(${ out_val }) = VT_UI8;
                V_UI8(${ out_val }) = reinterpret_cast<ULONGLONG>(${ in_val });
            `.replace(/^ {16}/mg, "").trim();
        }

        const cpptype = generator.getCppType(in_type, coclass, options);
        const is_const = modifiers.includes("/C");

        if (is_by_ref && !is_const) {
            in_val = `::autoit::reference_internal(${ in_val })`;
        }

        if (is_by_ref && !is_const && cpptype.startsWith("std::vector<")) {
            const fqn = generator.add_vector(in_type, coclass, options);
            const cotype = generator.classes.get(fqn).getClassName();

            return `
                I${ cotype }* pdispVal = nullptr;
                I${ cotype }** ppdispVal = &pdispVal;
                hr = autoit_from(${ in_val }, ppdispVal);
                if (SUCCEEDED(hr)) {
                    VariantClear(${ out_val });
                    V_VT(${ out_val }) = VT_DISPATCH;
                    V_DISPATCH(${ out_val }) = static_cast<IDispatch*>(*ppdispVal);
                }
            `.replace(/^ {16}/mg, "").trim();
        }

        return `hr = autoit_from(${ generator.castFromEnumIfNeeded(in_type, in_val, coclass, options) }, ${ out_val });`;
    },

    convertFromIdl(in_type, in_val, out_type, obj, propname, setter, is_enum) {
        if (in_type.toLowerCase() === out_type.toLowerCase()) {
            const assignation = setter ? `${ obj }${ setter }(${ in_val })` : `${ obj }${ propname } = ${ in_val }`;
            return `${ assignation };\nreturn S_OK;`;
        }

        if (is_enum || this.isNativeType(in_type) && this.isNativeType(out_type)) {
            in_val = `static_cast<${ out_type }>(${ in_val })`;
            const assignation = setter ? `${ obj }${ setter }(${ in_val })` : `${ obj }${ propname } = ${ in_val }`;
            return `${ assignation };\nreturn S_OK;`;
        }

        if (setter) {
            return `${ out_type } out_val;\nHRESULT hr = autoit_to(${ in_val }, out_val);\n${ obj }${ setter }(out_val);\nreturn hr;`;
        }

        return `return autoit_to(${ in_val }, ${ obj }${ propname });`;
    },

    writeProperty(generator, iidl, impl, ipublic, iprivate, fqn, idlname, is_test, options) {
        const coclass = generator.classes.get(fqn);
        const cotype = coclass.getClassName();

        const is_prop_test = is_test && !options.notest.has(`${ fqn }::${ idlname }`);

        const {type, modifiers} = coclass.properties.get(idlname);
        const propidltype = generator.getIDLType(type, coclass, options);
        const cpptype = generator.getCppType(type, coclass, options);
        const is_static = !coclass.is_class && !coclass.is_struct || modifiers.includes("/S");
        const is_enum = modifiers.includes("/Enum");
        const no_external_decl = modifiers.includes("/ExternalNoDecl");
        const is_external = no_external_decl || modifiers.includes("/External");
        const has_docs = !fqn.endsWith("AndVariant");

        let is_private = true;
        let propname = idlname;
        let rname, wname;
        let id = null;
        let is_propget = false;
        let is_propput = false;
        const attrs = [];

        for (const modifier of modifiers) {
            if (modifier[0] === "=") {
                propname = modifier.slice(1);
            } else if (modifier.startsWith("/R=")) {
                rname = `${ modifier.slice("/R=".length) }()`;
            } else if (modifier.startsWith("/W=")) {
                wname = modifier.slice("/W=".length);
            } else if (modifier.startsWith("/id=")) {
                const new_id = modifier.slice("/id=".length);
                if (id === null) {
                    id = new_id;
                } else if (id !== new_id) {
                    throw new Error(`different ids for property ${ idlname } : ${ id } != ${ new_id }`);
                }
            } else if (modifier.startsWith("/attr=")) {
                attrs.push(modifier.slice("/attr=".length));
            }
        }

        const obj = `${ is_static ? `${ fqn }::` : "__self->get()->" }`;

        if (is_static || is_enum || modifiers.includes("/R") || modifiers.includes("/RW") || (!modifiers.includes("/W") && !wname) || rname) {
            is_propget = true;
            id = coclass.addIDLName(idlname, `get_${ idlname }`, id);

            const attributes = [`id(${ id })`, "propget"].concat(attrs);
            let idltype = propidltype;
            is_private = false;

            if (is_enum) {
                impl.push(`
                    STDMETHODIMP C${ cotype }::get_${ idlname }(${ idltype }* pVal) {
                        *pVal = static_cast<LONG>(${ `${ fqn }::${ propname }` });
                        return S_OK;
                    }`.replace(/^ {20}/mg, "")
                );
            } else {
                let is_by_ref = false;

                if (modifiers.includes("/W") || modifiers.includes("/RW") || rname) {
                    const shared_ptr = removeNamespaces(options.shared_ptr, options);
                    const is_ptr = type.endsWith("*");
                    const has_ptr = cpptype.startsWith(`${ shared_ptr }<`);
                    const is_vector = cpptype.startsWith("std::vector<");
                    is_by_ref = !is_ptr && !has_ptr && (is_vector || idltype[0] === "I" && idltype !== "IDispatch*");
                }

                rname = `${ obj }${ rname ? rname : propname }`;
                for (const modifier of modifiers) {
                    if (modifier.startsWith("/RExpr=")) {
                        rname = makeExpansion(modifier.slice("/RExpr=".length), rname);
                    }
                }

                const enum_type = generator.getEnumType(type, coclass, options);
                if (rname.endsWith("::this") && enum_type) {
                    idltype = generator.classes.get(enum_type).getIDLType();
                    generator.addDependency(coclass.fqn, enum_type);
                }

                const cvt = this.convertToIdl(generator, coclass, type, rname, idltype, "pVal", modifiers, is_by_ref, options).split("\n");

                useNamespaces(cvt, "unshift", generator, coclass);

                const hr = is_static ? "" : `
                    if (__self->get() == NULL) {
                        return E_INVALIDARG;
                    }
                `.replace(/^ {20}/mg, "");

                impl.push(`
                    STDMETHODIMP C${ cotype }::get_${ idlname }(${ idltype }* pVal) {
                        HRESULT hr = S_OK;
                        ${ is_prop_test ? "/* " : "" }${ hr.split("\n").join(`\n${ " ".repeat(24) }`) }${ is_prop_test ? " */" : "" }
                        ${ is_prop_test ? "/* " : "" }${ cvt.join(`\n${ " ".repeat(24) }`) }${ is_prop_test ? " */" : "" }
                        return hr;
                    }`.replace(/^ {20}/mg, "")
                );
            }

            // implementation of external is in another file
            if (is_external) {
                impl.pop();
            }

            iidl.push(`[${ attributes.join(", ") }] HRESULT ${ idlname }([out, retval] ${ idltype }* pVal);`);
            ipublic.push(`STDMETHOD(get_${ idlname })(${ idltype }* pVal);`);
        }

        if (modifiers.includes("/W") || modifiers.includes("/RW") || wname) {
            is_propput = true;
            id = coclass.addIDLName(idlname, `put_${ idlname }`, id);

            const attributes = [`id(${ id })`, "propput"].concat(attrs);
            is_private = false;
            const idltype = propidltype === "VARIANT" ? "VARIANT*" : propidltype;

            const enum_fqn = generator.getEnumType(type, coclass, options);
            const cvt = this.convertFromIdl(idltype, "newVal", enum_fqn === null ? type : enum_fqn, obj, propname, wname, enum_fqn !== null).split("\n");

            useNamespaces(cvt, "unshift", generator, coclass);

            impl.push(`
                STDMETHODIMP C${ cotype }::put_${ idlname }(${ idltype } newVal) {
                    ${ is_prop_test ? "// " : "" }${ is_static ? "" : `${ options.assert }(__self->get() != NULL)` };
                    ${ is_prop_test ? "return S_OK; /* " : "" }${ cvt.join(`\n${ " ".repeat(20) }`) }${ is_prop_test ? " */" : "" }
                }`.replace(/^ {16}/mg, "")
            );

            // implementation of external is in another file
            if (is_external) {
                impl.pop();
            }

            iidl.push(`[${ attributes.join(", ") }] HRESULT ${ idlname }([in] ${ idltype } newVal);`);
            ipublic.push(`STDMETHOD(put_${ idlname })(${ idltype } newVal);`);
        }

        if (is_private) {
            iprivate.push(`${ cpptype } ${ propname };`);
        } else if (has_docs) {
            // generate docs header
            generator.docs.push(`### ${ coclass.name }.${ idlname }\n`.replaceAll("_", "\\_"));

            const cppsignature = [];
            if (is_static) {
                cppsignature.push("static");
            }
            cppsignature.push(cpptype);

            if (propname !== "this") {
                cppsignature.push(`${ fqn }::${ propname }`);
            }

            const attributes = [];

            if (is_propget) {
                attributes.push("propget");
            }

            if (is_propput) {
                attributes.push("propput");
            }

            generator.docs.push([
                "```cpp",
                cppsignature.join(" "),
                // "",
                "AutoIt:",
                `${ " ".repeat(4) }[${ attributes.join(", ") }] $o${ coclass.name }.${ idlname }`,
                "```",
                ""
            ].join("\n").replace(/\s*\( {2}\)/g, "()"));
        }
    }
});
