const {hasOwnProperty: hasProp} = Object.prototype;

const normalizeVectType = type => {
    return type.replace(/^const /, "").replace(/ *< */g, "<").replace(/ *> */g, ">");
};

const OVERRIDE_MAP = {
    cveImread(entry, declarations, destructors, options) {
        const args = entry[2];

        for (const arg of args) {
            const [, argName] = arg;

            if (argName === "result") {
                arg[2] = "Null";
                arg[3] = false;

                declarations.push(""); // new line
                declarations.push(...`
                    If $result == Null Then
                        $result = _cveMatCreate()
                    EndIf
                `.replace(/^ {20}/mg, "").trim().split("\n"));

                destructors.push("Return $result");
                destructors.unshift(""); // new line
            }
        }
    },
};

const DECLARATION_MAP = {
    "cv::String*": (autoItArgName, [argType, argName, defaultValue], declarations, destructors, entry, options) => {
        const capitalCasedName = argName[0].toUpperCase() + argName.slice(1);

        declarations.push(""); // new line
        declarations.push(...`
            Local $b${ capitalCasedName }IsString = IsString(${ autoItArgName })
            If $b${ capitalCasedName }IsString Then
                ${ autoItArgName } = _cveStringCreateFromStr(${ autoItArgName })
            EndIf
        `.replace(/^ {12}/mg, "").trim().split("\n"));

        destructors.unshift(...`
            If $b${ capitalCasedName }IsString Then
                _cveStringRelease(${ autoItArgName })
            EndIf
        `.replace(/^ {12}/mg, "").trim().split("\n"));
        destructors.unshift(""); // new line
    },

    vector: (autoItArgName, [argType, argName, defaultValue], declarations, destructors, entry, options) => {
        const {vectmap} = options;
        const isPointer = argType.endsWith("**");
        const vecttype = normalizeVectType(isPointer ? argType.slice(0, -1) : argType);

        if (!hasProp.call(vectmap, vecttype)) {
            console.log(entry[1], "cannot bind", argType);
            return null;
        }

        const method = vectmap[vecttype];
        const capitalCasedName = argName[0].toUpperCase() + argName.slice(1);
        const vector = `$vec${ capitalCasedName }`;
        const size = `$iArr${ capitalCasedName }Size`;

        declarations.push(""); // new line
        declarations.push(...`
            Local ${ vector }, ${ size }
            Local $b${ capitalCasedName }IsArray = IsArray(${ autoItArgName })

            If $b${ capitalCasedName }IsArray Then
                ${ vector } = _${ method }Create()

                ${ size } = UBound(${ autoItArgName })
                For $i = 0 To ${ size } - 1
                    _${ method }Push(${ vector }, ${ autoItArgName }[$i])
                Next
            Else
                ${ vector } = ${ autoItArgName }
            EndIf
        `.replace(/^ {12}/mg, "").trim().split("\n"));

        destructors.unshift(...`
            If $b${ capitalCasedName }IsArray Then
                _${ method }Release(${ vector })
            EndIf
        `.replace(/^ {12}/mg, "").trim().split("\n"));
        destructors.unshift(""); // new line

        return vector;
    },
};

const isEnum = (argType, options) => {
    argType = argType.replace("const ", "");

    return hasProp.call(options.enums, argType) || [
        "cv::cudacodec::SurfaceFormat",
        "cv::stereo::PropagationParameters",
        "tesseract::PageIteratorLevel",
        "tesseract::PageSegMode",
    ].indexOf(argType) !== -1;
};

const isPointer = (argType, options) => {
    argType = argType.replace("const ", "");

    return [
        "cv::_InputArray",
        "CvErrorCallback",
        "CvScalar",
        "CvSize",
        "emgu::DataCallback",
    ].indexOf(argType) !== -1;
};

module.exports = {
    exports: {
        start: "CVAPI(",
        end: ")",
    },
    cdecl: true,

    ifeval(input, pos) {
        return !input.startsWith("#if WINAPI_FAMILY", pos);
    },

    exported: {},

    defaults: {},

    isbyref(argType) {
        return argType !== "cv::String*" && argType.endsWith("*") && !argType.startsWith("const ");
    },

    overrides(...args) {
        const name = args[0][1];
        const options = args[3];
        options.exported[name] = 1;

        if (isEnum(args[0][0], options)) {
            args[0][0] = "int";
        } else if (isPointer(args[0][0], options)) {
            args[0][0] = "ptr";
        }

        if (hasProp.call(OVERRIDE_MAP, name)) {
            OVERRIDE_MAP[name](...args);
        }
    },

    dllvar: "$_h_cvextern_dll",

    retwrap(retval, [, name], options) {
        return `CVEDllCallResult(${ retval }, "${ name }", @error)`;
    },

    getAutoItDllType(autoItType, isNativeType, [argType, argName, defaultValue], [returnType, name, args], options) {
        if (isEnum(argType, options)) {
            argType = "int";
            autoItType = `"${ argType }"`;
            isNativeType = true;
        } else if (isPointer(argType, options)) {
            argType = "ptr";
            autoItType = `"${ argType }"`;
            isNativeType = false;
        }

        if (!isNativeType || !/^VectorOf\w+Push$/.test(name)) {
            return autoItType;
        }

        return `"${ argType }"`;
    },

    rettype(returnType, entry, options) {
        return `CVAPI(${ returnType })`;
    },

    declaration(...args) {
        const argType = args[1][0].replace("const ", "");

        if (hasProp.call(DECLARATION_MAP, argType)) {
            return DECLARATION_MAP[argType](...args);
        }

        if (/(?:const )?std::vector/.test(argType)) {
            return DECLARATION_MAP.vector(...args);
        }

        return null;
    },

    fnwrap(func, fnname, entry, options) {
        const [returnType, , args] = entry;
        const {isbyref} = options;

        const overridedFuncArgs = [];

        const matAutoItArgs = [];
        const matFuncArgs = [];

        const typedAutoItArgs = [];
        const typedDeclarations = [];
        const typedDestructors = [];

        for (const arg of args) {
            const [argType, argName, defaultValue, , canDefault] = arg;

            const autoItArgName = `$${ argName }`;
            matAutoItArgs.push(autoItArgName);

            let byRef = arg[3];
            if (byRef === undefined) {
                byRef = typeof isbyref === "function" ? isbyref(argType, arg, entry, options) : argType.endsWith("*") && !argType.startsWith("const ");
            }

            const match = /cv::_(Input|Output|InputOutput)Array\*/.exec(argType);

            if (match === null) {
                matFuncArgs.push(autoItArgName);
                overridedFuncArgs.push(autoItArgName);
                typedAutoItArgs.push(autoItArgName);

                if (canDefault !== false && defaultValue !== undefined) {
                    matAutoItArgs[matAutoItArgs.length - 1] += ` = ${ defaultValue === "_cveNoArray()" ? "_cveNoArrayMat()" : defaultValue }`;
                    typedAutoItArgs[typedAutoItArgs.length - 1] += ` = ${ defaultValue }`;
                }

                continue;
            }

            const capitalCasedName = argName[0].toUpperCase() + argName.slice(1);

            const arrType = match[1];
            const type = `$typeOf${ capitalCasedName }`;
            const vector = `$vector${ capitalCasedName }`;
            const size = `$iArr${ capitalCasedName }Size`;

            const ARRAY_PREFIXES = {
                Input: "iArr",
                Output: "oArr",
                InputOutput: "ioArr",
            };

            const overridedArg = `$${ ARRAY_PREFIXES[arrType] }${ capitalCasedName }`;

            typedAutoItArgs.push(type);
            typedAutoItArgs.push(autoItArgName);

            if (canDefault !== false && defaultValue === "_cveNoArray()") {
                matAutoItArgs[matAutoItArgs.length - 1] += ` = ${ defaultValue === "_cveNoArray()" ? "_cveNoArrayMat()" : defaultValue }`;
                typedAutoItArgs[typedAutoItArgs.length - 2] += " = Default";
                typedAutoItArgs[typedAutoItArgs.length - 1] += ` = ${ defaultValue }`;
            }

            matFuncArgs.push("\"Mat\"");
            matFuncArgs.push(autoItArgName);

            overridedFuncArgs.push(overridedArg);

            typedDeclarations.push(""); // new line
            typedDeclarations.push(...`
                Local ${ overridedArg }, ${ vector }, ${ size }
                Local $b${ capitalCasedName }IsArray = IsArray(${ autoItArgName })
                Local $b${ capitalCasedName }Create = IsDllStruct(${ autoItArgName }) And ${ type } == "Scalar"

                If ${ type } == Default Then
                    ${ overridedArg } = ${ autoItArgName }
                ElseIf $b${ capitalCasedName }IsArray Then
                    ${ vector } = Call("_VectorOf" & ${ type } & "Create")

                    ${ size } = UBound(${ autoItArgName })
                    For $i = 0 To ${ size } - 1
                        Call("_VectorOf" & ${ type } & "Push", ${ vector }, ${ autoItArgName }[$i])
                    Next

                    ${ overridedArg } = Call("_cve${ arrType }ArrayFromVectorOf" & ${ type }, ${ vector })
                Else
                    If $b${ capitalCasedName }Create Then
                        ${ autoItArgName } = Call("_cve" & ${ type } & "Create", ${ autoItArgName })
                    EndIf
                    ${ overridedArg } = Call("_cve${ arrType }ArrayFrom" & ${ type }, ${ autoItArgName })
                EndIf
            `.replace(/^ {16}/mg, "").trim().split("\n"));

            typedDestructors.unshift(...`
                If $b${ capitalCasedName }IsArray Then
                    Call("_VectorOf" & ${ type } & "Release", ${ vector })
                EndIf

                If ${ type } <> Default Then
                    _cve${ arrType }ArrayRelease(${ overridedArg })
                    If $b${ capitalCasedName }Create Then
                        Call("_cve" & ${ type } & "Release", ${ autoItArgName })
                    EndIf
                EndIf
            `.replace(/^ {16}/mg, "").trim().split("\n"));
            typedDestructors.unshift(""); // new line
        }

        if (typedDeclarations.length === 0) {
            return func;
        }

        const indent = " ".repeat(16);
        const retval = returnType === "void" ? "" : "Local $retval = ";
        const ret = returnType === "void" ? "" : `\n\n${ indent }Return $retval`;

        const typedBody = [];
        typedBody.push(...typedDeclarations);
        typedBody.push(""); // new line
        typedBody.push(`${ retval }_${ fnname }(${ overridedFuncArgs.join(", ") })`);
        typedBody.push(...typedDestructors);

        const typedFunc = `
            Func _${ fnname }Typed(${ typedAutoItArgs.join(", ") })
                ${ typedBody.join(`\n${ indent }`) }${ ret }
            EndFunc   ;==>_${ fnname }Typed
        `.replace(/^ {12}/mg, "").trim();

        const matBody = [];
        matBody.push(`; ${ fnname } using cv::Mat instead of _*Array`);
        matBody.push(`${ retval }_${ fnname }Typed(${ matFuncArgs.join(", ") })`);

        const matFunc = `
            Func _${ fnname }Mat(${ matAutoItArgs.join(", ") })
                ${ matBody.join(`\n${ indent }`) }${ ret }
            EndFunc   ;==>_${ fnname }Mat
        `.replace(/^ {12}/mg, "").trim();

        return `${ func }\n\n${ typedFunc }\n\n${ matFunc }`;
    }
};
