const {getTypeDef} = require("./alias");

exports.declare = (generator, type, parent, options = {}) => {
    const cpptype = generator.getCppType(type, parent, options);

    const fqn = getTypeDef(cpptype, options);

    if (generator.classes.has(fqn)) {
        return fqn;
    }

    const vtype = cpptype.slice("std::vector<".length, -">".length);
    const coclass = generator.getCoClass(fqn, options);
    generator.typedefs.set(fqn, cpptype);

    coclass.include = parent;
    coclass.is_simple = true;
    coclass.is_class = true;
    coclass.is_vector = true;
    coclass.cpptype = vtype;
    coclass.idltype = generator.getIDLType(vtype, coclass, options);

    coclass.addProperty(["size_t", "Count", "", ["/R", "=size()"]]);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [], "", ""]);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
        ["size_t", "size", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
        [fqn, "other", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.Keys`, "vector_int", ["/External"], [], "", ""]);
    coclass.addMethod([`${ fqn }.Items`, fqn, ["/Call=", "/Expr=*__self->get()"], [], "", ""]);

    coclass.addMethod([`${ fqn }.push_back`, "void", [], [
        [vtype, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.push_back`, "void", ["=Add"], [
        [vtype, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.push_back`, "void", ["=append"], [
        [vtype, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.erase`, "void", ["=Remove"], [
        ["size_t", "index", "", ["/Expr=std::next(__self->get()->begin() + index)"]],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, vtype, ["/External"], [
        ["size_t", "index", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, "void", ["/External"], [
        ["size_t", "index", "", []],
        [vtype, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, vtype, ["/attr=propget", "/idlname=Item", "=get_Item", "/id=DISPID_VALUE", "/ExternalNoDecl"], [
        ["size_t", "index", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, "void", ["/attr=propput", "/idlname=Item", "=put_Item", "/id=DISPID_VALUE", "/ExternalNoDecl"], [
        ["size_t", "index", "", []],
        [vtype, "item", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.size`, "size_t", [], [], "", ""]);
    coclass.addMethod([`${ fqn }.empty`, "bool", [], [], "", ""]);
    coclass.addMethod([`${ fqn }.clear`, "void", [], [], "", ""]);

    coclass.addMethod([`${ fqn }.push_vector`, "void", ["/External"], [
        [fqn, "other", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.push_vector`, "void", ["/External"], [
        [fqn, "other", "", []],
        ["size_t", "count", "", []],
        ["size_t", "start", "0", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.slice`, fqn, ["/External"], [
        ["size_t", "start", "0", []],
        ["size_t", "count", "__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.sort`, "void", ["/External"], [
        ["void*", "comparator", "", []],
        ["size_t", "start", "0", []],
        ["size_t", "count", "__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.sort_variant`, "void", ["/External"], [
        ["void*", "comparator", "", []],
        ["size_t", "start", "0", []],
        ["size_t", "count", "__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.start`, "void*", ["/External"], [], "", ""]);
    coclass.addMethod([`${ fqn }.end`, "void*", ["/External"], [], "", ""]);

    // make vector to be recognized as a collection
    generator.as_stl_enum(coclass, vtype);

    generator.setAssignOperator(vtype, coclass, options);

    return fqn;
};

exports.convert_sort = (coclass, header, impl, options = {}) => {
    const cotype = coclass.getClassName();
    const comparator = `${ coclass.fqn.replaceAll("::", "_") }Comparator`;
    const ptr_comparator = `${ coclass.fqn.replaceAll("::", "_") }PtrComparator`;
    const { cpptype: vtype } = coclass;
    const idltype = coclass.idltype === "VARIANT" || coclass.idltype[0] === "I" ? "VARIANT" : coclass.idltype;
    const to_variant = idltype === "VARIANT";
    const default_value = to_variant ? "{ VT_EMPTY }" : "NULL";
    const ptrtype = to_variant ? idltype : vtype;
    const byref = vtype !== "void*" && vtype !== "uchar*" && (idltype === "VARIANT" || idltype[0] === "I");

    const cmp = (to_variant || idltype[0] === "I" ? `
        ${ to_variant ? "_variant_t" : idltype } va = ${ default_value };
        ${ to_variant ? "_variant_t" : idltype } vb = ${ default_value };

        ${ idltype }* pva = &va;
        ${ idltype }* pvb = &vb;

        autoit_from(a, pva);
        autoit_from(b, pvb);

        return cmp(pva, pvb);
    ` : `
        return cmp(&a, &b);
    `).replace(/^ {8}/mg, "").trim().split("\n");

    header.push(`
        using ${ comparator } = bool (*)(${ vtype }${ byref ? "&" : "" } a, ${ vtype }${ byref ? "&" : "" } b);
        using ${ ptr_comparator } = bool (*)(${ ptrtype }* a, ${ ptrtype }* b);
        typedef struct _${ comparator }Proxy  ${ comparator }Proxy;
    `.replace(/^ {8}/mg, ""));

    impl.push(`
        typedef struct _${ comparator }Proxy {
            ${ ptr_comparator } cmp;
            bool operator() (${ vtype }${ byref ? "&" : "" } a, ${ vtype }${ byref ? "&" : "" } b) {
                ${ cmp.join(`\n${ " ".repeat(16) }`) }
            }
        } ${ comparator }Proxy;

        void C${ cotype }::sort(void* comparator, size_t start, size_t count, HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            auto begin = std::begin(v) + start;
            std::sort(begin, begin + count, reinterpret_cast<${ comparator }>(comparator));
        }

        void C${ cotype }::sort_variant(void* comparator, size_t start, size_t count, HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            auto begin = std::begin(v) + start;
            ${ comparator }Proxy cmp = { reinterpret_cast<${ ptr_comparator }>(comparator) };
            std::sort(begin, begin + count, cmp);
        }
        `.replace(/^ {8}/mg, "")
    );
};

exports.convert = (coclass, header, impl, options = {}) => {
    exports.convert_sort(coclass, header, impl, options);

    const cotype = coclass.getClassName();
    const { cpptype: vtype } = coclass;
    const idltype = coclass.idltype === "VARIANT" || coclass.idltype[0] === "I" ? "VARIANT" : coclass.idltype;
    const byref = vtype !== "void*" && vtype !== "uchar*" && (idltype === "VARIANT" || idltype[0] === "I");

    impl.push(`
        const std::vector<int> C${ cotype }::Keys(HRESULT& hr) {
            const auto& v = *__self->get();
            std::vector<int> keys(v.size());
            std::iota(keys.begin(), keys.end(), 0);
            return keys;
        }

        const ${ vtype } C${ cotype }::at(size_t i, HRESULT& hr) {
            auto& v = *__self->get();
            if (i >= v.size()) {
                hr = E_INVALIDARG;
                AUTOIT_ERROR("index " << i << " is out of range");
                return ${ vtype }();
            }
            hr = S_OK;
            return v.at(i);
        }

        void C${ cotype }::at(size_t i, ${ vtype }${ byref ? "&" : "" } value, HRESULT& hr) {
            auto& v = *__self->get();
            if (i >= v.size()) {
                hr = E_INVALIDARG;
                AUTOIT_ERROR("index " << i << " is out of range");
                return;
            }
            hr = S_OK;
            v[i] = value;
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            v.insert(std::end(v), std::begin(other), std::end(other));
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, size_t count, size_t start, HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            auto begin = std::begin(other) + start;
            v.insert(std::end(v), begin, begin + count);
        }

        const ${ coclass.fqn } C${ cotype }::slice(size_t start, size_t count, HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            auto begin = std::begin(v) + start;
            return ${ coclass.fqn }(begin, begin + count);
        }

        const void* C${ cotype }::start(HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            ${ vtype === "bool" ? "void*" : "auto" } _result = ${ vtype === "bool" ? "NULL" : "v.empty() ? NULL : static_cast<const void*>(&v[0])" };
            return _result;
        }

        const void* C${ cotype }::end(HRESULT& hr) {
            hr = S_OK;
            auto& v = *__self->get();
            ${ vtype === "bool" ? "void*" : "auto" } _result = ${ vtype === "bool" ? "NULL" : "v.empty() ? NULL : static_cast<const void*>(&v[v.size()])" };
            return _result;
        }

        `.replace(/^ {8}/mg, "")
    );
};
