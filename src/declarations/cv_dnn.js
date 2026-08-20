module.exports = [
    ["cv.dnn.blobFromImage", "void", [], [
        ["InputArray", "image", "", []],
        ["OutputArray", "blob", "", []],
        ["double", "scalefactor", "1.0", []],
        ["Size", "size", "Size()", ["/C", "/Ref"]],
        ["Scalar", "mean", "Scalar()", ["/C", "/Ref"]],
        ["bool", "swapRB", "false", []],
        ["bool", "crop", "false", []],
        ["int", "ddepth", "CV_32F", []],
    ], "void", ""],

    ["cv.dnn.blobFromImages", "void", [], [
        ["InputArrayOfArrays", "images", "", []],
        ["OutputArray", "blob", "", []],
        ["double", "scalefactor", "1.0", []],
        ["Size", "size", "Size()", ["/C", "/Ref"]],
        ["Scalar", "mean", "Scalar()", ["/C", "/Ref"]],
        ["bool", "swapRB", "false", []],
        ["bool", "crop", "false", []],
        ["int", "ddepth", "CV_32F", []],
    ], "void", ""],
];
