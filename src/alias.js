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

    const reg = new RegExp(`\\b(?:${ Array.from(options.namespaces).join("|") })::`, "g");

    return str.replace(reg, "");
};

// const options = {
//     shared_ptr: "std::shared_ptr",
//     namespaces: new Set([
//         "cv",
//         "std",
//         "dlib"
//     ])
// };

// ["dense_vect", "SpaceVector"],
// ["sample_type", "SpaceVector"],
// ["matrix_double_0_1", "SpaceVector"],
// ["matrix_double", "Matrix"],
// ["sparse_vect", "vector_pair_ULONG_and_double"],
// ["ranges", "vector_pair_ULONG_and_ULONG"],
// ["simple_object_detector", "fhog_object_detector"],

// console.log(exports.replaceAliases("shared_ptr_sparse_vect", options));
// console.log(exports.replaceAliases("sparse_vect", options));
// console.log(exports.replaceAliases("sparse_vector", options));
// console.log(exports.replaceAliases("sparse_vect ", options));
// console.log(exports.replaceAliases("sparse_vector ", options));
// console.log(exports.replaceAliases(" sparse_vect", options));
// console.log(exports.replaceAliases(" sparse_vector", options));
// console.log(exports.replaceAliases(" sparse_vect_and_", options));
// console.log(exports.replaceAliases("Mat_to_vector_sparse_vect_and_", options));
// console.log(exports.replaceAliases("vector_sparse_vect_and_", options));
// console.log(exports.replaceAliases("vector_sparse_vect", options));
// console.log(exports.replaceAliases("tuple_sparse_vect", options));
// console.log(exports.replaceAliases("tuple_sparse_vect_and_int", options));
// console.log(exports.replaceAliases("tuple_int_and_sparse_vect", options));
// console.log(exports.replaceAliases("tuple_int_and_sparse_vect_and_uint", options));
// console.log(exports.replaceAliases(" tuple_sparse_vect", options));
// console.log(exports.replaceAliases(" tuple_sparse_vect_and_int", options));
// console.log(exports.replaceAliases(" tuple_int_and_sparse_vect", options));
// console.log(exports.replaceAliases(" tuple_int_and_sparse_vect_and_uint", options));
// console.log(exports.replaceAliases("tuple_sparse_vect ", options));
// console.log(exports.replaceAliases("tuple_sparse_vect_and_int ", options));
// console.log(exports.replaceAliases("tuple_int_and_sparse_vect ", options));
// console.log(exports.replaceAliases("tuple_int_and_sparse_vect_and_uint ", options));
// console.log(exports.replaceAliases("_make_sparse_vector ", options));
