#pragma once

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

extern const HRESULT autoit_from(const cv::GMetaArg& in_val, VARIANT*& out_val);
#if (CV_VERSION_MAJOR > 4) || CV_VERSION_MAJOR == 4 && (CV_VERSION_MINOR > 5 || CV_VERSION_MINOR == 5 && CV_VERSION_REVISION > 0)
extern const HRESULT autoit_from(const cv::GOptRunArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val);
#endif

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
		inline static HRESULT copy(destination_type* pTo, const cv::Point_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Point3_<_Tp>> {
		inline static HRESULT copy(destination_type* pTo, const cv::Point3_<_Tp>* pFrom) {
			return autoit_from(static_cast<cv::Vec<_Tp, 3>>(*pFrom), pTo);
		}
	};

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Rect_<_Tp>> {
		inline static HRESULT copy(destination_type* pTo, const cv::Rect_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp>
	struct _GenericCopy<destination_type, cv::Size_<_Tp>> {
		inline static HRESULT copy(destination_type* pTo, const cv::Size_<_Tp>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type, typename _Tp, int cn>
	struct _GenericCopy<destination_type, cv::Vec<_Tp, cn>> {
		inline static HRESULT copy(destination_type* pTo, const cv::Vec<_Tp, cn>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type>
	struct _GenericCopy<destination_type, cv::GMetaArg> {
		inline static HRESULT copy(destination_type* pTo, const cv::GMetaArg* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};
}

template<typename _Tp>
const bool is_assignable_from(cv::Point3_<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::Vec<_Tp, 3> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<typename _Tp>
const bool is_assignable_from(cv::Ptr<cv::Point3_<_Tp>>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::Point3_<_Tp> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<typename _Tp>
const HRESULT autoit_to(VARIANT const* const& in_val, cv::Point3_<_Tp>& out_val) {
	cv::Vec<_Tp, 3> tmp;
	HRESULT hr = autoit_to(in_val, tmp);
	if (SUCCEEDED(hr)) {
		out_val = tmp;
	}
	return hr;
}

template<typename _Tp>
const HRESULT autoit_to(VARIANT const* const& in_val, cv::Ptr<cv::Point3_<_Tp>>& out_val) {
    out_val = std::make_shared<cv::Point3_<_Tp>>();
    return autoit_to(in_val, *out_val.get());
}

template<typename _Tp>
const HRESULT autoit_from(const cv::Point3_<_Tp>& in_val, VARIANT*& out_val) {
	return autoit_from(cv::Vec<_Tp, 3>(in_val), out_val);
}

namespace cv {
	template<int _depth>
	struct TypeDepth;

	template<>
	struct TypeDepth<CV_8U> {
		typedef uchar value_type;
	};

	template<>
	struct TypeDepth<CV_8S> {
		typedef schar value_type;
	};

	template<>
	struct TypeDepth<CV_16U> {
		typedef ushort value_type;
	};

	template<>
	struct TypeDepth<CV_16S> {
		typedef short value_type;
	};

	template<>
	struct TypeDepth<CV_32S> {
		typedef int value_type;
	};

	template<>
	struct TypeDepth<CV_32F> {
		typedef float value_type;
	};

	template<>
	struct TypeDepth<CV_64F> {
		typedef double value_type;
	};

	template<>
	struct TypeDepth<CV_16F> {
		typedef float16_t value_type;
	};
}
