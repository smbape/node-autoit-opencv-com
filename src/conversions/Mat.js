module.exports = (header = [], impl = [], options = {}) => {
    impl.push(`
        #include "Cv_Mat_Object.h"
    `.trim().replace(/^ {8}/mg, ""));

    impl.push("");

    for (const args of [
        [
            ["int", "i0", "", []],
        ],
        [
            ["int", "row", "", []],
            ["int", "col", "", []],
        ],
        [
            ["int", "i0", "", []],
            ["int", "i1", "", []],
            ["int", "i2", "", []],
        ],
        [
            ["cv::Point", "pt", "", []],
        ],
        [
            ["std::vector<int>", "idx", "", ["/Ref", "/C", "/Expr=idx.data()"]]
        ],
    ]) {
        const argdecl = args.map(([argtype, argname]) => `${ argtype === "std::vector<int>" ? "const " : "" }${ argtype }${ argtype !== "int" ? "&" : "" } ${ argname }`).join(", ");
        const argexpr = args.map(([, callarg, , arg_modifiers]) => {
            for (const modifier of arg_modifiers) {
                if (modifier.startsWith("/Expr=")) {
                    callarg = modifier.slice("/Expr=".length);
                }
            }
            return callarg;
        }).join(", ");

        impl.push(`
            const cv::Point2d CCv_Mat_Object::Point_at(${ argdecl }, HRESULT& hr) {
                using namespace cv;
                const auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    return Point2d(m.at<Vec<uint8_t, 2>>(${ argexpr })[0], m.at<Vec<uint8_t, 2>>(${ argexpr })[1]);
                case CV_8S:
                    return Point2d(m.at<Vec<int8_t, 2>>(${ argexpr })[0], m.at<Vec<int8_t, 2>>(${ argexpr })[1]);
                case CV_16U:
                    return Point2d(m.at<Vec<uint16_t, 2>>(${ argexpr })[0], m.at<Vec<uint16_t, 2>>(${ argexpr })[1]);
                case CV_16S:
                    return Point2d(m.at<Vec<int16_t, 2>>(${ argexpr })[0], m.at<Vec<int16_t, 2>>(${ argexpr })[1]);
                case CV_16F:
                    return Point2d(static_cast<float>(m.at<Vec<cv::hfloat, 2>>(${ argexpr })[0]), static_cast<float>(m.at<Vec<cv::hfloat, 2>>(${ argexpr })[1]));
                case CV_16BF:
                    return Point2d(static_cast<float>(m.at<Vec<cv::bfloat, 2>>(${ argexpr })[0]), static_cast<float>(m.at<Vec<cv::bfloat, 2>>(${ argexpr })[1]));
                case CV_32U:
                    return Point2d(m.at<Vec<uint32_t, 2>>(${ argexpr })[0], m.at<Vec<uint32_t, 2>>(${ argexpr })[1]);
                case CV_32S:
                    return Point2d(m.at<Vec<int32_t, 2>>(${ argexpr })[0], m.at<Vec<int32_t, 2>>(${ argexpr })[1]);
                case CV_32F:
                    return Point2d(m.at<Vec<float, 2>>(${ argexpr })[0], m.at<Vec<float, 2>>(${ argexpr })[1]);
                case CV_64U:
                    return Point2d(m.at<Vec<uint64_t, 2>>(${ argexpr })[0], m.at<Vec<uint64_t, 2>>(${ argexpr })[1]);
                case CV_64S:
                    return Point2d(m.at<Vec<int64_t, 2>>(${ argexpr })[0], m.at<Vec<int64_t, 2>>(${ argexpr })[1]);
                case CV_64F:
                    return Point2d(m.at<Vec<double, 2>>(${ argexpr })[0], m.at<Vec<double, 2>>(${ argexpr })[1]);
                default:
                    hr = E_INVALIDARG;
                    return Point2d();
                }
            }

            const double CCv_Mat_Object::at(${ argdecl }, HRESULT& hr) {
                const auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    return m.at<uint8_t>(${ argexpr });
                case CV_8S:
                    return m.at<int8_t>(${ argexpr });
                case CV_16U:
                    return m.at<uint16_t>(${ argexpr });
                case CV_16S:
                    return m.at<int16_t>(${ argexpr });
                case CV_16F:
                    return static_cast<float>(m.at<cv::hfloat>(${ argexpr }));
                case CV_16BF:
                    return static_cast<float>(m.at<cv::bfloat>(${ argexpr }));
                case CV_32U:
                    return m.at<uint32_t>(${ argexpr });
                case CV_32S:
                    return m.at<int32_t>(${ argexpr });
                case CV_32F:
                    return m.at<float>(${ argexpr });
                case CV_64U:
                    return m.at<uint64_t>(${ argexpr });
                case CV_64S:
                    return m.at<int64_t>(${ argexpr });
                case CV_64F:
                    return m.at<double>(${ argexpr });
                default:
                    hr = E_INVALIDARG;
                    return 0;
                }
            }

            void CCv_Mat_Object::set_at(${ argdecl }, double value, HRESULT& hr) {
                auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    m.at<uint8_t>(${ argexpr }) = static_cast<uint8_t>(value);
                    break;
                case CV_8S:
                    m.at<int8_t>(${ argexpr }) = static_cast<int8_t>(value);
                    break;
                case CV_16U:
                    m.at<uint16_t>(${ argexpr }) = static_cast<uint16_t>(value);
                    break;
                case CV_16S:
                    m.at<int16_t>(${ argexpr }) = static_cast<int16_t>(value);
                    break;
                case CV_16F:
                    m.at<cv::hfloat>(${ argexpr }) = static_cast<cv::hfloat>(value);
                    break;
                case CV_16BF:
                    m.at<cv::bfloat>(${ argexpr }) = static_cast<cv::bfloat>(value);
                    break;
                case CV_32U:
                    m.at<uint32_t>(${ argexpr }) = static_cast<uint32_t>(value);
                    break;
                case CV_32S:
                    m.at<int32_t>(${ argexpr }) = static_cast<int32_t>(value);
                    break;
                case CV_32F:
                    m.at<float>(${ argexpr }) = static_cast<float>(value);
                    break;
                case CV_64U:
                    m.at<uint64_t>(${ argexpr }) = static_cast<uint64_t>(value);
                    break;
                case CV_64S:
                    m.at<int64_t>(${ argexpr }) = static_cast<int64_t>(value);
                    break;
                case CV_64F:
                    m.at<double>(${ argexpr }) = static_cast<double>(value);
                    break;
                default:
                    hr = E_INVALIDARG;
                }
            }

        `.trim().replace(/^ {12}/mg, ""), "");
    }

    return [header.join("\n"), impl.join("\n")];
};
