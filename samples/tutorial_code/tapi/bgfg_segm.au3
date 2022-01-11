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
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.5/de/da9/tutorial_template_matching.html
;~     https://github.com/opencv/opencv/blob/4.5.5/samples/tapi/bgfg_segm.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Changing the contrast and brightness of an image!", 1262, 672, 185, 122)

Global $LabelFPS = GUICtrlCreateLabel("FPS : ", 16, 16, 105, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $InputFile = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\vtest.avi", 366, 16, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnFile = GUICtrlCreateButton("Video File", 825, 14, 75, 25)

Global $CheckboxUseCamera = GUICtrlCreateCheckbox("", 368, 56, 17, 17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $LabelCamera = GUICtrlCreateLabel("Camera", 390, 56, 67, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboCamera = GUICtrlCreateCombo("", 464, 56, 351, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

Global $GroupMethod = GUICtrlCreateGroup("Method", 368, 96, 137, 89)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $RadioKNN = GUICtrlCreateRadio("KNN", 392, 120, 73, 17)
GUICtrlSetFont(-1, 8, 400, 0, "MS Sans Serif")
Global $RadioMOG2 = GUICtrlCreateRadio("MOG2", 392, 152, 73, 17)
GUICtrlSetFont(-1, 8, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $GroupCPUMode = GUICtrlCreateGroup("CPU mode", 528, 96, 137, 89)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $RadioOpenCL = GUICtrlCreateRadio("OpenCL", 552, 120, 73, 17)
Global $RadioCPU = GUICtrlCreateRadio("CPU", 552, 152, 73, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $BtnStart = GUICtrlCreateButton("Start", 824, 104, 75, 25)
Global $BtnStop = GUICtrlCreateButton("Stop", 824, 144, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 192, 216, 47, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 16, 240, 400, 400)
Global $PicImage = GUICtrlCreatePic("", 21, 251, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelForegroundMask = GUICtrlCreateLabel("Foreground mask", 567, 216, 125, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupForegroundMask = GUICtrlCreateGroup("", 430, 238, 400, 400)
Global $PicForegroundMask = GUICtrlCreatePic("", 435, 249, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelForegroundImage = GUICtrlCreateLabel("Foreground image", 975, 216, 131, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupForegroundImage = GUICtrlCreateGroup("", 840, 238, 400, 400)
Global $PicForegroundImage = GUICtrlCreatePic("", 845, 249, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

Global $bHasAddon = _Addon_DLLOpen(_Addon_FindDLL())

Global $ocl = _OpenCV_ObjCreate("cv.ocl")

If $ocl.useOpenCL() Then
	GUICtrlSetState($RadioOpenCL, $GUI_CHECKED)
Else
	GUICtrlSetState($RadioCPU, $GUI_CHECKED)
EndIf

Global $tPtr = DllStructCreate("ptr value")
Global $sCameraList = ""

Global Const $M_MOG2 = 2
Global Const $M_KNN = 3

Global $sInputFile = ""
Global $useCamera = False
Global $method
Global $cap = Null
Global $running = True
Global $bInitialized = False

Global $frame = _OpenCV_ObjCreate("cv.Mat")
Global $fgmask = _OpenCV_ObjCreate("cv.Mat")
Global $fgimg = _OpenCV_ObjCreate("cv.Mat")

Global $knn, $mog2

Global $mode

Global $hUser32DLL = DllOpen("user32.dll")

Global $nMsg

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BtnFile
			_handleBtnFileClick()
		Case $CheckboxUseCamera
			Main()
		Case $RadioKNN
			Main()
		Case $RadioMOG2
			Main()
		Case $RadioOpenCL
			UpdateState()
		Case $RadioCPU
			UpdateState()
		Case $ComboCamera
			Main()
		Case $BtnStart
			$running = True
		Case $BtnStop
			$running = False
	EndSwitch

	UpdateCameraList()

	If $running Then
		If $cap == Null Then
			Main()
			Sleep(1000) ; Sleep to reduce CPU usage
			ContinueLoop
		EndIf

		UpdateFrame()
	EndIf

	If _IsPressed(Hex(Asc("Q")), $hUser32DLL) Then
		ExitLoop
	EndIf

	Sleep(30) ; Sleep to reduce CPU usage
WEnd

DllClose($hUser32DLL)

If $bHasAddon Then _Addon_DLLClose()

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func _handleBtnFileClick()
	$sInputFile = ControlGetText($FormGUI, "", $InputFile)
	$sInputFile = FileOpenDialog("Select a video", $OPENCV_SAMPLES_DATA_PATH, "Video files (*.avi;*.mp4)", $FD_FILEMUSTEXIST, $sInputFile)
	If @error Then
		$sInputFile = ""
		Return
	EndIf

	ControlSetText($FormGUI, "", $InputFile, $sInputFile)
	Main()
EndFunc   ;==>_handleBtnFileClick

Func Main()
	UpdateState()

	If $useCamera Then
		Local $iCamId = _Max(0, _GUICtrlComboBox_GetCurSel($ComboCamera))
		$cap = _OpenCV_ObjCreate("cv.VideoCapture").create($iCamId)
	Else
		$sInputFile = ControlGetText($FormGUI, "", $InputFile)
		$cap = _OpenCV_ObjCreate("cv.VideoCapture").create($sInputFile)
	EndIf

	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the " & ($useCamera ? "camera" : "video file") & @CRLF)
		$cap = Null
		Return
	EndIf
EndFunc   ;==>Main

Func UpdateState()
	$useCamera = _IsChecked($CheckboxUseCamera)

	If $useCamera Then
		GUICtrlSetState($BtnFile, $GUI_DISABLE)
		GUICtrlSetState($ComboCamera, $GUI_ENABLE)
	Else
		GUICtrlSetState($BtnFile, $GUI_ENABLE)
		GUICtrlSetState($ComboCamera, $GUI_DISABLE)
	EndIf

	If _IsChecked($RadioKNN) Then
		$method = $M_KNN
	Else
		$method = $M_MOG2
	EndIf

	Local $useOpenCL = _IsChecked($RadioOpenCL)

	If $ocl.useOpenCL() <> $useOpenCL Then
		$ocl.setUseOpenCL($useOpenCL)

		If $useOpenCL Then
			$mode = "OpenCL enabled"
		Else
			$mode = "CPU"
		EndIf
		ConsoleWrite("Switched to " & $mode & " mode" & @CRLF)
	EndIf
EndFunc   ;==>UpdateState

Func InitState()
	If $bInitialized Then Return

	$knn = $cv.createBackgroundSubtractorKNN()
	$mog2 = $cv.createBackgroundSubtractorMOG2()

	$fgimg = $fgimg.create($frame.size(), $frame.type())
	$fgmask = $fgmask.create()

	$bInitialized = True
EndFunc   ;==>InitState

Func UpdateFrame()
	If $cap == Null Then Return

	If Not $cap.read($frame) Then
		If $useCamera Or Not $bInitialized Then
			ConsoleWriteError("!>Error: cannot read camera or video file." & @CRLF)
		EndIf
		Return
	EndIf

	InitState()

	Local $start = $cv.getTickCount()

	Switch $method
		Case $M_KNN
			$knn.apply($frame, -1, $fgmask)
		Case $M_MOG2
			$mog2.apply($frame, -1, $fgmask)
	EndSwitch

	$fgimg.setTo(_OpenCV_ScalarAll(0))
	$frame.copyTo($fgmask, $fgimg)

	_OpenCV_imshow_ControlPic($frame, $FormGUI, $PicImage)
	_OpenCV_imshow_ControlPic($fgmask, $FormGUI, $PicForegroundMask)
	_OpenCV_imshow_ControlPic($fgimg, $FormGUI, $PicForegroundImage)

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

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

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
