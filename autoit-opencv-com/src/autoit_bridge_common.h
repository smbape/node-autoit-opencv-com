#pragma once
#pragma comment(lib, "comsuppw.lib")

#include <algorithm>
#include <atlbase.h>
#include <atlcom.h>
#include <atlctl.h>
#include <atlsafe.h>
#include <comutil.h>
#include <chrono>
#include <iostream>
#include <map>
#include <memory>
#include <mutex>
#include <numeric>
#include <OleAuto.h>
#include <optional>
#include <queue>
#include <sstream>
#include <string>
#include <tuple>
#include <type_traits>
#include <typeindex>
#include <typeinfo>
#include <utility>
#include <variant>
#include <vector>

#include "autoit_def.h"

#ifndef CV_PROP_W
#define CV_PROP_W
#endif

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

#ifndef AUTOIT_QUOTE_WSTRING2
#define AUTOIT_QUOTE_WSTRING2(x) L#x
#endif
#ifndef AUTOIT_QUOTE_WSTRING
#define AUTOIT_QUOTE_WSTRING(x) AUTOIT_QUOTE_WSTRING2(x)
#endif

#define AUTOIT_WIDEN2(x) L ## x
#define AUTOIT_WIDEN(x) AUTOIT_WIDEN2(x)

#ifndef AUTOIT_INFO
#define AUTOIT_INFO( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
		"(%s) Info: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_WINFO
#define AUTOIT_WINFO( _message ) do { \
	std::wostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fwprintf(stderr, \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_NAME) \
		L"(%s) Info: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AUTOIT_WIDEN(AutoIt_Func), AUTOIT_WIDEN(__FILE__), __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_WARN
#define AUTOIT_WARN( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
		"(%s) Warning: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_WWARN
#define AUTOIT_WWARN( _message ) do { \
	std::wostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fwprintf(stderr, \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_NAME) \
		L"(%s) Warning: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_VERSION), AUTOIT_WIDEN(AutoIt_Func), AUTOIT_WIDEN(__FILE__), __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_ERROR
#define AUTOIT_ERROR( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
		"(%s) Error: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_WERROR
#define AUTOIT_WERROR( _message ) do { \
	std::wostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fwprintf(stderr, \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_NAME) \
		L"(%s) Error: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_WSTRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AUTOIT_WIDEN(AutoIt_Func), AUTOIT_WIDEN(__FILE__), __LINE__); \
	fflush(stdout); fflush(stderr);         \
} while(0)
#endif

#ifndef AUTOIT_THROW
#define AUTOIT_THROW( _message ) do { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
		"(%s) Error: %s in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);           \
	throw std::exception(_out.str().c_str()); \
} while(0)
#endif

#ifndef AUTOIT_ASSERT_THROW
#define AUTOIT_ASSERT_THROW( expr, _message ) do { if(!!(expr)) ; else { \
	std::ostringstream _out; _out << _message;	\
	fflush(stdout); fflush(stderr);         \
	fprintf(stderr, \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
		"(%s) Error: %s (%s) in %s, file %s, line %d\n", \
		AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), _out.str().c_str(), #expr, AutoIt_Func, __FILE__, __LINE__); \
	fflush(stdout); fflush(stderr);         \
	throw std::exception(_out.str().c_str());    \
}} while(0)
#endif

#ifndef AUTOIT_ASSERT_SET_HR
#define AUTOIT_ASSERT_SET_HR( expr ) do { if(!!(expr)) { hr = S_OK; } else { \
fflush(stdout); fflush(stderr); \
fprintf(stderr, \
	AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
	"(%s) Error: (%s) in %s, file %s, line %d\n", \
	AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), #expr, AutoIt_Func, __FILE__, __LINE__); \
fflush(stdout); fflush(stderr); \
hr = E_FAIL; } \
} while(0)
#endif

#ifndef AUTOIT_ASSERT
#define AUTOIT_ASSERT( expr ) do { if(!!(expr)) ; else { \
fflush(stdout); fflush(stderr); \
fprintf(stderr, \
	AUTOIT_QUOTE_STRING(AUTOIT_LIB_NAME) \
	"(%s) Error: (%s) in %s, file %s, line %d\n", \
	AUTOIT_QUOTE_STRING(AUTOIT_LIB_VERSION), #expr, AutoIt_Func, __FILE__, __LINE__); \
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

extern IDispatch* getRealIDispatch(VARIANT const* in_val);
extern const variant_t get_variant_in(VARIANT const* in_val);

extern const bool is_assignable_from(bool& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, bool& out_val);
extern const HRESULT autoit_to(VARIANT_BOOL const& in_val, bool& out_val);
extern const HRESULT autoit_from(bool const& in_val, VARIANT_BOOL*& out_val);
extern const HRESULT autoit_from(bool const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(std::string& out_val, BSTR const& in_val, bool is_optional);
extern const bool is_assignable_from(std::string& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(BSTR const& in_val, std::string& out_val);
extern const HRESULT autoit_to(VARIANT const* in_val, std::string& out_val);
extern const HRESULT autoit_from(std::string const& in_val, BSTR& out_val);
extern const HRESULT autoit_from(std::string const& in_val, BSTR*& out_val);
extern const HRESULT autoit_from(std::string const& in_val, VARIANT*& out_val);
extern const HRESULT autoit_from(BSTR const& in_val, VARIANT*& out_val);

extern const bool is_assignable_from(char*& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, char*& out_val);

#define PTR_BRIDGE_DECL(_Tp) \
extern const bool is_assignable_from(_Tp& out_val, VARIANT const* in_val, bool is_optional); \
extern const HRESULT autoit_to(VARIANT const* in_val, _Tp& out_val); \
extern const HRESULT autoit_from(_Tp const& in_val, VARIANT*& out_val);

PTR_BRIDGE_DECL(void*)
PTR_BRIDGE_DECL(unsigned char*)
PTR_BRIDGE_DECL(HWND)

extern const HRESULT autoit_from(VARIANT const& in_val, VARIANT*& out_val);

extern const HRESULT autoit_out(IDispatch*& out_val, VARIANT* const retval);
extern const HRESULT autoit_out(VARIANT*& out_val, VARIANT* const retval);
extern const HRESULT autoit_out(VARIANT*& out_val, IDispatch** const retval);
extern const HRESULT autoit_out(VARIANT*& out_val, BSTR* const retval);

// ================================
// T if std::is_enum_v<T>
// ================================

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const bool> is_assignable_from(T& out_val, VARIANT const* in_val, bool is_optional);

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const HRESULT> autoit_to(VARIANT const* in_val, T& out_val);

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const HRESULT> autoit_from(T const& in_val, VARIANT*& out_val);

// ================================

// ================================
// std::optional
// ================================

template<typename T>
const bool is_assignable_from(std::optional<T>& out_val, VARIANT const* in_val, bool is_optional);

template<typename T>
const HRESULT autoit_to(VARIANT const* in_val, std::optional<T>& out_val);

template<typename T>
const HRESULT autoit_from(std::optional<T> const& in_val, VARIANT*& out_val);

template<typename T>
const HRESULT autoit_out(std::optional<T>& out_val, VARIANT* const retval);

// ================================

// ================================
// std::pair
// ================================

template<typename _Ty1, typename _Ty2>
const bool is_assignable_from(std::pair<_Ty1, _Ty2>& out_val, VARIANT const* in_val, bool is_optional);

template<typename _Ty1, typename _Ty2>
HRESULT autoit_to(VARIANT const* in_val, std::pair<_Ty1, _Ty2>& out_val);

template<typename _Ty1, typename _Ty2>
const HRESULT autoit_from(std::pair<_Ty1, _Ty2> const& in_val, VARIANT*& out_val);

// ================================

// ================================
// std::tuple
// ================================

template<typename ... Types>
const bool is_assignable_from(std::tuple <Types...>& out_val, VARIANT const* in_val, bool is_optional);

template<std::size_t I = 0, typename... Types>
typename std::enable_if<I == sizeof...(Types) - 1, const HRESULT>::type
autoit_to(VARIANT const* in_val, std::tuple<Types...>& out_val);

template<std::size_t I = 0, typename... Types>
typename std::enable_if<I != sizeof...(Types) - 1, const HRESULT>::type
autoit_to(VARIANT const* in_val, std::tuple<Types...>& out_val);

template<std::size_t I = 0, typename... Types>
typename std::enable_if<I == sizeof...(Types), const HRESULT>::type
autoit_from(std::tuple<Types...> const& in_val, VARIANT*& out_val);

template<std::size_t I = 0, typename... Types>
typename std::enable_if<I != sizeof...(Types), const HRESULT>::type
autoit_from(std::tuple<Types...> const& in_val, VARIANT*& out_val);

// ================================

// ================================
// std::vector
// ================================

template<class T, class Allocator = std::allocator<T>>
const bool is_assignable_from(std::vector<T, Allocator>& out_val, VARIANT const* in_val, bool is_optional);

template<class T, class Allocator = std::allocator<T>>
const bool is_assignable_from(AUTOIT_PTR<std::vector<T, Allocator>>& out_val, VARIANT const* in_val, bool is_optional);

template<class T, class Allocator = std::allocator<T>>
const HRESULT autoit_to(VARIANT const* in_val, std::vector<T, Allocator>& out_val);

template<class T, class Allocator = std::allocator<T>>
const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<std::vector<T, Allocator>>& out_val);

template<class T, class Allocator = std::allocator<T>>
const HRESULT autoit_from(AUTOIT_PTR<std::vector<T, Allocator>> const& in_val, VARIANT*& out_val);

template<class T, class Allocator = std::allocator<T>>
const HRESULT autoit_from(std::vector<T, Allocator> const& in_val, VARIANT*& out_val);

// ================================

// ================================
// std::variant
// ================================

template<typename... Types>
const bool is_assignable_from(std::variant<Types...>& out_val, VARIANT const* in_val, bool is_optional);

template<typename... Types>
const HRESULT autoit_to(VARIANT const* in_val, std::variant<Types...>& out_val);

template<typename... Types>
const HRESULT autoit_from(std::variant<Types...> const& in_val, VARIANT*& out_val);

// ================================

// ================================
// T if is_usertype_v<T>
// ================================

namespace autoit {
	// ================================
	// is_usertype generics
	// ================================

	template<typename T>
	struct is_usertype : std::false_type {};

	template<typename T>
	constexpr inline bool is_usertype_v = is_usertype<T>::value;

	// Source - https://stackoverflow.com/questions/11251376/how-can-i-check-if-a-type-is-an-instantiation-of-a-given-class-template#11251408
	// Posted by Luc Touraille
	// Retrieved 2026-05-20, License - CC BY-SA 3.0

	template<template<typename...> class Template, typename T>
	struct is_instantiation_of : std::false_type {};

	template<template<typename...> class Template, typename... Types>
	struct is_instantiation_of<Template, Template<Types...>> : std::true_type {};

	template <template <typename...> class Template, typename T>
	constexpr inline bool is_instantiation_of_v = is_instantiation_of<Template, T>::value;
}

template<typename T>
std::enable_if_t<autoit::is_usertype_v<T>&& std::is_assignable_v<T&, T>, const bool> is_assignable_from(T& out_val, VARIANT const* in_val, bool is_optional);
template<typename T>
std::enable_if_t<autoit::is_usertype_v<T>&& std::is_assignable_v<T&, T>, const HRESULT> autoit_to(VARIANT const* in_val, T& out_val);

// ================================

// ================================
// autoit_from_reference
// ================================

template<typename T, typename V>
std::enable_if_t<autoit::is_usertype_v<T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val);

template<typename T, typename V>
std::enable_if_t<!autoit::is_usertype_v<T> && autoit::is_instantiation_of_v<std::optional, T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val);

template<typename T, typename V>
std::enable_if_t<!autoit::is_usertype_v<T> && !autoit::is_instantiation_of_v<std::optional, T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val);

template<typename T, typename V>
std::enable_if_t<!std::is_reference_v<T>, const HRESULT> autoit_from_reference(const T& in_val, V& out_val);

// ================================

template<typename _Tp>
HRESULT get_variant_number(VARIANT const* in_val, _Tp& out_val) {
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

extern const bool is_variant_number(VARIANT const* in_val);

extern const HRESULT GetInterfaceName(IUnknown* punk, VARIANT* vres);

extern const bool is_assignable_from(_variant_t& out_val, VARIANT const* in_val, bool is_optional);
extern const HRESULT autoit_to(VARIANT const* in_val, _variant_t& out_val);

template<typename _Tp>
inline const bool is_assignable_from_ptr(_Tp& out_val, VARIANT const* in_val, bool is_optional) {
	return is_variant_number(in_val) || (PARAMETER_MISSING(in_val) && is_optional);
}

template<typename _Tp>
inline const HRESULT autoit_to_ptr(VARIANT const* in_val, _Tp& out_val) {
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
const bool is_assignable_from(_Tp& out_val, VARIANT const* in_val, bool is_optional) { \
	return is_assignable_from_ptr(out_val, in_val, is_optional); \
} \
\
const HRESULT autoit_to(VARIANT const* in_val, _Tp& out_val) { \
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
#pragma push_macro("CV_WRAP")
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

#ifdef CV_WRAP
#undef CV_WRAP
#endif
#define CV_WRAP

#ifdef CV_OUT
#undef CV_OUT
#endif
#define CV_OUT

class CV_EXPORTS_W_SIMPLE NamedParameters : public MapOfStringAndVariant {
public:
	CV_WRAP static bool isNamedParameters(const NamedParameters& value) {
		return true;
	}

	CV_WRAP static bool isNamedParameters(VARIANT* value = nullptr) {
		return false;
	}
};

namespace autoit {
	// ================================
	// __str__
	// ================================

	template<typename T>
	std::string __str__(const T& obj, const std::string& type);

	// ================================

	// ================================
	// __eq__
	// ================================

	template<typename T>
	bool __eq__(const std::shared_ptr<T>& p1, const std::shared_ptr<T>& p2);

	template<typename K, typename V>
	bool __eq__(const std::map<K, V>& m1, const std::map<K, V>& m2);

	template<typename T1, typename T2>
	bool __eq__(const std::pair<T1, T2>& p1, const std::pair<T1, T2>& p2);

	template<typename T>
	bool __eq__(const std::vector<T>& v1, const std::vector<T>& v2);

	template<typename T>
	bool __eq__(const T& o1, const T& o2);

	// ================================

	template<typename _Tp>
	AUTOIT_PTR<typename _Tp> cast(IDispatch* in_val);

	template<typename _Tp>
	const AUTOIT_PTR<typename _Tp> cast(IDispatch const* in_val);

	template<typename _Tp>
	inline _Tp cast(VARIANT const* in_val) {
		_Tp value;
		AUTOIT_ASSERT_THROW(SUCCEEDED(autoit_to(in_val, value)), "Invalid argument");
		return value;
	}

	template<typename _Tp>
	inline const AUTOIT_PTR<typename _Tp> reference_internal(_Tp* element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, element);
	}

	template<typename _Tp>
	inline const AUTOIT_PTR<typename _Tp> reference_internal(const _Tp* element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, const_cast<_Tp*>(element));
	}

	template<typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(_Tp& element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, & element);
	}

	template<typename _Tp>
	const AUTOIT_PTR<typename _Tp> reference_internal(const _Tp& element) {
		return AUTOIT_PTR<_Tp>(AUTOIT_PTR<_Tp>{}, const_cast<_Tp*>(&element));
	}

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

		template<typename destination_type, typename source_type>
		inline static HRESULT copy(destination_type* pTo, source_type* pFrom) {
			return autoit_from_reference(*pFrom, pTo);
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

	class CV_EXPORTS_W_SIMPLE Buffer : public std::string {
	public:
		Buffer() : std::string() {}
		CV_WRAP Buffer(const void* data, size_t size) : std::string((char*)data, size) {}
	};
}

namespace com {
	class CV_EXPORTS_W Thread {
	public:
		using Function = void (*)();

		CV_WRAP Thread(void* func) : m_func(reinterpret_cast<Function>(func)) {}
		CV_WRAP void start();
		CV_WRAP void join();
	private:
		Function m_func = nullptr;
		std::unique_ptr<std::thread> m_thread;
	};

	class CV_EXPORTS_W ThreadSafeQueue : public std::queue<VARIANT*>
	{
	public:
		CV_WRAP ThreadSafeQueue() {}
		CV_WRAP void push(VARIANT* entry);
		CV_WRAP VARIANT* get();
		CV_WRAP void clear();
	private:
		std::mutex m_mutex;
	};
}

#pragma pop_macro("CV_EXPORTS_W_SIMPLE")
#pragma pop_macro("CV_EXPORTS_W")
#pragma pop_macro("CV_WRAP")
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
	typename CollType::iterator m_iter;
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
			const auto value = *m_iter;
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
