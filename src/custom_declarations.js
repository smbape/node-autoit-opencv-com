const fs = require("node:fs");
const sysPath = require("node:path");

const files = fs.readdirSync(sysPath.join(__dirname, "declarations"));
const default_declarations = [];

exports.push = (...declarations) => {
    default_declarations.push(...declarations);
};

exports.load = options => {
    const declarations = [...default_declarations];

    for (const file of files) {
        let decls = require(sysPath.join(__dirname, "declarations", file));
        if (typeof decls === "function") {
            decls = decls(options);
        }
        declarations.push(...decls);
    }

    return declarations;
};
