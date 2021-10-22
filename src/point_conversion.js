/* eslint-disable no-magic-numbers */

const optional = require("./optional_conversion");

module.exports = (header = [], impl = []) => {
    header.push("template<typename _Tp>");
    header.push("extern const bool is_assignable_from(cv::Point_<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional);");
    header.push(`
        template<typename _Tp>
        const bool is_assignable_from(cv::Point_<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
            ${ optional.check.join(`\n${ " ".repeat(12) }`) }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return false;
            }

            cv::Point_<_Tp> dummy;
            return SUCCEEDED(autoit_opencv_to(in_val, dummy));
        }`.replace(/^ {8}/mg, "")
    );

    header.push("template<typename _Tp>");
    header.push("extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Point_<_Tp>& out_val);");
    header.push(`
        template<typename _Tp>
        const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::Point_<_Tp>& out_val) {
            ${ optional.assign.join(`\n${ " ".repeat(12) }`) }

            if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(in_val));

            LONG lLower = vArray.GetLowerBound();
            LONG lUpper = vArray.GetUpperBound();

            _Tp value;

            for (LONG i = lLower; i <= lUpper && (i - lLower) < 4; i++) {
                auto& v = vArray.GetAt(i);
                VARIANT *pv = &v;
                hr = autoit_opencv_to(pv, value);
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
        }`.replace(/^ {8}/mg, "")
    );

    header.push("template<typename _Tp>");
    header.push("extern const HRESULT autoit_opencv_from(const cv::Point_<_Tp>& in_val, VARIANT*& out_val);");
    header.push(`
        template<typename _Tp>
        const HRESULT autoit_opencv_from(const cv::Point_<_Tp>& in_val, VARIANT*& out_val) {
            if (${ optional.condition("out_val") }) {
                V_VT(out_val) = VT_ARRAY | VT_VARIANT;
                CComSafeArray<VARIANT> vArray((ULONG) 2);
                V_ARRAY(out_val) = vArray.Detach();
            }

            if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
                return E_INVALIDARG;
            }

            HRESULT hr = S_OK;

            CComSafeArray<VARIANT> vArray;
            vArray.Attach(V_ARRAY(out_val));
            vArray.Resize(2);

            for (LONG i = 0; i < 2; i++) {
                VARIANT value = { VT_EMPTY };
                auto *pvalue = &value;

                switch (i) {
                    case 0:
                        hr = autoit_opencv_from(in_val.x, pvalue);
                        break;
                    case 1:
                        hr = autoit_opencv_from(in_val.y, pvalue);
                        break;
                }

                if (FAILED(hr)) {
                    VariantClear(&value);
                    break;
                }

                vArray.SetAt(i, value);
                VariantClear(&value);
            }

            vArray.Detach();
            return hr;
        }
        `.replace(/^ {8}/mg, "")
    );

    return [header.join("\n"), impl.join("\n")];
};
