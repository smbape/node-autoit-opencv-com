#include-once
#include <File.au3>
#include "cv_interface.au3"
#include "cv_enums.au3"

Global $h_opencv_world_dll = -1
Global $h_opencv_ffmpeg_dll = -1
Global $h_autoit_opencv_com_dll = -1

Func _OpenCV_ObjCreate($sClassname)
	_OpenCV_ActivateManifest()

	Local Static $namespaces[] = ["", "OpenCV.", "OpenCV.cv.", "OpenCV.com.", "OpenCV.std."]
	Local $siClassname, $oObj

	For $i = 0 To UBound($namespaces) - 1
		$siClassname = $namespaces[$i] & $sClassname
		_OpenCV_DebugMsg("Try ObjCreate " & $siClassname)

		$oObj = ObjCreate($siClassname)
		If IsObj($oObj) Then
			_OpenCV_DebugMsg("ObjCreate " & $siClassname)
			ExitLoop
		EndIf
	Next

	_OpenCV_DeactivateActCtx()
	Return $oObj
EndFunc   ;==>_OpenCV_ObjCreate

Func _OpenCV_get($vVal = Default)
	Local Static $cv = 0

	If $vVal <> Default Then
		Local $prevVal = $cv
		$cv = $vVal
		Return $prevVal
	EndIf

	If IsObj($cv) Then Return $cv
	$cv = _OpenCV_ObjCreate("cv")

	; https://stackoverflow.com/questions/63110817/how-to-ensure-that-gpu-memory-is-actually-deallocated-after-an-opencv-t-api-func
	; It seems that an allocation flushes the cleanup queue!
	If IsObj($cv) Then $cv.UMat.zeros(1, 1, $CV_8UC1)

	$cv.samples.addSamplesDataSearchPath(@ScriptDir)

	Local $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")
	If FileExists($OPENCV_SAMPLES_DATA_PATH) Then
		$cv.samples.addSamplesDataSearchPath($OPENCV_SAMPLES_DATA_PATH)
	EndIf

	$OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data", Default, Default, Default, _OpenCV_Tuple( _
			"opencv\sources", _
			"opencv-4.12.0-*\sources", _
			"opencv-4.12.0-*\opencv\sources" _
			))
	If FileExists($OPENCV_SAMPLES_DATA_PATH) Then
		$cv.samples.addSamplesDataSearchPath($OPENCV_SAMPLES_DATA_PATH)
	EndIf

	Return $cv
EndFunc   ;==>_OpenCV_get

Func _OpenCV_Open_And_Register($s_opencv_world_dll = Default, $s_autoit_opencv_com_dll = Default, $bUser = Default)
	If Not _OpenCV_Open($s_opencv_world_dll, $s_autoit_opencv_com_dll) Then Return False
	If Not _OpenCV_Register($bUser) Then Return False
	Return True
EndFunc   ;==>_OpenCV_Open_And_Register

Func _OpenCV_Unregister_And_Close($bUser = Default)
	If Not _OpenCV_Unregister($bUser) Then Return False
	If Not _OpenCV_Close() Then Return False
	Return True
EndFunc   ;==>_OpenCV_Unregister_And_Close

Func _OpenCV_Install($s_opencv_world_dll = Default, $s_autoit_opencv_com_dll = Default, $bUser = Default, $bOpen = True, $bClose = True, $bInstall = False, $bUninstall = False)
	If $s_opencv_world_dll == Default Then $s_opencv_world_dll = "opencv_world4120.dll"
	If $s_autoit_opencv_com_dll == Default Then $s_autoit_opencv_com_dll = "autoit_opencv_com4120.dll"
	If $bUser == Default Then $bUser = Not IsAdmin()

	If $bClose And $h_opencv_world_dll <> -1 Then DllClose($h_opencv_world_dll)
	If $bOpen Then
		$h_opencv_world_dll = _OpenCV_LoadDLL($s_opencv_world_dll)
		If $h_opencv_world_dll == -1 Then Return SetError(@error, 0, False)
	EndIf

	; ffmpeg is looked on PATH when loaded in debug mode, not relatively to opencv_world4120d.dll
	; this is a work around to load ffmpeg relatively to opencv_world4120d.dll
	If $bClose And $h_opencv_ffmpeg_dll <> -1 Then DllClose($h_opencv_ffmpeg_dll)
	If $bOpen And EnvGet("OPENCV_BUILD_TYPE") == "Debug" Then
		$h_opencv_ffmpeg_dll = _OpenCV_LoadDLL(StringReplace($s_opencv_world_dll, "opencv_world4120d.dll", "opencv_videoio_ffmpeg4120_64.dll"))
		If $h_opencv_ffmpeg_dll == -1 Then Return SetError(@error, 0, False)
	EndIf

	If $bClose Then
		If $h_autoit_opencv_com_dll <> -1 Then
			DllClose($h_autoit_opencv_com_dll)
			$h_autoit_opencv_com_dll = -1
		EndIf
	EndIf

	If $bOpen Then
		$h_autoit_opencv_com_dll = _OpenCV_LoadDLL($s_autoit_opencv_com_dll)
		If $h_autoit_opencv_com_dll == -1 Then Return SetError(@error, 0, False)
	EndIf

	Local $hresult

	If $bUninstall Then
		$hresult = _OpenCV_DllCall($h_autoit_opencv_com_dll, "long", "DllInstall", "bool", False, "wstr", $bUser ? "user" : "")
		If $hresult < 0 Then
			ConsoleWriteError('!>Error: DllInstall(false, "' & ($bUser ? "user" : "") & '") 0x' & Hex($hresult) & @CRLF)
			Return SetError(1, 0, False)
		EndIf
	EndIf

	If $bInstall Then
		$hresult = _OpenCV_DllCall($h_autoit_opencv_com_dll, "long", "DllInstall", "bool", True, "wstr", $bUser ? "user" : "")
		If $hresult < 0 Then
			ConsoleWriteError('!>Error: DllInstall(true, "' & ($bUser ? "user" : "") & '") 0x' & Hex($hresult) & @CRLF)
			Return SetError(1, 0, False)
		EndIf
	EndIf

	Return True
EndFunc   ;==>_OpenCV_Install

Func _OpenCV_Open($s_opencv_world_dll = Default, $s_autoit_opencv_com_dll = Default)
	Return _OpenCV_Install($s_opencv_world_dll, $s_autoit_opencv_com_dll)
EndFunc   ;==>_OpenCV_Open

Func _OpenCV_Close()
	Local Const $cv = _OpenCV_get(0)

	; https://stackoverflow.com/questions/63110817/how-to-ensure-that-gpu-memory-is-actually-deallocated-after-an-opencv-t-api-func
	; It seems that an allocation flushes the cleanup queue!
	If IsObj($cv) Then $cv.UMat.zeros(1, 1, $CV_8UC1)

	Return _OpenCV_Install(Default, Default, Default, False)
EndFunc   ;==>_OpenCV_Close

Func _OpenCV_Register($bUser = Default)
	Return _OpenCV_Install(Default, Default, $bUser, False, False, True, False)
EndFunc   ;==>_OpenCV_Register

Func _OpenCV_Unregister($bUser = Default)
	Return _OpenCV_Install(Default, Default, $bUser, False, False, False, True)
EndFunc   ;==>_OpenCV_Unregister

Func _OpenCV_ActivateManifest($sManifest = Default)
	If $sManifest == Default Then $sManifest = EnvGet("OPENCV_ACTCTX_MANIFEST")
	Return _OpenCV_DllCall($h_autoit_opencv_com_dll, "BOOL", "DllActivateManifest", "wstr", $sManifest)
EndFunc   ;==>_OpenCV_ActivateManifest

Func _OpenCV_DeactivateActCtx()
	Return _OpenCV_DllCall($h_autoit_opencv_com_dll, "BOOL", "DllDeactivateActCtx")
EndFunc   ;==>_OpenCV_DeactivateActCtx

Func _OpenCV_FindFiles($aParts, $sDir = Default, $iFlag = Default, $bReturnPath = Default, $bReverse = Default)
	If $sDir == Default Then $sDir = @ScriptDir
	If $iFlag == Default Then $iFlag = $FLTA_FILESFOLDERS
	If $bReturnPath == Default Then $bReturnPath = False
	If $bReverse == Default Then $bReverse = False

	If IsString($aParts) Then
		$aParts = StringSplit($aParts, "\", $STR_NOCOUNT)
	EndIf

	Local $aMatches[0]
	Local $bFound = False
	Local $aNextParts[0]
	Local $aFileList[0]
	Local $aNextFileList[0]
	Local $iParts = UBound($aParts)
	Local $iLen = StringLen($sDir)
	Local $iLastPart = $iParts - 1, $iFound = 0, $iNextFound = 0, $sPath = "", $iiFlags = 0

	For $i = 0 To $iLastPart
		$bFound = False

		If ($iFlag == $FLTA_FILESFOLDERS Or $i <> $iLastPart) And StringInStr($aParts[$i], "?") == 0 And StringInStr($aParts[$i], "*") == 0 Then
			_OpenCV_DebugMsg("Looking for " & $sDir & "\" & $aParts[$i])
			$bFound = FileExists($sDir & "\" & $aParts[$i])
			If Not $bFound Then
				ExitLoop
			EndIf

			$sDir &= "\" & $aParts[$i]
			ContinueLoop
		EndIf

		_OpenCV_DebugMsg("Listing " & $sDir & "\=" & $aParts[$i])
		$iiFlags = $i == $iLastPart ? $iFlag : $FLTA_FILESFOLDERS

		$aFileList = _FileListToArray($sDir, $aParts[$i], $iiFlags, $bReturnPath)
		If @error Then ExitLoop

		If $i == $iLastPart Then
			ReDim $aMatches[$aFileList[0]]

			For $j = 1 To $aFileList[0]
				$sPath = $aFileList[$j]
				If Not $bReturnPath Then
					$sPath = $sDir & "\" & $sPath
					$sPath = StringRight($sPath, StringLen($sPath) - $iLen - 1)
				EndIf
				$aMatches[$j - 1] = $sPath
			Next

			If $bReverse Then _ArrayReverse($aMatches)
			Return $aMatches
		EndIf

		ReDim $aNextParts[$iParts - $i - 1]
		For $j = $i + 1 To $iLastPart
			$aNextParts[$j - $i - 1] = $aParts[$j]
		Next

		For $j = 1 To $aFileList[0]
			$sPath = $aFileList[$j]
			If Not $bReturnPath Then
				$sPath = $sDir & "\" & $sPath
			EndIf

			$aNextFileList = _OpenCV_FindFiles($aNextParts, $sPath, $iFlag, $bReturnPath, $bReverse)
			$iNextFound = UBound($aNextFileList)

			If $iNextFound <> 0 Then
				ReDim $aMatches[$iFound + $iNextFound]
				For $k = 0 To $iNextFound - 1
					$sPath = $aNextFileList[$k]
					If Not $bReturnPath Then
						$sPath = $sDir & "\" & $aFileList[$j] & "\" & $sPath
						$sPath = StringRight($sPath, StringLen($sPath) - $iLen - 1)
					EndIf
					$aMatches[$iFound + $k] = $sPath
				Next
				$iFound += $iNextFound
			EndIf
		Next

		If $bReverse Then _ArrayReverse($aMatches)
		Return $aMatches
	Next

	If $bFound Then
		ReDim $aMatches[1]

		If Not $bReturnPath Then
			$sDir = StringRight($sDir, StringLen($sDir) - $iLen - 1)
		EndIf

		_OpenCV_DebugMsg("Found " & $sDir)
		$aMatches[0] = $sDir
	EndIf

	SetError(@error)

	If $bReverse Then _ArrayReverse($aMatches)
	Return $aMatches
EndFunc   ;==>_OpenCV_FindFiles

Func _OpenCV_FindFile($sFile, $sFilter = Default, $sDir = Default, $iFlag = Default, $aSearchPaths = Default, $bReverse = Default)
	If $sFilter == Default Then $sFilter = ""
	If $sDir == Default Then $sDir = @ScriptDir
	If $aSearchPaths == Default Then $aSearchPaths = _OpenCV_Tuple(1, ".")

	_OpenCV_DebugMsg("_OpenCV_FindFile('" & $sFile & "', '" & $sFilter & "', '" & $sDir & "') " & VarGetType($aSearchPaths))

	Local $sFound = "", $sPath, $aFileList
	Local $sDrive = "", $sFileName = "", $sExtension = ""

	Local $iSearchStart, $iSearchEnd
	If IsNumber($aSearchPaths[0]) Then
		$iSearchStart = 1
		$iSearchEnd = $aSearchPaths[0]
	Else
		$iSearchStart = 0
		$iSearchEnd = UBound($aSearchPaths) - 1
	EndIf

	Local $aFilters[1]
	If IsArray($sFilter) Then
		$aFilters = $sFilter
	Else
		$aFilters[0] = $sFilter
	EndIf

	While 1
		For $sFilter In $aFilters
			For $i = $iSearchStart To $iSearchEnd
				$sPath = ""

				If $sFilter <> "" Then
					$sPath = $sFilter
				EndIf

				If StringCompare($aSearchPaths[$i], ".") <> 0 Then
					If $sPath == "" Then
						$sPath = $aSearchPaths[$i]
					Else
						$sPath &= "\" & $aSearchPaths[$i]
					EndIf
				EndIf

				If $sPath == "" Then
					$sPath = $sFile
				Else
					$sPath &= "\" & $sFile
				EndIf

				$aFileList = _OpenCV_FindFiles($sPath, $sDir, $iFlag, True, $bReverse)
				$sFound = UBound($aFileList) == 0 ? "" : $aFileList[0]

				If $sFound <> "" Then
					_OpenCV_DebugMsg("Found " & $sFound & @CRLF)
					ExitLoop 3
				EndIf
			Next

			_PathSplit($sDir, $sDrive, $sDir, $sFileName, $sExtension)
			If $sDir == "" Then
				ExitLoop 2
			EndIf
			$sDir = $sDrive & StringLeft($sDir, StringLen($sDir) - 1)
		Next
	WEnd

	Return $sFound
EndFunc   ;==>_OpenCV_FindFile

Func _OpenCV_DebugMsg($msg)
	Local $_cv_debug = Number(EnvGet("OPENCV_DEBUG"))
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
	Return SetError($result == -1 ? 1 : 0, 0, $result)
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
	;     $_aResult = DllCall($dll, $return_type, $function, ${ Array.from(Array(j + 1).keys()).map(i => `$type${ i + 1 }, $param${ i + 1 }`).join(", ") })
	; `).join("\n"))
	Switch @NumParams
		Case 3
			$_aResult = DllCall($dll, $return_type, $function)
		Case 5
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1)
		Case 7
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2)
		Case 9
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3)
		Case 11
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4)
		Case 13
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5)
		Case 15
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6)
		Case 17
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7)
		Case 19
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8)
		Case 21
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9)
		Case 23
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10)
		Case 25
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11)
		Case 27
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12)
		Case 29
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13)
		Case 31
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14)
		Case 33
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15)
		Case 35
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16)
		Case 37
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17)
		Case 39
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18)
		Case 41
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19)
		Case 43
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20)
		Case 45
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21)
		Case 47
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22)
		Case 49
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23)
		Case 51
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24)
		Case 53
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25)
		Case 55
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26)
		Case 57
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27)
		Case 59
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28)
		Case 61
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28, $type29, $param29)
		Case 63
			$_aResult = DllCall($dll, $return_type, $function, $type1, $param1, $type2, $param2, $type3, $param3, $type4, $param4, $type5, $param5, $type6, $param6, $type7, $param7, $type8, $param8, $type9, $param9, $type10, $param10, $type11, $param11, $type12, $param12, $type13, $param13, $type14, $param14, $type15, $param15, $type16, $param16, $type17, $param17, $type18, $param18, $type19, $param19, $type20, $param20, $type21, $param21, $type22, $param22, $type23, $param23, $type24, $param24, $type25, $param25, $type26, $param26, $type27, $param27, $type28, $param28, $type29, $param29, $type30, $param30)
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments for ' & $function & @CRLF)
			Return SetError(1, 0, -1)
	EndSwitch

	Local $error = @error
	Local $extended = @extended

	_OpenCV_DebugMsg('Called ' & $function)

	If $error Then
		_OpenCV_PrintDLLError($error, $function)
		Return SetError($error, $extended, -1)
	EndIf

	Return $_aResult[0]
EndFunc   ;==>_OpenCV_DllCall

; Array.from(Array(30).keys()).map(i => `$val${ i } = 0`).join(", ")
Func _OpenCV_Tuple($val0 = 0, $val1 = 0, $val2 = 0, $val3 = 0, $val4 = 0, $val5 = 0, $val6 = 0, $val7 = 0, $val8 = 0, $val9 = 0, $val10 = 0, $val11 = 0, $val12 = 0, $val13 = 0, $val14 = 0, $val15 = 0, $val16 = 0, $val17 = 0, $val18 = 0, $val19 = 0, $val20 = 0, $val21 = 0, $val22 = 0, $val23 = 0, $val24 = 0, $val25 = 0, $val26 = 0, $val27 = 0, $val28 = 0, $val29 = 0)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ j + 1 }
	;     Local $_aResult[@NumParams] = [${ Array.from(Array(j + 1).keys()).map(i => `$val${ i }`).join(", ") }]
	;     Return $_aResult
	; `.trim()).join("\n"))
	Switch @NumParams
		Case 0
			Local $_aResult[0] = []
			Return $_aResult
		Case 1
			Local $_aResult[@NumParams] = [$val0]
			Return $_aResult
		Case 2
			Local $_aResult[@NumParams] = [$val0, $val1]
			Return $_aResult
		Case 3
			Local $_aResult[@NumParams] = [$val0, $val1, $val2]
			Return $_aResult
		Case 4
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3]
			Return $_aResult
		Case 5
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4]
			Return $_aResult
		Case 6
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5]
			Return $_aResult
		Case 7
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6]
			Return $_aResult
		Case 8
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7]
			Return $_aResult
		Case 9
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8]
			Return $_aResult
		Case 10
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9]
			Return $_aResult
		Case 11
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10]
			Return $_aResult
		Case 12
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11]
			Return $_aResult
		Case 13
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12]
			Return $_aResult
		Case 14
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13]
			Return $_aResult
		Case 15
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14]
			Return $_aResult
		Case 16
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15]
			Return $_aResult
		Case 17
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16]
			Return $_aResult
		Case 18
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17]
			Return $_aResult
		Case 19
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18]
			Return $_aResult
		Case 20
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19]
			Return $_aResult
		Case 21
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20]
			Return $_aResult
		Case 22
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21]
			Return $_aResult
		Case 23
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22]
			Return $_aResult
		Case 24
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23]
			Return $_aResult
		Case 25
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24]
			Return $_aResult
		Case 26
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24, $val25]
			Return $_aResult
		Case 27
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24, $val25, $val26]
			Return $_aResult
		Case 28
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24, $val25, $val26, $val27]
			Return $_aResult
		Case 29
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24, $val25, $val26, $val27, $val28]
			Return $_aResult
		Case 30
			Local $_aResult[@NumParams] = [$val0, $val1, $val2, $val3, $val4, $val5, $val6, $val7, $val8, $val9, $val10, $val11, $val12, $val13, $val14, $val15, $val16, $val17, $val18, $val19, $val20, $val21, $val22, $val23, $val24, $val25, $val26, $val27, $val28, $val29]
			Return $_aResult
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments' & @CRLF)
			Return SetError(1, 0, -1)
	EndSwitch
EndFunc   ;==>_OpenCV_Tuple

; Array.from(Array(30).keys()).map(i => `$sKey${ i + 1 } = Default, $vVal${ i + 1 } = Default`).join(", ")
Func _OpenCV_Params($sKey1 = Default, $vVal1 = Default, $sKey2 = Default, $vVal2 = Default, $sKey3 = Default, $vVal3 = Default, $sKey4 = Default, $vVal4 = Default, $sKey5 = Default, $vVal5 = Default, $sKey6 = Default, $vVal6 = Default, $sKey7 = Default, $vVal7 = Default, $sKey8 = Default, $vVal8 = Default, $sKey9 = Default, $vVal9 = Default, $sKey10 = Default, $vVal10 = Default, $sKey11 = Default, $vVal11 = Default, $sKey12 = Default, $vVal12 = Default, $sKey13 = Default, $vVal13 = Default, $sKey14 = Default, $vVal14 = Default, $sKey15 = Default, $vVal15 = Default, $sKey16 = Default, $vVal16 = Default, $sKey17 = Default, $vVal17 = Default, $sKey18 = Default, $vVal18 = Default, $sKey19 = Default, $vVal19 = Default, $sKey20 = Default, $vVal20 = Default, $sKey21 = Default, $vVal21 = Default, $sKey22 = Default, $vVal22 = Default, $sKey23 = Default, $vVal23 = Default, $sKey24 = Default, $vVal24 = Default, $sKey25 = Default, $vVal25 = Default, $sKey26 = Default, $vVal26 = Default, $sKey27 = Default, $vVal27 = Default, $sKey28 = Default, $vVal28 = Default, $sKey29 = Default, $vVal29 = Default, $sKey30 = Default, $vVal30 = Default)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ 2 * (j + 1) }
	;     Return $NamedParameters.create(_OpenCV_Tuple(${ Array.from(Array(j + 1).keys()).map(i => `_OpenCV_Tuple($sKey${ i + 1 }, $vVal${ i + 1 })`).join(", ") }))
	; `.trim()).join("\n"))
	Local Static $NamedParameters = _OpenCV_ObjCreate("NamedParameters")
	Switch @NumParams
		Case 2
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1)))
		Case 4
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2)))
		Case 6
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3)))
		Case 8
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4)))
		Case 10
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5)))
		Case 12
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6)))
		Case 14
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7)))
		Case 16
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8)))
		Case 18
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9)))
		Case 20
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10)))
		Case 22
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11)))
		Case 24
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12)))
		Case 26
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13)))
		Case 28
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14)))
		Case 30
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15)))
		Case 32
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16)))
		Case 34
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17)))
		Case 36
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18)))
		Case 38
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19)))
		Case 40
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20)))
		Case 42
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21)))
		Case 44
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22)))
		Case 46
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23)))
		Case 48
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24)))
		Case 50
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25)))
		Case 52
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26)))
		Case 54
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27)))
		Case 56
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28)))
		Case 58
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28), _OpenCV_Tuple($sKey29, $vVal29)))
		Case 60
			Return $NamedParameters.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28), _OpenCV_Tuple($sKey29, $vVal29), _OpenCV_Tuple($sKey30, $vVal30)))
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments' & @CRLF)
			Return SetError(1, 0, -1)
	EndSwitch
EndFunc   ;==>_OpenCV_Params

; Array.from(Array(30).keys()).map(i => `$sKey${ i + 1 } = Default, $vVal${ i + 1 } = Default`).join(", ")
Func _OpenCV_Map($sKeyType, $sValueType, $sKey1 = Default, $vVal1 = Default, $sKey2 = Default, $vVal2 = Default, $sKey3 = Default, $vVal3 = Default, $sKey4 = Default, $vVal4 = Default, $sKey5 = Default, $vVal5 = Default, $sKey6 = Default, $vVal6 = Default, $sKey7 = Default, $vVal7 = Default, $sKey8 = Default, $vVal8 = Default, $sKey9 = Default, $vVal9 = Default, $sKey10 = Default, $vVal10 = Default, $sKey11 = Default, $vVal11 = Default, $sKey12 = Default, $vVal12 = Default, $sKey13 = Default, $vVal13 = Default, $sKey14 = Default, $vVal14 = Default, $sKey15 = Default, $vVal15 = Default, $sKey16 = Default, $vVal16 = Default, $sKey17 = Default, $vVal17 = Default, $sKey18 = Default, $vVal18 = Default, $sKey19 = Default, $vVal19 = Default, $sKey20 = Default, $vVal20 = Default, $sKey21 = Default, $vVal21 = Default, $sKey22 = Default, $vVal22 = Default, $sKey23 = Default, $vVal23 = Default, $sKey24 = Default, $vVal24 = Default, $sKey25 = Default, $vVal25 = Default, $sKey26 = Default, $vVal26 = Default, $sKey27 = Default, $vVal27 = Default, $sKey28 = Default, $vVal28 = Default, $sKey29 = Default, $vVal29 = Default, $sKey30 = Default, $vVal30 = Default)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ 2 * (j + 1) + 2 }
	;     Return $MapType.create(_OpenCV_Tuple(${ Array.from(Array(j + 1).keys()).map(i => `_OpenCV_Tuple($sKey${ i + 1 }, $vVal${ i + 1 })`).join(", ") }))
	; `.trim()).join("\n"))
	Local $MapType = _OpenCV_ObjCreate("MapOf" & $sKeyType & "And" & $sValueType)
	Switch @NumParams
		Case 4
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1)))
		Case 6
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2)))
		Case 8
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3)))
		Case 10
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4)))
		Case 12
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5)))
		Case 14
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6)))
		Case 16
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7)))
		Case 18
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8)))
		Case 20
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9)))
		Case 22
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10)))
		Case 24
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11)))
		Case 26
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12)))
		Case 28
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13)))
		Case 30
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14)))
		Case 32
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15)))
		Case 34
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16)))
		Case 36
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17)))
		Case 38
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18)))
		Case 40
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19)))
		Case 42
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20)))
		Case 44
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21)))
		Case 46
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22)))
		Case 48
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23)))
		Case 50
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24)))
		Case 52
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25)))
		Case 54
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26)))
		Case 56
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27)))
		Case 58
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28)))
		Case 60
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28), _OpenCV_Tuple($sKey29, $vVal29)))
		Case 62
			Return $MapType.create(_OpenCV_Tuple(_OpenCV_Tuple($sKey1, $vVal1), _OpenCV_Tuple($sKey2, $vVal2), _OpenCV_Tuple($sKey3, $vVal3), _OpenCV_Tuple($sKey4, $vVal4), _OpenCV_Tuple($sKey5, $vVal5), _OpenCV_Tuple($sKey6, $vVal6), _OpenCV_Tuple($sKey7, $vVal7), _OpenCV_Tuple($sKey8, $vVal8), _OpenCV_Tuple($sKey9, $vVal9), _OpenCV_Tuple($sKey10, $vVal10), _OpenCV_Tuple($sKey11, $vVal11), _OpenCV_Tuple($sKey12, $vVal12), _OpenCV_Tuple($sKey13, $vVal13), _OpenCV_Tuple($sKey14, $vVal14), _OpenCV_Tuple($sKey15, $vVal15), _OpenCV_Tuple($sKey16, $vVal16), _OpenCV_Tuple($sKey17, $vVal17), _OpenCV_Tuple($sKey18, $vVal18), _OpenCV_Tuple($sKey19, $vVal19), _OpenCV_Tuple($sKey20, $vVal20), _OpenCV_Tuple($sKey21, $vVal21), _OpenCV_Tuple($sKey22, $vVal22), _OpenCV_Tuple($sKey23, $vVal23), _OpenCV_Tuple($sKey24, $vVal24), _OpenCV_Tuple($sKey25, $vVal25), _OpenCV_Tuple($sKey26, $vVal26), _OpenCV_Tuple($sKey27, $vVal27), _OpenCV_Tuple($sKey28, $vVal28), _OpenCV_Tuple($sKey29, $vVal29), _OpenCV_Tuple($sKey30, $vVal30)))
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments' & @CRLF)
			Return SetError(1, 0, -1)
	EndSwitch
EndFunc   ;==>_OpenCV_Map
