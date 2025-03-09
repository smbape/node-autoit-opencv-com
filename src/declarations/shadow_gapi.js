module.exports = [
    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L6-L12
    ["struct cv.GCompileArg", "", ["/Simple"], [], "", ""],

    ["cv.GCompileArg.GCompileArg", "", [], [
        ["cv::GKernelPackage", "arg", "", []],
    ], "", ""],

    ["cv.GCompileArg.GCompileArg", "", [], [
        ["cv::gapi::GNetPackage", "arg", "", []],
    ], "", ""],

    ["cv.GCompileArg.GCompileArg", "", [], [
        ["cv::gapi::streaming::queue_capacity", "arg", "", []],
    ], "", ""],

    ["cv.GCompileArg.GCompileArg", "", [], [
        ["cv::gapi::ot::ObjectTrackerParams", "arg", "", []],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L14-L20
    ["struct cv.GInferInputs", "", ["/Simple"], [], "", ""],

    ["cv.GInferInputs.GInferInputs", "", [], [], "", ""],

    ["cv.GInferInputs.setInput", "cv::GInferInputs", ["/Ref"], [
        ["std::string", "name", "", ["/C", "/Ref"]],
        ["cv::GMat", "value", "", ["/C", "/Ref"]],
    ], "", ""],

    ["cv.GInferInputs.setInput", "cv::GInferInputs", ["/Ref"], [
        ["std::string", "name", "", ["/C", "/Ref"]],
        ["cv::GFrame", "value", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L22-L28
    ["struct cv.GInferListInputs", "", ["/Simple"], [], "", ""],

    ["cv.GInferListInputs.GInferListInputs", "", [], [], "", ""],

    ["cv.GInferListInputs.setInput", "cv::GInferListInputs", [], [
        ["std::string", "name", "", ["/C", "/Ref"]],
        ["cv::GArray<cv::GMat>", "value", "", ["/C", "/Ref"]],
    ], "", ""],

    ["cv.GInferListInputs.setInput", "cv::GInferListInputs", [], [
        ["std::string", "name", "", ["/C", "/Ref"]],
        ["cv::GArray<cv::Rect>", "value", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L30-L35
    ["struct cv.GInferOutputs", "", ["/Simple"], [], "", ""],

    ["cv.GInferOutputs.GInferOutputs", "", [], [], "", ""],

    ["cv.GInferOutputs.at", "cv::GMat", [], [
        ["std::string", "name", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L37-L42
    ["struct cv.GInferListOutputs", "", ["/Simple"], [], "", ""],

    ["cv.GInferListOutputs.GInferListOutputs", "", [], [], "", ""],

    ["cv.GInferListOutputs.at", "cv::GArray<cv::GMat>", [], [
        ["std::string", "name", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L48
    ["class cv.gapi.wip.IStreamSource", "", [], [], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L51-L61
    ["cv.gapi.wip.draw.Rect.Rect", "", [], [
        ["cv::Rect2i", "rect_", "", ["/C", "/Ref"]],
        ["cv::Scalar", "color_", "", ["/C", "/Ref"]],
        ["int", "thick_", "1", []],
        ["int", "lt_", "8", []],
        ["int", "shift_", "0", []],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L51-L61
    ["cv.gapi.wip.draw.Mosaic.Mosaic", "", [], [
        ["cv::Rect2i", "mos_", "", ["/C", "/Ref"]],
        ["int", "cellSz_", "", []],
        ["int", "decim_", "", []],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L72
    ["cv.gapi.streaming.timestamp", "cv::GOpaque<int64_t>", [], [
        ["cv::GMat", "g", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L73
    ["cv.gapi.streaming.seqNo", "cv::GOpaque<int64_t>", [], [
        ["cv::GMat", "g", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L74
    ["cv.gapi.streaming.seq_id", "cv::GOpaque<int64_t>", [], [
        ["cv::GMat", "g", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L76
    ["cv.gapi.streaming.desync", "cv::GMat", [], [
        ["cv::GMat", "g", "", ["/C", "/Ref"]],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L82
    ["cv.detail.strip", "cv::gapi::GNetParam", [], [
        ["gapi::ie::PyParams", "params", "", []],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L83
    ["cv.detail.strip", "cv::gapi::GNetParam", [], [
        ["gapi::onnx::PyParams", "params", "", []],
    ], "", ""],

    // https://github.com/opencv/opencv/blob/4.11.0/modules/gapi/misc/python/shadow_gapi.hpp#L84
    ["cv.detail.strip", "cv::gapi::GNetParam", [], [
        ["gapi::ov::PyParams", "params", "", []],
    ], "", ""],
];
