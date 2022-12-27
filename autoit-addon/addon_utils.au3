#include-once
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

Global $h_addon_dll = -1

Global Const $tagAddonDeviceInfo = _
		"long WaveInID;" & _
		"ptr FriendlyName;" & _
		"ulong_ptr FriendlyNameLen;" & _
		"ptr DevicePath;" & _
		"ulong_ptr DevicePathLen;"

Func _Addon_FindDLL($sFile = Default, $sFilter = Default, $sDir = Default)
	Local $sBuildType = EnvGet("OPENCV_BUILD_TYPE") == "Debug" ? "Debug" : "Release"
	Local $sPostfix = EnvGet("OPENCV_BUILD_TYPE") == "Debug" ? "d" : ""

	If $sFile == Default Then
		$sFile = "autoit_addon470*" & $sPostfix & ".dll"
	EndIf

	Local $aSearchPaths[] = [ _
			".", _
			"autoit-addon", _
			"autoit-opencv-com", _
			"autoit-addon\build_x64\bin\" & $sBuildType _
			]

	Return _OpenCV_FindFile($sFile, $sFilter, $sDir, $FLTA_FILES, $aSearchPaths)
EndFunc   ;==>_Addon_FindDLL

Func _Addon_DLLOpen($s_addon_dll)
	$h_addon_dll = _OpenCV_LoadDLL($s_addon_dll)
	Return $h_addon_dll <> -1
EndFunc   ;==>_Addon_DLLOpen

Func _Addon_DLLClose()
	If $h_addon_dll == -1 Then Return False
	DllClose($h_addon_dll)
	$h_addon_dll = -1
EndFunc   ;==>_Addon_DLLClose
