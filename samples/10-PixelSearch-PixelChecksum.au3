#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Color.au3>
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $hTimer, $img, $aPos, $iChecksum

	; Search on the first screen. Leave empty to search on all screens
	; Reducing the search area improves the search time
	Local $aRect = _OpenCV_GetDesktopScreenRect(1)

	Local $iLeft = $aRect[0]
	Local $iTop = $aRect[1]
	Local $iWidth = $aRect[2]
	Local $iHeight = $aRect[3]
	Local $iColor = PixelGetColor($iLeft + $iWidth - 1, $iTop + $iHeight - 1)

	ConsoleWrite("Rect: [" & $iWidth & " x " & $iHeight & " from (" & $iLeft & ", " & $iTop & ")]" & @CRLF)
	ConsoleWrite("Color: 0x" & Hex($iColor, 6) & @CRLF)

	$hTimer = TimerInit()
	$img = _OpenCV_GetDesktopScreenMat($aRect)
	ConsoleWrite("Capturing screen took " & TimerDiff($hTimer) & "ms" & @CRLF)

	$hTimer = TimerInit()
	$aPos = PixelSearch($iLeft, $iTop, $iLeft + $iWidth - 1, $iTop + $iHeight - 1, $iColor)
	ConsoleWrite("PixelSearch took " & TimerDiff($hTimer) & "ms" & @CRLF)
	If IsArray($aPos) Then ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $aPos = [' & $aPos[0] & ', ' & $aPos[1] & ']' & @CRLF) ;### Debug Console

	$hTimer = TimerInit()
	$aPos = $img.PixelSearch(_ColorGetCOLORREF($iColor))
	ConsoleWrite("cv.Mat.PixelSearch took " & TimerDiff($hTimer) & "ms" & @CRLF)
	If IsArray($aPos) Then ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $aPos = [' & ($iLeft + $aPos[0]) & ', ' & ($iTop + $aPos[1]) & ']' & @CRLF) ;### Debug Console

	$hTimer = TimerInit()
	$iChecksum = PixelChecksum($iLeft, $iTop, $iLeft + $iWidth - 1, $iTop + $iHeight - 1)
	ConsoleWrite("PixelChecksum ADLER32 " & TimerDiff($hTimer) & "ms" & @CRLF)
	ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $iChecksum = 0x' & Hex(Ptr($iChecksum), 8) & @CRLF) ;### Debug Console

	$hTimer = TimerInit()
	$iChecksum = $img.PixelChecksum()
	ConsoleWrite("cv.Mat.PixelChecksum ADLER32 " & TimerDiff($hTimer) & "ms" & @CRLF)
	ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $iChecksum = 0x' & Hex(Ptr($iChecksum), 8) & @CRLF) ;### Debug Console

	$hTimer = TimerInit()
	$iChecksum = PixelChecksum($iLeft, $iTop, $iLeft + $iWidth - 1, $iTop + $iHeight - 1, Default, Default, 1)
	ConsoleWrite("PixelChecksum CRC32 " & TimerDiff($hTimer) & "ms" & @CRLF)
	ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $iChecksum = 0x' & Hex(Ptr($iChecksum), 8) & @CRLF) ;### Debug Console

	$hTimer = TimerInit()
	$iChecksum = $img.PixelChecksum(Default, Default, Default, Default, Default, 1)
	ConsoleWrite("cv.Mat.PixelChecksum CRC32 " & TimerDiff($hTimer) & "ms" & @CRLF)
	ConsoleWrite('    @@ Debug(' & @ScriptLineNumber & ') : $iChecksum = 0x' & Hex(Ptr($iChecksum), 8) & @CRLF) ;### Debug Console
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
