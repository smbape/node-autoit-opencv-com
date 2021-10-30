const { v4: uuidv4 } = require("uuid");

const knwon_ids = require("./ids");

const {
    CLASS_PTR,
} = require("./constants");

const hasProp = Object.prototype.hasOwnProperty;

// Visual studio gave me 106 as the first resource id
// I just reused it since I don't know the impact of changing
// those resource ids
let idr = 105;

class CoClass {
    static getClassName(fqn) {
        return `${ fqn.split("::").map(name => name[0].toUpperCase() + name.slice(1)).join("_") }_Object`;
    }

    constructor(fqn) {
        const path = fqn.split("::");

        this.fqn = fqn;
        this.path = path;
        this.name = path[path.length - 1];
        this.className = CoClass.getClassName(this.fqn);
        this.idl = `I${ this.className }*`;
        this.parents = new Set();
        this.properties = new Map();
        this.methods = new Map();
        this.enums = new Set();
        this.is_ptr = CLASS_PTR.has(fqn);

        if (hasProp.call(knwon_ids, fqn)) {
            this.iid = knwon_ids[fqn].iid;
            this.clsid = knwon_ids[fqn].clsid;
        } else {
            this.iid = uuidv4();
            this.clsid = uuidv4();
            knwon_ids[fqn] = {
                iid: this.iid,
                clsid: this.clsid,
            };
        }

        this.progid = path.join(".");

        this.idr = ++idr;
    }

    addParent(fqn) {
        this.parents.add(fqn);
    }

    addProperty([argtype, argname, defval /* or "" if none */, list_of_modifiers]) {
        if (this.properties.has(argname)) {
            console.log(`duplicate property '${ argname }' of '${ this.fqn }'`);
        }

        this.properties.set(argname, {
            type: argtype,
            value: defval,
            modifiers: list_of_modifiers
        });
    }

    addEnum(fqn) {
        this.enums.add(fqn);
    }

    addMethod(decl) {
        const [name, return_value_type, list_of_modifiers, list_of_arguments] = decl;
        const path = name.split(".");

        let fname = path[path.length - 1];

        const is_constructor = return_value_type === "" && fname === this.name;

        if (is_constructor) {
            fname = "create";
            list_of_modifiers.push("/CO", "/S");
            decl[0] = path.slice(0, -1).join("::");
            decl[1] = this.fqn;

            if (list_of_arguments.length === 1) {
                const [argtype] = list_of_arguments[0];
                if (argtype === this.fqn || `${ this.namespace }::${ argtype }` === this.fqn || `cv::${ argtype }` === this.fqn) {
                    this.has_copy_constructor = true;
                }
            }

            if (list_of_arguments.length === 0 || !list_of_arguments.some(([argtype, argname, defval]) => defval === "")) {
                this.has_default_constructor = true;
            }
        }

        for (const modifier of list_of_modifiers) {
            if (modifier[0] === "=") {
                fname = modifier.slice(1);
            }
        }

        if (!this.methods.has(fname)) {
            this.methods.set(fname, []);
        }

        this.methods.get(fname).push(decl);
    }

    getIDLType() {
        return this.idl;
    }

    getClassName() {
        return this.className;
    }

    getFilename() {
        return this.fqn.replace(/::/g, "_");
    }
}

module.exports = CoClass;
