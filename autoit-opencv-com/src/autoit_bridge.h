#pragma once

#include "autoit_bridge_generated.h"
#include "impl_mat.h"

PTR_BRIDGE_DECL(cv::wgc::WGCFrameCallback)

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp
#ifdef HAVE_OPENCV_GAPI
extern const bool is_assignable_from(AUTOIT_PTR<cv::gapi::wip::draw::Prim>& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::gapi::wip::draw::Prim>& out_val);
extern const HRESULT autoit_from(AUTOIT_PTR<cv::gapi::wip::draw::Prim> const& prim, VARIANT*& out_val);

extern const bool is_assignable_from(cv::gapi::wip::draw::Prim& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::gapi::wip::draw::Prim& out_val);
extern const HRESULT autoit_from(cv::gapi::wip::draw::Prim const& prim, VARIANT*& out_val);

extern const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::GMetaArg& out_val);
extern const HRESULT autoit_from(cv::GMetaArg const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(cv::GArg& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::GArg& out_val);
extern const HRESULT autoit_from(cv::GArg const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(cv::detail::OpaqueRef& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::detail::OpaqueRef& out_val);
extern const HRESULT autoit_from(cv::detail::OpaqueRef const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(cv::detail::VectorRef& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::detail::VectorRef& out_val);
extern const HRESULT autoit_from(cv::detail::VectorRef const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(cv::GRunArg& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::GRunArg& out_val);
extern const HRESULT autoit_from(cv::GRunArg const& in_val, VARIANT*& out_val);

extern const HRESULT autoit_from(cv::GOptRunArg const& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(cv::util::variant<cv::GRunArgs, cv::GOptRunArgs> const& in_val, VARIANT*& out_val);

// TODO
// "kernels", CV_PY_FN_WITH_KW(pyopencv_cv_gapi_kernels), "kernels(...) -> GKernelPackage"
// "__op", CV_PY_FN_WITH_KW(pyopencv_cv_gapi_op), "__op(...) -> retval\n"
#endif

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp
#ifdef HAVE_OPENCV_FLANN
extern const bool is_assignable_from(AUTOIT_PTR<cv::flann::IndexParams>& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::flann::IndexParams>& out_val);
extern const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::flann::IndexParams& out_val);

extern const bool is_assignable_from(AUTOIT_PTR<cv::flann::SearchParams>& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::flann::SearchParams>& out_val);
extern const bool is_assignable_from(cv::flann::SearchParams& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::flann::SearchParams& out_val);
#endif

// https://github.com/opencv/opencv/tree/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp
#ifdef HAVE_OPENCV_DNN
extern const bool is_assignable_from(cv::dnn::DictValue& dv, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::dnn::DictValue& dv);
extern const HRESULT autoit_from(cv::dnn::DictValue const& dv, VARIANT*& out_val);

extern const bool is_assignable_from(cv::dnn::LayerParams& lp, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, cv::dnn::LayerParams& lp);
extern const HRESULT autoit_from(cv::dnn::LayerParams const& lp, VARIANT*& out_val);

extern const HRESULT autoit_from(std::vector<cv::dnn::Target> const& t, VARIANT*& out_val);
#endif

namespace autoit
{
	const _variant_t fileNodeAsVariant(const cv::FileNode& node);
}
