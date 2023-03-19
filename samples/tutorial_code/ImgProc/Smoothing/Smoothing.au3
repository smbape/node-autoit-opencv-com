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
;~     https://docs.opencv.org/4.7.0/dc/dd3/tutorial_gausian_median_blur_bilateral_filter.html
;~     https://github.com/opencv/opencv/blob/4.7.0/samples/cpp/tutorial_code/ImgProc/Smoothing/Smoothing.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Smoothing Images", 1067, 641, 192, 124)

Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("lena.jpg"), 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelMethod = GUICtrlCreateLabel("Method:", 504, 61, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboMethod = GUICtrlCreateCombo("", 568, 61, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "Homogeneous Blur|Gaussian Blur|Median Blur|Bilateral Blur")

Global $BtnReplay = GUICtrlCreateButton("Replay", 723, 59, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 92, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 115, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 126, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Smoothing Demo", 735, 92, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 115, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 126, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sImage = ""
Global $nMsg

Global $src

Global $DELAY_BLUR = 100 ;
Global $MAX_KERNEL_LENGTH = 31 ;

Global $aMethods[4] = ["Homogeneous Blur", "Gaussian Blur", "Median Blur", "Bilateral Blur"]
_GUICtrlComboBox_SetCurSel($ComboMethod, 0)

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sImage)
			If Not @error Then
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
		Case $BtnReplay
			Smooth()
		Case $ComboMethod
			Smooth()
	EndSwitch
WEnd

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	If $sImage == "" Then Return

	;;! [Load image]
	$src = _OpenCV_imread_and_check($sImage, $CV_IMREAD_COLOR)
	If @error Then
		$sImage = ""
		Return
	EndIf
	;;! [Load image]

	;;! [Display]
	; _cveImshowMat("Source image", $src );
	_OpenCV_imshow_ControlPic($src, $FormGUI, $PicSource)
	;;! [Display]

	Smooth()
EndFunc   ;==>Main

Func Smooth()
	If $sImage == "" Then Return

	Local $smooth_method = $aMethods[_GUICtrlComboBox_GetCurSel($ComboMethod)]
	Local $dst

	Switch $smooth_method
		Case "Homogeneous Blur"
			;;![blur]
			For $i = 1 To $MAX_KERNEL_LENGTH - 1 Step 2
				$dst = $cv.blur($src, _OpenCV_Size($i, $i))
				_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
				Sleep($DELAY_BLUR)
			Next
			;;![blur]
		Case "Gaussian Blur"
			;;![gaussianblur]
			For $i = 1 To $MAX_KERNEL_LENGTH - 1 Step 2
				$dst = $cv.GaussianBlur($src, _OpenCV_Size($i, $i), 0)
				_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
				Sleep($DELAY_BLUR)
			Next
			;;![gaussianblur]
		Case "Median Blur"
			;;![medianblur]
			For $i = 1 To $MAX_KERNEL_LENGTH - 1 Step 2
				$dst = $cv.medianBlur($src, $i)  ;
				_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
				Sleep($DELAY_BLUR)
			Next
			;;![medianblur]
		Case "Bilateral Blur"
			;;![bilateralfilter]
			For $i = 1 To $MAX_KERNEL_LENGTH - 1 Step 2
				$dst = $cv.bilateralFilter($src, $i, $i * 2, $i / 2)
				_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
				Sleep($DELAY_BLUR)
			Next
			;;![bilateralfilter]
	EndSwitch
EndFunc   ;==>Smooth

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
