#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.8.0/dd/d49/tutorial_py_contour_features.html
;~     https://github.com/opencv/opencv/blob/4.8.0/samples/python/tutorial_code/ShapeDescriptors/bounding_rotated_ellipses/generalContours_demo2.py

_OpenCV_Open(_OpenCV_FindDLL("opencv_world480*"), _OpenCV_FindDLL("autoit_opencv_com480*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Contour Features", 1061, 601, 200, 90)

Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("pic1.png"), 120, 16, 450, 21)
Global $BtnSource = GUICtrlCreateButton("Source", 580, 14, 75, 25)

Global $BtnSaveImg = GUICtrlCreateButton("Save image", 680, 14, 100, 25)

Global $LabelThreshold = GUICtrlCreateLabel("Threshold: 180", 120, 62, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $SliderThreshold = GUICtrlCreateSlider(240, 62, 334, 45)
GUICtrlSetLimit(-1, 255, 0) ; change min/max value
GUICtrlSetData($SliderThreshold, 180) ; set cursor
_GUICtrlSlider_SetTicFreq($SliderThreshold, 1)

Global $CheckboxCanny = GUICtrlCreateCheckbox("Canny", 580, 62, 58, 20)
Global $CheckboxInvert = GUICtrlCreateCheckbox("Invert threshold (the object must be white)", 580, 92, 250, 20)

GUICtrlCreateLabel("Do not show areas with size less than:", 120, 107, 290, 25)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputMinArea = GUICtrlCreateInput("1000", 415, 107, 50, 21)

Global $LabelSource = GUICtrlCreateLabel("Source Image and Contour", 130, 150, 187, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 170, 400, 410)
Global $PicSource = GUICtrlCreatePic("", 25, 185, 380, 380)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelThresholdImage = GUICtrlCreateLabel("Threshold Image", 580, 150, 121, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupThresholdImage = GUICtrlCreateGroup("", 455, 170, 400, 410)
Global $PicThresholdImage = GUICtrlCreatePic("", 460, 185, 380, 380)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $CheckboxConcave = GUICtrlCreateCheckbox("", 880, 15, 20, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $LabelConcave = GUICtrlCreateLabel("View Concave contour", 900, 18, 140, 21)
GUICtrlSetColor(-1, 0x358856) ; Green

Global $CheckboxConcaveCenter = GUICtrlCreateCheckbox("", 880, 45, 20, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $LabelConcaveCenter = GUICtrlCreateLabel("Draw Concave center", 900, 48, 140, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetColor(-1, 0x358856) ; Green

Global $CheckboxConvex = GUICtrlCreateCheckbox("", 880, 75, 20, 21)
Global $LabelConvex = GUICtrlCreateLabel("View Convex contour", 900, 78, 140, 21)
GUICtrlSetColor(-1, 0xFF0000) ; Red

Global $CheckboxConvexCenter = GUICtrlCreateCheckbox("", 880, 105, 20, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetColor(-1, 0xFF0000) ; Red
Global $LabelConvexCenter = GUICtrlCreateLabel("Draw Convex center", 900, 108, 140, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetColor(-1, 0xFF0000) ; Red

Global $CheckboxBoundingRect = GUICtrlCreateCheckbox("", 880, 135, 20, 21)
Global $LabelBoundingRect = GUICtrlCreateLabel("Straight Bounding Rectangle", 900, 138, 140, 21)
GUICtrlSetColor(-1, 0x0000FF) ; Blue

Global $CheckboxRotatedRectangle = GUICtrlCreateCheckbox("", 880, 165, 20, 21)
Global $LabelRotatedRectangle = GUICtrlCreateLabel("Rotated Rectangle", 900, 168, 140, 21)
GUICtrlSetColor(-1, 0xFFA701) ; Yellow

Global $CheckboxEnclosingCircle = GUICtrlCreateCheckbox("", 880, 195, 20, 21)
Global $LabelEnclosingCircle = GUICtrlCreateLabel("Minimum Enclosing Circle", 900, 198, 140, 21)
GUICtrlSetColor(-1, 0xBF3EFF) ; Purple

Global $CheckboxFittingEllipse = GUICtrlCreateCheckbox("", 880, 225, 20, 21)
Global $LabelFittingEllipse = GUICtrlCreateLabel("Fitting an Ellipse", 900, 228, 140, 21)
GUICtrlSetColor(-1, 0xFF00C0) ; Pink

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $src, $src_gray, $src_displayed, $sImage

Main()

Global $current_threshold = GUICtrlRead($SliderThreshold)
Global $last_threshold = $current_threshold

Global $nMsg
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop

		Case $BtnSource
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif;*.webp)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf

		Case $BtnSaveImg
			_SaveImg()

		Case $CheckboxCanny
			_ThresholdImage()

		Case $CheckboxInvert
			_ThresholdImage()

		Case $CheckboxConcave
			_DrawContours()

		Case $LabelConcave
			If _IsChecked($CheckboxConcave) Then
				GUICtrlSetState($CheckboxConcave, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxConcave, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxConcaveCenter
			_DrawContours()

		Case $LabelConcaveCenter
			If _IsChecked($CheckboxConcaveCenter) Then
				GUICtrlSetState($CheckboxConcaveCenter, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxConcaveCenter, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxConvex
			_DrawContours()

		Case $LabelConvex
			If _IsChecked($CheckboxConvex) Then
				GUICtrlSetState($CheckboxConvex, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxConvex, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxConvexCenter
			_DrawContours()

		Case $LabelConvexCenter
			If _IsChecked($CheckboxConvexCenter) Then
				GUICtrlSetState($CheckboxConvexCenter, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxConvexCenter, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxBoundingRect
			_DrawContours()

		Case $LabelBoundingRect
			If _IsChecked($CheckboxBoundingRect) Then
				GUICtrlSetState($CheckboxBoundingRect, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxBoundingRect, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxRotatedRectangle
			_DrawContours()

		Case $LabelRotatedRectangle
			If _IsChecked($CheckboxRotatedRectangle) Then
				GUICtrlSetState($CheckboxRotatedRectangle, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxRotatedRectangle, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxEnclosingCircle
			_DrawContours()

		Case $LabelEnclosingCircle
			If _IsChecked($CheckboxEnclosingCircle) Then
				GUICtrlSetState($CheckboxEnclosingCircle, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxEnclosingCircle, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case $CheckboxFittingEllipse
			_DrawContours()

		Case $LabelFittingEllipse
			If _IsChecked($CheckboxFittingEllipse) Then
				GUICtrlSetState($CheckboxFittingEllipse, $GUI_UNCHECKED)
			Else
				GUICtrlSetState($CheckboxFittingEllipse, $GUI_CHECKED)
			EndIf
			_DrawContours()

		Case Else
			$current_threshold = GUICtrlRead($SliderThreshold)
			If $last_threshold <> $current_threshold Then
				_ThresholdImage()
				$last_threshold = $current_threshold
			EndIf
	EndSwitch

	Sleep(30) ; Sleep to reduce CPU usage
WEnd

Func _SaveImg()
	Local $sFileSaveDialog = FileSaveDialog("Choose a filename.", @ScriptDir, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif;*.webp)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE))
	If @error Then
		; MsgBox($MB_SYSTEMMODAL, "", "No file was saved.")
		Return
	EndIf

	If Not $cv.imwrite($sFileSaveDialog, $src_displayed) Then
		MsgBox($MB_SYSTEMMODAL, "", "No file was saved.")
	EndIf
EndFunc   ;==>_SaveImg

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	$src = _OpenCV_imread_and_check($sImage, $CV_IMREAD_COLOR)
	If @error Then
		MsgBox(0, "Warning", "Failed to read the image")
		$sImage = ""
		Return
	EndIf

	_ThresholdImage()
EndFunc   ;==>Main

Func _ThresholdImage()
	$src_gray = $cv.cvtColor($src, $CV_COLOR_BGR2GRAY)
	$src_gray = $cv.GaussianBlur($src_gray, _OpenCV_Size(5, 5), 0)

	Local $threshold = GUICtrlRead($SliderThreshold)

	If _IsChecked($CheckboxCanny) Then
		$src_gray = $cv.Canny($src_gray, $threshold, $threshold * 2)
		If _IsChecked($CheckboxInvert) Then
			$src_gray = $cv.bitwise_not($src_gray)
		EndIf
	Else
		$cv.threshold($src_gray, $threshold, 255, _IsChecked($CheckboxInvert) ? $CV_THRESH_BINARY_INV : $CV_THRESH_BINARY, $src_gray)
	EndIf

	_OpenCV_imshow_ControlPic($src_gray, $FormGUI, $PicThresholdImage)

	_DrawContours()
EndFunc   ;==>_ThresholdImage

Func _DrawContours()
	If _IsChecked($CheckboxConcave) Then
		GUICtrlSetState($CheckboxConcaveCenter, $GUI_ENABLE)
		GUICtrlSetState($LabelConcaveCenter, $GUI_ENABLE)
	Else
		GUICtrlSetState($CheckboxConcaveCenter, $GUI_DISABLE)
		GUICtrlSetState($CheckboxConcaveCenter, $GUI_UNCHECKED)
		GUICtrlSetState($LabelConcaveCenter, $GUI_DISABLE)
	EndIf

	If _IsChecked($CheckboxConvex) Then
		GUICtrlSetState($CheckboxConvexCenter, $GUI_ENABLE)
		GUICtrlSetState($LabelConvexCenter, $GUI_ENABLE)
	Else
		GUICtrlSetState($CheckboxConvexCenter, $GUI_DISABLE)
		GUICtrlSetState($CheckboxConvexCenter, $GUI_UNCHECKED)
		GUICtrlSetState($LabelConvexCenter, $GUI_DISABLE)
	EndIf

	If $sImage == "" Then Return

	$src_displayed = $src.clone()

	; Find contours
	Local $good_contours = _OpenCV_ObjCreate("VectorOfMat")
	Local $contours = $cv.findContours($src_gray, $CV_RETR_TREE, $CV_CHAIN_APPROX_SIMPLE) ; $CV_RETR_LIST, $CV_RETR_EXTERNAL, $CV_RETR_TREE

	Local $sCurrentArea = GUICtrlRead($InputMinArea)
	If $sCurrentArea = "" Then $sCurrentArea = "0"
	Local $dCurrentArea = Number($sCurrentArea, $NUMBER_DOUBLE)

	For $i = 0 To UBound($contours) - 1
		Local $dArea = $cv.contourArea($contours[$i])
		If $dArea < $dCurrentArea Then
			ContinueLoop
		EndIf
		$good_contours.push_back($contours[$i])
	Next

	Local $tmpcontours[1], $moments, $tmp

	For $i = 0 To $good_contours.size() - 1
		; Draw Concave contour
		If _IsChecked($CheckboxConcave) Then
			$cv.drawContours($src_displayed, $good_contours, $i, _OpenCV_RGB(0, 255, 0), 3)

			If _IsChecked($CheckboxConcaveCenter) Then
				; Draw circle in center of Concave
				$moments = $cv.moments($good_contours.at($i))

				Local $cx1 = $moments.m10 / $moments.m00
				Local $cy1 = $moments.m01 / $moments.m00
				$cv.circle($src_displayed, _OpenCV_Point($cx1, $cy1), 15, _OpenCV_Scalar(0, 255, 0), $CV_FILLED)
			EndIf
		EndIf

		; Draw Convex Hull contour
		If _IsChecked($CheckboxConvex) Then
			$tmpcontours[0] = $cv.convexHull($good_contours.at($i))
			$cv.drawContours($src_displayed, $tmpcontours, -1, _OpenCV_RGB(255, 0, 0), 3)

			If _IsChecked($CheckboxConvexCenter) Then
				; Draw circle in center of Convex
				$moments = $cv.moments($tmpcontours[0])

				Local $cx = $moments.m10 / $moments.m00
				Local $cy = $moments.m01 / $moments.m00
				$cv.circle($src_displayed, _OpenCV_Point($cx, $cy), 10, _OpenCV_RGB(255, 0, 0), $CV_FILLED)
			EndIf
		EndIf

		; Draw Straight Bounding Rectangle contour
		If _IsChecked($CheckboxBoundingRect) Then
			$tmp = $cv.boundingRect($good_contours.at($i))
			$cv.rectangle($src_displayed, $tmp, _OpenCV_RGB(0, 0, 255), 3, $CV_LINE_8, 0)
		EndIf

		; Draw Rotated Rectangle contour
		If _IsChecked($CheckboxRotatedRectangle) Then
			$tmp = $cv.minAreaRect($good_contours.at($i))
			$tmp = $cv.boxPoints($tmp)
			$tmp = $tmp.convertTo($CV_32S)
			$tmpcontours[0] = $tmp
			$cv.drawContours($src_displayed, $tmpcontours, -1, _OpenCV_RGB(255, 255, 0), 3)
		EndIf

		; Draw Minimum Enclosing Circle contour
		If _IsChecked($CheckboxEnclosingCircle) Then
			Local $center = $cv.minEnclosingCircle($good_contours.at($i))
			Local $radius = $cv.extended[1]
			$cv.circle($src_displayed, $center, $radius, _OpenCV_RGB(0xbf, 0x3E, 0xFF), 2)
		EndIf

		; Draw Fitting Ellipse contour
		If _IsChecked($CheckboxFittingEllipse) Then
			$tmp = $good_contours.at($i)
			If $tmp.rows < 5 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Cannot draw ellipse for countour ' & $i & ' because it has less than 5 points.' & @CRLF)
			Else
				$tmp = $cv.fitEllipse($tmp)
				$cv.ellipse($src_displayed, $tmp, _OpenCV_RGB(0xFF, 0x00, 0xC0), 2)
			EndIf
		EndIf
	Next

	; View result
	_OpenCV_imshow_ControlPic($src_displayed, $FormGUI, $PicSource)
EndFunc   ;==>_DrawContours

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
