#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <Math.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://www.autoitscript.com/forum/topic/206432-opencv-v4-udf/page/5/?tab=comments#comment-1488802
;~     https://docs.opencv.org/4.10.0/dd/d49/tutorial_py_contour_features.html
;~     https://docs.opencv.org/4.10.0/d9/d61/tutorial_py_morphological_ops.html

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

Global $gray, $Gaus, $sObject = "", $img, $CurrentArea
Global $ErosionNumber = 0, $DilationNumber = 0, $OpeningNumber = 0, $ClosingNumber = 0, $GradientNumber = 0

#Region GUI
Global $FormGUI = GUICreate("Draw contour", 1060, 600, 200, 90)

Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("pic1.png"), 120, 16, 450, 21)
Global $BtnSource = GUICtrlCreateButton("Source", 580, 14, 75, 25)
Global $BtnExec = GUICtrlCreateButton("Execute", 750, 14, 75, 25)
Global $LabelThreshold = GUICtrlCreateLabel("Threshold: 180", 120, 70, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderThreshold = GUICtrlCreateSlider(240, 70, 334, 45)
GUICtrlSetLimit(-1, 255, 0) ; change min/max value
GUICtrlSetData($SliderThreshold, 180) ; set cursor
_GUICtrlSlider_SetTicFreq($SliderThreshold, 1)
Global $Invert = GUICtrlCreateCheckbox("Invert Gaussian Blur (the object must be white)", 580, 70, 250, 21)

GUICtrlCreateLabel("Do not show areas with square less than:", 120, 115, 290, 25)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $MinArea = GUICtrlCreateInput("1000", 415, 115, 50, 21)

Global $LabelSource = GUICtrlCreateLabel("Source image and Contour", 130, 150, 200, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 170, 400, 410)
Global $PicSource = GUICtrlCreatePic("", 25, 185, 380, 380)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelMatchTemplate = GUICtrlCreateLabel("Gaussian Blur", 580, 150, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupMatchTemplate = GUICtrlCreateGroup("", 455, 170, 400, 410)
Global $PicMatchTemplate = GUICtrlCreatePic("", 460, 185, 380, 380)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $Concave = GUICtrlCreateCheckbox("", 880, 15, 20, 21)
GUICtrlCreateLabel("View Concave contour", 900, 18, 140, 21)
GUICtrlSetColor(-1, 0x358856) ; Green

Global $ConcaveCenter = GUICtrlCreateCheckbox("", 880, 45, 20, 21)
GUICtrlSetState($ConcaveCenter, $GUI_DISABLE)
GUICtrlCreateLabel("Draw Concave center", 900, 48, 140, 21)
GUICtrlSetColor(-1, 0x358856) ; Green

Global $Convex = GUICtrlCreateCheckbox("", 880, 75, 20, 21)
GUICtrlCreateLabel("View Convex contour", 900, 78, 140, 21)
GUICtrlSetColor(-1, 0xFF0000) ; Red

Global $ConvexCenter = GUICtrlCreateCheckbox("", 880, 105, 20, 21)
GUICtrlSetState($ConvexCenter, $GUI_DISABLE)
GUICtrlCreateLabel("Draw Convex center", 900, 108, 140, 21)
GUICtrlSetColor(-1, 0xFF0000) ; Red

Global $BoundingRectangle = GUICtrlCreateCheckbox("", 880, 135, 20, 21)
GUICtrlCreateLabel("Straight Bounding Rectangle", 900, 138, 140, 21)
GUICtrlSetColor(-1, 0x0000FF) ; Blue

Global $RotatedRectangle = GUICtrlCreateCheckbox("", 880, 165, 20, 21)
GUICtrlCreateLabel("Rotated Rectangle", 900, 168, 140, 21)
GUICtrlSetColor(-1, 0xFFA701) ; Yellow

Global $EnclosingCircle = GUICtrlCreateCheckbox("", 880, 195, 20, 21)
GUICtrlCreateLabel("Minimum Enclosing Circle", 900, 198, 140, 21)
GUICtrlSetColor(-1, 0xbf3eff) ; Purple

Global $FittingEllipse = GUICtrlCreateCheckbox("", 880, 225, 20, 21)
GUICtrlCreateLabel("Fitting an Ellipse", 900, 228, 140, 21)
GUICtrlSetColor(-1, 0xff00c0) ; Pink

Global $Erosion = GUICtrlCreateButton("Reduce Line Thickness (Erosion)", 870, 300, 180, 25)
Global $Dilation = GUICtrlCreateButton("Increase Line Thickness (Dilation)", 870, 330, 180, 25)
Global $Opening = GUICtrlCreateButton("Removing noise (Opening)", 870, 360, 180, 25)
Global $Closing = GUICtrlCreateButton("Closing small holes inside (Closing)", 870, 390, 180, 25)
Global $Gradient = GUICtrlCreateButton("Outline of the object (Gradient)", 870, 420, 180, 25)

Global $SaveImg = GUICtrlCreateButton("Save image", 910, 500, 100, 25)
#EndRegion GUI

GUISetState(@SW_SHOW)

_ReadImg()
_Contour()

Global $nMsg, $current_threshold
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sObject = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif;*.webp)", $FD_FILEMUSTEXIST, $sObject)
			If @error Then
				$sObject = ""
			Else
				$ErosionNumber = 0
				$DilationNumber = 0

				ControlSetText($FormGUI, "", $InputSource, $sObject)
				_ReadImg()
			EndIf

		Case $SliderThreshold
			$ErosionNumber = 0
			$DilationNumber = 0
			$current_threshold = GUICtrlRead($SliderThreshold)
			GUICtrlSetData($LabelThreshold, "Threshold: " & $current_threshold)
			_ReadImg()

		Case $BtnExec
			If FileExists(GUICtrlRead($InputSource)) <> 1 Then
				MsgBox(0, "Warning", "Not found image")
			Else
				_ReadImg()
				_Contour()
			EndIf
		Case $Invert
			If $sObject <> "" Then
				$ErosionNumber = 0
				$DilationNumber = 0
				_ReadImg()
			EndIf
		Case $Concave
			If _IsChecked($Concave) Then
				GUICtrlSetState($ConcaveCenter, $GUI_ENABLE)
			Else
				GUICtrlSetState($ConcaveCenter, $GUI_DISABLE)
				GUICtrlSetState($ConcaveCenter, $GUI_UNCHECKED)
			EndIf
		Case $Convex
			If _IsChecked($Convex) Then
				GUICtrlSetState($ConvexCenter, $GUI_ENABLE)
			Else
				GUICtrlSetState($ConvexCenter, $GUI_DISABLE)
				GUICtrlSetState($ConvexCenter, $GUI_UNCHECKED)
			EndIf

		Case $Erosion
			If $sObject <> "" Then
				$ErosionNumber += 1
				_Erosion()
			EndIf
		Case $Dilation
			If $sObject <> "" Then
				$DilationNumber += 1
				_Dilation()
			EndIf
		Case $Opening
			If $sObject <> "" Then
				$OpeningNumber += 1
				_Opening()
			EndIf
		Case $Closing
			If $sObject <> "" Then
				$ClosingNumber += 1
				_Closing()
			EndIf
		Case $Gradient
			If $sObject <> "" Then
				$GradientNumber += 1
				_Gradient()
			EndIf
		Case $SaveImg
			_SaveImg()
	EndSwitch
WEnd

Func _SaveImg()
	;save to file
	$cv.imwrite(@ScriptDir & "\Result.png", $img)
EndFunc   ;==>_SaveImg

Func _ViewThreshold()
	$Gaus = $cv.GaussianBlur($img, _OpenCV_Size(5, 5), 0)

	$gray = $cv.cvtColor($Gaus, $CV_COLOR_BGR2GRAY)

	Local $threshold = GUICtrlRead($SliderThreshold)
	$cv.threshold($gray, $threshold, 255, _IsChecked($Invert) ? $CV_THRESH_BINARY_INV : $CV_THRESH_BINARY, $gray)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_ViewThreshold

Func _ReadImg()
	$sObject = ControlGetText($FormGUI, "", $InputSource)
	$img = _OpenCV_imread_and_check($sObject, $CV_IMREAD_COLOR)
	If @error Then
		$sObject = ""
		Return
	EndIf

	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
	_ViewThreshold()
EndFunc   ;==>_ReadImg

Func _Erosion()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")
	$gray = $cv.erode($gray, $kernel)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_Erosion

Func _Dilation()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")
	$gray = $cv.dilate($gray, $kernel)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_Dilation

Func _Opening()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")
	$gray = $cv.morphologyEx($gray, $CV_MORPH_OPEN, $kernel)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_Opening

Func _Closing()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")
	$gray = $cv.morphologyEx($gray, $CV_MORPH_CLOSE, $kernel)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_Closing

Func _Gradient()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")
	$gray = $cv.morphologyEx($gray, $CV_MORPH_GRADIENT, $kernel)
	_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
EndFunc   ;==>_Gradient

Func _Contour()
	Local $kernel = _OpenCV_ObjCreate("cv.Mat")

	If $ErosionNumber > 0 Then
		$gray = $cv.erode($gray, $kernel, Default, Default, $ErosionNumber)
		_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
	EndIf

	If $DilationNumber > 0 Then
		$gray = $cv.dilate($gray, $kernel, Default, Default, $DilationNumber)
		_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
	EndIf

	If $OpeningNumber > 0 Then
		$gray = $cv.morphologyEx($gray, $CV_MORPH_OPEN, $kernel)
		_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
	EndIf

	If $ClosingNumber > 0 Then
		$gray = $cv.morphologyEx($gray, $CV_MORPH_CLOSE, $kernel)
		_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
	EndIf

	If $GradientNumber > 0 Then
		$gray = $cv.morphologyEx($gray, $CV_MORPH_GRADIENT, $kernel)
		_OpenCV_imshow_ControlPic($gray, $FormGUI, $PicMatchTemplate)
	EndIf

	$CurrentArea = GUICtrlRead($MinArea)
	If $CurrentArea = "" Then $CurrentArea = 1000

	; Find contours
	Local $good_contours = _OpenCV_ObjCreate("VectorOfMat")
	Local $contours = $cv.findContours($gray, $CV_RETR_TREE, $CV_CHAIN_APPROX_SIMPLE) ; $CV_RETR_LIST, $CV_RETR_EXTERNAL, $CV_RETR_TREE

	ConsoleWrite("Found " & UBound($contours) & " contours" & @CRLF & @CRLF)

	For $i = 0 To UBound($contours) - 1
		Local $Area = $cv.contourArea($contours[$i])
		If $Area < $CurrentArea Then
			ContinueLoop
		EndIf
		$good_contours.push_back($contours[$i])
	Next

	ConsoleWrite("Found " & $good_contours.size() & " good_contours" & @CRLF & @CRLF)

	Local $moments

	; Concave draw
	If _IsChecked($Concave) Then
		For $i = 0 To $good_contours.size() - 1
			$cv.drawContours($img, $good_contours, $i, _OpenCV_RGB(0, 255, 0), 3) ; -1 for all contours

			If _IsChecked($ConcaveCenter) Then
				; Draw circle in center of Concave
				$moments = $cv.moments($good_contours.at($i))
				Local $cx1 = $moments.m10 / $moments.m00
				Local $cy1 = $moments.m01 / $moments.m00
				$cv.circle($img, _OpenCV_Point($cx1, $cy1), 15, _OpenCV_Scalar(0, 255, 0), $CV_FILLED)
			EndIf
		Next
	EndIf

	; Convex draw
	If _IsChecked($Convex) Then
		;Find and draw Convex contour
		Local $hull = _OpenCV_ObjCreate("VectorOfMat").create($good_contours.size())
		Local $hull_i = _OpenCV_ObjCreate("cv.Mat")
		For $i = 0 To $good_contours.size() - 1
			$cv.convexHull($good_contours.at($i), $hull_i)
			$hull.at($i, $hull_i)

			If _IsChecked($ConvexCenter) Then
				;Draw circle in center of Convex
				$moments = $cv.moments($hull_i)

				Local $cx = $moments.m10 / $moments.m00
				Local $cy = $moments.m01 / $moments.m00
				$cv.circle($img, _OpenCV_Point($cx, $cy), 10, _OpenCV_RGB(255, 0, 0), $CV_FILLED)
			EndIf
		Next

		$cv.drawContours($img, $hull, -1, _OpenCV_RGB(255, 0, 0), 3) ; -1 for all contours
	EndIf

	If _IsChecked($BoundingRectangle) Then
		Local $boundingRect
		; Local $tVectorPointPtr3 = DllStructCreate("ptr value")

		For $i = 0 To $good_contours.size() - 1
			$boundingRect = $cv.boundingRect($good_contours.at($i))
			$cv.rectangle($img, $boundingRect, _OpenCV_RGB(0, 0, 255), 3, $CV_LINE_8, 0)
		Next
	EndIf

	If _IsChecked($RotatedRectangle) Then
		Local $countours2 = _OpenCV_ObjCreate("VectorOfMat").create($good_contours.size())
		Local $box = _OpenCV_ObjCreate("cv.Mat")
		Local $rect

		For $i = 0 To $good_contours.size() - 1
			$rect = $cv.minAreaRect($good_contours.at($i))
			$cv.boxPoints($rect, $box)
			$box = $box.convertTo($CV_32S)
			$countours2.at($i, $box)
		Next

		$cv.drawContours($img, $countours2, -1, _OpenCV_RGB(255, 255, 0), 3)
	EndIf

	If _IsChecked($EnclosingCircle) Then
		Local $center, $radius
		For $i = 0 To $good_contours - 1
			$center = $cv.minEnclosingCircle($good_contours.at($i))
			$radius = $cv.extended[1]
			$cv.circle($img, $center, $radius, _OpenCV_RGB(0xbf, 0x3e, 0xff), 2)
		Next
	EndIf

	If _IsChecked($FittingEllipse) Then
		; Local $Less5 = 0
		Local $cnt, $ellipse
		For $i = 0 To $good_contours.size() - 1
			$cnt = $good_contours.at($i)

			If $cnt.rows < 5 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Cannot draw ellipse for countour ' & $i & ' because it has less than 5 points.' & @CRLF)
				ContinueLoop
			EndIf

			$ellipse = $cv.fitEllipse($cnt)
			$cv.ellipse($img, $ellipse, _OpenCV_RGB(0xff, 0x00, 0xc0), 2)
		Next
	EndIf

	; View result
	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
EndFunc   ;==>_Contour

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
