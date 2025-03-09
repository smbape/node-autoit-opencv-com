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

extern const bool is_variant_scalar(VARIANT const* const& in_val);
extern const bool is_array_from(VARIANT const* const& in_val, bool is_optional);
extern const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional);

extern const HRESULT autoit_from(cv::MatExpr const& in_val, ICv_Mat_Object**& out_val);

namespace cv {
	CV_EXPORTS_W Mat createMatFromBitmap(void* ptr, bool copy = true);
}

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

	namespace cvextra {
		void convertToShow(cv::InputArray src, cv::Mat& dst, bool toRGB = true);
		const void* convertToBitmap(cv::InputArray src, bool copy);
		void GdiplusResize(cv::InputArray src, cv::Mat& dst, float newWidth, float newHeight, int interpolation);
		AUTOIT_PTR<cv::Mat> createFromVectorOfMat(const std::vector<cv::Mat>& vec);
	}
}

template<typename _Tp>
inline const bool is_assignable_from(cv::Point3_<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::Vec<_Tp, 3> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<typename _Tp>
const bool is_assignable_from(AUTOIT_PTR<cv::Point3_<_Tp>>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::Point3_<_Tp> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<typename _Tp>
inline const HRESULT autoit_to(VARIANT const* const& in_val, cv::Point3_<_Tp>& out_val) {
	cv::Vec<_Tp, 3> tmp;
	HRESULT hr = autoit_to(in_val, tmp);
	if (SUCCEEDED(hr)) {
		out_val = tmp;
	}
	return hr;
}

template<typename _Tp>
inline const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<cv::Point3_<_Tp>>& out_val) {
	out_val = std::make_shared<cv::Point3_<_Tp>>();
	return autoit_to(in_val, *out_val.get());
}

template<typename _Tp>
inline const HRESULT autoit_from(cv::Point3_<_Tp> const& in_val, VARIANT*& out_val) {
	return autoit_from(cv::Vec<_Tp, 3>(in_val), out_val);
}
