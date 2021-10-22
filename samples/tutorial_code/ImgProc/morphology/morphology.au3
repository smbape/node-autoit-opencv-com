#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <AutoItConstants.au3>
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
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/dd/d49/tutorial_py_contour_features.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/python/tutorial_code/ShapeDescriptors/bounding_rotated_ellipses/generalContours_demo2.py

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

_GDIPlus_Startup()

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Morphological Transformations", 1300, 617, 192, 124)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\j.png", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Local $LabelErosion = GUICtrlCreateLabel("Reduce Line Thickness (Erosion)", 1056, 110, 161, 17)
Local $InputErosion = GUICtrlCreateInput("1", 1224, 110, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelDilation = GUICtrlCreateLabel("Increase Line Thickness (Dilation)", 1056, 150, 161, 17)
Local $InputDilation = GUICtrlCreateInput("0", 1224, 148, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelOpening = GUICtrlCreateLabel("Removing noise (Opening)", 1056, 190, 161, 17)
Local $InputOpening = GUICtrlCreateInput("0", 1224, 188, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelClosing = GUICtrlCreateLabel("Closing small holes inside (Closing)", 1056, 230, 161, 17)
Local $InputClosing = GUICtrlCreateInput("0", 1224, 228, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelGradient = GUICtrlCreateLabel("Outline of the object (Gradient)", 1056, 270, 161, 17)
Local $InputGradient = GUICtrlCreateInput("0", 1224, 268, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelTopHat = GUICtrlCreateLabel("Top Hat", 1056, 310, 161, 17)
Local $InputTopHat = GUICtrlCreateInput("0", 1224, 308, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelBlackHat = GUICtrlCreateLabel("Black Hat", 1056, 350, 161, 17)
Local $InputBlackHat = GUICtrlCreateInput("0", 1224, 348, 41, 21)
GUICtrlCreateUpdown(-1)

Local $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Local $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelResult = GUICtrlCreateLabel("Morphological Transform", 719, 60, 177, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Local $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Local $src, $sImage

Local $oldErosion = GUICtrlRead($InputErosion)
Local $oldDilation = GUICtrlRead($InputDilation)
Local $oldOpening = GUICtrlRead($InputOpening)
Local $oldClosing = GUICtrlRead($InputClosing)
Local $oldGradient = GUICtrlRead($InputGradient)
Local $oldTopHat = GUICtrlRead($InputTopHat)
Local $oldBlackHat = GUICtrlRead($InputBlackHat)
Local $bTransform = False

Main()

Local $nMsg
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

		Case $InputErosion
			_CheckNumber($InputErosion, True)

		Case $InputDilation
			_CheckNumber($InputDilation, True)

		Case $InputOpening
			_CheckNumber($InputOpening, True)

		Case $InputClosing
			_CheckNumber($InputClosing, True)

		Case $InputGradient
			_CheckNumber($InputGradient, True)

		Case $InputTopHat
			_CheckNumber($InputTopHat, True)

		Case $InputBlackHat
			_CheckNumber($InputBlackHat, True)

		Case Else
			$bTransform = False

			If $oldErosion <> GUICtrlRead($InputErosion) Then
				$bTransform = True
				$oldErosion = GUICtrlRead($InputErosion)
			EndIf

			If $oldDilation <> GUICtrlRead($InputDilation) Then
				$bTransform = True
				$oldDilation = GUICtrlRead($InputDilation)
			EndIf

			If $oldOpening <> GUICtrlRead($InputOpening) Then
				$bTransform = True
				$oldOpening = GUICtrlRead($InputOpening)
			EndIf

			If $oldClosing <> GUICtrlRead($InputClosing) Then
				$bTransform = True
				$oldClosing = GUICtrlRead($InputClosing)
			EndIf

			If $oldGradient <> GUICtrlRead($InputGradient) Then
				$bTransform = True
				$oldGradient = GUICtrlRead($InputGradient)
			EndIf

			If $oldTopHat <> GUICtrlRead($InputTopHat) Then
				$bTransform = True
				$oldTopHat = GUICtrlRead($InputTopHat)
			EndIf

			If $oldBlackHat <> GUICtrlRead($InputBlackHat) Then
				$bTransform = True
				$oldBlackHat = GUICtrlRead($InputBlackHat)
			EndIf

			If $bTransform Then _Transform()
	EndSwitch

	Sleep(30) ; Sleep to reduce CPU usage
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	$src = _OpenCV_imread_and_check($sImage, $CV_IMREAD_COLOR)
	If @error Then
		MsgBox(0, "Warning", "Failed to read the image")
		$sImage = ""
		Return
	EndIf

	_OpenCV_imshow_ControlPic($src, $FormGUI, $PicSource)
	_Transform()
EndFunc   ;==>Main

Func _Transform()
	If $sImage == "" Then Return

	Local $src_displayed = $src.clone()
	Local $iterations
	Local $kernel = ObjCreate("OpenCV.cv.Mat").ones(5, 5, $CV_8UC1)

	$iterations = _CheckNumber($InputErosion)
	If $iterations > 0 Then $src_displayed = $cv.erode($src_displayed, $kernel, Default, $iterations)

	$iterations = _CheckNumber($InputDilation)
	If $iterations > 0 Then $src_displayed = $cv.dilate($src_displayed, $kernel, Default, $iterations)

	$iterations = _CheckNumber($InputOpening)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_OPEN, $kernel, Default, $iterations)

	$iterations = _CheckNumber($InputClosing)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_CLOSE, $kernel, Default, $iterations)

	$iterations = _CheckNumber($InputGradient)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_GRADIENT, $kernel, Default, $iterations)

	$kernel = ObjCreate("OpenCV.cv.Mat").ones(9, 9, $CV_8UC1)

	$iterations = _CheckNumber($InputTopHat)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_TOPHAT, $kernel, Default, $iterations)

	$iterations = Number(GUICtrlRead($InputBlackHat), $NUMBER_32BIT)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_BLACKHAT, $kernel, Default, $iterations)

	; View result
	_OpenCV_imshow_ControlPic($src_displayed, $FormGUI, $PicResult)
EndFunc   ;==>_Transform

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _CheckNumber($idControlID, $bSetData = False)
	Local $sValue = GUICtrlRead($idControlID)
	Local $nNumber = Number(GUICtrlRead($idControlID), $NUMBER_32BIT)
	If $nNumber < 0 Then $nNumber = 0
	If $bSetData And $sValue <> String($nNumber) Then
		GUICtrlSetData($idControlID, $nNumber)
	EndIf
	Return $nNumber
EndFunc   ;==>_CheckNumber
