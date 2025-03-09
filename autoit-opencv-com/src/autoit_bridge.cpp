#include "autoit_bridge.h"
#include "Cv_Mat_Object.h"
#include "Cv_GMatDesc_Object.h"
#include "Cv_GScalarDesc_Object.h"
#include "Cv_GArrayDesc_Object.h"
#include "Cv_GOpaqueDesc_Object.h"

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

#ifdef HAVE_OPENCV_GAPI
const bool is_assignable_from(AUTOIT_PTR<cv::gapi::wip::draw::Prim>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::gapi::wip::draw::Prim obj;
	return is_assignable_from(obj, in_val, is_optional);
}

const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<cv::gapi::wip::draw::Prim>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return E_INVALIDARG;
	}

	out_val.reset(new cv::gapi::wip::draw::Prim());
	return autoit_to(in_val, *out_val);
}

const HRESULT autoit_from(AUTOIT_PTR<cv::gapi::wip::draw::Prim> const& prim, VARIANT*& out_val) {
	return autoit_from(*prim, out_val);
}

const bool is_assignable_from(cv::gapi::wip::draw::Prim& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::gapi::wip::draw::Rect value_Rect;
	static cv::gapi::wip::draw::Text value_Text;
	static cv::gapi::wip::draw::Circle value_Circle;
	static cv::gapi::wip::draw::Line value_Line;
	static cv::gapi::wip::draw::Poly value_Poly;
	static cv::gapi::wip::draw::Mosaic value_Mosaic;
	static cv::gapi::wip::draw::Image value_Image;
	return
		is_assignable_from(value_Rect, in_val, is_optional) ||
		is_assignable_from(value_Text, in_val, is_optional) ||
		is_assignable_from(value_Circle, in_val, is_optional) ||
		is_assignable_from(value_Line, in_val, is_optional) ||
		is_assignable_from(value_Poly, in_val, is_optional) ||
		is_assignable_from(value_Mosaic, in_val, is_optional) ||
		is_assignable_from(value_Image, in_val, is_optional)
		;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::gapi::wip::draw::Prim& out_val) {
#define TRY_EXTRACT(Prim)                                         \
	static cv::gapi::wip::draw::##Prim value_##Prim;              \
	if (is_assignable_from(value_##Prim, in_val, false)) {        \
		HRESULT hr = autoit_to(in_val, value_##Prim);             \
		if (FAILED(hr)); {                                        \
			AUTOIT_ERROR("Invalid draw primitive type " #Prim);   \
		}                                                         \
		out_val = value_##Prim;                                   \
		return hr;                                                \
	}                                                             \

	TRY_EXTRACT(Rect)
	TRY_EXTRACT(Text)
	TRY_EXTRACT(Circle)
	TRY_EXTRACT(Line)
	TRY_EXTRACT(Mosaic)
	TRY_EXTRACT(Image)
	TRY_EXTRACT(Poly)
#undef TRY_EXTRACT

		AUTOIT_ERROR("Unsupported primitive type");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L149-L170
const HRESULT autoit_from(cv::gapi::wip::draw::Prim const& prim, VARIANT*& out_val) {
	switch (prim.index())
	{
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Rect>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Rect>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Text>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Text>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Circle>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Circle>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Line>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Line>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Poly>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Poly>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Mosaic>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Mosaic>(prim), out_val);
	case cv::gapi::wip::draw::Prim::index_of<cv::gapi::wip::draw::Image>():
		return autoit_from(cv::util::get<cv::gapi::wip::draw::Image>(prim), out_val);
	}

	AUTOIT_ERROR("Unsupported draw primitive type");
	return E_INVALIDARG;
}


// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L208-L226
const bool is_assignable_from(cv::GMetaArg& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::GMatDesc value_GMatDesc;
	static cv::GScalarDesc value_GScalarDesc;
	static cv::GArrayDesc value_GArrayDesc;
	static cv::GOpaqueDesc value_GOpaqueDesc;
	return
		is_assignable_from(value_GMatDesc, in_val, is_optional) ||
		is_assignable_from(value_GScalarDesc, in_val, is_optional) ||
		is_assignable_from(value_GArrayDesc, in_val, is_optional) ||
		is_assignable_from(value_GOpaqueDesc, in_val, is_optional)
		;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L208-L226
const HRESULT autoit_to(VARIANT const* const& in_val, cv::GMetaArg& out_val) {
#define TRY_EXTRACT(Meta)                                         \
	static cv::##Meta value_##Meta;                               \
	if (is_assignable_from(value_##Meta, in_val, false)) {        \
		HRESULT hr = autoit_to(in_val, value_##Meta);             \
		if (FAILED(hr)); {                                        \
			AUTOIT_ERROR("Invalid cv::GMetaArg " #Meta);          \
		}                                                         \
		out_val = value_##Meta;                                   \
		return hr;                                                \
	}                                                             \

	TRY_EXTRACT(GMatDesc)
	TRY_EXTRACT(GScalarDesc)
	TRY_EXTRACT(GArrayDesc)
	TRY_EXTRACT(GOpaqueDesc)
#undef TRY_EXTRACT

		AUTOIT_ERROR("Unsupported cv::GMetaArg type");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L764-L798
const HRESULT autoit_from(cv::GMetaArg const& in_val, VARIANT*& out_val) {
	switch (in_val.index()) {
	case cv::GMetaArg::index_of<cv::GMatDesc>():
		return autoit_from(cv::util::get<cv::GMatDesc>(in_val), out_val);

	case cv::GMetaArg::index_of<cv::GScalarDesc>():
		return autoit_from(cv::util::get<cv::GScalarDesc>(in_val), out_val);

	case cv::GMetaArg::index_of<cv::GOpaqueDesc>():
		return autoit_from(cv::util::get<cv::GOpaqueDesc>(in_val), out_val);

	case cv::GMetaArg::index_of<cv::GArrayDesc>():
		return autoit_from(cv::util::get<cv::GArrayDesc>(in_val), out_val);

	default:
		return E_INVALIDARG;
	}
}

const bool is_assignable_from(cv::GArg& out_val, VARIANT const* const& in_val, bool is_optional) {
	AUTOIT_ERROR("Setting a cv::GArg is not yet supported");
	return false;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::GArg& out_val) {
	// out_val = cv::GArg(cv::detail::PyObjectHolder(obj)); // TODO
	AUTOIT_ERROR("Setting a cv::GArg is not yet supported");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L236-L267
const HRESULT autoit_from(cv::GArg const& in_val, VARIANT*& out_val) {
	GAPI_Assert(in_val.kind != cv::detail::ArgKind::GOBJREF);
#define HANDLE_CASE(T, O) case cv::detail::OpaqueKind::CV_##T:  \
	{                                                           \
		return autoit_from(in_val.get<O>(), out_val);           \
	}

#define UNSUPPORTED(T) case cv::detail::OpaqueKind::CV_##T: break
	switch (in_val.opaque_kind)
	{
		HANDLE_CASE(BOOL, bool);
		HANDLE_CASE(INT, int);
		HANDLE_CASE(INT64, int64_t);
		HANDLE_CASE(UINT64, uint64_t);
		HANDLE_CASE(DOUBLE, double);
		HANDLE_CASE(FLOAT, float);
		HANDLE_CASE(STRING, std::string);
		HANDLE_CASE(POINT, cv::Point);
		HANDLE_CASE(POINT2F, cv::Point2f);
		HANDLE_CASE(POINT3F, cv::Point3f);
		HANDLE_CASE(SIZE, cv::Size);
		HANDLE_CASE(RECT, cv::Rect);
		HANDLE_CASE(SCALAR, cv::Scalar);
		HANDLE_CASE(MAT, cv::Mat);
		// HANDLE_CASE(UNKNOWN,   cv::detail::PyObjectHolder); // TODO
		HANDLE_CASE(DRAW_PRIM, cv::gapi::wip::draw::Prim);
#undef HANDLE_CASE
#undef UNSUPPORTED
	}

	AUTOIT_ERROR("Unsupported kernel input type");
	return E_INVALIDARG;
}

const bool is_assignable_from(cv::detail::OpaqueRef& out_val, VARIANT const* const& in_val, bool is_optional) {
	return false;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::detail::OpaqueRef& out_val) {
	AUTOIT_ERROR("Setting a cv::detail::OpaqueRef is not allowed");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L301-L325
const HRESULT autoit_from(cv::detail::OpaqueRef const& in_val, VARIANT*& out_val) {
	switch (in_val.getKind())
	{
	case cv::detail::OpaqueKind::CV_BOOL: return autoit_from(in_val.rref<bool>(), out_val);
	case cv::detail::OpaqueKind::CV_INT: return autoit_from(in_val.rref<int>(), out_val);
	case cv::detail::OpaqueKind::CV_INT64: return autoit_from(in_val.rref<int64_t>(), out_val);
	case cv::detail::OpaqueKind::CV_UINT64: return autoit_from(in_val.rref<uint64_t>(), out_val);
	case cv::detail::OpaqueKind::CV_DOUBLE: return autoit_from(in_val.rref<double>(), out_val);
	case cv::detail::OpaqueKind::CV_FLOAT: return autoit_from(in_val.rref<float>(), out_val);
	case cv::detail::OpaqueKind::CV_STRING: return autoit_from(in_val.rref<std::string>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT: return autoit_from(in_val.rref<cv::Point>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT2F: return autoit_from(in_val.rref<cv::Point2f>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT3F: return autoit_from(in_val.rref<cv::Point3f>(), out_val);
	case cv::detail::OpaqueKind::CV_SIZE: return autoit_from(in_val.rref<cv::Size>(), out_val);
	case cv::detail::OpaqueKind::CV_RECT: return autoit_from(in_val.rref<cv::Rect>(), out_val);
	case cv::detail::OpaqueKind::CV_UNKNOWN: return autoit_from(in_val.rref<cv::GArg>(), out_val);
	case cv::detail::OpaqueKind::CV_DRAW_PRIM: return autoit_from(in_val.rref<cv::gapi::wip::draw::Prim>(), out_val);
	case cv::detail::OpaqueKind::CV_SCALAR: break;
	case cv::detail::OpaqueKind::CV_MAT: break;
	}

	AUTOIT_ERROR("Unsupported GOpaque type");
	return E_INVALIDARG;
}

const bool is_assignable_from(cv::detail::VectorRef& out_val, VARIANT const* const& in_val, bool is_optional) {
	return false;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::detail::VectorRef& out_val) {
	AUTOIT_ERROR("Setting a cv::detail::VectorRef is not allowed");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L328-L352
const HRESULT autoit_from(cv::detail::VectorRef const& in_val, VARIANT*& out_val) {
	switch (in_val.getKind())
	{
	case cv::detail::OpaqueKind::CV_BOOL: return autoit_from(in_val.rref<bool>(), out_val);
	case cv::detail::OpaqueKind::CV_INT: return autoit_from(in_val.rref<int>(), out_val);
	case cv::detail::OpaqueKind::CV_INT64: return autoit_from(in_val.rref<int64_t>(), out_val);
	case cv::detail::OpaqueKind::CV_UINT64: return autoit_from(in_val.rref<uint64_t>(), out_val);
	case cv::detail::OpaqueKind::CV_DOUBLE: return autoit_from(in_val.rref<double>(), out_val);
	case cv::detail::OpaqueKind::CV_FLOAT: return autoit_from(in_val.rref<float>(), out_val);
	case cv::detail::OpaqueKind::CV_STRING: return autoit_from(in_val.rref<std::string>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT: return autoit_from(in_val.rref<cv::Point>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT2F: return autoit_from(in_val.rref<cv::Point2f>(), out_val);
	case cv::detail::OpaqueKind::CV_POINT3F: return autoit_from(in_val.rref<cv::Point3f>(), out_val);
	case cv::detail::OpaqueKind::CV_SIZE: return autoit_from(in_val.rref<cv::Size>(), out_val);
	case cv::detail::OpaqueKind::CV_RECT: return autoit_from(in_val.rref<cv::Rect>(), out_val);
	case cv::detail::OpaqueKind::CV_SCALAR: return autoit_from(in_val.rref<cv::Scalar>(), out_val);
	case cv::detail::OpaqueKind::CV_MAT: return autoit_from(in_val.rref<cv::Mat>(), out_val);
	case cv::detail::OpaqueKind::CV_UNKNOWN: return autoit_from(in_val.rref<cv::GArg>(), out_val);
	case cv::detail::OpaqueKind::CV_DRAW_PRIM: return autoit_from(in_val.rref<cv::gapi::wip::draw::Prim>(), out_val);
	}

	AUTOIT_ERROR("Unsupported GArray type");
	return E_INVALIDARG;
}

const bool is_assignable_from(cv::GRunArg& out_val, VARIANT const* const& in_val, bool is_optional) {
	return false;
}

const HRESULT autoit_to(VARIANT const* const& in_val, cv::GRunArg& out_val) {
	AUTOIT_ERROR("Setting a cv::GRunArg is not allowed");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L355-L374
const HRESULT autoit_from(cv::GRunArg const& in_val, VARIANT*& out_val) {
	switch (in_val.index())
	{
	case cv::GRunArg::index_of<cv::Mat>():
		return autoit_from(cv::util::get<cv::Mat>(in_val), out_val);

	case cv::GRunArg::index_of<cv::Scalar>():
		return autoit_from(cv::util::get<cv::Scalar>(in_val), out_val);

	case cv::GRunArg::index_of<cv::detail::VectorRef>():
		return autoit_from(cv::util::get<cv::detail::VectorRef>(in_val), out_val);

	case cv::GRunArg::index_of<cv::detail::OpaqueRef>():
		return autoit_from(cv::util::get<cv::detail::OpaqueRef>(in_val), out_val);
	}

	AUTOIT_ERROR("Failed to unpack GRunArgs. Index of variant is unknown");
	return E_INVALIDARG;
}

namespace {
	template <typename T>
	const HRESULT autoit_from(const cv::optional<T>& opt, VARIANT*& out_val) {
		if (!opt.has_value()) {
			VariantInit(out_val);
			V_VT(out_val) = VT_NULL;
			return S_OK;
		}
		return autoit_from(*opt, out_val);
	}
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L387-L406
const HRESULT autoit_from(cv::GOptRunArg const& in_val, VARIANT*& out_val) {
	using namespace cv;
	switch (in_val.index()) {
	case GOptRunArg::index_of<cv::optional<cv::Mat>>():
		return autoit_from(util::get<cv::optional<cv::Mat>>(in_val), out_val);

	case GOptRunArg::index_of<cv::optional<cv::Scalar>>():
		return autoit_from(util::get<cv::optional<cv::Scalar>>(in_val), out_val);

	case GOptRunArg::index_of<cv::optional<cv::detail::VectorRef>>():
		return autoit_from(util::get<cv::optional<cv::detail::VectorRef>>(in_val), out_val);

	case GOptRunArg::index_of<cv::optional<cv::detail::OpaqueRef>>():
		return autoit_from(util::get<cv::optional<cv::detail::OpaqueRef>>(in_val), out_val);

	default:
		return E_INVALIDARG;
	}
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/gapi/misc/python/pyopencv_gapi.hpp#L422-L435
const HRESULT autoit_from(cv::util::variant<cv::GRunArgs, cv::GOptRunArgs> const& in_val, VARIANT*& out_val) {
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

#ifdef HAVE_OPENCV_FLANN
const bool is_assignable_from(AUTOIT_PTR<cv::flann::IndexParams>& out_val, VARIANT const* const& in_val, bool is_optional) {
	static cv::flann::IndexParams obj;
	return is_assignable_from(obj, in_val, is_optional);
}

const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<cv::flann::IndexParams>& out_val) {
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
const bool is_assignable_from(cv::flann::IndexParams& out_val, VARIANT const* const& in_val, bool is_optional) {
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
const bool is_assignable_from(AUTOIT_PTR<cv::flann::SearchParams>& out_val, VARIANT const* const& in_val, bool is_optional) {
	return is_assignable_from(static_cast<cv::flann::IndexParams&>(*out_val), in_val, is_optional);
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
const HRESULT autoit_to(VARIANT const* const& in_val, AUTOIT_PTR<cv::flann::SearchParams>& out_val) {
	return autoit_to(in_val, static_cast<cv::flann::IndexParams&>(*out_val));
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
const bool is_assignable_from(cv::flann::SearchParams& out_val, VARIANT const* const& in_val, bool is_optional) {
	return is_assignable_from(static_cast<cv::flann::IndexParams&>(out_val), in_val, is_optional);
}

// https://github.com/opencv/opencv/tree/4.11.0/modules/flann/misc/python/pyopencv_flann.hpp#L106-L109
const HRESULT autoit_to(VARIANT const* const& in_val, cv::flann::SearchParams& out_val) {
	return autoit_to(in_val, static_cast<cv::flann::IndexParams&>(out_val));
}
#endif

#ifdef HAVE_OPENCV_DNN
// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L7-L37
const bool is_assignable_from(cv::dnn::DictValue& out_val, VARIANT const* const& in_val, bool is_optional) {
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
const HRESULT autoit_to(VARIANT const* const& in_val, cv::dnn::DictValue& dv) {
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
	const HRESULT _autoit_from(const cv::dnn::DictValue& dv, VARIANT*& out_val) {
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
const HRESULT autoit_from(cv::dnn::DictValue const& dv, VARIANT*& out_val) {
	using namespace cv;

	if (dv.isInt()) return _autoit_from<int>(dv, out_val);
	if (dv.isReal()) return _autoit_from<float>(dv, out_val);
	if (dv.isString()) return _autoit_from<String>(dv, out_val);

	AUTOIT_ERROR("DictValue has an unsupported value type ");
	return E_INVALIDARG;
}

// https://github.com/opencv/opencv/blob/4.11.0/modules/dnn/misc/python/pyopencv_dnn.hpp#L75-L88
const bool is_assignable_from(cv::dnn::LayerParams& lp, VARIANT const* const& in_val, bool is_optional) {
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
const HRESULT autoit_to(VARIANT const* const& in_val, cv::dnn::LayerParams& lp) {
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
const HRESULT autoit_from(cv::dnn::LayerParams const& lp, VARIANT*& out_val) {
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
const HRESULT autoit_from(std::vector<cv::dnn::Target> const& t, VARIANT*& out_val) {
	return autoit_from(std::vector<int>(t.begin(), t.end()), out_val);
}

#endif
