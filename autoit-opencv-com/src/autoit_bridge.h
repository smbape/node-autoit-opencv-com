#pragma once

#include "autoit_bridge_generated.h"
#include <tuple>
#include <utility>

#define is_parameter_not_found(in_val) (V_VT(in_val) == VT_ERROR && V_ERROR(in_val) == DISP_E_PARAMNOTFOUND)
#define is_parameter_missing(in_val) (V_VT(in_val) == VT_EMPTY || is_parameter_not_found(in_val))

template<typename _Tp>
struct TypeToImplType;

template<typename _Tp>
class AutoItObject {
public:
	cv::Ptr<_Tp>* __self = nullptr;
};

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

class ExtendedHolder {
public:
	static ATL::CComSafeArray<VARIANT> extended;
	static HRESULT SetLength(ULONG len);
	static HRESULT SetAt(LONG i, const VARIANT& value, bool copy = true);
	static HMODULE hModule;
};

extern IDispatch* getRealIDispatch(VARIANT const* const& in_val);

extern const bool is_assignable_from(bool& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, bool& out_val);
extern const HRESULT autoit_opencv_to(VARIANT_BOOL& in_val, bool& out_val);
extern const HRESULT autoit_opencv_from(const bool& in_val, VARIANT_BOOL*& out_val);

extern const bool is_assignable_from(std::string& out_val, BSTR const& in_val, bool is_optional);
extern const bool is_assignable_from(std::string& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(BSTR const& in_val, std::string& out_val);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, std::string& out_val);
extern const HRESULT autoit_opencv_from(std::string& in_val, BSTR& out_val);
extern const HRESULT autoit_opencv_from(const std::string& in_val, BSTR*& out_val);
extern const HRESULT autoit_opencv_from(const std::string& in_val, VARIANT*& out_val);
extern const HRESULT autoit_opencv_from(BSTR const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(char*& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, char*& out_val);

extern const bool is_assignable_from(void*& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, void*& out_val);

extern const HRESULT autoit_opencv_from(uchar const* const& in_val, VARIANT*& out_val);

extern const HRESULT autoit_opencv_from(cv::MatExpr& in_val, ICv_Mat_Object**& out_val);

extern const HRESULT autoit_opencv_from(VARIANT const& in_val, VARIANT*& out_val);

extern const HRESULT autoit_opencv_out(IDispatch*& in_val, VARIANT*& out_val);
extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, VARIANT*& out_val);
extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, IDispatch**& out_val);
extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, BSTR*& out_val);

template<typename _Tp>
const bool is_assignable_from(std::vector<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
	}

	if (V_VT(in_val) == VT_EMPTY) {
		return is_optional;
	}

	if (V_VT(in_val) == VT_DISPATCH) {
		return dynamic_cast<TypeToImplType<std::vector<_Tp>>::type*>(getRealIDispatch(in_val)) ? true : false;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	std::vector<_Tp> dummy;
	return SUCCEEDED(autoit_opencv_to(in_val, dummy));
}

template<typename _Tp>
const HRESULT autoit_opencv_to(VARIANT const* const& in_val, std::vector<_Tp>& out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	if (V_VT(in_val) == VT_EMPTY) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();

	out_val.resize(lUpper - lLower + 1);
	_Tp value;

	for (LONG i = lLower; i <= lUpper; i++) {
		auto& v = vArray.GetAt(i);
		VARIANT* pv = &v;

		if (!is_assignable_from(value, pv, false)) {
			hr = E_INVALIDARG;
			break;
		}

		hr = autoit_opencv_to(pv, value);
		if (FAILED(hr)) {
			break;
		}

		out_val[i - lLower] = value;
	}

	vArray.Detach();
	return hr;
}

template<typename _Tp>
const HRESULT autoit_opencv_from(const cv::Ptr<std::vector<_Tp>>& in_val, VARIANT*& out_val) {
	return autoit_opencv_from(*in_val.get(), out_val);
}

template<typename _Tp>
const HRESULT autoit_opencv_from(const std::vector<_Tp>& in_val, VARIANT*& out_val) {
	if (V_VT(out_val) == VT_EMPTY || V_VT(out_val) == VT_ERROR && V_ERROR(out_val) == DISP_E_PARAMNOTFOUND) {
		V_VT(out_val) = VT_ARRAY | VT_VARIANT;
		CComSafeArray<VARIANT> vArray((ULONG)0);
		V_ARRAY(out_val) = vArray.Detach();
	}

	if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

	#pragma warning( push )
	#pragma warning( disable : 4267)
	vArray.Resize(in_val.size());
	#pragma warning( pop )

	for (LONG i = 0; SUCCEEDED(hr) && i < in_val.size(); i++) {
		VARIANT value = { VT_EMPTY };
		auto* pvalue = &value;
		hr = autoit_opencv_from(in_val[i], pvalue);

		if (SUCCEEDED(hr)) {
			vArray.SetAt(i, value);
		}

		VariantClear(&value);
	}

	vArray.Detach();
	return hr;
}

template<typename ... _Rest>
const bool is_assignable_from(std::tuple <_Rest...>& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
	}

	if (V_VT(in_val) == VT_EMPTY) {
		return is_optional;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	std::tuple<__Rest...> dummy;
	return SUCCEEDED(autoit_opencv_to(in_val, dummy));
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I == sizeof...(_Ts), const HRESULT>::type
autoit_opencv_to(VARIANT const* const& in_val, std::tuple<_Ts...>& out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	if (V_VT(in_val) == VT_EMPTY) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	return S_OK;
}

template<std::size_t I = 0, typename _This, typename... _Rest>
typename std::enable_if < I < 1 + sizeof...(_Rest), const HRESULT>::type
	autoit_opencv_to(VARIANT const* const& in_val, std::tuple<_This, _Rest...>& out_val) {
	HRESULT hr = autoit_opencv_to<I + 1, _This, _Rest...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));
	auto& v = vArray.GetAt(I);
	auto* pv = &v;

	_This value;

	hr = is_assignable_from(value, pv, false);

	if (SUCCEEDED(hr)) {
		hr = autoit_opencv_to(pv, value);
	}

	if (SUCCEEDED(hr)) {
		std::get<I>(out_val) = value;
	}

	vArray.Detach();
	return hr;
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I == sizeof...(_Ts), const HRESULT>::type
autoit_opencv_from(std::tuple<_Ts...>& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_ARRAY | VT_VARIANT;
	CComSafeArray<VARIANT> vArray((ULONG)I);
	V_ARRAY(out_val) = vArray.Detach();
	return S_OK;
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if < I < sizeof...(_Ts), const HRESULT>::type
	autoit_opencv_from(std::tuple<_Ts...>& in_val, VARIANT*& out_val) {
	HRESULT hr = autoit_opencv_from<I + 1, _Ts...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

	VARIANT value = { VT_EMPTY };
	auto* pvalue = &value;
	hr = autoit_opencv_from(std::get<I>(in_val), pvalue);

	if (SUCCEEDED(hr)) {
		vArray.SetAt(I, value);
	}

	VariantClear(&value);

	vArray.Detach();
	return hr;
}

template<typename _Tp>
HRESULT get_variant_number(VARIANT const* const& in_val, _Tp& out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	switch (V_VT(in_val)) {
		case VT_EMPTY:
			return S_OK;
		case VT_I1:
			out_val = static_cast<_Tp>(V_I1(in_val));
			return S_OK;
		case VT_I2:
			out_val = static_cast<_Tp>(V_I2(in_val));
			return S_OK;
		case VT_I4:
			out_val = static_cast<_Tp>(V_I4(in_val));
			return S_OK;
		case VT_I8:
			out_val = static_cast<_Tp>(V_I8(in_val));
			return S_OK;
		case VT_INT:
			out_val = static_cast<_Tp>(V_INT(in_val));
			return S_OK;
		case VT_UI1:
			out_val = static_cast<_Tp>(V_UI1(in_val));
			return S_OK;
		case VT_UI2:
			out_val = static_cast<_Tp>(V_UI2(in_val));
			return S_OK;
		case VT_UI4:
			out_val = static_cast<_Tp>(V_UI4(in_val));
			return S_OK;
		case VT_UI8:
			out_val = static_cast<_Tp>(V_UI8(in_val));
			return S_OK;
		case VT_UINT:
			out_val = static_cast<_Tp>(V_UINT(in_val));
			return S_OK;
		default:
			return E_INVALIDARG;
	}
}

extern const bool is_variant_number(VARIANT const* const& in_val);
extern const bool is_variant_scalar(VARIANT const* const& in_val);
extern const bool is_array_from(VARIANT const* const& in_val, bool is_optional);
extern const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional);

extern const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::GMetaArg& out_val);

extern const HRESULT autoit_opencv_from(const GMetaArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_opencv_from(const GOptRunArg& in_val, VARIANT*& out_val);
extern const HRESULT autoit_opencv_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val);

extern HRESULT GetInterfaceName(IUnknown* punk, VARIANT* vres);

extern const bool is_assignable_from(cv::Ptr<cv::flann::IndexParams> &out_val, VARIANT* &in_val, bool is_optional);
extern const bool is_assignable_from(cv::Ptr<cv::flann::SearchParams> &out_val, VARIANT* &in_val, bool is_optional);
extern const bool is_assignable_from(cv::flann::IndexParams &out_val, VARIANT* &in_val, bool is_optional);
extern const HRESULT autoit_opencv_to(VARIANT* &in_val, cv::Ptr<cv::flann::IndexParams> &out_val);
extern const HRESULT autoit_opencv_to(VARIANT* &in_val, cv::Ptr<cv::flann::SearchParams> &out_val);
extern const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::flann::IndexParams& out_val);
