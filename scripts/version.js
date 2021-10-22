const { spawn } = require("child_process");
const sysPath = require("path");
const fs = require("fs");
const waterfall = require("async/waterfall");

const regexEscape = str => {
    return str.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
};

const version = process.env.npm_package_version || require("../package.json").version;
const readme = sysPath.join(__dirname, "..", "README.md");

waterfall([
    next => {
        const oldReadmeContent = fs.readFileSync(readme).toString();
        const pos = oldReadmeContent.indexOf("autoit-opencv-4.5.4-com-v");
        if (pos === -1) {
            next(null, false);
            return;
        }

        const start = pos + "autoit-opencv-4.5.4-com-v".length;
        const end = oldReadmeContent.indexOf(".7z", start);
        if (end === -1) {
            next(null, false);
            return;
        }

        const oldVersion = oldReadmeContent.slice(start, end);
        const newReadmeContent = oldReadmeContent.replace(new RegExp(regexEscape(oldVersion), "g"), version);

        if (newReadmeContent === oldReadmeContent) {
            next(null, false);
            return;
        }

        fs.writeFile(readme, newReadmeContent, err => {
            next(err, true);
        });
    },

    (performed, next) => {
        if (!performed) {
            next();
            return;
        }

        const child = spawn("git", ["add", readme], {
            stdio: "inherit"
        });

        child.on("error", next);
        child.on("close", next);
    }
], err => {
    if (err) {
        throw err;
    }
});
