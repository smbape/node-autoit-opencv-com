/* eslint-disable no-magic-numbers */

const optional = require("./optional_conversion");
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

Object.assign(exports, {
    number: {
        declare: (in_type, out_type) => {
            return `
                extern const bool is_assignable_from(${ in_type }& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const bool is_assignable_from(cv::Ptr<${ in_type }>& out_val, VARIANT const* const& in_val, bool is_optional);
                extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ in_type }& out_val);
                extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Ptr<${ in_type }>& out_val);
                extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, ${ in_type }*& out_val);
                extern const HRESULT autoit_opencv_from(${ in_type } const& in_val, ${ out_type }*& out_val);
                extern const HRESULT autoit_opencv_from(${ in_type } const& in_val, VARIANT*& var_out_val);
                extern const HRESULT autoit_opencv_from(const cv::Ptr<${ in_type }>& in_val, cv::Ptr<${ in_type }>& out_val);
                extern const HRESULT autoit_opencv_from(const cv::Ptr<${ in_type }>& in_val, VARIANT*& var_out_val);
            `.replace(/^ {16}/mg, "").trim();
        },

        define: (in_type, out_type) => {
            return `
                const bool is_assignable_from(${ in_type }& out_val, VARIANT const* const& in_val, bool is_optional) {
                    switch (V_VT(in_val)) {
                        ${ Array.from(numbers).map(([, vt]) => `case VT_${ vt }:`).join(`\n${ " ".repeat(24) }`) }
                            return true;
                        ${ optional.case.join(`\n${ " ".repeat(24) }`) }
                        default:
                            return false;
                    }
                }

                const bool is_assignable_from(cv::Ptr<${ in_type }>& out_val, VARIANT const* const& in_val, bool is_optional) {
                    switch (V_VT(in_val)) {
                        case VT_UI8:
                            return true;
                        ${ optional.case.join(`\n${ " ".repeat(24) }`) }
                        default:
                            return false;
                    }
                }

                const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ in_type }& out_val) {
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

                const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Ptr<${ in_type }>& out_val) {
                    ${ optional.assign.join(`\n${ " ".repeat(20) }`) }

                    switch (V_VT(in_val)) {
                        case VT_UI8:
                            out_val = reinterpret_cast<${ in_type }*>(V_UI8(in_val));
                        default:
                            return E_INVALIDARG;
                    }
                }

                const HRESULT autoit_opencv_out(VARIANT const* const& in_val, ${ in_type }*& out_val) {
                    auto _out_val = *out_val;
                    HRESULT hr = autoit_opencv_to(in_val, _out_val);
                    if (SUCCEEDED(hr)) {
                        *out_val = _out_val;
                    }
                    return hr;
                }

                const HRESULT autoit_opencv_from(${ in_type } const& in_val, ${ out_type }*& out_val) {
                    *out_val = ${ in_type === out_type ? "in_val" : `static_cast<${ out_type }>(in_val)` };
                    return S_OK;
                }

                const HRESULT autoit_opencv_from(${ in_type } const& in_val, VARIANT*& var_out_val) {
                    V_VT(var_out_val) = VT_${ numbers.get(out_type.toUpperCase()) };
                    V_${ numbers.get(out_type.toUpperCase()) }(var_out_val) = ${ in_type === out_type ? "in_val" : `static_cast<${ out_type }>(in_val)` };
                    return S_OK;
                }

                const HRESULT autoit_opencv_from(const cv::Ptr<${ in_type }>& in_val, VARIANT*& var_out_val) {
                    V_VT(var_out_val) = VT_UI8;
                    *reinterpret_cast<${ in_type }*>(V_UI8(var_out_val)) = *in_val;
                    return S_OK;
                }

                const HRESULT autoit_opencv_from(const cv::Ptr<${ in_type }>& in_val, cv::Ptr<${ in_type }>& out_val) {
                    *out_val = *in_val;
                    return S_OK;
                }
            `.replace(/^ {16}/mg, "").trim();
        }
    },

    convert: (coclass, header, impl) => {
        if (coclass.is_vector) {
            vector_conversion(coclass, header, impl);
            return;
        }

        if (!coclass.is_class && !coclass.is_struct) {
            return;
        }

        const cotype = coclass.getClassName();

        header.push(`
            extern const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype }*& in_val, bool is_optional);
            extern const bool is_assignable_from(${ coclass.fqn }& out_val, IDispatch*& in_val, bool is_optional);
            extern const bool is_assignable_from(${ coclass.fqn }& out_val, VARIANT const* const& in_val, bool is_optional);

            extern const HRESULT autoit_opencv_to(I${ cotype }*& in_val, ${ coclass.fqn }& out_val);
            extern const HRESULT autoit_opencv_to(IDispatch*& in_val, ${ coclass.fqn }& out_val);
            extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ coclass.fqn }& out_val);

            extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val);
            extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, I${ cotype }**& out_val);

            extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, I${ cotype }**& out_val);
            extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, IDispatch**& out_val);
            extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, VARIANT*& out_val);
        `.replace(/^ {12}/mg, ""));

        impl.push(`
            const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype }* in_val, bool is_optional) {
                return true;
            }

            const bool is_assignable_from(${ coclass.fqn }& out_val, IDispatch*& in_val, bool is_optional) {
                return dynamic_cast<C${ cotype }*>(in_val) ? true : false;
            }

            const bool is_assignable_from(${ coclass.fqn }& out_val, VARIANT const* const& in_val, bool is_optional) {
                switch (V_VT(in_val)) {
                    case VT_DISPATCH:
                        // TODO : find a better way to check instanceof with V_DISPATH
                        return dynamic_cast<C${ cotype }*>(getRealIDispatch(in_val)) ? true : false;
                    ${ optional.case.join(`\n${ " ".repeat(20) }`) }
                    default:
                        return false;
                }
            }

            const HRESULT autoit_opencv_to(I${ cotype }*& in_val, ${ coclass.fqn }& out_val) {
                auto obj = reinterpret_cast<C${ cotype }*>(in_val);
                out_val = *obj->__self->get();
                return S_OK;
            }

            const HRESULT autoit_opencv_to(IDispatch*& in_val, ${ coclass.fqn }& out_val) {
                auto obj = reinterpret_cast<C${ cotype }*>(in_val);
                out_val = *obj->__self->get();
                return S_OK;
            }

            const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ coclass.fqn }& out_val) {
                ${ optional.assign.join(`\n${ " ".repeat(16) }`) }

                if (V_VT(in_val) != VT_DISPATCH) {
                    return E_INVALIDARG;
                }

                auto obj = reinterpret_cast<C${ cotype }*>(getRealIDispatch(in_val));
                out_val = *obj->__self->get();
                return S_OK;
            }

            const HRESULT autoit_opencv_out(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val) {
                if (V_VT(in_val) != VT_DISPATCH) {
                    return E_INVALIDARG;
                }

                auto obj = reinterpret_cast<C${ cotype }*>(getRealIDispatch(in_val));
                out_val = obj->__self->get();
                return S_OK;
            }

            const HRESULT autoit_opencv_out(VARIANT const* const& in_val, I${ cotype }**& out_val) {
                if (V_VT(in_val) != VT_DISPATCH) {
                    return E_INVALIDARG;
                }

                auto obj = reinterpret_cast<I${ cotype }*>(getRealIDispatch(in_val));
                *out_val = obj;
                obj->AddRef();
                return S_OK;
            }

            const HRESULT autoit_opencv_from(I${ cotype }*& in_val, I${ cotype }**& out_val) {
                *out_val = in_val;
                in_val->AddRef();
                return S_OK;
            }

            const HRESULT autoit_opencv_from(I${ cotype }*& in_val, IDispatch**& out_val) {
                *out_val = static_cast<IDispatch*>(in_val);
                in_val->AddRef();
                return S_OK;
            }

            const HRESULT autoit_opencv_from(I${ cotype }*& in_val, VARIANT*& out_val) {
                VariantClear(out_val);
                V_VT(out_val) = VT_DISPATCH;
                V_DISPATCH(out_val) = static_cast<IDispatch*>(in_val);
                in_val->AddRef();
                return S_OK;
            }
            `.replace(/^ {12}/mg, "")
        );

        header.push(`
            extern const bool is_assignable_from(cv::Ptr<${ coclass.fqn }>& out_val, VARIANT const* const& in_val, bool is_optional);
            extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Ptr<${ coclass.fqn }>& out_val);
            extern const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, I${ cotype }**& out_val);
            extern const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, IDispatch**& out_val);
            extern const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, VARIANT*& out_val);
        `.replace(/^ {12}/mg, ""));

        impl.push(`
            const bool is_assignable_from(cv::Ptr<${ coclass.fqn }>& out_val, VARIANT const* const& in_val, bool is_optional) {
                switch (V_VT(in_val)) {
                    case VT_DISPATCH:
                        // TODO : find a better way to check instanceof with V_DISPATH
                        return dynamic_cast<C${ cotype }*>(getRealIDispatch(in_val)) ? true : false;
                    ${ optional.case.join(`\n${ " ".repeat(20) }`) }
                    default:
                        return false;
                }
            }

            const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Ptr<${ coclass.fqn }>& out_val) {
                ${ optional.assign.join(`\n${ " ".repeat(16) }`) }

                if (V_VT(in_val) != VT_DISPATCH) {
                    return E_INVALIDARG;
                }

                auto obj = reinterpret_cast<C${ cotype }*>(getRealIDispatch(in_val));
                out_val.reset(obj->__self->get());

                return S_OK;
            }

            const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, I${ cotype }**& out_val) {
                HRESULT hr = CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(out_val));
                if (SUCCEEDED(hr)) {
                    auto obj = static_cast<C${ cotype }*>(*out_val);
                    obj->__self = new cv::Ptr<${ coclass.fqn }>(in_val);
                }
                return hr;
            }

            const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, IDispatch**& out_val) {
                return autoit_opencv_from(in_val, reinterpret_cast<I${ cotype }**&>(out_val));
            }

            const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, VARIANT*& out_val) {
                I${ cotype }* pdispVal;
                I${ cotype }** ppdispVal = &pdispVal;
                HRESULT hr = autoit_opencv_from(in_val, ppdispVal);
                if (SUCCEEDED(hr)) {
                    VariantClear(out_val);
                    V_VT(out_val) = VT_DISPATCH;
                    V_DISPATCH(out_val) = static_cast<IDispatch*>(*ppdispVal);
                }
                return hr;
            }
            `.replace(/^ {12}/mg, "")
        );

        if (coclass.is_ptr) {
            header.push(`extern const bool is_assignable_from(${ coclass.fqn }*& out_val, VARIANT const* const& in_val, bool is_optional);`);
            header.push(`extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val);`);
            impl.push(`
                const bool is_assignable_from(${ coclass.fqn }*& out_val, VARIANT const* const& in_val, bool is_optional) {
                    switch (V_VT(in_val)) {
                        case VT_DISPATCH:
                            // TODO : find a better way to check instanceof with V_DISPATH
                            return dynamic_cast<C${ cotype }*>(getRealIDispatch(in_val)) ? true : false;
                        ${ optional.case.join(`\n${ " ".repeat(24) }`) }
                        default:
                            return false;
                    }
                }

                const HRESULT autoit_opencv_to(VARIANT const* const& in_val, ${ coclass.fqn }*& out_val) {
                    ${ optional.assign.join(`\n${ " ".repeat(20) }`) }

                    if (V_VT(in_val) != VT_DISPATCH) {
                        return E_INVALIDARG;
                    }

                    auto obj = reinterpret_cast<C${ cotype }*>(getRealIDispatch(in_val));
                    out_val = obj->__self->get();

                    return S_OK;
                }
            `.replace(/^ {16}/mg, ""));
        }

        if (coclass.is_simple || coclass.is_map || coclass.has_copy_constructor || coclass.has_default_constructor) {
            const assign = coclass.has_default_constructor ? "*(*obj->__self) = in_val" : `obj->__self->reset(new ${ coclass.fqn }(in_val))`;

            header.push(`
                extern const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, I${ cotype }**& out_val);
                extern const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, IDispatch**& out_val);
                extern const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, VARIANT*& out_val);
            `.replace(/^ {16}/mg, "").trim());
            impl.push(`
                const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, I${ cotype }**& out_val) {
                    HRESULT hr = CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(out_val));
                    if (SUCCEEDED(hr)) {
                        auto obj = static_cast<C${ cotype }*>(*out_val);
                        ${ assign };
                    }
                    return hr;
                }

                const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, IDispatch**& out_val) {
                    return autoit_opencv_from(in_val, reinterpret_cast<I${ cotype }**&>(out_val));
                }

                const HRESULT autoit_opencv_from(const ${ coclass.fqn }& in_val, VARIANT*& out_val) {
                    I${ cotype }* pdispVal;
                    I${ cotype }** ppdispVal = &pdispVal;
                    HRESULT hr = autoit_opencv_from(in_val, ppdispVal);
                    if (SUCCEEDED(hr)) {
                        VariantClear(out_val);
                        V_VT(out_val) = VT_DISPATCH;
                        V_DISPATCH(out_val) = static_cast<IDispatch*>(*ppdispVal);
                    }
                    return hr;
                }
                `.replace(/^ {16}/mg, "")
            );
        }
    },

    enum: (type, header, impl) => {
        header.push(`
            extern const bool is_assignable_from(${ type }& out_val, LONG& in_val, bool is_optional);
            extern const HRESULT autoit_opencv_to(LONG& in_val, ${ type }& out_val);
        `.replace(/^ {12}/mg, "").trim());

        impl.push(`
            const bool is_assignable_from(${ type }& out_val, LONG& in_val, bool is_optional) {
                return true;
            }

            const HRESULT autoit_opencv_to(LONG& in_val, ${ type }& out_val) {
                out_val = static_cast<${ type }>(in_val);
                return S_OK;
            }
            `.replace(/^ {12}/mg, "")
        );
    }
});
