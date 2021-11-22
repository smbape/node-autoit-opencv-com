const { spawn } = require("child_process");
const sysPath = require("path");
const fs = require("fs");
const eachOfLimit = require("async/eachOfLimit");
const waterfall = require("async/waterfall");

const regexEscape = str => {
    return str.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
};

const version = process.env.npm_package_version || require("../package.json").version;
const readme = sysPath.join(__dirname, "..", "README.md");

waterfall([
    next => {
        const oldContent = fs.readFileSync(readme).toString();
        const pos = oldContent.indexOf("autoit-opencv-4.5.4-com-v");
        if (pos === -1) {
            next(null, false);
            return;
        }

        const start = pos + "autoit-opencv-4.5.4-com-v".length;
        const end = oldContent.indexOf(".7z", start);
        if (end === -1) {
            next(null, false);
            return;
        }

        const oldVersion = oldContent.slice(start, end);
        next(null, oldVersion);
    },

    (oldVersion, next) => {
        if (!oldVersion) {
            next();
            return;
        }

        const replacer = new RegExp(regexEscape(oldVersion), "g");

        eachOfLimit([
            readme,
            sysPath.join(__dirname, "..", "autoit-opencv-com", "install.bat"),
        ], 1, (file, i, next) => {
            waterfall([
                next => {
                    fs.readFile(file, next);
                },

                (buffer, next) => {
                    const oldContent = buffer.toString();
                    const newContent = oldContent.replace(replacer, version);

                    if (newContent === oldContent) {
                        next(null, false);
                        return;
                    }

                    fs.writeFile(readme, newContent, err => {
                        next(err, true);
                    });
                },

                (hasChanged, next) => {
                    if (!hasChanged) {
                        next();
                        return;
                    }

                    const child = spawn("git", ["add", readme], {
                        stdio: "inherit"
                    });

                    child.on("error", next);
                    child.on("close", next);
                }
            ], next);
        }, next);
    }
], err => {
    if (err) {
        throw err;
    }
});
