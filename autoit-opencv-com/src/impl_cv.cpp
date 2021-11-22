#include "Cv_Object.h"

STDMETHODIMP CCv_Object::get_extended(VARIANT* _retval) {
    auto pArray = ExtendedHolder::extended.Detach();
    V_VT(_retval) = VT_ARRAY | VT_VARIANT;
    V_ARRAY(_retval) = pArray;
    PVOID pDataToRelease;
    HRESULT hr = SafeArrayAddRef(pArray, &pDataToRelease);
    if (pDataToRelease) {
        SafeArrayReleaseData(pDataToRelease);
    }
    ExtendedHolder::extended.Attach(pArray);
    return hr;
}

const _variant_t CCv_Object::variant(void* ptr, HRESULT& hr) {
    return _variant_t(static_cast<VARIANT*>(ptr));
}
