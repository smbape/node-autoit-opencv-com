#include-once

#include "opencv_udf.au3"

#include <GDIPlus.au3>
#include <Math.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global $_cv_gdi_resize = Number(EnvGet("OPENCV_GDI_RESIZE"))
Global Const $OPENCV_UDF_SORT_ASC = 1
Global Const $OPENCV_UDF_SORT_DESC = -1
Global Const $CV_TM_EXACT = -1

Func _OpenCV_FindDLL($sFile, $sFilter = Default, $sDir = Default, $bReverse = Default)
	Local $_cv_build_type = EnvGet("OPENCV_BUILD_TYPE")
	Local $sBuildType = $_cv_build_type == "Debug" ? "Debug" : "Release"
	Local $sPostfix = $_cv_build_type == "Debug" ? "d" : ""

	Local $aSearchPaths[] = [ _
			".", _
			"autoit-opencv-com", _
			"autoit-opencv-com\build_x64\bin\" & $sBuildType, _
			"opencv\build\x64\vc16\bin", _
			"opencv-4.8.0-*\build\x64\vc16\bin", _
			"opencv-4.8.0-*\opencv\build\x64\vc16\bin" _
			]

	Return _OpenCV_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, $aSearchPaths, $bReverse)
EndFunc   ;==>_OpenCV_FindDLL

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDevices
; Description ...: Return devices
; Syntax ........: _OpenCV_GetDevices([$iDeviceCategory = Default])
; Parameters ....: $iDeviceCategory     - [optional] device type to return. Default is 2.
;                                         $iDeviceCategory = 0 : Audio and Video devices
;                                         $iDeviceCategory = 1 : Audio devices
;                                         $iDeviceCategory = 2 : Video devices
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OpenCV_GetDevices($iDeviceCategory = Default)
	Local $devices = _OpenCV_ObjCreate("VectorOfString")

	If $iDeviceCategory == 0 Then
		$devices.push_vector(_OpenCV_GetDevices(1))
		$devices.push_vector(_OpenCV_GetDevices(2))
		Return $devices
	EndIf

	;===============================================================================
	#interface "ICreateDevEnum"
	Local Static $sCLSID_SystemDeviceEnum = '{62BE5D10-60EB-11D0-BD3B-00A0C911CE86}'
	Local Static $sIID_ICreateDevEnum = '{29840822-5B84-11D0-BD3B-00A0C911CE86}'
	Local Static $tagICreateDevEnum = "CreateClassEnumerator hresult(clsid;ptr*;dword);"
	;===============================END=============================================

	;===============================================================================
	#interface "IEnumMoniker"
	Local Static $sIID_IEnumMoniker = '{00000102-0000-0000-C000-000000000046}'
	Local Static $tagIEnumMoniker = "Next hresult(dword;ptr*;dword*);" & _
			"Skip hresult(dword);" & _
			"Reset hresult();" & _
			"Clone hresult(ptr*);"
	;===============================END=============================================

	;===============================================================================
	#interface "IMoniker"
	Local Static $sIID_IMoniker = '{0000000F-0000-0000-C000-000000000046}'
	Local Static $tagIMoniker = "GetClassID hresult( clsid );" & _
			"IsDirty hresult(  );" & _
			"Load hresult( ptr );" & _
			"Save hresult( ptr; bool );" & _
			"GetSizeMax hresult( uint64 );" & _
			"BindToObject hresult( ptr; ptr; clsid; ptr* );" & _
			"BindToStorage hresult( ptr; ptr; clsid; ptr* );" & _
			"Reduce hresult( ptr; dword; ptr*; ptr* );" & _
			"ComposeWith hresult( ptr; bool; ptr* );" & _
			"Enum hresult( bool; ptr* );" & _
			"IsEqual hresult( ptr );" & _
			"Hash hresult( dword );" & _
			"IsRunning hresult( ptr; ptr; ptr );" & _
			"GetTimeOfLastChange hresult( ptr; ptr; uint64 );" & _
			"Inverse hresult( ptr* );" & _
			"CommonPrefixWith hresult( ptr; ptr* );" & _
			"RelativePathTo hresult( ptr; ptr* );" & _
			"GetDisplayName hresult( ptr; ptr; ushort );" & _
			"ParseDisplayName hresult( ptr; ptr; ushort; ulong; ptr* );" & _
			"IsSystemMoniker hresult( dword );"
	;===============================END=============================================

	;===============================================================================
	#interface "IPropertyBag"
	Local Static $sIID_IPropertyBag = '{55272A00-42CB-11CE-8135-00AA004BB851}'
	Local Static $tagIPropertyBag = "Read hresult( wstr; variant*; ptr* );" & _
			"Write hresult( wstr; variant );"
	;===============================END=============================================

	Local Static $S_FALSE = 1
	Local Static $VFW_E_NOT_FOUND = 0x80040216
	Local Static $sCLSID_AudioInputDeviceCategory = '{33D9A762-90C8-11D0-BD43-00A0C911CE86}'
	Local Static $sCLSID_VideoInputDeviceCategory = '{860BB310-5D01-11D0-BD3B-00A0C911CE86}'

	Local $sCLSID_category = $iDeviceCategory == 1 ? $sCLSID_AudioInputDeviceCategory : $sCLSID_VideoInputDeviceCategory

	;  // Create a helper object To find the capture device.
	;  hr = CoCreateInstance(CLSID_SystemDeviceEnum, Null, CLSCTX_INPROC_SERVER, IID_ICreateDevEnum, (LPVOID *) & pDevEnum);
	Local $oDevEnum = ObjCreateInterface($sCLSID_SystemDeviceEnum, $sIID_ICreateDevEnum, $tagICreateDevEnum)
	If Not IsObj($oDevEnum) Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to create SystemDeviceEnum' & @CRLF)
		Return $devices
	EndIf

	; IEnumMoniker *pEnum = 0;
	; hr = pDevEnum->CreateClassEnumerator(CLSID_category, &pEnum, 0);
	Local $pEnum = 0
	Local $hr = $oDevEnum.CreateClassEnumerator($sCLSID_category, $pEnum, 0)
	If $hr == $S_FALSE Then
		$hr = $VFW_E_NOT_FOUND ; The category is empty. Treat as an error.
	EndIf

	If $hr < 0 Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to create the device enumerator' & @CRLF)
		Return $devices
	EndIf

	Local $oEnum = ObjCreateInterface(Ptr($pEnum), $sIID_IEnumMoniker, $tagIEnumMoniker)
	If Not IsObj($oEnum) Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to enumerate devices' & @CRLF)
	EndIf

	; IMoniker *pMoniker = 0;
	Local $pMoniker, $oMoniker, $pPropBag, $oPropBag, $var

	; while (pEnum->Next(1, &pMoniker, NULL) == S_OK) {
	While $oEnum.Next(1, $pMoniker, 0) == $S_OK
		$oMoniker = ObjCreateInterface($pMoniker, $sIID_IMoniker, $tagIMoniker)
		If Not IsObj($oMoniker) Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to get device' & @CRLF)
			ContinueLoop
		EndIf

		; HRESULT hr = pMoniker->BindToStorage(0, 0, IID_PPV_ARGS(&pPropBag));
		$hr = $oMoniker.BindToStorage(0, 0, $sIID_IPropertyBag, $pPropBag)
		If $hr < 0 Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed bind device properties' & @CRLF)
			ContinueLoop
		EndIf

		$oPropBag = ObjCreateInterface(Ptr($pPropBag), $sIID_IPropertyBag, $tagIPropertyBag)
		If Not IsObj($oPropBag) Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to get device properties' & @CRLF)
			ContinueLoop
		EndIf

		; hr = pPropBag->Read(L"Description", &var, 0);
		$hr = $oPropBag.Read('Description', $var, 0)
		If $hr < 0 Then
			; hr = pPropBag->Read(L"FriendlyName", &var, 0);
			$hr = $oPropBag.Read('FriendlyName', $var, 0)
		EndIf

		If $hr < 0 Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed get device FriendlyName' & @CRLF)
			ContinueLoop
		EndIf

		$devices.Add($var)
	WEnd

	Return $devices
EndFunc   ;==>_OpenCV_GetDevices

Func _OpenCV_imread_and_check($fileName, $flags = Default)
	Local Const $cv = _OpenCV_get()
	Local $img = $cv.imread($fileName, $flags)
	If $img.empty() Then
		ConsoleWriteError("!>Error: The image " & $fileName & " could not be loaded." & @CRLF)
	EndIf
	Return SetError($img.empty() ? 1 : 0, 0, $img)
EndFunc   ;==>_OpenCV_imread_and_check

Func _OpenCV_computeResizeParams($iWidth, $iHeight, $iHintWidth = Default, $iHintHeight = Default, $bEnlarge = False)
	If $iHintWidth == Default Then
		If $iHintHeight == Default Then
			$iHintWidth = $iWidth
			$iHintHeight = $iHeight
		Else
			$iHintWidth = $iHintHeight * $iWidth / $iHeight
		EndIf
	ElseIf $iHintHeight == Default Then
		$iHintHeight = $iHintWidth * $iHeight / $iWidth
	EndIf

	Local $fRatio = $iWidth / $iHeight
	Local $iDstWidth = $iHintWidth
	Local $iDstHeight = $iHintHeight

	If $fRatio * $iDstHeight > $iDstWidth Then
		$iDstHeight = Floor($iDstWidth / $fRatio)
	Else
		$iDstWidth = Floor($iDstHeight * $fRatio)
	EndIf

	If $iWidth < $iDstWidth And $iHeight < $iDstHeight And Not $bEnlarge Then
		$iDstWidth = $iWidth
		$iDstHeight = $iHeight
	EndIf

	Local $iPadLeft = Floor(($iHintWidth - $iDstWidth) / 2)
	Local $iPadTop = Floor(($iHintHeight - $iDstHeight) / 2)

	If $iPadLeft < 0 Then $iPadLeft = 0
	If $iPadTop < 0 Then $iPadTop = 0

	Return _OpenCV_Tuple($iDstWidth, $iDstHeight, $iPadLeft, $iPadTop)
EndFunc   ;==>_OpenCV_computeResizeParams

; node scripts/func_kwargs.js OpenCV resizeAndCenter "['src', 'src']" "['iDstWidth', 'width', 'Default']" "['iDstHeight', 'height', 'Default']" "['aBackgroundColor', 'background', '_OpenCV_Scalar(0xF0, 0xF0, 0xF0, 0xFF)']" "['bResize', 'resize', 'True']" "['bEnlarge', 'enlarge', 'False']" "['bCenter', 'center', 'True']" "['interpolation', 'interpolation', 'Default']" | clip
Func _OpenCV_resizeAndCenter($src, $iDstWidth = Default, $iDstHeight = Default, $aBackgroundColor = Default, $bResize = Default, $bEnlarge = Default, $bCenter = Default, $interpolation = Default)
	Local Static $NamedParameters = _OpenCV_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($src) ? $src : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($iDstWidth) ? $iDstWidth : Default
		Case 3
			$kwargs = $NamedParameters.isNamedParameters($iDstHeight) ? $iDstHeight : Default
		Case 4
			$kwargs = $NamedParameters.isNamedParameters($aBackgroundColor) ? $aBackgroundColor : Default
		Case 5
			$kwargs = $NamedParameters.isNamedParameters($bResize) ? $bResize : Default
		Case 6
			$kwargs = $NamedParameters.isNamedParameters($bEnlarge) ? $bEnlarge : Default
		Case 7
			$kwargs = $NamedParameters.isNamedParameters($bCenter) ? $bCenter : Default
		Case 8
			$kwargs = $NamedParameters.isNamedParameters($interpolation) ? $interpolation : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument src
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("src") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : src was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("src") Then
			$src = $kwargs.Item("src")
			$usedkw += 1
		EndIf
	EndIf

	; get argument width
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("width") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : width was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("width") Then
			$iDstWidth = $kwargs.Item("width")
			$usedkw += 1
		EndIf
	EndIf

	; get argument height
	If (Not $has_kwarg) Or @NumParams > 3 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("height") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : height was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("height") Then
			$iDstHeight = $kwargs.Item("height")
			$usedkw += 1
		EndIf
	EndIf

	; get argument background
	If (Not $has_kwarg) Or @NumParams > 4 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("background") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : background was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("background") Then
			$aBackgroundColor = $kwargs.Item("background")
			$usedkw += 1
		EndIf
	EndIf
	If $aBackgroundColor == Default Then $aBackgroundColor = _OpenCV_Scalar(0xF0, 0xF0, 0xF0, 0xFF)

	; get argument resize
	If (Not $has_kwarg) Or @NumParams > 5 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("resize") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : resize was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("resize") Then
			$bResize = $kwargs.Item("resize")
			$usedkw += 1
		EndIf
	EndIf
	If $bResize == Default Then $bResize = True

	; get argument enlarge
	If (Not $has_kwarg) Or @NumParams > 6 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("enlarge") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : enlarge was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("enlarge") Then
			$bEnlarge = $kwargs.Item("enlarge")
			$usedkw += 1
		EndIf
	EndIf
	If $bEnlarge == Default Then $bEnlarge = False

	; get argument center
	If (Not $has_kwarg) Or @NumParams > 7 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("center") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : center was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("center") Then
			$bCenter = $kwargs.Item("center")
			$usedkw += 1
		EndIf
	EndIf
	If $bCenter == Default Then $bCenter = True

	; get argument interpolation
	If (Not $has_kwarg) Or @NumParams > 8 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("interpolation") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : interpolation was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("interpolation") Then
			$interpolation = $kwargs.Item("interpolation")
			$usedkw += 1
		EndIf
	EndIf

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	If Not $bResize And Not $bCenter Then Return $src

	Local $aParams = _OpenCV_computeResizeParams($src.width, $src.height, $iDstWidth, $iDstHeight, $bEnlarge)
	Local $iWidth = $aParams[0]
	Local $iHeight = $aParams[1]
	Local $iPadLeft = $aParams[2]
	Local $iPadTop = $aParams[3]

	If $iDstWidth == Default Then $iDstWidth = $iWidth
	If $iDstHeight == Default Then $iDstHeight = $iHeight

	Local $bHighQuality = $iDstWidth > $src.width Or $iDstHeight > $src.height ? $interpolation == $CV_INTER_CUBIC : $interpolation == $CV_INTER_AREA

	Local Const $cv = _OpenCV_get()
	; Local $hTimer

	If $bResize And ($src.width <> $iWidth Or $src.height <> $iHeight) Then
		If $_cv_gdi_resize And $__g_hGDIPDll > 0 Then
			Switch $interpolation
				Case $CV_INTER_NEAREST
					$interpolation = $GDIP_INTERPOLATIONMODE_NEARESTNEIGHBOR
				Case $CV_INTER_LINEAR
					$interpolation = $GDIP_INTERPOLATIONMODE_BILINEAR
				Case $CV_INTER_CUBIC
					$interpolation = $bHighQuality ? $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC : $GDIP_INTERPOLATIONMODE_BICUBIC
				Case $CV_INTER_AREA
					$interpolation = $bHighQuality ? $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC : $GDIP_INTERPOLATIONMODE_BICUBIC
				Case $CV_INTER_LANCZOS4
					$interpolation = $GDIP_INTERPOLATIONMODE_NEARESTNEIGHBOR
				Case $CV_INTER_LINEAR_EXACT
					$interpolation = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBILINEAR
				Case $CV_INTER_NEAREST_EXACT
					$interpolation = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC
				Case Else
					If $interpolation == Default Then $interpolation = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC
					If $interpolation < $GDIP_INTERPOLATIONMODE_DEFAULT Then $interpolation = $GDIP_INTERPOLATIONMODE_DEFAULT
					If $interpolation > $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC Then $interpolation = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC
			EndSwitch

			; $hTimer = TimerInit()
			$src = $src.GdiplusResize($iWidth, $iHeight, $interpolation)
			; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Mat.GdiplusResize ' & TimerDiff($hTimer) & ' ms' & @CRLF) ;### Debug Console
		Else
			If $interpolation == Default Then $interpolation = ($iDstWidth > $src.width Or $iDstHeight > $src.height) ? $CV_INTER_CUBIC : $CV_INTER_AREA

			; $hTimer = TimerInit()
			$src = $cv.resize($src, _OpenCV_Size($iWidth, $iHeight), Default, 0, 0, $interpolation)
			; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : cv.resize ' & TimerDiff($hTimer) & ' ms' & @CRLF) ;### Debug Console
		EndIf
	EndIf

	If $bCenter And ($iPadLeft > 0 Or $iPadTop > 0) Then
		Local $padded = $src.create($iDstHeight, $iDstWidth, CV_MAKETYPE($src.depth(), $src.channels()), $aBackgroundColor)
		$src.copyTo($src.create($padded, _OpenCV_Rect($iPadLeft, $iPadTop, $src.width, $src.height)))
		$src = $padded
	EndIf

	Return $src
EndFunc   ;==>_OpenCV_resizeAndCenter

Func _OpenCV_SetControlPic($controlID, $src, $iDstWidth = Default, $iDstHeight = Default, $aBackgroundColor = Default, $bResize = False, $bEnlarge = False, $bCenter = False, $interpolation = Default)
	$src = _OpenCV_resizeAndCenter($src.convertToShow(), $iDstWidth, $iDstHeight, $aBackgroundColor, $bResize, $bEnlarge, $bCenter, $interpolation)

	; https://devblogs.microsoft.com/oldnewthing/20140219-00/?p=1713
	; Handle the case of a secret copy
	Local $hHBITMAP = _OpenCV_GetHBITMAP($src, 4)
	Local $hPrevImage = GUICtrlSendMsg($controlID, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBITMAP)
	_WinAPI_DeleteObject($hPrevImage) ; Delete Prev image if any
	_WinAPI_DeleteObject($hHBITMAP)
EndFunc   ;==>_OpenCV_SetControlPic

Func _OpenCV_GetHBITMAP($img, $iChannels = Default)
	If $iChannels == Default Then $iChannels = 3

	Local $iWidth = $img.width
	Local $iHeight = $img.height

	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFO)
	Local $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($tBITMAPINFO))

	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = -$iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8
	$tBIHDR.biCompression = $BI_RGB

	; Local $hTimer
	; $hTimer = TimerInit()
	Local $pBits
	Local $hDIB = _WinAPI_CreateDIBSection(_WinAPI_GetDesktopWindow(), $tBITMAPINFO, $DIB_RGB_COLORS, $pBits)
	Local $dst = _OpenCV_ObjCreate("cv.Mat").create($img.rows, $img.cols, CV_MAKETYPE($CV_8U, $iChannels), $pBits, BitAND($img.cols * $iChannels + 3, -4))
	$img.convertToShow($dst)
	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : CreateDIBSection ' & TimerDiff($hTimer) & ' ms' & @CRLF) ;### Debug Console

	Return $hDIB
EndFunc   ;==>_OpenCV_GetHBITMAP

Func _OpenCV_imshow_ControlPic($oMat, $hWnd, $controlID, $aBackgroundColor = Default, $bResize = True, $bEnlarge = Default, $bCenter = True, $interpolation = Default)
	Local $aPicPos = ControlGetPos($hWnd, "", $controlID)
	_OpenCV_SetControlPic($controlID, $oMat, $aPicPos[2], $aPicPos[3], $aBackgroundColor, $bResize, $bEnlarge, $bCenter, $interpolation)
EndFunc   ;==>_OpenCV_imshow_ControlPic

Func _OpenCV_resizeRatio_ControlPic($src, $hWnd, $controlID, $bEnlarge = Default)
	Local $aPicPos = ControlGetPos($hWnd, "", $controlID)
	Local $aParams = _OpenCV_computeResizeParams($src.width, $src.height, $aPicPos[2], $aPicPos[3], $bEnlarge)
	Return $aParams[0] / $src.width
EndFunc   ;==>_OpenCV_resizeRatio_ControlPic

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenBits
; Description ...: Get the screen color bytes
; Syntax ........: _OpenCV_GetDesktopScreenBits($aRect[, $iChannels = 4])
; Parameters ....: $aRect               - [in] an array [left, top, width, height]
;                  $iChannels           - [in] number of channels (3, 4). Default is 4
; Return values .: a byte[] struct of ABRG colors of the screen. Can be used as data for an opencv matrix
; Author ........: Stéphane MBAPE
; Modified ......:
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenBits($aRect, $iChannels = Default)
	If $iChannels == Default Then $iChannels = 4
	Return __OpenCV_GetDesktopScreenCapture($aRect, $iChannels, "__OpenCV_HandleScreenBitsClone")
EndFunc   ;==>_OpenCV_GetDesktopScreenBits

Func __OpenCV_HandleScreenBitsClone(Const ByRef $pBits, Const ByRef $iWidth, Const ByRef $iHeight, Const ByRef $iChannels)
	Local $iSize = $iWidth * $iHeight * $iChannels
	Local $tBits = DllStructCreate('byte value[' & $iSize & ']')
	_OpenCV_DllCall("msvcrt.dll", "ptr", "memcpy_s", "struct*", $tBits, "ulong_ptr", $iSize, "ptr", $pBits, "ulong_ptr", $iSize)
	Return $tBits
EndFunc   ;==>__OpenCV_HandleScreenBitsClone

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenMat
; Description ...: Get the screen image mat
; Syntax ........: _OpenCV_GetDesktopScreenMat($aRect[, $iChannels = 3])
; Parameters ....: $aRect               - [in] an array [left, top, width, height]
;                  $iChannels           - [in] number of channels (3, 4). Default is 3
; Return values .: an opencv matrix
; Author ........: Stéphane MBAPE
; Modified ......:
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenMat($aRect, $iChannels = Default)
	If $iChannels == Default Then $iChannels = 3
	Return __OpenCV_GetDesktopScreenCapture($aRect, $iChannels, "__OpenCV_HandleScreenBitsMat")
EndFunc   ;==>_OpenCV_GetDesktopScreenMat

Func __OpenCV_HandleScreenBitsMat(Const ByRef $pBits, Const ByRef $iWidth, Const ByRef $iHeight, Const ByRef $iChannels)
	; $pBits will be unallacoted when _WinAPI_DeleteObject will be called.
	; To be able to preserve the data,
	; copy $pBits before unallocation
	Local $iType = CV_MAKETYPE($CV_8U, $iChannels)
	Local $iStep = BitAND($iWidth * $iChannels + 3, -4)
	Local $dst = _OpenCV_ObjCreate("cv.Mat").create($iHeight, $iWidth, $iType, $pBits, $iStep)
	Return $dst.clone()
EndFunc   ;==>__OpenCV_HandleScreenBitsMat

; #FUNCTION# ====================================================================================================================
; Name ..........: __OpenCV_GetDesktopScreenCapture
; Description ...: Get the screen color bytes
; Syntax ........: __OpenCV_GetDesktopScreenCapture(ByRef $aRect, ByRef $iChannels, ByRef $sCallback)
; Parameters ....: $aRect               - [in] an array [left, top, width, height]
;                  $iChannels           - [in] number of channels
;                  $sCallback           - [in] callback called with ($pBits, $iWidth, $iHeight, $iChannels)
; Return values .: The result of the callback
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......: https://github.com/opencv/opencv/blob/4.8.0/modules/highgui/src/window_w32.cpp#L1407
;                  https://github.com/opencv/opencv/blob/4.8.0/modules/highgui/src/window_w32.cpp#L122
; ===============================================================================================================================
Func __OpenCV_GetDesktopScreenCapture(Const ByRef $aRect, Const ByRef $iChannels, Const $sCallback)
	Local $iLeft = $aRect[0]
	Local $iTop = $aRect[1]
	Local $iWidth = $aRect[2]
	Local $iHeight = $aRect[3]

	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hSrcDC = _WinAPI_GetDC($hWnd)
	Local $hDstDC = _WinAPI_CreateCompatibleDC($hSrcDC)

	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFO)
	Local $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($tBITMAPINFO))
	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = -$iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8
	$tBIHDR.biCompression = $BI_RGB

	Local $pBits
	Local $hPrevDstObject = _WinAPI_SelectObject($hDstDC, _WinAPI_CreateDIBSection($hDstDC, $tBITMAPINFO, $DIB_RGB_COLORS, $pBits))

	; Local $hTimer = TimerInit()
	_WinAPI_BitBlt($hDstDC, 0, 0, $iWidth, $iHeight, $hSrcDC, $iLeft, $iTop, $SRCCOPY)
	; ConsoleWrite("_WinAPI_BitBlt took " & TimerDiff($hTimer) & "ms" & @CRLF)

	Local $vRes = Call($sCallback, $pBits, $iWidth, $iHeight, $iChannels)

	_WinAPI_DeleteObject(_WinAPI_SelectObject($hDstDC, $hPrevDstObject))
	_WinAPI_DeleteDC($hDstDC)
	_WinAPI_ReleaseDC($hWnd, $hSrcDC)

	Return $vRes
EndFunc   ;==>__OpenCV_GetDesktopScreenCapture

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenRect
; Description ...: Get desktop screen rect, handling multi-screen desktop.
; Syntax ........: _OpenCV_GetDesktopScreenRect([$iScreenNum = Default])
; Parameters ....: $iScreenNum          - [optional] The screen number. Set to Default for all screens. Default is Default.
; Return values .: $aRect an array [left, top, width, height]
; Author ........: Stéphane MBAPE
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenRect($iScreenNum = Default)
	Local $iRight, $iBottom, $aRetrun

	Local $tRect = DllStructCreate($tagRECT)
	$tRect.Left = 0
	$tRect.Top = 0
	$tRect.Right = -1
	$tRect.Bottom = -1

	Local Const $tagDISPLAY_DEVICE = "dword Size;wchar Name[32];wchar String[128];dword Flags;wchar ID[128];wchar Key[128]"
	Local $tDisplayDevice = DllStructCreate($tagDISPLAY_DEVICE)
	$tDisplayDevice.Size = DllStructGetSize($tDisplayDevice)

	Local $tDisplaySettings = DllStructCreate($tagDEVMODE_DISPLAY)
	$tDisplaySettings.Size = DllStructGetSize($tDisplaySettings)

	Local $_cv_debug = Number(EnvGet("OPENCV_DEBUG"))
	Local $iDevNum = 0
	While 1
		; _WinAPI_EnumDisplayDevices("", $iDevNum)
		$aRetrun = DllCall("user32.dll", "int", "EnumDisplayDevicesW", "ptr", 0, "dword", $iDevNum, "struct*", $tDisplayDevice, "dword", 1)
		If Not $aRetrun[0] Then ExitLoop
		$iDevNum += 1

		If $iScreenNum <> Default And $iScreenNum <> $iDevNum Then ContinueLoop

		If BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_MIRRORING_DRIVER) Or Not BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) Then
			ContinueLoop
		EndIf

		If $_cv_debug <> 0 Then
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "Attached to desktop: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) <> 0))
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "Primary: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_PRIMARY_DEVICE) <> 0))
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "Mirroring driver: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_MIRRORING_DRIVER) <> 0))
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "VGA compatible: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_VGA_COMPATIBLE) <> 0))
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "Removable: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_REMOVABLE) <> 0))
			_OpenCV_DebugMsg($tDisplayDevice.Name & @TAB & "More display modes: " & (BitAND($tDisplayDevice.Flags, $DISPLAY_DEVICE_MODESPRUNED) <> 0))
			_OpenCV_DebugMsg("")
		EndIf

		; _WinAPI_EnumDisplaySettings($tDisplayDevice.Name, $ENUM_CURRENT_SETTINGS)
		Local $sDevice = $tDisplayDevice.Name
		Local $sTypeOfDevice = 'wstr'
		If Not StringStripWS($sDevice, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfDevice = 'ptr'
			$sDevice = 0
		EndIf
		$aRetrun = DllCall("user32.dll", "bool", "EnumDisplaySettingsW", $sTypeOfDevice, $sDevice, "dword", $ENUM_CURRENT_SETTINGS, "struct*", $tDisplaySettings)
		If Not $aRetrun[0] Then ContinueLoop

		If $tRect.Left > $tDisplaySettings.X Then $tRect.Left = $tDisplaySettings.X
		If $tRect.Top > $tDisplaySettings.Y Then $tRect.Left = $tDisplaySettings.Y

		$iRight = $tDisplaySettings.X + $tDisplaySettings.PelsWidth
		If $tRect.Right < $iRight Then $tRect.Right = $iRight

		$iBottom = $tDisplaySettings.Y + $tDisplaySettings.PelsHeight
		If $tRect.Bottom < $iBottom Then $tRect.Bottom = $iBottom
	WEnd

	$tDisplaySettings = 0
	$tDisplayDevice = 0

	Return _OpenCV_Tuple($tRect.Left, $tRect.Top, $tRect.Right - $tRect.Left, $tRect.Bottom - $tRect.Top)
EndFunc   ;==>_OpenCV_GetDesktopScreenRect

Func _OpenCV_CompareMatHist($matSrc, $matDst, $matMask, $aChannels, $aHistSize, $aRanges, $iCompareMethod = $CV_HISTCMP_CORREL, $bAccumulate = False)
	If $matMask == Default Then $matMask = Null
	Local Const $cv = _OpenCV_get()

	Local $aMatSrc[1] = [$matSrc]
	Local $matHistSrc = $cv.calcHist($aMatSrc, $aChannels, $matMask, $aHistSize, $aRanges, Default, $bAccumulate)
	$cv.normalize($matHistSrc, $matHistSrc, 0, 1, $CV_NORM_MINMAX)

	Local $aMatDst[1] = [$matDst]
	Local $matHistDst = $cv.calcHist($aMatDst, $aChannels, $matMask, $aHistSize, $aRanges, Default, $bAccumulate)
	$cv.normalize($matHistDst, $matHistDst, 0, 1, $CV_NORM_MINMAX)

	Local $dResult = $cv.compareHist($matHistSrc, $matHistDst, $iCompareMethod)

	Return $dResult
EndFunc   ;==>_OpenCV_CompareMatHist

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_FindTemplate
; Description ...: Find matches of a template in an image
; Syntax ........: _OpenCV_FindTemplate($matImg, $matTempl[, $fThreshold = 0.95[, $iCode = -1[, $iMatchMethod = $CV_TM_CCOEFF_NORMED[,
;                  $matTemplMask = Default[, $fOverlapping = 2[, $aChannels = Default[,
;                  $aHistSize = Default[, $aRanges = Default[, $iCompareMethod = $CV_HISTCMP_CORREL[,
;                  $iDstCn = 0[, $bAccumulate = False[, $iLimit = 100]]]]]]]]]]]])
; Parameters ....: $matImg              - image matrix.
;                  $matTempl            - template matrix.
;                  $fThreshold          - [optional] matching correlation should not be under this value. 1 means only keep perfect matches. Default is 0.95.
;                  $iMatchMethod        - [optional] parameter specifying the comparison method. Default is $CV_TM_CCOEFF_NORMED.
;                  $matTemplMask        - [optional] mask to use for matching. Default is Default.
;                  $iLimit              - [optional] an integer value. Default is 20.
;                  $iCode               - [optional] color space conversion code. Use -1 for no conversion. Default is -1.
;                  $fOverlapping        - [optional] koeffitient to control overlapping of matches.
;                                                    $fOverlapping = 1     : two matches can overlap half-body of template
;                                                    $fOverlapping = 2     : no overlapping,only border touching possible
;                                                    $fOverlapping = > 2   : distancing matches
;                                                    0 < $fOverlapping < 1 : matches can overlap more then half.
;                                                    Default is 2.
;                  $aChannels           - [optional] an array of ints. List of the dims channels used to compute the histogram.
;                  $aHistSize           - [optional] an array of int. Array of histogram sizes in each dimension.
;                  $aRanges             - [optional] an array of float. Array of the dims arrays of the histogram bin boundaries in each dimension.
;                  $iCompareMethod      - [optional] an integer value. Default is $CV_HISTCMP_CORREL.
;                  $iDstCn              - [optional] number of channels in the destination image. Default is 0.
;                  $bAccumulate         - [optional] Accumulation flag.
;                                                    If it is set, the histogram is not cleared in the beginning when it is allocated.
;                                                    Default is False.
; Return values .: An array of matches [[x1, y1, s1], [x2, y2, s2], ..., [xn, yn, sn]]
; Author ........: Stéphane MBAPE
; Modified ......:
; Sources .......: https://stackoverflow.com/a/28647930
;                  https://github.com/opencv/opencv/blob/4.8.0/samples/cpp/tutorial_code/Histograms_Matching/MatchTemplate_Demo.cpp#L84
;                  https://vovkos.github.io/doxyrest-showcase/opencv/sphinx_rtd_theme/page_tutorial_histogram_calculation.html
; ===============================================================================================================================
Func _OpenCV_FindTemplate($matImg, $matTempl, $fThreshold = Default, $iMatchMethod = Default, $matTemplMask = Default, $iLimit = Default, $iCode = Default, $fOverlapping = Default, $aChannels = Default, $aHistSize = Default, $aRanges = Default, $iCompareMethod = Default, $iDstCn = Default, $bAccumulate = False)
	Local Const $cv = _OpenCV_get()

	If $fThreshold == Default Then $fThreshold = 0.95
	If $iMatchMethod == Default Then $iMatchMethod = $CV_TM_CCOEFF_NORMED
	If $iCode == Default Then $iCode = -1
	If $fOverlapping == Default Then $fOverlapping = 2
	If $iCompareMethod == Default Then $iCompareMethod = $CV_HISTCMP_CORREL
	If $iLimit == Default Then $iLimit = 20

	If $iCode >= 0 Then
		$matImg = $cv.cvtColor($matImg, $iCode, Default, $iDstCn)
		$matTempl = $cv.cvtColor($matTempl, $iCode, Default, $iDstCn)
	EndIf

	If $aChannels == Default Then
		Local $arr[$matImg.channels()]
		For $i = 0 To $matImg.channels() - 1
			$arr[$i] = $i
		Next
		$aChannels = $arr
	EndIf

	If $aHistSize == Default Then
		Local $arr[$matImg.channels()]
		For $i = 0 To $matImg.channels() - 1
			$arr[$i] = $iMatchMethod == $CV_TM_EXACT ? $i : 32
		Next
		$aHistSize = $arr
	EndIf

	If $aRanges == Default Then
		Local $arr[$matImg.channels() * 2]
		For $i = 0 To $matImg.channels() - 1
			$arr[2 * $i] = $iMatchMethod == $CV_TM_EXACT ? -(1 - $fThreshold) * 256 : 0
			$arr[2 * $i + 1] = $iMatchMethod == $CV_TM_EXACT ? (1 - $fThreshold) * 256 : 256
		Next
		$aRanges = $arr
	EndIf

	If $iLimit < 0 Then $iLimit = 0
	Local $aResult[$iLimit][3]
	If $iLimit == 0 Then Return $aResult

	Local $width = $matImg.width
	Local $height = $matImg.height

	Local $w = $matTempl.width
	Local $h = $matTempl.height

	Local $aMatchRect[4] = [0, 0, $w, $h]

	Local $rw = $width - $w + 1
	Local $rh = $height - $h + 1

	If $rw <= 0 Or $rh <= 0 Then
		ReDim $aResult[0][3]
		Return $aResult
	EndIf

	Local $Mat = $matImg.create()

	Local $matResult = $Mat.create()
	Local $bMethodAcceptsMask = $iMatchMethod == $CV_TM_EXACT Or $CV_TM_SQDIFF == $iMatchMethod Or $iMatchMethod == $CV_TM_CCORR_NORMED
	Local $bIsNormed = $iMatchMethod == $CV_TM_EXACT Or $iMatchMethod == $CV_TM_SQDIFF_NORMED Or $iMatchMethod == $CV_TM_CCORR_NORMED Or $iMatchMethod == $CV_TM_CCOEFF_NORMED

	If Not $bMethodAcceptsMask Then $matTemplMask = Default

	; Local $hTimer

	; $hTimer = TimerInit()
	If $iMatchMethod == $CV_TM_EXACT Then
		$cv.searchTemplate($matImg, $matTempl, $matResult, $matTemplMask, $aChannels, $aRanges)
	ElseIf $matImg.width * $matImg.height > 500 * 500 Then
		$cv.matchTemplateParallel($matImg, $matTempl, $iMatchMethod, $matResult, $matTemplMask)
	Else
		$cv.matchTemplate($matImg, $matTempl, $iMatchMethod, $matResult, $matTemplMask)
	EndIf
	; ConsoleWrite("matchTemplate took " & TimerDiff($hTimer) & "ms" & @CRLF)

	Local $aMatchLoc
	Local $fHistScore = 1
	Local $fScore = 0
	Local $iFound = 0

	If Not $bIsNormed Then
		$cv.normalize($matResult, $matResult, 0, 1, $CV_NORM_MINMAX)
	EndIf

	; there are $rh rows and $rw cols in the result matrix
	; create a mask with the same number of rows and cols
	Local $matResultMask = $Mat.ones($rh, $rw, $CV_8UC1)
	Local $minVal, $maxVal, $aMinLoc, $aMaxLoc

	; $hTimer = TimerInit()
	While $iLimit > 0 ; guard against infinite loop
		$iLimit = $iLimit - 1

		$cv.minMaxLoc($matResult, $matResultMask)

		$minVal = $cv.extended[0]
		$maxVal = $cv.extended[1]
		$aMinLoc = $cv.extended[2]
		$aMaxLoc = $cv.extended[3]

		; For SQDIFF and SQDIFF_NORMED, the best matches are lower values. For all the other methods, the higher the better
		If ($iMatchMethod == $CV_TM_SQDIFF Or $iMatchMethod == $CV_TM_SQDIFF_NORMED) Then
			$aMatchLoc = $aMinLoc
			$fScore = 1 - $minVal
		Else
			$aMatchLoc = $aMaxLoc
			$fScore = $maxVal
		EndIf

		If (Not $bIsNormed) And ($iFound == 0) Then
			$aMatchRect[0] = $aMatchLoc[0]
			$aMatchRect[1] = $aMatchLoc[1]

			Local $matImgMatch = $Mat.create($matImg, $aMatchRect)
			If $matTemplMask <> Default And $matTemplMask.channels() <> 1 Then $matTemplMask = Default
			$fHistScore = _OpenCV_CompareMatHist($matImgMatch, $matTempl, $matTemplMask, $aChannels, $aHistSize, $aRanges, $iCompareMethod, $bAccumulate)
			; ConsoleWrite("$fHistScore: " & $fHistScore & @CRLF)
		EndIf

		$fScore *= $fHistScore

		If $fScore < $fThreshold Then
			ExitLoop
		EndIf

		$aResult[$iFound][0] = $aMatchLoc[0]
		$aResult[$iFound][1] = $aMatchLoc[1]
		$aResult[$iFound][2] = $fScore
		$iFound = $iFound + 1

		Local $tw = _Max(1, Ceiling($fOverlapping * $w))
		Local $th = _Max(1, Ceiling($fOverlapping * $h))
		Local $x = _Max(0, $aMatchLoc[0] - $tw / 2)
		Local $y = _Max(0, $aMatchLoc[1] - $th / 2)

		; ensure that the template stays within the mask
		If $x + $tw > $rw Then $tw = $rw - $x
		If $y + $th > $rh Then $th = $rh - $y

		; mask the locations that should not be matched again
		Local $aMaskedRect[4] = [$x, $y, $tw, $th]
		Local $matMaskedRect = $Mat.create($matResultMask, $aMaskedRect)
		$matMaskedRect.setTo(_OpenCV_ScalarAll(0))
	WEnd
	; ConsoleWrite("minMaxLoc took " & TimerDiff($hTimer) & "ms" & @CRLF)

	ReDim $aResult[$iFound][3]

	Return $aResult
EndFunc   ;==>_OpenCV_FindTemplate

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_RotateBound
; Description ...: Rotates an image around the center and put bounds around the rotated image.
; Syntax ........: _OpenCV_RotateBound($img[, $angle = 0[, $scale = 1.0[, $rotated = Default]]])
; Parameters ....: $img                 - input image.
;                  $angle               - [optional] angle Rotation angle in degrees. Positive values mean clockwise rotation. Default is 0.
;                  $scale               - [optional] Isotropic scale factor. Default is 1.0.
; Return values .: Rotated image
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://www.pyimagesearch.com/2017/01/02/rotate-images-correctly-with-opencv-and-python/
; Example .......: No
; ===============================================================================================================================
Func _OpenCV_RotateBound($img, $angle = 0, $scale = 1.0, $flags = Default, $borderMode = Default, $borderValue = Default, $rotated = Default)
	Local Const $cv = _OpenCV_get()

	Local $center[2] = [$img.width / 2, $img.height / 2]
	Local $M = $cv.getRotationMatrix2D($center, -$angle, $scale)

	Local $M11 = $M.double_at(0, 0)
	Local $M12 = $M.double_at(0, 1)
	Local $M13 = $M.double_at(0, 2)

	Local $M21 = $M.double_at(1, 0)
	Local $M22 = $M.double_at(1, 1)
	Local $M23 = $M.double_at(1, 2)

	Local $X11 = $M13
	Local $Y11 = $M23

	Local $X21 = $M12 * $img.height + $M13
	Local $Y21 = $M22 * $img.height + $M23

	Local $X12 = $M11 * $img.width + $M13
	Local $Y12 = $M21 * $img.width + $M23

	Local $X22 = $M11 * $img.width + $M12 * $img.height + $M13
	Local $Y22 = $M21 * $img.width + $M22 * $img.height + $M23

	Local $x1 = _Min(_Min($X11, $X21), _Min($X12, $X22))
	Local $y1 = _Min(_Min($Y11, $Y21), _Min($Y12, $Y22))

	Local $x2 = _Max(_Max($X11, $X21), _Max($X12, $X22))
	Local $y2 = _Max(_Max($Y11, $Y21), _Max($Y12, $Y22))

	Local $nW = $x2 - $x1
	Local $nH = $y2 - $y1

	; adjust the rotation matrix to take into account the translation
	$M.double_set_at(0, 2, $M13 - $x1)
	$M.double_set_at(1, 2, $M23 - $y1)

	Local $size[2] = [$nW, $nH]

	Return $cv.warpAffine($img, $M, $size, $rotated, $flags, $borderMode, $borderValue)
EndFunc   ;==>_OpenCV_RotateBound

Func _OpenCV_ColorGetScalar($iColor)
	Local $cvScalar[4] = [ _
			BitAND($iColor, 0xFF), _
			BitAND(BitShift($iColor, 8), 0xFF), _
			BitAND(BitShift($iColor, 16), 0xFF), _
			BitAND(BitShift($iColor, 24), 0xFF) _
			]
	Return $cvScalar
EndFunc   ;==>_OpenCV_ColorGetScalar

Func _OpenCV_RGB($cvRed, $cvGreen, $cvBlue)
	Local $cvScalar[4] = [$cvBlue, $cvGreen, $cvRed, 0xFF]
	Return $cvScalar
EndFunc   ;==>_OpenCV_RGB

Func _OpenCV_Scalar($v0 = 0, $v1 = 0, $v2 = 0, $v3 = 0)
	Local $cvScalar[4] = [$v0, $v1, $v2, $v3]
	Return $cvScalar
EndFunc   ;==>_OpenCV_Scalar

Func _OpenCV_ScalarAll($v0 = 0)
	Local $cvScalar[4] = [$v0, $v0, $v0, $v0]
	Return $cvScalar
EndFunc   ;==>_OpenCV_ScalarAll

Func _OpenCV_ScalarMat($v0 = 0)
	Local $cvScalar[4] = [$v0, $v0, $v0, $v0]
	Return _OpenCV_ObjCreate("cv.Mat").create(1, 1, $CV_64F, $cvScalar)
EndFunc   ;==>_OpenCV_ScalarMat

Func _OpenCV_Point($x = 0, $y = 0)
	Local $cvSize[2] = [$x, $y]
	Return $cvSize
EndFunc   ;==>_OpenCV_Point

Func _OpenCV_Size($width = 0, $height = 0)
	Local $cvSize[2] = [$width, $height]
	Return $cvSize
EndFunc   ;==>_OpenCV_Size

Func _OpenCV_Rect($x = 0, $y = 0, $width = 0, $height = 0)
	Local $cvSize[4] = [$x, $y, $width, $height]
	Return $cvSize
EndFunc   ;==>_OpenCV_Rect

Func _OpenCV_ArraySort(ByRef $aArray, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_OpenCV_Sort($aArray, "__OpenCV_ArraySize", "__OpenCV_ArrayGetter", "__OpenCV_ArraySetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_OpenCV_ArraySort

Func _OpenCV_VectorSort(ByRef $oVector, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_OpenCV_Sort($oVector, "__OpenCV_VectorSize", "__OpenCV_VectorGetter", "__OpenCV_VectorSetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_OpenCV_VectorSort

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_Sort
; Description ...: Sort a collection using a custom comapator, getter, setter
; Syntax ........: _OpenCV_ArraySort(ByRef $aArray[, $sCompare = Default[, $iOrder = Default[, $iStart = Default[,
;                  $iEnd = Default]]]])
; Parameters ....: $aArray              - [in/out] array to sort.
;                  $sGetSize            - [optional] get size function. Default is array UBound
;                  $sGetter             - [optional] getter function. Default is array getter
;                  $sSetter             - [optional] setter function. Default is array setter
;                  $sCompare            - [optional] comparator function. Default is "StringCompare".
;                  $iOrder              - [optional] sorting order. 1 for asc, -1 for desc. Default is 1.
;                  $iStart              - [optional] index of array to start sorting at. Default is 0
;                  $iEnd                - [optional] index of array to stop sorting at (included). Default is UBound($aArray) - 1
; Return values .: None
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OpenCV_Sort(ByRef $aArray, $sGetSize, $sGetter, $sSetter, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	Local $iUBound = Call($sGetSize, $aArray) - 1

	If $sCompare == Default Then $sCompare = "StringCompare"
	If $iOrder == Default Then $iOrder = $OPENCV_UDF_SORT_ASC
	If $iStart < 0 Or $iStart = Default Then $iStart = 0
	If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
	If $iEnd <= $iStart Then Return

	__OpenCV_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_OpenCV_Sort

; #FUNCTION# ====================================================================================================================
; Name ..........: __OpenCV_QuickSort
; Description ...: Helper function for sorting collections
; Syntax ........: __OpenCV_QuickSort(ByRef $aArray, Const ByRef $sCompare, Const ByRef $iStart, Const ByRef $iEnd)
; Parameters ....: $aArray              - [in/out] array to sort.
;                  $sGetter             - [in/out and const] getter function.
;                  $sSetter             - [in/out and const] setter function.
;                  $sCompare            - [in/out and const] comparator function.
;                  $iOrder              - [optional] sorting order. 1 for asc, -1 for desc. Default is 1.
;                  $iStart              - [in/out and const] index of array to start sorting at.
;                  $iEnd                - [in/out and const] index of array to stop sorting at (included).
; Return values .: None
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......: A modified version of Array.au3 __ArrayQuickSort1D
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __OpenCV_QuickSort(ByRef $aArray, Const ByRef $sGetter, Const ByRef $sSetter, Const ByRef $sCompare, Const ByRef $iOrder, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp, $vValue

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) <= 16 Then
		For $i = $iStart + 1 To $iEnd
			$vTmp = Call($sGetter, $aArray, $i)

			For $j = $i - 1 To $iStart Step -1
				$vValue = Call($sGetter, $aArray, $j)
				If Call($sCompare, $vTmp, $vValue) * $iOrder >= 0 Then ExitLoop
				Call($sSetter, $aArray, $j + 1, $vValue)
			Next

			Call($sSetter, $aArray, $j + 1, $vTmp)
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = Call($sGetter, $aArray, Int(($iStart + $iEnd) / 2))
	Do
		While Call($sCompare, Call($sGetter, $aArray, $L), $vPivot) * $iOrder < 0
			$L += 1
		WEnd
		While Call($sCompare, Call($sGetter, $aArray, $R), $vPivot) * $iOrder > 0
			$R -= 1
		WEnd

		; Swap
		If $L <= $R Then
			If $L <> $R Then
				$vTmp = Call($sGetter, $aArray, $L)
				Call($sSetter, $aArray, $L, Call($sGetter, $aArray, $R))
				Call($sSetter, $aArray, $R, $vTmp)
			EndIf
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__OpenCV_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $iStart, $R)
	__OpenCV_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $L, $iEnd)
EndFunc   ;==>__OpenCV_QuickSort

Func __OpenCV_ArraySize(ByRef $aArray)
	Return UBound($aArray)
EndFunc   ;==>__OpenCV_ArraySize

Func __OpenCV_ArrayGetter(ByRef $aArray, $i)
	Return $aArray[$i]
EndFunc   ;==>__OpenCV_ArrayGetter

Func __OpenCV_ArraySetter(ByRef $aArray, $i, $vValue)
	$aArray[$i] = $vValue
EndFunc   ;==>__OpenCV_ArraySetter

Func __OpenCV_VectorSize(ByRef $oVector)
	Return $oVector.size()
EndFunc   ;==>__OpenCV_VectorSize

Func __OpenCV_VectorGetter(ByRef $oVector, $i)
	Return $oVector.at($i)
EndFunc   ;==>__OpenCV_VectorGetter

Func __OpenCV_VectorSetter(ByRef $oVector, $i, $vValue)
	$oVector.at($i, $vValue)
EndFunc   ;==>__OpenCV_VectorSetter

Func _OpenCV_FourPointTransform($image, $pts)
	Local Const $cv = _OpenCV_get()

	;; obtain a consistent order of the points and unpack them
	;; individually
	Local $rect = _OpenCV_OrderPoints($pts)
	Local $tl = $rect.Point_at(0)
	Local $tr = $rect.Point_at(1)
	Local $br = $rect.Point_at(2)
	Local $bl = $rect.Point_at(3)

	;; compute the width of the new image, which will be the
	;; maximum distance between bottom-right and bottom-left
	;; x-coordiates or the top-right and top-left x-coordinates
	Local $widthA = Sqrt((($br[0] - $bl[0]) ^ 2) + (($br[1] - $bl[1]) ^ 2))
	Local $widthB = Sqrt((($tr[0] - $tl[0]) ^ 2) + (($tr[1] - $tl[1]) ^ 2))
	Local $maxWidth = _Max($widthA, $widthB)

	;; compute the height of the new image, which will be the
	;; maximum distance between the top-right and bottom-right
	;; y-coordinates or the top-left and bottom-left y-coordinates
	Local $heightA = Sqrt((($tr[0] - $br[0]) ^ 2) + (($tr[1] - $br[1]) ^ 2))
	Local $heightB = Sqrt((($tl[0] - $bl[0]) ^ 2) + (($tl[1] - $bl[1]) ^ 2))
	Local $maxHeight = _Max($heightA, $heightB)

	;; now that we have the dimensions of the new image, construct
	;; the set of destination points to obtain a "birds eye view",
	;; (i.e. top-down view) of the image, again specifying points
	;; in the top-left, top-right, bottom-right, and bottom-left
	;; order
	Local $dst = _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2f(_OpenCV_Tuple( _
			_OpenCV_Point(0, 0), _
			_OpenCV_Point($maxWidth - 1, 0), _
			_OpenCV_Point($maxWidth - 1, $maxHeight - 1), _
			_OpenCV_Point(0, $maxHeight - 1) _
			))

	;; compute the perspective transform matrix and then apply it
	Local $M = $cv.getPerspectiveTransform($rect, $dst)
	Local $warped = $cv.warpPerspective($image, $M, _OpenCV_Size($maxWidth, $maxHeight))

	;; return the warped image
	Return $warped
EndFunc   ;==>_OpenCV_FourPointTransform

Func _OpenCV_OrderPoints($pts)
	;; the original function is has bugs as reported in
	;; https://www.pyimagesearch.com/2014/08/25/4-point-opencv-getperspective-transform-example/#comment-431230
	;; a fixed version has been provided here
	;; https://www.pyimagesearch.com/2016/03/21/ordering-coordinates-clockwise-with-python-and-opencv/
	Local $tmp[$pts.rows]

	For $i = 0 To $pts.rows - 1
		$tmp[$i] = $pts.Point_at($i)
	Next

	;; sort the points based on their x-coordinates then y-coordinates
	_OpenCV_ArraySort($tmp, "_OpenCV_CoordComparator")

	Local $tl, $tr, $br, $bl

	;; the top-left and bottom-left points are the 2 most left points
	;; between those 2 points, the top-left will be the one with the lowest y-coordinate
	;; and the bottom-left will be the other point
	If ($tmp[0])[1] < ($tmp[1])[1] Then
		$tl = $tmp[0]
		$bl = $tmp[1]
	Else
		$tl = $tmp[1]
		$bl = $tmp[0]
	EndIf

	;; the top-right and bottom-right points are the 2 most right points
	;; between those 2 points, the bottom-right will be
	;; the one with the largest euclean distance to the top-left point
	;; and the top right will be the other point
	Local $r1 = $tmp[$pts.rows - 2]
	Local $r2 = $tmp[$pts.rows - 1]

	If _OpenCV_EuclideanDist($tl, $r1) > _OpenCV_EuclideanDist($tl, $r2) Then
		$br = $r1
		$tr = $r2
	Else
		$br = $r2
		$tr = $r1
	EndIf

	Local $rect[] = [$tl, $tr, $br, $bl]
	Return _OpenCV_ObjCreate("cv.Mat").createFromVectorOfVec2f($rect)
EndFunc   ;==>_OpenCV_OrderPoints

Func _OpenCV_CoordComparator($a, $b)
	If $a[0] < $b[0] Then Return -1
	If $a[0] > $b[0] Then Return 1
	If $a[1] < $b[1] Then Return -1
	If $a[1] > $b[1] Then Return 1
	Return 0
EndFunc   ;==>_OpenCV_CoordComparator

Func _OpenCV_EuclideanDist($p, $q)
	Local $dist = 0
	For $i = 0 To UBound($p) - 1
		$dist += ($p[$i] - $q[$i]) ^ 2
	Next
	Return Sqrt($dist)
EndFunc   ;==>_OpenCV_EuclideanDist
