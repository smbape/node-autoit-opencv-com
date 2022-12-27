#pragma once
#pragma comment(lib, "comsuppw.lib")

#include <algorithm>
#include <atlbase.h>
#include <atlcom.h>
#include <atlctl.h>
#include <atlsafe.h>
#include <comutil.h>
#include <iostream>
#include <map>
#include <memory>
#include <numeric>
#include <OleAuto.h>
#include <sstream>
#include <string>
#include <tuple>
#include <type_traits>
#include <typeindex>
#include <typeinfo>
#include <utility>
#include <vector>

#include "autoit_def.h"

// import the .TLB that's compiled in scrrun.dll
// needed to use ScriptingDictionary
#import "C:\Windows\System32\scrrun.dll" \
	rename("CopyFile", "CopyFile2") \
	rename("DeleteFile", "DeleteFile2") \
	rename("FreeSpace", "FreeSpace2") \
	rename("MoveFile", "MoveFile2") \
	// avoid name collision with Windows SDK's macros, this is specific to scrrun.dll

#ifdef AutoIt_Func
// keep current value (through OpenCV port file)
#elif defined __GNUC__ || (defined (__cpluscplus) && (__cpluscplus >= 201103))
#define AutoIt_Func __func__
#elif defined __clang__ && (__clang_minor__ * 100 + __clang_major__ >= 305)
#define AutoIt_Func __func__
#elif defined(__STDC_VERSION__) && (__STDC_VERSION >= 199901)
#define AutoIt_Func __func__
#elif defined _MSC_VER
#define AutoIt_Func __FUNCTION__
#elif defined(__INTEL_COMPILER) && (_INTEL_COMPILER >= 600)
#define AutoIt_Func __FUNCTION__
#elif defined __IBMCPP__ && __IBMCPP__ >=500
#define AutoIt_Func __FUNCTION__
#elif defined __BORLAND__ && (__BORLANDC__ >= 0x550)
#define AutoIt_Func __FUNC__
#else
#define AutoIt_Func "<unknown>"
#endif

#ifndef AUTOIT_QUOTE_STRING2
#define AUTOIT_QUOTE_STRING2(x) #x
#endif
#ifndef AUTOIT_QUOTE_STRING
#define AUTOIT_QUOTE_STRING(x) AUTOIT_QUOTE_STRING2(x)
#endif

#ifndef AUTOIT_INFO
#define AUTOIT_INFO( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Info: %s (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), "", AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_WARN
#define AUTOIT_WARN( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Warning: %s (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), "", AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_ERROR
#define AUTOIT_ERROR( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Error: %s (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), "", AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_THROW
#define AUTOIT_THROW( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Error: %s (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), "", AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);           \
	throw std::exception(_out.str().c_str()); \
} while(0)
#endif

#ifndef AUTOIT_ASSERT_THROW
#define AUTOIT_ASSERT_THROW( expr, _message ) do { if(!!(expr)) ; else { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Error: %s (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), #expr, AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
	throw std::exception(_out.str().c_str());    \
}} while(0)
#endif

#ifndef AUTOIT_ASSERT_SET_HR
#define AUTOIT_ASSERT_SET_HR( expr ) do { if(!!(expr)) { hr = S_OK; } else { \
fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Error: (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), #expr, AutoIt_Func, __FILE__, __LINE__); \
hr = E_FAIL; } \
} while(0)
#endif

#ifndef AUTOIT_ASSERT
#define AUTOIT_ASSERT( expr ) do { if(!!(expr)) ; else { \
fflush(stdout); fflush(stderr); \
fprintf(stderr, AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) "(%s) Error: (%s) in %s, file %s, line %d\n", AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), #expr, AutoIt_Func, __FILE__, __LINE__); \
fflush(stdout); fflush(stderr); \
return E_FAIL; } \
} while(0)
#endif

#define PARAMETER_NOT_FOUND(in_val) (V_VT(in_val) == VT_ERROR && V_ERROR(in_val) == DISP_E_PARAMNOTFOUND)
#define PARAMETER_EMPTY(in_val) (V_VT(in_val) == VT_EMPTY || V_VT(in_val) == VT_DISPATCH && V_DISPATCH(in_val) == NULL)
#define PARAMETER_NULL(in_val) (PARAMETER_EMPTY(in_val) || V_VT(in_val) == VT_NULL)
#define PARAMETER_MISSING(in_val) (PARAMETER_EMPTY(in_val) || PARAMETER_NOT_FOUND(in_val))
#define PARAMETER_IN(in_val) variant_t variant_##in_val = get_variant_in(in_val); if (V_ISBYREF(in_val)) in_val = &variant_##in_val

template<typename _Tp>
struct TypeToImplType;

template<typename _Tp>
class AutoItObject {
public:
	AUTOIT_PTR<_Tp>* __self = nullptr;
};

/**
 * https://learn.microsoft.com/en-us/windows/win32/sbscs/isolating-components
 */
class CActivationContext
{
public:
	CActivationContext();
	void Set(HANDLE hActCtx);
	~CActivationContext();
	bool Activate(ULONG_PTR& ulpCookie);
	bool Deactivate(ULONG_PTR& ulpCookie);
private:
	HANDLE m_hActCtx;
};

/**
 * https://learn.microsoft.com/en-us/windows/win32/sbscs/isolating-components
 */
class CActCtxActivator
{
public:
	CActCtxActivator(CActivationContext& src, bool fActivate = true);
	~CActCtxActivator();
private:
	CActivationContext& m_ActCtx;
	ULONG_PTR m_Cookie;
	bool m_Activated;
};

class ExtendedHolder {
public:
	static typename ATL::template CComSafeArray<VARIANT> extended;
	static HRESULT SetLength(ULONG len);
	static HRESULT SetAt(LONG i, const VARIANT& value, bool copy = true);
	static HMODULE hModule;
	static void CreateActivationContext(HINSTANCE hInstance);
	static CActivationContext _ActCtx;
};

extern IDispatch* getRealIDispatch(VARIANT const* const& in_val);
extern const variant_t get_variant_in(VARIANT const* const& in_val);

extern const bool is_assignable_from(bool& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* const& in_val, bool& out_val);
extern const HRESULT autoit_to(VARIANT_BOOL& in_val, bool& out_val);
extern const HRESULT autoit_from(const bool& in_val, VARIANT_BOOL*& out_val);
extern const HRESULT autoit_from(const bool& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(std::string& out_val, BSTR const& in_val, bool is_optional);
extern const bool is_assignable_from(std::string& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(BSTR const& in_val, std::string& out_val);
extern const HRESULT autoit_to(VARIANT const* const& in_val, std::string& out_val);
extern const HRESULT autoit_from(std::string& in_val, BSTR& out_val);
extern const HRESULT autoit_from(const std::string& in_val, BSTR*& out_val);
extern const HRESULT autoit_from(const std::string& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(BSTR const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(char*& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* const& in_val, char*& out_val);

#define PTR_BRIDGE_DECL(_Tp) \
extern const bool is_assignable_from(_Tp& out_val, VARIANT const* const& in_val, bool is_optional); \
extern const HRESULT autoit_to(VARIANT const* const& in_val, _Tp& out_val); \
extern const HRESULT autoit_from(_Tp const& in_val, VARIANT*& out_val);

PTR_BRIDGE_DECL(void*)
PTR_BRIDGE_DECL(unsigned char*)
PTR_BRIDGE_DECL(HWND)

extern const HRESULT autoit_from(VARIANT const& in_val, VARIANT*& out_val);

extern const HRESULT autoit_out(IDispatch*& in_val, VARIANT*& out_val);
extern const HRESULT autoit_out(VARIANT const* const& in_val, VARIANT*& out_val);
extern const HRESULT autoit_out(VARIANT const* const& in_val, IDispatch**& out_val);
extern const HRESULT autoit_out(VARIANT const* const& in_val, BSTR*& out_val);

template<typename _Tp>
const bool is_assignable_from(std::vector<_Tp>& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) == VT_DISPATCH) {
		return dynamic_cast<TypeToImplType<std::vector<_Tp>>::type*>(getRealIDispatch(in_val)) != NULL;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();

	_Tp value;

	for (LONG i = lLower; i <= lUpper; i++) {
		auto& v = vArray.GetAt(i);
		VARIANT* pv = &v;
		if (!is_assignable_from(value, pv, false)) {
			hr = E_INVALIDARG;
			break;
		}
	}

	vArray.Detach();

	return SUCCEEDED(hr);
}

template<typename _Tp>
const bool is_assignable_from(AUTOIT_PTR<std::vector<_Tp>>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static std::vector<_Tp> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<typename _Tp>
const HRESULT autoit_to(VARIANT const* const& in_val, std::vector<_Tp>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) == VT_DISPATCH) {
		const auto& obj = dynamic_cast<TypeToImplType<std::vector<_Tp>>::type*>(getRealIDispatch(in_val));
		if (!obj) {
			return E_INVALIDARG;
		}
		out_val = *obj->__self->get();
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
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

		hr = autoit_to(pv, value);
		if (FAILED(hr)) {
			break;
		}

		out_val[i - lLower] = value;
	}

	vArray.Detach();
	return hr;
}

template<typename _Tp>
const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<std::vector<_Tp>>& out_val) {
	out_val = AUTOIT_MAKE_PTR<std::vector<_Tp>>();
	return autoit_to(in_val, *out_val.get());
}

template<typename _Tp>
const HRESULT autoit_from(const AUTOIT_PTR<std::vector<_Tp>>& in_val, VARIANT*& out_val) {
	return autoit_from(*in_val.get(), out_val);
}

template<typename _Tp>
const HRESULT autoit_from(const std::vector<_Tp>& in_val, VARIANT*& out_val) {
	if (PARAMETER_NULL(out_val) || PARAMETER_NOT_FOUND(out_val)) {
		V_VT(out_val) = VT_ARRAY | VT_VARIANT;
		typename ATL::template CComSafeArray<VARIANT> vArray((ULONG)0);
		V_ARRAY(out_val) = vArray.Detach();
	}

	if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

#pragma warning( push )
#pragma warning( disable : 4267)
	vArray.Resize(in_val.size());
#pragma warning( pop )

	for (LONG i = 0; SUCCEEDED(hr) && i < in_val.size(); i++) {
		VARIANT value = { VT_EMPTY };
		auto* pvalue = &value;
		hr = autoit_from(in_val[i], pvalue);

		if (SUCCEEDED(hr)) {
			AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(i, value)), "Failed to set value a index " << i);
		}

		VariantClear(&value);
	}

	vArray.Detach();
	return hr;
}

template<typename ... _Rest>
const bool is_assignable_from(std::tuple <_Rest...>& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	std::tuple<_Rest...> dummy;
	return SUCCEEDED(autoit_to(in_val, dummy));
}

template<std::size_t I = 0, typename... _Ts>
const HRESULT _autoit_to(VARIANT const* const& in_val, std::tuple<_Ts...>& out_val) {
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));
	auto& v = vArray.GetAt(I);
	auto* pv = &v;

	using _Tuple = typename std::tuple<_Ts...>;
	using _Type = typename std::tuple_element<I, _Tuple>::type;
	_Type value;

	HRESULT hr = is_assignable_from(value, pv, false);

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pv, value);
	}

	if (SUCCEEDED(hr)) {
		std::get<I>(out_val) = value;
	}

	vArray.Detach();
	return hr;
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I == sizeof...(_Ts) - 1, const HRESULT>::type
autoit_to(VARIANT const* const& in_val, std::tuple<_Ts...>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));
	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();
	vArray.Detach();

	if (lUpper - lLower + 1 < I) {
		return E_INVALIDARG;
	}

	return _autoit_to<I, _Ts...>(in_val, out_val);
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I != sizeof...(_Ts) - 1, const HRESULT>::type
autoit_to(VARIANT const* const& in_val, std::tuple<_Ts...>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	HRESULT hr = autoit_to<I + 1, _Ts...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	return _autoit_to<I, _Ts...>(in_val, out_val);
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I == sizeof...(_Ts), const HRESULT>::type
autoit_from(const std::tuple<_Ts...>& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_ARRAY | VT_VARIANT;
	typename ATL::template CComSafeArray<VARIANT> vArray((ULONG)I);
	V_ARRAY(out_val) = vArray.Detach();
	return S_OK;
}

template<std::size_t I = 0, typename... _Ts>
typename std::enable_if<I != sizeof...(_Ts), const HRESULT>::type
autoit_from(const std::tuple<_Ts...>& in_val, VARIANT*& out_val) {
	HRESULT hr = autoit_from<I + 1, _Ts...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

	VARIANT value = { VT_EMPTY };
	auto* pvalue = &value;
	hr = autoit_from(std::get<I>(in_val), pvalue);

	if (SUCCEEDED(hr)) {
		AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(I, value)), "Failed to set value a index " << I);
	}

	VariantClear(&value);

	vArray.Detach();
	return hr;
}

template<typename _Ty1, typename _Ty2>
const bool is_assignable_from(std::pair<_Ty1, _Ty2>& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	if (vArray.GetCount() != 2) {
		vArray.Detach();
		return false;
	}

	auto& vfirst = vArray.GetAt(0);
	auto* pvfirst = &vfirst;

	auto& vsecond = vArray.GetAt(1);
	auto* pvsecond = &vsecond;

	HRESULT hr = is_assignable_from(out_val.first, pvfirst, false);

	if (SUCCEEDED(hr)) {
		hr = is_assignable_from(out_val.second, pvsecond, false);
	}

	vArray.Detach();

	return hr;
}

template<typename _Ty1, typename _Ty2>
HRESULT autoit_to(VARIANT const* const& in_val, std::pair<_Ty1, _Ty2>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	if (vArray.GetCount() != 2) {
		vArray.Detach();
		return E_INVALIDARG;
	}

	auto& vfirst = vArray.GetAt(0);
	auto* pvfirst = &vfirst;

	auto& vsecond = vArray.GetAt(1);
	auto* pvsecond = &vsecond;

	HRESULT hr = is_assignable_from(out_val.first, pvfirst, false);

	if (SUCCEEDED(hr)) {
		hr = is_assignable_from(out_val.second, pvsecond, false);
	}

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pvfirst, out_val.first);
	}

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pvsecond, out_val.second);
	}

	vArray.Detach();
	return hr;
}

template<typename _Ty1, typename _Ty2>
HRESULT autoit_from(const std::pair<_Ty1, _Ty2>& in_val, VARIANT*& out_val) {
	typename ATL::template CComSafeArray<VARIANT> vArray(2);

	HRESULT hr;

	VARIANT value;
	VariantInit(&value);
	auto* pvalue = &value;

	hr = autoit_from(in_val.first, pvalue);
	if (SUCCEEDED(hr)) {
		AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(0, value)), "Failed to set value a index " << 0);

		VariantClear(&value);
		hr = autoit_from(in_val.second, pvalue);
		if (SUCCEEDED(hr)) {
			AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(1, value)), "Failed to set value a index " << 1);
		}
	}

	VariantClear(&value);

	VariantInit(out_val);
	V_VT(out_val) = VT_ARRAY | VT_VARIANT;
	V_ARRAY(out_val) = vArray.Detach();
	return S_OK;
}

template<typename _Tp>
HRESULT get_variant_number(VARIANT const* const& in_val, _Tp& out_val) {
	switch (V_VT(in_val)) {
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
	case VT_R4:
		out_val = static_cast<_Tp>(V_R4(in_val));
		return S_OK;
	case VT_R8:
		out_val = static_cast<_Tp>(V_R8(in_val));
		return S_OK;
	default:
		return PARAMETER_MISSING(in_val) ? S_OK : E_INVALIDARG;
	}
}

extern const bool is_variant_number(VARIANT const* const& in_val);

extern const HRESULT GetInterfaceName(IUnknown* punk, VARIANT* vres);

extern const bool is_assignable_from(_variant_t& out_val, VARIANT const* const& in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* const& in_val, _variant_t& out_val);

template<typename _Tp>
inline const bool is_assignable_from_ptr(_Tp& out_val, VARIANT const* const& in_val, bool is_optional) {
	return is_variant_number(in_val) || (PARAMETER_MISSING(in_val) && is_optional);
}

template<typename _Tp>
inline const HRESULT autoit_to_ptr(VARIANT const* const& in_val, _Tp& out_val) {
	ULONGLONG _out_val = 0;
	HRESULT hr = get_variant_number<ULONGLONG>(in_val, _out_val);
	if (FAILED(hr) || PARAMETER_MISSING(in_val)) {
		return hr;
	}

	out_val = reinterpret_cast<_Tp>(_out_val);
	return hr;
}

template<typename _Tp>
inline const HRESULT autoit_from_ptr(_Tp const& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_UI8;
	V_UI8(out_val) = reinterpret_cast<ULONGLONG>(in_val);
	return S_OK;
}

#define PTR_BRIDGE_IMPL(_Tp) \
\
const bool is_assignable_from(_Tp& out_val, VARIANT const* const& in_val, bool is_optional) { \
	return is_assignable_from_ptr(out_val, in_val, is_optional); \
} \
\
const HRESULT autoit_to(VARIANT const* const& in_val, _Tp& out_val) { \
	return autoit_to_ptr(in_val, out_val); \
} \
\
const HRESULT autoit_from(_Tp const& in_val, VARIANT*& out_val) { \
	return autoit_from_ptr(in_val, out_val); \
}

template<typename _Tp>
extern const bool is_assignable_from(_Tp& out_val, _Tp const& in_val, bool is_optional) {
	return is_optional;
}

template<typename _Tp>
extern const HRESULT autoit_to(_Tp const& in_val, _Tp& out_val) {
	out_val = in_val;
	return S_OK;
}

template<typename _Tp>
extern const HRESULT autoit_from(_Tp const& in_val, _Tp*& out_val) {
	*out_val = in_val;
	return S_OK;
}

#pragma push_macro("CV_EXPORTS_W_SIMPLE")
#pragma push_macro("CV_EXPORTS_W")
#pragma push_macro("CV_OUT")
#define MapOfStringAndVariant std::map<std::string, _variant_t>

#ifdef CV_EXPORTS_W_SIMPLE
#undef CV_EXPORTS_W_SIMPLE
#endif
#define CV_EXPORTS_W_SIMPLE

#ifdef CV_EXPORTS_W
#undef CV_EXPORTS_W
#endif
#define CV_EXPORTS_W

#ifdef CV_OUT
#undef CV_OUT
#endif
#define CV_OUT

class CV_EXPORTS_W_SIMPLE NamedParameters : public MapOfStringAndVariant {};

namespace autoit {
	template <typename _Tp>
	AUTOIT_PTR<typename _Tp> cast(IDispatch* element);

	template <typename _Tp>
	const AUTOIT_PTR<typename _Tp> cast(const IDispatch* element);

	template<typename _Tp>
	_Tp cast(VARIANT const* const& in_val) {
		_Tp value;
		AUTOIT_ASSERT_THROW(SUCCEEDED(autoit_to(in_val, value)), "Invalid argument");
		return value;
	}

	template <typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(_Tp* element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, element);
	}

	template <typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(const _Tp* element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, const_cast<_Tp*>(element));
	}

	template <typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(_Tp& element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, & element);
	}

	template <typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(const _Tp& element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, const_cast<_Tp*>(&element));
	}

	template<typename destination_type, typename source_type>
	struct _GenericCopy {
		inline static HRESULT copy(destination_type* pTo, const source_type* pFrom) {
			AUTOIT_PTR<source_type> sp = ::autoit::reference_internal(pFrom);
			return autoit_from(sp, pTo);
		}
	};

	template<typename destination_type, typename source_type>
	struct _GenericCopy<destination_type, AUTOIT_PTR<source_type>> {
		inline static HRESULT copy(destination_type* pTo, const AUTOIT_PTR<source_type>* pFrom) {
			return autoit_from(&pFrom, pTo);
		}
	};

	template<typename destination_type, typename ... _Rest>
	struct _GenericCopy<destination_type, std::tuple <_Rest...>> {
		inline static HRESULT copy(destination_type* pTo, const std::tuple <_Rest...>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template <typename destination_type, typename _Ty1, typename _Ty2>
	struct _GenericCopy<destination_type, std::pair<_Ty1, _Ty2>> {
		inline static HRESULT copy(destination_type* pTo, const std::pair<_Ty1, _Ty2>* pFrom) {
			return autoit_from(*pFrom, pTo);
		}
	};

	template<typename destination_type>
	struct _GenericCopy<destination_type, _variant_t> {
		inline static HRESULT copy(destination_type* pTo, const _variant_t* pFrom) {
			return _Copy<destination_type>::copy(pTo, pFrom);
		}
	};

#define NATIVE_TYPE_GENERIC_COPY(source_type) \
	template<typename destination_type> \
	struct _GenericCopy<destination_type, source_type> { \
		inline static HRESULT copy(destination_type* pTo, const source_type* pFrom) { \
			return autoit_from(*pFrom, pTo); \
		} \
	};

	NATIVE_TYPE_GENERIC_COPY(int);
	NATIVE_TYPE_GENERIC_COPY(UINT);
	NATIVE_TYPE_GENERIC_COPY(long);
	NATIVE_TYPE_GENERIC_COPY(ULONG);
	NATIVE_TYPE_GENERIC_COPY(int64_t);
	NATIVE_TYPE_GENERIC_COPY(uint64_t);
	NATIVE_TYPE_GENERIC_COPY(double);
	NATIVE_TYPE_GENERIC_COPY(float);
	NATIVE_TYPE_GENERIC_COPY(bool);
	NATIVE_TYPE_GENERIC_COPY(std::string);

	template<typename source_type>
	class GenericCopy
	{
	public:
		static void init(VARIANT* p)
		{
			_Copy<VARIANT>::init(p);
		}
		static void destroy(VARIANT* p)
		{
			_Copy<VARIANT>::destroy(p);
		}
		static HRESULT copy(VARIANT* pTo, const source_type* pFrom)
		{
			return _GenericCopy<VARIANT, source_type>::copy(pTo, pFrom);
		}
	};

	const int FLTA_FILES = 1 << 0;
	const int FLTA_FOLDERS = 1 << 1;
	const int FLTA_FILESFOLDERS = FLTA_FILES | FLTA_FOLDERS;

	CV_EXPORTS_W void findFiles(
		CV_OUT std::vector<std::string>& matches,
		const std::string& path,
		const std::string& directory,
		int flags = FLTA_FILESFOLDERS,
		bool relative = true
	);

	CV_EXPORTS_W std::string findFile(
		const std::string& path,
		const std::string& directory,
		const std::string& filter = "",
		const std::vector<std::string>& hints = std::vector<std::string>(1, ".")
	);
}

#pragma pop_macro("CV_EXPORTS_W_SIMPLE")
#pragma pop_macro("CV_EXPORTS_W")
#pragma pop_macro("CV_OUT")
#undef MapOfStringAndVariant

namespace ATL {
	template<typename T, typename CollType, typename EnumType, typename AutoItType = AutoItObject<CollType>>
	class IAutoItCollectionEnumOnSTLImpl :
		public T,
		public AutoItType
	{
	public:
		STDMETHOD(get__NewEnum)(_Outptr_ IUnknown** ppUnk)
		{
			CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);

			auto& m_coll = *this->__self->get();
			if (ppUnk == NULL)
				return E_POINTER;
			*ppUnk = NULL;
			HRESULT hRes = S_OK;
			CComObject<EnumType>* p;
			hRes = CComObject<EnumType>::CreateInstance(&p);
			if (SUCCEEDED(hRes))
			{
				hRes = p->Init(this, m_coll);
				if (hRes == S_OK)
					hRes = p->QueryInterface(__uuidof(IUnknown), (void**)ppUnk);
			}
			if (hRes != S_OK)
				delete p;
			return hRes;
		}
	};
}

#define Base IEnumVARIANT
#define T VARIANT
#define piid &IID_IEnumVARIANT

template <class Copy, class CollType>
class ATL_NO_VTABLE IEnumOnSTLImpl<Base, piid, T, Copy, CollType> :
	public Base
{
public:

	HRESULT Init(
		_In_ IUnknown* pUnkForRelease,
		_In_ CollType& collection)
	{
		m_spUnk = pUnkForRelease;
		m_pcollection = &collection;
		m_iter = m_pcollection->begin();
		return S_OK;
	}
	STDMETHOD(Next)(
		_In_ ULONG celt,
		_Out_writes_to_(celt, *pceltFetched) T* rgelt,
		_Out_opt_ ULONG* pceltFetched);
	STDMETHOD(Skip)(_In_ ULONG celt);
	STDMETHOD(Reset)(void)
	{
		if (m_pcollection == NULL)
			return E_FAIL;
		m_iter = m_pcollection->begin();
		return S_OK;
	}
	STDMETHOD(Clone)(_Outptr_ Base** ppEnum);
	//Data
	CComPtr<IUnknown> m_spUnk;
	CollType* m_pcollection;
	typename CollType::const_iterator m_iter;
};

template <class Copy, class CollType>
COM_DECLSPEC_NOTHROW STDMETHODIMP IEnumOnSTLImpl<Base, piid, T, Copy, CollType>::Next(
	_In_ ULONG celt,
	_Out_writes_to_(celt, *pceltFetched) T* rgelt,
	_Out_opt_ ULONG* pceltFetched)
{
	CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);

	if (rgelt == NULL || (celt > 1 && pceltFetched == NULL))
		return E_POINTER;
	if (pceltFetched != NULL)
		*pceltFetched = 0;
	if (m_pcollection == NULL)
		return E_FAIL;

	ULONG nActual = 0;
	HRESULT hr = S_OK;
	T* pelt = rgelt;
	while (SUCCEEDED(hr) && m_iter != m_pcollection->end() && nActual < celt)
	{
		if constexpr (std::is_same<CollType, std::vector<bool>>::value) {
			auto value = *m_iter;
			hr = Copy::copy(pelt, &value);
		}
		else {
			hr = Copy::copy(pelt, &*m_iter);
		}
		if (FAILED(hr))
		{
			while (rgelt < pelt)
				Copy::destroy(rgelt++);
			nActual = 0;
		}
		else
		{
			pelt++;
			m_iter++;
			nActual++;
		}
	}
	if (SUCCEEDED(hr))
	{
		if (pceltFetched)
			*pceltFetched = nActual;
		if (nActual < celt)
			hr = S_FALSE;
	}
	return hr;
}

template <class Copy, class CollType>
COM_DECLSPEC_NOTHROW STDMETHODIMP IEnumOnSTLImpl<Base, piid, T, Copy, CollType>::Skip(_In_ ULONG celt)
{
	CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);

	HRESULT hr = S_OK;
	while (celt--)
	{
		if (m_iter != m_pcollection->end())
			m_iter++;
		else
		{
			hr = S_FALSE;
			break;
		}
	}
	return hr;
}

template <class Copy, class CollType>
COM_DECLSPEC_NOTHROW STDMETHODIMP IEnumOnSTLImpl<Base, piid, T, Copy, CollType>::Clone(
	_Outptr_ Base** ppEnum)
{
	CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);

	typedef CComObject<CComEnumOnSTL<Base, piid, T, Copy, CollType> > _class;
	HRESULT hRes = E_POINTER;
	if (ppEnum != NULL)
	{
		*ppEnum = NULL;
		_class* p;
		hRes = _class::CreateInstance(&p);
		if (SUCCEEDED(hRes))
		{
			hRes = p->Init(m_spUnk, *m_pcollection);
			if (SUCCEEDED(hRes))
			{
				p->m_iter = m_iter;
				hRes = p->_InternalQueryInterface(*piid, (void**)ppEnum);
			}
			if (FAILED(hRes))
				delete p;
		}
	}
	return hRes;
}

#undef Base
#undef T
#undef piid
