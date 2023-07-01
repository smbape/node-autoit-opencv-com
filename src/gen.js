/* eslint-disable no-magic-numbers */

const fs = require("node:fs");
const fsPromises = require("node:fs/promises");
const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const mkdirp = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");

const OpenCV_VERSION = "opencv-4.8.0";
const OpenCV_DLLVERSION = OpenCV_VERSION.slice("opencv-".length).replaceAll(".", "");

const parseArguments = PROJECT_DIR => {
    const options = {
        APP_NAME: "OpenCV",
        LIB_UID: "fc210206-673e-4ec8-82d5-1a6ac561f3de",
        LIBRARY: "cvLib",
        OUTPUT_NAME: `autoit_opencv_com${ OpenCV_DLLVERSION }`,
        OUTPUT_DIRECTORY_DEBUG: `${ PROJECT_DIR }/build_x64/bin/Debug`,
        OUTPUT_DIRECTORY_RELEASE: `${ PROJECT_DIR }/build_x64/bin/Release`,
        namespace: "cv",
        shared_ptr: "cv::Ptr",
        make_shared: "std::make_shared",
        assert: "AUTOIT_ASSERT",
        variantTypeReg: /^cv::(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/,
        implicitNamespaceType: /^(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/,

        // used to lookup classes
        namespaces: new Set([
            "cv",
            "std",
        ]),

        other_namespaces: new Set(),

        // used to reduce class name length
        remove_namespaces: new Set([
            "cv",
            "std",
        ]),
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        includes: [sysPath.join(PROJECT_DIR, "src")],
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true, // the limit of 1000KB is exeeded even without toc
        globals: ["$CV_MAT_DEPTH_MASK", "$CV_MAT_TYPE_MASK"],
        constReplacer: new Map([["std::numeric_limits<uint8_t>::max()", "0xFF"]]),
        onClass: (generator, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn === "cv::cuda::GpuData") {
                // assign operator has been deleted
                // avoid setting a conversion for this class
                coclass.is_class = true;
                coclass.is_struct = false;
            }
        },

        onCoClass: (generator, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn === "cv::Moments") {
                return;
            }

            const parts = fqn.split("::");

            for (let i = 1; i < parts.length; i++) {
                generator.add_func([`${ parts.slice(0, i).join(".") }.`, "", ["/Properties"], [
                    [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "/S", "=this"]],
                ], "", ""]);
            }
        },

        addEnum: (generator, epath, opts) => {
            if (epath.length !== 2 || epath[0] !== "cv") {
                return false;
            }

            const basename = epath[epath.length - 1];
            const coclass = generator.getCoClass("cv::enums", opts);
            coclass.addProperty(["int", basename, "", [`/RExpr=${ epath.join("::") }`, "/S"]]);
            return true;
        },
    };

    for (const opt of ["iface", "hdr", "impl", "idl", "manifest", "rgs", "res", "save"]) {
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

global.OpenCV_VERSION = OpenCV_VERSION;
const {
    CUSTOM_CLASSES,
} = require("./constants");

const {findFile} = require("./FileUtils");
const custom_declarations = require("./custom_declarations");
const AutoItGenerator = require("./AutoItGenerator");

const PROJECT_DIR = sysPath.resolve(__dirname, "../autoit-opencv-com");
const SRC_DIR = sysPath.join(PROJECT_DIR, "src");
const opencv_SOURCE_DIR = findFile(`${ OpenCV_VERSION }-*/opencv/sources`, sysPath.resolve(__dirname, "..")); // sysPath.join(PROJECT_DIR, "..", "opencv", "opencv");

const python_bindings_generator = sysPath.join(PROJECT_DIR, `${ OpenCV_VERSION }-build_x64`, "modules", "python_bindings_generator");
const src2 = sysPath.resolve(opencv_SOURCE_DIR, "modules/python/src2");
const headers = sysPath.join(python_bindings_generator, "headers.txt");
const pyopencv_generated_include = sysPath.join(python_bindings_generator, "pyopencv_generated_include.h");

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

        const child = spawn("python", [sysPath.join(src2, "gen2.py"), python_bindings_generator, headers], {
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
                .filter(content => !content.includes("python_bridge"))
                .concat(srcfiles.map(path => `#include "${ path.slice(SRC_DIR.length + 1).replace("\\", "/") }"`));

            next(err, srcfiles, generated_include);
        });
    },

    (srcfiles, generated_include, next) => {
        srcfiles.push(sysPath.resolve(opencv_SOURCE_DIR, "modules/flann/include/opencv2/flann/defines.h"));

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

            const configuration = JSON.parse(buffer.toString());
            configuration.decls.push(...custom_declarations.load(options));
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
    },
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ options.output }`);
});
