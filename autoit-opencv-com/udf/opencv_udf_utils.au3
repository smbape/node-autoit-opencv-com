#include-once

#include "opencv_udf.au3"
#include "cv_interface.au3"
#include "cv_enums.au3"

#include <File.au3>
#include <Math.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>

Local Const $aDefaultFormBackground[4] = [0xF0, 0xF0, 0xF0, 0xFF]
Local Const $aDefaultSearchPaths[2] = [1, "."]

Func _OpenCV_FindFiles($aParts, $sDir = Default, $iFlag = Default, $bReturnPath = Default)
	If $sDir == Default Then
		$sDir = @ScriptDir
	EndIf

	If $iFlag == Default Then
		$iFlag = $FLTA_FILESFOLDERS
	EndIf

	If $bReturnPath == Default Then
		$bReturnPath = False
	EndIf

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
		If @error Then
			ExitLoop
		EndIf

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

			$aNextFileList = _OpenCV_FindFiles($aNextParts, $sPath, $iFlag, $bReturnPath)
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

	Return $aMatches
EndFunc   ;==>_OpenCV_FindFiles

Func _OpenCV_FindFile($sFile, $sFilter = Default, $sDir = Default, $iFlag = Default, $bReturnPath = Default, $aSearchPaths = Default)
    If $sFilter == Default Then
        $sFilter = ""
    EndIf

    If $sDir == Default Then
        $sDir = @ScriptDir
    EndIf

    If $aSearchPaths == Default Then
        $aSearchPaths = $aDefaultSearchPaths
    EndIf

    _OpenCV_DebugMsg("_OpenCV_FindFile('" & $sFile & "', '" & $sDir & "')")

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

            $aFileList = _OpenCV_FindFiles($sPath, $sDir, $iFlag, True)
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

Func _OpenCV_FindDLL($sFile, $sFilter = Default, $sDir = Default)
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
    Return _OpenCV_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, True, $aSearchPaths)
EndFunc   ;==>_OpenCV_FindDLL

Func _OpenCV_imread_and_check($fileName, $flags = Default)
	Local $cv = _OpenCV_get()
	Local $img = $cv.imread($fileName, $flags)
	If $img.empty() Then
		ConsoleWriteError("!>Error: The image " & $fileName & " could not be loaded." & @CRLF)
	EndIf
	Return $img
EndFunc   ;==>_OpenCV_imread_and_check

Func _OpenCV_resizeAndCenter($matImg, $iDstWidth, $iDstHeight, $aBackgroundColor, $iCode = -1, $bFit = True)
	Local $iWidth = $matImg.width
	Local $iHeight = $matImg.height

	Local $fRatio = $iWidth / $iHeight
	Local $iPadHeight = 0
	Local $iPadWidth = 0

	If $iWidth <= $iDstWidth And $iHeight <= $iDstHeight Then
		$bFit = False
		$iPadHeight = Floor(($iDstHeight - $iHeight) / 2)
		$iPadWidth = Floor(($iDstWidth - $iWidth) / 2)
	ElseIf $fRatio * $iDstHeight > $iDstWidth Then
		$iWidth = $iDstWidth
		$iHeight = Floor($iWidth / $fRatio)
		$iPadHeight = Floor(($iDstHeight - $iHeight) / 2)
	Else
		$iHeight = $iDstHeight
		$iWidth = Floor($iHeight * $fRatio)
		$iPadWidth = Floor(($iDstWidth - $iWidth) / 2)
	EndIf

	Local $cv = _OpenCV_get()

	If $iCode <> -1 Then
		$matImg = $cv.cvtColor($matImg, $iCode)
	EndIf

	If $bFit Then
		Local $aDsize[2] = [$iWidth, $iHeight]
		$matImg = $cv.resize($matImg, $aDsize)
	EndIf

	Local $matResult = ObjCreate("OpenCV.cv.Mat").create($iDstHeight, $iDstWidth, $CV_8UC4)
	$cv.copyMakeBorder($matImg, $iPadHeight, $iPadHeight, $iPadWidth, $iPadWidth, $CV_BORDER_CONSTANT, $aBackgroundColor, $matResult)

	Return $matResult
EndFunc   ;==>_OpenCV_resizeAndCenter

Func _OpenCV_SetControlPic($controlID, $matImg)
	Local $iWidth = $matImg.width
	Local $iHeight = $matImg.height

	Local $iChannels = $matImg.channels()
	Local $iSize = $iWidth * $iHeight * $iChannels

	Local $tBIHDR = DllStructCreate($tagBITMAPINFO)
	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = -$iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8

	Local $aDIB = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", $DIB_RGB_COLORS, "ptr*", 0, "ptr", 0, "dword", 0)
	_OpenCV_DllCall("msvcrt.dll", "ptr", "memcpy_s", "ptr", $aDIB[4], "ulong_ptr", $iSize, "ptr", $matImg.data, "ulong_ptr", $iSize)
	Local $hPrevImage = _SendMessage(GUICtrlGetHandle($controlID), $STM_SETIMAGE, 0, $aDIB[0])
	_WinAPI_DeleteObject($hPrevImage) ; Delete Prev image if any
	_WinAPI_DeleteObject($aDIB[0])
EndFunc   ;==>_OpenCV_SetControlPic

Func _OpenCV_imshow_ControlPic($mat, $hWnd, $controlID, $aBackgroundColor = $aDefaultFormBackground, $iCode = -1, $bFit = True)
	Local $depth = $mat.depth()
	Local $channels = $mat.channels()

	If $iCode == -1 Then
		Switch CV_MAT_TYPE($mat.flags)
			Case $CV_8UC1
				$iCode = $CV_COLOR_GRAY2BGRA
			Case $CV_8UC3
				$iCode = $CV_COLOR_BGR2BGRA
			Case $CV_8UC4
				$iCode = -1
			Case $CV_32FC1
				; convert CV_32FC1 in range [0, 1] to CV_8UC1 in range [0, 255]
				$mat = $mat.convertTo($CV_8UC1, 255.0, 0)

				; then display the CV_8UC1 image (.i.e gray) as a BGRA image
				$iCode = $CV_COLOR_GRAY2BGRA
			Case Else
				ConsoleWriteError("!>Error: The image type is not supported." & @CRLF)
				Return
		EndSwitch
	EndIf

	Local $aPicPos = ControlGetPos($hWnd, "", $controlID)
	Local $matResized = _OpenCV_resizeAndCenter($mat, $aPicPos[2], $aPicPos[3], $aBackgroundColor, $iCode, $bFit)
	_OpenCV_SetControlPic($controlID, $matResized)

EndFunc   ;==>_OpenCV_imshow_ControlPic

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenCV_GetDesktopScreenBits
; Description ...: Get the screen color bytes
; Syntax ........: _OpenCV_GetDesktopScreenBits(Byref $aRect)
; Parameters ....: $aRect               - [in] a $tagRect struct value.
; Return values .: a byte[] struct of ABRG colors of the screen. Can be used as data for an opencv matrix
; Author ........: Stéphane MBAPE
; Modified ......:
; ===============================================================================================================================
Func _OpenCV_GetDesktopScreenBits(ByRef $aRect)
	Local $iLeft = $aRect[0]
	Local $iTop = $aRect[1]
	Local $iWidth = $aRect[2]
	Local $iHeight = $aRect[3]
	Local $iChannels = 4
	Local $iSize = $iWidth * $iHeight * $iChannels

	Local $tBits = DllStructCreate('byte value[' & $iSize & ']')

	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hDesktopDC = _WinAPI_GetDC($hWnd)
	Local $hMemoryDC = _WinAPI_CreateCompatibleDC($hDesktopDC) ;create compatible memory DC

	Local $tBIHDR = DllStructCreate($tagBITMAPINFO)
	$tBIHDR.biSize = DllStructGetSize($tBIHDR)
	$tBIHDR.biWidth = $iWidth
	$tBIHDR.biHeight = -$iHeight
	$tBIHDR.biPlanes = 1
	$tBIHDR.biBitCount = $iChannels * 8

	Local $aDIB = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", $DIB_RGB_COLORS, "ptr*", 0, "ptr", 0, "dword", 0)

	_WinAPI_SelectObject($hMemoryDC, $aDIB[0])
	_WinAPI_BitBlt($hMemoryDC, 0, 0, $iWidth, $iHeight, $hDesktopDC, $iLeft, $iTop, $SRCCOPY)

	; $aDIB[4] will be unallacoted when _WinAPI_DeleteObject will be called
	; to be able to preserve the values,
	; keep the values in our own allocated memory
	_OpenCV_DllCall("msvcrt.dll", "ptr", "memcpy_s", "struct*", $tBits, "ulong_ptr", $iSize, "ptr", $aDIB[4], "ulong_ptr", $iSize)

	_WinAPI_DeleteObject($aDIB[0])
	_WinAPI_DeleteDC($hMemoryDC)
	_WinAPI_ReleaseDC($hWnd, $hDesktopDC)

	$tBIHDR = 0

	Return $tBits
EndFunc   ;==>_OpenCV_GetDesktopScreenBits

Func _OpenCV_CompareMatHist($matSrc, $matDst, $matMask, $aChannels, $aHistSize, $aRanges, $iCompareMethod = $CV_HISTCMP_CORREL, $bAccumulate = False)
	Local $cv = _OpenCV_get()

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
;                                             $fOverlapping = 1     : two matches can overlap half-body of template
;                                             $fOverlapping = 2     : no overlapping,only border touching possible
;                                             $fOverlapping = > 2   : distancing matches
;                                             0 < $fOverlapping < 1 : matches can overlap more then half.
;                                             Default is 2.
;                  $aChannels           - [optional] an array of ints. List of the dims channels used to compute the histogram.
;                  $aHistSize           - [optional] an array of int. Array of histogram sizes in each dimension.
;                  $aRanges             - [optional] an array of float. Array of the dims arrays of the histogram bin boundaries in each dimension.
;                  $iCompareMethod      - [optional] an integer value. Default is $CV_HISTCMP_CORREL.
;                  $iDstCn              - [optional] an integer value. Default is 0.
;                  $bAccumulate         - [optional] a boolean value. Default is False.
; Return values .: An array of matches [[x1, y1, s1], [x2, y2, s2], ..., [xn, yn, sn]]
; Author ........: Stéphane MBAPE
; Modified ......:
; Sources .......: https://stackoverflow.com/a/28647930
;                  https://docs.opencv.org/4.5.1/d8/ded/samples_2cpp_2tutorial_code_2Histograms_Matching_2MatchTemplate_Demo_8cpp-example.html#a16
;                  https://vovkos.github.io/doxyrest-showcase/opencv/sphinx_rtd_theme/page_tutorial_histogram_calculation.html
; ===============================================================================================================================
Func _OpenCV_FindTemplate($matImg, $matTempl, $fThreshold = 0.95, $iMatchMethod = $CV_TM_CCOEFF_NORMED, $matTemplMask = Default, $iLimit = Default, $iCode = Default, $fOverlapping = 2, $aChannels = Default, $aHistSize = Default, $aRanges = Default, $iCompareMethod = $CV_HISTCMP_CORREL, $iDstCn = 0, $bAccumulate = False)
	Local $cv = _OpenCV_get()

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

	Local $width = $matImg.width
	Local $height = $matImg.height

	Local $w = $matTempl.width
	Local $h = $matTempl.height

	Local $aMatchRect[4] = [0, 0, $w, $h]

	Local $rw = $width - $w + 1
	Local $rh = $height - $h + 1

	Local $mat = ObjCreate("OpenCV.cv.Mat")
	Local $matResult ; = $Mat.create($rh, $rw, $CV_32FC1)

	Local $bMethodAcceptsMask = $CV_TM_SQDIFF == $iMatchMethod Or $iMatchMethod == $CV_TM_CCORR_NORMED
	Local $bIsNormed = $iMatchMethod == $CV_TM_SQDIFF_NORMED Or $iMatchMethod == $CV_TM_CCORR_NORMED Or $iMatchMethod == $CV_TM_CCOEFF_NORMED

	Local $hTimer, $fDiff
	$hTimer = TimerInit()
	If $bMethodAcceptsMask Then
		$matResult = $cv.matchTemplate($matImg, $matTempl, $iMatchMethod, $matTemplMask)
	Else
		$matResult = $cv.matchTemplate($matImg, $matTempl, $iMatchMethod)
	EndIf

	$fDiff = TimerDiff($hTimer)
	; ConsoleWrite("matchTemplate took " & $fDiff & "ms" & @CRLF)

	Local $aMatchLoc
	Local $fHistScore = 1
	Local $fScore = 0
	Local $fVisited
	Local $aResult[$iLimit][3]
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

	$hTimer = TimerInit()
	While 1 ;use infinite loop since ExitLoop will get called
		If $iLimit == 0 Then
			ExitLoop
		EndIf

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
	$fDiff = TimerDiff($hTimer)
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

	Local $cv = _OpenCV_get()
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
EndFunc   ;==>_OpenCV_Scalar

Func _OpenCV_Point($x = 0, $y = 0)
	Local $cvSize[2] = [$x, $y]
	Return $cvSize
EndFunc   ;==>_OpenCV_Size

Func _OpenCV_Size($width = 0, $height = 0)
    Local $cvSize[2] = [$width, $height]
    Return $cvSize
EndFunc   ;==>_OpenCV_Size

Func _OpenCV_Rect($x = 0, $y = 0, $width = 0, $height = 0)
    Local $cvSize[4] = [$x, $y, $width, $height]
    Return $cvSize
EndFunc   ;==>_OpenCV_Size
