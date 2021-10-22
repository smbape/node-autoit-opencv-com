/* eslint-disable no-magic-numbers */

exports.case = `
    case VT_ERROR:
        return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
    case VT_EMPTY:
        return is_optional;
`.replace(/^ {4}/mg, "").trim().split("\n");

exports.check = `
    if (V_VT(in_val) == VT_ERROR) {
        return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND && is_optional;
    }

    if (V_VT(in_val) == VT_EMPTY) {
        return is_optional;
    }
`.replace(/^ {4}/mg, "").trim().split("\n");

exports.assign = `
    if (V_VT(in_val) == VT_ERROR) {
        return V_ERROR(in_val) == DISP_E_PARAMNOTFOUND ? S_OK : E_INVALIDARG;
    }

    if (V_VT(in_val) == VT_EMPTY) {
        return S_OK;
    }
`.replace(/^ {4}/mg, "").trim().split("\n");

exports.condition = value => {
    return `V_VT(${ value }) == VT_EMPTY || V_VT(${ value }) == VT_ERROR && V_ERROR(${ value }) == DISP_E_PARAMNOTFOUND`;
};
