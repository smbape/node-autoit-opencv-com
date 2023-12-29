#include-once

Global $h_addon_dll = -1

Func _Addon_DLLOpen($s_addon_dll)
	$h_addon_dll = _OpenCV_LoadDLL($s_addon_dll)
	Return $h_addon_dll <> -1
EndFunc   ;==>_Addon_DLLOpen

Func _Addon_DLLClose()
	If $h_addon_dll == -1 Then Return False
	DllClose($h_addon_dll)
	$h_addon_dll = -1
EndFunc   ;==>_Addon_DLLClose

Func _Addon_FindDLL($sFile = Default, $sFilter = Default, $sDir = Default, $bReverse = Default)
	If $sFile == Default Then $sFile = "autoit_addon490*"
	Local $_cv_build_type = EnvGet("OPENCV_BUILD_TYPE")
	Local $sBuildType = $_cv_build_type == "Debug" ? "Debug" : "Release"
	Local $sPostfix = $_cv_build_type == "Debug" ? "d" : ""

	Local $aSearchPaths[] = [ _
			".", _
			"autoit-addon", _
			"autoit-opencv-com", _
			"autoit-addon\build_x64\bin\" & $sBuildType _
			]

	Return _OpenCV_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, $aSearchPaths, $bReverse)
EndFunc   ;==>_Addon_FindDLL
