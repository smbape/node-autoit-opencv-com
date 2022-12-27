const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const exec = (file, argv, cb) => {
    console.log(file, argv.map(arg => (arg.includes(" ") ? `"${ arg }"` : arg)).join(" "));
    const child = spawn(file, argv);

    const stdout = [];
    let nout = 0;
    const stderr = [];
    let nerr = 0;

    child.stdout.on("data", chunk => {
        nout += chunk.length;
        stdout.push(chunk);
    });

    child.stderr.on("data", chunk => {
        nerr += chunk.length;
        stderr.push(chunk);
    });

    const next = (err, ...args) => {
        if (err) {
            if (nout !== 0) {
                process.stdout.write(Buffer.concat(stdout, nout));
            }

            if (nerr !== 0) {
                process.stderr.write(Buffer.concat(stderr, nerr));
            }
        }

        cb(err);
    };

    child.on("error", next);
    child.on("close", next);
};

exports.compile = (filename, options, cb) => {
    const dirname = sysPath.dirname(filename);
    const basename = sysPath.basename(filename, ".idl");
    const {includes} = options;

    // https://stackoverflow.com/questions/26302927/midl-changes-the-interface-name
    exec("midl.exe", includes.map(path => `/I${ path }`).concat([
        `/I${ dirname }`,
        "/W1", "/nologo",
        "/char", "signed",
        "/env", "x64",
        "/h", `${ basename }.h`,
        "/iid", `${ basename }_i.c`,
        "/proxy", `${ basename }_p.c`,
        "/tlb", `${ basename }.tlb`,
        "/target", "NT100",
        `/out${ dirname }`,
        filename
    ]), cb);
};
