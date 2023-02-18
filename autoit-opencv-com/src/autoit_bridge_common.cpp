#include "autoit_bridge_common.h"
#include <filesystem>

namespace fs = std::filesystem;

CActivationContext::CActivationContext() : m_hActCtx(INVALID_HANDLE_VALUE)
{
}

void CActivationContext::Set(HANDLE hActCtx)
{
	if (hActCtx != INVALID_HANDLE_VALUE) {
		::AddRefActCtx(hActCtx);
	}

	if (m_hActCtx != INVALID_HANDLE_VALUE) {
		::ReleaseActCtx(m_hActCtx);
	}

	m_hActCtx = hActCtx;
}

CActivationContext::~CActivationContext()
{
	if (m_hActCtx != INVALID_HANDLE_VALUE) {
		::ReleaseActCtx(m_hActCtx);
	}
}

bool CActivationContext::Activate(ULONG_PTR& ulpCookie)
{
	return m_hActCtx != INVALID_HANDLE_VALUE && ::ActivateActCtx(m_hActCtx, &ulpCookie);
}

bool CActivationContext::Deactivate(ULONG_PTR& ulpCookie)
{
	if (!::DeactivateActCtx(0, ulpCookie)) {
		return false;
	}
	ulpCookie = 0;
	return true;
}

CActCtxActivator::CActCtxActivator(CActivationContext& src, bool fActivate)
	: m_ActCtx(src), m_Cookie(0)
{
	m_Activated = fActivate && src.Activate(m_Cookie);
}

CActCtxActivator::~CActCtxActivator()
{
	if (m_Activated) {
		m_ActCtx.Deactivate(m_Cookie);
		m_Activated = false;
	}
}

ATL::CComSafeArray<VARIANT> ExtendedHolder::extended((ULONG)0);
HMODULE ExtendedHolder::hModule = GetModuleHandle(NULL);
CActivationContext ExtendedHolder::_ActCtx;

HRESULT ExtendedHolder::SetLength(ULONG len) {
	return extended.Resize(len);
}

HRESULT ExtendedHolder::SetAt(LONG i, const VARIANT& value, bool copy) {
	return extended.SetAt(i, value, copy);
}

void ExtendedHolder::CreateActivationContext(HINSTANCE hInstance) {
	// GetModuleFileName
	std::vector<wchar_t> sourceBuffer;

	DWORD nSize = 0;
	do {
		sourceBuffer.resize(sourceBuffer.size() + MAX_PATH);
		nSize = GetModuleFileNameW(hInstance, &sourceBuffer.at(0), sourceBuffer.size());
	} while (GetLastError() == ERROR_INSUFFICIENT_BUFFER);

	if (GetLastError() != 0) {
		return;
	}

	sourceBuffer.resize(nSize);

	//First try ID 2 and then ID 1 - this is to consider also a.dll.manifest file
	//for dlls, which ID 2 ignores.
	ACTCTXW actCtx;
	memset((void*)&actCtx, 0, sizeof(ACTCTXW));
	actCtx.cbSize = sizeof(ACTCTXW);

	actCtx.dwFlags = ACTCTX_FLAG_RESOURCE_NAME_VALID | ACTCTX_FLAG_HMODULE_VALID;
	actCtx.lpSource = &sourceBuffer.at(0);
	actCtx.lpResourceName = MAKEINTRESOURCEW(2);
	actCtx.hModule = hInstance;

	HANDLE hActCtx = ::CreateActCtxW(&actCtx);
	if (hActCtx == INVALID_HANDLE_VALUE)
	{
		actCtx.lpResourceName = MAKEINTRESOURCEW(3);
		hActCtx = ::CreateActCtxW(&actCtx);
	}

	if (hActCtx == INVALID_HANDLE_VALUE)
	{
		actCtx.lpResourceName = MAKEINTRESOURCEW(1);
		hActCtx = ::CreateActCtxW(&actCtx);
	}

	if (hActCtx == INVALID_HANDLE_VALUE)
	{
		std::wstring manifest(sourceBuffer.begin(), sourceBuffer.end());
		const std::wstring what = L".dll";
		const std::wstring with = L".sxs.manifest";
		manifest.replace(manifest.length() - what.length(), what.length(), with.data(), with.length());

		memset((void*)&actCtx, 0, sizeof(ACTCTXW));
		actCtx.cbSize = sizeof(ACTCTXW);
		actCtx.lpSource = manifest.c_str();
		hActCtx = ::CreateActCtxW(&actCtx);
	}

	_ActCtx.Set(hActCtx);
	::ReleaseActCtx(hActCtx);
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

namespace {
	inline std::vector<std::string> split(const std::string& s, const std::vector<std::string>& delimiters) {
		size_t pos_start = 0;
		size_t pos_end, pos;
		std::string token;
		std::vector<std::string> res;

		std::string delimiter;
		while (true) {
			pos_end = std::string::npos;

			for (const auto& delim : delimiters) {
				pos = s.find(delim, pos_start);
				if (pos != std::string::npos && (pos_end == std::string::npos || pos < pos_end)) {
					pos_end = pos;
					delimiter = delim;
				}
			}

			if (pos_end == std::string::npos) {
				break;
			}

			token = s.substr(pos_start, pos_end - pos_start);
			pos_start = pos_end + delimiter.length();;
			res.push_back(token);
		}

		res.push_back(s.substr(pos_start));
		return res;
	}

	bool isMatch(const std::string& s, const std::string& p) {
		const auto slen = s.length();
		const auto plen = p.length();
		int scur = 0;
		int pcur = 0;
		int lastindex = -1;
		int lastmatch = -1;

		while (scur < slen) {
			if (pcur < plen && p[pcur] == '*') {
				while (pcur < plen && p[pcur] == '*') {
					pcur++;
				}
				lastmatch = scur;
				lastindex = pcur;
			}
			else if (p[pcur] == '?' || s[scur] == p[pcur]) {
				scur++;
				pcur++;
			}
			else if (lastindex != -1) {
				scur = ++lastmatch;
				pcur = lastindex;
			}
			else {
				return false;
			}
		}

		while (pcur < plen && p[pcur] == '*') {
			pcur++;
		}

		return pcur == plen;
	}

	std::string normalize_path(const std::string& path) {
		auto parts = split(path, { "/", "\\" });

		int end = 0;
		for (const auto& part : parts) {
			if (part == "." || part.empty()) {
				continue;
			}

			if (part == "..") {
				end = std::max(0, end - 1);
			}
			else {
				parts[end++] = part;
			}
		}

		if (end == 0) {
			return "";
		}

		fs::path normalized(parts[0]);
		for (int i = 1; i < end; i++) {
			normalized /= parts[i];
		}

		return normalized.string();
	}

	void _findFiles(
		std::vector<std::string>& matches,
		const std::vector<std::string>& parts,
		const fs::path& root_path,
		int flags,
		bool relative,
		int i = 0
	) {
		if ((flags & ::autoit::FLTA_FILESFOLDERS) == 0) {
			return;
		}

		const auto last_part = parts.size() - 1;
		bool found = false;
		fs::path dir = root_path;
		std::vector<std::string> next_matches;

		for (; i <= last_part; i++) {
			found = false;
			auto part = parts[i];

			if (
				(i != last_part || (flags & ::autoit::FLTA_FOLDERS) == ::autoit::FLTA_FOLDERS) &&
				part.find("?") == std::string::npos && part.find("*") == std::string::npos
				) {
				dir = dir / part;
				found = fs::exists(dir);
				if (!found) {
					break;
				}
				continue;
			}

			for (auto const& dir_entry : fs::directory_iterator{ dir }) {
				auto filename = dir_entry.path().filename().string();
				if (!isMatch(filename, part)) {
					continue;
				}

				auto filepath = dir / filename;
				auto relpath = filepath.lexically_relative(root_path);

				if (i == last_part) {
					bool is_valid = (flags & ::autoit::FLTA_FILESFOLDERS) == ::autoit::FLTA_FILESFOLDERS;
					if (!is_valid) {
						auto status = dir_entry.symlink_status();
						is_valid = (flags & ::autoit::FLTA_FILES) == ::autoit::FLTA_FILES && !fs::is_directory(status) ||
							(flags & ::autoit::FLTA_FILES) == ::autoit::FLTA_FOLDERS && fs::is_directory(status);
					}

					if (is_valid) {
						matches.push_back(relative ? relpath.string() : filepath.string());
					}

					continue;
				}

				next_matches.clear();
				_findFiles(next_matches, parts, filepath, flags, false, i + 1);

				for (const auto& match : next_matches) {
					filepath = fs::path(match);
					relpath = filepath.lexically_relative(root_path);
					matches.push_back(relative ? relpath.string() : filepath.string());
				}
			}

			break;
		}

		if (!found) {
			return;
		}

		const auto& filepath = dir;
		auto relpath = filepath.lexically_relative(root_path);

		bool is_valid = (flags & ::autoit::FLTA_FILESFOLDERS) == ::autoit::FLTA_FILESFOLDERS;
		if (!is_valid) {
			auto status = fs::symlink_status(filepath);
			is_valid = (flags & ::autoit::FLTA_FILES) == ::autoit::FLTA_FILES && !fs::is_directory(status) ||
				(flags & ::autoit::FLTA_FILES) == ::autoit::FLTA_FOLDERS && fs::is_directory(status);
		}

		if (is_valid) {
			matches.push_back(relative ? relpath.string() : filepath.string());
		}
	}

	void _findFiles(
		std::vector<std::string>& matches,
		const std::string& path,
		const fs::path& root_path,
		int flags,
		bool relative
	) {
		const auto& parts = split(path, { "/", "\\" });
		_findFiles(matches, parts, root_path, flags, relative);
	}
}

void autoit::findFiles(
	std::vector<std::string>& matches,
	const std::string& path,
	const std::string& directory,
	int flags,
	bool relative
) {
	_findFiles(matches, path, fs::absolute(directory), flags, relative);
}

std::string autoit::findFile(
	const std::string& path,
	const std::string& directory,
	const std::string& filter,
	const std::vector<std::string>& hints
) {
	std::string found;

	if (path.empty()) {
		return found;
	}

	std::vector<std::string> matches;
	fs::path root_path = fs::absolute(directory);

	while (true) {
		for (const auto& search_path : hints) {
			if (search_path.empty()) {
				continue;
			}

			fs::path spath(search_path);
			if (!filter.empty()) {
				spath = filter / spath;
			}
			spath /= path;

			_findFiles(matches, normalize_path(spath.string()), root_path, ::autoit::FLTA_FILESFOLDERS, false);
			if (!matches.empty()) {
				return matches[0];
			}
		}

		auto parent_path = root_path.parent_path();
		if (parent_path == root_path) {
			break;
		}
		root_path = parent_path;
	}

	return found;
}
