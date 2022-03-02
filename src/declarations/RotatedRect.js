module.exports = [
    ["class cv.RotatedRect", "", ["/Simple"], [
        ["Point2f", "center", "", ["/RW"]],
        ["Size2f", "size", "", ["/RW"]],
        ["float", "angle", "", ["/RW"]],
    ], "", ""],

    ["cv.RotatedRect.RotatedRect", "", [], [], "", ""],

    ["cv.RotatedRect.RotatedRect", "", [], [
        ["Point2f", "center", "", []],
        ["Size2f", "size", "", []],
        ["float", "angle", "", []],
    ], "", ""],

    ["cv.RotatedRect.RotatedRect", "", [], [
        ["Point2f", "point1", "", []],
        ["Point2f", "point2", "", []],
        ["Point2f", "point3", "", []],
    ], "", ""],

    ["cv.RotatedRect.boundingRect", "Rect", [], [], "", ""],

];
