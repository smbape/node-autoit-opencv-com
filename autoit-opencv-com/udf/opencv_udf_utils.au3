#include-once

#include "opencv_udf.au3"

#include <File.au3>
#include <GDIPlus.au3>
#include <Math.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global Const $OPENCV_UDF_SORT_ASC = 1
Global Const $OPENCV_UDF_SORT_DESC = -1
Global $_cv_gdi_resize = 0

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
	Local $iFound = 0, $iNextFound = 0
	Local $iLen = StringLen($sDir)
	Local $sPath = "", $iiFlags = 0

	For $i = 0 To $iParts - 1
		$bFound = False

		If ($iFlag == $FLTA_FILESFOLDERS Or $i <> $iParts - 1) And StringInStr($aParts[$i], "?") == 0 And StringInStr($aParts[$i], "*") == 0 Then
			_OpenCV_DebugMsg("Looking for " & $sDir & "\" & $aParts[$i])
			$bFound = FileExists($sDir & "\" & $aParts[$i])
			If Not $bFound Then
				ExitLoop
			EndIf

			$sDir &= "\" & $aParts[$i]
			ContinueLoop
		EndIf

		_OpenCV_DebugMsg("Listing " & $sDir & "\=" & $aParts[$i])
		$iiFlags = $i == $iParts - 1 ? $iFlag : $FLTA_FILESFOLDERS

		$aFileList = _FileListToArray($sDir, $aParts[$i], $iiFlags, $bReturnPath)
		If @error Then ExitLoop

		If $i == $iParts - 1 Then
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
		For $j = $i + 1 To $iParts - 1
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

	_OpenCV_DebugMsg("_OpenCV_FindFile('" & $sFile & "', '" & $sDir & "') " & VarGetType($aSearchPaths))

	Local $sFound = "", $sPath, $aFileList
	Local $sDrive = "", $sFileName = "", $sExtension = ""

	While 1
		For $i = 1 To $aSearchPaths[0]
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
				ExitLoop 2
			EndIf
		Next

		_PathSplit($sDir, $sDrive, $sDir, $sFileName, $sExtension)
		If $sDir == "" Then
			ExitLoop
		EndIf
		$sDir = $sDrive & StringLeft($sDir, StringLen($sDir) - 1)
	WEnd

	Return $sFound
EndFunc   ;==>_OpenCV_FindFile

Func _OpenCV_FindDLL($sFile, $sFilter = Default, $sDir = Default, $bReverse = Default)
	Local $sBuildType = $_cv_build_type == "Debug" ? "Debug" : "Release"
	Local $sPostfix = $_cv_build_type == "Debug" ? "d" : ""

	Local $aSearchPaths[10] = [ _
		9, _
		".", _
		"build_x64", _
		"build_x64\" & $sBuildType, _
		"build", _
		"build\x64", _
		"build\x64\vc15\bin", _
		"autoit-opencv-com", _
		"autoit-opencv-com\build_x64", _
		"autoit-opencv-com\build_x64\" & $sBuildType _
	]
	Return _OpenCV_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, $aSearchPaths, $bReverse)
EndFunc   ;==>_OpenCV_FindDLL

Func _OpenCV_imread_and_check($fileName, $flags = Default)
	Local Const $cv = _OpenCV_get()
	Local $img = $cv.imread($fileName, $flags)
	If $img.empty() Then
		ConsoleWriteError("!>Error: The image " & $fileName & " could not be loaded." & @CRLF)
	EndIf
	Return $img
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

	Local $iPadWidth = Floor(($iHintWidth - $iDstWidth) / 2)
	Local $iPadHeight = Floor(($iHintHeight - $iDstHeight) / 2)

	If $iPadWidth < 0 Then $iPadWidth = 0
	If $iPadHeight < 0 Then $iPadHeight = 0

	Return _OpenCV_Tuple($iDstWidth, $iDstHeight, $iPadWidth, $iPadHeight)
EndFunc   ;==>_OpenCV_computeResizeParams

Func _OpenCV_resizeAndCenter($src, $iDstWidth = Default, $iDstHeight = Default, $aBackgroundColor = Default, $bResize = Default, $bEnlarge = Default, $bCenter = Default, $interpolation = Default)
	If $aBackgroundColor == Default Then $aBackgroundColor = _OpenCV_Scalar(0xF0, 0xF0, 0xF0, 0xFF)
	If $bResize == Default Then $bResize = True
	If $bCenter == Default Then $bCenter = True
	If $bEnlarge == Default Then $bEnlarge = False

	If Not $bResize And Not $bCenter Then Return $src

	Local $aParams = _OpenCV_computeResizeParams($src.width, $src.height, $iDstWidth, $iDstHeight, $bEnlarge)
	Local $iWidth = $aParams[0]
	Local $iHeight = $aParams[1]
	Local $iPadWidth = $aParams[2]
	Local $iPadHeight = $aParams[3]

	If $iDstWidth == Default Then $iDstWidth = $iWidth
	If $iDstHeight == Default Then $iDstHeight = $iHeight

	Local Const $cv = _OpenCV_get()
	; Local $hTimer

	If $bResize Then
		If $_cv_gdi_resize And $__g_hGDIPDll > 0 Then
			Switch $interpolation
				Case $CV_INTER_NEAREST
					$interpolation = $GDIP_INTERPOLATIONMODE_NEARESTNEIGHBOR
				Case $CV_INTER_LINEAR
					$interpolation = $GDIP_INTERPOLATIONMODE_BILINEAR
				Case $CV_INTER_CUBIC
					$interpolation = $GDIP_INTERPOLATIONMODE_BICUBIC
				Case $CV_INTER_AREA
					$interpolation = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC
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
			; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : cv.resize ' & TimerDiff($hTimer) & ' ms' & @CRLF) ;### Debug Console
		Else
			; $hTimer = TimerInit()
			$src = $cv.resize($src, _OpenCV_Size($iWidth, $iHeight), 0, 0, $interpolation)
			; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : cv.resize ' & TimerDiff($hTimer) & ' ms' & @CRLF) ;### Debug Console
		EndIf
	EndIf

	If $bCenter And ($iPadWidth > 0 Or $iPadHeight > 0) Then
		Local $padded = ObjCreate("OpenCV.cv.Mat").create($iDstHeight, $iDstWidth, $src.depth())
		$cv.copyMakeBorder($src, $iPadHeight, $iPadHeight, $iPadWidth, $iPadWidth, $CV_BORDER_CONSTANT, $aBackgroundColor, $padded)
		$src = $padded
	EndIf

	Return $src
EndFunc   ;==>_OpenCV_resizeAndCenter

Func _OpenCV_SetControlPic($controlID, $src, $iDstWidth = Default, $iDstHeight = Default, $aBackgroundColor = Default, $bResize = False, $bEnlarge = False, $bCenter = False, $interpolation = $CV_INTER_AREA)
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

	Local Const $cv = _OpenCV_get()

	Local $iWidth = $img.width
	Local $iHeight = $img.height

	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFO)
	Local $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($tBITMAPINFO))

	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = $iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8
	$tBIHDR.biCompression = $BI_RGB

	; Local $hTimer
	; $hTimer = TimerInit()
	Local $pBits
	Local $hDIB = _WinAPI_CreateDIBSection(_WinAPI_GetDesktopWindow(), $tBITMAPINFO, $DIB_RGB_COLORS, $pBits)
	Local $dst = _OpenCV_ObjCreate("cv.Mat").create($img.rows, $img.cols, CV_MAKETYPE($CV_8U, $iChannels), $pBits, BitAND($img.cols * $iChannels + 3, -4))
	$img.convertToShow($dst)

	$cv.flip($dst, 0, $dst)

	Return $hDIB
EndFunc   ;==>_OpenCV_GetHBITMAP

Func _OpenCV_imshow_ControlPic($mat, $hWnd, $controlID, $aBackgroundColor = Default, $bResize = True, $bEnlarge = Default, $bCenter = True, $interpolation = Default)
	Local $aPicPos = ControlGetPos($hWnd, "", $controlID)
	_OpenCV_SetControlPic($controlID, $mat, $aPicPos[2], $aPicPos[3], $aBackgroundColor, $bResize, $bEnlarge, $bCenter, $interpolation)
EndFunc   ;==>_OpenCV_imshow_ControlPic

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenBits
; Description ...: Get the screen color bytes
; Syntax ........: _OpenCV_GetDesktopScreenBits(Byref $aRect)
; Parameters ....: $aRect               - [in] an array [left, top, width, height]
;                  $iChannels           - [in] number of channels (3, 4). Default is 3
; Return values .: a byte[] struct of ABRG colors of the screen. Can be used as data for an opencv matrix
; Author ........: Stéphane MBAPE
; Modified ......:
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenBits($aRect, $iChannels = Default)
	If $iChannels == Default Then $iChannels = 4

	Local $iLeft = $aRect[0]
	Local $iTop = $aRect[1]
	Local $iWidth = $aRect[2]
	Local $iHeight = $aRect[3]
	Local $iSize = $iWidth * $iHeight * $iChannels

	Local $tBits = DllStructCreate('byte value[' & $iSize & ']')

	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hDesktopDC = _WinAPI_GetDC($hWnd)
	Local $hMemoryDC = _WinAPI_CreateCompatibleDC($hDesktopDC) ;create compatible memory DC

	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFO)
	Local $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($tBITMAPINFO))
	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = -$iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8

	Local $pBits
	Local $hDIB = _WinAPI_CreateDIBSection($hWnd, $tBITMAPINFO, $DIB_RGB_COLORS, $pBits)

	_WinAPI_SelectObject($hMemoryDC, $hDIB)
	_WinAPI_BitBlt($hMemoryDC, 0, 0, $iWidth, $iHeight, $hDesktopDC, $iLeft, $iTop, $SRCCOPY)

	; $pBits will be unallacoted when _WinAPI_DeleteObject will be called
	; to be able to preserve the values,
	; keep the values in our own allocated memory
	_OpenCV_DllCall("msvcrt.dll", "ptr", "memcpy_s", "struct*", $tBits, "ulong_ptr", $iSize, "ptr", $pBits, "ulong_ptr", $iSize)

	_WinAPI_DeleteObject($hDIB)
	_WinAPI_DeleteDC($hMemoryDC)
	_WinAPI_ReleaseDC($hWnd, $hDesktopDC)

	Return $tBits
EndFunc   ;==>_OpenCV_GetDesktopScreenBits

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenMat
; Description ...: Get the screen image mat
; Syntax ........: _OpenCV_GetDesktopScreenMat(Byref $aRect)
; Parameters ....: $aRect               - [in] an array [left, top, width, height]
;                  $iChannels           - [in] number of channels (3, 4). Default is 3
; Return values .: an opencv matrix
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......: https://github.com/opencv/opencv/blob/4.5.4/modules/highgui/src/window_w32.cpp#L1407
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenMat($aRect, $iChannels = Default)
	If $iChannels == Default Then $iChannels = 3

	Local Const $cv = _OpenCV_get()

	Local $iLeft = $aRect[0]
	Local $iTop = $aRect[1]
	Local $iWidth = $aRect[2]
	Local $iHeight = $aRect[3]

	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hDesktopDC = _WinAPI_GetDC($hWnd)
	Local $hMemoryDC = _WinAPI_CreateCompatibleDC($hDesktopDC) ;create compatible memory DC

	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFO)
	Local $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($tBITMAPINFO))
	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = $iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8

	Local $pBits
	Local $hDIB = _WinAPI_CreateDIBSection($hWnd, $tBITMAPINFO, $DIB_RGB_COLORS, $pBits)

	_WinAPI_SelectObject($hMemoryDC, $hDIB)
	_WinAPI_BitBlt($hMemoryDC, 0, 0, $iWidth, $iHeight, $hDesktopDC, $iLeft, $iTop, $SRCCOPY)

	Local $dst = _OpenCV_ObjCreate("cv.Mat").create($iHeight, $iWidth, CV_MAKETYPE($CV_8U, $iChannels), $pBits, BitAND($iWidth * $iChannels + 3, -4)) ;
	$dst = $cv.flip($dst, 0)

	_WinAPI_DeleteObject($hDIB)
	_WinAPI_DeleteDC($hMemoryDC)
	_WinAPI_ReleaseDC($hWnd, $hDesktopDC)

	Return $dst
EndFunc   ;==>_OpenCV_GetDesktopScreenMat

Func _OpenCV_CompareMatHist($matSrc, $matDst, $matMask, $aChannels, $aHistSize, $aRanges, $iCompareMethod = $CV_HISTCMP_CORREL, $bAccumulate = False)
	Local Const $cv = _OpenCV_get()

	Local $aMatSrc[1] = [$matSrc]
	Local $matHistSrc = $cv.calcHist($aMatSrc, $aChannels, $matMask, $aHistSize, $aRanges, $bAccumulate)
	$cv.normalize($matHistSrc, $matHistSrc, 0, 1, $CV_NORM_MINMAX)

	Local $aMatDst[1] = [$matDst]
	Local $matHistDst = $cv.calcHist($aMatDst, $aChannels, $matMask, $aHistSize, $aRanges, $bAccumulate)
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
;                  https://docs.opencv.org/4.5.1/d8/ded/samples_2cpp_2tutorial_code_2Histograms_Matching_2MatchTemplate_Demo_8cpp-example.html#a16
;                  https://vovkos.github.io/doxyrest-showcase/opencv/sphinx_rtd_theme/page_tutorial_histogram_calculation.html
; ===============================================================================================================================
Func _OpenCV_FindTemplate($matImg, $matTempl, $fThreshold = 0.95, $iMatchMethod = $CV_TM_CCOEFF_NORMED, $matTemplMask = Default, $iLimit = Default, $iCode = Default, $fOverlapping = 2, $aChannels = Default, $aHistSize = Default, $aRanges = Default, $iCompareMethod = $CV_HISTCMP_CORREL, $iDstCn = 0, $bAccumulate = False)
	Local Const $cv = _OpenCV_get()

	If $iCode == Default Then $iCode = -1
	If $iLimit == Default Then $iLimit = 20

	If $iCode >= 0 Then
		$matImg = $cv.cvtColor($matImg, $iCode, $iDstCn)
		$matTempl = $cv.cvtColor($matTempl, $iCode, $iDstCn)
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
			$arr[$i] = 32
		Next
		$aHistSize = $arr
	EndIf

	If $aRanges == Default Then
		Local $arr[$matImg.channels() * 2]
		For $i = 0 To $matImg.channels() - 1
			$arr[2 * $i] = 0
			$arr[2 * $i + 1] = 256
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

	Local $mat = _OpenCV_ObjCreate("cv.Mat")
	Local $matResult ; = $Mat.create($rh, $rw, $CV_32FC1)

	Local $bMethodAcceptsMask = $CV_TM_SQDIFF == $iMatchMethod Or $iMatchMethod == $CV_TM_CCORR_NORMED
	Local $bIsNormed = $iMatchMethod == $CV_TM_SQDIFF_NORMED Or $iMatchMethod == $CV_TM_CCORR_NORMED Or $iMatchMethod == $CV_TM_CCOEFF_NORMED

	; Local $hTimer, $fDiff

	; $hTimer = TimerInit()
	If $bMethodAcceptsMask Then
		$matResult = $cv.matchTemplate($matImg, $matTempl, $iMatchMethod, $matTemplMask)
	Else
		$matResult = $cv.matchTemplate($matImg, $matTempl, $iMatchMethod)
	EndIf

	; $fDiff = TimerDiff($hTimer)
	; ConsoleWrite("matchTemplate took " & $fDiff & "ms" & @CRLF)

	Local $aMatchLoc
	Local $fHistScore = 1
	Local $fScore = 0
	Local $fVisited
	Local $iFound = 0

	; For SQDIFF and SQDIFF_NORMED, the best matches are lower values. For all the other methods, the higher the better
	If ($iMatchMethod == $CV_TM_SQDIFF Or $iMatchMethod == $CV_TM_SQDIFF_NORMED) Then
		$fVisited = 1.0
	Else
		$fVisited = 0.0
	EndIf

	If Not $bIsNormed Then
		$cv.normalize($matResult, $matResult, 0, 1, $CV_NORM_MINMAX)
	EndIf

	; there are $rh rows and $rw cols in the result matrix
	; create a mask with the same number of rows and cols
	Local $matResultMask = $mat.ones($rh, $rw, $CV_8UC1)
	Local $minVal, $maxVal, $aMinLoc, $aMaxLoc

	; $hTimer = TimerInit()
	While $iLimit > 0 ;use infinite loop since ExitLoop will get called
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

			Local $matImgMatch = $mat.create($matImg, $aMatchRect)
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

		; Mark as visited
		$matResult.float_set_at($aMinLoc, $fVisited)
		$matResult.float_set_at($aMaxLoc, $fVisited)

		Local $tw = Ceiling($fOverlapping * $w)
		Local $th = Ceiling($fOverlapping * $h)
		Local $x = _Max(0, $aMatchLoc[0] - $tw / 2)
		Local $y = _Max(0, $aMatchLoc[1] - $th / 2)

		; will template come beyond the mask?:if yes-cut off margin
		If $x + $tw > $rw Then $tw = $rw - $x
		If $y + $th > $rh Then $th = $rh - $y

		Local $aMaskedRect[4] = [$x, $y, $tw, $th]
		Local $matMasked = $mat.zeros($th, $tw, $CV_8UC1)
		Local $matMaskedRect = $mat.create($matResultMask, $aMaskedRect)

		; mask the locations that should not be matched again
		$matMasked.copyTo($matMaskedRect)
	WEnd
	; $fDiff = TimerDiff($hTimer)
	; ConsoleWrite("minMaxLoc took " & $fDiff & "ms" & @CRLF)

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

	Return $cv.warpAffine($img, $M, $size, $flags, $borderMode, $borderValue, $rotated)
EndFunc   ;==>_OpenCV_RotateBound

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

; Array.from(Array(30).keys()).map(i => `$val${ i } = 0`).join(", ")
Func _OpenCV_Tuple($val0 = 0, $val1 = 0, $val2 = 0, $val3 = 0, $val4 = 0, $val5 = 0, $val6 = 0, $val7 = 0, $val8 = 0, $val9 = 0, $val10 = 0, $val11 = 0, $val12 = 0, $val13 = 0, $val14 = 0, $val15 = 0, $val16 = 0, $val17 = 0, $val18 = 0, $val19 = 0, $val20 = 0, $val21 = 0, $val22 = 0, $val23 = 0, $val24 = 0, $val25 = 0, $val26 = 0, $val27 = 0, $val28 = 0, $val29 = 0)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ j + 1 }
	;     Local $_aResult[@NumParams] = [${ Array.from(Array(j + 1).keys()).map(i => `$val${ i }`).join(", ") }]
	;     Return $_aResult
	; `.trim()).join("\n"))
	Switch @NumParams
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
			ConsoleWriteError('!>Error: Invalid number of arguments')
			Return SetError(1, 0, -1)
	EndSwitch

	Return $_aResult
EndFunc   ;==>_OpenCV_Tuple

Func _OpenCV_ArraySort(ByRef $aArray, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_OpenCV_Sort($aArray, "__OpenCV_ArraySize", "__OpenCV_ArrayGetter", "__OpenCV_ArraySetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_OpenCV_ArraySort

Func _OpenCV_VectorSort(ByRef $oVector, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_OpenCV_Sort($oVector, "__OpenCV_VectorSize", "__OpenCV_VectorGetter", "__OpenCV_VectorSetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_OpenCV_VectorSort

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_Sort
; Description ...: Sort a collection using a custom comapator, getter, setter
; Syntax ........: _OpenCV_ArraySort(Byref $aArray[, $sCompare = Default[, $iOrder = Default[, $iStart = Default[,
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
; Syntax ........: __OpenCV_QuickSort(Byref $aArray, Const Byref $sCompare, Const Byref $iStart, Const Byref $iEnd)
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

	Local $rect = _OpenCV_Tuple($tl, $tr, $br, $bl)
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
