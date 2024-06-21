#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $img = _OpenCV_imread_and_check($cv.samples.findFile("mario.png"))
	Local $tmpl = _OpenCV_imread_and_check($cv.samples.findFile("mario_coin.png"))

	; The higher the value, the higher the match is exact
	Local $threshold = 0.8

	Local $aMatches = _OpenCV_FindTemplate($img, $tmpl, $threshold)

	Local $aRedColor = _OpenCV_RGB(255, 0, 0)
	Local $aMatchRect[4] = [0, 0, $tmpl.width, $tmpl.height]

	For $i = 0 To UBound($aMatches) - 1
		$aMatchRect[0] = $aMatches[$i][0]
		$aMatchRect[1] = $aMatches[$i][1]

		; Draw a red rectangle around the matched position
		$cv.rectangle($img, $aMatchRect, $aRedColor)
	Next

	$cv.imshow("Find template example", $img)
	$cv.waitKey()

	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
