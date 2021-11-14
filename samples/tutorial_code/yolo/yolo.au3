#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <InetConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://www.autoitscript.com/forum/topic/202987-real-time-object-detection-using-yolov3-wrapper/
;~     https://learnopencv.com/deep-learning-based-object-detection-using-yolov3-with-opencv-python-c/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Global $cv = _OpenCV_get()
Global $addon_dll = _Addon_FindDLL()
Global $dnn = ObjCreate("OpenCV.cv.dnn")

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("OpenCV object detection", 1202, 795, 191, 27)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\people-2557408_1920.jpg", 264, 24, 449, 21)
Global $BtnSource = GUICtrlCreateButton("Browse", 723, 22, 75, 25)

Global $InputModelNames = GUICtrlCreateInput(@ScriptDir & "\yolov3.txt", 264, 60, 449, 21)
Global $BtnModelNames = GUICtrlCreateButton("Browse", 723, 58, 75, 25)

Global $InputModelConfiguration = GUICtrlCreateInput(@ScriptDir & "\yolov3.cfg", 264, 96, 449, 21)
Global $BtnModelConfiguration = GUICtrlCreateButton("Browse", 723, 94, 75, 25)

Global $InputModelWeights = GUICtrlCreateInput(@ScriptDir & "\yolov3.weights", 264, 132, 449, 21)
Global $BtnModelWeights = GUICtrlCreateButton("Browse", 723, 130, 75, 25)

Global $BtnExec = GUICtrlCreateButton("Execute", 832, 24, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 271, 180, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 203, 574, 580)
Global $PicSource = GUICtrlCreatePic("", 25, 214, 564, 564)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Object detection", 823, 180, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 604, 203, 574, 580)
Global $PicResult = GUICtrlCreatePic("", 609, 214, 564, 564)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

;; Initialize the parameters
Global $confThreshold = 0.5  ; Confidence threshold
Global $nmsThreshold = 0.4   ; Non-maximum suppression threshold
Global $inpWidth = 416       ; Width of network's input image
Global $inpHeight = 416      ; Height of network's input image

Global $sSource, $sModelNames, $sModelConfiguration, $sModelWeights
Global $nMsg

_DownloadWeights(ControlGetText($FormGUI, "", $InputModelWeights))
Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sSource = ControlGetText($FormGUI, "", $InputSource)
			$sSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sSource)
			If @error Then
				$sSource = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sSource)
			EndIf
		Case $BtnModelNames
			$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
			$sModelNames = FileOpenDialog("Select a model names", $OPENCV_SAMPLES_DATA_PATH, "Model names (*.names;*.txt)", $FD_FILEMUSTEXIST, $sModelNames)
			If @error Then
				$sModelNames = ""
			Else
				ControlSetText($FormGUI, "", $InputModelNames, $sModelNames)
			EndIf
		Case $BtnModelConfiguration
			$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)
			$sModelConfiguration = FileOpenDialog("Select a model configuration", $OPENCV_SAMPLES_DATA_PATH, "Model configuration (*.cfg)", $FD_FILEMUSTEXIST, $sModelConfiguration)
			If @error Then
				$sModelConfiguration = ""
			Else
				ControlSetText($FormGUI, "", $InputModelConfiguration, $sModelConfiguration)
			EndIf
		Case $BtnModelWeights
			$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)
			$sModelWeights = FileOpenDialog("Select a model weights", $OPENCV_SAMPLES_DATA_PATH, "Model weights (*.weights)", $FD_FILEMUSTEXIST, $sModelWeights)
			If @error Then
				$sModelWeights = ""
			Else
				ControlSetText($FormGUI, "", $InputModelWeights, $sModelWeights)
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

Func Main()
	$sSource = ControlGetText($FormGUI, "", $InputSource)
	If $sSource == "" Then Return

	$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
	If $sModelNames == "" Then Return

	$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)
	If $sModelConfiguration == "" Then Return

	$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)
	If $sModelWeights == "" Then Return

	;;! [Load image]
	Local $image = _OpenCV_imread_and_check($sSource)
	If @error Then Return
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSource)
	;;! [Load image]

	Local $hTimer

	Local $classes = FileReadToArray($sModelNames)
	If @error Then
		ConsoleWriteError("!>Error: Unable to read model names " & $sModelNames & @CRLF)
	EndIf

	; Local $net = $dnn.readNetFromDarknet($sModelConfiguration, $sModelWeights)
	; $net.setPreferableBackend($CV_DNN_DNN_BACKEND_OPENCV)
	; $net.setPreferableTarget($CV_DNN_DNN_TARGET_CPU)

	$hTimer = TimerInit()
	Local $net = $dnn.readNet($sModelWeights, $sModelConfiguration)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $dnn.readNet    ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	$hTimer = TimerInit()
	ProcessFrame($net, $classes, $image)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ProcessFrame    ' & TimerDiff($hTimer) & ' ms' & @CRLF)
EndFunc   ;==>Main

Func ProcessFrame($net, $classes, $frame)
	Local $hTimer

	;; Create a 4D blob from a frame.
	Local $blob = $dnn.blobFromImage($frame, 1 / 255, _OpenCV_Size($inpWidth, $inpHeight), _OpenCV_Scalar(0, 0, 0), True, False)

	;; Sets the input to the network
	$net.setInput($blob)

	;; Runs the forward pass to get output of the output layers
	$hTimer = TimerInit()
	Local $outs = $net.forward(getOutputsNames($net))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : forward         ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Remove the bounding boxes with low confidence
	$hTimer = TimerInit()
	postprocess($frame, $outs, $classes)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : postprocess     ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Put efficiency information.
	;; The function getPerfProfile returns the overall time for inference(t)
	;; and the timings for each of the layers(in layersTimes)
	Local $t = $net.getPerfProfile()
	Local $label = 'Inference time: ' & Round($t * 1000.0 / $cv.getTickFrequency(), 2) & ' ms'
	$cv.putText($frame, $label, _OpenCV_Point(0, 15), $CV_FONT_HERSHEY_SIMPLEX, 0.5, _OpenCV_Scalar(0, 0, 255))

	$hTimer = TimerInit()
	_OpenCV_imshow_ControlPic($frame, $FormGUI, $PicResult)
EndFunc   ;==>ProcessFrame

;; Get the names of the output layers
Func getOutputsNames($net)
	;; Get the indices of the output layers, i.e. the layers with unconnected outputs
	Local $outLayers = $net.getUnconnectedOutLayers()

	;; Get the names of all the layers in the network
	Local $layersNames = $net.getLayerNames()

	;; Get the names of the output layers in names
	Local $names[UBound($outLayers)]
	; Local $names = ObjCreate("OpenCV.VectorOfString").create(UBound($outLayers))

	For $i = 0 To UBound($outLayers) - 1
		$names[$i] = $layersNames[$outLayers[$i] - 1]
		; $names.at($i, $layersNames[$outLayers[$i] - 1])
	Next

	Return $names
EndFunc   ;==>getOutputsNames

;; Remove the bounding boxes with low confidence using non-maxima suppression
Func postprocess($frame, $outs, $classes)
	Local $frameHeight = $frame.height
	Local $frameWidth = $frame.width

	;; Scan through all the bounding boxes output from the network and keep only the
	;; ones with high confidence scores. Assign the box's class label as the class with the highest score.
	Local $classIds = ObjCreate("OpenCV.VectorOfInt")
	Local $confidences = ObjCreate("OpenCV.VectorOfFloat")
	Local $boxes = ObjCreate("OpenCV.VectorOfRect2d")
	Local $Mat = ObjCreate("OpenCV.cv.Mat")

	Local $hTimer

	Local $left, $top, $width, $height

	If $addon_dll == "" Then
		; Slower
		$hTimer = TimerInit()

		Local $detection = $Mat.create(1, 0, $CV_32F)
		Local $scores = $Mat.create(1, 0, $CV_32F)

		Local $out, $data, $step, $cols, $sizeof
		Local $confidence, $classIdPoint
		Local $center_x, $center_y

		For $i = 0 To UBound($outs) - 1
			$out = $outs[$i]
			$data = Ptr($out.data)
			$step = $out.step
			$cols = $out.cols
			$sizeof = $step / $cols
			$detection.cols = $cols
			$scores.cols = $cols - 5

			For $j = 0 To $out.rows - 1
				; Slower
				; Local $detection = $out.row($j)
				; Local $scores = $detection.colRange(5, $out.cols)

				; Slower
				; $detection.data = $out.ptr($j, 0)
				; $scores.data = $out.ptr($j, 5)

				$detection.data = $data + $step * $j
				$scores.data = Ptr($detection.data) + 5 * $sizeof

				$cv.minMaxLoc($scores)
				$confidence = $cv.extended[1]
				$classIdPoint = $cv.extended[3]

				If $confidence > $confThreshold Then
					$center_x = $detection.at(0) * $frameWidth
					$center_y = $detection.at(1) * $frameHeight
					$width = $detection.at(2) * $frameWidth
					$height = $detection.at(3) * $frameHeight
					$left = $center_x - $width / 2
					$top = $center_y - $height / 2

					$classIds.push_back($classIdPoint[0])
					$confidences.push_back($confidence)
					$boxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
				EndIf
			Next
		Next

		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : AutoIt yolo_postprocess  ' & TimerDiff($hTimer) & ' ms' & @CRLF)
	Else
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
		$hTimer = TimerInit()
		Local $vOuts = ObjCreate("OpenCV.VectorOfMat").create($outs)
		_OpenCV_DllCall($addon_dll, "none:cdecl", "yolo_postprocess", _
			"ptr", $frame.self, _
			"ptr", $vOuts.self, _
			"float", $confThreshold, _
			"float", $nmsThreshold, _
			"ptr", $classIds.self, _
			"ptr", $confidences.self, _
			"ptr", $boxes.self _
		)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllCall yolo_postprocess ' & TimerDiff($hTimer) & ' ms' & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf

	;; Perform non maximum suppression to eliminate redundant overlapping boxes with
	;; lower confidences.
	Local $indices = $dnn.NMSBoxes($boxes, $confidences, $confThreshold, $nmsThreshold)
	Local $idx, $box
	For $i = 0 To UBound($indices) - 1
		$idx = $indices[$i]
		$box = $boxes.at($idx)
		$left = $box[0]
		$top = $box[1]
		$width = $box[2]
		$height = $box[3]
		drawPred($classIds.at($idx), $confidences.at($idx), $left, $top, $left + $width, $top + $height, $frame, $classes)
	Next
EndFunc   ;==>postprocess

Func drawPred($classId, $conf, $left, $top, $right, $bottom, $frame, $classes)
	;; Draw a bounding box.
	$cv.rectangle($frame, _OpenCV_Point($left, $top), _OpenCV_Point($right, $bottom), _OpenCV_Scalar(255, 178, 50), 3)

	;; Get the label for the class name and its confidence
	Local $label = IsArray($classes) ? $classes[$classId] & ':' & Round($conf, 2) : String(Round($conf, 2))

	Local $aPicPos = ControlGetPos($FormGUI, "", $PicResult)
	Local $iDstWidth = $aPicPos[2]
	Local $iDstHeight = $aPicPos[3]
	Local $fRatio = $frame.width / $frame.height
	Local $ratio = 1
	If $fRatio * $iDstHeight > $iDstWidth Then
		$ratio = $frame.width / $iDstWidth
	ElseIf $fRatio * $iDstHeight < $iDstWidth Then
		$ratio = $frame.height / $iDstHeight
	Else
		$ratio = 1
	EndIf

	;;Display the label at the top of the bounding box
	Local $labelSize = $cv.getTextSize($label, $CV_FONT_HERSHEY_SIMPLEX, 0.5 * $ratio, $ratio)
	Local $baseLine = $cv.extended[1] ;
	$top = _Max($top, $labelSize[1])
	$cv.rectangle( _
		$frame, _
		_OpenCV_Point($left, $top - 1.5 * $labelSize[1]), _
		_OpenCV_Point($left + 1.5 * $labelSize[0], $top + $baseLine), _
		_OpenCV_Scalar(255, 255, 255), _
		$CV_FILLED _
	)
	$cv.putText($frame, $label, _OpenCV_Point($left, $top), $CV_FONT_HERSHEY_SIMPLEX, 0.75 * $ratio, _OpenCV_Scalar(0, 0, 0), $ratio)
EndFunc   ;==>drawPred

Func _DownloadWeights($sFilePath)
	Local $sUrl = "https://pjreddie.com/media/files/yolov3.weights"
	Local $iActualSize = FileGetSize($sFilePath)
	Local $iExpectedSize = InetGetSize($sUrl)

	If (Not FileExists($sFilePath)) Or $iActualSize <> $iExpectedSize Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetSize ' & $iActualSize & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : InetGetSize ' & $iExpectedSize & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Downloading ' & $sUrl & @CRLF) ;### Debug Console
		InetGet($sUrl, $sFilePath, $INET_FORCERELOAD)
	EndIf
EndFunc
