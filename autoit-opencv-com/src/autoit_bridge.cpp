#include "autoit_bridge.h"
#include "Cv_Mat_Object.h"

PTR_BRIDGE_IMPL(cv::wgc::WGCFrameCallback)

#if defined __i386__ || defined(_M_IX86) || defined __x86_64__ || defined(_M_X64)
#define CV_UNALIGNED_LITTLE_ENDIAN_MEM_ACCESS 1
#else
#define CV_UNALIGNED_LITTLE_ENDIAN_MEM_ACCESS 0
#endif

static inline int readInt(const uchar* p)
{
#if CV_UNALIGNED_LITTLE_ENDIAN_MEM_ACCESS
	return *(const int*)p;
#else
	int val = (int)(p[0] | (p[1] << 8) | (p[2] << 16) | (p[3] << 24));
	return val;
#endif
}

/**
 * [ConvertUtf8ToWide description]
 * @param  str  Pointer to the character string to convert.
 * @param  wstr Pointer to a buffer that receives the converted string.
 * @return      The number of characters written to the buffer pointed to by wstr.
 * @see             https://stackoverflow.com/questions/6693010/how-do-i-use-multibytetowidechar/59617138#59617138
 *                  https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar
 */
inline auto ConvertUtf8ToWide(const std::string& str, std::wstring& wstr) {
	int size = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), NULL, 0);
	wstr.assign(size, 0);
	return MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), &wstr[0], size + 1);
}

/**
 * @param in_val  std::string
 * @param out_val _bstr_t
 * @see https://stackoverflow.com/questions/6284524/bstr-to-stdstring-stdwstring-and-vice-versa/6284978#6284978
 */
inline void string_to_bstr(std::string const& in_val, _bstr_t& out_val) {
	std::wstring ws; ConvertUtf8ToWide(in_val, ws);
	BSTR bstr = SysAllocStringLen(ws.data(), ws.size());
	out_val = _bstr_t(bstr);
	SysFreeString(bstr);
}

const _variant_t autoit::fileNodeAsVariant(const cv::FileNode& node) {
	using namespace cv;

	_variant_t res;
	V_VT(&res) = VT_ERROR;
	V_ERROR(&res) = DISP_E_PARAMNOTFOUND;
	VARIANT* out_val = &res;

	if (node.empty()) {
		return res;
	}

	if (node.isInt()) {
		return _variant_t((int)node);
	}

	if (node.isReal()) {
		return _variant_t((double)node);
	}

	if (node.isString()) {
		_bstr_t value;
		string_to_bstr((std::string)node, value);
		return _variant_t(value);
	}

	if (node.isNone()) {
		V_VT(&res) = VT_NULL;
	}
	else if (node.isMap()) {
		std::map<std::string, _variant_t> obj;
		for (const auto& key : node.keys()) {
			FileNode v = node[key];
			obj[key] = fileNodeAsVariant(v);
		}

		VariantInit(out_val);
		HRESULT hr = autoit_from(obj, out_val);
		if (FAILED(hr)) {
			CV_Error(Error::StsNotImplemented, "Unexpected value");
		}
	}
	else if (node.isSeq()) {
		std::vector<_variant_t> values;
		for (size_t i = 0; i < node.size(); ++i)
		{
			FileNode v = node[(int)i];
			values.push_back(fileNodeAsVariant(v));
		}

		VariantInit(out_val);
		HRESULT hr = autoit_from(values, out_val);
		if (FAILED(hr)) {
			CV_Error(Error::StsNotImplemented, "Unexpected value");
		}
	}

	return res;
}

#ifdef HAVE_OPENCV_FLANN
const bool is_assignable_from(AUTOIT_PTR<cv::flann::IndexParams>& out_val, VARIANT const* in_val, bool is_optional) {
	static cv::flann::IndexParams obj;
	return is_assignable_from(obj, in_val, is_optional);
}

HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::flann::IndexParams>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	out_val.reset(new cv::flann::IndexParams());
	return autoit_to(in_val, *out_val);
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L18-L103
const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return false;
	}

	VARIANT vname = { VT_EMPTY };
	HRESULT hr = GetInterfaceName(V_DISPATCH(in_val), &vname);
	if (FAILED(hr)) {
		return false;
	}

	bool _result = wcscmp(V_BSTR(&vname), L"IDictionary") == 0;
	VariantClear(&vname);
	return _result;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L18-L103
HRESULT autoit_to(VARIANT const* in_val, cv::flann::IndexParams& out_val) {
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
	double doubleVal;
	std::string sValue;

	for (LONG i = lLower; SUCCEEDED(hr) && i <= lUpper; i++) {
		auto& vKey = keys.GetAt(i);
		if (V_VT(&vKey) != VT_BSTR) {
			AUTOIT_ERROR("Key at pos " << (i - lLower) << " must be a string. Given " << V_VT(&vKey) << ".");
			hr = E_INVALIDARG;
			break;
		}

		std::string sKey;
		hr = autoit_to(V_BSTR(&vKey), sKey);
		if (FAILED(hr)) {
			AUTOIT_ERROR("Key at pos " << (i - lLower) << " cannot be read as a string");
			break;
		}

		_variant_t vValue; VariantInit(&vValue);

		hr = dict->get_Item(&vKey, &vValue);
		if (FAILED(hr)) {
			AUTOIT_WERROR("Failed to get property value of '" << _bstr_t(V_BSTR(&vKey), true) << "'");
			break;
		}

		bool isInt = false;
		bool isDouble = false;

		switch (V_VT(&vValue)) {
		case VT_BOOL:
			out_val.setBool(sKey, V_BOOL(&vValue) == VARIANT_TRUE);
			break;
		case VT_BSTR:
			hr = autoit_to(V_BSTR(&vValue), sValue);
			if (FAILED(hr)) {
				AUTOIT_WERROR("Property value of '" << _bstr_t(V_BSTR(&vKey), true) << "' cannot be read as a string");
				break;
			}
			out_val.setString(sKey, sValue);
			break;
		case VT_I1:
			intVal = static_cast<int>(V_I1(&vValue));
			isInt = true;
			break;
		case VT_I2:
			intVal = static_cast<int>(V_I2(&vValue));
			isInt = true;
			break;
		case VT_I4:
			intVal = static_cast<int>(V_I4(&vValue));
			isInt = true;
			break;
		case VT_I8:
			intVal = static_cast<int>(V_I8(&vValue));
			isInt = true;
			break;
		case VT_INT:
			intVal = static_cast<int>(V_INT(&vValue));
			isInt = true;
			break;
		case VT_UI1:
			intVal = static_cast<int>(V_UI1(&vValue));
			isInt = true;
			break;
		case VT_UI2:
			intVal = static_cast<int>(V_UI2(&vValue));
			isInt = true;
			break;
		case VT_UI4:
			intVal = static_cast<int>(V_UI4(&vValue));
			isInt = true;
			break;
		case VT_UI8:
			intVal = static_cast<int>(V_UI8(&vValue));
			isInt = true;
			break;
		case VT_UINT:
			intVal = static_cast<int>(V_UINT(&vValue));
			isInt = true;
			break;
		case VT_R4:
			doubleVal = static_cast<double>(V_R4(&vValue));
			isDouble = true;
			break;
		case VT_R8:
			doubleVal = V_R8(&vValue);
			isDouble = true;
			break;
		default:
			AUTOIT_WERROR("Property '" << _bstr_t(V_BSTR(&vKey), true) << "' has an unsupported value type " << V_VT(&vValue));
			hr = E_INVALIDARG;
			break;
		}

		if (isInt) {
			bool isAlgorithm = wcscmp(V_BSTR(&vKey), L"algorithm") == 0;
			if (isAlgorithm) {
				out_val.setAlgorithm(intVal);
			}
			else {
				out_val.setInt(sKey, intVal);
			}
		}
		else if (isDouble) {
			bool isEps = wcscmp(V_BSTR(&vKey), L"eps") == 0;
			if (isEps) {
				out_val.setFloat(sKey, static_cast<float>(doubleVal));
			}
			else {
				out_val.setDouble(sKey, doubleVal);
			}
		}
	}

	keys.Detach();

	return hr;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
const bool is_assignable_from(AUTOIT_PTR<cv::flann::SearchParams>& out_val, VARIANT const* in_val, bool is_optional) {
	return is_assignable_from(static_cast<cv::flann::IndexParams&>(*out_val), in_val, is_optional);
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<cv::flann::SearchParams>& out_val) {
	return autoit_to(in_val, static_cast<cv::flann::IndexParams&>(*out_val));
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
const bool is_assignable_from(cv::flann::SearchParams& out_val, VARIANT const* in_val, bool is_optional) {
	return is_assignable_from(static_cast<cv::flann::IndexParams&>(out_val), in_val, is_optional);
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
HRESULT autoit_to(VARIANT const* in_val, cv::flann::SearchParams& out_val) {
	return autoit_to(in_val, static_cast<cv::flann::IndexParams&>(out_val));
}
#endif

#ifdef HAVE_OPENCV_DNN
// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L7-L37
const bool is_assignable_from(cv::dnn::DictValue& out_val, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if (is_variant_number(in_val) || PARAMETER_NULL(in_val)) {
		return true;
	}

	static std::string out_str;
	return is_assignable_from(out_str, in_val, is_optional);

}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L7-L37
HRESULT autoit_to(VARIANT const* in_val, cv::dnn::DictValue& dv) {
	using namespace cv;

	if (PARAMETER_MISSING(in_val) || PARAMETER_NULL(in_val)) {
		return S_OK;
	}

	HRESULT hr = S_OK;

	switch (V_VT(in_val)) {
	case VT_BSTR: {
		std::string str;
		autoit_to(V_BSTR(in_val), str);
		dv = dnn::DictValue(str);
		break;
	}
	case VT_I1:
		dv = dnn::DictValue(static_cast<int64>(V_I1(in_val)));
		break;
	case VT_I2:
		dv = dnn::DictValue(static_cast<int64>(V_I2(in_val)));
		break;
	case VT_I4:
		dv = dnn::DictValue(static_cast<int64>(V_I4(in_val)));
		break;
	case VT_I8:
		dv = dnn::DictValue(static_cast<int64>(V_I8(in_val)));
		break;
	case VT_INT:
		dv = dnn::DictValue(static_cast<int64>(V_INT(in_val)));
		break;
	case VT_UI1:
		dv = dnn::DictValue(static_cast<int64>(V_UI1(in_val)));
		break;
	case VT_UI2:
		dv = dnn::DictValue(static_cast<int64>(V_UI2(in_val)));
		break;
	case VT_UI4:
		dv = dnn::DictValue(static_cast<int64>(V_UI4(in_val)));
		break;
	case VT_UI8:
		dv = dnn::DictValue(static_cast<int64>(V_UI8(in_val)));
		break;
	case VT_UINT:
		dv = dnn::DictValue(static_cast<int64>(V_UINT(in_val)));
		break;
	case VT_R4:
		dv = dnn::DictValue(static_cast<double>(V_R4(in_val)));
		break;
	case VT_R8:
		dv = dnn::DictValue(V_R8(in_val));
		break;
	default:
		AUTOIT_ERROR("DictValue has an unsupported value type " << V_VT(in_val));
		hr = E_INVALIDARG;
		break;
	}

	return hr;
}

namespace {
	// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L39-L51
	template<typename T>
	HRESULT _autoit_from(const cv::dnn::DictValue& dv, VARIANT*& out_val) {
		if (dv.size() > 1) {
			std::vector<T> vec(dv.size());
			for (int i = 0; i < dv.size(); ++i) {
				vec[i] = dv.get<T>(i);
			}
			return autoit_from(vec, out_val);
		}

		return autoit_from(dv.get<T>(), out_val);
	}
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L54-L61
HRESULT autoit_from(cv::dnn::DictValue const& dv, VARIANT*& out_val) {
	using namespace cv;

	if (dv.isInt()) return _autoit_from<int>(dv, out_val);
	if (dv.isReal()) return _autoit_from<float>(dv, out_val);
	if (dv.isString()) return _autoit_from<String>(dv, out_val);

	AUTOIT_ERROR("DictValue has an unsupported value type ");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L75-L88
const bool is_assignable_from(cv::dnn::LayerParams& lp, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return false;
	}

	VARIANT vname = { VT_EMPTY };
	HRESULT hr = GetInterfaceName(V_DISPATCH(in_val), &vname);
	if (FAILED(hr)) {
		return false;
	}

	bool _result = wcscmp(V_BSTR(&vname), L"IDictionary") == 0;
	VariantClear(&vname);
	return _result;
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L75-L88
HRESULT autoit_to(VARIANT const* in_val, cv::dnn::LayerParams& lp) {
	using namespace cv;

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

	for (LONG i = lLower; SUCCEEDED(hr) && i <= lUpper; i++) {
		auto& vKey = keys.GetAt(i);
		if (V_VT(&vKey) != VT_BSTR) {
			AUTOIT_ERROR("Property key must be a string. Given " << V_VT(&vKey) << ".");
			hr = E_INVALIDARG;
			break;
		}

		std::string sKey; autoit_to(V_BSTR(&vKey), sKey);
		_variant_t vValue; VariantInit(&vValue);

		hr = dict->get_Item(&vKey, &vValue);
		if (FAILED(hr)) {
			AUTOIT_WERROR("Failed to get property '" << _bstr_t(V_BSTR(&vKey), true) << "'");
			break;
		}

		dnn::DictValue dv;
		hr = autoit_to(&vValue, dv);
		if (FAILED(hr)) {
			break;
		}

		lp.set(sKey, dv);
	}

	keys.Detach();

	return hr;
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L64-L72
HRESULT autoit_from(cv::dnn::LayerParams const& lp, VARIANT*& out_val) {
	using namespace cv;

	VariantInit(out_val);

	HRESULT hr = S_OK;

	Scripting::IDictionaryPtr dict(__uuidof(Scripting::Dictionary));

	for (auto it = lp.begin(); it != lp.end(); ++it) {
		_variant_t vKey;
		VARIANT* vKeyPtr = &vKey;
		hr = autoit_from(it->first, vKeyPtr);
		if (FAILED(hr)) {
			break;
		}

		_variant_t vValue;
		VARIANT* vValuePtr = &vValue;
		hr = autoit_from(it->second, vValuePtr);
		if (FAILED(hr)) {
			break;
		}

		dict->Add(&vKey, &vValue);
	}

	V_DISPATCH(out_val) = dict.Detach();

	return hr;
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L91-L94
HRESULT autoit_from(std::vector<cv::dnn::Target> const& t, VARIANT*& out_val) {
	return autoit_from(std::vector<int>(t.begin(), t.end()), out_val);
}

#endif
