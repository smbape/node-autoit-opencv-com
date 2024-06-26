const process = require("node:process");
const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const eachOfLimit = require("async/eachOfLimit");
const waterfall = require("async/waterfall");
const { explore } = require("fs-explorer");

const AUTOIT_EXE = "C:\\Program Files (x86)\\AutoIt3\\AutoIt3.exe";
const AUTOIT_WRAPPER = "C:\\Program Files (x86)\\AutoIt3\\SciTE\\AutoIt3Wrapper\\AutoIt3Wrapper.au3";
const AUTOIT_WRAPPER_ARGV = ["/run", "/prod", "/ErrorStdOut", "/in"];
const CS_RUN = sysPath.join("samples", "dotnet", "csrun.bat");

const unixCmd = argv => {
    return argv.map(arg => {
        if (arg.includes(" ") || arg.includes("\\")) {
            return `'${ arg }'`;
        }

        if (arg[0] === "/" && arg[1] !== "/") {
            return `/${ arg }`;
        }

        return arg;
    }).join(" ");
};

const run = (file, env, options, next) => {
    const { BUILD_TYPE, OPENCV_BUILD_TYPE } = options.env;
    if (BUILD_TYPE && BUILD_TYPE !== env.BUILD_TYPE || OPENCV_BUILD_TYPE && OPENCV_BUILD_TYPE !== env.OPENCV_BUILD_TYPE) {
        next(null, 0);
        return;
    }

    const keys = Object.keys(env);
    env = Object.assign({}, options.env, env);

    const extname = sysPath.extname(file);

    const args = [];

    if (extname === ".au3") {
        if (options.bash) {
            args.push("autoit", [file, "/UserParams"]);
        } else {
            args.push(AUTOIT_EXE, [AUTOIT_WRAPPER, ...AUTOIT_WRAPPER_ARGV, file, "/UserParams"]);
        }
    } else if (extname === ".cs") {
        args.push("cmd.exe", ["/c", CS_RUN, file]);
    } else if (extname === ".ps1") {
        args.push("powershell.exe", ["-ExecutionPolicy", "UnRestricted", "-File", file]);
    } else {
        throw new Error(`Unsupported extenstion ${ extname }`);
    }

    const cmd = [keys.map(key => `${ key }=${ env[key] }`).join(" "), unixCmd(args.flat())].join(" ");

    if (options.bash) {
        console.log(cmd, "||", "exit $?");
        next(null, 0);
        return;
    }

    console.log(cmd);

    args.push({
        stdio: options.stdio,
        env,
        cwd: options.cwd,
    });

    const child = spawn(...args);
    child.on("error", err => {
        if (next !== null) {
            next(err);
            next = null;
        }
    });

    child.on("close", (code, signal) => {
        if (next !== null) {
            next(code, signal);
            next = null;
        }
    });

    if (typeof options.run === "function") {
        options.run(child);
    }
};

const unixPath = path => {
    return `/${ path.replace(":", "").replaceAll("\\", "/") }`;
};

const bash_init = `#!/usr/bin/env bash

set -o pipefail

function autoit() {
    '${ unixPath(AUTOIT_EXE) }' '${ unixPath(AUTOIT_WRAPPER) }' ${ unixCmd(AUTOIT_WRAPPER_ARGV) } "$@"
}
`;

const main = (options, next) => {
    options = Object.assign({
        cwd: sysPath.resolve(__dirname, ".."),
        includes: [],
        includes_ext: [".au3", ".cs", ".ps1"],
        excludes: [],
        argv: [],
        stdio: "inherit",
    }, options);

    const { cwd, includes, includes_ext, excludes } = options;

    excludes.push(...["Table.au3", "Find-Contour-Draw-Demo.au3", "csrun.ps1", "download_model.ps1"]);

    if (options.bash) {
        console.log([
            bash_init,
            `cd ${ cwd.includes(" ") ? `'${ unixPath(cwd) }'` : unixPath(cwd) }`,
            "",
        ].join("\n"));
    }

    explore(sysPath.join(cwd, "samples"), (path, stats, next) => {
        const file = sysPath.relative(cwd, path);
        const basename = sysPath.basename(file);
        const extname = sysPath.extname(file);

        if (
            !includes_ext.includes(extname) ||
            excludes.some(exclude => basename.startsWith(exclude)) ||
            includes.length !== 0 && !includes.some(include => basename.startsWith(include))
        ) {
            next();
            return;
        }

        waterfall([
            next => {
                run(file, {
                    BUILD_TYPE: "Release",
                    OPENCV_BUILD_TYPE: "Release",
                }, options, next);
            },

            (signal, next) => {
                run(file, {
                    BUILD_TYPE: "Debug",
                    OPENCV_BUILD_TYPE: "Debug",
                }, options, next);
            },
        ], (code, signal) => {
            next(code);
        });
    }, (path, stats, files, state, next) => {
        const basename = sysPath.basename(path);
        const skip = state === "begin" && (basename[0] === "." || basename === "BackUp");
        next(null, skip);
    }, next);
};

exports.main = main;

if (typeof require !== "undefined" && require.main === module) {
    const options = {
        includes: [],
        excludes: [],
        argv: [],
        env: Object.assign({}, process.env),
        "--": 0,
    };

    for (const arg of process.argv.slice(2)) {
        if (arg === "--") {
            options[arg]++;
        } else if (arg[0] === "!") {
            options.excludes.push(arg.slice(1));
        } else if (options["--"] === 1 && arg[0] !== "-") {
            options.includes.push(arg);
        } else if (options["--"] > 1 || options["--"] === 1 && arg[0] === "-") {
            options.argv.push(arg);
        } else if (["--Debug", "--Release"].includes(arg)) {
            options.env.BUILD_TYPE = arg.slice(2);
        } else if (arg === "--bash") {
            options[arg.slice(2)] = true;
        } else {
            options.cwd = sysPath.resolve(arg);
            options["--"] = 1;
        }
    }

    main(options, err => {
        if (err) {
            if (!Array.isArray(err)) {
                throw err;
            }

            const code = err.flat(Infinity)[0];
            if (typeof code !== "number") {
                throw code;
            }

            process.exitCode = code;
        }
    });
}
