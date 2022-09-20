/* eslint-disable no-magic-numbers */

const optional = require("../optional_conversion");

module.exports = (header = [], impl = [], options = {}) => {
    header.push(`
        template<typename _Tp, int cn>
        const bool is_assignable_from(cv::Vec<_Tp, cn>& out_val, VARIANT const* const& in_val, bool is_optional) {
            ${ optional.check.join(`\n${ " ".repeat(12) }`) }

            // a number can be a Scalar .i.e. Vec4d
            if (cn == 4 && std::is_same<_Tp, double>::value) {
                switch (V_VT(in_val)) {
                    case VT_I1:
                    case VT_I2:
                    case VT_I4:
                    case VT_I8:
                    case VT_INT:
                    case VT_R4:
                    case VT_R8:
                        return true;
                }
            }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return false;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(in_val));

            LONG lLower = vArray.GetLowerBound();
            LONG lUpper = vArray.GetUpperBound();

            if (lUpper - lLower >= cn) {
                vArray.Detach();
                return false;
            }

            _Tp value;

            for (LONG i = lLower; i <= lUpper; i++) {
                auto& v = vArray.GetAt(i);
                VARIANT *pv = &v;
                if (!is_assignable_from(value, pv, false)) {
                    hr = E_INVALIDARG;
                    break;
                }
            }

            vArray.Detach();
            return SUCCEEDED(hr);
        }

        template<typename _Tp, int cn>
        const bool is_assignable_from(cv::Ptr<cv::Vec<_Tp, cn>>& out_val, VARIANT const* const& in_val, bool is_optional) {
            static cv::Vec<_Tp, cn> tmp;
            return is_assignable_from(tmp, in_val, is_optional);
        }

        template<typename _Tp, int cn>
        const HRESULT autoit_to(VARIANT const* const& in_val, cv::Vec<_Tp, cn>& out_val) {
            ${ optional.assign.join(`\n${ " ".repeat(12) }`) }

            // a number can be a Scalar .i.e. Vec4d
            if (cn == 4 && std::is_same<_Tp, double>::value) {
                switch (V_VT(in_val)) {
                    case VT_I1:
                        out_val.val[0] = static_cast<_Tp>(V_I1(in_val));
                        return S_OK;
                    case VT_I2:
                        out_val.val[0] = static_cast<_Tp>(V_I2(in_val));
                        return S_OK;
                    case VT_I4:
                        out_val.val[0] = static_cast<_Tp>(V_I4(in_val));
                        return S_OK;
                    case VT_I8:
                        out_val.val[0] = static_cast<_Tp>(V_I8(in_val));
                        return S_OK;
                    case VT_INT:
                        out_val.val[0] = static_cast<_Tp>(V_INT(in_val));
                        return S_OK;
                    case VT_R4:
                        out_val.val[0] = static_cast<_Tp>(V_R4(in_val));
                        return S_OK;
                    case VT_R8:
                        out_val.val[0] = static_cast<_Tp>(V_R8(in_val));
                        return S_OK;
                }
            }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(in_val));

            LONG lLower = vArray.GetLowerBound();
            LONG lUpper = vArray.GetUpperBound();

            if (lUpper - lLower >= cn) {
                vArray.Detach();
                return E_INVALIDARG;
            }

            _Tp value;

            for (LONG i = lLower; i <= lUpper; i++) {
                auto& v = vArray.GetAt(i);
                VARIANT *pv = &v;
                hr = autoit_to(pv, value);
                if (FAILED(hr)) {
                    break;
                }
                out_val.val[i - lLower] = value;
            }

            vArray.Detach();
            return hr;
        }

        template<typename _Tp, int cn>
        const HRESULT autoit_to(VARIANT const* const& in_val, cv::Ptr<cv::Vec<_Tp, cn>>& out_val) {
            out_val = std::make_shared<cv::Vec<_Tp, cn>>();
            return autoit_to(in_val, *out_val.get());
        }

        template<typename _Tp, int cn>
        const HRESULT autoit_from(const cv::Vec<_Tp, cn>& in_val, VARIANT*& out_val) {
            if (${ optional.condition("out_val") }) {
                V_VT(out_val) = VT_ARRAY | VT_VARIANT;
                typename ATL::template CComSafeArray<VARIANT> vArray((ULONG) cn);
                V_ARRAY(out_val) = vArray.Detach();
            }

            if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(out_val));
            vArray.Resize(cn);

            for (LONG i = 0; i < cn; i++) {
                VARIANT value = { VT_EMPTY };
                auto *pvalue = &value;
                HRESULT hr = autoit_from(in_val[i], pvalue);
                if (FAILED(hr)) {
                    VariantClear(&value);
                    break;
                }
                AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(i, value)), "Failed to set value a index " << i);
                VariantClear(&value);
            }

            vArray.Detach();
            return hr;
        }
        `.replace(/^ {8}/mg, "")
    );

    return [header.join("\n"), impl.join("\n")];
};
