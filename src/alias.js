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

exports.useNamespaces = (body, method, processor, coclass) => {
    const namespaces = new Set();

    if (coclass.namespace) {
        // useNamspace(namespaces, coclass.namespace);
        namespaces.add(`using namespace ${ coclass.namespace };`);
    }

    if (coclass.include && coclass.include.namespace) {
        namespaces.add(`using namespace ${ coclass.include.namespace };`);
    }

    if (processor.namespace) {
        namespaces.add(`using namespace ${ processor.namespace };`);
    }

    if (namespaces.size !== 0) {
        namespaces.add("");
    }

    body[method](...Array.from(namespaces).sort((a, b) => {
        if (a.length === 0) {
            return 1;
        }

        if (b.length === 0) {
            return -1;
        }

        const aLen = a.split("::").length;
        const bLen = b.split("::").length;

        if (aLen > bLen) {
            return -1;
        }

        if (aLen < bLen) {
            return 1;
        }

        return a < b ? -1 : a > b ? 1 : 0;
    }));
};

exports.getTypeDef = (type, options) => {
    let type_def = type
        .replace(/\b(u?int(?:8|16|32|64))_t\b/g, "$1")
        .replaceAll("std::map", "MapOf")
        .replaceAll("std::pair", "PairOf")
        .replaceAll("std::vector", "VectorOf")
        .replaceAll("std::shared_ptr", "SharedPtrOf")
        .replaceAll(options.shared_ptr, "SharedPtrOf")
        .replaceAll("std::variant", "VariantOf")
        .replaceAll("cv::util::variant", "CvVariantOf");

    type_def = exports.removeNamespaces(type_def, options)
        .replace(/\b_variant_t\b/g, "Variant")
        .replace(/::/g, "_")
        .replace(/\b[a-z]/g, m => m.toUpperCase())
        .replace(/, /g, "And")
        .replace(/[<>]/g, "");

    return type_def;
};

const {ALIASES} = require("./constants");

exports.getAlias = str => {
    str = str.trim();

    const key = str.split(".").filter(item => Boolean(item)).join("::");
    if (ALIASES.has(key)) {
        return ALIASES.get(key);
    }

    const sep = str.includes("::") ? "::" : ".";
    return str.split(sep).map(item => (ALIASES.has(item) ? ALIASES.get(item) : item)).join(sep);
};
