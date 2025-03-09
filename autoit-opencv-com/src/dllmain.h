#pragma once

#include "autoit_bridge.h"

class CCvModule : public ATL::CAtlDllModuleT< CCvModule >
{
public:
	DECLARE_LIBID(LIBID_cvLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_CV, "{fc210206-673e-4ec8-82d5-1a6ac561f3de}")
};

extern class CCvModule _AtlModule;

STDAPI_(BOOL) DllActivateManifest(_In_opt_ LPCWSTR pManifest);
STDAPI_(BOOL) DllActivateActCtx(_In_opt_ PCACTCTXW pActCtx);
STDAPI_(BOOL) DllDeactivateActCtx();
