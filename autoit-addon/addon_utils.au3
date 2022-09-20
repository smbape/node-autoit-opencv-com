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
	Local $sBuildType = $_cv_build_type == "Debug" ? "Debug" : "RelWithDebInfo"
	Local $sPostfix = $_cv_build_type == "Debug" ? "d" : ""

	If $sFile == Default Then
		$sFile = "autoit_addon*" & $sPostfix & ".dll"
	EndIf

	Local $aSearchPaths[] = [ _
			0, _
			".", _
			$sBuildType, _
			"build_x64\" & $sBuildType, _
			"autoit-addon", _
			"autoit-addon\" & $sBuildType, _
			"autoit-addon\build_x64\", _
			"autoit-addon\build_x64\" & $sBuildType, _
			"autoit-opencv-com", _
			"autoit-opencv-com\" & $sBuildType, _
			"autoit-opencv-com\build_x64\", _
			"autoit-opencv-com\build_x64\" & $sBuildType _
			]

	If $_cv_build_type <> "Debug" Then
		_ArrayAdd($aSearchPaths, "build_x64\Release")
		_ArrayAdd($aSearchPaths, "autoit-dlib-com\build_x64\Release")
	EndIf

	$aSearchPaths[0] = UBound($aSearchPaths) - 1

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
