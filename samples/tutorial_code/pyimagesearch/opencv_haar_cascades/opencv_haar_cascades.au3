#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://pyimagesearch.com/2021/04/12/opencv-haar-cascades/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
_GDIPlus_Startup()
Global $hUser32DLL = DllOpen("user32.dll")
Global $bHasAddon = _Addon_DLLOpen(_Addon_FindDLL())
OnAutoItExitRegister("_OnAutoItExit")

Global Const $cv = _OpenCV_get()
If Not IsObj($cv) Then Exit

#Region ### START Globals section ###
Global Const $CASCADES_PATH = _OpenCV_FindFile("samples\tutorial_code\pyimagesearch\opencv_haar_cascades\cascades")

; initialize a dictionary that maps the name of the haar cascades to
; their filenames
Global $detectors = _OpenCV_Params( _
	"face", "haarcascade_frontalface_default.xml", _
	"eyes", "haarcascade_eye.xml", _
	"smile", "haarcascade_smile.xml" _
)

For $sKey In $detectors.Keys()
	$detectors($sKey) = _OpenCV_ObjCreate("cv.CascadeClassifier").create($CASCADES_PATH & "\" & $detectors($sKey))
Next

Global $tPtr = DllStructCreate("ptr value")
Global $sCameraList = ""
Global $cap = Null
Global $frame = _OpenCV_ObjCreate("cv.Mat")
#EndRegion ### START Globals section ###

#Region ### START Koda GUI section ###
Global $FormGUI = GUICreate("OpenCV Haar Cascades", 1262, 672, 185, 122)

Global $LabelFPS = GUICtrlCreateLabel("FPS : ", 16, 16, 105, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $LabelCamera = GUICtrlCreateLabel("Camera", 150, 16, 67, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboCamera = GUICtrlCreateCombo("", 224, 16, 351, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))

Global $GroupImage = GUICtrlCreateGroup("", 16, 56, 800, 600)
Global $PicImage = GUICtrlCreatePic("", 21, 67, 790, 584)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START GUI Event Loop section ###
Global $nMsg

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ComboCamera
			Main()
	EndSwitch

	UpdateCameraList()

	If $cap == Null Then
		Main()
		Sleep(1000) ; Sleep to reduce CPU usage
		ContinueLoop
	EndIf

	UpdateFrame()

	If _IsPressed(Hex(Asc("Q")), $hUser32DLL) Then
		ExitLoop
	EndIf

	Sleep(10) ; Sleep to reduce CPU usage
WEnd
#EndRegion ### START GUI Event Loop section ###

Func Main()
	If $cap <> Null And $cap.isOpened() Then $cap.release()

	Local $iCamId = _Max(0, _GUICtrlComboBox_GetCurSel($ComboCamera))
	$cap = _OpenCV_ObjCreate("cv.VideoCapture").create($iCamId)

	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the camera" & @CRLF)
		$cap = Null
	EndIf
EndFunc   ;==>Main

Func UpdateFrame()
	If $cap == Null Then Return

	Local $start = $cv.getTickCount()

	If Not $cap.read($frame) Then
		ConsoleWriteError("!>Error: cannot read camera or video file." & @CRLF)
		Return
	EndIf

	Local $gray = $cv.cvtColor($frame, $CV_COLOR_BGR2GRAY)

	; perform face detection using the appropriate haar cascade
    Local $faceRects = $detectors("face").detectMultiScale($gray, _OpenCV_Params( _
        "scaleFactor", 1.05, _
        "minNeighbors", 5, _
        "minSize", _OpenCV_Size(30, 30), _
        "flags", $CV_CASCADE_SCALE_IMAGE _
    ))

	Local $faceROI, $eyeRects, $smileRects

	; loop over the face bounding boxes
	For $faceRect In $faceRects
		; extract the face ROI
		$faceROI = _OpenCV_ObjCreate("cv.Mat").create($gray, $faceRect)

		; apply eyes detection to the face ROI
        $eyeRects = $detectors("eyes").detectMultiScale($faceROI, _OpenCV_Params( _
            "scaleFactor", 1.1, _
            "minNeighbors", 10, _
            "minSize", _OpenCV_Size(15, 15), _
            "flags", $CV_CASCADE_SCALE_IMAGE _
        ))

		; apply smile detection to the face ROI
		$smileRects = $detectors("smile").detectMultiScale($faceROI, _OpenCV_Params( _
            "scaleFactor", 1.1, _
            "minNeighbors", 10, _
            "minSize", _OpenCV_Size(15, 15), _
            "flags", $CV_CASCADE_SCALE_IMAGE _
        ))

		; loop over the eye bounding boxes
		For $eyeRect In $eyeRects
			; draw the eye bounding box
            $eyeRect[0] += $faceRect[0]
            $eyeRect[1] += $faceRect[1]
			$cv.rectangle($frame, $eyeRect, _OpenCV_Scalar(0, 0, 255), 2)
		Next

		; loop over the smile bounding boxes
		For $smileRect In $smileRects
			; draw the smile bounding box
            $smileRect[0] += $faceRect[0]
            $smileRect[1] += $faceRect[1]
			$cv.rectangle($frame, $smileRect, _OpenCV_Scalar(255, 0, 0), 2)
		Next

		; draw the face bounding box on the frame
		$cv.rectangle($frame, $faceRect, _OpenCV_Scalar(0, 255, 0), 2)
	Next

	_OpenCV_imshow_ControlPic($frame, $FormGUI, $PicImage)

	Local $fps = $cv.getTickFrequency() / ($cv.getTickCount() - $start)
	GUICtrlSetData($LabelFPS, "FPS : " & Round($fps))
EndFunc   ;==>UpdateFrame

Func UpdateCameraList()
	If Not $bHasAddon Then Return

	Local $videoDevices = _VectorOfDeviceInfoCreate()
	_addonEnumerateVideoDevices($videoDevices)

	Local $tDevice, $tStr
	Local $sCamera = GUICtrlRead($ComboCamera)
	Local $sLongestString = ""
	Local $sOldCameraList = $sCameraList
	$sCameraList = ""

	For $i = 0 To _VectorOfDeviceInfoGetSize($videoDevices) - 1
		_VectorOfDeviceInfoGetItemPtr($videoDevices, $i, $tPtr)
		$tDevice = DllStructCreate($tagAddonDeviceInfo, $tPtr.value)

		$tStr = DllStructCreate("wchar value[" & $tDevice.FriendlyNameLen & "]", $tDevice.FriendlyName)
		$sCameraList &= "|" & $tStr.value

		If StringLen($sLongestString) < StringLen($tStr.value) Then
			$sLongestString = $tStr.value
		EndIf
	Next

	_VectorOfDeviceInfoRelease($videoDevices)

	If StringLen($sCameraList) <> 0 Then
		$sCameraList = StringRight($sCameraList, StringLen($sCameraList) - 1)
	EndIf

	If StringCompare($sOldCameraList, $sCameraList, $STR_CASESENSE) == 0 Then Return

	_GUICtrlComboBox_ResetContent($ComboCamera)
	GUICtrlSetData($ComboCamera, $sCameraList)

	Local $avSize_Info = _StringSize($sLongestString)
	Local $aPos = ControlGetPos($FormGUI, "", $ComboCamera)
	GUICtrlSetPos($ComboCamera, $aPos[0], $aPos[1], _Max(145, $avSize_Info[2] + 20))

	If _GUICtrlComboBox_SelectString($ComboCamera, $sCamera) == -1 Then
		_GUICtrlComboBox_SetCurSel($ComboCamera, 0)
	EndIf
EndFunc   ;==>UpdateCameraList

; #FUNCTION# =======================================================================================
;
; Name...........: _StringSize
; Description ...: Returns size of rectangle required to display string - width can be chosen
; Syntax ........: _StringSize($sText[, $iSize[, $iWeight[, $iAttrib[, $sName[, $iWidth]]]]])
; Parameters ....: $sText   - String to display
;                 $iSize   - Font size in points - default AutoIt GUI default
;                 $iWeight - Font weight (400 = normal) - default AutoIt GUI default
;                 $iAttrib - Font attribute (0-Normal, 2-Italic, 4-Underline, 8 Strike - default AutoIt
;                 $sName   - Font name - default AutoIt GUI default
;                 $iWidth  - [optional] Width of rectangle - default is unwrapped width of string
; Requirement(s) : v3.2.12.1 or higher
; Return values .: Success - Returns array with details of rectangle required for text:
;                 |$array[0] = String formatted with @CRLF at required wrap points
;                 |$array[1] = Height of single line in selected font
;                 |$array[2] = Width of rectangle required to hold formatted string
;                 |$array[3] = Height of rectangle required to hold formatted string
;                 Failure - Returns 0 and sets @error:
;                 |1 - Incorrect parameter type (@extended = parameter index)
;                 |2 - Failure to create GUI to test label size
;                 |3 - Failure of _WinAPI_SelectObject
;                 |4 - Font too large for chosen width - longest word will not fit
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
;===================================================================================================
Func _StringSize($sText, $iSize = Default, $iWeight = Default, $iAttrib = Default, $sName = Default, $iWidth = 0)
	Local $hWnd, $hFont, $hDC, $oFont, $tSize, $hGUI, $hText_Label, $sTest_Line
	Local $iLine_Count, $iLine_Width, $iWrap_Count, $iLast_Word
	Local $asLines[1], $avSize_Info[4], $aiPos[4]
	If Not IsString($sText) Then Return SetError(1, 1, 0)
	If Not IsNumber($iSize) And $iSize <> Default Then Return SetError(1, 2, 0)
	If Not IsInt($iWeight) And $iWeight <> Default Then Return SetError(1, 3, 0)
	If Not IsInt($iAttrib) And $iAttrib <> Default Then Return SetError(1, 4, 0)
	If Not IsString($sName) And $sName <> Default Then Return SetError(1, 5, 0)
	If Not IsNumber($iWidth) Then Return SetError(1, 6, 0)
	$hGUI = GUICreate("", 1200, 500, 10, 10)
	If $hGUI = 0 Then Return SetError(2, 0, 0)
	GUISetFont($iSize, $iWeight, $iAttrib, $sName)
	$avSize_Info[0] = $sText
	If StringInStr($sText, @CRLF) = 0 Then StringRegExpReplace($sText, "[x0a|x0d]", @CRLF)
	$asLines = StringSplit($sText, @CRLF, 1)
	$hText_Label = GUICtrlCreateLabel($sText, 10, 10)
	$aiPos = ControlGetPos($hGUI, "", $hText_Label)
	GUICtrlDelete($hText_Label)
	$avSize_Info[1] = ($aiPos[3] - 8) / $asLines[0]
	$avSize_Info[2] = $aiPos[2]
	$avSize_Info[3] = $aiPos[3] - 4
	If $aiPos[2] > $iWidth And $iWidth > 0 Then
		$avSize_Info[0] = ""
		$avSize_Info[2] = $iWidth
		$iLine_Count = 0
		For $j = 1 To $asLines[0]
			$hText_Label = GUICtrlCreateLabel($asLines[$j], 10, 10)
			$aiPos = ControlGetPos($hGUI, "", $hText_Label)
			GUICtrlDelete($hText_Label)
			If $aiPos[2] < $iWidth Then
				$iLine_Count += 1
				$avSize_Info[0] &= $asLines[$j] & @CRLF
			Else
				$hText_Label = GUICtrlCreateLabel("", 0, 0)
				$hWnd = ControlGetHandle($hGUI, "", $hText_Label)
				$hFont = _SendMessage($hWnd, $WM_GETFONT)
				$hDC = _WinAPI_GetDC($hWnd)
				$oFont = _WinAPI_SelectObject($hDC, $hFont)
				If $oFont = 0 Then Return SetError(3, 0, 0)
				$iWrap_Count = 0
				While 1
					$iLine_Width = 0
					$iLast_Word = 0
					For $i = 1 To StringLen($asLines[$j])
						If StringMid($asLines[$j], $i, 1) = " " Then $iLast_Word = $i - 1
						$sTest_Line = StringMid($asLines[$j], 1, $i)
						GUICtrlSetData($hText_Label, $sTest_Line)
						$tSize = _WinAPI_GetTextExtentPoint32($hDC, $sTest_Line)
						$iLine_Width = DllStructGetData($tSize, "X")
						If $iLine_Width >= $iWidth - Int($iSize / 2) Then ExitLoop
					Next
					If $i > StringLen($asLines[$j]) Then
						$iWrap_Count += 1
						$avSize_Info[0] &= $sTest_Line & @CRLF
						ExitLoop
					Else
						$iWrap_Count += 1
						If $iLast_Word = 0 Then
							GUIDelete($hGUI)
							Return SetError(4, 0, 0)
						EndIf
						$avSize_Info[0] &= StringLeft($sTest_Line, $iLast_Word) & @CRLF
						$asLines[$j] = StringTrimLeft($asLines[$j], $iLast_Word)
						$asLines[$j] = StringStripWS($asLines[$j], 1)
					EndIf
				WEnd
				$iLine_Count += $iWrap_Count
				_WinAPI_ReleaseDC($hWnd, $hDC)
				GUICtrlDelete($hText_Label)
			EndIf
		Next
		$avSize_Info[3] = ($iLine_Count * $avSize_Info[1]) + 4
	EndIf
	GUIDelete($hGUI)
	Return $avSize_Info
EndFunc   ;==>_StringSize

Func _OnAutoItExit()
    If $bHasAddon Then _Addon_DLLClose()
	DllClose($hUser32DLL)
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
