const {getTypeDef} = require("./alias");
const PropertyDeclaration = require("./PropertyDeclaration");

exports.declare = (generator, type, parent, options = {}) => {
    const cpptype = generator.getCppType(type, parent, options);

    const fqn = getTypeDef(cpptype, options);

    if (generator.classes.has(fqn)) {
        return fqn;
    }

    const [key_type, value_type] = PropertyDeclaration.getTupleTypes(type.slice("map<".length, -">".length));
    const coclass = generator.getCoClass(fqn, options);

    generator.add_vector(`std::vector<std::pair<${ key_type }, ${ value_type }>>`, parent, options);
    generator.add_vector(`std::vector<${ key_type }>`, parent, options);
    generator.add_vector(`std::vector<${ value_type }>`, parent, options);
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

    coclass.addMethod([`${ fqn }.create`, `${ options.shared_ptr }<${ coclass.name }>`, ["/External", "/S"], [
        [`std::vector<std::pair<${ key_type }, ${ value_type }>>`, "pairs", "", []],
    ], "", ""]);

    // Element access
    coclass.addMethod([`${ fqn }.at`, value_type, ["=Get", "/External"], [
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

    coclass.addMethod([`${ fqn }.count`, "bool", ["=contains", "/Output=($0 != 0)"], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.count`, "bool", ["=has", "/Output=($0 != 0)"], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.at`, value_type, ["/attr=propget", "/idlname=Item", "=get_Item", "/id=DISPID_VALUE", "/ExternalNoDecl"], [
        [key_type, "key", "", []],
    ], "", ""]);

    coclass.addMethod([`${ fqn }.insert_or_assign`, "void", ["/attr=propput", "/idlname=Item", "=put_Item", "/id=DISPID_VALUE"], [
        [key_type, "key", "", []],
        [value_type, "item", "", []],
    ], "", ""]);

    // make map to be recognized as a collection
    generator.as_stl_enum(coclass, `std::pair<const ${ coclass.key_type }, ${ coclass.value_type }>`);

    return fqn;
};

exports.convert = (coclass, header, impl, { shared_ptr, make_shared } = {}) => {
    const cotype = coclass.getClassName();
    const { fqn, key_type, value_type } = coclass;
    const pair_type = `${ key_type }, ${ value_type }`;

    impl.push(`
        const ${ shared_ptr }<${ fqn }> C${ cotype }::create(std::vector<std::pair<${ pair_type }>>& pairs, HRESULT& hr) {
            hr = S_OK;
            auto sp = ${ make_shared }<${ fqn }>();
            for (const auto& pair_ : pairs) {
                sp->insert_or_assign(pair_.first, pair_.second);
            }
            return sp;
        }

        const std::vector<${ key_type }> C${ cotype }::Keys(HRESULT& hr) {
            hr = S_OK;
            auto& map = *__self->get();

            std::vector<${ key_type }> keys;

            for (auto it = map.begin(); it != map.end(); ++it) {
                keys.push_back(it->first);
            }

            return keys;
        }

        const ${ value_type } C${ cotype }::at(${ key_type } key, HRESULT& hr) {
            hr = S_OK;
            auto& map = *__self->get();
            if (!map.count(key)) {
                AUTOIT_ERROR("the container does not have an element with the specified key '" << key << "'");
                hr = E_INVALIDARG;
                return ${ value_type }();
            }
            return map.at(key);
        }

        const std::vector<${ value_type }> C${ cotype }::Items(HRESULT& hr) {
            hr = S_OK;
            auto& map = *__self->get();

            std::vector<${ value_type }> keys;

            for (auto it = map.begin(); it != map.end(); ++it) {
                keys.push_back(it->second);
            }

            return keys;
        }
        `.replace(/^ {8}/mg, "")
    );
};
