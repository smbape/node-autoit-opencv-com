const genFunc = (libname, fname, args) => {
    return `
Func _${ libname }_${ fname }(${ args.map(([argname, , defval]) => `$${ argname }${ defval == null ? "" : " = Default" }`).join(", ") })
    Local Static $NamedParameters = _${ libname }_ObjCreate("NamedParameters")

    Local $kwargs = Default
    Switch @NumParams
        ${ args.map(([argname], i) => `
            Case ${ i + 1 }
                $kwargs = $NamedParameters.isNamedParameters($${ argname }) ? $${ argname } : Default
        `.replace(/^ {4}/mg, "").trim()).join(`\n${ " ".repeat(8) }`) }
    EndSwitch

    Local $has_kwarg = $kwargs <> Default
    If $kwargs == Default Then $kwargs = $NamedParameters
    Local $usedkw = 0

    ${ args.map(([argname, kwname, defval], i) => `
        ; get argument ${ kwname || argname }
        If (Not $has_kwarg) Or @NumParams > ${ i + 1 } Then
            ; positional parameter should not be a named parameter
            If $has_kwarg And $kwargs.count("${ kwname || argname }") Then
                ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : ${ kwname || argname } was both specified as a Positional and NamedParameter' & @CRLF)
                Exit(1)
            EndIf
        Else
            ; named parameter
            If $kwargs.has("${ kwname || argname }") Then
                $${ argname } = $kwargs.Item("${ kwname || argname }")
                $usedkw += 1
            EndIf
        EndIf
        ${ defval == null || defval === "Default" ? "" : `If $${ argname } == Default Then $${ argname } = ${ defval }` }
    `.replace(/^ {4}/mg, "").trim()).join(`\n\n${ " ".repeat(4) }`) }

    If $usedkw <> $kwargs.size() Then
        ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
        Exit (1)
    EndIf

    ; ... YOUR CODE HERE
EndFunc   ;==>_${ libname }_${ fname }
`.trim();
};

const [,, libname, fname, ...args] = process.argv;

// eslint-disable-next-line no-eval
console.log(genFunc(libname, fname, args.map(arg => eval(arg))));
