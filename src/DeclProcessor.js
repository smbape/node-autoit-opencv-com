/* eslint-disable no-magic-numbers */
const { getAlias } = require("./alias");

const {
    CPP_TYPES,
    IGNORED_CLASSES,
    TEMPLATED_TYPES,
} = require("./constants");

const CoClass = require("./CoClass");
const {orderDependencies} = require("./dependencies");

const countInstances = (str, searchString) => {
   return str.split(searchString).length - 1;
};

class DeclProcessor {
    constructor({ proto } = {}) {
        if (proto) {
            Object.assign(this, proto);
        }

        this.classes = new Map();
        this.enums = new Map();
        this.typedefs = new Map();

        // for inheritance tree computation
        this.bases = new Map();
        this.derives = new Map();

        this.dependents = new Map();
        this.dependencies = new Map();

        this.docs = [];
    }

    toJSON() {
        return {
            classes: Object.fromEntries(this.classes),
        };
    }

    process(config, options = {}) {
        const {decls, namespaces} = config;

        this.namespaces = new Set();

        this.namespace = options.namespace;

        if (options.typedefs) {
            for (const [fqn, cpptype] of options.typedefs) {
                this.typedefs.set(fqn, cpptype);
            }
        }

        for (const namespace of namespaces) {
            // If a child is a namespace, then, it's ascendants are also namespaces
            const parts = namespace.replaceAll(".", "::").split("::");
            for (let i = 0; i < parts.length; i++) {
                this.namespaces.add(parts.slice(0, parts.length - i).join("::"));
            }
        }

        for (const decl of decls) {
            const [name] = decl;

            if (name.startsWith("class ") || name.startsWith("struct ")) {
                this.add_class(decl, options);
            } else if (name.startsWith("enum ")) {
                this.add_enum(decl, options);
            } else {
                this.add_func(decl, options);
            }
        }

        this.preprocess(config, options);

        for (const fqn of IGNORED_CLASSES) {
            if (this.classes.has(fqn)) {
                this.removeClass(fqn);
            }
        }

        for (const fqn of this.classes.keys()) {
            const coclass = this.classes.get(fqn);

            // set assign operator for types that are assigned as default params or return type
            for (const [, overrides] of coclass.methods.entries()) {
                for (const decl of overrides) {
                    const [, return_value_type, func_modifiers, list_of_arguments] = decl;
                    if (return_value_type !== "" && !func_modifiers.includes("/CO")) {
                        this.setAssignOperator(return_value_type, coclass, options);
                    }

                    for (const [argtype, , defval] of list_of_arguments) {
                        if (defval !== "") {
                            this.setAssignOperator(argtype, coclass, options);
                        }
                    }
                }
            }

            // populate enums =this properties
            for (const [, property] of coclass.properties.entries()) {
                const {type, modifiers} = property;
                if (!modifiers.includes("/R") || !modifiers.includes("=this")) {
                    continue;
                }

                const enum_type = this.getEnumType(type, coclass, options);
                if (!enum_type || this.classes.has(enum_type)) {
                    continue;
                }

                const enum_class = this.getCoClass(enum_type, options);
                const [,,, values] = this.enums.get(enum_type);
                for (const [value] of values) {
                    enum_class.addProperty([
                        enum_type,
                        value.slice(value.lastIndexOf(".") + ".".length),
                        "",
                        [`/RExpr=${ value.slice("const ".length).replaceAll(".", "::") }`]
                    ]);
                }
            }

            this.addParentDefinition(coclass, options);
            this.addDependencies(coclass, options);
        }

        // remove empty classes
        for (const fqn of this.classes.keys()) {
            const coclass = this.classes.get(fqn);
            if (coclass.empty()) {
                this.removeClass(fqn);
            }
        }

        const ordered = options.hasInheritanceSupport ? (() => {
            const _dependencies = new Map(this.dependencies);
            const _dependents = new Map(this.dependents);

            for (const fqn of this.classes.keys()) {
                if (!_dependencies.has(fqn)) {
                    _dependencies.set(fqn, new Set());
                }
            }

            return orderDependencies(_dependencies, _dependents);
        })().reverse() : this.classes.keys();

        for (const fqn of ordered) {
            const coclass = this.classes.get(fqn);
            const cpptype = this.getCppType(fqn, coclass, options);
            const displayName = this.getTypeDisplayName(fqn, cpptype);

            // add __str__ method
            if (!coclass.isStatic() && options.meta_methods && options.meta_methods.has("__str__")) {
                const is_meta_method = options.is_meta_methods && options.is_meta_methods.has("__str__") ? options.is_meta_methods.get("__str__") : ([fname]) => fname === "__str__";
                const methods = options.hasInheritanceSupport ? this.getAllMethods(fqn) : coclass.methods;
                if (!Array.from(methods.entries()).some(is_meta_method)) {
                    const __str__ = options.meta_methods.get("__str__");
                    const name = options.meta_methods_name && options.meta_methods_name.has("__str__") ? options.meta_methods_name.get("__str__") : "__str__";
                    coclass.addMethod([`${ fqn }.${ name }`, "std::string", [`/Call=${ __str__ }`, `/Expr=${ options.self }, ${ JSON.stringify(displayName) }`], [], "", ""], options);
                }
            }

            // add __eq__ method
            if (!coclass.isStatic() && options.meta_methods && options.meta_methods.has("__eq__")) {
                const is_meta_method = options.is_meta_methods && options.is_meta_methods.has("__eq__") ? options.is_meta_methods.get("__eq__") : ([fname]) => fname === "__eq__";
                const methods = options.hasInheritanceSupport ? this.getAllMethods(fqn) : coclass.methods;
                if (!Array.from(methods.entries()).some(is_meta_method)) {
                    const __eq__ = options.meta_methods.get("__eq__");
                    const name = options.meta_methods_name && options.meta_methods_name.has("__eq__") ? options.meta_methods_name.get("__eq__") : "__eq__";
                    coclass.addMethod([`${ fqn }.${ name }`, "bool", [`/Call=${ __eq__ }`, `/Expr=${ options.self }, $0`], [
                        [cpptype, "other", "", ["/Ref", "/C"]],
                    ], "", ""], options);
                    coclass.addMethod([`${ fqn }.${ name }`, "bool", ["/Output=false"], [
                        [options.Any, "other", "", []],
                    ], "", ""], options);
                }
            }

            // add __type__ method
            if (!coclass.isStatic() && options.meta_methods && options.meta_methods.has("__type__")) {
                const is_meta_method = options.is_meta_methods && options.is_meta_methods.has("__type__") ? options.is_meta_methods.get("__type__") : ([fname]) => fname === "__type__";
                const methods = options.hasInheritanceSupport ? this.getAllMethods(fqn) : coclass.methods;
                if (!Array.from(methods.entries()).some(is_meta_method)) {
                    const __type__ = options.meta_methods.get("__type__");
                    const modifiers = typeof __type__ === "string" ? [`/Call=${ __type__ }`] : [`/Output=${ JSON.stringify(displayName) }`];
                    const name = options.meta_methods_name && options.meta_methods_name.has("__type__") ? options.meta_methods_name.get("__type__") : "__type__";
                    coclass.addMethod([`${ fqn }.${ name }`, "std::string", ["/S", ...modifiers], [], "", ""], options);
                }
            }

            // add reflection methods and properties
            if (!options.hasIsInstanceSupport && !coclass.isStatic()) {
                coclass.addMethod([`${ fqn }.IsInstance`, "bool", ["/S", "/Output=true"], [
                    [cpptype, "obj", "", ["/Ref", "/C"]],
                ], "", ""], options);
                coclass.addMethod([`${ fqn }.IsInstance`, "bool", ["/S", "/Output=false"], [
                    [options.Any, "obj", "", []],
                ], "", ""], options);
            }
        }
    }

    preprocess(config, options) {
        // Nothing to do
    }

    removeClass(fqn) {
        const stack = [fqn];

        while (stack.length !== 0) {
            fqn = stack.shift();
            this.classes.delete(fqn);

            if (!this.dependents.has(fqn)) {
                continue;
            }

            for (const dependent of this.dependents.get(fqn)) {
                this.dependencies.get(dependent).delete(fqn);

                const coclass = this.classes.get(dependent);
                const {properties} = coclass;
                for (const [name, {type}] of properties.entries()) {
                    if (type === fqn) {
                        properties.delete(name);
                    }
                }

                if (coclass.empty()) {
                    stack.push(dependent);
                }
            }
        }
    }

    add_class(decl, options = {}) {
        const [name, base, list_of_modifiers, properties] = decl;
        const path = getAlias(name.slice(name.indexOf(" ") + 1)).split(".");
        const fqn = path.join("::");

        if (options.excludes && options.excludes.has(fqn)) {
            return;
        }

        const coclass = this.getCoClass(fqn, options);

        coclass.is_class = name.startsWith("class ");
        coclass.is_struct = name.startsWith("struct ");
        coclass.is_simple = list_of_modifiers.includes("/Simple");
        coclass.is_map = list_of_modifiers.includes("/Map");
        coclass.is_external = list_of_modifiers.includes("/External");
        coclass.is_cexternal = list_of_modifiers.includes("/CExternal");
        coclass.is_rexternal = list_of_modifiers.includes("/RExternal");
        if (list_of_modifiers.includes("/Ptr")) {
            coclass.is_ptr = true;
        }

        if ((coclass.is_map || coclass.is_struct && coclass.is_simple || list_of_modifiers.includes("/DC")) && !coclass.has_default_constructor) {
            coclass.has_default_constructor = 0;
        }

        coclass.noidl = list_of_modifiers.includes("/noidl");

        for (const modifier of list_of_modifiers) {
            if (modifier.startsWith("=")) {
                coclass.name = modifier.slice("=".length);
                coclass.progid = path.map((id, i) => CoClass.getObjectName(i === path.length - 1 ? coclass.name : id)).join(".");
            } else if (modifier.startsWith("/idl=")) {
                coclass.idl = modifier.slice("/idl=".length);
            } else if (modifier.startsWith("/cpp_quote=")) {
                coclass.cpp_quotes.push(modifier.slice("/cpp_quote=".length));
            } else if (modifier.startsWith("/interface=")) {
                coclass.interface = modifier.slice("/interface=".length);
            }
        }

        for (const property of properties) {
            coclass.addProperty(property);
        }

        this.bases.set(fqn, new Set());

        const parents = base ? base.slice(": ".length).split(", ") : [];

        for (let parent of parents) {
            parent = getAlias(parent);
            if (parent === fqn || parent === "") {
                continue;
            }

            coclass.addParent(parent);

            this.bases.get(fqn).add(parent);

            if (!this.derives.has(parent)) {
                this.derives.set(parent, new Set());
            }

            this.derives.get(parent).add(fqn);
        }

        if (typeof options.onClass === "function") {
            options.onClass(this, coclass, options);
        }
    }

    add_enum(decl, options = {}) {
        const [name, , , enums] = decl;

        let is_enum_class = false;
        let start = 0;

        while (true) { // eslint-disable-line no-constant-condition
            if (name.startsWith("enum ", start)) {
                start += "enum ".length;
                continue;
            }

            if (name.startsWith("struct ", start)) {
                start += "struct ".length;
                continue;
            }

            if (name.startsWith("class ", start)) {
                start += "class ".length;
                is_enum_class = true;
                continue;
            }

            break;
        }

        const path = name.slice(start).split(".");
        const fqn = path.join("::");

        if (options.excludes && options.excludes.has(fqn)) {
            return;
        }

        if (this.enums.has(fqn)) {
            this.enums.get(fqn)[3].push(...enums);
        } else {
            this.enums.set(fqn, decl);
        }

        const enum_class = is_enum_class ? fqn : path.slice(0, -1).join("::");
        const enum_coclass = this.getCoClass(enum_class, options);
        enum_coclass.addEnum(fqn);
        enum_coclass.is_enum_class = is_enum_class;

        for (const edecl of enums) {
            const [ename] = edecl;
            if (!ename.startsWith("const ")) {
                throw new Error(`enum ${ ename } is not supported`);
            }

            const epath = ename.slice("const ".length).split(".");

            // known invalid enum
            if (epath.join("::") === "cv::detail::ArgKind::OPAQUE") {
                continue;
            }

            if (options.noEnumExport) {
                continue;
            }

            // Make enumerations available via a COM property.
            // Because com properties and methods are case insensitive,
            // an enum name cannot be the same as a property or a method name.
            // To get around that limitation, an underscore is added at the end of the enum name.
            // More over, office vba does not allow properties/methods names to start with an underscore.
            // Therefore, putting the underscore at the end is also to get around that office vba limitation.
            // For exemple, cv::FileNode as a method 'real' and an enum 'REAL'
            // The enum will be named REAL_
            //
            // Sources:
            // https://docs.microsoft.com/en-us/windows/win32/com/com-technical-overview
            // https://docs.microsoft.com/it-ch/office/vba/language/reference/user-interface-help/bad-interface-for-implements-method-has-underscore-in-name

            // There is no name conflict with enum class properties
            const basename = epath[epath.length - 1];
            const propname = is_enum_class || options.isCaseSensitive ? basename : `${ basename }_`;
            let added = false;

            if (options.addEnum) {
                added = options.addEnum(this, epath, options);
            }

            if (!added) {
                const coclass = this.getCoClass(epath.slice(0, -1).join("::"), options);
                coclass.addProperty(["int", propname, `static_cast<int>(${ epath.join("::") })`, ["/R", "/S", "/Enum", `=${ basename }`]]);
            }
        }
    }

    add_custom_type(fqn, parent, options = {}) {
        const objectName = CoClass.getObjectName(fqn);

        if (this.classes.has(objectName)) {
            return this.classes.get(objectName);
        }

        const coclass = this.getCoClass(objectName, options);
        coclass.is_simple = true;
        coclass.is_class = true;

        const cpptype = this.getCppType(fqn, parent, options);
        this.typedefs.set(coclass.fqn, cpptype);

        return coclass;
    }

    add_func(decl, options = {}) {
        decl[0] = getAlias(decl[0]); // name

        const [name, , list_of_modifiers, properties] = decl;
        const path = getAlias(name).split(".");
        const fqn = path.slice(0, -1).join("::");

        if (options.excludes && options.excludes.has(fqn)) {
            return;
        }

        const coclass = this.getCoClass(fqn, options);

        if (list_of_modifiers.includes("/Properties")) {
            for (const property of properties) {
                coclass.addProperty(property);
            }
        } else {
            coclass.addMethod(decl, options);
        }
    }

    getCoClass(fqn, options = {}) {
        if (this.classes.has(fqn)) {
            return this.classes.get(fqn);
        }

        const path = fqn.split("::");
        let coclass = null;

        for (let i = 0; i < path.length; i++) {
            const prefix = path.slice(0, i + 1).join("::");

            if (this.classes.has(prefix)) {
                coclass = this.classes.get(prefix);
                continue;
            }

            coclass = new CoClass(prefix);
            this.classes.set(prefix, coclass);

            if (typeof options.progid === "function") {
                const progid = options.progid(coclass.progid);
                if (progid) {
                    coclass.progid = progid;
                }
            }

            for (let j = i; j >= 0; j--) {
                const namespace = path.slice(0, j + 1).join("::");
                if (this.namespaces.has(namespace)) {
                    coclass.namespace = namespace;
                    break;
                }
            }

            if (coclass !== null) {
                // coclass.addProperty([prefix, path[i], "", ["/R"]]);
            }

            if (typeof options.onCoClass === "function") {
                options.onCoClass(this, coclass, options);
            }
        }

        return coclass;
    }

    getCppType(type, coclass, options = {}) {
        if (type.includes("(") || type.includes(")") || type.includes("<") && !type.endsWith(">") || countInstances(type, "<") !== countInstances(type, ">")) {
            // invalid type, most likely comming from defval
            return type;
        }

        type = getAlias(type);

        if (CPP_TYPES.has(type)) {
            type = CPP_TYPES.get(type);
        }

        if (
            type === "IUnknown*" ||
            type === "IEnumVARIANT*" ||
            type === "IDispatch*" ||
            type === "VARIANT*" ||
            type === "VARIANT" ||
            type === "_variant_t"
        ) {
            return type;
        }

        if (type.endsWith("*")) {
            return `${ this.getCppType(type.slice(0, -1), coclass, options) }*`;
        }

        let type_ = type;
        type = CoClass.restoreOriginalType(type, options);

        if (type.includes("<") && type.endsWith(">")) {
            const pos = type.indexOf("<");
            const tpl = this.getCppType(type.slice(0, pos), coclass, options);
            const types = CoClass.getTupleTypes(type.slice(pos + 1, -">".length)).map(itype => this.getCppType(itype, coclass, options));

            if (TEMPLATED_TYPES.has(tpl)) {
                const custom_type = this.add_custom_type(`${ tpl }<${ types.join(", ") }>`, coclass, options);
                this.addDependency(coclass.fqn, custom_type.fqn);
            }

            return `${ tpl }<${ types.join(", ") }>`;
        }

        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        if (options.implicitNamespaceType && options.implicitNamespaceType.test(type_)) {
            type_ = `${ this.namespace }::${ type }`;
        }

        for (const fqn of this.getMaybeTypes(type_, include)) {
            if (this.enums.has(fqn)) {
                return fqn;
            }

            if (options.variantTypeReg && options.variantTypeReg.test(fqn)) {
                return fqn;
            }

            if (CPP_TYPES.has(fqn)) {
                return CPP_TYPES.get(fqn);
            }

            if (this.classes.has(fqn)) {
                return fqn;
            }
        }

        return type_;
    }

    getReturnCppType(type, coclass, options = {}) {
        if (typeof options.getReturnCppType === "function") {
            return options.getReturnCppType(this, type, coclass, options);
        }
        return this.getCppType(type, coclass, options);
    }

    getNonAmbiguousType(cpptype) {
        return !cpptype.startsWith("::") && this.classes.has(cpptype) ? `::${ cpptype }` : cpptype;
    }

    getTypeDisplayName(fqn, cpptype) {
        const name = this.typedefs.has(fqn) ? this.typedefs.get(fqn) : cpptype;
        return name.startsWith("::") ? name.slice("::".length) : name;
    }

    fqnIndentifier(value, coclass, options) {
        const identifiers = /[^\w:]/g;
        let match = identifiers.exec(value);

        if (match === null) {
            let vfqn = this.getCppType(value, coclass, options);
            if (this.classes.has(vfqn)) {
                return vfqn;
            }

            const parts = value.split("::");
            if (parts.length > 1) {
                vfqn = this.getCppType(parts.slice(-1).join("::"), coclass, options);
                if (this.classes.has(vfqn)) {
                    return `${ vfqn }::${ parts[parts.length - 1] }`;
                }
            }

            return value;
        }

        if (match[0] !== "<") {
            return value;
        }

        const start = identifiers.lastIndex;
        const separators = /[<>]/g;
        separators.lastIndex = start;

        let lastIndex = start;
        let open = 0;

        while (match = separators.exec(value)) { // eslint-disable-line no-cond-assign
            if (match[0] === "<") {
                open++;
            } else if (match[0] === ">") {
                open--;
            }

            if (open === 0) {
                lastIndex = separators.lastIndex;
                break;
            }
        }

        if (lastIndex === start) {
            return value;
        }

        const types = CoClass.getTupleTypes(value.slice(start, lastIndex)).map(type => this.getCppType(type, coclass, options));

        return value.slice(0, start) + types.join(", ") + value.slice(lastIndex);
    }

    setAssignOperator(type, coclass, options) {
        const cpptype = this.getCppType(type, coclass, options);

        if (cpptype.startsWith("std::optional<")) {
            this.setAssignOperator(type.slice("std::optional<".length, -">".length), coclass, options);
        } else if (cpptype.startsWith("std::vector<")) {
            this.setAssignOperator(type.slice("std::vector<".length, -">".length), coclass, options);
        } else if (type.startsWith("std::tuple<")) {
            const types = CoClass.getTupleTypes(type.slice("std::tuple<".length, -">".length));
            for (const ttype of types) {
                this.setAssignOperator(ttype, coclass, options);
            }
        } else if (type.startsWith("std::variant<")) {
            const types = CoClass.getTupleTypes(type.slice("std::variant<".length, -">".length));
            for (const ttype of types) {
                this.setAssignOperator(ttype, coclass, options);
            }
        } else if (type.startsWith("std::map<")) {
            const types = CoClass.getTupleTypes(type.slice("std::map<".length, -">".length));
            for (const ttype of types) {
                this.setAssignOperator(ttype, coclass, options);
            }
        } else if (type.startsWith("std::pair<")) {
            const types = CoClass.getTupleTypes(type.slice("std::pair<".length, -">".length));
            for (const ttype of types) {
                this.setAssignOperator(ttype, coclass, options);
            }
        } else if (this.classes.has(cpptype)) {
            this.classes.get(cpptype).has_assign_operator = true;
        }
    }

    getEnumType(type, coclass, options = {}) {
        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        for (const fqn of this.getMaybeTypes(type, include)) {
            if (this.enums.has(fqn)) {
                return fqn;
            }
        }

        return null;
    }

    castAsEnumIfNeeded(type, value, coclass, options = {}) {
        const fqn = this.getEnumType(type, coclass, options);
        return fqn === null ? value : `static_cast<${ fqn }>(${ value })`;
    }

    castFromEnumIfNeeded(type, value, coclass, options = {}) {
        let include = coclass;
        while (include.include) {
            include = include.include;
        }

        if (this.getEnumType(type, coclass, options)) {
            return `static_cast<int>(${ value })`;
        }

        return value;
    }

    addDependency(dependent, dependency) {
        if (dependent === dependency || !dependency || !dependent) {
            return;
        }

        if (!this.dependents.has(dependency)) {
            this.dependents.set(dependency, new Set());
        }

        if (!this.dependencies.has(dependent)) {
            this.dependencies.set(dependent, new Set());
        }

        this.dependents.get(dependency).add(dependent);
        this.dependencies.get(dependent).add(dependency);
    }

    addParentDefinition(coclass, options) {
        const {fqn} = coclass;

        // Add a default constructor
        if (coclass.has_default_constructor === 0) {
            coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], []], options);
        }

        if (options.hasInheritanceSupport) {
            return;
        }

        const parents = [...coclass.parents];

        // denormalize parents
        for (const parent of parents) {
            if (this.classes.has(parent)) {
                this.classes.get(parent).children.add(coclass);
            }

            if (this.bases.has(parent)) {
                this.addDependency(fqn, parent);
                for (const base of this.bases.get(parent)) {
                    parents.push(base);
                }
            }
        }

        // get overrided methods
        const signatures = this.getSignatures(coclass, options);
        const cname = options.cname ? options.cname : "create";

        // inherit methods
        for (const pfqn of parents) {
            if (!this.classes.has(pfqn)) {
                continue;
            }

            const parent = this.classes.get(pfqn);

            for (const fname of parent.methods.keys()) {
                if (fname === cname) {
                    // ignore create method because it creates a base type instance
                    // and not a derived type instance
                    continue;
                }

                const overrides = parent.methods.get(fname);

                for (const decl of overrides) {
                    const [name, return_value_type, func_modifiers, list_of_arguments] = decl;

                    const signature = this.getSignature(coclass, fname, decl, options);

                    if (signatures.has(signature)) {
                        // console.log("duplicated", signature);
                        continue;
                    }

                    const modifiers = func_modifiers.slice();

                    if (!func_modifiers.some(modifier => modifier.startsWith("/Cast="))) {
                        modifiers.push(`/Cast=static_cast<${ parent.fqn }*>`);
                    }

                    coclass.addMethod([`${ fqn }.${ name.split(".").pop() }`, return_value_type, modifiers, list_of_arguments], options);

                    signatures.add(signature);
                }
            }
        }
    }

    makeDependent(type, coclass, options) {
        this.getCppType(type, coclass, options);
    }

    addDependencies(coclass, options) {
        for (const [, {type}] of coclass.properties.entries()) {
            this.makeDependent(type, coclass, options);
        }

        for (const [, overrides] of coclass.methods.entries()) {
            for (const decl of overrides) {
                const [, return_value_type, , list_of_arguments] = decl;

                this.makeDependent(return_value_type, coclass, options);

                for (const [argtype] of list_of_arguments) {
                    this.makeDependent(argtype, coclass, options);
                }
            }
        }
    }

    getSignatures(coclass, options) {
        const signatures = new Set();

        for (const fname of coclass.methods.keys()) {
            const overrides = coclass.methods.get(fname);

            for (const decl of overrides) {
                const signature = this.getSignature(coclass, fname, decl, options);

                if (signatures.has(signature)) {
                    // console.log("duplicated", signature);
                }

                signatures.add(signature);
            }
        }

        return signatures;
    }

    getSignature(coclass, fname, decl, options) {
        const [, , , list_of_arguments] = decl;
        const signature = [fname];

        for (const [argtype] of list_of_arguments) {
            signature.push(this.getCppType(argtype, coclass, options));
        }

        return signature.join(", ");
    }

    getMaybeTypes(type, coclass) {
        const types = new Set([type]);

        if (coclass.fqn) {
            coclass.fqn.split("::").forEach((el, i, arr) => {
                types.add(`${ arr.slice(0, arr.length - i).join("::") }::${ type }`);
            });
        }

        if (coclass.namespace) {
            types.add(`${ coclass.namespace }::${ type }`);
        }

        for (const namespace of this.namespaces) {
            const itype = `${ namespace }::${ type }`;
            if (this.classes.has(itype)) {
                types.add(itype);
            }
        }

        types.add(`${ this.namespace }::${ type }`);

        return Array.from(types);
    }

    getAllMethods(fqn) {
        const stack = [fqn];

        const methods = new Map();
        const seen = new Set();

        while (stack.length !== 0) {
            fqn = stack.pop();
            if (seen.has(fqn) || !this.classes.has(fqn)) {
                continue;
            }

            seen.add(fqn);
            const coclass = this.classes.get(fqn);
            for (const [fname, decl] of coclass.methods.entries()) {
                if (!methods.has(fname)) {
                    methods.set(fname, decl);
                }
            }
            stack.push(...Array.from(coclass.parents).reverse());
        }

        return methods;
    }
}

module.exports = DeclProcessor;
