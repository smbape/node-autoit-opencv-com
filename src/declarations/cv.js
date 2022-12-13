module.exports = [
    ["cv.", "", ["/Properties"], [
        ["_variant_t", "extended", "", ["/R", "/External"]],
        ["cv::core", "core", "", ["/R", "=this"]],
    ], "", ""],

    ["cv.variant", "_variant_t", ["/External"], [
        ["void*", "ptr", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readMat"], [
        ["FileNode", "node", "", []],
        ["Mat", "mat", "", ["/O"]],
        ["Mat", "default_mat", "Mat()", []],
    ], "", ""],

    ["cv.read", "void", ["=readInt"], [
        ["FileNode", "node", "", []],
        ["int", "value", "", ["/O"]],
        ["int", "default_value", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readFloat"], [
        ["FileNode", "node", "", []],
        ["float", "value", "", ["/O"]],
        ["float", "default_value", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readDouble"], [
        ["FileNode", "node", "", []],
        ["double", "value", "", ["/O"]],
        ["double", "default_value", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readString"], [
        ["FileNode", "node", "", []],
        ["String", "value", "", ["/O"]],
        ["String", "default_value", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readKeyPoint"], [
        ["FileNode", "node", "", []],
        ["KeyPoint", "value", "", ["/O"]],
        ["KeyPoint", "default_value", "", []],
    ], "", ""],

    ["cv.read", "void", ["=readDMatch"], [
        ["FileNode", "node", "", []],
        ["DMatch", "value", "", ["/O"]],
        ["DMatch", "default_value", "", []],
    ], "", ""],

    ["cv.format", "string", ["/External"], [
        ["InputArray", "mtx", "", []],
        ["Formatter::FormatType", "fmt", "Formatter::FMT_NUMPY", []],
    ], "", ""],

    ["cv.core.", "", ["/Properties"], [
        ["int", "cv_8U", "", ["/RExpr=CV_8U"]],
        ["int", "cv_8S", "", ["/RExpr=CV_8S"]],
        ["int", "cv_16U", "", ["/RExpr=CV_16U"]],
        ["int", "cv_16S", "", ["/RExpr=CV_16S"]],
        ["int", "cv_32S", "", ["/RExpr=CV_32S"]],
        ["int", "cv_32F", "", ["/RExpr=CV_32F"]],
        ["int", "cv_64F", "", ["/RExpr=CV_64F"]],
        ["int", "cv_16F", "", ["/RExpr=CV_16F"]],

        ["int", "cv_MAT_DEPTH_MASK", "", ["/RExpr=CV_MAT_DEPTH_MASK"]],

        ["int", "cv_8UC1", "", ["/RExpr=CV_8UC1"]],
        ["int", "cv_8UC2", "", ["/RExpr=CV_8UC2"]],
        ["int", "cv_8UC3", "", ["/RExpr=CV_8UC3"]],
        ["int", "cv_8UC4", "", ["/RExpr=CV_8UC4"]],

        ["int", "cv_8SC1", "", ["/RExpr=CV_8SC1"]],
        ["int", "cv_8SC2", "", ["/RExpr=CV_8SC2"]],
        ["int", "cv_8SC3", "", ["/RExpr=CV_8SC3"]],
        ["int", "cv_8SC4", "", ["/RExpr=CV_8SC4"]],

        ["int", "cv_16UC1", "", ["/RExpr=CV_16UC1"]],
        ["int", "cv_16UC2", "", ["/RExpr=CV_16UC2"]],
        ["int", "cv_16UC3", "", ["/RExpr=CV_16UC3"]],
        ["int", "cv_16UC4", "", ["/RExpr=CV_16UC4"]],

        ["int", "cv_16SC1", "", ["/RExpr=CV_16SC1"]],
        ["int", "cv_16SC2", "", ["/RExpr=CV_16SC2"]],
        ["int", "cv_16SC3", "", ["/RExpr=CV_16SC3"]],
        ["int", "cv_16SC4", "", ["/RExpr=CV_16SC4"]],

        ["int", "cv_32SC1", "", ["/RExpr=CV_32SC1"]],
        ["int", "cv_32SC2", "", ["/RExpr=CV_32SC2"]],
        ["int", "cv_32SC3", "", ["/RExpr=CV_32SC3"]],
        ["int", "cv_32SC4", "", ["/RExpr=CV_32SC4"]],

        ["int", "cv_32FC1", "", ["/RExpr=CV_32FC1"]],
        ["int", "cv_32FC2", "", ["/RExpr=CV_32FC2"]],
        ["int", "cv_32FC3", "", ["/RExpr=CV_32FC3"]],
        ["int", "cv_32FC4", "", ["/RExpr=CV_32FC4"]],

        ["int", "cv_64FC1", "", ["/RExpr=CV_64FC1"]],
        ["int", "cv_64FC2", "", ["/RExpr=CV_64FC2"]],
        ["int", "cv_64FC3", "", ["/RExpr=CV_64FC3"]],
        ["int", "cv_64FC4", "", ["/RExpr=CV_64FC4"]],

        ["int", "cv_16FC1", "", ["/RExpr=CV_16FC1"]],
        ["int", "cv_16FC2", "", ["/RExpr=CV_16FC2"]],
        ["int", "cv_16FC3", "", ["/RExpr=CV_16FC3"]],
        ["int", "cv_16FC4", "", ["/RExpr=CV_16FC4"]],
    ], "", ""],

    ["cv.core.cv_MAT_DEPTH", "int", ["/Call=CV_MAT_DEPTH"], [
        ["int", "flags", "", []],
    ], "", ""],

    ["cv.core.cv_MAKETYPE", "int", ["/Call=CV_MAKETYPE"], [
        ["int", "depth", "", []],
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_MAKE_TYPE", "int", ["/Call=CV_MAKE_TYPE"], [
        ["int", "depth", "", []],
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_8UC", "int", ["/Call=CV_8UC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_8SC", "int", ["/Call=CV_8SC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_16UC", "int", ["/Call=CV_16UC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_16SC", "int", ["/Call=CV_16SC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_32SC", "int", ["/Call=CV_32SC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_32FC", "int", ["/Call=CV_32FC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_64FC", "int", ["/Call=CV_64FC"], [
        ["int", "cn", "", []],
    ], "", ""],

    ["cv.core.cv_16FC", "int", ["/Call=CV_16FC"], [
        ["int", "cn", "", []],
    ], "", ""],
];
