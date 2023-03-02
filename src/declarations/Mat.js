module.exports = ({ shared_ptr }) => {
    const declarations = [
        ["class cv._InputArray", "", [], [], "", ""],
        ["class cv._OutputArray", "", [], [], "", ""],
        ["class cv._InputOutputArray", "", [], [], "", ""],

        ["class cv.Mat", "", ["/Simple"], [
            // Public Attributes

            ["int", "cols", "", ["/RW"]],
            ["uchar*", "data", "", ["/RW"]],
            ["int", "dims", "", ["/RW"]],
            ["int", "flags", "", ["/RW"]],
            ["int", "rows", "", ["/RW"]],
            ["size_t", "step", "", ["/RW"]],

            // Custom Attributes

            ["int", "width", "", ["/RW", "=cols"]],
            ["int", "height", "", ["/RW", "=rows"]],
            ["std::tuple<int, int, int>", "shape", "", ["/R", "/RExpr=std::tuple<int, int, int>(__self->get()->rows, __self->get()->cols, __self->get()->channels())"]],
            ["std::vector<int>", "sizes", "", ["/R", "/RExpr=std::vector<int>(__self->get()->size.p, __self->get()->size.p + __self->get()->dims)"]],
            ["std::vector<size_t>", "steps", "", ["/R", "/RExpr=std::vector<size_t>(__self->get()->step.p, __self->get()->step.p + __self->get()->dims)"]],
        ], "", ""],

        // Public Member Functions

        ["cv.Mat.Mat", "", [], [], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Size", "size", "", []],
            ["int", "type", "", []]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []],
            ["Scalar", "s", "", []],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Size", "size", "", []],
            ["int", "type", "", []],
            ["Scalar", "s", "", []],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["vector_int", "sizes", "", ["/Ref", "/C"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["vector_int", "sizes", "", ["/Ref", "/C"]],
            ["int", "type", "", []],
            ["Scalar", "s", "", []],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Mat", "m", "", ["/Ref", "/C"]]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []],
            ["void*", "data", "", []],
            ["size_t", "step", "Mat::AUTO_STEP", []]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Size", "size", "", []],
            ["int", "type", "", []],
            ["void*", "data", "", []],
            ["size_t", "step", "Mat::AUTO_STEP", []]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["vector_int", "sizes", "", ["/Ref", "/C"]],
            ["int", "type", "", []],
            ["void*", "data", "", []],
            ["std::vector<size_t>", "steps", "std::vector<size_t>()", ["/Ref", "/C", "/Expr=static_cast<size_t*>(steps.empty() ? 0 : steps.data())"]]
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Mat", "m", "", ["/Ref", "/C"]],
            ["Range", "rowRange", "", ["/Ref", "/C"]],
            ["Range", "colRange", "Range::all()", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Mat", "m", "", ["/Ref", "/C"]],
            ["Rect", "roi", "", []],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["Mat", "m", "", ["/Ref", "/C"]],
            ["std::vector<Range>", "ranges", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.Mat", "", ["/Expr=$0, true"], [
            ["std::vector<double>", "vec", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.Mat", "", ["/Expr=$0, true"], [
            ["std::vector<int>", "vec", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.Mat", "", [], [
            ["cuda::GpuMat", "m", "", ["/Ref", "/C"]]
        ], "", ""],

        // ["cv.Mat.addref", "void", [], [], "", ""],

        ["cv.Mat.adjustROI", `${ shared_ptr }<Mat>`, ["/Ref", "/WrapAs=::autoit::reference_internal"], [
            ["int", "dtop", "", []],
            ["int", "dbottom", "", []],
            ["int", "dleft", "", []],
            ["int", "dright", "", []],
        ], "", ""],

        ["cv.Mat.assignTo", "void", [], [
            ["Mat", "m", "", ["/Ref", "/C"]],
            ["int", "type", "-1", []],
        ], "", ""],

        ["cv.Mat.channels", "int", [], [], "", ""],

        ["cv.Mat.checkVector", "int", [], [
            ["int", "elemChannels", "", []],
            ["int", "depth", "-1", []],
            ["int", "requireContinuous", "true", []],
        ], "", ""],

        ["cv.Mat.clone", "Mat", [], [], "", ""],
        ["cv.Mat.clone", "Mat", ["=copy"], [], "", ""],

        ["cv.Mat.col", "Mat", [], [
            ["int", "x", "", []],
        ], "", ""],

        ["cv.Mat.colRange", "Mat", [], [
            ["int", "startcol", "", []],
            ["int", "endcol", "__self->get()->cols", []],
        ], "", ""],
        ["cv.Mat.colRange", "Mat", [], [
            ["Range", "r", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.convertTo", "void", [], [
            ["OutputArray", "m", "", []],
            ["int", "rtype", "", []],
            ["double", "alpha", "1.0", []],
            ["double", "beta", "0.0", []],
        ], "", ""],
        ["cv.Mat.convertTo", "void", [], [
            ["OutputArray", "m", "", []],
            ["int", "rtype", "-1", []],
            ["double", "alpha", "1.0", []],
            ["double", "beta", "0.0", []],
        ], "", ""],

        ["cv.Mat.copySize", "void", [], [
            ["Mat", "m", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.copyTo", "void", [], [
            ["OutputArray", "m", "", []],
        ], "", ""],

        ["cv.Mat.copyTo", "void", [], [
            ["OutputArray", "m", "", []],
            ["InputArray", "mask", "", []],
        ], "", ""],

        ["cv.Mat.cross", "Mat", [], [
            ["InputArray", "m", "", []],
        ], "", ""],

        ["cv.Mat.depth", "int", [], [], "", ""],

        ["cv.Mat.diag", "Mat", [], [
            ["int", "d", "0", []],
        ], "", ""],

        ["cv.Mat.dot", "double", [], [
            ["InputArray", "m", "", []],
        ], "", ""],

        ["cv.Mat.elemSize", "size_t", [], [], "", ""],
        ["cv.Mat.elemSize1", "size_t", [], [], "", ""],
        ["cv.Mat.empty", "bool", [], [], "", ""],

        ["cv.Mat.getUMat", "UMat", [], [
            ["AccessFlag", "accessFlags", "", []],
            ["UMatUsageFlags", "usageFlags", "USAGE_DEFAULT", []],
        ], "", ""],

        ["cv.Mat.inv", "Mat", [""], [
            ["int", "method", "DECOMP_LU", []],
        ], "", ""],

        ["cv.Mat.isContinuous", "bool", [], [], "", ""],
        ["cv.Mat.isSubmatrix", "bool", [], [], "", ""],

        ["cv.Mat.locateROI", "void", [], [
            ["Size", "wholeSize", "", ["/O", "/Ref"]],
            ["Point", "ofs", "", ["/O", "/Ref"]],
        ], "", ""],

        ["cv.Mat.mul", "Mat", [], [
            ["InputArray", "m", "", []],
            ["double", "scale", "1", []],
        ], "", ""],

        ["cv.Mat.pop_back", "void", [], [
            ["size_t", "value", "", []]
        ], "", ""],

        ["cv.Mat.ptr", "uchar*", [], [
            ["int", "y", "0", []]
        ], "", ""],
        ["cv.Mat.ptr", "uchar*", [], [
            ["int", "i0", "", []],
            ["int", "i1", "", []],
        ], "", ""],
        ["cv.Mat.ptr", "uchar*", [], [
            ["int", "i0", "", []],
            ["int", "i1", "", []],
            ["int", "i2", "", []],
        ], "", ""],
        ["cv.Mat.ptr", "uchar*", [], [
            ["std::vector<int>", "idx", "std::vector<int>()", ["/Ref", "/C", "/Expr=idx.data()"]]
        ], "", ""],

        ["cv.Mat.push_back", "void", [], [
            ["Mat", "m", "", ["/Ref", "/C"]]
        ], "", ""],

        // ["cv.Mat.release", "void", [], [], "", ""],

        ["cv.Mat.reserve", "void", [], [
            ["size_t", "sz", "", []],
        ], "", ""],

        ["cv.Mat.reserveBuffer", "void", [], [
            ["size_t", "sz", "", []],
        ], "", ""],

        ["cv.Mat.reshape", "Mat", [], [
            ["int", "cn", "", []],
            ["int", "rows", "0", []],
        ], "", ""],

        ["cv.Mat.reshape", "Mat", [], [
            ["int", "cn", "", []],
            ["std::vector<int>", "newshape", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.resize", "void", [], [
            ["size_t", "sz", "", []],
        ], "", ""],

        ["cv.Mat.resize", "void", [], [
            ["size_t", "sz", "", []],
            ["Scalar", "s", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.row", "Mat", [], [
            ["int", "y", "", []],
        ], "", ""],
        ["cv.Mat.rowRange", "Mat", [], [
            ["int", "startrow", "", []],
            ["int", "endrow", "__self->get()->rows", []],
        ], "", ""],
        ["cv.Mat.rowRange", "Mat", [], [
            ["Range", "r", "", []],
        ], "", ""],

        ["cv.Mat.setTo", "void", [], [
            ["InputArray", "value", "", []],
            ["InputArray", "mask", "noArray()", []],
        ], "", ""],

        ["cv.Mat.size", "Size", [], [], "", ""],

        ["cv.Mat.step1", "size_t", [], [
            ["int", "i", "0", []]
        ], "", ""],

        ["cv.Mat.t", "Mat", [], [], "", ""],

        ["cv.Mat.total", "size_t", [], [], "", ""],
        ["cv.Mat.total", "size_t", [], [
            ["int", "startDim", "", []],
            ["int", "endDim", "INT_MAX", []],
        ], "", ""],

        ["cv.Mat.type", "int", [], [], "", ""],

        ["cv.Mat.updateContinuityFlag", "void", [], [], "", ""],

        // Static Public Member Functions

        ["cv.Mat.diag", "Mat", ["/S"], [
            ["Mat", "d", "", ["/Ref", "/C"]],
        ], "", ""],

        ["cv.Mat.eye", "Mat", ["/S"], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.eye", "Mat", ["/S"], [
            ["int", "rows", "", ["/Expr=rows, rows"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.eye", "Mat", ["/S"], [
            ["int", "cols", "", ["/Expr=cols, cols"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.eye", "Mat", ["/S"], [
            ["Size", "size", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.ones", "Mat", ["/S"], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.ones", "Mat", ["/S"], [
            ["int", "cols", "", ["/Expr=1, cols"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.ones", "Mat", ["/S"], [
            ["int", "rows", "", ["/Expr=rows, 1"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.ones", "Mat", ["/S"], [
            ["Size", "size", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.ones", "Mat", ["/S"], [
            ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.zeros", "Mat", ["/S"], [
            ["int", "rows", "", []],
            ["int", "cols", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.zeros", "Mat", ["/S"], [
            ["int", "cols", "", ["/Expr=1, cols"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.zeros", "Mat", ["/S"], [
            ["int", "rows", "", ["/Expr=rows, 1"]],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.zeros", "Mat", ["/S"], [
            ["Size", "size", "", []],
            ["int", "type", "", []],
        ], "", ""],

        ["cv.Mat.zeros", "Mat", ["/S"], [
            ["std::vector<int>", "sizes", "", ["/Expr=sizes.size(), sizes.data()"]],
            ["int", "type", "", []],
        ], "", ""],

        // Extended Functions

        ["cv.Mat.makeInputArray", `${ shared_ptr }<_InputArray>`, ["/Call=this->createInputArray", `/Output=${ shared_ptr }<_InputArray>($0)`], [], "", ""],
        ["cv.Mat.makeOutputArray", `${ shared_ptr }<_OutputArray>`, ["/Call=this->createOutputArray", `/Output=${ shared_ptr }<_OutputArray>($0)`], [], "", ""],
        ["cv.Mat.makeInputOutputArray", `${ shared_ptr }<_InputOutputArray>`, ["/Call=this->createInputOutputArray", `/Output=${ shared_ptr }<_InputOutputArray>($0)`], [], "", ""],

        ["cv.Mat.convertToShow", "void", ["/Call=::autoit::cvextra::convertToShow", "/Expr=*__self->get(), $0"], [
            ["Mat", "dst", "Mat::zeros(__self->get()->rows, __self->get()->cols, CV_8UC3)", ["/IO"]],
            ["bool", "toRGB", "false", []],
        ], "", ""],
        ["cv.Mat.convertToBitmap", "void*", ["/Call=::autoit::cvextra::convertToBitmap", "/Expr=*__self->get(), $0"], [
            ["bool", "copy", "true", []],
        ], "", ""],
        ["cv.Mat.GdiplusResize", "void", ["/Call=::autoit::cvextra::GdiplusResize", "/Expr=*__self->get(), $0"], [
            ["Mat", "dst", "", ["/O"]],
            ["float", "newWidth", "", []],
            ["float", "newHeight", "", []],
            ["int", "interpolation", "7", []],
        ], "", ""],

        ["cv.Mat.createFromArray", "Mat", ["/External", "/S"], [
            ["_variant_t", "array", "", []],
            ["int", "depth", "-1", []],
        ], "", ""],

        ["cv.Mat.asArray", "_variant_t", ["/External"], [], "", ""],

        ["cv.Mat.PixelSearch", "_variant_t", ["/External"], [
            ["Scalar", "color", "", []],
            ["int", "left", "0", []],
            ["int", "top", "0", []],
            ["int", "right", "__self->get()->cols - 1", []],
            ["int", "bottom", "__self->get()->rows - 1", []],
            ["uchar", "shade_variation", "0", []],
            ["int", "step", "1", []],
        ], "", ""],

        ["cv.Mat.PixelSearch", "_variant_t", ["/External"], [
            ["Scalar", "color", "", []],
            ["Rect", "rect", "Rect(0, 0, __self->get()->cols, __self->get()->rows)", []],
            ["uchar", "shade_variation", "0", []],
            ["int", "step", "1", []],
        ], "", ""],

        ["cv.Mat.PixelChecksum", "size_t", ["/External"], [
            ["int", "left", "0", []],
            ["int", "top", "0", []],
            ["int", "right", "__self->get()->cols - 1", []],
            ["int", "bottom", "__self->get()->rows - 1", []],
            ["int", "step", "1", []],
            ["int", "mode", "0", []],
        ], "", ""],

        ["cv.Mat.PixelChecksum", "size_t", ["/External"], [
            ["Rect", "rect", "Rect(0, 0, __self->get()->cols, __self->get()->rows)", []],
            ["int", "step", "1", []],
            ["int", "mode", "0", []],
        ], "", ""],
    ];

    const types = new Set(["int", "float", "double"]);

    for (const _Tp of ["b", "s", "w"]) {
        for (const cn of [2, 3, 4]) { // eslint-disable-line no-magic-numbers
            types.add(`Vec${ cn }${ _Tp }`);
        }
    }

    for (const cn of [2, 3, 4, 6, 8]) { // eslint-disable-line no-magic-numbers
        types.add(`Vec${ cn }i`);
    }

    for (const _Tp of ["f", "d"]) {
        for (const cn of [2, 3, 4, 6]) { // eslint-disable-line no-magic-numbers
            types.add(`Vec${ cn }${ _Tp }`);
        }
    }

    for (const type of types) {
        if (type.startsWith("Vec")) {
            declarations.push(["cv.Mat.Mat", "", [`=createFrom${ type }`, "/Expr=$0, true"], [
                [type, "vec", "", []],
            ], "", ""]);
        }

        declarations.push(["cv.Mat.Mat", "", [`=createFromVectorOf${ type[0].toUpperCase() }${ type.slice(1) }`, "/Expr=$0, true"], [
            [`vector_${ type }`, "vec", "", []],
        ], "", ""]);
    }

    for (const args of [
        [
            ["int", "i0", "", []],
        ],
        [
            ["int", "row", "", []],
            ["int", "col", "", []],
        ],
        [
            ["int", "i0", "", []],
            ["int", "i1", "", []],
            ["int", "i2", "", []],
        ],
        [
            ["Point", "pt", "", []],
        ],
        [
            ["std::vector<int>", "idx", "", ["/Ref", "/C", "/Expr=idx.data()"]]
        ],
    ]) {
        declarations.push(...[
            ["cv.Mat.Point_at", "Point2d", ["/External"], args, "", ""],
            ["cv.Mat.at", "double", ["/External"], args, "", ""],
            ["cv.Mat.set_at", "void", ["/External"], args.concat([["double", "value", "", []]]), "", ""],
            ["cv.Mat.at", "double", ["/ExternalNoDecl", "/attr=propget", "=get_Item", "/idlname=Item", "/id=DISPID_VALUE"], args, "", ""],
            ["cv.Mat.set_at", "void", ["/ExternalNoDecl", "/attr=propput", "=put_Item", "/idlname=Item", "/id=DISPID_VALUE"], args.concat([["double", "value", "", []]]), "", ""],
        ]);

        const argexpr = args.map(([, callarg, , arg_modifiers]) => {
            for (const modifier of arg_modifiers) {
                if (modifier.startsWith("/Expr=")) {
                    callarg = modifier.slice("/Expr=".length);
                }
            }
            return callarg;
        }).join(", ");

        for (const type of types) {
            declarations.push(...[
                [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], args, "", ""],
                [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, `/Expr=${ argexpr }) = (value`], args.concat([[type, "value", "", []]]), "", ""],
            ]);
        }
    }

    return declarations;
};
