const {removeNamespaces} = require("./alias");
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
            case "size_t":
            case "ULONGLONG":
                return true;
            default:
                return false;
        }
    },

    convertToIdl(generator, coclass, in_type, in_val, out_type, out_val, modifiers, is_by_ref, options) {
        for (const modifier of modifiers) {
            if (modifier.startsWith("/Cast=")) {
                in_val = `${ modifier.slice("/Cast=".length) }(${ in_val })`;
            }
        }

        if (in_type === out_type) {
            const cvt = `*${ out_val } = ${ in_val };`;
            return `${ cvt }\nreturn S_OK;`;
        }

        if (this.isNativeType(in_type) && this.isNativeType(out_type)) {
            const cvt = `*${ out_val } = static_cast<${ out_type }>(${ in_val });`;
            return `${ cvt }\nreturn S_OK;`;
        }

        if (PTR.has(in_type) && out_type === "VARIANT") {
            const cvt = `
                V_VT(${ out_val }) = VT_UI8;
                V_UI8(${ out_val }) = reinterpret_cast<ULONGLONG>(${ in_val });
            `.replace(/^ {16}/mg, "").trim();
            return `${ cvt }\nreturn S_OK;`;
        }

        const cpptype = generator.getCppType(in_type, coclass, options);

        if (is_by_ref) {
            const {shared_ptr} = options;
            in_val = `${ shared_ptr }<${ cpptype }>(${ shared_ptr }<${ cpptype }>{}, &${ in_val })`;
        }

        if (is_by_ref && cpptype.startsWith("std::vector<")) {
            const fqn = generator.add_vector(in_type, coclass, options);
            const cotype = generator.classes.get(fqn).getClassName();

            return `
                I${ cotype }* pdispVal = nullptr;
                I${ cotype }** ppdispVal = &pdispVal;
                HRESULT hr = autoit_from(${ in_val }, ppdispVal);
                if (SUCCEEDED(hr)) {
                    VariantClear(${ out_val });
                    V_VT(${ out_val }) = VT_DISPATCH;
                    V_DISPATCH(${ out_val }) = static_cast<IDispatch*>(*ppdispVal);
                }
                return hr;
            `.replace(/^ {16}/mg, "").trim();
        }

        const cvt = `autoit_from(${ in_val }, ${ out_val });`;
        return `return ${ cvt }`;
    },

    convertFromIdl(in_type, in_val, out_type, obj, propname, setter) {
        if (in_type.toLowerCase() === out_type.toLowerCase()) {
            const assignation = setter ? `${ obj }${ setter }(${ in_val })` : `${ obj }${ propname } = ${ in_val }`;
            return `${ assignation };\nreturn S_OK;`;
        }

        if (this.isNativeType(in_type) && this.isNativeType(out_type)) {
            in_val = `static_cast<${ out_type }>(${ in_val })`;
            const assignation = setter ? `${ obj }${ setter }(${ in_val })` : `${ obj }${ propname } = ${ in_val }`;
            return `${ assignation };\nreturn S_OK;`;
        }

        if (setter) {
            return `${ out_type } out_val;\nHRESULT hr = autoit_to(${ in_val }, out_val);\n${ obj }${ setter }(out_val);\nreturn hr;`;
        }

        return `return autoit_to(${ in_val }, ${ obj }${ propname });`;
    },

    writeProperty(generator, iidl, impl, ipublic, idnames, fqn, idlname, id, is_test, options) {
        const coclass = generator.classes.get(fqn);
        const cotype = coclass.getClassName();

        if (idnames.has(idlname.toLowerCase())) {
            throw new Error(`duplicated idl name ${ fqn }::${ idlname }`);
        }
        idnames.add(idlname.toLowerCase());

        const is_prop_test = is_test && !options.notest.has(`${ fqn }::${ idlname }`);

        const {type, modifiers} = coclass.properties.get(idlname);
        const propidltype = generator.getIDLType(type, coclass, options);
        const is_static = !coclass.is_class && !coclass.is_struct || modifiers.includes("/S");
        const is_enum = modifiers.includes("/Enum");
        const is_external = modifiers.includes("/External");

        let propname = idlname;
        let rname, wname;

        for (const modifier of modifiers) {
            if (modifier[0] === "=") {
                propname = modifier.slice(1);
            } else if (modifier.startsWith("/R=")) {
                rname = `${ modifier.slice("/R=".length) }()`;
            } else if (modifier.startsWith("/W=")) {
                wname = modifier.slice("/W=".length);
            }
        }

        const obj = `${ is_static ? `${ fqn }::` : "this->__self->get()->" }`;

        if (is_static || is_enum || modifiers.includes("/R") || modifiers.includes("/RW")) {
            iidl.push(`[propget, id(${ id })] HRESULT ${ idlname }([out, retval] ${ propidltype }* pVal);`);
            ipublic.push(`STDMETHOD(get_${ idlname })(${ propidltype }* pVal);`);

            if (is_enum) {
                impl.push(`
                    STDMETHODIMP C${ cotype }::get_${ idlname }(${ propidltype }* pVal) {
                        *pVal = static_cast<LONG>(${ `${ fqn }::${ propname }` });
                        return S_OK;
                    }`.replace(/^ {20}/mg, "")
                );
            } else {
                let is_by_ref = false;
                const cpptype = generator.getCppType(type, coclass, options);

                if (modifiers.includes("/W") || modifiers.includes("/RW")) {
                    const shared_ptr = removeNamespaces(options.shared_ptr, options);
                    const is_ptr = type.endsWith("*");
                    const has_ptr = cpptype.startsWith(`${ shared_ptr }<`);
                    const is_vector = cpptype.startsWith("std::vector<");
                    is_by_ref = !is_ptr && !has_ptr && (is_vector || propidltype[0] === "I" && propidltype !== "IDispatch*");
                }

                const cvt = this.convertToIdl(generator, coclass, type, `${ obj }${ rname ? rname : propname }`, propidltype, "pVal", modifiers, is_by_ref, options);

                impl.push(`
                    STDMETHODIMP C${ cotype }::get_${ idlname }(${ propidltype }* pVal) {
                        ${ is_prop_test ? "// " : "" }${ is_static ? "" : `${ options.assert }(this->__self->get() != NULL)` };
                        ${ is_prop_test ? "return S_OK; /* " : "" }${ cvt.split("\n").join(`\n${ " ".repeat(24) }`) }${ is_prop_test ? " */" : "" }
                    }`.replace(/^ {20}/mg, "")
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

            const cvt = this.convertFromIdl(idltype, "newVal", type, obj, propname, wname);
            impl.push(`
                STDMETHODIMP C${ cotype }::put_${ idlname }(${ idltype } newVal) {
                    ${ is_prop_test ? "// " : "" }${ is_static ? "" : `${ options.assert }(this->__self->get() != NULL)` };
                    ${ is_prop_test ? "return S_OK; /* " : "" }${ cvt.split("\n").join(`\n${ " ".repeat(20) }`) }${ is_prop_test ? " */" : "" }
                }`.replace(/^ {16}/mg, "")
            );

            // implementation of external is in another file
            if (is_external) {
                impl.pop();
            }
        }
    }
});
