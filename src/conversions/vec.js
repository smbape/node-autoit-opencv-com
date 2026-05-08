/* eslint-disable no-magic-numbers */

const optional = require("../optional_conversion");

module.exports = (header = [], impl = [], options = {}) => {
    header.push(`
        template<typename _Tp, int cn>
        const bool is_assignable_from(cv::Vec<_Tp, cn>& out_val, VARIANT const* in_val, bool is_optional) {
            ${ optional.check.join(`\n${ " ".repeat(12) }`) }

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
        inline const bool is_assignable_from(AUTOIT_PTR<cv::Vec<_Tp, cn>>& out_val, VARIANT const* in_val, bool is_optional) {
            static cv::Vec<_Tp, cn> tmp;
            return is_assignable_from(tmp, in_val, is_optional);
        }

        template<typename _Tp, int cn>
        const HRESULT autoit_to(VARIANT const* in_val, cv::Vec<_Tp, cn>& out_val) {
            ${ optional.assign.join(`\n${ " ".repeat(12) }`) }

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
        inline const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::Vec<_Tp, cn>>& out_val) {
            out_val = ${ options.make_shared }<cv::Vec<_Tp, cn>>();
            return autoit_to(in_val, *out_val.get());
        }

        template<typename _Tp, int cn>
        const HRESULT autoit_from(cv::Vec<_Tp, cn> const& in_val, VARIANT*& out_val) {
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
                    AUTOIT_ERROR("Failed to get value a index " << i);
                    VariantClear(&value);
                    break;
                }

                hr = vArray.SetAt(i, value);
                if (FAILED(hr)) {
                    AUTOIT_ERROR("Failed to set value a index " << i);
                    VariantClear(&value);
                    break;
                }

                VariantClear(&value);
            }

            vArray.Detach();
            return hr;
        }
        `.replace(/^ {8}/mg, "")
    );

    return [header.join("\n"), impl.join("\n")];
};
