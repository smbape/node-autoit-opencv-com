/* eslint-disable no-magic-numbers */

exports.check = `
    if (PARAMETER_MISSING(in_val)) {
        return is_optional;
    }
`.replace(/^ {4}/mg, "").trim().split("\n");

exports.assign = `
    if (PARAMETER_MISSING(in_val)) {
        return S_OK;
    }
`.replace(/^ {4}/mg, "").trim().split("\n");

exports.condition = value => {
    return `PARAMETER_MISSING(${ value })`;
};
