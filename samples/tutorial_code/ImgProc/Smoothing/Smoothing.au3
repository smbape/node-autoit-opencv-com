#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/dc/dd3/tutorial_gausian_median_blur_bilateral_filter.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/ImgProc/Smoothing/Smoothing.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Smoothing Images", 1067, 641, 192, 124)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\lena.jpg", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Local $LabelMethod = GUICtrlCreateLabel("Method:", 504, 61, 59, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $ComboMethod = GUICtrlCreateCombo("", 568, 61, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "Homogeneous Blur|Gaussian Blur|Median Blur|Bilateral Blur")

Local $BtnReplay = GUICtrlCreateButton("Replay", 723, 59, 75, 25)

Local $LabelSource = GUICtrlCreateLabel("Source Image", 231, 92, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 20, 115, 510, 516)
Local $PicSource = GUICtrlCreatePic("", 25, 126, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelResult = GUICtrlCreateLabel("Smoothing Demo", 735, 92, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupResult = GUICtrlCreateGroup("", 532, 115, 510, 516)
Local $PicResult = GUICtrlCreatePic("", 537, 126, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

Local $sImage = ""
Local $nMsg

Local $src

Local $DELAY_BLUR = 100 ;
Local $MAX_KERNEL_LENGTH = 31 ;

Local $aMethods[4] = ["Homogeneous Blur", "Gaussian Blur", "Median Blur", "Bilateral Blur"]
_GUICtrlComboBox_SetCurSel($ComboMethod, 0)

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImage)
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

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

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
				$dst = $cv.blur($src, _OpenCV_Size($i, $i), _OpenCV_Point(-1, -1))
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
