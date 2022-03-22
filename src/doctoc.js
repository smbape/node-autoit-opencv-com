const fs = require("fs");
const cpus = require("os").cpus().length;
const transform = require("doctoc/lib/transform");
const eachOfLimit = require("async/eachOfLimit");
const waterfall = require("async/waterfall");

exports.modes = {
    bitbucket: "bitbucket.org",
    nodejs: "nodejs.org",
    github: "github.com",
    gitlab: "gitlab.com",
    ghost: "ghost.org"
};

exports.transformAndSave = (files, cb, mode = exports.modes.github, maxHeaderLevel = undefined, title = undefined, notitle = false, entryPrefix = "-", processAll = false, stdOut = false, updateOnly = false) => {
    if (processAll) {
        console.log("--all flag is enabled. Including headers before the TOC location.");
    }

    if (updateOnly) {
        console.log("--update-only flag is enabled. Only updating files that already have a TOC.");
    }

    eachOfLimit(files, stdOut ? 1 : cpus, (file, i, next) => {
        console.log ('DocToccing file "%s" for %s.', file, mode);

        waterfall([
            next => {
                fs.readFile(file, next);
            },

            (buffer, next) => {
                const content = buffer.toString();
                const result = transform(content, mode, maxHeaderLevel, title, notitle, entryPrefix, processAll, updateOnly);
                const shouldUpdate = result.transformed && content !== result.data;

                if (stdOut) {
                    console.log(result.toc);
                    if (shouldUpdate) {
                        console.log("==================\n\n\"%s\" should be updated", file);
                    }
                    next(null, result.transformed);
                    return;
                }

                if (shouldUpdate) {
                    console.log("\"%s\" will be updated", file);
                    fs.writeFile(file, result.data, err => {
                        next(err, true);
                    });
                    return;
                }

                console.log("\"%s\" is up to date", file);
                next(null, false);
            }
        ], next);
    }, cb);
};
