module.exports = [
    ["class cv.RNG", "", ["/Simple", "/Ptr"], [
        ["uint64", "state", "", ["/RW"]],
    ], "", ""],
    ["cv.RNG.RNG", "", [], [], "", ""],
    ["cv.RNG.RNG", "", [], [
        ["uint64", "state", "", []]
    ], "", ""],
    ["cv.RNG.next", "uint", [], [], "", ""],
    ["cv.RNG.uniform", "int", ["=uniform_int"], [
        ["int", "a", "", []],
        ["int", "b", "", []],
    ], "", ""],
    ["cv.RNG.uniform", "float", ["=uniform_float"], [
        ["float", "a", "", []],
        ["float", "b", "", []],
    ], "", ""],
    ["cv.RNG.uniform", "double", ["=uniform_double"], [
        ["double", "a", "", []],
        ["double", "b", "", []],
    ], "", ""],
    ["cv.RNG.uniform", "double", [], [
        ["double", "a", "", []],
        ["double", "b", "", []],
    ], "", ""],
    ["cv.theRNG", "cv::Ptr<RNG>", ["/S", "/Ref", "/WrapAs=::autoit::reference_internal"], [], "", ""],
];
