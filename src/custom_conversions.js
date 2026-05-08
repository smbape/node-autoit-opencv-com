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

const files = walk(sysPath.join(__dirname, "conversions"));

const conversions = [];

for (const file of files) {
    conversions.push(require(file));
}

module.exports = conversions;
