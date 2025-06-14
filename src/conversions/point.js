/* eslint-disable no-magic-numbers */

const optional = require("../optional_conversion");

module.exports = (header = [], impl = [], options = {}) => {
    header.push(`
        template<typename _Tp>
        const bool is_assignable_from(cv::Point_<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
            ${ optional.check.join(`\n${ " ".repeat(12) }`) }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return false;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(in_val));

            LONG lLower = vArray.GetLowerBound();
            LONG lUpper = vArray.GetUpperBound();

            if (lUpper - lLower >= 2) {
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

        template<typename _Tp>
        inline const bool is_assignable_from(AUTOIT_PTR<cv::Point_<_Tp>>& out_val, VARIANT const* const& in_val, bool is_optional) {
            static cv::Point_<_Tp> tmp;
            return is_assignable_from(tmp, in_val, is_optional);
        }

        template<typename _Tp>
        const HRESULT autoit_to(VARIANT const* const& in_val, cv::Point_<_Tp>& out_val) {
            ${ optional.assign.join(`\n${ " ".repeat(12) }`) }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(in_val));

            LONG lLower = vArray.GetLowerBound();
            LONG lUpper = vArray.GetUpperBound();

            if (lUpper - lLower >= 2) {
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

                switch (i) {
                    case 0:
                        out_val.x = value;
                        break;
                    case 1:
                        out_val.y = value;
                        break;
                }
            }

            vArray.Detach();
            return hr;
        }

        template<typename _Tp>
        inline const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<cv::Point_<_Tp>>& out_val) {
            out_val = ${ options.make_shared }<cv::Point_<_Tp>>();
            return autoit_to(in_val, *out_val.get());
        }

        template<typename _Tp>
        const HRESULT autoit_from(cv::Point_<_Tp> const& in_val, VARIANT*& out_val) {
            if (${ optional.condition("out_val") }) {
                V_VT(out_val) = VT_ARRAY | VT_VARIANT;
                typename ATL::template CComSafeArray<VARIANT> vArray((ULONG) 2);
                V_ARRAY(out_val) = vArray.Detach();
            }

            if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            typename ATL::template CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(out_val));
            vArray.Resize(2);

            for (LONG i = 0; i < 2; i++) {
                VARIANT value = { VT_EMPTY };
                auto *pvalue = &value;

                switch (i) {
                    case 0:
                        hr = autoit_from(in_val.x, pvalue);
                        break;
                    case 1:
                        hr = autoit_from(in_val.y, pvalue);
                        break;
                }

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
