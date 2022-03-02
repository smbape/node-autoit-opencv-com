#include-once
#include "cv_interface.au3"
#include "cv_enums.au3"

Global $_cv_build_type = "Release"
Global $_cv_debug = 0

Global $h_opencv_world_dll = -1
Global $h_autoit_opencv_com_dll = -1

Func _OpenCV_ObjCreate($sClassname, $sFilename = Default)
	Local Static $s_autoit_opencv_com_dll = ""
	If $s_autoit_opencv_com_dll == "" Or $sFilename <> Default Then $s_autoit_opencv_com_dll = $sFilename
	If $sFilename == Default Then $sFilename = $s_autoit_opencv_com_dll

	Local Const $namespaces[3] = ["", "OpenCV.", "OpenCV.cv."]
	Local $siClassname, $oObj

	For $i = 0 To UBound($namespaces) -1
		$siClassname = $namespaces[$i] & $sClassname
		$oObj = ObjGet($s_autoit_opencv_com_dll, $siClassname)
		If IsObj($oObj) Then
			_OpenCV_DebugMsg("ObjCreate " & $siClassname)
			Return $oObj
		EndIf

		$oObj = ObjCreate($siClassname)
		If IsObj($oObj) Then
			_OpenCV_DebugMsg("ObjCreate " & $siClassname)
			Return $oObj
		EndIf
	Next

	Return $oObj
EndFunc   ;==>_OpenCV_ObjCreate

Func _OpenCV_get($vVal = Default)
	Local Static $cv = 0
	If $vVal <> Default Then
		$cv = $vVal
		Return $cv
	EndIf
	If IsObj($cv) Then Return $cv
	$cv = _OpenCV_ObjCreate("cv")
	Return $cv
EndFunc   ;==>_OpenCV_get

Func _OpenCV_Open_And_Register($s_opencv_wolrd_dll = Default, $s_autoit_opencv_com_dll = Default, $bUser = Default)
	If Not _OpenCV_Open($s_opencv_wolrd_dll, $s_autoit_opencv_com_dll) Then Return False
	If Not _Opencv_Register($bUser) Then Return False
	Return True
EndFunc   ;==>_OpenCV_Open_And_Register

Func _OpenCV_Unregister_And_Close($bUser = Default)
	If Not _Opencv_Unregister($bUser) Then Return False
	If Not _OpenCV_Close() Then Return False
	Return True
EndFunc   ;==>_OpenCV_Unregister_And_Close

Func _OpenCV_Install($s_opencv_wolrd_dll = Default, $s_autoit_opencv_com_dll = Default, $bUser = Default, $bOpen = True, $bClose = True, $bInstall = False, $bUninstall = False)
	If $s_opencv_wolrd_dll == Default Then $s_opencv_wolrd_dll = "opencv_world455.dll"
	If $s_autoit_opencv_com_dll == Default Then $s_autoit_opencv_com_dll = "autoit_opencv_com455.dll"
	If $bUser == Default Then $bUser = Not IsAdmin()

	If $bClose And $h_opencv_world_dll <> -1 Then DllClose($h_opencv_world_dll)
	If $bOpen Then
		$h_opencv_world_dll = _OpenCV_LoadDLL($s_opencv_wolrd_dll)
		If $h_opencv_world_dll == -1 Then Return False
	EndIf

	If $bClose And $h_autoit_opencv_com_dll <> -1 Then DllClose($h_autoit_opencv_com_dll)
	If $bOpen Then
		$h_autoit_opencv_com_dll = _OpenCV_LoadDLL($s_autoit_opencv_com_dll)
		If $h_autoit_opencv_com_dll == -1 Then Return False
		_OpenCV_ObjCreate("cv", $s_autoit_opencv_com_dll)
	EndIf

	Local $hresult

	If $bUninstall Then
		$hresult = _OpenCV_DllCall($h_autoit_opencv_com_dll, "long", "DllInstall", "bool", False, "wstr", $bUser ? "user" : "")
		If $hresult < 0 Then
			ConsoleWriteError('!>Error: DllInstall ' & $hresult & @CRLF)
			Return False
		EndIf
	EndIf

	If $bInstall Then
		$hresult = _OpenCV_DllCall($h_autoit_opencv_com_dll, "long", "DllInstall", "bool", True, "wstr", $bUser ? "user" : "")
		If $hresult < 0 Then
			ConsoleWriteError('!>Error: DllInstall ' & $hresult & @CRLF)
			Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>_OpenCV_Install

Func _OpenCV_Open($s_opencv_wolrd_dll = Default, $s_autoit_opencv_com_dll = Default)
	Return _OpenCV_Install($s_opencv_wolrd_dll, $s_autoit_opencv_com_dll)
EndFunc   ;==>_OpenCV_Open

Func _OpenCV_Close()
	_OpenCV_get(0)
	_OpenCV_ObjCreate("cv", "")
	Return _OpenCV_Install(Default, Default, Default, False)
EndFunc   ;==>_OpenCV_Close

Func _OpenCV_Register($bUser = Default)
	Return _OpenCV_Install(Default, Default, $bUser, False, False, True, False)
EndFunc   ;==>_OpenCV_Register

Func _OpenCV_Unregister($bUser = Default)
	Return _OpenCV_Install(Default, Default, $bUser, False, False, False, True)
EndFunc   ;==>_OpenCV_Unregister

Func _OpenCV_DebugMsg($msg)
	If BitAND($_cv_debug, 1) Then
		ConsoleWrite($msg & @CRLF)
	EndIf
	If BitAND($_cv_debug, 2) Then
		DllCall("kernel32.dll", "none", "OutputDebugString", "str", $msg)
	EndIf
EndFunc   ;==>_OpenCV_DebugMsg

Func _OpenCV_LoadDLL($dll)
	_OpenCV_DebugMsg('Loading ' & $dll)
	Local $result = DllOpen($dll)
	If @error Or $result == -1 Then
		ConsoleWriteError('!>Error: unable to load ' & $dll & @CRLF)
	EndIf
	_OpenCV_DebugMsg('Loaded ' & $dll)
	Return $result
EndFunc   ;==>_OpenCV_LoadDLL

Func _OpenCV_PrintDLLError($error, $sFunction = "function")
	Local $sMsg = ""

	Switch $error
		Case 1
			$sMsg = $sFunction & ': unable to use the DLL file'
		Case 2
			$sMsg = $sFunction & ': unknown "return type'
		Case 3
			$sMsg = '"' & $sFunction & '" not found in the DLL file'
		Case 4
			$sMsg = $sFunction & ': bad number of parameters'
		Case 5
			$sMsg = $sFunction & ': bad number of parameters'
		Case Else
			$sMsg = $sFunction & ': bad parameter'
	EndSwitch

	ConsoleWriteError('!>Error: ' & $sMsg & @CRLF)
EndFunc   ;==>_OpenCV_PrintDLLError


; Array.from(Array(30).keys()).map(i => `$type${ i + 1 } = Default, $param${ i + 1 } = Default`).join(", ")
Func _OpenCV_DllCall($dll, $return_type, $function, $type1 = Default, $param1 = Default, $type2 = Default, $param2 = Default, $type3 = Default, $param3 = Default, $type4 = Default, $param4 = Default, $type5 = Default, $param5 = Default, $type6 = Default, $param6 = Default, $type7 = Default, $param7 = Default, $type8 = Default, $param8 = Default, $type9 = Default, $param9 = Default, $type10 = Default, $param10 = Default, $type11 = Default, $param11 = Default, $type12 = Default, $param12 = Default, $type13 = Default, $param13 = Default, $type14 = Default, $param14 = Default, $type15 = Default, $param15 = Default, $type16 = Default, $param16 = Default, $type17 = Default, $param17 = Default, $type18 = Default, $param18 = Default, $type19 = Default, $param19 = Default, $type20 = Default, $param20 = Default, $type21 = Default, $param21 = Default, $type22 = Default, $param22 = Default, $type23 = Default, $param23 = Default, $type24 = Default, $param24 = Default, $type25 = Default, $param25 = Default, $type26 = Default, $param26 = Default, $type27 = Default, $param27 = Default, $type28 = Default, $param28 = Default, $type29 = Default, $param29 = Default, $type30 = Default, $param30 = Default)
	Local $_aResult

	_OpenCV_DebugMsg('Calling ' & $function)

	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ 5 + 2 * j }
	;     $_aResult = Call("DllCall", $dll, $return_type, $function, ${ Array.from(Array(j + 1).keys()).map(i => `$type${ i + 1 }, $param${ i + 1 }`).join(", ") })
	; `).join("\n"))
	Switch @NumParams
		Case 3
			$_aResult = Call("DllCall", $dll, $return_type, $function)
		Case 5
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1)
		Case 7
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2)
		Case 9
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3)
		Case 11
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4)
		Case 13
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5)
		Case 15
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6)
		Case 17
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7)
		Case 19
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8)
		Case 21
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9)
		Case 23
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10)
		Case 25
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11)
		Case 27
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12)
		Case 29
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13)
		Case 31
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14)
		Case 33
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15)
		Case 35
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16)
		Case 37
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17)
		Case 39
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18)
		Case 41
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19)
		Case 43
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20)
		Case 45
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21)
		Case 47
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22)
		Case 49
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23)
		Case 51
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24)
		Case 53
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25)
		Case 55
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26)
		Case 57
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27)
		Case 59
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28)
		Case 61
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28, $type29, $param29)
		Case 63
			$_aResult = Call("DllCall", $dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28, $type29, $param29, $type30, $param30)
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments for ' & $function)
			Return SetError(1, 0, -1)
	EndSwitch

	Local $error = @error

	_OpenCV_DebugMsg('Called ' & $function)

	If $error Then
		_OpenCV_PrintDLLError($error, $function)
		Return -1
	EndIf

	Return $_aResult[0]
EndFunc   ;==>_OpenCV_DllCall
