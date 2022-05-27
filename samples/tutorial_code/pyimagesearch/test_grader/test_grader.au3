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
;~     https://www.pyimagesearch.com/2016/10/03/bubble-sheet-multiple-choice-scanner-and-test-grader-using-omr-python-and-opencv/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world5*", "opencv-5.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com5*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Bubble sheet multiple choice scanner and test grader using OMR and OpenCV", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\images\test_01.png", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Exam", 735, 60, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sImage = ""
Global $nMsg

;; define the answer key which maps the question number
;; to the correct answer
Global $ANSWER_KEY[5] = [1, 4, 0, 3, 1]

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

	Local $gray = $cv.cvtColor($image, $CV_COLOR_BGR2GRAY)
	Local $blurred = $cv.GaussianBlur($gray, _OpenCV_Size(5, 5), 0)
	Local $edged = $cv.Canny($blurred, 75, 200)

	;; find contours in the edge map, then initialize
	;; the contour that corresponds to the document
	Local $cnts = $cv.findContours($edged, $CV_RETR_EXTERNAL, $CV_CHAIN_APPROX_SIMPLE)
	Local $docCnt = Default

	;; sort the contours according to their size in
	;; descending order
	_OpenCV_ArraySort($cnts, "_ContourAreaComparator", True)

	;; loop over the contours
	For $i = 0 To UBound($cnts) - 1
		Local $c = $cnts[$i]

		;; approximate the contour
		Local $peri = $cv.arcLength($c, True)
		Local $approx = $cv.approxPolyDP($c, 0.02 * $peri, True)

		;; if our approximated contour has four points, then we
		;; can assume that we have found our screen
		If $approx.rows == 4 Then
			$docCnt = $approx
			ExitLoop
		EndIf
	Next

	Local $paper = $docCnt == Default ? $image : GradePaper($image, $gray, $docCnt)

	_OpenCV_imshow_ControlPic($paper, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func GradePaper($image, $gray, $docCnt)
	;; apply a four point perspective transform to both the
	;; original image and grayscale image to obtain a top-down
	;; birds eye view of the paper
	Local $paper = _OpenCV_FourPointTransform($image, $docCnt)
	Local $warped = _OpenCV_FourPointTransform($gray, $docCnt)

	;; apply Otsu's thresholding method to binarize the warped
	;; piece of paper
	$cv.threshold($warped, 0, 255, BitOR($CV_THRESH_BINARY_INV, $CV_THRESH_OTSU))
	Local $thresh = $cv.extended[1]

	;; find contours in the thresholded image, then initialize
	;; the list of contours that correspond to questions
	Local $cnts = $cv.findContours($thresh, $CV_RETR_EXTERNAL, $CV_CHAIN_APPROX_SIMPLE)
	Local $questionCnts = _OpenCV_ObjCreate("VectorOfMat")
	Local $c

	;; loop over the contours
	For $i = 0 To UBound($cnts) - 1
		$c = $cnts[$i]

		;; compute the bounding box of the contour, then use the
		;; bounding box to derive the aspect ratio
		Local $rect = $cv.boundingRect($c)
		Local $w = $rect[2], $h = $rect[3]
		Local $ar = $w / $h

		;; in order to label the contour as a question, region
		;; should be sufficiently wide, sufficiently tall, and
		;; have an aspect ratio approximately equal to 1
		If $w >= 20 And $h >= 20 And $ar >= 0.9 And $ar <= 1.1 Then
			$questionCnts.push_back($c)
		EndIf
	Next

	;; sort the question contours top-to-bottom left-to-right
	_OpenCV_VectorSort($questionCnts, "_TopToBottomComparator")

	Local $correct = 0
	Local $mask, $bubbled, $total, $color, $k

	;; each question has 5 possible answers
	;; after sorting the contours,
	;; every batch of 5 contours is a question
	Local $questionsCount = $questionCnts.size() / 5
	For $q = 0 To $questionsCount - 1
		$cnts = $questionCnts.slice($q * 5, 5)
		_OpenCV_ArraySort($cnts, "_LeftToRightComparator")
		$bubbled = Default

		;; loop over the sorted contours
		For $j = 0 To UBound($cnts) - 1
			$c = $cnts[$j]

			;; construct a mask that reveals only the current
			;; "bubble" for the question
			$mask = _OpenCV_ObjCreate("cv.Mat").zeros($thresh.size(), $CV_8U)
			$cv.drawContours($mask, _OpenCV_Tuple($c), -1, 255, -1)

			;; apply the mask to the thresholded image, then
			;; count the number of non-zero pixels in the
			;; bubble area
			$mask = $cv.bitwise_and($thresh, $thresh, Default, $mask)
			$total = $cv.countNonZero($mask)

			;; if the current total has a larger number of total
			;; non-zero pixels, then we are examining the currently
			;; bubbled-in answer
			If $bubbled == Default Or $total > $bubbled[0] Then
				$bubbled = _OpenCV_Tuple($total, $j)
			EndIf
		Next

		;; initialize the contour color and the index of the
		;; *correct* answer
		$color = _OpenCV_Scalar(0, 0, 255)
		$k = $ANSWER_KEY[$q]

		;; check to see if the bubbled answer is correct
		If $k == $bubbled[1] Then
			$color = _OpenCV_Scalar(0, 255, 0)
			$correct += 1
		EndIf

		;; draw the outline of the correct answer on the test
		$cv.drawContours($paper, $cnts, $k, $color, 3)
	Next

	;; grab the test taker
	Local $score = ($correct / 5.0) * 100
	ConsoleWrite(StringFormat("[INFO] score: %.2f%%", $score) & @CRLF)
	$cv.putText($paper, StringFormat("%.2f%%", $score), _OpenCV_Point(10, 30), $CV_FONT_HERSHEY_SIMPLEX, 0.9, _OpenCV_Scalar(0, 0, 255), 2)

	Return $paper
EndFunc   ;==>GradePaper

Func _ContourAreaComparator($a, $b)
	Return $cv.contourArea($a) - $cv.contourArea($b)
EndFunc   ;==>_ContourAreaComparator

Func _TopToBottomComparator($a, $b)
	$a = $cv.boundingRect($a)
	$b = $cv.boundingRect($b)
	Return $a[1] - $b[1]
EndFunc   ;==>_TopToBottomComparator

Func _LeftToRightComparator($a, $b)
	$a = $cv.boundingRect($a)
	$b = $cv.boundingRect($b)
	Return $a[0] - $b[0]
EndFunc   ;==>_LeftToRightComparator

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
