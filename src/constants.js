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

    ["QRCodeEncoder_Params", "QRCodeEncoder::Params"],
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

    ["RgbdNormals_RgbdNormalsMethod", "cv::RgbdNormals::RgbdNormalsMethod"],
    ["GStreamerSource_OutputType", "cv::gapi::wip::gst::GStreamerSource::OutputType"],
    ["OriginalClassName_Params", "cv::utils::nested::OriginalClassName::Params"],

    ["GMetaArg", "cv::GMetaArg"],
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
    ["kinfu_VolumeType", "kinfu::VolumeType"],
    ["kinfu_Params", "kinfu::Params"],
    ["legacy_Tracker", "legacy::Tracker"],
    ["dnn_Net", "dnn::Net"],
    ["HistogramPhaseUnwrapping_Params", "HistogramPhaseUnwrapping::Params"],
    ["ml_SVM", "ml::SVM"],
    ["SinusoidalPattern_Params", "SinusoidalPattern::Params"],
    ["text_decoder_mode", "text::decoder_mode"],
    ["ERFilter_Callback", "ERFilter::Callback"],
    ["OCRBeamSearchDecoder_ClassifierCallback", "OCRBeamSearchDecoder::ClassifierCallback"],
    ["TrackerCSRT_Params", "TrackerCSRT::Params"],
    ["TrackerKCF_Params", "TrackerKCF::Params"],
    ["TrackerNano_Params", "TrackerNano::Params"],
    ["DAISY_NormalizationType", "DAISY::NormalizationType"],
    ["OCRHMMDecoder_ClassifierCallback", "OCRHMMDecoder::ClassifierCallback"],
    ["EdgeDrawing_Params", "EdgeDrawing::Params"],

    // ["cv.createChiHistogramCostExtractor", "cv.createChiHistogramCostExtractor"],
    // ["cv.createThinPlateSplineShapeTransformer", "cv.createThinPlateSplineShapeTransformer"],
    // ["cv::createChiHistogramCostExtractor", "cv::createChiHistogramCostExtractor"],
    // ["cv::createThinPlateSplineShapeTransformer", "cv::createThinPlateSplineShapeTransformer"],
    // ["createChiHistogramCostExtractor", "cv::createChiHistogramCostExtractor"],
    // ["createThinPlateSplineShapeTransformer", "cv::createThinPlateSplineShapeTransformer"],
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

exports.IGNORED_CLASSES = new Set([]);
