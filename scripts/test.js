const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");
const process = require("node:process");

const argv = process.argv.slice(2);
const cwd = argv.length !== 0 ? argv[0] : sysPath.resolve(__dirname, "..");

const AUTOIT_EXE = "C:\\Program Files (x86)\\AutoIt3\\AutoIt3.exe";
const AUTOIT_WRAPPER = "C:\\Program Files (x86)\\AutoIt3\\SciTE\\AutoIt3Wrapper\\AutoIt3Wrapper.au3";
const CS_RUN = sysPath.join(cwd, "samples", "dotnet", "csrun.bat");

const run = (file, env, next) => {
    console.log("\nRunning", file, env);
    const extname = sysPath.extname(file);

    const args = [];

    if (extname === ".au3") {
        args.push(AUTOIT_EXE, [AUTOIT_WRAPPER, "/run", "/prod", "/ErrorStdOut", "/in", file, "/UserParams"]);
    } else if (extname === ".cs") {
        args.push("cmd.exe", ["/c", CS_RUN, file]);
    } else if (extname === ".ps1") {
        args.push("powershell.exe", ["-ExecutionPolicy", "UnRestricted", "-File", file]);
    } else {
        throw new Error(`Unsupported extenstion ${ extname }`);
    }

    args.push({
        stdio: "inherit",
        env: Object.assign({}, process.env, env),
        cwd,
    });

    const child = spawn(...args);

    child.on("error", next);
    child.on("close", next);
};

const INCLUDED_EXT = [".au3", ".cs", ".ps1"];
const EXCLUDED_FILES = ["Table.au3", "Find-Contour-Draw-Demo.au3", "csrun.ps1", "download_model.ps1"];
const INCLUDED_FILES = argv.slice(1);

explore(sysPath.join(cwd, "samples"), (path, stats, next) => {
    const basename = sysPath.basename(path);
    const extname = sysPath.extname(path);
    if (basename.endsWith("test.au3") || !INCLUDED_EXT.includes(extname) || EXCLUDED_FILES.includes(basename) || INCLUDED_FILES.length !== 0 && !INCLUDED_FILES.some(include => basename.startsWith(include))) {
        next();
        return;
    }

    waterfall([
        next => {
            run(path, {
                BUILD_TYPE: "Release",
                OPENCV_BUILD_TYPE: "Release",
            }, next);
        },

        (signal, next) => {
            run(path, {
                BUILD_TYPE: "Debug",
                OPENCV_BUILD_TYPE: "Debug",
            }, next);
        },
    ], next);
}, (path, stats, files, state, next) => {
    const basename = sysPath.basename(path);
    const skip = state === "begin" && (basename[0] === "." || basename === "BackUp");
    next(null, skip);
}, err => {
    if (err) {
        const code = err.flat(Infinity)[0];
        process.exitCode = code;
    }
});
