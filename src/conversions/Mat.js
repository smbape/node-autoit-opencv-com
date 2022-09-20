const Point = "cv::Point";

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
            [Point, "pt", "", []],
        ],
    ]) {
        const argdecl = args.map(([argtype, argname]) => `${ argtype }${ argtype === Point ? "&" : "" } ${ argname }`).join(", ");
        const argexpr = args.map(([, argname]) => argname).join(", ");

        impl.push(`
            const cv::Point2d CCv_Mat_Object::Point_at(${ argdecl }, HRESULT& hr) {
                using namespace cv;
                const auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    return Point2d(m.at<Vec2b>(${ argexpr })[0], m.at<Vec2b>(${ argexpr })[1]);
                case CV_8S:
                    return Point2d(m.at<Vec<char, 2>>(${ argexpr })[0], m.at<Vec<char, 2>>(${ argexpr })[1]);
                case CV_16U:
                    return Point2d(m.at<Vec2w>(${ argexpr })[0], m.at<Vec2w>(${ argexpr })[1]);
                case CV_16S:
                    return Point2d(m.at<Vec2s>(${ argexpr })[0], m.at<Vec2s>(${ argexpr })[1]);
                case CV_32S:
                    return Point2d(m.at<Vec2i>(${ argexpr })[0], m.at<Vec2i>(${ argexpr })[1]);
                case CV_32F:
                    return Point2d(m.at<Vec2f>(${ argexpr })[0], m.at<Vec2f>(${ argexpr })[1]);
                case CV_64F:
                    return Point2d(m.at<Vec2d>(${ argexpr })[0], m.at<Vec2d>(${ argexpr })[1]);
                default:
                    hr = E_INVALIDARG;
                    return Point2d();
                }
            }

            const double CCv_Mat_Object::at(${ argdecl }, HRESULT& hr) {
                const auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    return m.at<uchar>(${ argexpr });
                case CV_8S:
                    return m.at<char>(${ argexpr });
                case CV_16U:
                    return m.at<ushort>(${ argexpr });
                case CV_16S:
                    return m.at<short>(${ argexpr });
                case CV_32S:
                    return m.at<int>(${ argexpr });
                case CV_32F:
                    return m.at<float>(${ argexpr });
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
                    m.at<uchar>(${ argexpr }) = static_cast<uchar>(value);
                    break;
                case CV_8S:
                    m.at<char>(${ argexpr }) = static_cast<char>(value);
                    break;
                case CV_16U:
                    m.at<ushort>(${ argexpr }) = static_cast<ushort>(value);
                    break;
                case CV_16S:
                    m.at<short>(${ argexpr }) = static_cast<short>(value);
                    break;
                case CV_32S:
                    m.at<int>(${ argexpr }) = static_cast<int>(value);
                    break;
                case CV_32F:
                    m.at<float>(${ argexpr }) = static_cast<float>(value);
                    break;
                case CV_64F:
                    m.at<double>(${ argexpr }) = value;
                    break;
                default:
                    hr = E_INVALIDARG;
                }
            }

        `.trim().replace(/^ {12}/mg, ""));
    }

    return [header.join("\n"), impl.join("\n")];
};
