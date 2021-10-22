const fs = require("fs");
const sysPath = require("path");

const files = fs.readdirSync(sysPath.join(__dirname, "declarations"));

const declarations = [];

for (const file of files) {
    declarations.push(...require(sysPath.join(__dirname, "declarations", file)));
}

module.exports = declarations;
