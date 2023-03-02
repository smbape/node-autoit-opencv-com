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
;~     https://docs.opencv.org/4.7.0/d3/dc1/tutorial_basic_linear_transform.html
;~     https://github.com/opencv/opencv/blob/4.7.0/samples/cpp/tutorial_code/ImgProc/changing_contrast_brightness_image/changing_contrast_brightness_image.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")
$cv.samples.addSamplesDataSearchPath($OPENCV_SAMPLES_DATA_PATH)
$cv.samples.addSamplesDataSearchPath(_OpenCV_FindFile("samples\data", Default, Default, Default, _OpenCV_Tuple( _
        "opencv\sources", _
        "opencv-4.7.0-*\sources", _
        "opencv-4.7.0-*\opencv\sources" _
        )))

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Changing the contrast and brightness of an image!", 1261, 671, 185, 122)

Global $InputSource = GUICtrlCreateInput(_PathFull($cv.samples.findFile("lena.jpg")), 366, 16, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Source", 825, 14, 75, 25)

Global $LabelAlpha = GUICtrlCreateLabel("Alpha gain (contrast) : ", 366, 56, 195, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderAlpha = GUICtrlCreateSlider(560, 56, 340, 45)
GUICtrlSetLimit(-1, 500, 0)
GUICtrlSetData(-1, 100)

Global $LabelBeta = GUICtrlCreateLabel("Beta bias (brightness) : ", 366, 112, 197, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderBeta = GUICtrlCreateSlider(560, 104, 340, 45)
GUICtrlSetLimit(-1, 200, 0)
GUICtrlSetData(-1, 100)

Global $LabelGamma = GUICtrlCreateLabel("Gamma correction : ", 366, 160, 178, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderGamma = GUICtrlCreateSlider(560, 152, 340, 45)
GUICtrlSetLimit(-1, 200, 0)
GUICtrlSetData(-1, 100)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 170, 216, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 16, 240, 400, 400)
Global $PicSource = GUICtrlCreatePic("", 21, 251, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelLinearTransform = GUICtrlCreateLabel("Brightness and contrast adjustments", 504, 216, 253, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupLinearTransform = GUICtrlCreateGroup("", 430, 238, 400, 400)
Global $PicLinearTransform = GUICtrlCreatePic("", 435, 249, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelGammaCorrection = GUICtrlCreateLabel("Gamma correction", 975, 216, 130, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupGammaCorrection = GUICtrlCreateGroup("", 840, 238, 400, 400)
Global $PicGammaCorrection = GUICtrlCreatePic("", 845, 249, 390, 384)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderAlpha, 1)
_GUICtrlSlider_SetTicFreq($SliderBeta, 1)
_GUICtrlSlider_SetTicFreq($SliderGamma, 1)

Global $sInputSource, $img
Global $nMsg

Main()

Global $iCurrentAlpha = GUICtrlRead($SliderAlpha)
Global $iLastAlpha = $iCurrentAlpha

Global $iCurrentBeta = GUICtrlRead($SliderBeta)
Global $iLastBeta = $iCurrentBeta

Global $iCurrentGamma = GUICtrlRead($SliderGamma)
Global $iLastGamma = $iCurrentGamma

While 1
	$iCurrentAlpha = GUICtrlRead($SliderAlpha)
	$iCurrentBeta = GUICtrlRead($SliderBeta)
	If $iLastAlpha <> $iCurrentAlpha Or $iLastBeta <> $iCurrentBeta Then
		basicLinearTransform()
		$iLastAlpha = $iCurrentAlpha
		$iLastBeta = $iCurrentBeta
	EndIf

	$iCurrentGamma = GUICtrlRead($SliderGamma)
	If $iLastGamma <> $iCurrentGamma Then
		gammaCorrection()
		$iLastGamma = $iCurrentGamma
	EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sInputSource = ControlGetText($FormGUI, "", $InputSource)
			$sInputSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sInputSource)
			If @error Then
				$sInputSource = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sInputSource)
			EndIf
			Main()
	EndSwitch

	Sleep(30) ; Sleep to reduce CPU usage
WEnd

Func Main()
	$sInputSource = ControlGetText($FormGUI, "", $InputSource)
	If $sInputSource == "" Then Return

	;;! [Read the image]
	$img = _OpenCV_imread_and_check($sInputSource)
	If @error Then
		$sInputSource = ""
		Return
	EndIf
	;;! [Read the image]

	;;! [Show the image]
	_OpenCV_imshow_ControlPic($img, $FormGUI, $PicSource)
	;;! [Show the image]

	basicLinearTransform()
	gammaCorrection()
EndFunc   ;==>Main

Func basicLinearTransform()
	If $sInputSource == "" Then Return

	Local $alpha = GUICtrlRead($SliderAlpha) / 100
	GUICtrlSetData($LabelAlpha, "Alpha gain (contrast) : " & StringFormat("%.2f", $alpha))

	Local $beta = GUICtrlRead($SliderBeta) - 100
	GUICtrlSetData($LabelBeta, "Beta bias (brightness) : " & $beta)

	Local $res = $img.convertTo(_OpenCV_Params("alpha", $alpha, "beta", $beta))

	_OpenCV_imshow_ControlPic($res, $FormGUI, $PicLinearTransform)
EndFunc   ;==>basicLinearTransform

Func gammaCorrection()
	If $sInputSource == "" Then Return

	Local $gamma = GUICtrlRead($SliderGamma) / 100
	GUICtrlSetData($LabelGamma, "Gamma correction : " & StringFormat("%.2f", $gamma))

	;;! [changing-contrast-brightness-gamma-correction]
	Local $lookUpTable = $cv.Mat.create(1, 256, $CV_8U)
	Local $p = DllStructCreate("byte value[256]", $lookUpTable.ptr())

	For $i = 0 To 255
		; For elements that are an array this specifies the 1-based index to set.
		$p.value(($i + 1)) = _Max(0, _Min(255, (($i / 255) ^ $gamma) * 255))
	Next

	Local $res = $img.clone()
	$cv.LUT($img, $lookUpTable, $res)
	;;! [changing-contrast-brightness-gamma-correction]

	_OpenCV_imshow_ControlPic($res, $FormGUI, $PicGammaCorrection)

EndFunc   ;==>gammaCorrection

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
