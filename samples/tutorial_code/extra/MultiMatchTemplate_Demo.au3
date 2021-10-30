#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/d4/dc6/tutorial_py_template_matching.html

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Multi-template matching", 906, 607, 183, 120)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\mario.png", 185, 16, 449, 21)
Local $BtnSource = GUICtrlCreateButton("Source", 644, 14, 75, 25)

Local $InputTemplate = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\mario_coin.png", 185, 52, 449, 21)
Local $BtnTemplate = GUICtrlCreateButton("Template", 644, 50, 75, 25)

Local $InputMask = GUICtrlCreateInput("", 185, 88, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnMask = GUICtrlCreateButton("Mask", 644, 86, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)

Local $LabelMethod = GUICtrlCreateLabel("Method:", 423, 128, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $ComboMethod = GUICtrlCreateCombo("", 489, 128, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "TM SQDIFF|TM SQDIFF NORMED|TM CCORR|TM CCORR NORMED|TM CCOEFF|TM CCOEFF NORMED")

Local $LabelThreshold = GUICtrlCreateLabel("Threshold: 0.8", 185, 180, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $SliderThreshold = GUICtrlCreateSlider(300, 168, 334, 45)
GUICtrlSetData(-1, 80)

Local $BtnExec = GUICtrlCreateButton("Execute", 644, 126, 75, 25)

Local $LabelSource = GUICtrlCreateLabel("Source Image", 141, 224, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 20, 246, 342, 342)
Local $PicSource = GUICtrlCreatePic("", 25, 257, 332, 326)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelTemplate = GUICtrlCreateLabel("Template", 420, 232, 70, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupTemplate = GUICtrlCreateGroup("", 376, 246, 158, 158)
Local $PicTemplate = GUICtrlCreatePic("", 381, 257, 148, 142)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelMask = GUICtrlCreateLabel("Mask", 435, 416, 41, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupMask = GUICtrlCreateGroup("", 375, 430, 158, 158)
Local $PicMask = GUICtrlCreatePic("", 380, 441, 148, 142)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelMatchTemplate = GUICtrlCreateLabel("Match Template", 668, 224, 115, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupMatchTemplate = GUICtrlCreateGroup("", 544, 246, 342, 342)
Local $PicMatchTemplate = GUICtrlCreatePic("", 549, 257, 332, 326)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderThreshold, 1)

_GDIPlus_Startup()

Local $aRedColor = _OpenCV_RGB(255, 0, 0)

Local $sSource = "", $sTemplate = "", $sMask = ""
Local $img, $templ, $mask, $match_method, $threshold

Local $aMethods[6] = [$CV_TM_SQDIFF, $CV_TM_SQDIFF_NORMED, $CV_TM_CCORR, $CV_TM_CCORR_NORMED, $CV_TM_CCOEFF, $CV_TM_CCOEFF_NORMED]
_GUICtrlComboBox_SetCurSel($ComboMethod, 5)

Local $use_mask = False
Local $aMatchRect = _OpenCV_Rect(0, 0, 0, 0)

Main()

Local $current_threshold = GUICtrlRead($SliderThreshold)
Local $last_threshold = $current_threshold

Local $nMsg

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sSource = ControlGetText($FormGUI, "", $InputSource)
			$sSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sSource)
			If @error Then
				$sSource = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sSource)
				Main()
			EndIf
		Case $BtnTemplate
			$sTemplate = ControlGetText($FormGUI, "", $InputTemplate)
			$sTemplate = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sTemplate)
			If @error Then
				$sTemplate = ""
			Else
				ControlSetText($FormGUI, "", $InputTemplate, $sTemplate)
				Main()
			EndIf
		Case $BtnMask
			$sMask = ControlGetText($FormGUI, "", $InputMask)
			$sMask = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sMask)
			If @error Then
				$sMask = ""
			Else
				ControlSetText($FormGUI, "", $InputMask, $sMask)
			EndIf
		Case $BtnExec
			Main()
		Case $ComboMethod
			MultiMatchTemplate()
		Case Else
			$current_threshold = GUICtrlRead($SliderThreshold)
			If $last_threshold <> $current_threshold Then
				MultiMatchTemplate()
				$last_threshold = $current_threshold
			EndIf
	EndSwitch

	Sleep(30) ; Sleep to reduce CPU usage
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	;;! [load_image]
	;;/ Load image and template
	$sSource = ControlGetText($FormGUI, "", $InputSource)
	$img = _OpenCV_imread_and_check($sSource)
	If @error Then
		$sSource = ""
		Return
	EndIf

	$sTemplate = ControlGetText($FormGUI, "", $InputTemplate)
	$templ = _OpenCV_imread_and_check($sTemplate)
	If @error Then
		$sSource = ""
		$sTemplate = ""
		Return
	EndIf

	$sMask = ControlGetText($FormGUI, "", $InputMask)
	If $sMask <> "" Then
		$mask = _OpenCV_imread_and_check($sMask)
		If @error Then
			$sSource = ""
			$sTemplate = ""
			$sMask = ""
			Return
		EndIf
		$use_mask = True
	Else
		$use_mask = False
		$mask = ObjCreate("OpenCV.cv.Mat")
	EndIf
	;;! [load_image]

	;;! [prepare_match_rect]
	$aMatchRect[2] = $templ.width
	$aMatchRect[3] = $templ.height
	;;! [prepare_match_rect]

	;;! [Display]
	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($templ, $FormGUI, $PicTemplate)

	If $use_mask Then
		_OpenCV_imshow_ControlPic($mask, $FormGUI, $PicMask)
	EndIf
	;;! [Display]

	MultiMatchTemplate()
EndFunc   ;==>Main

Func MultiMatchTemplate()
	$match_method = $aMethods[_GUICtrlComboBox_GetCurSel($ComboMethod)]

	If $CV_TM_SQDIFF == $match_method Or $match_method == $CV_TM_CCORR_NORMED Then
		GUICtrlSetState($InputMask, $GUI_ENABLE)
		GUICtrlSetState($BtnMask, $GUI_ENABLE)
	Else
		GUICtrlSetState($InputMask, $GUI_DISABLE)
		GUICtrlSetState($BtnMask, $GUI_DISABLE)
	EndIf

	$threshold = GUICtrlRead($SliderThreshold) / 100
	GUICtrlSetData($LabelThreshold, "Threshold: " & StringFormat("%.2f", $threshold))

	If $sSource == "" Then Return

	;;! [copy_source]
	;;/ Source image to display
	Local $img_display = $img.clone()
	;;! [copy_source]

	;;! [match_template]
	Local $aMatches = _OpenCV_FindTemplate($img_display, $templ, $threshold, $match_method, $mask)
	Local $iMatches = UBound($aMatches)
	For $i = 0 To $iMatches - 1
		$aMatchRect[0] = $aMatches[$i][0]
		$aMatchRect[1] = $aMatches[$i][1]

		; Draw a red rectangle around the matched position
		$cv.rectangle($img_display, $aMatchRect, $aRedColor, 1, $CV_LINE_8, 0)
	Next
	;;! [match_template]

	;;! [imshow]
	_OpenCV_imshow_ControlPic($img_display, $FormGUI, $PicMatchTemplate)
	;;! [imshow]

EndFunc   ;==>MultiMatchTemplate
