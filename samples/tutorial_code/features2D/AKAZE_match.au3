#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.5/db/d70/tutorial_akaze_matching.html
;~     https://github.com/opencv/opencv/blob/4.5.5/samples/cpp/tutorial_code/features2D/AKAZE_match.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()
Global $addon_dll = _Addon_FindDLL()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("AKAZE local features matching", 1000, 707, 192, 95)

Global $InputImg1 = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\graf1.png", 230, 16, 449, 21)
Global $BtnImg1 = GUICtrlCreateButton("Image 1", 689, 14, 75, 25)

Global $InputImg2 = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\graf3.png", 230, 52, 449, 21)
Global $BtnImg2 = GUICtrlCreateButton("Image 2", 689, 50, 75, 25)

Global $InputHomography = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\H1to3p.xml", 230, 92, 449, 21)
Global $BtnHomography = GUICtrlCreateButton("Homography matrix", 689, 90, 115, 25)

Global $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Global $LabelMatches = GUICtrlCreateLabel("Result", 377, 144, 245, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupMatches = GUICtrlCreateGroup("", 20, 166, 958, 532)
Global $PicMatches = GUICtrlCreatePic("", 25, 177, 948, 516)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $img1, $img2, $homography
Global $nMsg, $hTimer
Global $sImg1, $sImg2, $sHomography

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnImg1
			$sImg1 = ControlGetText($FormGUI, "", $InputImg1)
			$sImg1 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImg1)
			If @error Then
				$sImg1 = ""
			Else
				ControlSetText($FormGUI, "", $InputImg1, $sImg1)
			EndIf
		Case $BtnImg2
			$sImg2 = ControlGetText($FormGUI, "", $InputImg2)
			$sImg2 = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImg2)
			If @error Then
				$sImg2 = ""
			Else
				ControlSetText($FormGUI, "", $InputImg2, $sImg2)
			EndIf
		Case $BtnHomography
			$sHomography = ControlGetText($FormGUI, "", $InputHomography)
			$sHomography = FileOpenDialog("Select an xml", $OPENCV_SAMPLES_DATA_PATH, "XML files (*.xml)", $FD_FILEMUSTEXIST, $sHomography)
			If @error Then
				$sHomography = ""
			Else
				ControlSetText($FormGUI, "", $InputHomography, $sHomography)
			EndIf
		Case $BtnExec
			Clean(False)
			Main()
	EndSwitch
WEnd

Func Main()
	;;! [load]
	If StringCompare($sImg1, ControlGetText($FormGUI, "", $InputImg1), $STR_NOCASESENSE) <> 0 Then
		$sImg1 = ControlGetText($FormGUI, "", $InputImg1)
		$img1 = _OpenCV_imread_and_check($sImg1, $CV_IMREAD_GRAYSCALE)
		If @error Then
			$sImg1 = ""
			Return
		EndIf
	EndIf

	If StringCompare($sImg2, ControlGetText($FormGUI, "", $InputImg2), $STR_NOCASESENSE) <> 0 Then
		$sImg2 = ControlGetText($FormGUI, "", $InputImg2)
		$img2 = _OpenCV_imread_and_check($sImg2, $CV_IMREAD_GRAYSCALE)
		If @error Then
			$sImg2 = ""
			Return
		EndIf
	EndIf

	If StringCompare($sHomography, ControlGetText($FormGUI, "", $InputHomography), $STR_NOCASESENSE) <> 0 Then
		$sHomography = ControlGetText($FormGUI, "", $InputHomography)
		Local $fs = _OpenCV_ObjCreate("cv.FileStorage").create($sHomography, $CV_FILE_STORAGE_READ)
		$homography = $fs.getFirstTopLevelNode().mat()

		If $homography.empty() Then
			ConsoleWriteError("!>Error: The xml file " & $sHomography & " could not be loaded." & @CRLF)
			$sHomography = ""
			Return
		EndIf
	EndIf
	;;! [load]

	Detect()
EndFunc   ;==>Main

Func Clean($force = True)
	If $sImg1 <> "" And ($force Or StringCompare($sImg1, ControlGetText($FormGUI, "", $InputImg1), $STR_NOCASESENSE) <> 0) Then
		$img1 = 0
		$sImg1 = ""
	EndIf

	If $sImg2 <> "" And ($force Or StringCompare($sImg2, ControlGetText($FormGUI, "", $InputImg2), $STR_NOCASESENSE) <> 0) Then
		$img2 = 0
		$sImg2 = ""
	EndIf

	If $sHomography <> "" And ($force Or StringCompare($sHomography, ControlGetText($FormGUI, "", $InputHomography), $STR_NOCASESENSE) <> 0) Then
		$homography = 0
		$sHomography = ""
	EndIf
EndFunc   ;==>Clean

Func Detect()
	If $sImg1 == "" Or $sImg2 == "" Or $sHomography == "" Then Return

	Local $inlier_threshold = 2.5 ; // Distance threshold to identify inliers with homography check
	Local $nn_match_ratio = 0.8 ;   // Nearest neighbor matching ratio

	;;! [AKAZE]
	$hTimer = TimerInit()
	Local $akaze = _OpenCV_ObjCreate("cv.AKAZE").create()

	Local $kpts1 = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $desc1 = _OpenCV_ObjCreate("cv.Mat")
	$akaze.detectAndCompute($img1, _OpenCV_ObjCreate("cv.Mat"), Default, $kpts1, $desc1)

	Local $kpts2 = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $desc2 = _OpenCV_ObjCreate("cv.Mat")
	$akaze.detectAndCompute($img2, _OpenCV_ObjCreate("cv.Mat"), Default, $kpts2, $desc2)

	ConsoleWrite("detectAndCompute                         " & TimerDiff($hTimer) & "ms" & @CRLF)
	;;! [AKAZE]

	;;! [2-nn matching]
	$hTimer = TimerInit()
	Local $matcher = _OpenCV_ObjCreate("cv.BFMatcher").create($CV_NORM_HAMMING)
	Local $nn_matches = _OpenCV_ObjCreate("VectorOfVectorOfDMatch")
	$matcher.knnMatch($desc1, $desc2, 2, Default, Default, $nn_matches)
	ConsoleWrite("knnMatch                                 " & TimerDiff($hTimer) & "ms" & @CRLF)
	;;! [2-nn matching]

	;;! [ratio test filtering]
	Local $matched1 = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $matched2 = _OpenCV_ObjCreate("VectorOfKeyPoint")

	If $addon_dll == "" Then
		; Slower
		$hTimer = TimerInit()
		For $i = 0 To $nn_matches.size() - 1
			Local $first = $nn_matches.at($i)[0]

			Local $dist1 = $nn_matches.at($i)[0].distance
			Local $dist2 = $nn_matches.at($i)[1].distance

			If $dist1 < $nn_match_ratio * $dist2 Then
				$matched1.push_back($kpts1.at($first.queryIdx))
				$matched2.push_back($kpts2.at($first.trainIdx))
			EndIf
		Next
		ConsoleWrite("AutoIt AKAZE_match_ratio_test_filtering  " & TimerDiff($hTimer) & "ms" & @CRLF)
	Else
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
		$hTimer = TimerInit()
		_OpenCV_DllCall($addon_dll, "none:cdecl", "AKAZE_match_ratio_test_filtering", _
			"ptr", $matched1.self, _
			"ptr", $kpts1.self, _
			"ptr", $matched2.self, _
			"ptr", $kpts2.self, _
			"ptr", $nn_matches.self, _
			"float", $nn_match_ratio _
		)
		ConsoleWrite("DllCall AKAZE_match_ratio_test_filtering " & TimerDiff($hTimer) & "ms" & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf
	;;! [ratio test filtering]

	;;! [homography check]
	Local $good_matches = _OpenCV_ObjCreate("VectorOfDMatch")
	Local $inliers1 = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $inliers2 = _OpenCV_ObjCreate("VectorOfKeyPoint")

	If $addon_dll == "" Then
		; Slower
		$hTimer = TimerInit()
		For $i = 0 To $matched1.size() - 1
			Local $col = _OpenCV_ObjCreate("cv.Mat").ones(3, 1, $CV_64F)
			$col.double_set_at(0, $matched1.at($i).pt[0])
			$col.double_set_at(1, $matched1.at($i).pt[1])

			$col = $cv.gemm($homography, $col, 1.0, _OpenCV_ObjCreate("cv.Mat"), 0.0)
			$col = $col.convertTo(-1, 1 / $col.double_at(2), 0.0)

			Local $dist = Sqrt((($col.double_at(0) - $matched2.at($i).pt[0]) ^ 2) + _
					(($col.double_at(1) - $matched2.at($i).pt[1]) ^ 2))

			If $dist < $inlier_threshold Then
				Local $new_i = $inliers1.size()
				$inliers1.push_back($matched1.at($i))
				$inliers2.push_back($matched2.at($i))
				$good_matches.push_back(_OpenCV_ObjCreate("cv.DMatch").create($new_i, $new_i, 0))
			EndIf
		Next

		ConsoleWrite("AutoIt AKAZE_homograpy_check             " & TimerDiff($hTimer) & "ms" & @CRLF)
	Else
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
		$hTimer = TimerInit()
		_OpenCV_DllCall($addon_dll, "none:cdecl", "AKAZE_homograpy_check", _
			"ptr", $homography.self, _
			"ptr", $matched1.self, _
			"ptr", $inliers1.self, _
			"ptr", $matched2.self, _
			"ptr", $inliers2.self, _
			"float", $inlier_threshold, _
			"ptr", $good_matches.self _
		)
		ConsoleWrite("DllCall AKAZE_homograpy_check            " & TimerDiff($hTimer) & "ms" & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf
	ConsoleWrite(@CRLF)
	;;! [homography check]

	;;! [draw final matches]
	Local $res = $cv.drawMatches($img1, $inliers1, $img2, $inliers2, $good_matches)

	Local $inlier_ratio = $inliers1.size() / $matched1.size()
	ConsoleWrite("A-KAZE Matching Results" & @CRLF) ;
	ConsoleWrite("*******************************" & @CRLF) ;
	ConsoleWrite("# Keypoints 1:                        " & @TAB & $kpts1.size() & @CRLF) ;
	ConsoleWrite("# Keypoints 2:                        " & @TAB & $kpts2.size() & @CRLF) ;
	ConsoleWrite("# Matches:                            " & @TAB & $matched1.size() & @CRLF) ;
	ConsoleWrite("# Inliers:                            " & @TAB & $inliers1.size() & @CRLF) ;
	ConsoleWrite("# Inliers Ratio:                      " & @TAB & $inlier_ratio & @CRLF) ;
	ConsoleWrite(@CRLF) ;

	_OpenCV_imshow_ControlPic($res, $FormGUI, $PicMatches)
	;;! [draw final matches]
EndFunc   ;==>Detect

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
