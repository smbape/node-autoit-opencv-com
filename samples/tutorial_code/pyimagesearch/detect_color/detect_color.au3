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
;~     https://www.pyimagesearch.com/2016/02/15/determining-object-color-with-opencv/

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()
Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Determining object color with OpenCV", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\example_shapes.png", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Color and shape detection", 719, 60, 186, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $colors = getColors()
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

	;; blur the resized image slightly, then convert it to both
	;; grayscale and the L*a*b* color spaces
	Local $blurred = $cv.GaussianBlur($resized, _OpenCV_Size(5, 5), 0)
	Local $gray = $cv.cvtColor($blurred, $CV_COLOR_BGR2GRAY)
	Local $lab = $cv.cvtColor($blurred, $CV_COLOR_BGR2LAB)
	$cv.threshold($gray, 60, 255, $CV_THRESH_BINARY)
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

		; detect the shape of the contour and label the color
		Local $shape = detect($c)
		Local $color = label($lab, $c)

		;; multiply the contour (x, y)-coordinates by the resize ratio,
		;; then draw the contours and the name of the shape on the image
		$tmp[0] = $c.convertTo(_OpenCV_Params("alpha", $ratio))
		$cv.drawContours($image, $tmp, -1, _OpenCV_Scalar(0, 255, 0), 2)
		$cv.putText($image, $color & " " & $shape, _OpenCV_Point($cX, $cY), $CV_FONT_HERSHEY_SIMPLEX, 0.5, _OpenCV_Scalar(255, 255, 255), 2)
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

Func label($image, $c)
	;; construct a mask for the contour, then compute the
	;; average L*a*b* value for the masked region
	Local $mask = $cv.Mat.zeros($image.size, $CV_8UC1)
	Local $contours[1] = [$c]
	$cv.drawContours($mask, $contours, -1, 255, -1)
	$mask = $cv.erode($mask, Null, _OpenCV_Params("iterations", 2))
	Local $mean = $cv.mean($image, $mask)

	;; initialize the minimum distance found thus far
	Local $minDist[2] = [0x7FFFFFFFFFFFFFFF, Default]

	;; loop over the known L*a*b* color values
	For $i = 0 To UBound($colors) - 1
		;; compute the distance between the current L*a*b*
		;; color value and the mean of the image
		Local $d = _OpenCV_EuclideanDist($colors[$i][1], $mean)

		;; if the distance is smaller than the current distance,
		;; then update the bookkeeping variable
		If $d < $minDist[0] Then
			$minDist[0] = $d
			$minDist[1] = $i
		EndIf
	Next

	;; return the name of the color with the smallest distance
	Return $colors[$minDist[1]][0]
EndFunc   ;==>label

Func getColors()
	Local $colors[3][2] = [ _
			["red", _OpenCV_Tuple(255, 0, 0)], _
			["green", _OpenCV_Tuple(0, 255, 0)], _
			["blue", _OpenCV_Tuple(0, 0, 255)] _
			]

	Local $lab = $cv.Mat.zeros(UBound($colors), 1, $CV_8UC3)

	For $i = 0 To UBound($colors) - 1
		$lab.Vec3b_set_at($i, $colors[$i][1])
	Next

	$lab = $cv.cvtColor($lab, $CV_COLOR_RGB2LAB)

	For $i = 0 To UBound($colors) - 1
		$colors[$i][1] = $lab.Vec3b_at($i)
	Next

	Return $colors
EndFunc   ;==>getColors

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
