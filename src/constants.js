exports.SIMPLE_ARGTYPE_DEFAULTS = new Map([
    ["bool", "0"],
    ["size_t", "0"],
    ["int", "0"],
    ["float", "0.f"],
    ["double", "0"],
    ["c_string", "(char*)\"\""],
    ["Stream", "Stream::Null()"],
]);

exports.IDL_TYPES = new Map([
    ["bool", "VARIANT_BOOL"],
    ["float", "FLOAT"],
    ["int64", "LONGLONG"],
    ["int", "LONG"],
    ["uint", "ULONG"],
    ["long", "LONG"],
    ["ulong", "ULONG"],
    ["size_t", "ULONGLONG"],
    ["uint64", "ULONGLONG"],
    ["String", "BSTR"],
    ["string", "BSTR"],
    ["uchar", "BYTE"],

    ["GMetaArg", "VARIANT"],
    ["MatShape", "VARIANT"],
    ["cv::flann::IndexParams", "IDispatch*"],
    ["cv::flann::SearchParams", "IDispatch*"],

    ["InputArray", "VARIANT"],
    ["InputArrayOfArrays", "VARIANT"],
    ["InputOutputArray", "VARIANT"],
    ["InputOutputArrayOfArrays", "VARIANT"],
    ["OutputArray", "VARIANT"],
    ["OutputArrayOfArrays", "VARIANT"],
]);

exports.CPP_TYPES = new Map([
    ["InputArray", "_InputArray"],
    ["InputArrayOfArrays", "_InputArray"],
    ["InputOutputArray", "_InputOutputArray"],
    ["InputOutputArrayOfArrays", "_InputOutputArray"],
    ["OutputArray", "_OutputArray"],
    ["OutputArrayOfArrays", "_OutputArray"],

    ["c_string", "char*"],
    ["dnn_Backend", "cv::dnn::Backend"],
    ["dnn_Target", "cv::dnn::Target"],
    ["flann_IndexParams", "cv::flann::IndexParams"],
    ["flann_SearchParams", "cv::flann::SearchParams"],
    ["GInferListOutputs", "cv::detail::GInferOutputsTyped<cv::GArray<cv::GMat>>"],
    ["String", "std::string"],
    ["string", "std::string"],
    ["gapi_ArgType", "cv::gapi::ArgType"],

    ["GpuMat_Allocator", "cuda::GpuMat::Allocator"],
    ["HostMem_AllocType", "cuda::HostMem::AllocType"],
    ["Event_CreateFlags", "cuda::Event::CreateFlags"],

    ["cvflann_flann_distance_t", "cvflann::flann_distance_t"],
    ["cvflann_flann_algorithm_t", "cvflann::flann_algorithm_t"],

    ["LayerId", "dnn::DictValue"],

    ["SimpleBlobDetector_Params", "SimpleBlobDetector::Params"],
    ["AKAZE_DescriptorType", "AKAZE::DescriptorType"],
    ["AgastFeatureDetector_DetectorType", "AgastFeatureDetector::DetectorType"],
    ["FastFeatureDetector_DetectorType", "FastFeatureDetector::DetectorType"],
    ["DescriptorMatcher_MatcherType", "DescriptorMatcher::MatcherType"],
    ["KAZE_DiffusivityType", "KAZE::DiffusivityType"],
    ["ORB_ScoreType", "ORB::ScoreType"],

    ["HOGDescriptor_HistogramNormType", "HOGDescriptor::HistogramNormType"],
    ["HOGDescriptor_DescriptorStorageFormat", "HOGDescriptor::DescriptorStorageFormat"],

    ["TrackerMIL_Params", "TrackerMIL::Params"],
    ["TrackerGOTURN_Params", "TrackerGOTURN::Params"],
    ["TrackerDaSiamRPN_Params", "TrackerDaSiamRPN::Params"],

    // NB: Python wrapper replaces :: with _ for classes
    ["gapi_GKernelPackage", "cv::gapi::GKernelPackage"],
    ["gapi_GNetPackage", "cv::gapi::GNetPackage"],
    ["gapi_ie_PyParams", "cv::gapi::ie::PyParams"],
    ["gapi_wip_IStreamSource_Ptr", "cv::Ptr<cv::gapi::wip::IStreamSource>"],
    ["detail_ExtractArgsCallback", "cv::detail::ExtractArgsCallback"],
    ["detail_ExtractMetaCallback", "cv::detail::ExtractMetaCallback"],

    ["DeviceInfo_ComputeMode", "cv::cuda::DeviceInfo::ComputeMode"],
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
    ["cv.detail.ExtractArgsCallback", ["/Simple"]],
    ["cv.detail.ExtractMetaCallback", ["/Simple"]],
    ["cv.gapi.wip.draw.Prim", ["/Simple"]],
    ["cv.gapi.wip.IStreamSource", []],
    ["cv.GProtoInputArgs", ["/Simple"]],
    ["cv.GProtoOutputArgs", ["/Simple"]],
];

exports.CUSTOM_NAMESPACES = new Set();

exports.ARRAY_CLASSES = new Set([
    // Array types
    // Unique
    "cv::GpuMat",
    "cv::Mat",
    "cv::UMat",
    "cv::Scalar", // Array of 4 numbers
]);

exports.ARRAYS_CLASSES = new Set([
    // Unique types
    "VectorOfMat",
    "VectorOfRotatedRect",
    "VectorOfUMat",

    // Ambiguous because Array of numbers
    "VectorOfChar", // Array of n numbers
    "VectorOfDouble", // Array of n numbers
    "VectorOfFloat", // Array of n numbers
    "VectorOfInt", // Array of n numbers
    "VectorOfUchar", // Array of n numbers

    // Ambiguous because Array of Array numbers
    "VectorOfPoint", // Array of Array of 2 numbers
    "VectorOfPoint2f", // Array of Array of 2 numbers
    "VectorOfRect", // Array of Array of 4 numbers
    "VectorOfSize", // Array of Array of 2 numbers
    "VectorOfVec6f", // Array of Array of 6 numbers
    "VectorOfVectorOfChar", // Array of Array of n numbers
    "VectorOfVectorOfInt", // Array of Array of n numbers

    // Ambiguous because Array of Array of Array of 2 numbers
    "VectorOfVectorOfPoint", // Array of Array of Array of 2 numbers
    "VectorOfVectorOfPoint2f", // Array of Array of Array of 2 numbers
]);

exports.IGNORED_CLASSES = new Set([
    "cv::cuda::GpuData"
]);

for (const type of exports.CPP_TYPES.keys()) {
    const cpptype = exports.CPP_TYPES.get(type);
    if (cpptype[0] !== "_" && !cpptype.includes("<") && !type.includes("string") && !type.includes("String")) {
        exports.ALIASES.set(type, cpptype);
    }
}
