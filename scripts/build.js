const { spawn } = require("child_process");
const sysPath = require("path");
const eachOfLimit = require("async/eachOfLimit");

const version = process.env.npm_package_version || require("../package.json").version;
const sources = sysPath.resolve(__dirname, "..");
const archive = sysPath.join(sources, `autoit-opencv-4.6.0-com-v${ version }.7z`);
const project = sysPath.join(sources, "autoit-opencv-com");

const files = [
    [project, "install.bat"],
    [project, "udf/*.au3"],
    [project, "udf/*.md"],
    [sysPath.join(project, "generated"), "cvLib.tlb"],
    [sysPath.join(project, "build_x64", "Debug"), "autoit*"],
    [sysPath.join(project, "build_x64", "RelWithDebInfo"), "autoit*"],
    [sysPath.join(sources, "autoit-addon", "build_x64", "Debug"), "autoit*"],
    [sysPath.join(sources, "autoit-addon", "build_x64", "RelWithDebInfo"), "autoit*"],
];

eachOfLimit(files, 1, ([cwd, file], i, next) => {
    const child = spawn("7z", ["a", archive, file], {
        cwd,
        stdio: "inherit"
    });

    child.on("close", next);
    child.on("error", next);
});
