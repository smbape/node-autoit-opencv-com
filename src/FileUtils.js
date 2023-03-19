const fs = require("node:fs");
const sysPath = require("node:path");
const cpus = require("node:os").cpus().length;
const eol = require("eol");
const eachOfLimit = require("async/eachOfLimit");
const waterfall = require("async/waterfall");
const series = require("async/series");
const mkdirp = require("mkdirp");

const MidlCompiler = require("./MidlCompiler");
const doctoc = require("./doctoc");

/**
 * @param  {String} str
 * @param  {String} pattern
 * @return {boolean}
 */
const isMatch = (str, pattern) => {
    const slen = str.length;
    const plen = pattern.length;

    let s = 0;
    let p = 0;
    let lastindex = -1;
    let lastmatch = 0;

    while (s < slen) {
        if (p < plen && pattern[p] === "*") {
            // it is enough to match patterns that are not wilward in the order of encounter
            // therefore, keeping track of the last wildcard position is enough
            while (p < plen && pattern[p] === "*") {
                p++;
            }

            lastindex = p;
            lastmatch = s;
        } else if (p < plen && (pattern[p] === "?" || pattern[p] === str[s])) {
            // pattern and text matches, advance both cursors
            p++;
            s++;
        } else if (lastindex !== -1) {
            // there is a wildcard before the remaining pattern
            // the remaining pattern was not found from the lastmatch
            // match one character as wilwcard
            // and retry from the last non wildcard pattern match
            s = ++lastmatch;
            p = lastindex;
        } else {
            return false;
        }
    }

    while (p < plen && pattern[p] === "*") {
        p++;
    }

    return p === plen;
};

const findFile = (path, rootPath = ".") => {
    path = path.split(/[\\/]/).join(sysPath.sep);

    const pos = path.indexOf("*");

    if (pos === -1) {
        path = sysPath.resolve(rootPath, path);
        try {
            fs.accessSync(path, fs.constants.R_OK);
            return path;
        } catch (err) {
            return null;
        }
    }

    const start = path.lastIndexOf(sysPath.sep, pos - 1);
    const end = path.indexOf(sysPath.sep, start + 1);
    const prefix = start === -1 ? sysPath.resolve(rootPath) : sysPath.resolve(rootPath, path.slice(0, start));
    const pattern = path.slice(start + 1, end === -1 ? path.length : end);
    const suffix = path.slice(end + 1);

    const candidates = fs.readdirSync(prefix).filter(item => {
        return isMatch(item, pattern);
    });

    for (const candidate of candidates) {
        const file = findFile(suffix, sysPath.join(prefix, candidate));
        if (file !== null) {
            return file;
        }
    }

    return null;
};

exports.findFile = findFile;

const writeFiles = (files, options, cb) => {
    const idls_to_generate = new Set();
    const doctoc_to_generate = new Set();

    series([
        next => {
            // write files
            eachOfLimit(files.keys(), cpus, (filename, i, next) => {
                if (options.save === false) {
                    next();
                    return;
                }

                const has_doc_toc = options.toc !== false && filename.endsWith(".md");

                waterfall([
                    next => {
                        mkdirp(sysPath.dirname(filename)).then(performed => {
                            next();
                        }, next);
                    },

                    next => {
                        fs.readFile(filename, (err, buffer) => {
                            if (err && err.code === "ENOENT") {
                                err = null;
                                buffer = Buffer.from([]);
                            }
                            next(err, buffer);
                        });
                    },

                    (buffer, next) => {
                        const content = eol[has_doc_toc ? "lf" : "crlf"](files.get(filename));
                        const str = buffer.toString();

                        if (content === str) {
                            next(null, false);
                            return;
                        }

                        console.log("write file", options.output, sysPath.relative(options.output, filename));

                        fs.writeFile(filename, content, err => {
                            next(err, true);
                        });
                    },

                    (performed, next) => {
                        if (performed && has_doc_toc) {
                            doctoc_to_generate.add(filename);
                        }

                        if (!filename.endsWith(".idl") || options.skip.has("idl")) {
                            next();
                            return;
                        }

                        fs.stat(filename, (err, stats) => {
                            if (err) {
                                next(err);
                                return;
                            }

                            const dirname = sysPath.dirname(filename);
                            const basename = sysPath.basename(filename, ".idl");
                            const header = sysPath.join(dirname, `${ basename }.h`);

                            fs.stat(header, (err, hstats) => {
                                if (err && err.code === "ENOENT") {
                                    err = null;
                                }

                                if (options.build.has("idl") || !hstats || hstats.mtime < stats.mtime) {
                                    idls_to_generate.add(filename);

                                    // tlb must be regenerated on any idl change
                                    idls_to_generate.add(sysPath.join(options.output, `${ options.LIBRARY }.idl`));
                                }

                                next(err);
                            });
                        });
                    },
                ], next);
            }, next);
        },

        next => {
            // generate doctoc
            doctoc.transformAndSave(doctoc_to_generate, next);
        },

        next => {
            // compile idls
            // manual compilation is necessary because
            // vs will loop indefinetely due to circular dependencies
            eachOfLimit(idls_to_generate, cpus, (filename, i, next) => {
                MidlCompiler.compile(filename, options, next);
            }, next);
        },
    ], cb);
};

exports.writeFiles = writeFiles;

const deleteFiles = (directory, files, options, cb) => {
    files = new Set([...files.keys()]);

    for (const file of files) {
        if (!file.endsWith(".idl")) {
            continue;
        }

        const basename = file.slice(0, -".idl".length);
        files.add(`${ basename }.h`);
        files.add(`${ basename }_p.c`);
        files.add(`${ basename }_i.c`);
        files.add(`${ basename }.tlb`);

        const dirname = sysPath.dirname(file);
        files.add(sysPath.join(dirname, "dlldata.c"));
    }

    waterfall([
        next => {
            fs.readdir(directory, next);
        },

        (names, next) => {
            eachOfLimit(names, cpus, (filename, i, next) => {
                filename = sysPath.join(directory, filename);

                if (files.has(filename) || ![".c", ".cc", ".cpp", ".h", ".idl", ".tlb"].some(ext => filename.endsWith(ext))) {
                    next();
                    return;
                }

                fs.unlink(filename, next);
            }, next);
        }
    ], cb);
};

exports.deleteFiles = deleteFiles;
