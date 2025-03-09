/* eslint-disable no-magic-numbers */

const fs = require("node:fs");
const fsPromises = require("node:fs/promises");
const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const mkdirp = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");

const OpenCV_VERSION = "opencv-4.11.0";
const OpenCV_DLLVERSION = OpenCV_VERSION.slice("opencv-".length).replaceAll(".", "");

const getOptions = PROJECT_DIR => {
    const options = {
        APP_NAME: "OpenCV",
        LIB_UID: "fc210206-673e-4ec8-82d5-1a6ac561f3de",
        LIBRARY: "cvLib",
        OUTPUT_NAME: `autoit_opencv_com${ OpenCV_DLLVERSION }`,
        OUTPUT_DIRECTORY_DEBUG: `${ PROJECT_DIR }/build_x64/bin/Debug`,
        OUTPUT_DIRECTORY_RELEASE: `${ PROJECT_DIR }/build_x64/bin/Release`,
        namespace: "cv",
        shared_ptr: "cv::Ptr",
        make_shared: "cv::makePtr",
        exception: "cv::Exception",
        assert: "AUTOIT_ASSERT",
        Any: "VARIANT*",
        variantTypeReg: new RegExp(`^cv::(?:(?:Point|Rect|Scalar|Size|Vec)(?:\\d[bdfisw])?|${ [
            "gapi::wip::draw::Prim",
            "GMetaArg",
            "GArg",
            "detail::OpaqueRef",
            "detail::VectorRef",
            "GRunArg",
            "GOptRunArg",
        ].join("|") })$`),
        implicitNamespaceType: /^(?:Point|Rect|Scalar|Size|Vec)(?:\d[bdfisw])?$/,

        self: "*__self->get()",
        self_get: (name = null) => {
            return name ? `__self->get()->${ name }` : "__self->get()";
        },

        // used to lookup classes
        namespaces: new Set([]),

        other_namespaces: new Set(),

        // used to reduce class name length
        remove_namespaces: new Set([
            "cv",
            "std",
        ]),

        build: new Set(),
        notest: new Set(),
        skip: new Set(),

        // For MIDL compile
        includes: [sysPath.join(PROJECT_DIR, "src")],
        excludes: new Set(["cv::dnn::DictValue"]),
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true, // the limit of 1000KB is exeeded even without toc
        globals: ["$CV_MAT_DEPTH_MASK", "$CV_MAT_TYPE_MASK"],
        constReplacer: new Map([["std::numeric_limits<uint8_t>::max()", "0xFF"]]),
        onClass: (processor, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn === "cv::cuda::GpuData") {
                // assign operator has been deleted
                // avoid setting a conversion for this class
                coclass.is_class = true;
                coclass.is_struct = false;
            }
        },

        onCoClass: (processor, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn === "cv::Moments") {
                return;
            }

            const parts = fqn.split("::");

            for (let i = 1; i < parts.length; i++) {
                processor.add_func([`${ parts.slice(0, i).join(".") }.`, "", ["/Properties"], [
                    [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "=this", "/S"]],
                ], "", ""]);
            }
        },

        addEnum: (processor, epath, opts) => {
            if (epath.length !== 2 || epath[0] !== "cv") {
                return false;
            }

            const basename = epath[epath.length - 1];
            const coclass = processor.getCoClass("cv::enums", opts);
            coclass.addProperty(["int", basename, "", [`/RExpr=${ epath.join("::") }`, "/S"]]);
            return true;
        },
    };

    const argv = process.argv.slice(2);
    const flags_true = ["iface", "hdr", "impl", "idl", "manifest", "rgs", "res", "save"];
    const flags_false = ["test"];

    for (const opt of flags_true) {
        options[opt] = !argv.includes(`--no-${ opt }`);
    }

    for (const opt of flags_false) {
        options[opt] = argv.includes(`--${ opt }`);
    }

    for (let i = 0; i < argv.length; i++) {
        const opt = argv[i];

        if (opt.startsWith("--no-") && flags_true.includes(opt.slice("--no-".length))) {
            continue;
        }

        if (opt.startsWith("--") && flags_false.includes(opt.slice("--".length))) {
            continue;
        }

        if (opt.startsWith("--no-test=")) {
            for (const fqn of opt.slice("--no-test=".length).split(/[ ,]/)) {
                options.notest.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("--build=")) {
            for (const fqn of opt.slice("--build=".length).split(/[ ,]/)) {
                options.build.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("--skip=")) {
            for (const fqn of opt.slice("--skip=".length).split(/[ ,]/)) {
                options.skip.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("-D")) {
            const [key, value] = opt.slice("-D".length).split("=");
            options[key] = typeof value === "undefined" ? true : value;
            continue;
        }

        throw new Error(`Unknown option ${ opt }`);
    }

    return options;
};

global.OpenCV_VERSION = OpenCV_VERSION;
const {
    CUSTOM_CLASSES,
} = require("./constants");

const {findFile} = require("./FileUtils");
const custom_declarations = require("./custom_declarations");
const DeclProcessor = require("./DeclProcessor");
const COMGenerator = require("./COMGenerator");

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

const options = getOptions(PROJECT_DIR);
options.proto = COMGenerator.proto;

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
        // exported class that are not included by python generated include file
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

            const processor = new DeclProcessor(options);
            processor.process(configuration, options);

            next(null, processor, configuration);
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

    (processor, configuration, next) => {
        const generator = new COMGenerator();
        generator.generate(processor, configuration, options, next);
    },
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ options.output }`);
});
