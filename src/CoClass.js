const { v4: uuidv4 } = require("uuid");

const knwon_ids = require("./ids");
const {removeNamespaces} = require("./alias");

const {
    CLASS_PTR,
} = require("./constants");

const { getAlias } = require("./alias");

const {hasOwnProperty: hasProp} = Object.prototype;

const DISID_CONSTANTS = new Map([
    ["DISPID_COLLECT", -8],
    ["DISPID_CONSTRUCTOR", -6],
    ["DISPID_DESTRUCTOR", -7],
    ["DISPID_EVALUATE", -5],
    ["DISPID_NEWENUM", -4],
    ["DISPID_PROPERTYPUT", -3],
    ["DISPID_UNKNOWN", -1],
    ["DISPID_VALUE", 0],
]);

// avoid long names on windows
// the files are no longer readable if the full path
// exceeds 255 characters
const getShortestName = (a, b, { maxFilenameLength }) => {
    return maxFilenameLength > 0 && a.length > maxFilenameLength ? b : a;
};

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

    static getDispId(idl) {
        const start = idl.indexOf("id(") + "id(".length;
        const end = idl.indexOf(")", start + 1);
        const sid = idl.slice(start, end);
        return DISID_CONSTANTS.has(sid) ? DISID_CONSTANTS.get(sid) : Number(sid);
    }

    static getTupleTypes(type) {
        const separators = /[,<>]/g;
        const types = [];

        let lastIndex = 0;
        let match;
        let open = 0;

        while (match = separators.exec(type)) { // eslint-disable-line no-cond-assign
            if (match[0] === "<") {
                open++;
            } else if (match[0] === ">") {
                open--;
            } else if (open === 0 && match[0] === ",") {
                types.push(type.slice(lastIndex, match.index).trim());
                lastIndex = separators.lastIndex;
            }
        }

        if (lastIndex !== type.length) {
            types.push(type.slice(lastIndex).trim());
        }

        return types;
    }

    static restoreOriginalType(type, options = {}) {
        const shared_ptr = removeNamespaces(options.shared_ptr, options);

        const types = [
            "map",
            "optional",
            "pair",
            "tuple",
            "variant",
            "vector",
            "GArray",
            "GOpaque",
            shared_ptr
        ];

        const templates = new RegExp(`\\b(?:${ [
            "std::map",
            "std::optional",
            "std::pair",
            "std::tuple",
            "std::variant",
            "std::vector",
            "cv::GArray",
            "cv::GOpaque",
            "cv::util::variant",
            "util::variant",
            options.shared_ptr
        ].join("|") })<`, "g");

        type = type
            .replace(templates, match => match.slice(match.indexOf("::") + "::".length))
            .replace(/_and_/g, ", ")
            .replace(/_end_/g, ">");

        const replacer = new RegExp(`\\b(?:${ types.join("|") })_`, "g");

        while (replacer.test(type)) {
            replacer.lastIndex = 0;
            type = type.replace(replacer, match => `${ match.slice(0, -1) }<`);
            replacer.lastIndex = 0;
        }

        const tokenizer = new RegExp(`(?:[,>]|\\b(?:${ types.join("|") })<)`, "g");

        let match;
        const path = [];
        let lastIndex = 0;
        let str = "";

        while (match = tokenizer.exec(type)) { // eslint-disable-line no-cond-assign
            str += type.slice(lastIndex, match.index);

            if (match[0] === ",") {
                while (path.length !== 0 && !["map", "pair", "tuple", "variant"].some(tmpl => path[path.length - 1] === tmpl)) {
                    str += ">";
                    path.pop();
                }
            } else if (match[0] === ">") {
                path.pop();
            } else {
                path.push(match[0].slice(0, -1));
            }

            str += match[0];
            lastIndex = tokenizer.lastIndex;
        }

        if (lastIndex !== type.length) {
            str += type.slice(lastIndex);
        }

        const open = str.split("<").length - 1;
        const close = str.split(">").length - 1;

        return str + ">".repeat(open - close);
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
        this.dispid = 0;
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

    toJSON() {
        return {
            name: this.name,
            fqn: this.fqn,
            path: this.path,
            iid: this.iid,
            clsid: this.clsid,
            parents: Array.from(this.parents),
            children: Array.from(this.children),
            properties: Object.fromEntries(this.properties),
            methods: Object.fromEntries(this.methods),
            enums: this.enums,
            is_enum_class: this.is_enum_class,
            is_ptr: this.is_ptr,
        };
    }

    addParent(fqn) {
        if (fqn !== this.fqn && !fqn.endsWith("::class")) {
            this.parents.add(fqn);
        }
    }

    addProperty([argtype, argname, defval /* or "" if none */, list_of_modifiers]) {
        const pos = argname.indexOf("=");
        if (pos !== -1) {
            defval = argname.slice(pos + 1).trim();
            argname = argname.slice(0, pos).trim();
        }

        const descriptor = {
            type: getAlias(argtype),
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

    addMethod(decl, options) {
        decl[1] = getAlias(decl[1]); // return_type

        const [name, , list_of_modifiers, list_of_arguments] = decl;
        const path = name.split(".");
        let fname = path[path.length - 1];

        for (const arg_decl of list_of_arguments) {
            const [argtype] = arg_decl;
            arg_decl[0] = getAlias(argtype);
        }

        if (fname === this.name && !this.isStatic()) {
            fname = options.cname ? options.cname : "create";
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
                id = ++this.dispid;
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

    getIDLFileName(options) {
        return `i${ getShortestName(this.objectName, this.clsid, options) }.idl`;
    }

    getCPPFileName(options) {
        return `${ getShortestName(this.className, this.clsid, options) }.cpp`;
    }

    empty() {
        return this.isStatic() && this.properties.size === 0 && this.methods.size === 0;
    }

    isEnumClass() {
        return this.enums.has(this.fqn);
    }

    isStatic() {
        return !this.is_class && !this.is_struct;
    }
}

module.exports = CoClass;
