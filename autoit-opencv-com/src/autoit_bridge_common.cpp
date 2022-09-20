#include "autoit_bridge_common.h"

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

const variant_t get_variant_in(VARIANT const* const& in_val) {
	if (!V_ISBYREF(in_val)) {
		return _variant_t(in_val);
	}

	switch (V_VT(in_val) ^ VT_BYREF) {
	case VT_I2:
		return _variant_t(*V_I2REF(in_val));
	case VT_I4:
		return _variant_t(*V_I4REF(in_val));
	case VT_R4:
		return _variant_t(*V_R4REF(in_val));
	case VT_R8:
		return _variant_t(*V_R8REF(in_val));
	case VT_CY:
		return _variant_t(*V_CYREF(in_val));
	case VT_DATE:
		return _variant_t(*V_DATEREF(in_val));
	case VT_BSTR:
		return _variant_t(*V_BSTRREF(in_val));
	case VT_DISPATCH:
		return _variant_t(*V_DISPATCHREF(in_val));
	case VT_ERROR:
		return _variant_t(*V_ERRORREF(in_val));
	case VT_BOOL:
		return _variant_t(*V_BOOLREF(in_val));
	case VT_VARIANT:
		return _variant_t(*V_VARIANTREF(in_val));
	case VT_UNKNOWN:
		return _variant_t(*V_UNKNOWNREF(in_val));
	case VT_DECIMAL:
		return _variant_t(*V_DECIMALREF(in_val));
	case VT_I1:
		return _variant_t(*V_I1REF(in_val));
	case VT_UI1:
		return _variant_t(*V_UI1REF(in_val));
	case VT_UI2:
		return _variant_t(*V_UI2REF(in_val));
	case VT_UI4:
		return _variant_t(*V_UI4REF(in_val));
	case VT_I8:
		return _variant_t(*V_I8REF(in_val));
	case VT_UI8:
		return _variant_t(*V_UI8REF(in_val));
	case VT_INT:
		return _variant_t(*V_INTREF(in_val));
	case VT_UINT:
		return _variant_t(*V_UINTREF(in_val));
	case VT_INT_PTR:
		return _variant_t(*V_INT_PTRREF(in_val));
	case VT_UINT_PTR:
		return _variant_t(*V_UINT_PTRREF(in_val));
	default:
		return _variant_t(in_val);
	}
}

const bool is_assignable_from(bool& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}
	
	return V_VT(in_val) == VT_BOOL;
}

const HRESULT autoit_to(VARIANT_BOOL& in_val, bool& out_val) {
	out_val = in_val == VARIANT_TRUE;
	return S_OK;
}

const HRESULT autoit_to(VARIANT const* const& in_val, bool& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_BOOL) {
		return E_INVALIDARG;
	}

	out_val = V_BOOL(in_val) == VARIANT_TRUE;
	return S_OK;
}

const HRESULT autoit_from(const bool& in_val, VARIANT_BOOL*& out_val) {
	*out_val = in_val ? VARIANT_TRUE : VARIANT_FALSE;
	return S_OK;
}

const HRESULT autoit_from(const bool& in_val, VARIANT*& out_val) {
	VariantClear(out_val);
	V_VT(out_val) = VT_BOOL;
	V_BOOL(out_val) = in_val ? VARIANT_TRUE : VARIANT_FALSE;
	return S_OK;
}

const bool is_assignable_from(std::string& out_val, BSTR const& in_val, bool is_optional) {
	return true;
}

const bool is_assignable_from(std::string& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	return V_VT(in_val) == VT_BSTR;
}

const HRESULT autoit_to(BSTR const& in_val, std::string& out_val) {
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

const HRESULT autoit_to(VARIANT const* const& in_val, std::string& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_BSTR) {
		return E_INVALIDARG;
	}

	return autoit_to(V_BSTR(in_val), out_val);
}

const HRESULT autoit_from(std::string& in_val, BSTR& out_val) {
	auto* pout_val = &out_val;
	return autoit_from(in_val, pout_val);
}

const HRESULT autoit_from(const std::string& in_val, BSTR*& out_val) {
	// assuming strings are utf8 encoded
	// https://stackoverflow.com/a/59617138
	int count = MultiByteToWideChar(CP_UTF8, 0, in_val.c_str(), in_val.length(), NULL, 0);
	std::wstring ws(count, 0);
	MultiByteToWideChar(CP_UTF8, 0, in_val.c_str(), in_val.length(), &ws[0], count);

	// https://stackoverflow.com/a/6284978
	*out_val = SysAllocStringLen(ws.data(), ws.size());
	return S_OK;
}

const HRESULT autoit_from(const std::string& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_BSTR;
	BSTR bstrVal;
	BSTR* pbstrVal = &bstrVal;
	HRESULT hr = autoit_from(in_val, pbstrVal);
	V_BSTR(out_val) = bstrVal;
	return hr;
}

const HRESULT autoit_from(BSTR const& in_val, VARIANT*& out_val) {
	VARIANT variant = { VT_BSTR };
	V_BSTR(&variant) = in_val;
	VariantInit(out_val);
	return VariantCopy(out_val, &variant);
}

const bool is_assignable_from(char*& out_val, VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	return V_VT(in_val) == VT_BSTR;
}

const HRESULT autoit_to(VARIANT const* const& in_val, char*& out_val) {
	std::string str;
	HRESULT hr = autoit_to(in_val, str);
	if (SUCCEEDED(hr)) {
		out_val = const_cast<char*>(str.c_str());
	}
	return hr;
}

PTR_BRIDGE_IMPL(void*)
PTR_BRIDGE_IMPL(unsigned char*)
PTR_BRIDGE_IMPL(HWND)

const HRESULT autoit_from(VARIANT const& in_val, VARIANT*& out_val) {
	VariantInit(out_val);
	return VariantCopy(out_val, &in_val);
}

const HRESULT autoit_out(IDispatch*& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_DISPATCH;
	V_DISPATCH(out_val) = in_val;
	in_val->AddRef();
	return S_OK;
}

const HRESULT autoit_out(VARIANT const* const& in_val, VARIANT*& out_val) {
	VariantInit(out_val);
	return VariantCopy(out_val, in_val);
}

const HRESULT autoit_out(VARIANT const* const& in_val, IDispatch**& out_val) {
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

const HRESULT autoit_out(VARIANT const* const& in_val, BSTR*& out_val) {
	if (V_VT(in_val) != VT_BSTR) {
		return E_INVALIDARG;
	}

	*out_val = SysAllocString(V_BSTR(in_val));
	return *out_val == NULL && V_BSTR(in_val) != NULL ? E_OUTOFMEMORY : S_OK;
}

const bool is_variant_number(VARIANT const* const& in_val) {
	switch (V_VT(in_val)) {
	case VT_I1:
	case VT_I2:
	case VT_I4:
	case VT_I8:
	case VT_INT:
	case VT_UI1:
	case VT_UI2:
	case VT_UI4:
	case VT_UI8:
	case VT_UINT:
	case VT_R4:
	case VT_R8:
		return true;
	default:
		return false;
	}
}

const HRESULT GetInterfaceName(IUnknown* punk, VARIANT* vres) {
	IDispatch* pDisp;
	ITypeInfo* pTI;
	BSTR bstr = NULL;
	HRESULT hr = punk->QueryInterface(IID_IDispatch, (void**)&pDisp);
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

const bool is_assignable_from(_variant_t& out_val, VARIANT const* const& in_val, bool is_optional) {
	return true;
}

const HRESULT autoit_to(VARIANT const* const& in_val, _variant_t& out_val) {
	out_val = *in_val;
	return S_OK;
}
