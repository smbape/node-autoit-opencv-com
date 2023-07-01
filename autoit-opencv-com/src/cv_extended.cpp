#include "Cv_Object.h"

STDMETHODIMP CCv_Object::get_extended(VARIANT* _retval) {
	VARIANT out_val = { 0 };
	V_VT(&out_val) = VT_ARRAY | VT_VARIANT;
	V_ARRAY(&out_val) = ExtendedHolder::extended.Detach();

	VariantInit(_retval);
	HRESULT hr = VariantCopy(_retval, &out_val);
	ExtendedHolder::extended.Attach(V_ARRAY(&out_val));
	return hr;
}
