const fs = require("fs");
const sysPath = require("path");

const files = fs.readdirSync(sysPath.join(__dirname, "conversions"));

const conversions = [];

for (const file of files) {
    conversions.push(require(sysPath.join(__dirname, "conversions", file)));
}

module.exports = conversions;
