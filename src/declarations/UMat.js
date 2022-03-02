module.exports = [
    ["class cv.UMat", "", ["/Simple"], [
        ["int", "rows", "", ["/RW"]],
        ["int", "cols", "", ["/RW"]],
        ["int", "dims", "", ["/RW"]],
        ["size_t", "step", "", ["/RW"]],
        ["int", "width", "", ["/RW", "=cols"]],
        ["int", "height", "", ["/RW", "=rows"]]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMat", "m", "", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.UMat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
        ["UMatUsageFlags", "usageFlags", "cv::USAGE_DEFAULT", []]
    ], "", ""],

    ["cv.UMat.getMat", "Mat", [], [
        ["int", "access", "", ["/Cast=static_cast<cv::AccessFlag>"]]
    ], "", ""],
];
