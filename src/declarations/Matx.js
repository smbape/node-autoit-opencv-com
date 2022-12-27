const Matx = (fqn, type, m, n) => {
    const name = fqn.slice(fqn.lastIndexOf(".") + 1);
    const cpptype = fqn.replaceAll(".", "::");

    const declarations = [
        [`class ${ fqn }`, "", ["/Simple"], [
            ["int", "rows", "", ["/R", "/S"]],
            ["int", "cols", "", ["/R", "/S"]],
            ["int", "channels", "", ["/R", "/S"]],
            ["int", "shortdim", "", ["/R", "/S"]],
        ], "", ""],

        //! default constructor
        [`${ fqn }.${ name }`, "", [], [], "", ""],

        [`${ fqn }.all`, cpptype, ["/S"], [
            [type, "alpha", "", []],
        ], "", ""],

        [`${ fqn }.zeros`, cpptype, ["/S"], [], "", ""],
        [`${ fqn }.ones`, cpptype, ["/S"], [], "", ""],
        [`${ fqn }.eye`, cpptype, ["/S"], [], "", ""],

        [`${ fqn }.randu`, cpptype, ["/S"], [
            [type, "a", "", []],
            [type, "b", "", []],
        ], "", ""],

        [`${ fqn }.randn`, cpptype, ["/S"], [
            [type, "a", "", []],
            [type, "b", "", []],
        ], "", ""],

        [`${ fqn }.dot`, type, [], [
            [cpptype, "v", "", ["/Ref"]],
        ], "", ""],

        [`${ fqn }.ddot`, "double", [], [
            [cpptype, "v", "", ["/Ref"]],
        ], "", ""],

        [`${ fqn }.mul`, cpptype, [], [
            [cpptype, "a", "", ["/Ref"]],
        ], "", ""],

        [`${ fqn }.div`, cpptype, [], [
            [cpptype, "a", "", ["/Ref"]],
        ], "", ""],
    ];

    const argdecl = [
        [
            ["int", "row", "", []],
            ["int", "col", "", []],
        ]
    ];

    if (m === 1 || n === 1) {
        argdecl.unshift([
            ["int", "i", "", []],
        ]);
    }

    for (const args of argdecl) {
        const argexpr = args.map(([, argname]) => argname).join(", ");

        declarations.push(...[
            [`${ fqn }.operator()`, type, ["/attr=propget", "=get_Item", "/idlname=Item", "/id=DISPID_VALUE"], args, "", ""],
            [`${ fqn }.operator()`, "void", ["/attr=propput", "=put_Item", "/idlname=Item", "/id=DISPID_VALUE", `/Expr=${ argexpr }) = (value`], args.concat([[type, "value", "", []]]), "", ""],
        ]);
    }

    return declarations;
};

module.exports = [
    ...Matx("cv.Matx33f", "float", 3, 3),
    ...Matx("cv.Matx33d", "double", 3, 3),
    ...Matx("cv.Matx44f", "float", 4, 4),
    ...Matx("cv.Matx44d", "double", 4, 4),
];
