const {ALIASES} = require("./constants");

exports.replaceAliases = (str, options = {}, aliases = ALIASES) => {
    if (aliases.size === 0) {
        return str;
    }

    const shared_ptr = exports.removeNamespaces(options.shared_ptr, options);

    // Ptr, tuple, vector, pair
    const replacer = (match, offset, string) => {
        const end = offset + match.length;

        if (offset !== 0 && string[offset - 1] === "_") {
            while (offset > 0 && /\w/.test(string[offset - 1])) {
                offset--;
            }
        }

        // must be at the begining of a word
        if (offset !== 0 && /\w/.test(string[offset - 1])) {
            return match;
        }

        const end_word = end === string.length || /\W/.test(string[end]);

        // if it is a word
        if (end_word && (end - offset) === match.length) {
            return aliases.get(match);
        }

        // pointer or vector
        for (const prefix of [shared_ptr, "vector"]) {
            if (string.startsWith(`${ prefix }_`, offset)) {
                return end_word ? aliases.get(match) : match;
            }
        }

        // type in a tuple or a pair
        for (const prefix of ["tuple", "pair"]) {
            if (string.startsWith(`${ prefix }_`, offset)) {
                if (!end_word && !string.startsWith("_and_", end) && !string.startsWith("_end_", end)) {
                    return match;
                }

                const start = end - match.length;

                return start === offset
                    || string.endsWith("_and_", start)
                    || string.endsWith("_end_", start)
                    ? aliases.get(match) : match;
            }
        }

        return match;
    };

    return str.replace(new RegExp(Array.from(aliases.keys()).join("|"), "g"), replacer);
};

exports.removeNamespaces = (str, options = {}) => {
    if (!options.namespaces || options.namespaces.size === 0) {
        return str;
    }

    const reg = new RegExp(`\\b(?:${ Array.from(options.namespaces).sort((a, b) => b.length - a.length).join("|") })::`, "g");

    return str.replace(reg, "");
};

const EXPANSION_REG = [...Array(11).keys()].map(i => new RegExp(`\\$(?:${ i }\\b|\\{${ i }\\})`, "g"));

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
