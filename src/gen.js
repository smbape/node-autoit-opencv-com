/* eslint-disable no-magic-numbers */

const fs = require("fs");
const sysPath = require("path");
const {spawn} = require("child_process");

const mkdirp = require("mkdirp");
const series = require("async/series");

const parseArguments = OUTPUT_DIR => {
    const options = {
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        make: sysPath.join(OUTPUT_DIR, "build.bat"),
        includes: [sysPath.join(OUTPUT_DIR, "src")],
        output: sysPath.join(OUTPUT_DIR, "generated"),
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
    ALIASES,
    CUSTOM_CLASSES,
    CUSTOM_NAMESPACES,
} = require("./constants");

const custom_declarations = require("./custom_declarations");
const AutoItGenerator = require("./AutoItGenerator");

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

const OUTPUT_DIR = sysPath.resolve(__dirname, "../autoit-opencv-com");

const python_generator = sysPath.join(OUTPUT_DIR, "opencv_build_x64", "modules", "python_bindings_generator");
const src2 = sysPath.resolve(__dirname, "..", candidates[0], "opencv", "sources", "modules", "python", "src2");
const headers = sysPath.join(python_generator, "headers.txt");
const pyopencv_generated_include = sysPath.join(python_generator, "pyopencv_generated_include.h");

const hdr_parser = fs.readFileSync(sysPath.join(src2, "hdr_parser.py")).toString();
const hdr_parser_start = hdr_parser.indexOf("class CppHeaderParser");
const hdr_parser_end = hdr_parser.indexOf("if __name__ == '__main__':");

const genpy = `
import io, json, os, re, string, sys

${ hdr_parser.slice(hdr_parser_start, hdr_parser_end).replace(`${ " ".repeat(20) }if self.wrap_mode:`, `${ " ".repeat(20) }if False:`) }

with open(${ JSON.stringify(headers) }, 'r') as f:
    srcfiles = [l.strip() for l in f.readlines()]

srcfiles.append(${ JSON.stringify(sysPath.resolve(__dirname, "..", candidates[0], "opencv", "sources", "modules", "flann", "include", "opencv2", "flann", "defines.h")) })

parser = CppHeaderParser(generate_umat_decls=True, generate_gpumat_decls=True)
all_decls = []
for hdr in srcfiles:
    decls = parser.parse(hdr)
    if len(decls) == 0 or hdr.find('/python/') != -1:
        continue

    all_decls += decls

print(json.dumps({"decls": all_decls, "namespaces": sorted(parser.namespaces)}, indent=4))
`;

const options = parseArguments(OUTPUT_DIR);

series([
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
        const generated_include = fs.readFileSync(pyopencv_generated_include).toString().split("\n").filter(include => include.indexOf("python_bridge") === -1);

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

            const replacer = new RegExp(Array.from(ALIASES.keys()).join("|"), "g");

            const configuration = JSON.parse(buffer.toString().replace(replacer, (match, offset, string) => {
                return offset === 0 || /\W/.test(string[offset - 1]) || string.endsWith("vector_", offset) || string.endsWith("Ptr_", offset) ? ALIASES.get(match) : match;
            }));
            configuration.generated_include = generated_include;

            configuration.decls.push(...custom_declarations);

            for (const [name, modifiers] of CUSTOM_CLASSES) {
                configuration.decls.push([`class ${ name }`, "", modifiers, [], "", ""]);
            }

            configuration.namespaces.push(...CUSTOM_NAMESPACES);

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

        child.stdin.write(genpy);
        child.stdin.end();
    }
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ sysPath.resolve(__dirname, "../autoit-opencv-com/generated") }`);
});
