const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const eachOfLimit = require("async/eachOfLimit");
const { version } = require("../src/version");

const OpenCV_VERSION = "opencv-4.14.0";
const OpenCV_DLLVERSION = OpenCV_VERSION.slice("opencv-".length).replaceAll(".", "");

const sources = sysPath.resolve(__dirname, "..");
const archive = sysPath.join(sources, `autoit-opencv-com-${ version }.7z`);
const project = sysPath.join(sources, "autoit-opencv-com");

const files = [
    [project, "install.bat"],
    [project, "udf/*.au3", "udf/*.md"],
    [project, "dotnet/*.cs"],
    [sysPath.join(sources, "samples"), "dotnet/*.psm1"],
    [sysPath.join(project, "generated"), "*.tlb", "dotnet/*.dll"],
    [sysPath.join(project, "build_x64", "bin", "Debug"), `autoit*${ OpenCV_DLLVERSION }*`, "dotnet/*", "opencv_*"],
    [sysPath.join(project, "build_x64", "bin", "Release"), `autoit*${ OpenCV_DLLVERSION }*`, "dotnet/*", "opencv_*"],
    [sysPath.join(sources, "autoit-addon", "build_x64", "bin", "Debug"), `autoit*${ OpenCV_DLLVERSION }*`],
    [sysPath.join(sources, "autoit-addon", "build_x64", "bin", "Release"), `autoit*${ OpenCV_DLLVERSION }*`],
];

eachOfLimit(files, 1, ([cwd, ...args], i, next) => {
    const child = spawn("7z", ["a", archive, ...args], {
        cwd,
        stdio: "inherit"
    });

    child.on("close", () => {
        if (next !== null) {
            next();
        }
    });
    child.on("error", err => {
        if (next !== null) {
            next(err);
            next = null;
        } else {
            console.error(err);
        }
    });
});
