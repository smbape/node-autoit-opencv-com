const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const fs = require("node:fs");
const waterfall = require("async/waterfall");
const doctoc = require("../src/doctoc");
const { version, versions } = require("../src/version");

const regexEscape = str => {
    return str.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
};

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

const readme = sysPath.join(__dirname, "..", "README.md");

const VERSION_REG = "[0-9]+\\.[0-9]+\\.[0-9]+(?:-[0-9]+)?";

waterfall([
    next => {
        updateContent(readme, oldContent => {
            return oldContent.replace(new RegExp(`(${ [
                "autoit-opencv-com-",
                "/node-autoit-opencv-com/archive/refs/tags/v",
                "/node-autoit-opencv-com/releases/download/v",
            ].join("|") })${ VERSION_REG }(\\.7z|\\.zip)?`, "g"), `$1${ version }$2`);
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
            return oldContent
                .replace(/(FILE|PRODUCT)VERSION \S+/g, `$1VERSION ${ versions.join(",") }`)
                .replace(/"(File|Product)Version", "\S+"/g, `"$1Version", "${ version }"`);
        }, next);
    },

    (hasChanged, next) => {
        updateContent(sysPath.join(__dirname, "..", "autoit-opencv-com", "dotnet", "Properties", "AssemblyInfo.cs"), oldContent => {
            return oldContent.replace(/(Assembly|AssemblyFile)Version\("[^"\s*]+"\)/g, `$1Version("${ versions.join(".") }")`);
        }, next);
    },
], err => {
    if (err) {
        throw err;
    }
});
