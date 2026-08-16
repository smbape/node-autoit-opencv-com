const version = process.env.npm_package_version || require("../package.json").version;
exports.version = version;

const versions = (() => {
    const semvers = [];

    for (let i = 0, last_index = 0, pre_realease = false; i <= version.length; i++) {
        if (i === version.length || version[i] === "." || !pre_realease && version[i] === "-") {
            if (pre_realease && semvers.length < 3) {
                for (let j = semvers.length; j < 3; j++) {
                    semvers[j] = "0";
                }
            }

            if (i !== version.length && version[i] === "-") {
                pre_realease = true;
            }

            const part = version.slice(last_index, i);
            if (!/^\d+$/.test(part)) {
                break;
            }

            semvers.push(part);
            last_index = i + 1;
        }
    }

    return semvers;
})();

if (versions.length > 4) {
    versions.length = 4;
}

for (let i = versions.length; i < 4; i++) {
    versions[i] = 0;
}

exports.versions = versions;
