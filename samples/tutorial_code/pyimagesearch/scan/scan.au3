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
;~     https://www.pyimagesearch.com/2014/09/01/build-kick-ass-mobile-document-scanner-just-5-minutes/
;~     https://www.pyimagesearch.com/2014/08/25/4-point-opencv-getperspective-transform-example/#comment-431230
;~     https://www.pyimagesearch.com/2016/03/21/ordering-coordinates-clockwise-with-python-and-opencv/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Mobile Document Scanner", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\receipt.jpg", 264, 24, 449, 21)
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

_GDIPlus_Startup()

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
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	If $sImage == "" Then Return

	;;! [Load image]
	Local $image = _OpenCV_imread_and_check($sImage)
	If @error Then Return
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSource)
	;;! [Load image]

	Local $orig = $image.clone()
	Local $ratio = $image.rows / 500.0
	$image = _OpenCV_resizeAndCenter($image, Default, 500)

	;; convert the image to grayscale, blur it, and find edges
	;; in the image
	Local $gray = $cv.cvtColor($image, $CV_COLOR_BGR2GRAY)
	$gray = $cv.GaussianBlur($gray, _OpenCV_Size(5, 5), 0)

	;; threshold the image, then perform a series of erosions +
	;; dilations to remove any small regions of noise
	$gray = $cv.erode($gray, Null, Default, 3)
	$gray = $cv.dilate($gray, Null, Default, 3)

	Local $edged = $cv.Canny($gray, 75, 200)

	;; find the contours in the edged image, keeping only the
	;; largest ones, and initialize the screen contour
	Local $cnts = $cv.findContours($edged, $CV_RETR_LIST, $CV_CHAIN_APPROX_SIMPLE)
	_OpenCV_ArraySort($cnts, "_ContourAreaComparator", $OPENCV_UDF_SORT_DESC)

	Local $screenCnt = $cnts[0]

	;; loop over the contours
	For $i = 0 To _Min(5, UBound($cnts)) - 1
		Local $c = $cnts[$i]

		;; approximate the contour
		Local $peri = $cv.arcLength($c, True)
		Local $approx = $cv.approxPolyDP($c, 0.02 * $peri, True)

		;; if our approximated contour has four points, then we
		;; can assume that we have found our screen
		If $approx.rows == 4 Then
			$screenCnt = $approx
			ExitLoop
		EndIf
	Next

	;; apply the four point transform to obtain a top-down
	;; view of the original image
	Local $warped = _OpenCV_FourPointTransform($orig, $screenCnt.convertTo(-1, $ratio))

	;; convert the warped image to grayscale, then threshold it
	;; to give it that 'black and white' paper effect
	; $warped = $cv.cvtColor($warped, $CV_COLOR_BGR2GRAY)
	; T = threshold_local(warped, 11, offset = 10, method = "gaussian")
	; warped = (warped > T).astype("uint8") * 255
	; $warped = $cv.inRange($warped, _OpenCV_Scalar(0), _OpenCV_Scalar(127))
	; $warped = $cv.bitwise_not($warped)

	;; show the original and scanned images
	_OpenCV_imshow_ControlPic($warped, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func _ContourAreaComparator($a, $b)
	Return _ContourArea($a) - _ContourArea($b)
EndFunc   ;==>_ContourAreaComparator

Func _ContourArea($c)
	; Return $cv.contourArea($c) ; Tends to give unexpected results for concave contours
	; Return $cv.contourArea($cv.convexHull($c)) ; A better approximation but way slower
	Local $rect = $cv.boundingRect($c)
	Return $rect[2] * $rect[3]
EndFunc   ;==>_ContourArea
