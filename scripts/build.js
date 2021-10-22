const { spawn } = require("child_process");
const sysPath = require("path");
const series = require("async/series");

const version = process.env.npm_package_version || require("../package.json").version;
const sources = sysPath.resolve(__dirname, "..");

series([
    next => {
        const child = spawn("7z", ["a", sysPath.join(sources, `autoit-opencv-4.5.4-com-v${ version }.7z`), "udf"], {
            cwd: sysPath.join(sources, "autoit-opencv-com"),
            stdio: "inherit"
        });

        child.on("close", next);
        child.on("error", next);
    },

    next => {
        const child = spawn("7z", ["a", sysPath.join(sources, `autoit-opencv-4.5.4-com-v${ version }.7z`), "autoit_opencv_com454.*"], {
            cwd: sysPath.join(sources, "autoit-opencv-com", "build_x64", "Release"),
            stdio: "inherit"
        });

        child.on("close", next);
        child.on("error", next);
    },

    next => {
        const child = spawn("7z", ["a", sysPath.join(sources, `autoit-opencv-4.5.4-com-v${ version }.7z`), "autoit_opencv_com454d.*"], {
            cwd: sysPath.join(sources, "autoit-opencv-com", "build_x64", "Debug"),
            stdio: "inherit"
        });

        child.on("close", next);
        child.on("error", next);
    },

    next => {
        const child = spawn("7z", ["a", sysPath.join(sources, `autoit-opencv-4.5.4-com-v${ version }.7z`), "cvLib.tlb"], {
            cwd: sysPath.join(sources, "autoit-opencv-com", "generated"),
            stdio: "inherit"
        });

        child.on("close", next);
        child.on("error", next);
    }
]);
