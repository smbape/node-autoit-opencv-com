#pragma once

#include "autoit_bridge_common.h"
#include "autoit_bridge_generated.h"

class IVariantArray {
public:
	virtual cv::_InputArray* createInputArray() = 0;
	virtual cv::_OutputArray* createOutputArray() = 0;
	virtual cv::_InputOutputArray* createInputOutputArray() = 0;
};

class IVariantArrays : public IVariantArray {

};

template<typename _Tp>
class IVariantArrayImpl :
	public IVariantArray,
	public AutoItObject<_Tp> {
public:
	cv::_InputArray* createInputArray() {
		return new cv::_InputArray(*this->__self->get());
	}

	cv::_OutputArray* createOutputArray() {
		return new cv::_OutputArray(*this->__self->get());
	}

	cv::_InputOutputArray* createInputOutputArray() {
		return new cv::_InputOutputArray(*this->__self->get());
	}
};

template<typename _Tp>
class IVariantArraysImpl :
	public IVariantArrays,
	public AutoItObject<_Tp> {
public:
	cv::_InputArray* createInputArray() {
		return new cv::_InputArray(*this->__self->get());
	}

	cv::_OutputArray* createOutputArray() {
		return new cv::_OutputArray(*this->__self->get());
	}

	cv::_InputOutputArray* createInputOutputArray() {
		return new cv::_InputOutputArray(*this->__self->get());
	}
};

PTR_BRIDGE_DECL(cv::wgc::WGCFrameCallback)

extern const bool is_variant_scalar(VARIANT const* const& in_val);
extern const bool is_array_from(VARIANT const* const& in_val, bool is_optional);
extern const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional);

extern const HRESULT autoit_from(cv::MatExpr& in_val, ICv_Mat_Object**& out_val);

extern const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* const& in_val, cv::GMetaArg& out_val);

extern const HRESULT autoit_from(const GMetaArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(const GOptRunArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(cv::Ptr<cv::flann::IndexParams>& out_val, VARIANT*& in_val, bool is_optional);
extern const bool is_assignable_from(cv::Ptr<cv::flann::SearchParams>& out_val, VARIANT*& in_val, bool is_optional);
extern const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT*& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT*& in_val, cv::Ptr<cv::flann::IndexParams>& out_val);
extern const HRESULT autoit_to(VARIANT*& in_val, cv::Ptr<cv::flann::SearchParams>& out_val);
extern const HRESULT autoit_to(VARIANT const* const& in_val, cv::flann::IndexParams& out_val);


namespace autoit
{

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Point_<_Tp>> {
		inline static HRESULT copy(VARIANT* pTo, const cv::Point_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Rect_<_Tp>> {
		inline static HRESULT copy(VARIANT* pTo, const cv::Rect_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Size_<_Tp>> {
		inline static HRESULT copy(VARIANT* pTo, const cv::Size_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp, int cn>
	struct _GenericCopy<destination_type, cv::Vec<_Tp, cn>> {
		inline static HRESULT copy(VARIANT* pTo, const cv::Vec<_Tp, cn>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type>
	struct _GenericCopy<destination_type, cv::GMetaArg> {
		inline static HRESULT copy(VARIANT* pTo, const cv::GMetaArg* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

}
