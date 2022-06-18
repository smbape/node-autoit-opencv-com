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
;~     https://docs.opencv.org/4.6.0/de/da9/tutorial_template_matching.html
;~     https://github.com/opencv/opencv/blob/4.6.0/samples/cpp/tutorial_code/Histograms_Matching/MatchTemplate_Demo.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Scaled Template Matching", 1267, 556, 185, 122)

Global $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\lena_tmpl.jpg", 366, 16, 449, 21)
Global $BtnSource = GUICtrlCreateButton("Source", 825, 14, 75, 25)

Global $InputTemplate = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\tmpl.png", 366, 52, 449, 21)
Global $BtnTemplate = GUICtrlCreateButton("Template", 825, 50, 75, 25)

Global $InputMask = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\mask.png", 366, 88, 449, 21)
Global $BtnMask = GUICtrlCreateButton("Mask", 825, 86, 75, 25)

Global $CheckboxGrayScale = GUICtrlCreateCheckbox("Gray scale", 152, 64, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $CheckboxCanny = GUICtrlCreateCheckbox("Canny", 152, 96, 97, 17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $LabelThreshold = GUICtrlCreateLabel("Threshold: 0.6", 153, 128, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderThreshold = GUICtrlCreateSlider(260, 128, 334, 45)
GUICtrlSetData(-1, 60)

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
Global $img, $img_used, $templ, $templ_used, $mask, $match_method, $scale_direction, $min_scale, $max_scale, $threshold
Global $nMsg

Global $aMethods[6] = [$CV_TM_SQDIFF, $CV_TM_SQDIFF_NORMED, $CV_TM_CCORR, $CV_TM_CCORR_NORMED, $CV_TM_CCOEFF, $CV_TM_CCOEFF_NORMED]
_GUICtrlComboBox_SetCurSel($ComboMethod, 3)

Global $use_mask = False

Main()

Global $current_threshold = GUICtrlRead($SliderThreshold)
Global $last_threshold = $current_threshold

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
		Case $CheckboxGrayScale
			Main()
		Case $CheckboxCanny
			Main()
		Case $ComboMethod
			MatchingMethod()
		Case $SliderThreshold
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
	If @error Then
		$sSource = ""
		Return
	EndIf

	$sTemplate = ControlGetText($FormGUI, "", $InputTemplate)
	$templ = _OpenCV_imread_and_check($sTemplate, $CV_IMREAD_COLOR)
	If @error Then
		$sSource = ""
		$sTemplate = ""
		Return
	EndIf

	$sMask = ControlGetText($FormGUI, "", $InputMask)
	If $sMask <> "" Then
		$mask = _OpenCV_imread_and_check($sMask, $CV_IMREAD_GRAYSCALE)
		If @error Then
			$sSource = ""
			$sTemplate = ""
			$sMask = ""
			Return
		EndIf
		$use_mask = True
	Else
		$use_mask = False
		$mask = _OpenCV_ObjCreate("cv.Mat")
	EndIf
	;;! [load_image]

	;;! [Display]
	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($templ, $FormGUI, $PicTemplate)

	If $use_mask Then
		_OpenCV_imshow_ControlPic($mask, $FormGUI, $PicMask)
	EndIf
	;;! [Display]

	; convert to gray to speed up computation
	If _IsChecked($CheckboxGrayScale) Then
		$img_used = $cv.cvtColor($img, $CV_COLOR_BGR2GRAY)
		$templ_used = $cv.cvtColor($templ, $CV_COLOR_BGR2GRAY)
	Else
		$img_used = $img
		$templ_used = $templ
	EndIf

	; finds edges in the input image and marks them in the output map edges using the Canny algorithm
	; also a tip to speed up computation
	If _IsChecked($CheckboxGrayScale) And _IsChecked($CheckboxCanny) Then
		$templ_used = $cv.Canny($templ_used, 50, 200)
	EndIf

	If $img.width >= $templ.width And $img.height >= $templ.height Then
		$scale_direction = 1
		$min_scale = 1
	Else
		$scale_direction = -1
		$min_scale = Round(_Max($templ.width / $img.width, $templ.height / $img.height))
	EndIf

	$max_scale = 2.5 * $min_scale

	MatchingMethod()
EndFunc   ;==>Main

Func MatchingMethod()
	$match_method = $aMethods[_GUICtrlComboBox_GetCurSel($ComboMethod)]
	Local $method_accepts_mask = $CV_TM_SQDIFF == $match_method Or $match_method == $CV_TM_CCORR_NORMED ;

	If $method_accepts_mask Then
		GUICtrlSetState($InputMask, $GUI_ENABLE)
		GUICtrlSetState($BtnMask, $GUI_ENABLE)
	Else
		GUICtrlSetState($InputMask, $GUI_DISABLE)
		GUICtrlSetState($BtnMask, $GUI_DISABLE)
	EndIf

	If _IsChecked($CheckboxGrayScale) Then
		GUICtrlSetState($CheckboxCanny, $GUI_ENABLE)
	Else
		GUICtrlSetState($CheckboxCanny, $GUI_DISABLE)
	EndIf

	$threshold = GUICtrlRead($SliderThreshold) / 100
	GUICtrlSetData($LabelThreshold, "Threshold: " & StringFormat("%.2f", $threshold))

	If $sSource == "" Then Return

	Local $aDsize = _OpenCV_Size()
	Local $aMatchRect = _OpenCV_Rect(0, 0, $templ.width, $templ.height)
	Local $scale, $img_resized, $aMatches
	Local $fBestScore = 0
	Local $aBestMatchRect = _OpenCV_Rect()

	For $i = $min_scale To $max_scale Step 0.25
		$scale = $i ^ $scale_direction

		$aDsize[0] = $img.width / $scale
		$aDsize[1] = $img.height / $scale
		If ($aDsize[0] < $templ.width) Or ($aDsize[1] < $templ.height) Then
			ExitLoop
		EndIf

		; Resize the image and draw edges
		$img_resized = $cv.resize($img_used, $aDsize)

		If _IsChecked($CheckboxGrayScale) And _IsChecked($CheckboxCanny) Then
			$img_resized = $cv.Canny($img_resized, 50, 200)
		EndIf

		$aDsize[0] = $img_resized.width
		$aDsize[1] = $img_resized.height

		;;! [match_template]
		; Local $rw = $aDsize[0] - $templ.width + 1
		; Local $rh = $aDsize[1] - $templ.height + 1

		$aMatches = _OpenCV_FindTemplate($img_resized, $templ_used, $threshold, $match_method, $mask, 1)
		Local $iMatches = UBound($aMatches)
		For $m = 0 To $iMatches - 1 Step 1
			$aMatchRect[0] = $aMatches[$m][0]
			$aMatchRect[1] = $aMatches[$m][1]

			If $fBestScore < $aMatches[$m][2] Then
				$fBestScore = $aMatches[$m][2]
				$aBestMatchRect[0] = $aMatchRect[0] * $scale
				$aBestMatchRect[1] = $aMatchRect[1] * $scale
				$aBestMatchRect[2] = $aMatchRect[2] * $scale
				$aBestMatchRect[3] = $aMatchRect[3] * $scale
			EndIf

			; Draw a red rectangle around the matched position
			$cv.rectangle($img_resized, $aMatchRect, $aGreenColor, 2, $CV_LINE_8, 0)
		Next
		;;! [match_template]

		;;! [imshow]
		_OpenCV_imshow_ControlPic($img_resized, $FormGUI, $PicMatchTemplate)
		;;! [imshow]

		Sleep(100)
	Next

	;;! [imshow]
	; Draw a red rectangle around the matched position
	Local $img_display = $img.clone()
	$cv.rectangle($img_display, $aBestMatchRect, $aGreenColor, 2, $CV_LINE_8, 0)
	_OpenCV_imshow_ControlPic($img_display, $FormGUI, $PicResultImage)
	;;! [imshow]
EndFunc   ;==>MatchingMethod

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
