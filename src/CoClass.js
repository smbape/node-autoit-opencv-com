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
        return `${ this.getObjectName(fqn, true) }_Object`;
    }

    static getObjectName(fqn, upper = false) {
        return fqn
            .replace(/>+$/g, "")
            .replace(/, /g, "_and_")
            .replace(/>/g, "_end_")
            .split("::")
            .map(name => {
                name = name.replace(/\W+/g, "_");
                return upper ? name[0].toUpperCase() + name.slice(1) : name;
            })
            .join("_");
    }

    constructor(fqn) {
        const path = fqn.split("::");

        this.fqn = fqn;
        this.path = path;
        this.name = path[path.length - 1];
        this.className = CoClass.getClassName(this.fqn);
        this.objectName = CoClass.getObjectName(this.fqn);
        this.idl = `I${ this.className }*`;
        this.parents = new Set();
        this.children = new Set();
        this.idlnames = new Map();
        this.properties = new Map();
        this.methods = new Map();
        this.enums = new Set();
        this.is_ptr = CLASS_PTR.has(fqn);
        this.cpp_quotes = [];
        this.interface = "IDispatch";

        if (hasProp.call(knwon_ids, fqn)) {
            // keep order of appearance
            const id = knwon_ids[fqn];
            delete knwon_ids[fqn];
            knwon_ids[fqn] = id;

            this.iid = id.iid;
            this.clsid = id.clsid;
        } else {
            this.iid = uuidv4();
            this.clsid = uuidv4();
            knwon_ids[fqn] = {
                iid: this.iid,
                clsid: this.clsid,
            };
        }

        this.progid = path.map(name => CoClass.getObjectName(name)).join(".");

        this.idr = ++idr;
    }

    addParent(fqn) {
        this.parents.add(fqn);
    }

    addProperty([argtype, argname, defval /* or "" if none */, list_of_modifiers]) {
        const pos = argname.indexOf("=");
        if (pos !== -1) {
            defval = argname.slice(pos + 1).trim();
            argname = argname.slice(0, pos).trim();
        }

        const descriptor = {
            type: argtype,
            value: defval,
            modifiers: list_of_modifiers
        };

        if (this.properties.has(argname)) {
            // poor man object comparison
            if (JSON.stringify(this.properties.get(argname)) === JSON.stringify(descriptor)) {
                return;
            }
            console.log(`duplicate property '${ argname }' of '${ this.fqn }'`);
        }

        this.properties.set(argname, descriptor);
    }

    addEnum(fqn) {
        this.enums.add(fqn);
    }

    addMethod(decl) {
        const [name, , list_of_modifiers, list_of_arguments] = decl;
        const path = name.split(".");

        let fname = path[path.length - 1];

        const is_constructor = fname === this.name;

        if (is_constructor) {
            fname = "create";
            list_of_modifiers.push("/CO", "/S");
            decl[0] = path.slice(0, -1).join("::");
            decl[1] = this.fqn;

            if (list_of_arguments.length === 1) {
                const [argtype, , , arg_modifiers] = list_of_arguments[0];
                if (!arg_modifiers.includes("/RRef") && (argtype === this.fqn || `${ this.namespace }::${ argtype }` === this.fqn)) {
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

        const signature = JSON.stringify(decl);
        if (!this.methods.get(fname).some(idecl => JSON.stringify(idecl) === signature)) {
            this.methods.get(fname).push(decl);
        }
    }

    addIDLName(idlname, fname, id) {
        const lidlname = idlname.toLowerCase();

        if (!this.idlnames.has(lidlname)) {
            if (id == null) {
                id = this.idlnames.size + 1;
            }

            this.idlnames.set(lidlname, [idlname, id, fname]);
            return id;
        }

        const [prev_idlname, prev_id, ...fnames] = this.idlnames.get(lidlname);

        if (prev_idlname !== idlname) {
            throw new Error(`case mismatch idl name for ${ this.fqn } : ${ idlname }( ${ fname } ) != ${ prev_idlname }( ${ fnames.join(", ") } )`);
        }

        if (!fnames.includes(fname)) {
            const getter = `get_${ idlname }`;
            const setter = `put_${ idlname }`;
            if (fname !== getter && fname !== setter) {
                throw new Error(`duplicated idl name ${ idlname } = ${ this.fqn }::${ fname }, ${ fnames.join(", ") }`);
            }
            this.idlnames.get(lidlname).push(fname);
        }

        if (id != null && id !== prev_id) {
            throw new Error(`multiple id for the same idlname [${ id }] ${ idlname } = ${ this.fqn }::${ fname }, ${ fnames.join(", ") }`);
        }

        return prev_id;
    }

    getIDLNameId(idlname) {
        idlname = idlname.toLowerCase();
        if (!this.idlnames.has(idlname)) {
            throw new Error(`unknown idl idlname ${ this.fqn }::${ idlname }`);
        }
        const [, id] = this.idlnames.get(idlname);
        return id;
    }

    getIDLType() {
        return this.idl;
    }

    getClassName() {
        return this.className;
    }

    getObjectName() {
        return this.objectName;
    }
}

module.exports = CoClass;
