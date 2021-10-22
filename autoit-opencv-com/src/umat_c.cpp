#include "Cv_UMat_Object.h"

STDMETHODIMP CCv_UMat_Object::get_step(ULONGLONG* pVal) {
    *pVal = static_cast<ULONGLONG>(this->__self->get()->step);
    return S_OK;
}
