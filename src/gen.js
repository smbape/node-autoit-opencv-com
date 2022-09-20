/* eslint-disable no-magic-numbers */

const fs = require("node:fs");
const fsPromises = require("node:fs/promises");
const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const mkdirp = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");

const parseArguments = PROJECT_DIR => {
    const options = {
        APP_NAME: "OpenCV",
        LIB_UID: "fc210206-673e-4ec8-82d5-1a6ac561f3de",
        LIBRARY: "cvLib",
        namespace: "cv",
        shared_ptr: "cv::Ptr",
        make_shared: "std::make_shared",
        assert: "AUTOIT_ASSERT",
        variantTypeReg: /^cv::(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/,
        implicitNamespaceType: /^(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/,
        namespaces: new Set([
            "cv",
            "std",
        ]),
        other_namespaces: new Set(),
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        make: sysPath.join(PROJECT_DIR, "build.bat"),
        includes: [sysPath.join(PROJECT_DIR, "src")],
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true, // the limit of 1000KB is exeeded even without toc
        globals: ["$CV_MAT_DEPTH_MASK", "$CV_MAT_TYPE_MASK"],
        constReplacer: new Map([["std::numeric_limits<uint8_t>::max()", "0xFF"]]),
        onClass: (generator, coclass, opts) => {
            const {fqn, name} = coclass;

            if (fqn === "cv::cuda::GpuData") {
                // assign operator has been deleted
                // avoir setting a conversion for this class
                coclass.is_class = true;
                coclass.is_struct = false;
            }

            // https://github.com/MicrosoftDocs/win32/blob/docs/desktop-src/Midl/compiler-errors.md#user-content-midl2379
            // until a way around MIDL limitation of 64 KB is found
            // keep the code
            const has_MIDL2379 = true;
            if (has_MIDL2379) {
                return;
            }

            if (fqn === "cv::Moments" || !fqn.startsWith("cv::") || fqn.split("::").length !== 2) {
                return;
            }

            // expose a ${ name } property like in mediapipe python
            const parts = fqn.split("::");
            parts[parts.length - 1] = "";
            generator.add_func([parts.join("."), "", ["/Properties"], [
                [fqn, name, "", ["/R", "=this"]],
            ], "", ""]);
        },
    };

    for (const opt of ["iface", "hdr", "impl", "idl", "rgs", "res", "save"]) {
        options[opt] = !process.argv.includes(`--no-${ opt }`);
    }

    for (const opt of ["test"]) {
        options[opt] = process.argv.includes(`--${ opt }`);
    }

    for (const opt of process.argv) {
        if (opt.startsWith("--no-test=")) {
            for (const fqn of opt.slice("--no-test=".length).split(/[ ,]/)) {
                options.notest.add(fqn);
            }
        }

        if (opt.startsWith("--build=")) {
            for (const fqn of opt.slice("--build=".length).split(/[ ,]/)) {
                options.build.add(fqn);
            }
        }

        if (opt.startsWith("--skip=")) {
            for (const fqn of opt.slice("--skip=".length).split(/[ ,]/)) {
                options.skip.add(fqn);
            }
        }
    }

    return options;
};

const {
    CUSTOM_CLASSES,
} = require("./constants");

const {replaceAliases} = require("./alias");

const custom_declarations = require("./custom_declarations");
const AutoItGenerator = require("./AutoItGenerator");

const PROJECT_DIR = sysPath.resolve(__dirname, "../autoit-opencv-com");
const SRC_DIR = sysPath.join(PROJECT_DIR, "src");

const candidates = fs.readdirSync(sysPath.join(__dirname, "..")).filter(path => {
    if (!path.startsWith("opencv-4.")) {
        return false;
    }

    try {
        fs.accessSync(sysPath.join(__dirname, "..", path, "opencv"), fs.constants.R_OK);
        return true;
    } catch (err) {
        return false;
    }
});

const python_generator = sysPath.join(PROJECT_DIR, "opencv_build_x64", "modules", "python_bindings_generator");
const src2 = sysPath.resolve(__dirname, "..", candidates[0], "opencv/sources/modules/python/src2");
const headers = sysPath.join(python_generator, "headers.txt");
const pyopencv_generated_include = sysPath.join(python_generator, "pyopencv_generated_include.h");

const hdr_parser = fs.readFileSync(sysPath.join(src2, "hdr_parser.py")).toString();
const hdr_parser_start = hdr_parser.indexOf("class CppHeaderParser");
const hdr_parser_end = hdr_parser.indexOf("if __name__ == '__main__':");

const options = parseArguments(PROJECT_DIR);

waterfall([
    next => {
        try {
            fs.accessSync(pyopencv_generated_include, fs.constants.R_OK);
            next();
            return;
        } catch (err) {
            // Nothing to do
        }

        console.log("generating", pyopencv_generated_include);

        const child = spawn("python", [sysPath.join(src2, "gen2.py"), python_generator, headers], {
            stdio: [0, "pipe", "pipe"]
        });

        child.stdout.on("data", chunk => {
            process.stdout.write(chunk);
        });

        child.stderr.on("data", chunk => {
            process.stderr.write(chunk);
        });

        child.on("close", code => {
            if (code !== 0) {
                console.log(`python process exited with code ${ code }`);
                process.exit(code);
            }
            next();
        });
    },

    next => {
        mkdirp(options.output).then(performed => {
            next();
        }, next);
    },

    next => {
        const srcfiles = [];

        explore(SRC_DIR, async (path, stats, next) => {
            if (path.endsWith(".h") || path.endsWith(".hpp")) {
                const content = await fsPromises.readFile(path);
                if (content.includes("CV_EXPORTS")) {
                    srcfiles.push(path);
                }
            }
            next();
        }, {followSymlink: true}, async err => {
            const generated_include = (await fsPromises.readFile(pyopencv_generated_include))
                .toString()
                .split("\n")
                .filter(include => include.indexOf("python_bridge") === -1)
                .concat(srcfiles.map(path => `#include "${ path.slice(SRC_DIR.length + 1).replace("\\", "/") }"`));

            next(err, srcfiles, generated_include);
        });
    },

    (srcfiles, generated_include, next) => {
        srcfiles.push(sysPath.resolve(__dirname, "..", candidates[0], "opencv/sources/modules/flann/include/opencv2/flann/defines.h"));

        const buffers = [];
        let nlen = 0;
        const child = spawn("python", []);

        child.stderr.on("data", chunk => {
            process.stderr.write(chunk);
        });

        child.on("close", code => {
            if (code !== 0) {
                console.log(`python process exited with code ${ code }`);
                process.exit(code);
            }

            const buffer = Buffer.concat(buffers, nlen);

            const json = JSON.parse(replaceAliases(buffer.toString(), options));
            json.decls.push(...custom_declarations);

            const configuration = JSON.parse(replaceAliases(JSON.stringify(json), options));
            configuration.generated_include = generated_include;

            for (const [name, modifiers] of CUSTOM_CLASSES) {
                configuration.decls.push([`class ${ name }`, "", modifiers, [], "", ""]);
            }

            configuration.namespaces.push(...options.namespaces);
            configuration.namespaces.push(...options.other_namespaces);

            const generator = new AutoItGenerator();
            generator.generate(configuration, options, next);
        });

        child.stderr.on("data", chunk => {
            process.stderr.write(chunk);
        });

        child.stdout.on("data", chunk => {
            buffers.push(chunk);
            nlen += chunk.length;
        });

        const code = `
            import io, json, os, re, string, sys

            ${ hdr_parser
                .slice(hdr_parser_start, hdr_parser_end)
                .replace(`${ " ".repeat(20) }if self.wrap_mode:`, `${ " ".repeat(20) }if False:`)
                .replace(/\("std::", ""\), \("cv::", ""\)/g, Array.from(options.namespaces).map(namespace => `("${ namespace }::", "")`).join(", "))
                .split("\n")
                .join(`\n${ " ".repeat(12) }`) }

            with open(${ JSON.stringify(headers) }, 'r') as f:
                srcfiles = [l.strip() for l in f.readlines()]

            ${ srcfiles.map(file => `srcfiles.append(${ JSON.stringify(file) })`).join(`\n${ " ".repeat(12) }`) }

            parser = CppHeaderParser(generate_umat_decls=True, generate_gpumat_decls=True)
            all_decls = []
            for hdr in srcfiles:
                decls = parser.parse(hdr)
                if len(decls) == 0 or hdr.find('/python/') != -1:
                    continue

                all_decls += decls

            # parser.print_decls(all_decls)
            print(json.dumps({"decls": all_decls, "namespaces": sorted(parser.namespaces)}, indent=4))
        `.trim().replace(/^ {12}/mg, "");

        // fs.writeFileSync(sysPath.join(__dirname, "../gen.py"), code);

        child.stdin.write(code);
        child.stdin.end();
    }
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ options.output }`);
});
