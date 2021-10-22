#include "autoit_bridge.h"
#include "Cv_Mat_Object.h"
#include "Cv_GRunArg_Object.h"
#include "Cv_GMatDesc_Object.h"
#include "Cv_GScalarDesc_Object.h"
#include "Cv_GArrayDesc_Object.h"
#include "Cv_GOpaqueDesc_Object.h"
#include "Cv_Gapi_Wip_Draw_Rect_Object.h"
#include "Cv_Gapi_Wip_Draw_Text_Object.h"
#include "Cv_Gapi_Wip_Draw_Circle_Object.h"
#include "Cv_Gapi_Wip_Draw_Line_Object.h"
#include "Cv_Gapi_Wip_Draw_Poly_Object.h"
#include "Cv_Gapi_Wip_Draw_Mosaic_Object.h"
#include "Cv_Gapi_Wip_Draw_Image_Object.h"

// import the .TLB that's compiled in scrrun.dll
#import "C:\Windows\System32\scrrun.dll" \
	rename("CopyFile", "CopyFile2") \
	rename("DeleteFile", "DeleteFile2") \
	rename("FreeSpace", "FreeSpace2") \
	rename("MoveFile", "MoveFile2") \
	// avoid name collision with Windows SDK's GetFreeSpace macro, this is specific to scrrun.dll

ATL::CComSafeArray<VARIANT> ExtendedHolder::extended((ULONG)0);
HMODULE ExtendedHolder::hModule = GetModuleHandle(NULL);

HRESULT ExtendedHolder::SetLength(ULONG len) {
	return extended.Resize(len);
}

HRESULT ExtendedHolder::SetAt(LONG i, const VARIANT& value, bool copy) {
	return extended.SetAt(i, value, copy);
}

IDispatch* getRealIDispatch(VARIANT const* const& in_val) {
	auto dispatch = V_DISPATCH(in_val);

	MEMORY_BASIC_INFORMATION info;
	VirtualQuery(*reinterpret_cast<void**>(dispatch), &info, sizeof(info));

	if (info.AllocationBase == ExtendedHolder::hModule) {
		// Assume autoit object
		dispatch = *reinterpret_cast<IDispatch**>(reinterpret_cast<char*>(dispatch) + 0x10);
	}

	return dispatch;
}

const bool is_assignable_from(bool& out_val, VARIANT const* const& in_val, bool is_optional) {
	switch (V_VT(in_val)) {
	case VT_BOOL:
		return true;
	case VT_ERROR:
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
	default:
		return false;
	}
}

const HRESULT autoit_opencv_to(VARIANT_BOOL& in_val, bool& out_val) {
	out_val = in_val == VARIANT_TRUE;
	return S_OK;
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, bool& out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	if (V_VT(in_val) != VT_BOOL) {
		return E_INVALIDARG;
	}

	out_val = V_BOOL(in_val) == VARIANT_TRUE;
	return S_OK;
}

const HRESULT autoit_opencv_from(const bool& in_val, VARIANT_BOOL*& out_val) {
	*out_val = in_val ? VARIANT_TRUE : VARIANT_FALSE;
	return S_OK;
}

const bool is_assignable_from(std::string& out_val, BSTR const& in_val, bool is_optional) {
	return true;
}

const bool is_assignable_from(std::string& out_val, VARIANT const* const& in_val, bool is_optional) {
	switch (V_VT(in_val)) {
	case VT_BSTR:
		return true;
	case VT_ERROR:
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
	default:
		return false;
	}
}

const HRESULT autoit_opencv_to(BSTR const& in_val, std::string& out_val) {
	if (in_val) {
		std::wstring wide(in_val);
		out_val = std::string(wide.length(), 0);
		std::transform(wide.begin(), wide.end(), out_val.begin(), [](wchar_t c) {
			return (char)c;
		});
		return S_OK;
	}
	return E_INVALIDARG;
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, std::string& out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	if (V_VT(in_val) != VT_BSTR) {
		return E_INVALIDARG;
	}

	return autoit_opencv_to(V_BSTR(in_val), out_val);
}

const HRESULT autoit_opencv_from(std::string& in_val, BSTR& out_val) {
	auto* pout_val = &out_val;
	return autoit_opencv_from(in_val, pout_val);
}

const HRESULT autoit_opencv_from(const std::string& in_val, BSTR*& out_val) {
	// assuming strings are utf8 encoded
	// https://stackoverflow.com/a/6284978
	std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
	std::wstring ws = converter.from_bytes(in_val);
	*out_val = SysAllocStringLen(ws.data(), ws.size());
	return S_OK;
}

const HRESULT autoit_opencv_from(const std::string& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_BSTR;
	BSTR bstrVal;
	BSTR* pbstrVal = &bstrVal;
	HRESULT hr = autoit_opencv_from(in_val, pbstrVal);
	V_BSTR(out_val) = bstrVal;
	return hr;
}

const HRESULT autoit_opencv_from(BSTR const& in_val, VARIANT*& out_val) {
	VARIANT variant = { VT_BSTR };
	V_BSTR(&variant) = in_val;
	VariantCopyInd(out_val, &variant);
	return S_OK;
}

const bool is_assignable_from(char*& out_val, VARIANT const* const& in_val, bool is_optional) {
	switch (V_VT(in_val)) {
	case VT_BSTR:
		return true;
	case VT_ERROR:
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
	default:
		return false;
	}
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, char*& out_val) {
	std::string str;
	HRESULT hr = autoit_opencv_to(in_val, str);
	if (SUCCEEDED(hr)) {
		out_val = const_cast<char*>(str.c_str());
	}
	return hr;
}

const bool is_assignable_from(void*& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (is_variant_number(in_val)) {
		return true;
	}

	switch (V_VT(in_val)) {
		case VT_EMPTY:
			return true;
		case VT_ERROR:
			return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
		default:
			return false;
	}
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, void*& out_val) {
	ULONGLONG _out_val = 0;
	HRESULT hr = get_variant_number<ULONGLONG>(in_val, _out_val);
	if (FAILED(hr) || is_parameter_missing(in_val)) {
		return hr;
	}

	out_val = reinterpret_cast<void*>(_out_val);
	return hr;
}

const HRESULT autoit_opencv_from(uchar const* const& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_UI8;
	V_UI8(out_val) = reinterpret_cast<ULONGLONG>(in_val);
	return S_OK;
}

const HRESULT autoit_opencv_from(cv::MatExpr& in_val, ICv_Mat_Object**& out_val) {
	return autoit_opencv_from(cv::Mat(in_val), out_val);
}

const HRESULT autoit_opencv_from(VARIANT const& in_val, VARIANT*& out_val) {
	return VariantCopyInd(out_val, &in_val);
}

const HRESULT autoit_opencv_out(IDispatch*& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_DISPATCH;
	V_DISPATCH(out_val) = in_val;
	in_val->AddRef();
	return S_OK;
}

const HRESULT autoit_opencv_out(VARIANT const* const& in_val, VARIANT*& out_val) {
	return VariantCopyInd(out_val, in_val);
}

const HRESULT autoit_opencv_out(VARIANT const* const& in_val, IDispatch**& out_val) {
	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	if (*out_val) {
		(*out_val)->Release();
	}

	*out_val = getRealIDispatch(in_val);
	(*out_val)->AddRef();
	return S_OK;
}

const HRESULT autoit_opencv_out(VARIANT const* const& in_val, BSTR*& out_val) {
	if (V_VT(in_val) != VT_BSTR) {
		return E_INVALIDARG;
	}

	*out_val = SysAllocString(V_BSTR(in_val));
	return *out_val == NULL && V_BSTR(in_val) != NULL ? E_OUTOFMEMORY : S_OK;
}

const bool is_variant_number(VARIANT const* const& in_val) {
	switch (V_VT(in_val)) {
		case VT_I2:
		case VT_I4:
		case VT_I1:
		case VT_UI1:
		case VT_UI2:
		case VT_UI4:
		case VT_I8:
		case VT_UI8:
		case VT_INT:
		case VT_UINT:
			return true;
		default:
			return false;
	}
}

const bool is_variant_scalar(VARIANT const* const& in_val) {
	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	cv::Scalar out_val;
	return SUCCEEDED(autoit_opencv_to(in_val, out_val));
}

const bool is_array_from(VARIANT const* const& in_val, bool is_optional) {
	if (is_parameter_missing(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return is_variant_scalar(in_val);
	}

	return dynamic_cast<IVariantArray*>(getRealIDispatch(in_val)) ? true : false;
}

const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional) {
	if (is_parameter_missing(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return false;
	}

	return dynamic_cast<IVariantArrays*>(getRealIDispatch(in_val)) ? true : false;
}

const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional) {
	cv::GMatDesc value_GMatDesc;
	cv::GScalarDesc value_GScalarDesc;
	cv::GArrayDesc value_GArrayDesc;
	cv::GOpaqueDesc value_GOpaqueDesc;
	return is_assignable_from(value_GMatDesc, in_val, is_optional)
		|| is_assignable_from(value_GScalarDesc, in_val, is_optional)
		|| is_assignable_from(value_GArrayDesc, in_val, is_optional)
		|| is_assignable_from(value_GOpaqueDesc, in_val, is_optional)
	;
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::GMetaArg& out_val) {
	cv::GMatDesc value_GMatDesc;
	cv::GScalarDesc value_GScalarDesc;
	cv::GArrayDesc value_GArrayDesc;
	cv::GOpaqueDesc value_GOpaqueDesc;

	HRESULT hr = S_OK;

	if (is_assignable_from(value_GMatDesc, in_val, false)) {
		hr = autoit_opencv_to(in_val, value_GMatDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GMatDesc;
		}
	} else if (is_assignable_from(value_GScalarDesc, in_val, false)) {
		hr = autoit_opencv_to(in_val, value_GScalarDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GScalarDesc;
		}
	} else if (is_assignable_from(value_GArrayDesc, in_val, false)) {
		hr = autoit_opencv_to(in_val, value_GArrayDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GArrayDesc;
		}
	} else if (is_assignable_from(value_GOpaqueDesc, in_val, false)) {
		hr = autoit_opencv_to(in_val, value_GOpaqueDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GOpaqueDesc;
		}
	}


	return hr;
}

const HRESULT autoit_opencv_from(const GMetaArg& in_val, VARIANT*& out_val) {
	switch (in_val.index()) {
		case cv::GMetaArg::index_of<cv::GMatDesc>():
			return autoit_opencv_from(util::get<cv::GMatDesc>(in_val), out_val);

		case cv::GMetaArg::index_of<cv::GScalarDesc>():
			return autoit_opencv_from(util::get<cv::GScalarDesc>(in_val), out_val);

		case cv::GMetaArg::index_of<cv::GOpaqueDesc>():
			return autoit_opencv_from(util::get<cv::GOpaqueDesc>(in_val), out_val);

		case cv::GMetaArg::index_of<cv::GArrayDesc>():
			return autoit_opencv_from(util::get<cv::GArrayDesc>(in_val), out_val);

		default:
			return E_INVALIDARG;
	}
}

const HRESULT autoit_opencv_from(const GOptRunArg& in_val, VARIANT*& out_val) {
	switch (in_val.index()) {
		case GOptRunArg::index_of<cv::optional<cv::Mat>>():
			return autoit_opencv_from(util::get<cv::optional<cv::Mat>>(in_val), out_val);

		case GOptRunArg::index_of<cv::optional<cv::Scalar>>():
			return autoit_opencv_from(util::get<cv::optional<cv::Scalar>>(in_val), out_val);

		case GOptRunArg::index_of<optional<cv::detail::VectorRef>>():
			return autoit_opencv_from(util::get<optional<cv::detail::VectorRef>>(in_val), out_val);

		case GOptRunArg::index_of<optional<cv::detail::OpaqueRef>>():
			return autoit_opencv_from(util::get<optional<cv::detail::OpaqueRef>>(in_val), out_val);

		default:
			return E_INVALIDARG;
	}
}

const HRESULT autoit_opencv_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val) {
	using RunArgs = cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>;
	switch (in_val.index()) {
		case RunArgs::index_of<cv::GRunArgs>():
			return autoit_opencv_from(util::get<cv::GRunArgs>(in_val), out_val);
		case RunArgs::index_of<cv::GOptRunArgs>():
			return autoit_opencv_from(util::get<cv::GOptRunArgs>(in_val), out_val);
		default:
			return E_INVALIDARG;
	}
}

HRESULT GetInterfaceName(IUnknown* punk, VARIANT* vres) {
	HRESULT hr;
	IDispatch* pDisp;
	ITypeInfo* pTI;
	BSTR bstr = NULL;
	hr = punk->QueryInterface(IID_IDispatch, (void**)&pDisp);
	if (SUCCEEDED(hr) && pDisp != NULL) {
		hr = pDisp->GetTypeInfo(0, LOCALE_USER_DEFAULT, &pTI);
		if (SUCCEEDED(hr) && pTI != NULL) {
			hr = pTI->GetDocumentation(MEMBERID_NIL, &bstr, NULL, NULL, NULL);
			pTI->Release();
		}
		pDisp->Release();
	}
	if (bstr == NULL) {
		bstr = SysAllocString(L"");
	}

	V_VT(vres) = VT_BSTR;
	V_BSTR(vres) = bstr;
	return hr;
}

const bool is_assignable_from(cv::Ptr<cv::flann::IndexParams> &out_val, VARIANT* &in_val, bool is_optional) {
	cv::flann::IndexParams obj;
	return is_assignable_from(obj, in_val, is_optional);
}

const bool is_assignable_from(cv::flann::IndexParams &out_val, VARIANT* &in_val, bool is_optional) {
	VARIANT vname = { VT_EMPTY };
	bool _result = false;

	switch (V_VT(in_val)) {
		case VT_DISPATCH:
			GetInterfaceName(V_DISPATCH(in_val), &vname);
			_result = wcscmp(V_BSTR(&vname), L"IDictionary") == 0;
			VariantClear(&vname);
			return _result;
		case VT_ERROR:
			return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
		case VT_EMPTY:
			return is_optional;
		default:
			return false;
	}
}

const bool is_assignable_from(cv::Ptr<cv::flann::SearchParams> &out_val, VARIANT* &in_val, bool is_optional) {
	return is_assignable_from(static_cast<cv::Ptr<cv::flann::IndexParams>>(out_val), in_val, is_optional);
}

const HRESULT autoit_opencv_to(VARIANT* &in_val, cv::Ptr<cv::flann::IndexParams> &out_val) {
	if (V_VT(in_val) == VT_ERROR) {
		return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
	}

	if (V_VT(in_val) == VT_EMPTY) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	auto obj = new cv::flann::IndexParams();
	HRESULT hr = autoit_opencv_to(in_val, *obj);
	if (SUCCEEDED(hr)) {
		out_val.reset(obj);
	}

	return hr;
}

const HRESULT autoit_opencv_to(VARIANT* &in_val, cv::Ptr<cv::flann::SearchParams> &out_val) {
	return autoit_opencv_to(in_val, static_cast<cv::Ptr<cv::flann::IndexParams>>(out_val));
}

const HRESULT autoit_opencv_to(VARIANT const* const& in_val, cv::flann::IndexParams& out_val) {
	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	auto dispatch = getRealIDispatch(in_val);

	HRESULT hr = S_OK;

	Scripting::IDictionaryPtr dict(static_cast<Scripting::IDictionary*>(dispatch));

	auto vKeys = dict->Keys();
	ATL::CComSafeArray<VARIANT> keys(V_ARRAY(&vKeys));

	LONG lLower = keys.GetLowerBound();
	LONG lUpper = keys.GetUpperBound();

	int intVal;
	std::string svalue;

	for (LONG i = lLower; SUCCEEDED(hr) && i <= lUpper; i++) {
		auto& vkey = keys.GetAt(i);
		if (V_VT(&vkey) != VT_BSTR) {
			std::cout << "Property key must be a string. Given " << V_VT(&vkey) << "." << std::endl;
			hr = E_INVALIDARG;
			break;
		}

		std::string skey;
		autoit_opencv_to(V_BSTR(&vkey), skey);

		VARIANT vvalue = { VT_EMPTY };
		hr = dict->get_Item(&vkey, &vvalue);
		if (FAILED(hr)) {
			std::wcout << "Failed to get property '" << _bstr_t(V_BSTR(&vkey), true) << "'" << std::endl;
			break;
		}

		bool isAlgorithm = wcscmp(V_BSTR(&vkey), L"algorithm") == 0;
		bool isInt = false;

		switch (V_VT(&vvalue)) {
			case VT_BOOL:
				out_val.setBool(skey, V_BOOL(&vvalue) == VARIANT_TRUE);
				break;
			case VT_BSTR:
				autoit_opencv_to(V_BSTR(&vvalue), svalue);
				out_val.setString(skey, svalue);
				break;
			case VT_I1:
				intVal = static_cast<int>(V_I1(&vvalue));
				isInt = true;
				break;
			case VT_I2:
				intVal = static_cast<int>(V_I2(&vvalue));
				isInt = true;
				break;
			case VT_I4:
				intVal = static_cast<int>(V_I4(&vvalue));
				isInt = true;
				break;
			case VT_I8:
				intVal = static_cast<int>(V_I8(&vvalue));
				isInt = true;
				break;
			case VT_UI1:
				intVal = static_cast<int>(V_UI1(&vvalue));
				isInt = true;
				break;
			case VT_UI2:
				intVal = static_cast<int>(V_UI2(&vvalue));
				isInt = true;
				break;
			case VT_UI4:
				intVal = static_cast<int>(V_UI4(&vvalue));
				isInt = true;
				break;
			case VT_UI8:
				intVal = static_cast<int>(V_UI8(&vvalue));
				isInt = true;
				break;
			case VT_INT:
				intVal = static_cast<int>(V_INT(&vvalue));
				isInt = true;
				break;
			case VT_UINT:
				intVal = static_cast<int>(V_UINT(&vvalue));
				isInt = true;
				break;
			case VT_R4:
				out_val.setDouble(skey, static_cast<double>(V_R4(&vvalue)));
				break;
			case VT_R8:
				out_val.setDouble(skey, V_R8(&vvalue));
				break;
			default:
				std::wcout << "Property '" << _bstr_t(V_BSTR(&vkey), true) << "' has an unsupported value type " << V_VT(&vvalue) << std::endl;
				hr = E_INVALIDARG;
				break;
		}

		if (isInt) {
			if (isAlgorithm) {
				out_val.setAlgorithm(intVal);
			} else {
				out_val.setInt(skey, intVal);
			}
		}
	}

	return hr;
}
