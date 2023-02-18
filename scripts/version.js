const { spawn } = require("child_process");
const sysPath = require("path");
const fs = require("fs");
const waterfall = require("async/waterfall");
const doctoc = require("../src/doctoc");

const regexEscape = str => {
    return str.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
};

const version = process.env.npm_package_version || require("../package.json").version;
const readme = sysPath.join(__dirname, "..", "README.md");

const updateContent = (file, replacer, cb) => {
    waterfall([
        next => {
            fs.readFile(file, next);
        },

        (buffer, next) => {
            const oldContent = buffer.toString();
            const newContent = replacer(oldContent);

            if (newContent === oldContent) {
                next(null, false);
                return;
            }

            fs.writeFile(file, newContent, err => {
                next(err, true);
            });
        },

        (hasChanged, next) => {
            if (!hasChanged) {
                next(null, hasChanged);
                return;
            }

            const child = spawn("git", ["add", file], {
                stdio: "inherit"
            });

            child.on("error", next);
            child.on("close", () => {
                next(null, hasChanged);
            });
        }
    ], cb);
};

waterfall([
    next => {
        const oldContent = fs.readFileSync(readme).toString();
        const pos = oldContent.indexOf("/node-autoit-opencv-com/releases/download/v");
        if (pos === -1) {
            next(null, false);
            return;
        }

        const start = pos + "/node-autoit-opencv-com/releases/download/v".length;
        const end = oldContent.indexOf("/", start);
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

        waterfall([
            next => {
                updateContent(readme, oldContent => {
                    const replacer = new RegExp(regexEscape(oldVersion), "g");
                    return oldContent.replace(replacer, version);
                }, next);
            },

            (hasChanged, next) => {
                doctoc.transformAndSave([readme], (err, transformed) => {
                    if (!transformed) {
                        next(null, transformed);
                        return;
                    }

                    const child = spawn("git", ["add", readme], {
                        stdio: "inherit"
                    });

                    child.on("error", next);
                    child.on("close", () => {
                        next(null, transformed);
                    });

                    next(err, transformed);
                });
            },

            (hasChanged, next) => {
                updateContent(sysPath.join(__dirname, "..", "autoit-opencv-com", "install.bat"), oldContent => {
                    return oldContent.replace(/VERSION: \S+/, `VERSION: ${ version }`);
                }, next);
            },

            (hasChanged, next) => {
                updateContent(sysPath.join(__dirname, "..", "autoit-opencv-com", "src", "cvLib.rc"), oldContent => {
                    const vsversion = version.split(".").join(",").replace(/[^\d,]/g, "");
                    return oldContent
                        .replace(/(FILE|PRODUCT)VERSION \S+/g, `$1VERSION ${ vsversion }`)
                        .replace(/"(File|Product)Version", "\S+"/g, `"$1Version", "${ version }"`);
                }, next);
            },

            (hasChanged, next) => {
                updateContent(sysPath.join(__dirname, "..", "autoit-opencv-com", "dotnet", "Properties", "AssemblyInfo.cs"), oldContent => {
                    return oldContent.replace(/(Assembly|AssemblyFile)Version\("[^"\s*]+"\)/g, `$1Version("${ version }.0")`);
                }, next);
            },
        ], next);
    }
], err => {
    if (err) {
        throw err;
    }
});
