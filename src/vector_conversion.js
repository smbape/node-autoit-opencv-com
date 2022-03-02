const optional = require("./optional_conversion");

exports.declare = (generator, type, parent, options = {}) => {
    const cpptype = generator.getCppType(type, parent, options);

    const fqn = cpptype
        .replace(/std::map/g, "MapOf")
        .replace(/std::pair/g, "PairOf")
        .replace(/std::vector/g, "VectorOf")
        .replace(/\b_variant_t\b/g, "Variant")
        .replace(/\w+::/g, "")
        .replace(/\b[a-z]/g, m => m.toUpperCase())
        .replace(/, /g, "And")
        .replace(/[<>]/g, "");

    if (generator.classes.has(fqn)) {
        return fqn;
    }

    const vtype = type.slice("vector<".length, -">".length);
    const coclass = generator.getCoClass(fqn);
    generator.typedefs.set(fqn, cpptype);

    coclass.is_simple = true;
    coclass.is_class = true;
    coclass.is_vector = true;
    coclass.cpptype = cpptype.slice("std::vector<".length, -">".length);
    coclass.idltype = generator.getIDLType(vtype, {
        fqn,
        namespace: parent.namespace,
    }, options);
    coclass.include = parent;

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [], "", ""]);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
        ["size_t", "size", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [
        [fqn, "other", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.push_back`, "void", [], [
        [vtype, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, vtype, [], [
        ["size_t", "index", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, "void", ["/External"], [
        ["size_t", "index", "", []],
        [vtype, "value", "", []],
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
        ["size_t", "count", "this->__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.sort`, "void", ["/External"], [
        ["void*", "comparator", "", []],
        ["size_t", "start", "0", []],
        ["size_t", "count", "this->__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.sort_variant`, "void", ["/External"], [
        ["void*", "comparator", "", []],
        ["size_t", "start", "0", []],
        ["size_t", "count", "this->__self->get()->size()", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.start`, "void*", ["/External"], [], "", ""]);
    coclass.addMethod([`${ fqn }.end`, "void*", ["/External"], [], "", ""]);

    return fqn;
};

exports.generate = (coclass, header, impl, {shared_ptr} = {}) => {
    const cotype = coclass.getClassName();
    const comparator = `${ coclass.fqn }Comparator`;
    const ptr_comparator = `${ coclass.fqn }PtrComparator`;
    const { cpptype } = coclass;
    const idltype = coclass.idltype === "VARIANT" || coclass.idltype[0] === "I" ? "VARIANT" : coclass.idltype;
    const to_variant = idltype === "VARIANT";
    const default_value = to_variant ? "{ VT_EMPTY }" : "NULL";
    const ptrtype = to_variant ? idltype : cpptype;
    const byref = cpptype !== "void*" && cpptype !== "uchar*" && (idltype === "VARIANT" || idltype[0] === "I");

    const cvt = (to_variant || idltype[0] === "I" ? `
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
        typedef bool (*${ comparator })(${ cpptype } a, ${ cpptype } b);
        typedef bool (*${ ptr_comparator })(${ ptrtype }* a, ${ ptrtype }* b);
        typedef struct _${ comparator }Proxy  ${ comparator }Proxy;
    `.replace(/^ {8}/mg, ""));

    impl.push(`
        typedef struct _${ comparator }Proxy {
            ${ ptr_comparator } cmp;
            bool operator() (${ cpptype } a, ${ cpptype } b) {
                ${ cvt.join(`\n${ " ".repeat(16) }`) }
            }
        } ${ comparator }Proxy;

        #include "vectors_c.h"

        void C${ cotype }::at(size_t i, ${ cpptype }${ byref ? "&" : "" } value, HRESULT& hr) {
            (*this->__self->get())[i] = value;
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, HRESULT& hr) {
            auto v = this->__self->get();
            VectorPushMulti(v, &other[0], other.size());
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, size_t count, size_t start, HRESULT& hr) {
            auto v = this->__self->get();
            VectorPushMulti(v, &other[start], count);
        }

        const ${ coclass.fqn } C${ cotype }::slice(size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            return ${ coclass.fqn }(begin, begin + count);
        }

        void C${ cotype }::sort(void* comparator, size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            std::sort(begin, begin + count, reinterpret_cast<${ comparator }>(comparator));
        }

        void C${ cotype }::sort_variant(void* comparator, size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            ${ comparator }Proxy cmp = { reinterpret_cast<${ ptr_comparator }>(comparator) };
            std::sort(begin, begin + count, cmp);
        }

        const void* C${ cotype }::start(HRESULT& hr) {
            auto v = this->__self->get();
            auto _result = v->empty() ? NULL : static_cast<const void*>(&(*v)[0]);
            return _result;
        }

        const void* C${ cotype }::end(HRESULT& hr) {
            auto v = this->__self->get();
            auto _result = v->empty() ? NULL : static_cast<const void*>(&(*v)[v->size()]);
            return _result;
        }
        `.replace(/^ {8}/mg, "")
    );
};
