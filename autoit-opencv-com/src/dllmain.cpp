#include "dllmain.h"

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

	if (pszCmdLine != nullptr)
	{
		if (_wcsnicmp(pszCmdLine, szUserSwitch, _countof(szUserSwitch)) == 0)
		{
			ATL::AtlSetPerUserRegistration(true);
		}
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
	ULONG_PTR activated = false;
	std::vector<ULONG_PTR> cookies;
}

STDAPI_(BOOL) DLLActivateActCtx()
{
	ULONG_PTR cookie = 0;
	if (ExtendedHolder::_ActCtx.Activate(cookie)) {
		cookies.push_back(cookie);
		return true;
	}
	return false;
}

STDAPI_(BOOL) DLLDeactivateActCtx()
{
	if (!cookies.empty() && ExtendedHolder::_ActCtx.Deactivate(cookies.back())) {
		cookies.pop_back();
		return true;
	}
	return false;
}
