exports.removeNamespaces = (str, options = {}) => {
    if (!options.remove_namespaces || options.remove_namespaces.size === 0) {
        return str;
    }

    const reg = new RegExp(`\\b(?:${ Array.from(options.remove_namespaces).sort((a, b) => b.length - a.length).join("|") })::`, "g");

    return str.replace(reg, "");
};

exports.makeExpansion = (str, ...args) => {
    str = str.replace(/\$(?:0\b|\{0\})/g, args.join(", "));
    str = str.replace(/\$(?:(\d+)\b|\{(\d+)\})/g, (match, i1, i2) => {
        const i = parseInt(i1 || i2, 10) - 1;
        return i >= 0 && i < args.length ? args[i] : match;
    });
    return str;
};

const addAscendantNamespaces = (namespaces, namespace) => {
    if (typeof namespace !== "string") {
        return;
    }

    namespace.split("::").forEach((el, i, parts) => {
        const ascendant = parts.slice(0, parts.length - i).join("::");
        namespaces.add(`using namespace ${ ascendant };`);
    });
};

exports.useNamespaces = (body, method, processor, coclass) => {
    const namespaces = new Set();

    addAscendantNamespaces(namespaces, coclass.namespace);

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

exports.getTupleTypes = type => {
    const separators = /[,<>]/g;
    const types = [];

    let lastIndex = 0;
    let match;
    let open = 0;

    while (match = separators.exec(type)) { // eslint-disable-line no-cond-assign
        if (match[0] === "<") {
            open++;
        } else if (match[0] === ">") {
            open--;
        } else if (open === 0 && match[0] === ",") {
            types.push(type.slice(lastIndex, match.index).trim());
            lastIndex = separators.lastIndex;
        }
    }

    if (lastIndex !== type.length) {
        types.push(type.slice(lastIndex).trim());
    }

    return types;
};

const FUNDAMENTAL_TYPES = new Map([
    ["signed char", "char"],
    ["short int", "short"],
    ["signed short", "short"],
    ["signed short int", "short"],
    ["unsigned short int", "unsigned short"],
    ["short unsigned int", "unsigned short"],
    ["signed int", "int"],
    ["unsigned", "unsigned int"],
    ["long int", "long"],
    ["signed long", "long"],
    ["signed long int", "long"],
    ["unsigned long int", "unsigned long"],
    ["long unsigned int", "unsigned long"],
    ["long long int", "long long"],
    ["signed long long", "long long"],
    ["signed long long int", "long long"],
    ["unsigned long long int", "unsigned long long"],
    ["long long unsigned int", "unsigned long long"],
]);

exports.getTypeDef = (type, options) => {
    if (type.includes("<") && type.endsWith(">")) {
        const pos = type.indexOf("<");
        const tpl = type.slice(0, pos);
        const types = exports.getTupleTypes(type.slice(pos + 1, -">".length));
        type = `${ tpl }<${ types.map(itype => exports.getTypeDef(itype, options)).join(", ") }>`;
    } else if (FUNDAMENTAL_TYPES.has(type)) {
        type = FUNDAMENTAL_TYPES.get(type);
    }

    const typename = type
        .replace(/\bunsigned\s+\b/g, "u")
        .replace(/\bsigned\s+\b/g, "")
        .replace(/\s*\*/g, "Ptr")
        .replaceAll("std::map", "MapOf")
        .replaceAll("std::multimap", "MultiMapOf")
        .replaceAll("std::unordered_map", "UnorderedMapOf")
        .replaceAll("std:: unordered_multimap", "UnorderedMultiMapOf")
        .replaceAll("std::pair", "PairOf")
        .replaceAll("std::vector", "VectorOf")
        .replaceAll("std::shared_ptr", "SharedPtrOf")
        .replaceAll(options.shared_ptr, "SharedPtrOf")
        .replaceAll("std::variant", "VariantOf")
        .replaceAll("cv::util::variant", "CvVariantOf");

    const typedef = exports.removeNamespaces(typename, options)
        .replace(/\b_variant_t\b/g, "Variant")
        .replace(/::/g, "_")
        .replace(/\b[a-z]/g, m => m.toUpperCase())
        .replace(/, /g, "And")
        .replace(/[<> ]/g, "");

    return typedef;
};

const {ALIASES} = require("./constants");

exports.getAlias = str => {
    str = str.trim();

    const key = str.split(".").filter(item => Boolean(item)).join("::");

    if (ALIASES.has(key)) {
        return ALIASES.get(key);
    }

    if (FUNDAMENTAL_TYPES.has(key)) {
        return FUNDAMENTAL_TYPES.get(key);
    }

    const sep = str.includes("::") ? "::" : ".";

    if (!str.includes(sep)) {
        return str;
    }

    return str.split(sep).map(item => exports.getAlias(item)).join(sep);
};

const noSpaceReg = /\S/g;

exports.removeConstQualifiers = type => {
    if (!type.includes("<") || !type.endsWith(">")) {
        // ignore const qualifiers since they have no effect
        if (/(?:^const\s+|\s+const$)/.test(type) && !/^(?:const\s+char|char\s+const)\s*\*$/.test(type)) {
            type = type.replace(/(?:^const\s+|\s+const$)/, "");
        }

        return type.replace(/^struct\s+/, "");
    }

    const separators = /[,<>]/g;
    const types = [];

    let lastIndex = type.indexOf("<") + 1;
    let match;
    let open = 0;

    separators.lastIndex = lastIndex;

    while (match = separators.exec(type)) { // eslint-disable-line no-cond-assign
        if (match[0] === "<") {
            open++;
        } else if (match[0] === ">") {
            open--;
        } else if (open === 0 && match[0] === ",") {
            let end = match.index;
            while (end > 0 && /s/.test(type[end - 1])) {
                end--;
            }

            noSpaceReg.lastIndex = lastIndex;
            match = noSpaceReg.exec(type);
            const start = match.index;

            types.push({
                start,
                end
            });

            lastIndex = separators.lastIndex;
        }
    }

    if (lastIndex !== type.length - 1) {
        types.push({
            start: lastIndex,
            end: type.length - 1
        });
    }

    const replacers = [];
    lastIndex = 0;
    for (const {start, end} of types) {
        replacers.push(type.slice(lastIndex, start));
        replacers.push(exports.removeConstQualifiers(type.slice(start, end)));
        lastIndex = end;
    }
    replacers.push(">");

    return replacers.join("");
};
