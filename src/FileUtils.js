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
    let parent = sysPath.resolve(rootPath);
    const isAbsolute = sysPath.isAbsolute(path);

    do {
        rootPath = parent;
        parent = sysPath.dirname(rootPath);

        if (pos === -1) {
            const rpath = isAbsolute ? sysPath.resolve(path) : sysPath.resolve(rootPath, path);
            try {
                fs.accessSync(rpath, fs.constants.R_OK);
                return rpath;
            } catch (err) {
                continue;
            }
        }

        const start = path.lastIndexOf(sysPath.sep, pos - 1);
        const end = path.indexOf(sysPath.sep, start + 1);
        const prefix = start === -1 ? rootPath : sysPath.resolve(rootPath, path.slice(0, start));
        const pattern = path.slice(start + 1, end === -1 ? path.length : end);
        const suffix = end === -1 ? "" : path.slice(end + 1);

        const candidates = !fs.existsSync(prefix) ? [] : fs.readdirSync(prefix).filter(item => {
            return isMatch(item, pattern);
        });

        for (const candidate of candidates) {
            const next = sysPath.join(prefix, candidate);

            if (end === -1) {
                return next;
            }

            const file = findFile(suffix, next);
            if (file !== null) {
                return file;
            }
        }

        continue;
    } while (!isAbsolute && parent !== rootPath); // eslint-disable-line no-unmodified-loop-condition

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
                const has_doc_toc = options.toc !== false && filename.endsWith(".md");

                waterfall([
                    next => {
                        if (options.save === false) {
                            next();
                            return;
                        }

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
                        if (options.save === false) {
                            next(null, false);
                            return;
                        }

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
            if (options.save === false) {
                next();
                return;
            }

            // generate doctoc
            doctoc.transformAndSave(doctoc_to_generate, next);
        },

        next => {
            const {size} = idls_to_generate;

            if (size !== 0) {
                console.log(`midl files to compile = ${ size }`);
            }

            // compile idls
            // manual compilation is necessary because
            // vs will loop indefinitely due to circular dependencies
            eachOfLimit(idls_to_generate, cpus, (filename, i, next) => {
                console.log(`compiling file ${ i + 1 } / ${ size }`);
                MidlCompiler.compile(filename, options, next);
            }, next);
        },

        next => {
            const proxyfiles = [];
            const library = sysPath.join(options.output, `${ options.LIBRARY }.idl`);
            let generated;

            eachOfLimit(files.keys(), cpus, (filename, i, next) => {
                if (!filename.endsWith(".idl") || filename === library || options.skip.has("idl")) {
                    next();
                    return;
                }

                const dirname = sysPath.dirname(filename);
                const basename = sysPath.basename(filename, ".idl");
                const proxy = sysPath.join(dirname, `${ basename }_p.c`);
                generated = dirname;

                waterfall([
                    next => {
                        fs.readFile(proxy, next);
                    },

                    (buffer, next) => {
                        const content = buffer.toString();
                        const end = content.indexOf("_ProxyFileInfo");
                        const start = content.lastIndexOf(" ", end) + 1;
                        proxyfiles.push(content.slice(start, end));
                        next();
                    },
                ], next);
            }, err => {
                if (err || proxyfiles.length === 0) {
                    next(err);
                    return;
                }

                proxyfiles.sort();

                const dlldata = `
                    /*********************************************************
                       DllData file -- generated by MIDL compiler 

                            DO NOT ALTER THIS FILE

                       This file is regenerated by MIDL on every IDL file compile.

                       To completely reconstruct this file, delete it and rerun MIDL
                       on all the IDL files in this DLL, specifying this file for the
                       /dlldata command line option

                    *********************************************************/

                    #define PROXY_DELEGATION

                    #include <rpcproxy.h>

                    #ifdef __cplusplus
                    extern "C"   {
                    #endif

                    ${ proxyfiles.map(proxy => `EXTERN_PROXY_FILE( ${ proxy } )`).join(`\n${ " ".repeat(20) }`) }


                    PROXYFILE_LIST_START
                    /* Start of list */
                      ${ proxyfiles.map(proxy => `REFERENCE_PROXY_FILE( ${ proxy } ),`).join(`\n${ " ".repeat(22) }`) }
                    /* End of list */
                    PROXYFILE_LIST_END


                    DLLDATA_ROUTINES( aProxyFileList, GET_DLL_CLSID )

                    #ifdef __cplusplus
                    }  /*extern "C" */
                    #endif

                    /* end of generated dlldata file */
                `.replace(/^ {20}/mg, "").trim();

                const output = sysPath.join(generated, "dlldata.c");

                writeFiles(new Map([[output, `${ dlldata }\n`]]), options, next);
            });
        },
    ], err => {
        cb(err);
    });
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

                if (files.has(filename) || ![".h", ".hpp", ".c", ".cc", ".cpp", ".cxx", ".idl", ".tlb"].some(ext => filename.endsWith(ext))) {
                    next();
                    return;
                }

                console.log("delete file", filename);
                if (options.save === false) {
                    next();
                    return;
                }

                fs.unlink(filename, next);
            }, next);
        }
    ], err => {
        cb(err);
    });
};

exports.deleteFiles = deleteFiles;
