const fs = require("node:fs");
const sysPath = require("node:path");

const walk = (start, files = [], seen = new Set()) => {
    if (!fs.existsSync(start) || seen.has(start)) {
        return files;
    }

    const realpath = fs.realpathSync(start);

    // protect against circular symbolic links
    if (seen.has(realpath)) {
        return files;
    }
    seen.add(realpath);

    const realStats = fs.lstatSync(realpath);

    if (realStats.isFile()) {
        files.push(start);
        return files;
    }

    if (!realStats.isDirectory()) {
        throw new Error(`Not a File nor a directory ${ start }`);
    }

    for (const file of fs.readdirSync(start)) {
        walk(sysPath.join(start, file), files);
    }

    return files;
};

const files = walk(sysPath.join(__dirname, "declarations"));
const default_declarations = [];

exports.push = (...declarations) => {
    default_declarations.push(...declarations);
};

exports.load = options => {
    const declarations = [...default_declarations];

    for (const file of files) {
        let decls = require(file);
        if (typeof decls === "function") {
            decls = decls(options);
        }
        declarations.push(...decls);
    }

    return declarations;
};
