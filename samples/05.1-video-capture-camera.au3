#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <Misc.au3>

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

If IsObj($cv) Then
	Local $iCamId = 0
	Local $cap = ObjCreate("OpenCV.cv.VideoCapture").create($iCamId)
	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the camera." & @CRLF)
		Exit
	EndIf

	Local $frame = ObjCreate("OpenCV.cv.Mat")

	While 1
		If _IsPressed("1B") Or _IsPressed(Hex(Asc("Q"))) Then
			ExitLoop
		EndIf

		If $cap.read($frame) Then
			;; Flip the image horizontally to give the mirror impression
			$frame = $cv.flip($frame, 1)
			$cv.imshow("capture camera", $frame)
		Else
			ConsoleWriteError("!>Error: cannot read the camera." & @CRLF)
		EndIf

		Sleep(30)
	WEnd

	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()
