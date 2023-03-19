const {ALIASES} = require("./constants");

exports.getAlias = str => {
    str = str.trim();
    return ALIASES.has(str) ? ALIASES.get(str) : str;
};

exports.removeNamespaces = (str, options = {}) => {
    if (!options.remove_namespaces || options.remove_namespaces.size === 0) {
        return str;
    }

    const reg = new RegExp(`\\b(?:${ Array.from(options.remove_namespaces).sort((a, b) => b.length - a.length).join("|") })::`, "g");

    return str.replace(reg, "");
};

const MAX_ARGS = 10;
const EXPANSION_REG = [...Array(MAX_ARGS).keys()].map(i => new RegExp(`\\$(?:${ i }\\b|\\{${ i }\\})`, "g"));

exports.makeExpansion = (str, ...args) => {
    str = str.replace(EXPANSION_REG[0], args.join(", "));
    for (let i = 0; i < args.length && i + 1 < EXPANSION_REG.length; i++) {
        str = str.replace(EXPANSION_REG[i + 1], args[i]);
    }
    return str;
};

exports.useNamespaces = (body, method, coclass, generator) => {
    const namespaces = new Set();

    if (generator.namespace) {
        namespaces.add(`using namespace ${ generator.namespace };`);
    }

    if (coclass.namespace) {
        namespaces.add(`using namespace ${ coclass.namespace };`);
    }

    if (coclass.include && coclass.include.namespace && coclass.include.namespace !== coclass.namespace) {
        namespaces.add(`using namespace ${ coclass.include.namespace };`);
    }

    body[method](...namespaces);
};

exports.getTypeDef = (type, options) => {
    type = type
        .replace(/std::map/g, "MapOf")
        .replace(/std::pair/g, "PairOf")
        .replace(/std::vector/g, "VectorOf");
    return exports.removeNamespaces(type, options)
        .replace(/\b_variant_t\b/g, "Variant")
        .replace(/::/g, "_")
        .replace(/\b[a-z]/g, m => m.toUpperCase())
        .replace(/, /g, "And")
        .replace(/[<>]/g, "");
};
