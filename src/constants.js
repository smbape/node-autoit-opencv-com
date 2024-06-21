const semver = require("semver");

exports.SIMPLE_ARGTYPE_DEFAULTS = new Map([
    ["bool", "0"],
    ["size_t", "0"],
    ["SSIZE_T", "0"],
    ["int", "0"],
    ["float", "0.f"],
    ["double", "0"],
    ["c_string", "(char*)\"\""],

    ["int8", "0"],
    ["int8_t", "0"],
    ["int16", "0"],
    ["int16_t", "0"],
    ["int32", "0"],
    ["int32_t", "0"],
    ["int64", "0"],
    ["int64_t", "0"],

    ["uint8", "0"],
    ["uint8_t", "0"],
    ["uint16", "0"],
    ["uint16_t", "0"],
    ["uint32", "0"],
    ["uint32_t", "0"],
    ["uint64", "0"],
    ["uint64_t", "0"],
    ["Stream", "Stream::Null()"],
]);

exports.IDL_TYPES = new Map([
    ["bool", "VARIANT_BOOL"],
    ["float", "FLOAT"],
    ["int", "LONG"],
    ["uint", "ULONG"],
    ["unsigned", "ULONG"],
    ["long", "LONG"],
    ["ulong", "ULONG"],
    ["SSIZE_T", "LONGLONG"],
    ["size_t", "ULONGLONG"],
    ["String", "BSTR"],
    ["string", "BSTR"],
    ["uchar", "BYTE"],
    ["cv::String", "BSTR"],
    ["std::string", "BSTR"],

    ["int8", "CHAR"],
    ["int8_t", "CHAR"],
    ["int16", "SHORT"],
    ["int16_t", "SHORT"],
    ["int32", "LONG"],
    ["int32_t", "LONG"],
    ["int64", "LONGLONG"],
    ["int64_t", "LONGLONG"],

    ["uint8", "BYTE"],
    ["uint8_t", "BYTE"],
    ["uint16", "USHORT"],
    ["uint16_t", "USHORT"],
    ["uint32", "ULONG"],
    ["uint32_t", "ULONG"],
    ["uint64", "ULONGLONG"],
    ["uint64_t", "ULONGLONG"],

    ["GMetaArg", "VARIANT"],
    ["cv::GMetaArg", "VARIANT"],
    ["MatShape", "VARIANT"],
    ["cv::flann::IndexParams", "IDispatch*"],
    ["cv::flann::SearchParams", "IDispatch*"],

    ["InputArray", "VARIANT"],
    ["InputArrayOfArrays", "VARIANT"],
    ["InputOutputArray", "VARIANT"],
    ["InputOutputArrayOfArrays", "VARIANT"],
    ["OutputArray", "VARIANT"],
    ["OutputArrayOfArrays", "VARIANT"],

    ["Point", "VARIANT"],
    ["cv::Point", "VARIANT"],
    ["Point2d", "VARIANT"],
    ["cv::Point2d", "VARIANT"],
    ["Rect", "VARIANT"],
    ["cv::Rect", "VARIANT"],
    ["Scalar", "VARIANT"],
    ["cv::Scalar", "VARIANT"],
    ["Size", "VARIANT"],
    ["cv::Size", "VARIANT"],
]);

exports.CPP_TYPES = new Map([
    ["InputArray", "cv::_InputArray"],
    ["InputArrayOfArrays", "cv::_InputArray"],
    ["InputOutputArray", "cv::_InputOutputArray"],
    ["InputOutputArrayOfArrays", "cv::_InputOutputArray"],
    ["OutputArray", "cv::_OutputArray"],
    ["OutputArrayOfArrays", "cv::_OutputArray"],

    ["Point", "cv::Point"],
    ["Point2d", "cv::Point2d"],
    ["Rect", "cv::Rect"],
    ["Scalar", "cv::Scalar"],
    ["Size", "cv::Size"],

    ["c_string", "char*"],
    ["GInferListOutputs", "cv::detail::GInferOutputsTyped<cv::GArray<cv::GMat>>"],
    ["String", "std::string"],
    ["string", "std::string"],

    ["LayerId", "dnn::DictValue"],

    ["gapi_wip_IStreamSource_Ptr", "cv::Ptr<cv::gapi::wip::IStreamSource>"],

    ["GMetaArg", "cv::GMetaArg"],
    ["GArray", "cv::GArray"],
    ["GOpaque", "cv::GOpaque"],
    ["Prim", "cv::gapi::wip::draw::Prim"],
]);

exports.ALIASES = new Map([
    ["DescriptorExtractor", "Feature2D"],
    ["FeatureDetector", "Feature2D"],
    ["GCompileArgs", "vector_GCompileArg"],
    ["GMetaArgs", "vector_GMetaArg"],
    ["GMat2", "tuple_GMat_and_GMat"],
    ["GRunArgs", "vector_GRunArg"],
    ["MatShape", "vector_int"],
    ["Prims", "vector_Prim"],
    ["Pose3DPtr", "Ptr_Pose3D"],
    ["PoseCluster3DPtr", "Ptr_PoseCluster3D"],

    // wrong namespace
    ["cv::cuda::cuda::StereoBeliefPropagation", "cv::cuda::StereoBeliefPropagation"],

    // contrib not speficiying namespace
    ["cv::bgsegm::BackgroundSubtractor", "cv::BackgroundSubtractor"],
    ["cv::xfeatures2d::Feature2D", "cv::Feature2D"],
    ["cv::optflow::DenseOpticalFlow", "cv::DenseOpticalFlow"],
    ["cv::optflow::SparseOpticalFlow", "cv::SparseOpticalFlow"],
    ["cv::xphoto::Tonemap", "cv::Tonemap"],
]);

exports.CLASS_PTR = new Set([
    "cv::cuda::GpuMat",
    "cv::cuda::GpuMat::Allocator",
]);

exports.PTR = new Set([
    "void*",
    "uchar*",
    "HWND",
    "cv::wgc::WGCFrameCallback",
]);

exports.CUSTOM_CLASSES = [
    ["cv.gapi.wip.draw.Prim", ["/Simple", "/DC"]],
    ["cv.gapi.wip.IStreamSource", []],
    ["cv.GProtoInputArgs", ["/Simple"]],
    ["cv.GProtoOutputArgs", ["/Simple"]],
];

if (semver.gt(global.OpenCV_VERSION.slice("opencv-".length), "4.5.0")) {
    exports.CUSTOM_CLASSES.push(...[
        ["cv.detail.ExtractArgsCallback", ["/Simple"]],
        ["cv.detail.ExtractMetaCallback", ["/Simple"]],
    ]);
} else {
    exports.CUSTOM_CLASSES.push(...[
        ["cv.GMatDesc", ["/Simple"]],
        ["cv.GScalarDesc", ["/Simple"]],
        ["cv.GArrayDesc", ["/Simple"]],
        ["cv.GOpaqueDesc", ["/Simple"]],
    ]);
}

exports.TEMPLATED_TYPES = new Set([
    "GArray",
    "GOpaque",
]);

exports.ARRAY_CLASSES = new Set([
    // Array types
    // Unique
    "cv::cuda::GpuMat",
    "cv::Mat",
    "cv::UMat",
    "cv::Scalar", // Array of 4 numbers
]);

const { getTypeDef } = require("./alias");

const types = [
    // Unique types
    "cv::Mat",
    "cv::UMat",
    // "bool",
    "cv::RotatedRect",
    "cv::Range",
    "cv::Moments",

    // Ambiguous because number
    "uchar",
    "schar",
    "char",
    "ushort",
    "short",
    "int",
    "float",
    "double",
    // "float16_t",

    // Ambiguous because array of numbers
    "cv::Point3i",
    "cv::Point3f",
    "cv::Point3d",

    // "cv::Point2l", // DataType<int64>::depth is not defined
    "cv::Point2f",
    "cv::Point2d",
    "cv::Point",

    "cv::Rect2f",
    "cv::Rect2d",
    "cv::Rect",

    // "cv::Size2l", // DataType<int64>::depth is not defined
    "cv::Size2f",
    "cv::Size2d",
    "cv::Size",
];

// Ambiguous because array of numbers
for (const _Tp of ["b", "s", "w"]) {
    for (const cn of [2, 3, 4]) { // eslint-disable-line no-magic-numbers
        types.push(`cv::Vec${ cn }${ _Tp }`);
    }
}

for (const cn of [2, 3, 4, 6, 8]) { // eslint-disable-line no-magic-numbers
    types.push(`cv::Vec${ cn }i`);
}

for (const _Tp of ["f", "d"]) {
    for (const cn of [2, 3, 4, 6]) { // eslint-disable-line no-magic-numbers
        types.push(`cv::Vec${ cn }${ _Tp }`);
    }
}

const length = types.length;

// Mat and UMat does not have vector<vector>
for (let i = 2; i < length; i++) {
    types.push(`std::vector<${ types[i] }>`);
}

for (let i = 0; i < types.length; i++) {
    types[i] = `std::vector<${ types[i] }>`;
}

exports.ARRAYS_CLASSES = new Set(types.map(type => getTypeDef(type, {
    remove_namespaces: new Set([
        "cv",
        "std",
    ])
})));

exports.IGNORED_CLASSES = new Set([]);
