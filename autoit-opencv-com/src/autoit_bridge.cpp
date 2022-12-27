#include "autoit_bridge.h"
#include "Cv_Mat_Object.h"
#include "Cv_GRunArg_Object.h"
#include "Cv_GMatDesc_Object.h"
#include "Cv_GScalarDesc_Object.h"
#include "Cv_GArrayDesc_Object.h"
#include "Cv_GOpaqueDesc_Object.h"

PTR_BRIDGE_IMPL(cv::wgc::WGCFrameCallback)

const bool is_variant_scalar(VARIANT const* const& in_val) {
	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	cv::Scalar out_val;
	return SUCCEEDED(autoit_to(in_val, out_val));
}

const bool is_array_from(VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_NULL(in_val)) {
		return true;
	}

	if (PARAMETER_NOT_FOUND(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return is_variant_scalar(in_val);
	}

	return dynamic_cast<IVariantArray*>(getRealIDispatch(in_val)) != NULL;
}

const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_NULL(in_val)) {
		return true;
	}

	if (PARAMETER_NOT_FOUND(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return false;
	}

	return dynamic_cast<IVariantArrays*>(getRealIDispatch(in_val)) != NULL;
}

const HRESULT autoit_from(cv::MatExpr& in_val, ICv_Mat_Object**& out_val) {
	return autoit_from(cv::Mat(in_val), out_val);
}

const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional) {
	cv::GMatDesc value_GMatDesc;
	cv::GScalarDesc value_GScalarDesc;
	cv::GArrayDesc value_GArrayDesc;
	cv::GOpaqueDesc value_GOpaqueDesc;
	return
		is_assignable_from(value_GMatDesc, in_val, is_optional) ||
		is_assignable_from(value_GScalarDesc, in_val, is_optional) ||
		is_assignable_from(value_GArrayDesc, in_val, is_optional) ||
		is_assignable_from(value_GOpaqueDesc, in_val, is_optional)
		;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::GMetaArg& out_val) {
	cv::GMatDesc value_GMatDesc;
	cv::GScalarDesc value_GScalarDesc;
	cv::GArrayDesc value_GArrayDesc;
	cv::GOpaqueDesc value_GOpaqueDesc;

	HRESULT hr = S_OK;

	if (is_assignable_from(value_GMatDesc, in_val, false)) {
		hr = autoit_to(in_val, value_GMatDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GMatDesc;
		}
	} else if (is_assignable_from(value_GScalarDesc, in_val, false)) {
		hr = autoit_to(in_val, value_GScalarDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GScalarDesc;
		}
	} else if (is_assignable_from(value_GArrayDesc, in_val, false)) {
		hr = autoit_to(in_val, value_GArrayDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GArrayDesc;
		}
	} else if (is_assignable_from(value_GOpaqueDesc, in_val, false)) {
		hr = autoit_to(in_val, value_GOpaqueDesc);
		if (SUCCEEDED(hr)) {
			out_val = value_GOpaqueDesc;
		}
	}


	return hr;
}

const HRESULT autoit_from(const cv::GMetaArg& in_val, VARIANT*& out_val) {
	using namespace cv;
	switch (in_val.index()) {
		case GMetaArg::index_of<GMatDesc>():
			return autoit_from(util::get<GMatDesc>(in_val), out_val);

		case GMetaArg::index_of<GScalarDesc>():
			return autoit_from(util::get<GScalarDesc>(in_val), out_val);

		case GMetaArg::index_of<GOpaqueDesc>():
			return autoit_from(util::get<GOpaqueDesc>(in_val), out_val);

		case GMetaArg::index_of<GArrayDesc>():
			return autoit_from(util::get<GArrayDesc>(in_val), out_val);

		default:
			return E_INVALIDARG;
	}
}

#if (CV_VERSION_MAJOR > 4) || CV_VERSION_MAJOR == 4 && (CV_VERSION_MINOR > 5 || CV_VERSION_MINOR == 5 && CV_VERSION_REVISION > 0)
const HRESULT autoit_from(const cv::GOptRunArg& in_val, VARIANT*& out_val) {
	using namespace cv;
	switch (in_val.index()) {
		case GOptRunArg::index_of<optional<Mat>>():
			return autoit_from(util::get<optional<Mat>>(in_val), out_val);

		case GOptRunArg::index_of<optional<Scalar>>():
			return autoit_from(util::get<optional<Scalar>>(in_val), out_val);

		case GOptRunArg::index_of<optional<detail::VectorRef>>():
			return autoit_from(util::get<optional<detail::VectorRef>>(in_val), out_val);

		case GOptRunArg::index_of<optional<detail::OpaqueRef>>():
			return autoit_from(util::get<optional<detail::OpaqueRef>>(in_val), out_val);

		default:
			return E_INVALIDARG;
	}
}

const HRESULT autoit_from(const cv::util::variant<cv::GRunArgs, cv::GOptRunArgs>& in_val, VARIANT*& out_val) {
	using namespace cv;
	using RunArgs = util::variant<GRunArgs, GOptRunArgs>;
	switch (in_val.index()) {
		case RunArgs::index_of<GRunArgs>():
			return autoit_from(util::get<GRunArgs>(in_val), out_val);
		case RunArgs::index_of<GOptRunArgs>():
			return autoit_from(util::get<GOptRunArgs>(in_val), out_val);
		default:
			return E_INVALIDARG;
	}
}
#endif

const bool is_assignable_from(cv::Ptr<cv::flann::IndexParams>& out_val, VARIANT*& in_val, bool is_optional) {
	cv::flann::IndexParams obj;
	return is_assignable_from(obj, in_val, is_optional);
}

const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT*& in_val, bool is_optional) {
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

const bool is_assignable_from(cv::Ptr<cv::flann::SearchParams>& out_val, VARIANT*& in_val, bool is_optional) {
	auto _out_val = static_cast<cv::Ptr<cv::flann::IndexParams>>(out_val);
	return is_assignable_from(_out_val, in_val, is_optional);
}

const HRESULT autoit_to(VARIANT*& in_val, cv::Ptr<cv::flann::IndexParams>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	auto obj = new cv::flann::IndexParams();
	HRESULT hr = autoit_to(in_val, *obj);
	if (SUCCEEDED(hr)) {
		out_val.reset(obj);
	}

	return hr;
}

const HRESULT autoit_to(VARIANT*& in_val, cv::Ptr<cv::flann::SearchParams>& out_val) {
	auto _out_val = static_cast<cv::Ptr<cv::flann::IndexParams>>(out_val);
	return autoit_to(in_val, _out_val);
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::flann::IndexParams& out_val) {
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

		std::string skey; autoit_to(V_BSTR(&vkey), skey);
		_variant_t vvalue; VariantInit(&vvalue);

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
				autoit_to(V_BSTR(&vvalue), svalue);
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
			case VT_INT:
				intVal = static_cast<int>(V_INT(&vvalue));
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

	keys.Detach();

	return hr;
}

// cv::Mat cv::getMat(VARIANT* in_val) {
// 	AUTOIT_ASSERT_THROW((V_VT(in_val) & VT_ARRAY) == VT_ARRAY, "argument must be an array");

// 	auto& psa = V_ARRAY(in_val);
// 	const auto& cDims = psa->cDims;
// 	AUTOIT_ASSERT_THROW(cDims > 0 && cDims <= 3, "array must have at most 3 dimensions");

// 	int depth;

// 	switch((V_VT(in_val) ^ VT_ARRAY)) {
// 		case VT_I1:
// 			depth = cv::DataType<CHAR>::depth;
// 			break;
// 		case VT_I2:
// 			depth = cv::DataType<SHORT>::depth;
// 			break;
// 		case VT_INT:
// 			depth = cv::DataType<INT>::depth;
// 			break;
// 		case VT_UI1:
// 			depth = cv::DataType<BYTE>::depth;
// 			break;
// 		case VT_UI2:
// 			depth = cv::DataType<USHORT>::depth;
// 			break;
// 		case VT_R4:
// 			depth = cv::DataType<FLOAT>::depth;
// 			break;
// 		case VT_R8:
// 			depth = cv::DataType<DOUBLE>::depth;
// 			break;
// 		default:
// 			AUTOIT_ASSERT_THROW(false, "array must be of a number type");
// 	}

// 	const auto& rgsabound = psa->rgsabound;

// 	ULONG rows = 0;
// 	ULONG cols = 1;
// 	ULONG channels = 1;

// 	for (int i = 0; i < cDims; i++) {
// 		AUTOIT_ASSERT_THROW(rgsabound[i].lLbound == 0, "only contiguous array are supported");

// 		if (i == 0) {
// 			rows = rgsabound[i].cElements;
// 		} else if (i == 1) {
// 			cols = rgsabound[i].cElements;
// 		} else {
// 			channels = rgsabound[i].cElements;
// 		}
// 	}

// 	return cv::Mat(rows, cols, CV_MAKETYPE(depth, channels), psa->pvData);
// }

// VARIANT cv::getArray(cv::Mat& m) {
// 	auto& dims = m.dims;
// 	AUTOIT_ASSERT_THROW(dims > 0 && dims <= 3, "array must have at most 3 dimensions");

// 	SAFEARRAYBOUND rgsabound[dims];

// 	for (int i = 0; i < dims; i++) {
// 		rgsabound[0].lLbound = 0;

// 		if (i == 0) {
// 			rgsabound[i].cElements = m.rows;
// 		} else if (i == 1) {
// 			rgsabound[i].cElements = m.cols;
// 		} else {
// 			rgsabound[i].cElements = m.channels();
// 		}
// 	}

// 	auto& data = m.data;
// }
