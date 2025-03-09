#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <Misc.au3>

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $devices = _OpenCV_GetDevices()
	For $device In $devices
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Video Device = ' & $device & @CRLF) ;### Debug Console
	Next

	Local $iCamId = 0
	Local $cap = $cv.VideoCapture($iCamId)
	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the camera." & @CRLF)
		Exit
	EndIf

	Local Const $CAP_FPS = 60
	Local Const $CAP_SPF = 1000 / $CAP_FPS

	$cap.set($CV_CAP_PROP_FRAME_WIDTH, 1280)
	$cap.set($CV_CAP_PROP_FRAME_HEIGHT, 720)
	$cap.set($CV_CAP_PROP_FPS, $CAP_FPS)

	Local $frame = $cv.Mat.zeros(1280, 720, $CV_8UC3)
	Local $start, $fps

	While 1
		If _IsPressed("1B") Or _IsPressed(Hex(Asc("Q"))) Then
			ExitLoop
		EndIf

		$start = $cv.getTickCount()
		If $cap.read($frame) Then
			;; Flip the image horizontally to give the mirror impression
			$frame = $cv.flip($frame, 1)
		Else
			ConsoleWriteError("!>Error: cannot read the camera." & @CRLF)
		EndIf
		$fps = $cv.getTickFrequency() / ($cv.getTickCount() - $start)

		$cv.putText($frame, "FPS : " & Round($fps), _OpenCV_Point(10, 30), $CV_FONT_HERSHEY_PLAIN, 2, _OpenCV_Scalar(255, 0, 255), 3)
		$cv.imshow("capture camera", $frame)

		Sleep($CAP_SPF)
	WEnd

	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
