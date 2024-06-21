#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIvkeysConstants.au3>
#include <WindowsConstants.au3>

;~ Sources:
;~     https://docs.opencv.org/4.10.0/de/d70/samples_2cpp_2kalman_8cpp-example.html
;~     https://github.com/opencv/opencv/blob/4.10.0/samples/cpp/kalman.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("OnAutoItExit")

Global $g_hSubclassProc = DllCallbackRegister("_SubclassProc", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")

Global $cv = _OpenCV_get()

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Kalman", 553, 547, -1, -1)

Global $GroupResult = GUICtrlCreateGroup("", 20, 11, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 25, 22, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_WinAPI_SetWindowSubclass($FormGUI, DllCallbackGetPtr($g_hSubclassProc), 1000, 0)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($GroupResult), DllCallbackGetPtr($g_hSubclassProc), 1000, 0)
_WinAPI_SetWindowSubclass(GUICtrlGetHandle($PicResult), DllCallbackGetPtr($g_hSubclassProc), 1000, 0)

Global $nMsg
Global $keyCode

Global $img = $cv.Mat.create(500, 500, $CV_8UC3)
Global $KF = $cv.KalmanFilter(2, 1, 0)
Global $state = $cv.Mat.create(2, 1, $CV_32F) ; /* (phi, delta_phi) */
Global $processNoise = $cv.Mat.create(2, 1, $CV_32F)
Global $measurement = $cv.Mat.zeros(1, 1, $CV_32F)

While 1
	Main()

	If $nMsg = $GUI_EVENT_CLOSE Or $keyCode = 0x1B Or $keyCode = Asc("Q") Or GUIGetMsg() = $GUI_EVENT_CLOSE Then
		ExitLoop
	EndIf
WEnd

Func Main()
	ConsoleWrite("Main" & @CRLF)

	$img.setTo(_OpenCV_ScalarAll(0))

	$state.set_at(0, 0)
	$state.set_at(1, 2 * $CV_PI / 6)
	$KF.transitionMatrix = $cv.Mat.create(2, 2, $CV_32F)
	$KF.transitionMatrix.set_at(0, 0, 1)
	$KF.transitionMatrix.set_at(0, 1, 1)
	$KF.transitionMatrix.set_at(1, 0, 0)
	$KF.transitionMatrix.set_at(1, 1, 1)

	$cv.setIdentity($KF.measurementMatrix)
	$cv.setIdentity($KF.processNoiseCov, _OpenCV_ScalarAll(1E-5))
	$cv.setIdentity($KF.measurementNoiseCov, _OpenCV_ScalarAll(1E-1))
	$cv.setIdentity($KF.errorCovPost, _OpenCV_ScalarAll(1))

	$cv.randn($KF.statePost, _OpenCV_ScalarAll(0), _OpenCV_ScalarAll(0.1))

	While 1
		Local $center = _OpenCV_Point($img.cols * 0.5, $img.rows * 0.5)
		Local $R = $img.cols / 3
		Local $stateAngle = $state.at(0) ;
		Local $statePt = calcPoint($center, $R, $stateAngle)

		Local $prediction = $KF.predict()
		Local $predictAngle = $prediction.at(0)
		Local $predictPt = calcPoint($center, $R, $predictAngle)

		;; generate measurement
		$cv.randn($measurement, _OpenCV_ScalarAll(0), _OpenCV_ScalarAll($KF.measurementNoiseCov.at(0)))

		$measurement = $cv.add($measurement, $cv.gemm($KF.measurementMatrix, $state, 1.0, Null, 0.0))

		Local $measAngle = $measurement.at(0)
		Local $measPt = calcPoint($center, $R, $measAngle)

		;; correct the state estimates based on measurements
		;; updates statePost & errorCovPost
		$KF.correct($measurement)
		Local $improvedAngle = $KF.statePost.at(0)
		Local $improvedPt = calcPoint($center, $R, $improvedAngle)

		;; plot points
		$img.convertTo(-1, $img, 0.2)
		$cv.drawMarker($img, $measPt, _OpenCV_Scalar(0, 0, 255), $CV_MARKER_SQUARE, 5, 2)
		$cv.drawMarker($img, $predictPt, _OpenCV_Scalar(0, 255, 255), $CV_MARKER_SQUARE, 5, 2)
		$cv.drawMarker($img, $improvedPt, _OpenCV_Scalar(0, 255, 0), $CV_MARKER_SQUARE, 5, 2)
		$cv.drawMarker($img, $statePt, _OpenCV_Scalar(255, 255, 255), $CV_MARKER_STAR, 10, 1)
		;; forecast one step
		Local $step = $cv.gemm($KF.transitionMatrix, $KF.statePost, 1.0, Null, 0.0)
		$cv.drawMarker($img, calcPoint($center, $R, $step.at(0)), _OpenCV_Scalar(255, 255, 0), $CV_MARKER_SQUARE, 12, 1)

		$cv.line($img, $statePt, $measPt, _OpenCV_Scalar(0, 0, 255), 1, $CV_LINE_AA, 0)
		$cv.line($img, $statePt, $predictPt, _OpenCV_Scalar(0, 255, 255), 1, $CV_LINE_AA, 0)
		$cv.line($img, $statePt, $improvedPt, _OpenCV_Scalar(0, 255, 0), 1, $CV_LINE_AA, 0)


		$cv.randn($processNoise, _OpenCV_Scalar(0), _OpenCV_ScalarAll(Sqrt($KF.processNoiseCov.at(0, 0))))
		$state = $cv.add($cv.gemm($KF.transitionMatrix, $state, 1.0, Null, 0.0), $processNoise)

		_OpenCV_imshow_ControlPic($img, $FormGUI, $PicResult)

		_WaitKey(1000)

		If $keyCode > 0 Or $nMsg = $GUI_EVENT_CLOSE Then
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>Main

Func calcPoint($center, $R, $angle)
	Return _openCV_Point($center[0] + Cos($angle) * $R, $center[1] - Sin($angle) * $R)
EndFunc   ;==>calcPoint

Func _WaitKey($delay = 0)
	$keyCode = -1
	Local $hTimer = TimerInit()
	While $keyCode == -1 And $nMsg <> $GUI_EVENT_CLOSE And TimerDiff($hTimer) < $delay
		Sleep(1)
		$nMsg = GUIGetMsg()
	WEnd
	Return $keyCode
EndFunc   ;==>_WaitKey

Func _SubclassProc($hWnd, $iMsg, $wParam, $lParam, $iID, $pData)
	#forceref $iID, $pData

	Switch $iMsg
		Case $WM_KEYDOWN
			$keyCode = $wParam
			ConsoleWrite("WM_KEYDOWN : " & Chr($wParam) & @CRLF)
	EndSwitch
	Return _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>_SubclassProc

Func OnAutoItExit()
	_WinAPI_RemoveWindowSubclass(GUICtrlGetHandle($PicResult), DllCallbackGetPtr($g_hSubclassProc), 1000)
	_WinAPI_RemoveWindowSubclass(GUICtrlGetHandle($GroupResult), DllCallbackGetPtr($g_hSubclassProc), 1000)
	_WinAPI_RemoveWindowSubclass($FormGUI, DllCallbackGetPtr($g_hSubclassProc), 1000)
	DllCallbackFree($g_hSubclassProc)
	_OpenCV_Close()
EndFunc   ;==>OnAutoItExit
