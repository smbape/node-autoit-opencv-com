#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://www.pyimagesearch.com/2016/02/08/opencv-shape-detection/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world5*", "opencv-5.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com5*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("OpenCV shape detection", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\shapes_and_colors.png", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Shape detection", 735, 60, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sImage = ""
Global $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
	EndSwitch
WEnd

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	If $sImage == "" Then Return

	;;! [Load image]
	Local $image = _OpenCV_imread_and_check($sImage)
	If @error Then Return
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSource)
	;;! [Load image]

	;; resize it to a smaller factor so that
	;; the shapes can be approximated better
	Local $resized = _OpenCV_resizeAndCenter($image, 300)
	Local $ratio = $image.width / $resized.width

	;; convert the resized image to grayscale, blur it slightly,
	;; and threshold it
	Local $gray = $cv.cvtColor($resized, $CV_COLOR_BGR2GRAY)
	Local $blurred = $cv.GaussianBlur($gray, _OpenCV_Size(5, 5), 0)
	$cv.threshold($blurred, 60, 255, $CV_THRESH_BINARY)
	Local $thresh = $cv.extended[1]

	;; find contours in the thresholded image and initialize the
	;; shape detector
	Local $cnts = $cv.findContours($thresh, $CV_RETR_EXTERNAL, $CV_CHAIN_APPROX_SIMPLE)
	Local $tmp[1]

	For $i = 0 To UBound($cnts) - 1
		Local $c = $cnts[$i]

		;; compute the center of the contour, then detect the name of the
		;; shape using only the contour
		Local $M = $cv.moments($c)
		Local $cY = ($M.m01 / $M.m00) * $ratio
		Local $cX = ($M.m10 / $M.m00) * $ratio
		Local $shape = detect($c)

		;; multiply the contour (x, y)-coordinates by the resize ratio,
		;; then draw the contours and the name of the shape on the image
		$tmp[0] = $c.convertTo(-1, Default, $ratio)
		$cv.drawContours($image, $tmp, -1, _OpenCV_Scalar(0, 255, 0), 2)
		$cv.putText($image, $shape, _OpenCV_Point($cX, $cY), $CV_FONT_HERSHEY_SIMPLEX, 0.5, _OpenCV_Scalar(255, 255, 255), 2)
	Next

	;; show the output image
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func detect($c)
	Local $shape = "undefined"
	Local $peri = $cv.arcLength($c, True)
	Local $approx = $cv.approxPolyDP($c, 0.04 * $peri, True)
	Local $rect, $ar

	Switch $approx.rows
		Case 3
			$shape = "triangle"
		Case 4
			;; compute the bounding box of the contour and use the
			;; bounding box to compute the aspect ratio
			$rect = $cv.boundingRect($approx)
			$ar = $rect[2] / $rect[3]

			;; a square will have an aspect ratio that is approximately
			;; equal to one, otherwise, the shape is a rectangle
			$shape = ($ar >= 0.95 And $ar <= 1.05) ? "square" : "rectangle"
		Case 5
			$shape = "pentagon"
		Case Else
			$shape = "circle"
	EndSwitch

	Return $shape
EndFunc   ;==>detect

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
