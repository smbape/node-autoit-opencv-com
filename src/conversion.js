/* eslint-disable no-magic-numbers */

const optional = require("./optional_conversion");
const map_conversion = require("./map_conversion");
const vector_conversion = require("./vector_conversion");

// idl types
// BSTR
// BYTE
// CHAR
// DOUBLE
// FLOAT
// IDispatch*
// LONG
// LONGLONG
// SHORT
// ULONG
// ULONGLONG
// USHORT
// VARIANT
// VARIANT_BOOL

const numbers = new Map([
    ["CHAR", "I1"],
    ["SHORT", "I2"],
    ["LONG", "I4"],
    ["LONGLONG", "I8"],
    ["INT", "INT"],
    ["FLOAT", "R4"],
    ["DOUBLE", "R8"],
    ["BYTE", "UI1"],
    ["USHORT", "UI2"],
    ["ULONG", "UI4"],
    ["ULONGLONG", "UI8"],
    ["UINT", "UINT"],
]);

const _dynamicCast = (processor, coclass, const_cast, options) => {
    const {children} = coclass;

    if (children.size === 0) {
        return "";
    }

    return `switch(cotype_indexes[std::type_index(typeid(*in_val))]) {
        ${ [...children].map((child, index) => {
            return `case ${ index + 1 }: {
                auto derived = dynamic_cast<${ const_cast }C${ child.getClassName() }*>(in_val);

                if (!derived) {
                    AUTOIT_ERROR("object cannot be cast to a ${ child.fqn }");
                    break;
                }

                return *derived->__self;
            }`.replace(/^ {4}/mg, "");
        }).join(`\n${ " ".repeat(8) }`) }
    }`.replace(/^ {4}/mg, "");
};

const _dynamicPointerCast = (processor, coclass, options) => {
    return "";
};

Object.assign(exports, {
    number: {
        declare: (in_type, out_type, {shared_ptr} = {}) => {
            return `
                extern const bool is_assignable_from(${ in_type }& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const bool is_assignable_from(${ shared_ptr }<${ in_type }>& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ in_type }& out_val);
                extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ shared_ptr }<${ in_type }>& out_val);
                extern const HRESULT autoit_out(VARIANT*& out_val, ${ in_type }*& retval);
                extern const HRESULT autoit_from(${ in_type } const& in_val, ${ out_type }*& out_val);
                extern const HRESULT autoit_from(${ in_type } const& in_val, VARIANT*& out_val);
                extern const HRESULT autoit_from(${ shared_ptr }<${ in_type }> const& in_val, ${ shared_ptr }<${ in_type }>& out_val);
                extern const HRESULT autoit_from(${ shared_ptr }<${ in_type }> const& in_val, VARIANT*& out_val);
            `.replace(/^ {16}/mg, "").trim();
        },

        define: (in_type, out_type, {shared_ptr} = {}) => {
            return `
                const bool is_assignable_from(${ in_type }& out_val, VARIANT const* const& in_val, bool is_optional) {
                    ${ optional.check.join(`\n${ " ".repeat(20) }`) }

                    switch (V_VT(in_val)) {
                        ${ Array.from(numbers).map(([, vt]) => `case VT_${ vt }:`).join(`\n${ " ".repeat(24) }`) }
                            return true;
                        default:
                            return false;
                    }
                }

                const bool is_assignable_from(${ shared_ptr }<${ in_type }>& out_val, VARIANT const* const& in_val, bool is_optional) {
                    ${ optional.check.join(`\n${ " ".repeat(20) }`) }
                    return V_VT(in_val) == VT_UI8;
                }

                const HRESULT autoit_to(VARIANT const* const& in_val, ${ in_type }& out_val) {
                    ${ optional.assign.join(`\n${ " ".repeat(20) }`) }

                    switch (V_VT(in_val)) {
                        ${ Array.from(numbers).map(([, vt]) => `
                            case VT_${ vt }:
                                out_val = static_cast<${ in_type }>(V_${ vt }(in_val));
                                return S_OK;
                        `.replace(/^ {28}/mg, "").trim()).join("\n").split("\n").join(`\n${ " ".repeat(24) }`) }
                        default:
                            return E_INVALIDARG;
                    }
                }

                const HRESULT autoit_to(VARIANT const* const& in_val, ${ shared_ptr }<${ in_type }>& out_val) {
                    ${ optional.assign.join(`\n${ " ".repeat(20) }`) }

                    switch (V_VT(in_val)) {
                        case VT_UI8:
                            out_val = ::autoit::reference_internal(reinterpret_cast<${ in_type }*>(V_UI8(in_val)));
                        default:
                            return E_INVALIDARG;
                    }
                }

                const HRESULT autoit_out(VARIANT*& out_val, ${ in_type }*& retval) {
                    ${ in_type } _retval;
                    HRESULT hr = autoit_to(out_val, _retval);
                    if (SUCCEEDED(hr)) {
                        *retval = _retval;
                    }
                    return hr;
                }

                const HRESULT autoit_from(${ in_type } const& in_val, ${ out_type }*& out_val) {
                    *out_val = ${ in_type === out_type ? "in_val" : `static_cast<${ out_type }>(in_val)` };
                    return S_OK;
                }

                const HRESULT autoit_from(${ in_type } const& in_val, VARIANT*& out_val) {
                    V_VT(out_val) = VT_${ numbers.get(out_type.toUpperCase()) };
                    V_${ numbers.get(out_type.toUpperCase()) }(out_val) = ${ in_type === out_type ? "in_val" : `static_cast<${ out_type }>(in_val)` };
                    return S_OK;
                }

                const HRESULT autoit_from(${ shared_ptr }<${ in_type }> const& in_val, VARIANT*& out_val) {
                    V_VT(out_val) = VT_UI8;
                    *reinterpret_cast<${ in_type }*>(V_UI8(out_val)) = *in_val;
                    return S_OK;
                }

                const HRESULT autoit_from(${ shared_ptr }<${ in_type }> const& in_val, ${ shared_ptr }<${ in_type }>& out_val) {
                    *out_val = *in_val;
                    return S_OK;
                }
            `.replace(/^ {16}/mg, "").trim();
        }
    },

    convert: (processor, coclass, header, impl, options = {}) => {
        for (const ename of coclass.enums) {
            if (ename.endsWith("<unnamed>")) {
                continue;
            }

            header.push(`
                extern const bool is_assignable_from(${ ename }& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ ename }& out_val);
                extern const HRESULT autoit_from(${ ename } const& in_val, VARIANT*& out_val);

                namespace autoit {
                    template<typename destination_type>
                    struct _GenericCopy<destination_type, ${ ename }> {
                        inline static HRESULT copy(destination_type* pTo, const ${ ename }* pFrom) {
                            return autoit_from(*pFrom, pTo);
                        }
                    };
                }
            `.replace(/^ {16}/mg, ""));

            impl.push(`
                const bool is_assignable_from(${ ename }& out_val, VARIANT const* const& in_val, bool is_optional) {
                    int value = 0;
                    return is_assignable_from(value, in_val, is_optional);
                }

                const HRESULT autoit_to(VARIANT const* const& in_val, ${ ename }& out_val) {
                    if (PARAMETER_MISSING(in_val)) {
                        return S_OK;
                    }
                    int value = 0;
                    HRESULT hr = autoit_to(in_val, value);
                    if (SUCCEEDED(hr)) {
                        out_val = static_cast<${ ename }>(value);
                    }
                    return hr;
                }

                const HRESULT autoit_from(${ ename } const& in_val, VARIANT*& out_val) {
                    return autoit_from(static_cast<int>(in_val), out_val);
                }
                `.replace(/^ {16}/mg, "")
            );
        }

        if (!coclass.is_class && !coclass.is_struct) {
            return;
        }

        const {shared_ptr, make_shared} = options;
        const dynamicCast = options.dynamicCast || _dynamicCast;
        const dynamicPointerCast = options.dynamicPointerCast || _dynamicPointerCast;

        const cotype = coclass.getClassName();
        const {interface: iface, children} = coclass;
        const wtype = iface === "IDispatch" ? "DISPATCH" : "UNKNOWN";

        header.push(`
            extern const HRESULT autoit_out(VARIANT*& out_val, I${ cotype }** const retval);

            extern const HRESULT autoit_from(I${ cotype } * const& in_val, I${ cotype }**& out_val);
            extern const HRESULT autoit_from(I${ cotype } * const& in_val, ${ iface }**& out_val);
            extern const HRESULT autoit_from(I${ cotype } * const& in_val, VARIANT*& out_val);

            namespace autoit {
                template<>
                extern ${ shared_ptr }<${ coclass.fqn }> cast<${ coclass.fqn }>(IDispatch* in_val);

                template<>
                extern ${ shared_ptr }<${ coclass.fqn }> const cast<${ coclass.fqn }>(IDispatch const* const& in_val);
            }
        `.replace(/^ {12}/mg, ""));

        if (children.size !== 0) {
            impl.push(`
                namespace {
                    auto init_cotype_indexes() {
                        std::unordered_map<std::type_index, int> cotype_indexes;
                        ${ [...children].map((child, index) => {
                            return `cotype_indexes[std::type_index(typeid(CComObject<C${ child.getClassName() }>))] = ${ index + 1 };`;
                        }).join(`\n${ " ".repeat(24) }`) }
                        return cotype_indexes;
                    }

                    auto cotype_indexes = init_cotype_indexes();
                }
            `.replace(/^ {16}/mg, ""));
        }

        impl.push(`
            const HRESULT autoit_out(VARIANT*& out_val, I${ cotype }** const retval) {
                if (V_VT(out_val) != VT_${ wtype }) {
                    return E_INVALIDARG;
                }

                auto obj = dynamic_cast<I${ cotype }*>(getRealIDispatch(out_val));
                if (obj) {
                    *retval = obj;
                    obj->AddRef();
                    return S_OK;
                }

                return E_INVALIDARG;
            }

            const HRESULT autoit_from(I${ cotype } * const& in_val, I${ cotype }**& out_val) {
                *out_val = in_val;
                in_val->AddRef();
                return S_OK;
            }

            const HRESULT autoit_from(I${ cotype } * const& in_val, ${ iface }**& out_val) {
                *out_val = static_cast<${ iface }*>(in_val);
                in_val->AddRef();
                return S_OK;
            }

            const HRESULT autoit_from(I${ cotype }* const& in_val, VARIANT*& out_val) {
                VariantClear(out_val);

                V_VT(out_val) = VT_${ wtype };
                V_${ wtype }(out_val) = static_cast<${ iface }*>(in_val);
                in_val->AddRef();
                return S_OK;
            }

            namespace autoit {
                template<>
                ${ shared_ptr }<${ coclass.fqn }> cast<${ coclass.fqn }>(IDispatch* in_val) {
                    {
                        auto obj = dynamic_cast<C${ cotype }*>(in_val);
                        if (obj) {
                            return *obj->__self;
                        }
                    }
                    ${ dynamicCast(processor, coclass, "", options).split("\n").join(`\n${ " ".repeat(20) }`) }
                    return ${ shared_ptr }<${ coclass.fqn }>();
                }

                template<>
                ${ shared_ptr }<${ coclass.fqn }> const cast<${ coclass.fqn }>(IDispatch const* const& in_val) {
                    {
                        auto obj = dynamic_cast<C${ cotype } const*>(in_val);
                        if (obj) {
                            return *obj->__self;
                        }
                    }
                    ${ dynamicCast(processor, coclass, "const ", options).split("\n").join(`\n${ " ".repeat(20) }`) }
                    return ${ shared_ptr }<${ coclass.fqn }>();
                }
            }

            `.replace(/^ {12}/mg, "")
        );

        if (!coclass.is_vector) {
            header.push(`
                extern const bool is_assignable_from(${ shared_ptr }<${ coclass.fqn }>& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ shared_ptr }<${ coclass.fqn }>& out_val);
            `.replace(/^ {16}/mg, ""));
        }

        header.push(`
            extern const bool is_assignable_from(${ coclass.fqn }*& out_val, VARIANT const* const& in_val, bool is_optional);
            extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val);
            extern const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, I${ cotype }**& out_val);
            extern const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, ${ iface }**& out_val);
            extern const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, VARIANT*& out_val);
            extern const HRESULT autoit_from(${ coclass.fqn } * const& in_val, I${ cotype }**& out_val);
            extern const HRESULT autoit_from(${ coclass.fqn } * const& in_val, ${ iface }**& out_val);
            extern const HRESULT autoit_from(${ coclass.fqn } * const& in_val, VARIANT*& out_val);
        `.replace(/^ {12}/mg, ""));

        if (!coclass.is_vector) {
            impl.push(`
                const bool is_assignable_from(${ shared_ptr }<${ coclass.fqn }>& out_val, VARIANT const* const& in_val, bool is_optional) {
                    ${ optional.check.join(`\n${ " ".repeat(20) }`) }

                    if (V_VT(in_val) == VT_NULL || V_VT(in_val) == VT_UI8) {
                        return true;
                    }

                    if (V_VT(in_val) != VT_${ wtype }) {
                        return false;
                    }

                    return ::autoit::cast<${ coclass.fqn }>(getRealIDispatch(in_val)) != NULL;
                }

                const HRESULT autoit_to(VARIANT const* const& in_val, ${ shared_ptr }<${ coclass.fqn }>& out_val) {
                    ${ optional.assign.join(`\n${ " ".repeat(20) }`) }

                    if (V_VT(in_val) == VT_NULL) {
                        out_val.reset();
                        return S_OK;
                    }

                    if (V_VT(in_val) == VT_UI8) {
                        const auto& ptr = V_UI8(in_val);
                        out_val = ::autoit::reference_internal(reinterpret_cast<${ coclass.fqn }*>(ptr));
                        return S_OK;
                    }

                    if (V_VT(in_val) == VT_${ wtype }) {
                        out_val = ::autoit::cast<${ coclass.fqn }>(getRealIDispatch(in_val));
                        return out_val.get() ? S_OK : E_INVALIDARG;
                    }

                    return E_INVALIDARG;
                }
            `.replace(/^ {16}/mg, ""));
        }

        impl.push(`
            const bool is_assignable_from(${ coclass.fqn }*& out_val, VARIANT const* const& in_val, bool is_optional) {
                ${ shared_ptr }<${ coclass.fqn }> out_val_shared;
                return is_assignable_from(out_val_shared, in_val, is_optional);
            }

            const HRESULT autoit_to(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val) {
                if (V_VT(in_val) == VT_NULL) {
                    out_val = nullptr;
                    return S_OK;
                }

                ${ shared_ptr }<${ coclass.fqn }> out_val_shared;
                HRESULT hr = autoit_to(in_val, out_val_shared);
                if (SUCCEEDED(hr)) {
                    out_val = out_val_shared.get();
                }
                return hr;
            }

            const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, I${ cotype }**& out_val) {
                HRESULT hr = *out_val != nullptr ? S_OK : CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(out_val));
                if (SUCCEEDED(hr)) {
                    auto obj = static_cast<C${ cotype }*>(*out_val);
                    *obj->__self = in_val;
                }
                return hr;
            }

            const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, ${ iface }**& out_val) {
                return autoit_from(in_val, reinterpret_cast<I${ cotype }**&>(out_val));
            }

            const HRESULT autoit_from(${ shared_ptr }<${ coclass.fqn }> const& in_val, VARIANT*& out_val) {
                if (!in_val) {
                    V_VT(out_val) = VT_NULL;
                    return S_OK;
                }

                ${ dynamicPointerCast(processor, coclass, options).split("\n").join(`\n${ " ".repeat(16) }`) }
                I${ cotype }* pdispVal = V_VT(out_val) != VT_${ wtype } ? nullptr : dynamic_cast<I${ cotype }*>(V_${ wtype }(out_val));
                I${ cotype }** ppdispVal = &pdispVal;

                HRESULT hr;
                if (pdispVal) {
                    hr = autoit_from(in_val, ppdispVal);
                } else {
                    hr = autoit_from(in_val, ppdispVal);
                    if (SUCCEEDED(hr)) {
                        VariantClear(out_val);
                        V_VT(out_val) = VT_${ wtype };
                        V_${ wtype }(out_val) = static_cast<${ iface }*>(*ppdispVal);
                    }
                }

                return hr;
            }

            const HRESULT autoit_from(${ coclass.fqn } * const& in_val, I${ cotype }**& out_val) {
                return autoit_from(::autoit::reference_internal(in_val), out_val);
            }

            const HRESULT autoit_from(${ coclass.fqn } * const& in_val, ${ iface }**& out_val) {
                return autoit_from(::autoit::reference_internal(in_val), out_val);
            }

            const HRESULT autoit_from(${ coclass.fqn } * const& in_val, VARIANT*& out_val) {
                if (!in_val) {
                    V_VT(out_val) = VT_NULL;
                    return S_OK;
                }

                return autoit_from(::autoit::reference_internal(in_val), out_val);
            }
            `.replace(/^ {12}/mg, "")
        );

        if (coclass.is_struct || coclass.is_simple || coclass.is_map || coclass.has_copy_constructor || coclass.has_assign_operator) {
            if (!coclass.is_vector) {
                header.push(`extern const bool is_assignable_from(${ coclass.fqn }& out_val, VARIANT const* const& in_val, bool is_optional);`);
                header.push(`extern const HRESULT autoit_to(VARIANT const* const& in_val, ${ coclass.fqn }& out_val);`);
                impl.push(`
                    const bool is_assignable_from(${ coclass.fqn }& out_val, VARIANT const* const& in_val, bool is_optional) {
                        ${ optional.check.join(`\n${ " ".repeat(24) }`) }

                        if (V_VT(in_val) == VT_UI8) {
                            return true;
                        }

                        if ( V_VT(in_val) != VT_${ wtype }) {
                            return false;
                        }

                        return ::autoit::cast<${ coclass.fqn }>(getRealIDispatch(in_val)) != NULL;
                    }

                    const HRESULT autoit_to(VARIANT const* const& in_val, ${ coclass.fqn }& out_val) {
                        ${ optional.assign.join(`\n${ " ".repeat(24) }`) }

                        if (V_VT(in_val) == VT_UI8) {
                            const auto& ptr = V_UI8(in_val);
                            out_val = *reinterpret_cast<${ coclass.fqn }*>(ptr);
                            return S_OK;
                        }

                        if (V_VT(in_val) == VT_${ wtype }) {
                            const auto& obj = ::autoit::cast<${ coclass.fqn }>(getRealIDispatch(in_val));
                            if (!obj) {
                                return E_INVALIDARG;
                            }
                            out_val = *obj;
                            return S_OK;
                        }

                        return E_INVALIDARG;
                    }
                `.replace(/^ {20}/mg, "").trim());
            }

            header.push(`
                extern const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype } * const& in_val, bool is_optional);
                extern const bool is_assignable_from(${ coclass.fqn }& out_val, ${ iface } * const& in_val, bool is_optional);

                extern const HRESULT autoit_to(I${ cotype } * const& in_val, ${ coclass.fqn }& out_val);
                extern const HRESULT autoit_to(${ iface } * const& in_val, ${ coclass.fqn }& out_val);

                extern const HRESULT autoit_from(${ coclass.fqn } const& in_val, I${ cotype }**& out_val);
                extern const HRESULT autoit_from(${ coclass.fqn } const& in_val, ${ iface }**& out_val);
            `.replace(/^ {16}/mg, "").trim());
            impl.push(`
                const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype } * const& in_val, bool is_optional) {
                    return true;
                }

                const bool is_assignable_from(${ coclass.fqn }& out_val, ${ iface } * const& in_val, bool is_optional) {
                    const auto &idispatch = ${ iface === "IDispatch" ? "in_val" : "dynamic_cast<IDispatch const*>(in_val)" };
                    if (${ iface === "IDispatch" } || idispatch) {
                        const auto& obj = ::autoit::cast<${ coclass.fqn }>(idispatch);
                        return obj ? S_OK : E_INVALIDARG;
                    }

                    return dynamic_cast<C${ cotype } const*>(in_val) != nullptr;
                }

                const HRESULT autoit_to(I${ cotype } * const& in_val, ${ coclass.fqn }& out_val) {
                    auto obj = dynamic_cast<C${ cotype }*>(in_val);
                    if (!obj) {
                        return E_INVALIDARG;
                    }
                    out_val = *obj->__self->get();
                    return S_OK;
                }

                const HRESULT autoit_to(${ iface } * const& in_val, ${ coclass.fqn }& out_val) {
                    const auto &idispatch = ${ iface === "IDispatch" ? "in_val" : "dynamic_cast<IDispatch*>(in_val)" };
                    if (${ iface === "IDispatch" } || idispatch) {
                        const auto& obj = ::autoit::cast<${ coclass.fqn }>(idispatch);
                        if (!obj) {
                            return E_INVALIDARG;
                        }
                        out_val = *obj;
                        return S_OK;
                    }

                    auto obj = dynamic_cast<C${ cotype }*>(in_val);
                    if (!obj) {
                        return E_INVALIDARG;
                    }
                    out_val = *obj->__self->get();
                    return S_OK;
                }

                const HRESULT autoit_from(${ coclass.fqn } const& in_val, I${ cotype }**& out_val) {
                    HRESULT hr = *out_val != nullptr ? S_OK : CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(out_val));
                    if (SUCCEEDED(hr)) {
                        auto obj = static_cast<C${ cotype }*>(*out_val);
                        *obj->__self = ${ make_shared }<${ coclass.fqn }>(in_val);
                    }
                    return hr;
                }

                const HRESULT autoit_from(${ coclass.fqn } const& in_val, ${ iface }**& out_val) {
                    return autoit_from(in_val, reinterpret_cast<I${ cotype }**&>(out_val));
                }
                `.replace(/^ {16}/mg, "")
            );

            if (!coclass.is_vector) {
                header.push(`
                    extern const HRESULT autoit_from(${ coclass.fqn } const& in_val, VARIANT*& out_val);
                `.replace(/^ {20}/mg, ""));
                impl.push(`
                    const HRESULT autoit_from(${ coclass.fqn } const& in_val, VARIANT*& out_val) {
                        I${ cotype }* pdispVal = V_VT(out_val) != VT_${ wtype } ? nullptr : dynamic_cast<I${ cotype }*>(V_${ wtype }(out_val));
                        I${ cotype }** ppdispVal = &pdispVal;

                        HRESULT hr;
                        if (pdispVal) {
                            hr = autoit_from(in_val, ppdispVal);
                        } else {
                            hr = autoit_from(in_val, ppdispVal);
                            if (SUCCEEDED(hr)) {
                                VariantClear(out_val);
                                V_VT(out_val) = VT_${ wtype };
                                V_${ wtype }(out_val) = static_cast<${ iface }*>(*ppdispVal);
                            }
                        }

                        return hr;
                    }
                `.replace(/^ {20}/mg, ""));
            }
        }

        if (coclass.is_vector) {
            vector_conversion.convert(coclass, header, impl, options);
        }

        if (coclass.is_stdmap || processor.namedParameters === coclass) {
            map_conversion.convert(coclass, header, impl, options);
        }

        if (typeof options.convert === "function") {
            options.convert(processor, coclass, header, impl, options);
        }
    },

    enum: (type, header, impl) => {
        header.push(`
            extern const bool is_assignable_from(${ type }& out_val, LONG const& in_val, bool is_optional);
            extern const HRESULT autoit_to(LONG const& in_val, ${ type }& out_val);
        `.replace(/^ {12}/mg, "").trim());

        impl.push(`
            const bool is_assignable_from(${ type }& out_val, LONG const& in_val, bool is_optional) {
                return true;
            }

            const HRESULT autoit_to(LONG const& in_val, ${ type }& out_val) {
                out_val = static_cast<${ type }>(in_val);
                return S_OK;
            }
            `.replace(/^ {12}/mg, "")
        );
    }
});
