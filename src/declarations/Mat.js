const declarations = [
    ["class cv.Mat", "", ["/Simple", "/DC"], [
        ["int", "flags", "", ["/R"]],
        ["int", "dims", "", ["/R"]],
        ["int", "rows", "", ["/R"]],
        ["int", "cols", "", ["/R"]],
        ["uchar*", "data", "", ["/R"]],
        ["size_t", "step", "", ["/R"]],
        ["int", "width", "", ["/R", "=cols"]],
        ["int", "height", "", ["/R", "=rows"]]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["void*", "data", "", []],
        ["size_t", "step", "cv::Mat::AUTO_STEP", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "m", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "src", "", []],
        ["Rect", "roi", "", []]
    ], "", ""],

    ["cv.Mat.isContinuous", "bool", [], [], "", ""],
    ["cv.Mat.isSubmatrix", "bool", [], [], "", ""],
    ["cv.Mat.depth", "int", [], [], "", ""],
    ["cv.Mat.size", "Size", [], [], "", ""],
    ["cv.Mat.type", "int", [], [], "", ""],
    ["cv.Mat.empty", "bool", [], [], "", ""],
    ["cv.Mat.channels", "int", [], [], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "y", "0", []]
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
        ["int", "i2", "", []],
    ], "", ""],
    ["cv.Mat.pop_back", "void", [], [
        ["size_t", "value", "", []]
    ], "", ""],
    ["cv.Mat.push_back", "void", [], [
        ["Mat", "value", "", []]
    ], "", ""],
    ["cv.Mat.total", "size_t", [], [], "", ""],
    ["cv.Mat.clone", "Mat", [], [], "", ""],
    ["cv.Mat.elemSize", "size_t", [], [], "", ""],
    ["cv.Mat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["InputArray", "mask", "", []],
    ], "", ""],
    ["cv.Mat.setTo", "void", [], [
        ["InputArray", "value", "", []],
        ["InputArray", "mask", "noArray()", []],
    ], "", ""],
    ["cv.Mat.convertTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["int", "rtype", "", []],
        ["double", "alpha", "1.0", []],
        ["double", "beta", "0.0", []],
    ], "", ""],
    ["cv.Mat.reshape", "cv::Mat", [], [
        ["int", "cn", "", []],
        ["int", "rows", "0", []],
    ], "", ""],
    ["cv.Mat.dot", "double", [], [
        ["InputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.cross", "Mat", [], [
        ["InputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.diag", "cv::Mat", [], [
        ["int", "d", "0", []],
    ], "", ""],
    ["cv.Mat.t", "cv::Mat", [], [], "", ""],

    ["cv.Mat.eye", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],
];

for (const type of ["int", "float", "double", "Vec3b", "Vec4b"]) {
    declarations.push(...[
        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["int", "x", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(x) = value"], [
            ["int", "x", "", []],
            [type, "value", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["int", "x", "", []],
            ["int", "y", "", []]
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(x, y) = value"], [
            ["int", "x", "", []],
            ["int", "y", "", []],
            [type, "value", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["Point", "pt", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(pt) = value"], [
            ["Point", "pt", "", []],
            [type, "value", "", []],
        ], "", ""],
    ]);
}

module.exports = declarations;
