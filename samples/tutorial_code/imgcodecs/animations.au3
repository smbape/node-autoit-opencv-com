#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstantsEx.au3>
#include <Array.au3>

;~ Sources:
;~     https://github.com/opencv/opencv/blob/4.11.0/samples/python/tutorial_code/imgcodecs/animations.py
EnvSet("OPENCV_BUILD_TYPE", "Debug")
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	#Region ### START Koda GUI section ### Form=
	Local $FormGUI = GUICreate("Animation", 400, 400, 200, 200)
	Local $Pic = GUICtrlCreatePic("", 0, 0, 400, 400)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	Local $OPENCV_DATA_PATH = _OpenCV_FindFile("samples\data")
	Local $sFilename = "animated_image.webp"
	Local $frame, $i, $nMsg

	;; [write_animation]
	If $sFilename == "animated_image.webp" Then
		; Create an Animation instance to save
		Local $animation_to_save = $cv.Animation()

		; Generate a base $image with a specific color
		Local $image = $cv.Mat.create(128, 256, $CV_8UC4, _OpenCV_Scalar(150, 150, 150, 255))
		Local $duration = 200
		Local $frames[0]
		Local $durations[0]

		; Populate $frames and $durations in the Animation object
		For $i = 0 To 9
			$frame = $image.copy()
			$cv.putText($frame, "Frame " & $i, _OpenCV_Point(30, 80), $CV_FONT_HERSHEY_SIMPLEX, 1.5, _OpenCV_Scalar(255, 100, 0, 255), 2)
			_ArrayAdd($frames, $frame)
			_ArrayAdd($durations, $duration)
		Next

		$animation_to_save.frames = $frames
		$animation_to_save.durations = $durations

		; Write the animation to file
		$cv.imwriteanimation($OPENCV_DATA_PATH & "\" & $sFilename, $animation_to_save, _OpenCV_Tuple($CV_IMWRITE_WEBP_QUALITY, 100))
		;; [write_animation]
	EndIf

	;; [init_animation]
	Local $animation = $cv.Animation()
	;; [init_animation]

	;; [read_animation]
	Local $success = $cv.imreadanimation($OPENCV_DATA_PATH & "\" & $sFilename)
	$animation = $cv.extended[1]
	If Not $success Then
		ConsoleWriteError("!>Error: Failed to load animation frames" & @CRLF)
		Return
	EndIf
	;; [read_animation]

	;; [show_animation]
	Local $frame_count = $animation.frames.Count
	$i = 0

	While True
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch

		$frame = $animation.frames($i)
		_OpenCV_imshow_ControlPic($frame, $FormGUI, $Pic)
		Sleep($animation.durations($i))

		$i = $i + 1
		If $i = $frame_count Then $i = 0
	WEnd
	;; [show_animation]
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
