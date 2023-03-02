#pragma once

#include "autoit_bridge_generated.h"
#include "impl_mat.h"

PTR_BRIDGE_DECL(cv::wgc::WGCFrameCallback)

extern const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* const& in_val, cv::GMetaArg& out_val);

extern const HRESULT autoit_from(const cv::GMetaArg& in_val, VARIANT*& out_val);
#if (CV_VERSION_MAJOR > 4) || CV_VERSION_MAJOR == 4 && (CV_VERSION_MINOR > 5 || CV_VERSION_MINOR == 5 && CV_VERSION_REVISION > 0)
extern const HRESULT autoit_from(const cv::GOptRunArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val);
#endif

extern const bool is_assignable_from(AUTOIT_PTR<cv::flann::IndexParams>& out_val, VARIANT*& in_val, bool is_optional);
extern const bool is_assignable_from(AUTOIT_PTR<cv::flann::SearchParams>& out_val, VARIANT*& in_val, bool is_optional);
extern const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT*& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT*& in_val, AUTOIT_PTR<cv::flann::IndexParams>& out_val);
extern const HRESULT autoit_to(VARIANT*& in_val, AUTOIT_PTR<cv::flann::SearchParams>& out_val);
extern const HRESULT autoit_to(VARIANT const* const& in_val, cv::flann::IndexParams& out_val);

namespace autoit
{
	template<typename destination_type>
	struct _GenericCopy<destination_type, cv::GMetaArg> {
		inline static HRESULT copy(destination_type* pTo, const cv::GMetaArg* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	const _variant_t fileNodeAsVariant(const cv::FileNode& node);
}
