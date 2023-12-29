#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("GUIOnEventMode", 1)

#include <File.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.9.0/d5/dc4/tutorial_adding_images.html
;~     https://github.com/opencv/opencv/blob/4.9.0/samples/cpp/tutorial_code/core/AddingImages/AddingImages.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world490*"), _OpenCV_FindDLL("autoit_opencv_com490*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Adding (blending) two images using OpenCV", 999, 500, 192, 124)

Global $InputSrc1 = GUICtrlCreateInput($cv.samples.findFile("LinuxLogo.jpg"), 230, 16, 449, 21)
Global $BtnSrc1 = GUICtrlCreateButton("Input 1", 689, 14, 75, 25)

Global $InputSrc2 = GUICtrlCreateInput($cv.samples.findFile("WindowsLogo.jpg"), 230, 52, 449, 21)
Global $BtnSrc2 = GUICtrlCreateButton("Input 2", 689, 50, 75, 25)

Global $LabelAlpha = GUICtrlCreateLabel("Alpha: 0.5", 230, 84, 104, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderAlpha = GUICtrlCreateSlider(342, 80, 422, 45)
GUICtrlSetData(-1, 50)

Global $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Global $LabelSrc1 = GUICtrlCreateLabel("Input 1", 144, 128, 49, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSrc1 = GUICtrlCreateGroup("", 20, 150, 310, 316)
Global $PicSrc1 = GUICtrlCreatePic("", 25, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelSrc2 = GUICtrlCreateLabel("Input 2", 468, 128, 49, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSrc2 = GUICtrlCreateGroup("", 344, 150, 310, 316)
Global $PicSrc2 = GUICtrlCreatePic("", 349, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Linear Blend", 792, 128, 91, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 668, 150, 310, 316)
Global $PicResult = GUICtrlCreatePic("", 673, 161, 300, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_cleanExit")
GUICtrlSetOnEvent($BtnSrc1, "_handleBtnSrc1Click")
GUICtrlSetOnEvent($BtnSrc2, "_handleBtnSrc2Click")
GUICtrlSetOnEvent($BtnExec, "_handleExecuteClick")
GUICtrlSetOnEvent($SliderAlpha, "AddWeighted")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderAlpha, 1)

Global $sSrc1 = "", $sSrc2 = ""
Global $src1, $src2
Global $warned = False

Main()

Global $current_alpha = GUICtrlRead($SliderAlpha)
Global $last_alpha = $current_alpha

While 1
	$current_alpha = GUICtrlRead($SliderAlpha)
	If $last_alpha <> $current_alpha Then
		AddWeighted()
		$last_alpha = $current_alpha
	EndIf
	Sleep(50) ; Sleep to reduce CPU usage
WEnd

Func _handleBtnSrc1Click()
	$sSrc1 = ControlGetText($FormGUI, "", $InputSrc1)
	$sSrc1 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSrc1)
	If @error Then
		$sSrc1 = ""
	Else
		ControlSetText($FormGUI, "", $InputSrc1, $sSrc1)
	EndIf
EndFunc   ;==>_handleBtnSrc1Click

Func _handleBtnSrc2Click()
	$sSrc2 = ControlGetText($FormGUI, "", $InputSrc2)
	$sSrc2 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSrc2)
	If @error Then
		$sSrc2 = ""
	Else
		ControlSetText($FormGUI, "", $InputSrc2, $sSrc2)
	EndIf
EndFunc   ;==>_handleBtnSrc2Click

Func _handleExecuteClick()
	Main()
EndFunc   ;==>_handleExecuteClick

Func Main()
	;;! [Load three images with different environment settings]
	$sSrc1 = ControlGetText($FormGUI, "", $InputSrc1)
	$src1 = _OpenCV_imread_and_check($sSrc1, $CV_IMREAD_COLOR)
	If @error Then
		$sSrc1 = ""
		Return
	EndIf

	$sSrc2 = ControlGetText($FormGUI, "", $InputSrc2)
	$src2 = _OpenCV_imread_and_check($sSrc2, $CV_IMREAD_COLOR)
	If @error Then
		$sSrc2 = ""
		Return
	EndIf
	;;! [Load three images with different environment settings]

	;;! [Display]
	_OpenCV_imshow_ControlPic($src1, $FormGUI, $PicSrc1)
	_OpenCV_imshow_ControlPic($src2, $FormGUI, $PicSrc2)
	;;! [Display]

	$warned = False
	AddWeighted()
EndFunc   ;==>Main

Func AddWeighted()
	Local $alpha = GUICtrlRead($SliderAlpha) / 100
	GUICtrlSetData($LabelAlpha, "Alpha: " & StringFormat("%.2f", $alpha))

	If $sSrc1 == "" Or $sSrc2 == "" Then Return

	If $src1.width <> $src2.width Or $src1.height <> $src2.height Then
		If Not $warned Then
			ConsoleWriteError("!>Error: 'Input 1' and 'Input 2' should be of the same size" & @CRLF)
			$warned = True
		EndIf
		Return
	EndIf

	;;![blend_images]
	Local $beta = (1.0 - $alpha) ;
	Local $dst = $cv.addWeighted($src1, $alpha, $src2, $beta, 0.0)
	;;![blend_images]

	;;![display]
	_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
	;;![display]
EndFunc   ;==>AddWeighted

Func _cleanExit()
	If @GUI_WinHandle <> $FormGUI Then Return
	Exit
EndFunc   ;==>_cleanExit

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
