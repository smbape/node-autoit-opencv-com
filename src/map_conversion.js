const FunctionDeclaration = require("./FunctionDeclaration");
const PropertyDeclaration = require("./PropertyDeclaration");

const _generate = function(generator, iglobal, iidl, impl, ipublic, iprivate, idnames, id, is_test, options) {
    const coclass = this; // eslint-disable-line no-invalid-this
    const {key_type, value_type} = coclass;

    FunctionDeclaration.declare(generator, coclass, [
        [`${ coclass.fqn }.at`, value_type, ["/attr=propget", "=get_Item"], [
            [key_type, "vKey", "", []],
        ], "", ""]
    ], "get_Item", "Item", "DISPID_VALUE", iidl, ipublic, impl, is_test, options);

    FunctionDeclaration.declare(generator, coclass, [
        [`${ coclass.fqn }.insert_or_assign`, "void", ["/attr=propput", "=put_Item"], [
            [key_type, "vKey", "", []],
            [value_type, "vItem", "", []],
        ], "", ""]
    ], "put_Item", "Item", "DISPID_VALUE", iidl, ipublic, impl, is_test, options);

    iidl.push(`
        [propget, restricted, id(DISPID_NEWENUM)] HRESULT _NewEnum([out, retval] IUnknown** ppUnk);
    `.replace(/^ {8}/mg, "").trim());
};

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

    const [key_type, value_type] = PropertyDeclaration.getTupleTypes(type.slice("map<".length, -">".length));
    const coclass = generator.getCoClass(fqn);
    generator.typedefs.set(fqn, cpptype);

    coclass.is_simple = true;
    coclass.is_class = true;
    coclass.is_stdmap = true;
    coclass.include = parent;
    coclass.key_type = generator.getCppType(key_type, coclass, options);
    coclass.value_type = generator.getCppType(value_type, coclass, options);
    coclass.idltype_key = generator.getIDLType(key_type, coclass, options);
    coclass.idltype_value = generator.getIDLType(value_type, coclass, options);

    coclass.addMethod([`${ fqn }.${ coclass.name }`, "", [], [], "", ""]);

    coclass.addMethod([`${ fqn }.create`, `shared_ptr<${ coclass.name }>`, ["/External", "/S"], [
        [`std::vector<std::pair<${ key_type }, ${ value_type }>>`, "pairs", "", []],
    ], "", ""]);

    // Element access
    coclass.addMethod([`${ fqn }.at`, value_type, ["=Get"], [
        [key_type, "key", "", []],
    ], "", ""]);

    // Iterators
    coclass.addMethod([`${ fqn }.Keys`, `vector_${ key_type }`, ["/External"], [], "", ""]);
    coclass.addMethod([`${ fqn }.Items`, `vector_${ value_type }`, ["/External"], [], "", ""]);

    // Capacity
    coclass.addMethod([`${ fqn }.empty`, "bool", [], [], "", ""]);
    coclass.addMethod([`${ fqn }.size`, "size_t", [], [], "", ""]);
    coclass.addMethod([`${ fqn }.max_size`, "size_t", [], [], "", ""]);

    // Modifiers
    coclass.addMethod([`${ fqn }.clear`, "void", [], [], "", ""]);

    coclass.addMethod([`${ fqn }.insert_or_assign`, "void", ["=Add"], [
        [key_type, "key", "", []],
        [value_type, "value", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.erase`, "size_t", [], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.erase`, "size_t", ["=Remove"], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.merge`, "void", [], [
        [fqn, "other", "", []],
    ], "", ""]);

    // Lookup
    coclass.addMethod([`${ fqn }.count`, "size_t", [], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.contains`, "bool", [], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.contains`, "bool", ["=has"], [
        [key_type, "key", "", []],
    ], "", ""]);

    // make map to be recognized as a collection
    const cotype = coclass.getClassName();
    const _Copy = `autoit::GenericCopy<std::pair<const ${ key_type }, ${ value_type }>>`;
    const CIntEnum = `CComEnumOnSTL<IEnumVARIANT, &IID_IEnumVARIANT, VARIANT, ${ _Copy }, ${ fqn }>`;
    const IIntCollection = `AutoItCollectionEnumOnSTLImpl<I${ cotype }, ${ fqn }, ${ CIntEnum }, AutoItObject<${ fqn }>>`;

    coclass.dispimpl = IIntCollection;
    coclass.generate = _generate.bind(coclass, generator);

    return fqn;
};

exports.generate = (coclass, header, impl, options = {}) => {
    const cotype = coclass.getClassName();
    const { key_type, value_type } = coclass;
    const pair_type = `${ key_type }, ${ value_type }`;
    const map_type = `std::map<${ pair_type }>`;

    impl.push(`
        const std::shared_ptr<${ map_type }> C${ cotype }::create(std::vector<std::pair<${ pair_type }>>& pairs, HRESULT& hr) {
            hr = S_OK;
            auto sp = std::make_shared<${ map_type }>();
            for (const auto& pair_ : pairs) {
                sp->insert_or_assign(pair_.first, pair_.second);
            }
            return sp;
        }

        const std::vector<${ key_type }> C${ cotype }::Keys(HRESULT& hr) {
            hr = S_OK;
            auto& map = *this->__self->get();

            std::vector<${ key_type }> keys;

            for (auto it = map.begin(); it != map.end(); ++it) {
                keys.push_back(it->first);
            }

            return keys;
        }

        const std::vector<${ value_type }> C${ cotype }::Items(HRESULT& hr) {
            hr = S_OK;
            auto& map = *this->__self->get();

            std::vector<${ value_type }> keys;

            for (auto it = map.begin(); it != map.end(); ++it) {
                keys.push_back(it->second);
            }

            return keys;
        }
        `.replace(/^ {8}/mg, "")
    );
};
