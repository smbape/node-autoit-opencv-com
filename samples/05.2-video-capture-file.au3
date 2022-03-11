#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <Misc.au3>

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $cap = _OpenCV_ObjCreate("cv.VideoCapture").create(_OpenCV_FindFile("samples\data\vtest.avi"))
	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the video file." & @CRLF)
		Exit
	EndIf

	Local $frame = _OpenCV_ObjCreate("cv.Mat")

	While 1
		If _IsPressed("1B") Or _IsPressed(Hex(Asc("Q"))) Then
			ExitLoop
		EndIf

		If Not $cap.read($frame) Then
			ConsoleWriteError("!>Error: cannot read the video or end of the video." & @CRLF)
			ExitLoop
		EndIf

		$cv.imshow("capture video file", $frame)

		Sleep(30)
	WEnd

	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
