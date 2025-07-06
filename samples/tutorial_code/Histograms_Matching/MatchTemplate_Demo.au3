#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.12.0/de/da9/tutorial_template_matching.html
;~     https://github.com/opencv/opencv/blob/4.12.0/samples/cpp/tutorial_code/Histograms_Matching/MatchTemplate_Demo.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4120*"), _OpenCV_FindDLL("autoit_opencv_com4120*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Template Matching", 1267, 556, 185, 122)

Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("lena_tmpl.jpg"), 366, 16, 449, 21)
Global $BtnSource = GUICtrlCreateButton("Source", 825, 14, 75, 25)

Global $InputTemplate = GUICtrlCreateInput($cv.samples.findFile("tmpl.png"), 366, 52, 449, 21)
Global $BtnTemplate = GUICtrlCreateButton("Template", 825, 50, 75, 25)

Global $InputMask = GUICtrlCreateInput($cv.samples.findFile("mask.png"), 366, 88, 449, 21)
Global $BtnMask = GUICtrlCreateButton("Mask", 825, 86, 75, 25)

Global $LabelMethod = GUICtrlCreateLabel("Method:", 604, 128, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboMethod = GUICtrlCreateCombo("", 670, 128, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "TM SQDIFF|TM SQDIFF NORMED|TM CCORR|TM CCORR NORMED|TM CCOEFF|TM CCOEFF NORMED")

Global $BtnExec = GUICtrlCreateButton("Execute", 825, 126, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 141, 168, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 190, 342, 342)
Global $PicSource = GUICtrlCreatePic("", 25, 201, 332, 326)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelTemplate = GUICtrlCreateLabel("Template", 420, 176, 70, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupTemplate = GUICtrlCreateGroup("", 376, 190, 158, 158)
Global $PicTemplate = GUICtrlCreatePic("", 381, 201, 148, 142)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelMask = GUICtrlCreateLabel("Mask", 435, 360, 41, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupMask = GUICtrlCreateGroup("", 375, 374, 158, 158)
Global $PicMask = GUICtrlCreatePic("", 380, 385, 148, 142)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelMatchTemplate = GUICtrlCreateLabel("Match Template", 668, 168, 115, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupMatchTemplate = GUICtrlCreateGroup("", 544, 190, 342, 342)
Global $PicMatchTemplate = GUICtrlCreatePic("", 549, 201, 332, 326)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResultImage = GUICtrlCreateLabel("Result Image", 1024, 168, 95, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResultImage = GUICtrlCreateGroup("", 900, 190, 342, 342)
Global $PicResultImage = GUICtrlCreatePic("", 905, 201, 332, 326)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $aGreenColor = _OpenCV_RGB(0, 255, 0)

Global $sSource = "", $sTemplate = "", $sMask = ""
Global $img, $templ, $mask, $match_method
Global $nMsg
Global $use_mask = False

Global $aMethods[6] = [$CV_TM_SQDIFF, $CV_TM_SQDIFF_NORMED, $CV_TM_CCORR, $CV_TM_CCORR_NORMED, $CV_TM_CCOEFF, $CV_TM_CCOEFF_NORMED]
_GUICtrlComboBox_SetCurSel($ComboMethod, 3)

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sSource = ControlGetText($FormGUI, "", $InputSource)
			$sSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSource)
			If @error Then
				$sSource = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sSource)
			EndIf
		Case $BtnTemplate
			$sTemplate = ControlGetText($FormGUI, "", $InputTemplate)
			$sTemplate = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sTemplate)
			If @error Then
				$sTemplate = ""
			Else
				ControlSetText($FormGUI, "", $InputTemplate, $sTemplate)
			EndIf
		Case $BtnMask
			$sMask = ControlGetText($FormGUI, "", $InputMask)
			$sMask = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sMask)
			If @error Then
				$sMask = ""
			Else
				ControlSetText($FormGUI, "", $InputMask, $sMask)
			EndIf
		Case $ComboMethod
			MatchingMethod()
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	;;! [load_image]
	;;/ Load image and template
	$sSource = ControlGetText($FormGUI, "", $InputSource)
	$img = _OpenCV_imread_and_check($sSource, $CV_IMREAD_COLOR)
	If @error Then Return

	$sTemplate = ControlGetText($FormGUI, "", $InputTemplate)
	$templ = _OpenCV_imread_and_check($sTemplate, $CV_IMREAD_COLOR)
	If @error Then Return

	$sMask = ControlGetText($FormGUI, "", $InputMask)
	If $sMask <> "" Then
		$mask = _OpenCV_imread_and_check($sMask, $CV_IMREAD_GRAYSCALE)
		If @error Then Return
		$use_mask = True
	Else
		$use_mask = False
		$mask = Null
	EndIf
	;;! [load_image]

	;;! [Display]
	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($templ, $FormGUI, $PicTemplate)

	If $use_mask Then
		_OpenCV_imshow_ControlPic($mask, $FormGUI, $PicMask)
	EndIf
	;;! [Display]

	MatchingMethod()
EndFunc   ;==>Main

Func MatchingMethod()
	$match_method = $aMethods[_GUICtrlComboBox_GetCurSel($ComboMethod)]

	If $CV_TM_SQDIFF == $match_method Or $match_method == $CV_TM_CCORR_NORMED Then
		GUICtrlSetState($InputMask, $GUI_ENABLE)
		GUICtrlSetState($BtnMask, $GUI_ENABLE)
	Else
		GUICtrlSetState($InputMask, $GUI_DISABLE)
		GUICtrlSetState($BtnMask, $GUI_DISABLE)
	EndIf

	If $sSource == "" Then Return

	;;! [copy_source]
	;;/ Source image to display
	Local $img_display = $img.copyTo()
	;;! [copy_source]

	;;! [create_result_matrix]
	;;/ Create the result matrix
	Local $result_cols = $img.width - $templ.width + 1
	Local $result_rows = $img.height - $templ.height + 1

	Local $result = $cv.Mat.create($result_rows, $result_cols, $CV_32FC1)
	;;! [create_result_matrix]

	;;! [match_template]
	;;/ Do the Matching and Normalize
	Local $method_accepts_mask = $CV_TM_SQDIFF == $match_method Or $match_method == $CV_TM_CCORR_NORMED
	If $use_mask And $method_accepts_mask Then
		$cv.matchTemplate($img, $templ, $match_method, $result, $mask)
	Else
		$cv.matchTemplate($img, $templ, $match_method, $result)
	EndIf
	;;! [match_template]

	;;! [normalize]
	$cv.normalize($result, $result, 0, 1, $CV_NORM_MINMAX, -1, Null)
	;;! [normalize]

	;;! [best_match]
	;;/ Localizing the best match with minMaxLoc
	Local $matchLoc

	$cv.minMaxLoc($result)
	; Local $minVal = $cv.extended[0]
	; Local $maxVal = $cv.extended[1]
	Local $minLoc = $cv.extended[2]
	Local $maxLoc = $cv.extended[3]

	;;! [best_match]

	;;! [match_loc]
	;;/ For SQDIFF and SQDIFF_NORMED, the best matches are lower values. For all the other methods, the higher the better
	If $match_method == $CV_TM_SQDIFF Or $match_method == $CV_TM_SQDIFF_NORMED Then
		$matchLoc = $minLoc
	Else
		$matchLoc = $maxLoc
	EndIf
	;;! [match_loc]

	;;! [imshow]
	;;/ Show me what you got
	Local $matchRect = _OpenCV_Rect($matchLoc[0], $matchLoc[1], $templ.width, $templ.height)

	$cv.rectangle($img_display, $matchRect, $aGreenColor, 2, 8, 0)
	$cv.rectangle($result, $matchRect, _OpenCV_ScalarAll(0), 2, 8, 0)

	_OpenCV_imshow_ControlPic($img_display, $FormGUI, $PicMatchTemplate)
	_OpenCV_imshow_ControlPic($result, $FormGUI, $PicResultImage)
	;;! [imshow]

EndFunc   ;==>MatchingMethod

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
