#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.5/dd/d49/tutorial_py_contour_features.html
;~     https://github.com/opencv/opencv/blob/4.5.5/samples/python/tutorial_code/imgProc/erosion_dilatation/morphology_1.py

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world5*", "opencv-5.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com5*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Morphological Transformations", 1300, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\j.png", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelErosion = GUICtrlCreateLabel("Reduce Line Thickness (Erosion)", 1056, 110, 161, 17)
Global $InputErosion = GUICtrlCreateInput("1", 1224, 110, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelDilation = GUICtrlCreateLabel("Increase Line Thickness (Dilation)", 1056, 150, 161, 17)
Global $InputDilation = GUICtrlCreateInput("0", 1224, 148, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelOpening = GUICtrlCreateLabel("Removing noise (Opening)", 1056, 190, 161, 17)
Global $InputOpening = GUICtrlCreateInput("0", 1224, 188, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelClosing = GUICtrlCreateLabel("Closing small holes inside (Closing)", 1056, 230, 161, 17)
Global $InputClosing = GUICtrlCreateInput("0", 1224, 228, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelGradient = GUICtrlCreateLabel("Outline of the object (Gradient)", 1056, 270, 161, 17)
Global $InputGradient = GUICtrlCreateInput("0", 1224, 268, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelTopHat = GUICtrlCreateLabel("Top Hat", 1056, 310, 161, 17)
Global $InputTopHat = GUICtrlCreateInput("0", 1224, 308, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelBlackHat = GUICtrlCreateLabel("Black Hat", 1056, 350, 161, 17)
Global $InputBlackHat = GUICtrlCreateInput("0", 1224, 348, 41, 21)
GUICtrlCreateUpdown(-1)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Morphological Transform", 719, 60, 177, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $src, $sImage

Global $oldErosion = GUICtrlRead($InputErosion)
Global $oldDilation = GUICtrlRead($InputDilation)
Global $oldOpening = GUICtrlRead($InputOpening)
Global $oldClosing = GUICtrlRead($InputClosing)
Global $oldGradient = GUICtrlRead($InputGradient)
Global $oldTopHat = GUICtrlRead($InputTopHat)
Global $oldBlackHat = GUICtrlRead($InputBlackHat)
Global $bTransform = False

Main()

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
	Local $kernel = _OpenCV_ObjCreate("cv.Mat").ones(5, 5, $CV_8UC1)

	$iterations = _CheckNumber($InputErosion)
	If $iterations > 0 Then $src_displayed = $cv.erode($src_displayed, $kernel, Default, Default, $iterations)

	$iterations = _CheckNumber($InputDilation)
	If $iterations > 0 Then $src_displayed = $cv.dilate($src_displayed, $kernel, Default, Default, $iterations)

	$iterations = _CheckNumber($InputOpening)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_OPEN, $kernel, Default, Default, $iterations)

	$iterations = _CheckNumber($InputClosing)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_CLOSE, $kernel, Default, Default, $iterations)

	$iterations = _CheckNumber($InputGradient)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_GRADIENT, $kernel, Default, Default, $iterations)

	$kernel = _OpenCV_ObjCreate("cv.Mat").ones(9, 9, $CV_8UC1)

	$iterations = _CheckNumber($InputTopHat)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_TOPHAT, $kernel, Default, Default, $iterations)

	$iterations = Number(GUICtrlRead($InputBlackHat), $NUMBER_32BIT)
	If $iterations > 0 Then $src_displayed = $cv.morphologyEx($src_displayed, $CV_MORPH_BLACKHAT, $kernel, Default, Default, $iterations)

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

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
