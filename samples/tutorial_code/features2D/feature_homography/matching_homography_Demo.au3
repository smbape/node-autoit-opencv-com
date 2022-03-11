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
;~     https://docs.opencv.org/4.5.5/d7/dff/tutorial_feature_homography.html
;~     https://github.com/opencv/opencv/blob/4.5.5/samples/cpp/tutorial_code/features2D/feature_homography/SURF_FLANN_matching_homography_Demo.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Features2D + Homography to find a known object", 1000, 707, 192, 95)

Global $InputObject = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\box.png", 230, 16, 449, 21)
Global $BtnObject = GUICtrlCreateButton("Object", 689, 14, 75, 25)

Global $InputScene = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\box_in_scene.png", 230, 52, 449, 21)
Global $BtnScene = GUICtrlCreateButton("Scene", 689, 50, 75, 25)

Global $LabelAlgorithm = GUICtrlCreateLabel("Algorithm", 150, 92, 69, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboAlgorithm = GUICtrlCreateCombo("", 230, 92, 169, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "ORB|Brisk|FAST|MSER|SimpleBlob|GFTT|KAZE|AKAZE|Agast")

Global $LabelMatchType = GUICtrlCreateLabel("Match type", 414, 92, 79, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboMatchType = GUICtrlCreateCombo("", 502, 92, 177, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "BruteForce|BruteForce-L1|BruteForce-Hamming|BruteForce-HammingLUT|BruteForce-Hamming(2)|BruteForce-SL2")

Global $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Global $LabelMatches = GUICtrlCreateLabel("Good Matches && Object detection", 377, 144, 245, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupMatches = GUICtrlCreateGroup("", 20, 166, 958, 532)
Global $PicMatches = GUICtrlCreatePic("", 25, 177, 948, 516)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $aMatchTypes[6] = [ _
		$CV_NORM_L2, _
		$CV_NORM_L1, _
		$CV_NORM_HAMMING, _
		$CV_NORM_HAMMING, _
		$CV_NORM_HAMMING2, _
		$CV_NORM_L2SQR _
		]

Global $ORB_DETECTOR = 0
Global $BRISK_DETECTOR = 1
Global $FAST_DETECTOR = 2
Global $MSER_DETECTOR = 3
Global $SIMPLE_BLOB_DETECTOR = 4
Global $GFTT_DETECTOR = 5
Global $KAZE_DETECTOR = 6
Global $AKAZE_DETECTOR = 7
Global $AGAST_DETECTOR = 8

_GUICtrlComboBox_SetCurSel($ComboAlgorithm, 0)
_GUICtrlComboBox_SetCurSel($ComboMatchType, 2)

Global $img_object, $img_scene
Global $nMsg
Global $sObject, $sScene

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnObject
			$sObject = ControlGetText($FormGUI, "", $InputObject)
			$sObject = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sObject)
			If @error Then
				$sObject = ""
			Else
				ControlSetText($FormGUI, "", $InputObject, $sObject)
			EndIf
		Case $BtnScene
			$sScene = ControlGetText($FormGUI, "", $InputScene)
			$sScene = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sScene)
			If @error Then
				$sScene = ""
			Else
				ControlSetText($FormGUI, "", $InputScene, $sScene)
			EndIf
		Case $ComboAlgorithm
			Detect()
		Case $ComboMatchType
			Detect()
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	;;! [load_image]
	;;/ Load object and scene
	$sObject = ControlGetText($FormGUI, "", $InputObject)
	$img_object = _OpenCV_imread_and_check($sObject, $CV_IMREAD_GRAYSCALE)
	If @error Then
		$sObject = ""
		Return
	EndIf

	$sScene = ControlGetText($FormGUI, "", $InputScene)
	$img_scene = _OpenCV_imread_and_check($sScene, $CV_IMREAD_GRAYSCALE)
	If @error Then
		$sScene = ""
		Return
	EndIf
	;;! [load_image]

	Detect()
EndFunc   ;==>Main

Func Detect()
	If $sObject == "" Or $sScene == "" Then Return

	Local $algorithm = _GUICtrlComboBox_GetCurSel($ComboAlgorithm)
	Local $match_type = $aMatchTypes[_GUICtrlComboBox_GetCurSel($ComboMatchType)]

	Local $can_compute = False
	Local $detector

	;;-- Step 1: Detect the keypoints using ORB Detector, compute the descriptors
	Switch $algorithm
		Case $ORB_DETECTOR
			$can_compute = True
			$detector = _OpenCV_ObjCreate("cv.ORB").create()
		Case $BRISK_DETECTOR
			$can_compute = True
			$detector = _OpenCV_ObjCreate("cv.BRISK").create()
		Case $FAST_DETECTOR
			$detector = _OpenCV_ObjCreate("cv.FastFeatureDetector").create()
		Case $MSER_DETECTOR
			$detector = _OpenCV_ObjCreate("cv.MSER").create()
		Case $SIMPLE_BLOB_DETECTOR
			$detector = _OpenCV_ObjCreate("cv.SimpleBlobDetector").create()
		Case $GFTT_DETECTOR
			$detector = _OpenCV_ObjCreate("cv.GFTTDetector").create()
		Case $KAZE_DETECTOR
			$can_compute = $match_type <> $CV_NORM_HAMMING And $match_type <> $CV_NORM_HAMMING2
			$detector = _OpenCV_ObjCreate("cv.KAZE").create()
		Case $AKAZE_DETECTOR
			$can_compute = True
			$detector = _OpenCV_ObjCreate("cv.AKAZE").create()
		Case $AGAST_DETECTOR
			$detector = _OpenCV_ObjCreate("cv.AgastFeatureDetector").create()
	EndSwitch

	Local $keypoints_object = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $keypoints_scene = _OpenCV_ObjCreate("VectorOfKeyPoint")
	Local $descriptors_object = _OpenCV_ObjCreate("cv.Mat")
	Local $descriptors_scene = _OpenCV_ObjCreate("cv.Mat")

	If $can_compute Then
		$detector.detectAndCompute($img_object, _OpenCV_ObjCreate("cv.Mat"), Default, $keypoints_object, $descriptors_object)
		$detector.detectAndCompute($img_scene, _OpenCV_ObjCreate("cv.Mat"), Default, $keypoints_scene, $descriptors_scene)
	Else
		$detector.detect($img_object, _OpenCV_ObjCreate("cv.Mat"), $keypoints_object)
		$detector.detect($img_scene, _OpenCV_ObjCreate("cv.Mat"), $keypoints_scene)
	EndIf

	;;-- Step 2: Matching descriptor vectors with a BruteForce based matcher
	;; Since ORB is a floating-point descriptor NORM_L2 is used
	Local $matcher = _OpenCV_ObjCreate("cv.BFMatcher").create()
	Local $knn_matches = _OpenCV_ObjCreate("VectorOfVectorOfDMatch")

	If $can_compute Then
		$matcher.knnMatch($descriptors_object, $descriptors_scene, 2, Default, Default, $knn_matches)
	EndIf

	;;-- Filter matches using the Lowe's ratio test
	Local $ratio_thresh = 0.75
	Local $good_matches = _OpenCV_ObjCreate("VectorOfDMatch")

	For $i = 0 To $knn_matches.size() - 1
		Local $oDMatch0 = $knn_matches.at($i)[0]
		Local $oDMatch1 = $knn_matches.at($i)[1]

		If $oDMatch0.distance < $ratio_thresh * $oDMatch1.distance Then
			$good_matches.push_back($oDMatch0)
		EndIf
	Next

	;;-- Draw matches
	Local $img_matches = _OpenCV_ObjCreate("cv.Mat")
	Local $matchesMask[0]

	If $can_compute Then
		$cv.drawMatches($img_object, $keypoints_object, $img_scene, $keypoints_scene, $good_matches, $img_matches, _OpenCV_ScalarAll(-1), _
				_OpenCV_ScalarAll(-1), $matchesMask, $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)
	Else
		Local $img_object_with_keypoints = _OpenCV_ObjCreate("cv.Mat")
		$cv.drawKeypoints($img_object, $keypoints_object, $img_object_with_keypoints, _OpenCV_ScalarAll(-1), $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)

		Local $img_scene_with_keypoints = _OpenCV_ObjCreate("cv.Mat")
		$cv.drawKeypoints($img_scene, $keypoints_scene, $img_scene_with_keypoints, _OpenCV_ScalarAll(-1), $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)

		; workaround to concatenate the two images
		$cv.drawMatches($img_object_with_keypoints, $keypoints_object, $img_scene_with_keypoints, $keypoints_scene, $good_matches, $img_matches, _OpenCV_ScalarAll(-1), _
				_OpenCV_ScalarAll(-1), $matchesMask, $CV_DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS)
	EndIf


	If Not $can_compute Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Compute is not supported for combination ' & GUICtrlRead($ComboAlgorithm) & ' - ' & GUICtrlRead($ComboMatchType) & @CRLF)
	ElseIf $good_matches.size() < 4 Then
		ConsoleWriteError("!>Error: Unable to calculate homography. There is less than 4 point correspondences." & @CRLF)
	Else
		;;-- Localize the object
		Local $obj = _OpenCV_ObjCreate("VectorOfPoint2f")
		Local $scene = _OpenCV_ObjCreate("VectorOfPoint2f")

		For $i = 0 To $good_matches.size() - 1
			;;-- Get the keypoints from the good matches
			$obj.push_back($keypoints_object.at($good_matches.at($i).queryIdx).pt)
			$scene.push_back($keypoints_scene.at($good_matches.at($i).trainIdx).pt)
		Next

		Local $H = $cv.findHomography($obj, $scene, $CV_RANSAC)

		If $H.empty() Then
			ConsoleWriteError("!>Error: No homography were found." & @CRLF)
		Else
			;;-- Get the corners from the image_1 ( the object to be "detected" )
			Local $obj_corners = _OpenCV_ObjCreate("VectorOfPoint2f").create(4)

			$obj_corners.at(0, _OpenCV_Point(0, 0))
			$obj_corners.at(1, _OpenCV_Point($img_object.cols, 0))
			$obj_corners.at(2, _OpenCV_Point($img_object.cols, $img_object.rows))
			$obj_corners.at(3, _OpenCV_Point(0, $img_object.rows))

			Local $scene_corners = _OpenCV_ObjCreate("VectorOfPoint2f").create(4)

			$cv.perspectiveTransform($obj_corners, $H, $scene_corners)

			;;-- Draw lines between the corners (the mapped object in the scene - image_2 )
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(0)[0] + $img_object.cols, $scene_corners.at(0)[1]), _
					_OpenCV_Point($scene_corners.at(1)[0] + $img_object.cols, $scene_corners.at(1)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(1)[0] + $img_object.cols, $scene_corners.at(1)[1]), _
					_OpenCV_Point($scene_corners.at(2)[0] + $img_object.cols, $scene_corners.at(2)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(2)[0] + $img_object.cols, $scene_corners.at(2)[1]), _
					_OpenCV_Point($scene_corners.at(3)[0] + $img_object.cols, $scene_corners.at(3)[1]), _OpenCV_Scalar(0, 255, 0), 4)
			$cv.line($img_matches, _OpenCV_Point($scene_corners.at(3)[0] + $img_object.cols, $scene_corners.at(3)[1]), _
					_OpenCV_Point($scene_corners.at(0)[0] + $img_object.cols, $scene_corners.at(0)[1]), _OpenCV_Scalar(0, 255, 0), 4)
		EndIf
	EndIf

	;-- Show detected matches
	; _cveImshowMat("Good Matches & Object detection", $img_matches)
	_OpenCV_imshow_ControlPic($img_matches, $FormGUI, $PicMatches)
EndFunc   ;==>Detect

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
