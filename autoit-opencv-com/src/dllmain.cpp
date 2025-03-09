#include "dllmain.h"
#include <filesystem>

namespace fs = std::filesystem;

using namespace ATL;

CCvModule _AtlModule;

// Point d'entrée de la DLL
STDAPI_(BOOL) DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	if (dwReason == DLL_PROCESS_ATTACH) {
		ExtendedHolder::CreateActivationContext(hInstance);
	}
	else if (dwReason == DLL_PROCESS_DETACH) {
		ExtendedHolder::_ActCtx.Set(INVALID_HANDLE_VALUE);
	}
	return _AtlModule.DllMain(dwReason, lpReserved);
}

// Utilisé pour déterminer si la DLL peut être déchargée par OLE.
_Use_decl_annotations_
STDAPI DllCanUnloadNow(void)
{
	return _AtlModule.DllCanUnloadNow();
}

// Retourne une fabrique de classes pour créer un objet du type demandé.
_Use_decl_annotations_
STDAPI DllGetClassObject(_In_ REFCLSID rclsid, _In_ REFIID riid, _Outptr_ LPVOID* ppv)
{
	return _AtlModule.DllGetClassObject(rclsid, riid, ppv);
}

// DllRegisterServer - Ajoute des entrées à la base de registres.
_Use_decl_annotations_
STDAPI DllRegisterServer(void)
{
	// inscrit l'objet, la typelib et toutes les interfaces dans la typelib
	HRESULT hr = _AtlModule.DllRegisterServer();
	return hr;
}

// DllUnregisterServer - Supprime des entrées de la base de registres.
_Use_decl_annotations_
STDAPI DllUnregisterServer(void)
{
	HRESULT hr = _AtlModule.DllUnregisterServer();
	return hr;
}

// DllInstall - Ajoute/supprime des entrées de la base de registres par utilisateur et par ordinateur.
STDAPI DllInstall(BOOL bInstall, _In_opt_ LPCWSTR pszCmdLine)
{
	HRESULT hr = E_FAIL;
	static const wchar_t szUserSwitch[] = L"user";

	if (pszCmdLine != nullptr && _wcsnicmp(pszCmdLine, szUserSwitch, _countof(szUserSwitch)) == 0)
	{
		ATL::AtlSetPerUserRegistration(true);
	}

	if (bInstall)
	{
		hr = DllRegisterServer();
		if (FAILED(hr))
		{
			DllUnregisterServer();
		}
	}
	else
	{
		hr = DllUnregisterServer();
	}

	return hr;
}

namespace {
	std::vector<ULONG_PTR> cookies;
	std::map<int, HANDLE> handles;
}

STDAPI_(BOOL) DllActivateManifest(_In_opt_ LPCWSTR pManifest)
{
	if (pManifest == nullptr || wcslen(pManifest) == 0) {
		PCACTCTXW pActCtx = nullptr;
		return DllActivateActCtx(pActCtx);
	}

	ACTCTXW actCtx;
	memset((void*)&actCtx, 0, sizeof(ACTCTXW));
	actCtx.cbSize = sizeof(ACTCTXW);
	actCtx.lpSource = pManifest;
	return DllActivateActCtx(&actCtx);
}

STDAPI_(BOOL) DllActivateActCtx(_In_opt_ PCACTCTXW pActCtx)
{
	ULONG_PTR ulpCookie = 0;
	BOOL activated = false;
	HANDLE hActCtx = INVALID_HANDLE_VALUE;

	if (pActCtx == nullptr) {
		activated = ExtendedHolder::_ActCtx.Activate(ulpCookie);
	}
	else {
		hActCtx = ::CreateActCtxW(pActCtx);
		CV_Assert(hActCtx != INVALID_HANDLE_VALUE);

		handles.insert_or_assign(cookies.size(), hActCtx);
		activated = ::ActivateActCtx(hActCtx, &ulpCookie);
	}

	CV_Assert(activated);

	cookies.push_back(ulpCookie);
	return true;
}

STDAPI_(BOOL) DllDeactivateActCtx()
{
	if (cookies.empty()) {
		return false;
	}

	auto ulpCookie = cookies.back();
	if (!::DeactivateActCtx(0, ulpCookie)) {
		return false;
	}
	cookies.pop_back();

	if (handles.count(cookies.size())) {
		const auto hActCtx = handles.at(cookies.size());

		::ReleaseActCtx(hActCtx);

		handles.erase(cookies.size());
	}

	return true;
}
