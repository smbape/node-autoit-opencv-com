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
    ["void*", "VARIANT"],
    ["uchar*", "VARIANT"],
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

    // ["cv::cuda::GpuMat", "IDispatch*"],
    // ["cv::cuda::HostMem", "IDispatch*"],
    // ["cv::cuda::Stream", "IDispatch*"],
    // ["cv::ocl::Device", "IDispatch*"],
    ["cv::Point", "VARIANT"],
    ["cv::Point2i", "VARIANT"],
    ["cv::Point2d", "VARIANT"],
    ["cv::Point2f", "VARIANT"],
    ["cv::Rect", "VARIANT"],
    ["cv::Rect2d", "VARIANT"],
    ["cv::Size", "VARIANT"],
    ["cv::Size2f", "VARIANT"],
    ["cv::Scalar", "VARIANT"],
    // ["cv::TermCriteria", "IDispatch*"],
    ["cv::Vec2d", "VARIANT"],
    ["cv::Vec2i", "VARIANT"],
    ["cv::Vec3d", "VARIANT"],
    ["cv::Vec3i", "VARIANT"],
    ["cv::Vec4f", "VARIANT"],
    ["cv::Vec6f", "VARIANT"],

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
    // ["GRunArgs", "std::vector<cv::GRunArg>"],
    ["String", "std::string"],
    ["string", "std::string"],
    // ["tuple_bool_and_util_variant_GRunArgs_and_GOptRunArgs", "std::tuple<bool, cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>>"],
    // ["tuple_GArray_Rect_and_GArray_int", "std::tuple<cv::GArray<cv::Rect>, cv::GArray<int>>"],
    // ["tuple_GMat_and_GMat_and_GMat", "std::tuple<cv::GMat, cv::GMat, cv::GMat>"],
    // ["tuple_GMat_and_GScalar", "std::tuple<cv::GMat, cv::GScalar>"],
    // ["tuple_GOpaque_double_and_GArray_int_end__and_GArray_Point2f", "std::tuple<cv::GOpaque<double>, cv::GArray<int>, cv::GArray<Point2f>>"],
    // ["vector_Target", "std::vector<cv::dnn::Target>"],
    // ["GMat2", "std::tuple<cv::GMat, cv::GMat>"],
    ["gapi_ArgType", "cv::gapi::ArgType"],

    // ["vector_uchar", "std::vector<uchar>"],
    // ["vector_char", "std::vector<char>"],
    // ["vector_int", "std::vector<int>"],
    // ["vector_float", "std::vector<float>"],
    // ["vector_double", "std::vector<double>"],
    // ["vector_size_t", "std::vector<size_t>"],
    // ["vector_Point", "std::vector<cv::Point>"],
    // ["vector_Point2f", "std::vector<cv::Point2f>"],
    // ["vector_Point3f", "std::vector<cv::Point3f>"],
    // ["vector_Size", "std::vector<cv::Size>"],
    // ["vector_Vec2f", "std::vector<cv::Vec2f>"],
    // ["vector_Vec3f", "std::vector<cv::Vec3f>"],
    // ["vector_Vec4f", "std::vector<cv::Vec4f>"],
    // ["vector_Vec6f", "std::vector<cv::Vec6f>"],
    // ["vector_Vec4i", "std::vector<cv::Vec4i>"],
    // ["vector_Rect", "std::vector<cv::Rect>"],
    // ["vector_Rect2d", "std::vector<cv::Rect2d>"],
    // ["vector_RotatedRect", "std::vector<cv::RotatedRect>"],
    // ["vector_KeyPoint", "std::vector<cv::KeyPoint>"],
    // ["vector_Mat", "std::vector<cv::Mat>"],
    // ["vector_vector_Mat", "std::vector<std::vector<Mat>>"],
    // ["vector_UMat", "std::vector<cv::UMat>"],
    // ["vector_DMatch", "std::vector<cv::DMatch>"],
    // ["vector_String", "std::vector<std::string>"],
    // ["vector_string", "std::vector<std::string>"],
    // ["vector_Scalar", "std::vector<cv::Scalar>"],

    // ["vector_vector_char", "std::vector<std::vector<char>>"],
    // ["vector_vector_Point", "std::vector<std::vector<cv::Point>>"],
    // ["vector_vector_Point2f", "std::vector<std::vector<cv::Point2f>>"],
    // ["vector_vector_Point3f", "std::vector<std::vector<cv::Point3f>>"],
    // ["vector_vector_DMatch", "std::vector<std::vector<DMatch>>"],
    // ["vector_vector_KeyPoint", "std::vector<std::vector<KeyPoint>>"],

    // ["vector_GpuMat", "std::vector<cuda::GpuMat>"],
    ["GpuMat_Allocator", "cuda::GpuMat::Allocator"],
    ["HostMem_AllocType", "cuda::HostMem::AllocType"],
    ["Event_CreateFlags", "cuda::Event::CreateFlags"],

    // ["vector_Range", "std::vector<cv::Range>"],

    ["cvflann_flann_distance_t", "cvflann::flann_distance_t"],
    ["cvflann_flann_algorithm_t", "cvflann::flann_algorithm_t"],

    ["LayerId", "dnn::DictValue"],
    // ["vector_MatShape", "std::vector<dnn::MatShape>"],
    // ["vector_vector_MatShape", "std::vector<std::vector<dnn::MatShape>>"],

    ["SimpleBlobDetector_Params", "SimpleBlobDetector::Params"],
    ["AKAZE_DescriptorType", "AKAZE::DescriptorType"],
    ["AgastFeatureDetector_DetectorType", "AgastFeatureDetector::DetectorType"],
    ["FastFeatureDetector_DetectorType", "FastFeatureDetector::DetectorType"],
    ["DescriptorMatcher_MatcherType", "DescriptorMatcher::MatcherType"],
    ["KAZE_DiffusivityType", "KAZE::DiffusivityType"],
    ["ORB_ScoreType", "ORB::ScoreType"],

    // ["vector_VideoCaptureAPIs", "std::vector<VideoCaptureAPIs>"],
    ["HOGDescriptor_HistogramNormType", "HOGDescriptor::HistogramNormType"],
    ["HOGDescriptor_DescriptorStorageFormat", "HOGDescriptor::DescriptorStorageFormat"],

    // ["Status", "Stitcher::Status"],
    // ["Mode", "Stitcher::Mode"],
    // ["vector_ImageFeatures", "std::vector<detail::ImageFeatures>"],
    // ["vector_MatchesInfo", "std::vector<detail::MatchesInfo>"],
    // ["vector_CameraParams", "std::vector<detail::CameraParams>"],
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
    // ["vector_GNetParam", "std::vector<cv::gapi::GNetParam>"],

    // NB: Python wrapper generate T_U for T<U>
    // This behavior is only observed for inputs
    // ["GOpaque_bool", "cv::GOpaque<bool>"],
    // ["GOpaque_int", "cv::GOpaque<int>"],
    // ["GOpaque_double", "cv::GOpaque<double>"],
    // ["GOpaque_float", "cv::GOpaque<double>"],
    // ["GOpaque_string", "cv::GOpaque<std::string>"],
    // ["GOpaque_Point2i", "cv::GOpaque<cv::Point>"],
    // ["GOpaque_Point2f", "cv::GOpaque<cv::Point2f>"],
    // ["GOpaque_Size", "cv::GOpaque<cv::Size>"],
    // ["GOpaque_Rect", "cv::GOpaque<cv::Rect>"],

    // ["GArray_bool", "cv::GArray<bool>"],
    // ["GArray_int", "cv::GArray<int>"],
    // ["GArray_double", "cv::GArray<double>"],
    // ["GArray_float", "cv::GArray<double>"],
    // ["GArray_string", "cv::GArray<std::string>"],
    // ["GArray_Point2i", "cv::GArray<cv::Point>"],
    // ["GArray_Point2f", "cv::GArray<cv::Point2f>"],
    // ["GArray_Size", "cv::GArray<cv::Size>"],
    // ["GArray_Rect", "cv::GArray<cv::Rect>"],
    // ["GArray_Scalar", "cv::GArray<cv::Scalar>"],
    // ["GArray_Mat", "cv::GArray<cv::Mat>"],
    // ["GArray_GMat", "cv::GArray<cv::GMat>"],
    // ["GArray_Prim", "cv::GArray<cv::gapi::wip::draw::Prim>"],

    // ["Point", "cv::Point"],
    // ["Point2i", "cv::Point2i"],
    // ["Point2d", "cv::Point2d"],
    // ["Point2f", "cv::Point2f"],
    // ["Rect", "cv::Rect"],
    // ["Size", "cv::Size"],
    // ["Size2f", "cv::Size2f"],
    // ["Prim", "cv::gapi::wip::draw::Prim"],

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

exports.CUSTOM_CLASSES = [
    ["cv.detail.ExtractArgsCallback", ["/Simple"]],
    ["cv.detail.ExtractMetaCallback", ["/Simple"]],
    ["cv.gapi.wip.draw.Prim", ["/Simple"]],
    ["cv.gapi.wip.IStreamSource", []],
    ["cv.GProtoInputArgs", ["/Simple"]],
    ["cv.GProtoOutputArgs", ["/Simple"]],
];

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
    if (!exports.IDL_TYPES.has(type)) {
        // exports.IDL_TYPES.set(type, "IDispatch*");
    }

    const cpptype = exports.CPP_TYPES.get(type);
    if (cpptype[0] !== "_" && !cpptype.includes("<") && !type.includes("string") && !type.includes("String")) {
        exports.ALIASES.set(type, cpptype);
    }
}
