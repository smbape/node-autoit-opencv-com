module.exports = ({ shared_ptr }) => [
    ["class cv.UMat", "", ["/Simple"], [
        // Public Attributes

        ["int", "cols", "", ["/RW"]],
        ["int", "dims", "", ["/RW"]],
        ["int", "flags", "", ["/RW"]],
        ["int", "rows", "", ["/RW"]],
        ["size_t", "step", "", ["/RW"]],

        // Custom Attributes

        ["int", "width", "", ["/RW", "=cols"]],
        ["int", "height", "", ["/RW", "=rows"]],
        ["std::tuple<int, int, int>", "shape", "", ["/R", "/RExpr=std::tuple<int, int, int>(__self->get()->rows, __self->get()->cols, __self->get()->channels())"]],
        ["std::vector<int>", "sizes", "", ["/R", "/RExpr=std::vector<int>(__self->get()->size.p, __self->get()->size.p + __self->get()->dims)"]],
        ["std::vector<size_t>", "steps", "", ["/R", "/RExpr=std::vector<size_t>(__self->get()->step.p, __self->get()->step.p + __self->get()->dims)"]],
    ], "", ""],

    // Public Member Functions

    ["cv.UMat.UMat", "", [], [
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", ["/Ref", "/C"]],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", ["/Ref", "/C"]],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
        ["int", "type", "", []],
        ["Scalar", "s", "", ["/Ref", "/C"]],
        ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
        ["Range", "rowRange", "", ["/Ref", "/C"]],
        ["Range", "colRange", "Range::all()", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
        ["Rect", "roi", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
        ["std::vector<Range>", "ranges", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.UMat", "", ["/Expr=$0, true"], [
        ["std::vector<double>", "vec", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.UMat", "", ["/Expr=$0, true"], [
        ["std::vector<int>", "vec", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.addref", "void", [], [], "", ""],

    ["cv.UMat.adjustROI", `${ shared_ptr }<UMat>`, ["/Ref", "/WrapAs=::autoit::reference_internal"], [
        ["int", "dtop", "", []],
        ["int", "dbottom", "", []],
        ["int", "dleft", "", []],
        ["int", "dright", "", []],
    ], "", ""],

    ["cv.UMat.assignTo", "void", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
        ["int", "type", "-1", []],
    ], "", ""],

    ["cv.UMat.channels", "int", [], [], "", ""],

    ["cv.UMat.checkVector", "int", [], [
        ["int", "elemChannels", "", []],
        ["int", "depth", "-1", []],
        ["int", "requireContinuous", "true", []],
    ], "", ""],

    ["cv.UMat.clone", "UMat", [], [], "", ""],
    ["cv.UMat.clone", "UMat", ["=copy"], [], "", ""],

    ["cv.UMat.col", "UMat", [], [
        ["int", "x", "", []],
    ], "", ""],

    ["cv.UMat.colRange", "UMat", [], [
        ["int", "startcol", "", []],
        ["int", "endcol", "__self->get()->cols", []],
    ], "", ""],
    ["cv.UMat.colRange", "UMat", [], [
        ["Range", "r", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.convertTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["int", "rtype", "", []],
        ["double", "alpha", "1.0", []],
        ["double", "beta", "0.0", []],
    ], "", ""],
    ["cv.UMat.convertTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["int", "rtype", "-1", []],
        ["double", "alpha", "1.0", []],
        ["double", "beta", "0.0", []],
    ], "", ""],

    ["cv.UMat.copySize", "void", [], [
        ["UMat", "m", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
    ], "", ""],

    ["cv.UMat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["InputArray", "mask", "", []],
    ], "", ""],

    ["cv.UMat.depth", "int", [], [], "", ""],

    ["cv.UMat.diag", "UMat", [], [
        ["int", "d", "0", []],
    ], "", ""],

    ["cv.UMat.dot", "double", [], [
        ["InputArray", "m", "", []],
    ], "", ""],

    ["cv.UMat.elemSize", "size_t", [], [], "", ""],
    ["cv.UMat.elemSize1", "size_t", [], [], "", ""],
    ["cv.UMat.empty", "bool", [], [], "", ""],

    ["cv.UMat.getMat", "Mat", [], [
        ["AccessFlag", "flags", "", []]
    ], "", ""],

    ["cv.UMat.handle", "void*", [], [
        ["AccessFlag", "acessFlag", "", []]
    ], "", ""],

    ["cv.UMat.isContinuous", "bool", [], [], "", ""],
    ["cv.UMat.isSubmatrix", "bool", [], [], "", ""],

    ["cv.UMat.locateROI", "void", [], [
        ["Size", "wholeSize", "", ["/O", "/Ref"]],
        ["Point", "ofs", "", ["/O", "/Ref"]],
    ], "", ""],

    ["cv.UMat.mul", "UMat", [], [
        ["InputArray", "m", "", []],
        ["double", "scale", "1", []],
    ], "", ""],

    ["cv.UMat.ndoffset", "void", [], [
        ["size_t*", "ofs", "", ["/O"]],
    ], "", ""],

    ["cv.UMat.release", "void", [], [], "", ""],

    ["cv.UMat.reshape", "UMat", [], [
        ["int", "cn", "", []],
        ["int", "rows", "0", []],
    ], "", ""],

    ["cv.UMat.reshape", "UMat", [], [
        ["int", "cn", "", []],
        ["std::vector<int>", "newshape", "", ["/Ref", "/C", "/Expr=newshape.size(), newshape.data()"]],
    ], "", ""],

    ["cv.UMat.row", "UMat", [], [
        ["int", "y", "", []],
    ], "", ""],
    ["cv.UMat.rowRange", "UMat", [], [
        ["int", "startrow", "", []],
        ["int", "endrow", "__self->get()->rows", []],
    ], "", ""],
    ["cv.UMat.rowRange", "UMat", [], [
        ["Range", "r", "", []],
    ], "", ""],

    ["cv.UMat.setTo", "void", [], [
        ["InputArray", "value", "", []],
        ["InputArray", "mask", "noArray()", []],
    ], "", ""],

    ["cv.UMat.size", "Size", [], [], "", ""],

    ["cv.UMat.step1", "size_t", [], [
        ["int", "i", "0", []]
    ], "", ""],

    ["cv.UMat.t", "UMat", [], [], "", ""],
    ["cv.UMat.total", "size_t", [], [], "", ""],
    ["cv.UMat.type", "int", [], [], "", ""],
    ["cv.UMat.updateContinuityFlag", "void", [], [], "", ""],

    // Static Public Member Functions

    ["cv.UMat.diag", "UMat", ["/S"], [
        ["UMat", "d", "", ["/Ref", "/C"]],
        ["UMatUsageFlags", "usageFlags", "", []],
    ], "", ""],

    ["cv.UMat.diag", "UMat", ["/S"], [
        ["UMat", "d", "", ["/Ref", "/C"]],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "rows", "", ["/Expr=rows, rows"]],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "cols", "", ["/Expr=cols, cols"]],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "rows", "", ["/Expr=rows, rows"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["int", "cols", "", ["/Expr=cols, cols"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.eye", "UMat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.ones", "UMat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.ones", "UMat", ["/S"], [
        ["int", "cols", "", ["/Expr=1, cols"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.ones", "UMat", ["/S"], [
        ["int", "rows", "", ["/Expr=rows, 1"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.ones", "UMat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.ones", "UMat", ["/S"], [
        ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.zeros", "UMat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.zeros", "UMat", ["/S"], [
        ["int", "cols", "", ["/Expr=1, cols"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.zeros", "UMat", ["/S"], [
        ["int", "rows", "", ["/Expr=rows, 1"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.zeros", "UMat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.UMat.zeros", "UMat", ["/S"], [
        ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
        ["int", "type", "", []],
    ], "", ""],

    // Extended Functions

    ["cv.UMat.convertToShow", "void", ["/Call=::autoit::cvextra::convertToShow", "/Expr=*__self->get(), $0"], [
        ["Mat", "dst", "Mat::zeros(__self->get()->rows, __self->get()->cols, CV_8UC3)", ["/IO"]],
        ["bool", "toRGB", "false", []],
    ], "", ""],
    ["cv.UMat.convertToBitmap", "void*", ["/Call=::autoit::cvextra::convertToBitmap", "/Expr=*__self->get(), $0"], [
        ["bool", "copy", "true", []],
    ], "", ""],
    ["cv.UMat.GdiplusResize", "void", ["/Call=::autoit::cvextra::GdiplusResize", "/Expr=*__self->get(), $0"], [
        ["Mat", "dst", "", ["/O"]],
        ["float", "newWidth", "", []],
        ["float", "newHeight", "", []],
        ["int", "interpolation", "7", []],
    ], "", ""],

];
