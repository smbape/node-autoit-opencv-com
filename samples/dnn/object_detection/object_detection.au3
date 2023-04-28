#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 ; -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <InetConstants.au3>
#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <Misc.au3>
#include <WinAPIDiag.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://learnopencv.com/deep-learning-based-object-detection-using-yolov3-with-opencv-python-c/
;~     https://github.com/sjinzh/awesome-yolo-object-detection
;~     https://github.com/ultralytics/yolov5
;~     https://github.com/ultralytics/yolov5/issues/251
;~     https://learnopencv.com/object-detection-using-yolov5-and-opencv-dnn-in-c-and-python/
;~     https://github.com/ultralytics/ultralytics/blob/main/examples/YOLOv8-CPP-Inference/inference.cpp
;~     https://docs.opencv.org/4.x/d4/d2f/tf_det_tutorial_dnn_conversion.html
;~     https://github.com/opencv/opencv/blob/4.7.0/samples/dnn/object_detection.py

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()
Global $addon_dll = _Addon_FindDLL()

; Make the starting point unpredictable
$cv.theRNG().state = $cv.getTickCount()

Global $models = $cv.FileStorage(@ScriptDir & "\models.yml", $CV_FILE_STORAGE_READ).root().asVariant()
Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")
$cv.samples.addSamplesDataSearchPath(_OpenCV_FindFile("tutorial_code\yolo"))

Global $sModelList = "none"
For $model In $models.Keys()
	If $models($model) ("sample") == "object_detection" Then
		$sModelList &= "|" & $model
	EndIf
Next

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Deep learning object detection in OpenCV", 1273, 840, 191, 18)

Global $LabelInput = GUICtrlCreateLabel("Input", 125, 8, 37, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("vtest.avi"), 164, 8, 324, 21)
; Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("scooter-5180947_1920.jpg"), 164, 8, 324, 21)
; Global $InputSource = GUICtrlCreateInput(_PathFull($cv.samples.findFile("group.jpg")), 164, 8, 324, 21)
Global $BtnSource = GUICtrlCreateButton("Browse", 498, 6, 75, 25)

Global $CheckboxUseCamera = GUICtrlCreateCheckbox("", 80, 44, 17, 17)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $LabelCamera = GUICtrlCreateLabel("Camera", 102, 44, 58, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboCamera = GUICtrlCreateCombo("", 164, 44, 407, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))

Global $LabelModelClassification = GUICtrlCreateLabel("Classification model", 16, 80, 144, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelClassification = GUICtrlCreateInput("", 164, 80, 324, 21)
Global $BtnModelClassification = GUICtrlCreateButton("Browse", 498, 78, 75, 25)

Global $LabelModelNames = GUICtrlCreateLabel("Model names", 63, 116, 97, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelNames = GUICtrlCreateInput("", 164, 116, 324, 21)
Global $BtnModelNames = GUICtrlCreateButton("Browse", 498, 114, 75, 25)

Global $LabelModelConfiguration = GUICtrlCreateLabel("Model configuration", 20, 152, 140, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelConfiguration = GUICtrlCreateInput("", 164, 152, 324, 21)
Global $BtnModelConfiguration = GUICtrlCreateButton("Browse", 498, 150, 75, 25)

Global $LabelZooModel = GUICtrlCreateLabel("Zoo model", 607, 150, 78, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, 'Preset parameters based on a zoo model')
Global $ComboZooModel = GUICtrlCreateCombo("", 689, 150, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
; GUICtrlSetData(-1, $sModelList, "faster_rcnn_tf")
; GUICtrlSetData(-1, $sModelList, "opencv_fd")
; GUICtrlSetData(-1, $sModelList, "ssd_caffe")
GUICtrlSetData(-1, $sModelList, "ssd_tf")
; GUICtrlSetData(-1, $sModelList, "yolo")
; GUICtrlSetData(-1, $sModelList, "yolov5n")
; GUICtrlSetData(-1, $sModelList, "yolov5s")
; GUICtrlSetData(-1, $sModelList, "yolov8n")
; GUICtrlSetData(-1, $sModelList, "yolov8s")
GUICtrlSetTip(-1, 'Preset parameters based on a zoo model')

Global $LabelModelSize = GUICtrlCreateLabel("Model size", 607, 6, 81, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelWidth = GUICtrlCreateInput("640", 695, 6, 25, 21)
GUICtrlSetTip(-1, "Width of network's input image")
Global $InputModelHeight = GUICtrlCreateInput("640", 730, 6, 25, 21)
GUICtrlSetTip(-1, "Height of network's input image")

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 607, 42, 97, 17)
; GUICtrlSetState(-1, $GUI_CHECKED)

Global $CheckboxUseCPP = GUICtrlCreateCheckbox("Use C++", 607, 78, 97, 17)
If $addon_dll == "" Then
	GUICtrlSetState(-1, $GUI_DISABLE)
Else
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

Global $CheckboxSwapRB = GUICtrlCreateCheckbox("Swap RB", 607, 114, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

Global $LabelFramework = GUICtrlCreateLabel("Framework", 765, 6, 84, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboFramework = GUICtrlCreateCombo("", 859, 6, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "auto|caffe|darknet|dldt|tensorflow|torch", "auto")

Global $LabelConfidence = GUICtrlCreateLabel("Confidence", 765, 40, 78, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderConfidence = GUICtrlCreateSlider(859, 40, 145, 25)
GUICtrlSetTip(-1, 'Class confidence threshold')
GUICtrlSetLimit(-1, 100, 1)
GUICtrlSetData(-1, 0.5 * 100)

Global $LabelScore = GUICtrlCreateLabel("Score", 765, 74, 78, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderScore = GUICtrlCreateSlider(859, 74, 145, 25)
GUICtrlSetTip(-1, 'Score threshold')
GUICtrlSetLimit(-1, 100, 1)
GUICtrlSetData(-1, 0.25 * 100)

Global $LabelNMS = GUICtrlCreateLabel("NMS", 765, 108, 78, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderNMS = GUICtrlCreateSlider(859, 108, 145, 25)
GUICtrlSetTip(-1, 'Non maxima suppresion')
GUICtrlSetLimit(-1, 100, 1)
GUICtrlSetData(-1, 0.4 * 100)

Global $LabelBackend = GUICtrlCreateLabel("Backend", 1030, 6, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboBackend = GUICtrlCreateCombo("", 1104, 6, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "Automatic|Halide language|OpenVINO|OpenCV|VKCOM|CUDA", "Automatic")

Global $LabelTarget = GUICtrlCreateLabel("Target", 1030, 40, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboTarget = GUICtrlCreateCombo("", 1104, 40, 145, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "CPU|OpenCL|OpenCL fp16|NCS2 VPU|HDDL VPU|Vulkan|CUDA|CUDA fp16", "CPU")

Global $LabelMean = GUICtrlCreateLabel("Mean", 1030, 74, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "scalar with mean values which are subtracted from channels")
Global $InputMean0 = GUICtrlCreateInput("0", 1104, 74, 35, 21)
Global $InputMean1 = GUICtrlCreateInput("0", 1149, 74, 35, 21)
Global $InputMean2 = GUICtrlCreateInput("0", 1194, 74, 35, 21)

Global $LabelScale = GUICtrlCreateLabel("Scale", 1030, 108, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "multiplier for image values")
Global $InputScale = GUICtrlCreateInput("1.0", 1104, 108, 95, 21)

Global $LabelThreads = GUICtrlCreateLabel("Threads", 1030, 142, 65, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "multiplier for image values")
Global $InputThreads = GUICtrlCreateInput($cv.getNumThreads(), 1104, 142, 25, 21)

Global $BtnStop = GUICtrlCreateButton("Stop", 1139, 141, 50, 23)
Global $BtnStart = GUICtrlCreateButton("Start", 1199, 141, 50, 23)

Global $BtnExec = GUICtrlCreateButton("Dectect Objects", 1104, 176, 95, 25)


Global $LabelSource = GUICtrlCreateLabel("Source Image", 271, 192, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 215, 610, 616)
Global $PicSource = GUICtrlCreatePic("", 25, 226, 600, 600)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Object detection", 863, 192, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 644, 215, 610, 616)
Global $PicResult = GUICtrlCreatePic("", 649, 226, 600, 600)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderConfidence, 1)
_GUICtrlSlider_SetTicFreq($SliderScore, 1)
_GUICtrlSlider_SetTicFreq($SliderNMS, 1)

Global $backends[] = [ _
		$CV_DNN_DNN_BACKEND_DEFAULT, _
		$CV_DNN_DNN_BACKEND_HALIDE, _
		$CV_DNN_DNN_BACKEND_INFERENCE_ENGINE, _
		$CV_DNN_DNN_BACKEND_OPENCV, _
		$CV_DNN_DNN_BACKEND_VKCOM, _
		$CV_DNN_DNN_BACKEND_CUDA _
		]

Global $targets[] = [ _
		$CV_DNN_DNN_TARGET_CPU, _
		$CV_DNN_DNN_TARGET_OPENCL, _
		$CV_DNN_DNN_TARGET_OPENCL_FP16, _
		$CV_DNN_DNN_TARGET_MYRIAD, _
		$CV_DNN_DNN_TARGET_HDDL, _
		$CV_DNN_DNN_TARGET_VULKAN, _
		$CV_DNN_DNN_TARGET_CUDA, _
		$CV_DNN_DNN_TARGET_CUDA_FP16 _
		]

Global $oFrameworks = _OpenCV_ObjCreate("MapOfStringAndVariant")
Global $aFrameworkList = _GUICtrlComboBox_GetListArray($ComboFramework)
For $i = 1 To $aFrameworkList[0]
	$oFrameworks($aFrameworkList[$i]) = $i - 1
Next

Global $sSource, $sModelNames, $sModelConfiguration, $sModelClassification

Global $sCameraList = ""
Global $useCamera = False
Global $cap = Null
Global $net = Null
Global $outNames[] = []
Global $running = True
Global $frameCounter = 0
Global $classes, $colors

UpdateZooModel()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sSource = ControlGetText($FormGUI, "", $InputSource)
			$sSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic;*.avi;*.mp4)", $FD_FILEMUSTEXIST, $sSource)
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
		Case $BtnModelClassification
			$sModelClassification = ControlGetText($FormGUI, "", $InputModelClassification)
			$sModelClassification = FileOpenDialog("Select a model weights", $OPENCV_SAMPLES_DATA_PATH, "Model weights (*.caffemodel;*.pb;*.t7;*.net;*.weights;*.bin;*.onnx)", $FD_FILEMUSTEXIST, $sModelClassification)
			If @error Then
				$sModelClassification = ""
			Else
				ControlSetText($FormGUI, "", $InputModelClassification, $sModelClassification)
			EndIf
		Case $BtnModelConfiguration
			$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)
			$sModelConfiguration = FileOpenDialog("Select a model configuration", $OPENCV_SAMPLES_DATA_PATH, "Model configuration (*.prototxt;*.pbtxt;*.cfg;*.xml)", $FD_FILEMUSTEXIST, $sModelConfiguration)
			If @error Then
				$sModelConfiguration = ""
			Else
				ControlSetText($FormGUI, "", $InputModelConfiguration, $sModelConfiguration)
			EndIf
		Case $InputThreads
			_GUICtrlReadNumber($InputThreads, True)
		Case $InputModelWidth
			_GUICtrlReadNumber($InputModelWidth, True)
		Case $InputModelHeight
			_GUICtrlReadNumber($InputModelHeight, True)
		Case $ComboZooModel
			UpdateZooModel()
		Case $CheckboxUseCamera
			UpdateCapture()
		Case $ComboCamera
			UpdateCapture()
		Case $CheckboxUseGDI
			UpdateUseGDI()
		Case $BtnStart
			$running = True
			$frameCounter = 0
		Case $BtnStop
			$running = False
		Case $BtnExec
			$running = True
			Main()
	EndSwitch

	If $running Then
		If $cap == Null Then
			Main()
			Sleep(1000) ; Sleep to reduce CPU usage
			ContinueLoop
		EndIf

		UpdateFrame()
	EndIf

	UpdateCameraList()

	; Sleep(10) ; Sleep to reduce CPU usage
WEnd

Func postprocess($frame, $inpWidth, $inpHeight, $imgScale, $outs)
	Local $class_ids = _OpenCV_ObjCreate("VectorOfInt")
	Local $scores = _OpenCV_ObjCreate("VectorOfFloat")
	Local $bboxes = _OpenCV_ObjCreate("VectorOfRect2d")

	Local $confidence_threshold = GUICtrlRead($SliderConfidence) / 100
	Local $score_threshold = GUICtrlRead($SliderScore) / 100
	Local $nms_threshold = GUICtrlRead($SliderNMS) / 100

	Local $aPicPos = ControlGetPos($FormGUI, "", $PicResult)
	$imgScale *= $frame.width > $frame.height ? $aPicPos[2] / $frame.width : $aPicPos[3] / $frame.height
	$frame = _OpenCV_resizeAndCenter($frame, _OpenCV_Params( _
			"width", $aPicPos[2], _
			"height", $aPicPos[3], _
			"center", False _
			))

	If Not _IsChecked($CheckboxUseCPP) Then
		; Slower
		_ConsoleTime()
		object_detection_postprocess( _
				$inpWidth, _
				$inpHeight, _
				$imgScale, _
				UBound($classes), _
				$outs, _
				$class_ids, _
				$scores, _
				$bboxes _
				)
		_ConsoleTime('AutoIt object_detection_postprocess')
	Else
		;;: [doing the loop in a compiled code is 150 times faster than doing it in autoit]
		_ConsoleTime()
		$outs = _OpenCV_ObjCreate("VectorOfMat").create($outs)
		_OpenCV_DllCall($addon_dll, "none:cdecl", "object_detection_postprocess", _
				"ptr", $net.self, _
				"int", $inpWidth, _
				"int", $inpHeight, _
				"float", $imgScale, _
				"ulong_ptr", UBound($classes), _
				"float", $confidence_threshold, _
				"float", $score_threshold, _
				"ptr", $outs.self, _
				"ptr", $class_ids.self, _
				"ptr", $scores.self, _
				"ptr", $bboxes.self _
				)
		_ConsoleTime('c++ object_detection_postprocess   ')
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf

	;; Perform non maximum suppression to eliminate redundant overlapping bounding boxes with lower scores.
	Local $indices = $cv.dnn.NMSBoxes($bboxes, $scores, $score_threshold, $nms_threshold)
	For $idx In $indices
		drawPred($frame, $class_ids.at($idx), $scores.at($idx), $bboxes.at($idx))
	Next

	; $cv.imshow("processed", $frame)
	_OpenCV_imshow_ControlPic($frame, $FormGUI, $PicResult)
EndFunc   ;==>postprocess

Func object_detection_postprocess($inpWidth, $inpHeight, $imgScale, $num_classes, $outs, $class_ids, $scores, $bboxes)
	Local $confidence_threshold = GUICtrlRead($SliderConfidence) / 100
	Local $score_threshold = GUICtrlRead($SliderScore) / 100

	Local $layerNames = $net.getLayerNames()
	Local $lastLayerId = $net.getLayerId($layerNames[UBound($layerNames) - 1])
	Local $lastLayer = $net.getLayer($lastLayerId)

	Local Const $UNSUPPORTED_YOLO_VERSION = "!>Error: Unsupported yolo version. Supported versions are v3, v5, v8."
	Local $offset, $scale_x, $scale_y

	Local $detection = $cv.Mat.create(1, 0, $CV_32F)
	Local $classes_scores = $cv.Mat.create(1, 0, $CV_32F)

	Local $out, $data, $steps, $step_row, $step_col
	Local $confidence, $maxScore, $maxClassLoc
	Local $center_x, $center_y
	Local $left, $top, $width, $height

	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : type                                ' & $lastLayer.type & @CRLF)

	If $lastLayer.type == "DetectionOutput" Then
		; Network produces output blob with a shape 1x1xNx7 where N is a number of
		; detections and an every detection is a vector of values
		; [batchId, classId, confidence, left, top, right, bottom]
		For $out In $outs
			$out = $out.reshape(1, $out.sizes[2])

			$data = Ptr($out.data)
			$steps = $out.steps
			$step_row = $steps[0]
			$step_col = $steps[1]

			$detection.cols = $out.cols

			For $j = 0 To $out.rows - 1
				; Slower
				; $detection = $out.row($j)

				; Slower
				; $detection.data = $out.ptr($j, 0)

				$detection.data = $data + $j * $step_row

				$confidence = $detection.at(2)
				If $confidence <= $confidence_threshold Then
					ContinueLoop
				EndIf

				If $detection.at(5) - $detection.at(3) < 1 Then
					; relative coordinates
					$scale_x = $inpWidth * $imgScale
					$scale_y = $inpHeight * $imgScale
				Else
					; absolute coordinate
					$scale_x = $imgScale
					$scale_y = $imgScale
				EndIf

				$left = $detection.at(3) * $scale_x
				$top = $detection.at(4) * $scale_y
				$width = $detection.at(5) * $scale_x - $left + 1
				$height = $detection.at(6) * $scale_y - $top + 1

				$class_ids.push_back($detection.at(1))
				$scores.push_back($confidence)
				$bboxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
			Next
		Next
	ElseIf $lastLayer.type == "Region" Then
		; relative coordinates
		$scale_x = $inpWidth * $imgScale
		$scale_y = $inpHeight * $imgScale

		; Network produces output blob with a shape NxC where N is a number of
		; detected objects and C is a number of classes + 4 where the first 4
		; numbers are [center_x, center_y, width, height]
		For $out In $outs
			$data = Ptr($out.data)
			$steps = $out.steps
			$step_row = $steps[0]
			$step_col = $steps[1]

			$detection.cols = $out.cols
			$classes_scores.cols = $out.cols - 5

			For $j = 0 To $out.rows - 1
				; Slower
				; $detection = $out.row($j)
				; $classes_scores = $detection.colRange(5, $out.cols)

				; Slower
				; $detection.data = $out.ptr($j, 0)
				; $classes_scores.data = $out.ptr($j, 5)

				$detection.data = $data + $j * $step_row

				$confidence = $detection.at(4)
				If $confidence <= $confidence_threshold Then
					ContinueLoop
				EndIf

				$classes_scores.data = Ptr($detection.data) + 5 * $step_col
				$cv.minMaxLoc($classes_scores)
				$maxScore = $cv.extended[1]
				$maxClassLoc = $cv.extended[3]

				If $maxScore <= $score_threshold Then
					ContinueLoop
				EndIf

				$center_x = $detection.at(0) * $scale_x
				$center_y = $detection.at(1) * $scale_y
				$width = $detection.at(2) * $scale_x
				$height = $detection.at(3) * $scale_y
				$left = $center_x - $width / 2
				$top = $center_y - $height / 2

				$class_ids.push_back($maxClassLoc[0])
				$scores.push_back($maxScore)
				$bboxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
			Next
		Next
	ElseIf $lastLayer.type == "Identity" Then
		For $out In $outs
			If $out.dims <> 2 And $out.dims <> 3 Then
				ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & ' out.dims != 2 && out.dims != 3' & @CRLF)
				Return
			EndIf

			If $out.dims == 2 Then
				If $out.cols == $num_classes + 5 Then
					;; yolo v3
					$offset = 5
				Else
					ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & @CRLF)
					Return
				EndIf

				; relative coordinates
				$scale_x = $inpWidth * $imgScale
				$scale_y = $inpHeight * $imgScale
			Else
				If $out.sizes[0] <> 1 Then
					ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & ' out.size[0] != 1' & @CRLF)
					Return
				EndIf

				$out = $out.reshape(1, $out.sizes[1])

				; absolute coordinate
				$scale_x = $imgScale
				$scale_y = $imgScale

				;; yolov5 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
				;; yolov8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
				If $out.rows == $num_classes + 4 Then
					;; yolo v8
					$offset = 4
					$out = $cv.transpose($out)
				ElseIf $out.cols == $num_classes + 5 Then
					;; yolo v5
					$offset = 5
				Else
					ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & @CRLF)
					Return
				EndIf
			EndIf

			$data = Ptr($out.data)
			$steps = $out.steps
			$step_row = $steps[0]
			$step_col = $steps[1]

			$detection.cols = $out.cols
			$classes_scores.cols = $out.cols - $offset

			For $j = 0 To $out.rows - 1
				; Slower
				; $detection = $out.row($j)
				; $classes_scores = $detection.colRange($offset, $out.cols)

				; Slower
				; $detection.data = $out.ptr($j, 0)
				; $classes_scores.data = $out.ptr($j, $offset)

				$detection.data = $data + $j * $step_row
				$classes_scores.data = Ptr($detection.data) + $offset * $step_col

				If $offset == 5 And $detection.at(4) < $confidence_threshold Then
					ContinueLoop
				EndIf

				$cv.minMaxLoc($classes_scores)
				$maxScore = $cv.extended[1]
				$maxClassLoc = $cv.extended[3]

				If $maxScore <= $score_threshold Then
					ContinueLoop
				EndIf

				$center_x = $detection.at(0) * $scale_x
				$center_y = $detection.at(1) * $scale_y
				$width = $detection.at(2) * $scale_x
				$height = $detection.at(3) * $scale_y
				$left = $center_x - $width / 2
				$top = $center_y - $height / 2

				$class_ids.push_back($maxClassLoc[0])
				$scores.push_back($maxScore)
				$bboxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
			Next
		Next
	Else
		ConsoleWriteError('!>Error: Unknown output layer type ' & $lastLayer.type & @CRLF)
	EndIf

EndFunc   ;==>object_detection_postprocess

Func drawPred($image, $class_id, $conf, $bbox)
	Local $thickness = 2
	Local $color = $colors.empty() ? _OpenCV_Scalar(0xFF, 0xB2, 0x32) : $colors.Vec3b_at($class_id)

	;; Draw a bounding box.
	$cv.rectangle($image, $bbox, $color, $thickness)

	;; Get the label for the class name and its confidence
	Local $label = StringFormat("%.3f", $conf)
	If UBound($classes) <> 0 Then
		$label = StringFormat("%s:%s", $classes[$class_id], $label)
	EndIf

	Local $left = $bbox[0] + $thickness
	Local $top = $bbox[1] + $thickness
	Local $fLabelBackgroundOpacity = 0x7F / 0xFF

	If $_cv_gdi_resize And $__g_hGDIPDll > 0 Then
		Local $LabelBrush = _GDIPlus_BrushCreateSolid(0xFF000000)
		Local $hLabelBackgroundBrush = _GDIPlus_BrushCreateSolid(BitOR(0x00FFFFFF, BitShift($fLabelBackgroundOpacity * 0xFF, -24))) ;color format AARRGGBB (hex)
		Local $hImage = $image.convertToBitmap(False)

		Local $hFormat = _GDIPlus_StringFormatCreate()
		Local $hFamily = _GDIPlus_FontFamilyCreate("Calibri")
		Local $hFont = _GDIPlus_FontCreate($hFamily, 12)

		Local $tLabelLayout = _GDIPlus_RectFCreate(0, 0, $image.width, $image.height)

		Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage)

		$tLabelLayout = _GDIPlus_GraphicsMeasureString($hGraphics, $label, $hFont, $tLabelLayout, $hFormat)
		$tLabelLayout = $tLabelLayout[0]
		$tLabelLayout.X = $left
		$tLabelLayout.Y = $top

		_GDIPlus_GraphicsSetSmoothingMode($hGraphics, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
		_GDIPlus_GraphicsFillRect($hGraphics, $left, $top, $tLabelLayout.Width, $tLabelLayout.Height, $hLabelBackgroundBrush)
		_GDIPlus_GraphicsDrawStringEx($hGraphics, $label, $hFont, $tLabelLayout, $hFormat, $LabelBrush)

		_GDIPlus_GraphicsDispose($hGraphics)

		_GDIPlus_FontDispose($hFont)
		_GDIPlus_FontFamilyDispose($hFamily)
		_GDIPlus_StringFormatDispose($hFormat)

		_GDIPlus_ImageDispose($hImage)
		_GDIPlus_BrushDispose($hLabelBackgroundBrush)
		_GDIPlus_BrushDispose($LabelBrush)
	Else
		Local $fontFace = $CV_FONT_HERSHEY_SIMPLEX
		Local $fontScale = 0.5
		Local $fontThickness = 1
		Local $labelSize = $cv.getTextSize($label, $fontFace, $fontScale, $fontThickness)
		Local $baseLine = $cv.extended[1]
		Local $width = $labelSize[0]
		Local $height = $labelSize[1] + $baseLine

		;; Draw a transparent label background

		If $fLabelBackgroundOpacity < 1 Then
			$left = _Max(0, $left - $thickness) + $thickness
			$top = _Max(0, $top - $thickness) + $thickness
			$width = _Min($left + $width, $image.width) - $left
			$height = _Min($top + $height, $image.height) - $top

			Local $aLabelBox = _OpenCV_Rect($left, $top, $width, $height)
			Local $oLabelRect = $cv.Mat.create($height, $width, $CV_8UC3, _OpenCV_Scalar(0xFF, 0xFF, 0xFF))
			Local $oLabelROI = $cv.Mat.create($image, $aLabelBox)

			$oLabelRect = $cv.addWeighted($oLabelRect, $fLabelBackgroundOpacity, $cv.Mat.create($image, $aLabelBox), 1 - $fLabelBackgroundOpacity, 0)
			$oLabelRect.copyTo($oLabelROI)
		Else
			$cv.rectangle( _
					$image, _
					_OpenCV_Rect($left, $top, $width, $height), _
					_OpenCV_Scalar(0xFF, 0xFF, 0xFF), _
					$CV_FILLED _
					)
		EndIf

		;; Display the label in the label background
		$cv.putText($image, $label, _OpenCV_Point($left, $top + $labelSize[1]), $fontFace, $fontScale, _OpenCV_Scalar(0, 0, 0), $fontThickness)
	EndIf
EndFunc   ;==>drawPred

Func Main()
	UpdateUseGDI()
	UpdateCapture()
	UpdateNet()
EndFunc   ;==>Main

Func UpdateUseGDI()
	$_cv_gdi_resize = _IsChecked($CheckboxUseGDI)
EndFunc   ;==>UpdateUseGDI

Func UpdateCapture()
	$useCamera = _IsChecked($CheckboxUseCamera)

	If $useCamera Then
		GUICtrlSetState($InputSource, $GUI_DISABLE)
		GUICtrlSetState($BtnSource, $GUI_DISABLE)
		GUICtrlSetState($ComboCamera, $GUI_ENABLE)
	Else
		GUICtrlSetState($InputSource, $GUI_ENABLE)
		GUICtrlSetState($BtnSource, $GUI_ENABLE)
		GUICtrlSetState($ComboCamera, $GUI_DISABLE)
	EndIf

	If $cap <> Null And $cap.isOpened() Then $cap.release()

	If $useCamera Then
		Local $iCamId = _Max(0, _GUICtrlComboBox_GetCurSel($ComboCamera))
		$cap = $cv.VideoCapture($iCamId)
	Else
		$sSource = ControlGetText($FormGUI, "", $InputSource)
		$cap = $cv.VideoCapture($sSource)
	EndIf

	If Not $cap.isOpened() Then
		ConsoleWriteError("!>Error: cannot open the " & ($useCamera ? "camera " & GUICtrlRead($ComboFramework) : "input file " & $sSource) & @CRLF)
		$cap = Null
	EndIf

	$frameCounter = 0
EndFunc   ;==>UpdateCapture

Func UpdateNet()
	$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)
	$sModelClassification = ControlGetText($FormGUI, "", $InputModelClassification)
	Local $sFramework = GUICtrlRead($ComboFramework)

	; Load names of classes
	$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
	$classes = $sModelNames <> "" ? FileReadToArray($sModelNames) : _OpenCV_Tuple()
	If @error Then
		ConsoleWriteError("!>Error: Unable to read model names " & $sModelNames & @CRLF)
		Return
	EndIf

	; Generate colors
	$colors = $cv.Mat.zeros(1, UBound($classes), $CV_8UC3)
	If UBound($classes) <> 0 Then $cv.randu($colors, 0.0, 255.0)

	; Load a network
	_ConsoleTime()
	$net = $cv.dnn.readNet($sModelClassification, $sModelConfiguration, $sFramework == "auto" ? "" : $sFramework)
	_ConsoleTime('$cv.dnn.readNet                    ')

	$net.setPreferableBackend($backends[_GUICtrlComboBox_GetCurSel($ComboBackend)])
	$net.setPreferableTarget($targets[_GUICtrlComboBox_GetCurSel($ComboTarget)])
	$outNames = $net.getUnconnectedOutLayersNames()
EndFunc   ;==>UpdateNet

Func UpdateFrame()
	Local Static $tickInit = 0
	Local Static $inputFPS
	Local Static $futureOutputs = _OpenCV_ObjCreate("VectorOfVariant")

	If $cap == Null Then
		Return
	EndIf

	Local Static $frame = $cv.Mat.create()
	$frame.setTo(0.0)

	If Not $cap.read($frame) Then
		$cap.release()
		$cap = Null
		$running = False
		Return
	EndIf

	; flip to gve the mirror impression
	If $useCamera Then $cv.flip($frame, 1, $frame)

	Local $elapsed = 0

	If $frameCounter == 0 Then
		$futureOutputs.clear()

		$inputFPS = $cap.get($CV_CAP_PROP_FPS)
		If $inputFPS == 0 Then
			$inputFPS = 30
			$cap.set($CV_CAP_PROP_FPS, $inputFPS)
		EndIf

		$tickInit = $cv.getTickCount()
	Else
		$elapsed = ($cv.getTickCount() - $tickInit) / $cv.getTickFrequency()

		Local $expected = $inputFPS * $elapsed
		If $expected < $frameCounter Then
			Sleep(1000 * ($frameCounter - $expected) / $inputFPS)
		EndIf
	EndIf

	Local $img_displayed = $frame.clone()
	Local Const $aPicPos = ControlGetPos($FormGUI, "", $PicSource)
	Local $scale = $img_displayed.width > $img_displayed.height ? $img_displayed.width / $aPicPos[2] : $img_displayed.height / $aPicPos[3]
	If $scale < 1 Then $scale = 1

	If $frameCounter <> 0 Then
		$elapsed = ($cv.getTickCount() - $tickInit) / $cv.getTickFrequency()
		Local Const $decimals = 2
		Local Const $fps = Round($frameCounter / $elapsed, $decimals)

		Local $text = StringFormat("FPS : %." & $decimals & "f / %." & $decimals & "f", $fps, $inputFPS)
		Local $org = _OpenCV_Point(10 * $scale, 30 * $scale)
		Local $fontScale = 2 * $scale
		Local $color = _OpenCV_Scalar(255, 0, 255)
		Local $thickness = 2 * $scale
		$cv.putText($img_displayed, $text, $org, $CV_FONT_HERSHEY_PLAIN, $fontScale, $color, $thickness)
	EndIf

	; $img_displayed = _OpenCV_resizeAndCenter($img_displayed, _OpenCV_Params( _
	; 		"width", $aPicPos[2], _
	; 		"height", $aPicPos[3], _
	; 		"center", False _
	; 		))
	; $cv.imshow("image", $img_displayed)
	_OpenCV_imshow_ControlPic($img_displayed, $FormGUI, $PicSource)

	ProcessFrame($futureOutputs, $frame)

	$frameCounter += 1
EndFunc   ;==>UpdateFrame

Func ProcessFrame($futureOutputs, $frame)
	Local $iThreads = _GUICtrlReadNumber($InputThreads)
	If $iThreads <> 0 And $iThreads == $futureOutputs.size() Then
		; Skip the frame
		Return
	EndIf

	Local $inpWidth = _GUICtrlReadNumber($InputModelWidth, False, $frame.width)
	Local $inpHeight = _GUICtrlReadNumber($InputModelHeight, False, $frame.height)

	;; The model expects images of size [ $inpWidth x $inpHeight ]
	;; Performing a high quality shrinking, instead of the provided one in blobFromImage
	;; improves detection
	Local $image = _OpenCV_resizeAndCenter($frame, _OpenCV_Params( _
			"width", $inpWidth, _
			"height", $inpHeight, _
			"enlarge", True, _
			"center", False _
			))

	Local $imgScale = $frame.width / $image.width

	;; Fill missing pixels with 0
	Local $padWidth = $inpWidth - $image.width
	Local $padHeight = $inpHeight - $image.height
	If $padWidth > 0 Or $padHeight > 0 Then
		Local $padded = $cv.Mat.zeros($inpHeight, $inpWidth, CV_MAKETYPE($image.depth(), $image.channels()))
		Local $roi = $cv.Mat.create($padded, _OpenCV_Rect(0, 0, $image.width, $image.height))
		$image.copyTo($roi)
		$image = $padded
	EndIf

	Local $scalefactor = Number(GUICtrlRead($InputScale))
	Local $mean = _OpenCV_Scalar( _
			Number(GUICtrlRead($InputMean0)), _
			Number(GUICtrlRead($InputMean1)), _
			Number(GUICtrlRead($InputMean2)) _
			)

	; Create a 4D blob from a frame.
	Local $blob = $cv.dnn.blobFromImage($image, _OpenCV_Params( _
			"size", _OpenCV_Size($inpWidth, $inpHeight), _
			"swapRB", _IsChecked($CheckboxSwapRB), _
			"ddepth", $CV_8U _
			))

	; Run a model
	$net.setInput($blob, _OpenCV_Params( _
			"scalefactor", $scalefactor, _
			"mean", $mean _
			))

	If $net.getLayer(0).outputNameToIndex('im_info') <> -1 Then  ; Faster-RCNN or R-FCN
		Local $data[][] = [[$inpHeight, $inpWidth, 1.6]]
		$net.setInput($cv.Mat.createFromArray($data, $CV_32F), 'im_info')
	EndIf

	Local $outs

	If $iThreads > 0 And $backends[_GUICtrlComboBox_GetCurSel($ComboBackend)] == $CV_DNN_DNN_BACKEND_INFERENCE_ENGINE Then
		$futureOutputs.append(_OpenCV_Tuple($net.forwardAsync(), $frame, $inpWidth, $inpHeight, $imgScale))
	Else
		_ConsoleTime()
		$outs = $net.forward($outNames)
		_ConsoleTime('forward                            ')
		postprocess($frame, $inpWidth, $inpHeight, $imgScale, $outs)
	EndIf

	Local $futureArgs
	$outs = _OpenCV_Tuple(Null)
	While (Not $futureOutputs.empty()) And ($futureOutputs[0])[0].wait_for(0)
		$futureArgs = $futureOutputs[0]
		$futureOutputs.Remove(0)

		$outs[0] = $futureArgs[0].get()
		postprocess($futureArgs[1], $futureArgs[2], $futureArgs[3], $futureArgs[4], $outs)
	WEnd
EndFunc   ;==>ProcessFrame

Func UpdateZooModel()
	Local $fs = $cv.FileStorage($cv.samples.findFile("models.yml"), $CV_FILE_STORAGE_READ)
	Local $models = $fs.root().asVariant()
	Local $name = GUICtrlRead($ComboZooModel)
	If Not $models.has($name) Then Return

	Local $aSearchPaths[] = [ _
			".", _
			"models", _
			"opencv\sources\samples\dnn", _
			"opencv\sources\samples\data\dnn", _
			"opencv-4.7.0-*\sources\samples\dnn", _
			"opencv-4.7.0-*\sources\samples\data\dnn", _
			"opencv-4.7.0-*\opencv\sources\samples\dnn", _
			"opencv-4.7.0-*\opencv\sources\samples\data\dnn" _
			]

	Local $info = $models($name)

	Local $model = _OpenCV_FindFile($info("model"), Default, Default, $FLTA_FILES, $aSearchPaths)
	Local $names = ($info.has("classes") And $info("classes") <> "") ? _OpenCV_FindFile($info("classes"), Default, Default, $FLTA_FILES, $aSearchPaths) : ""
	Local $config = ($info.has("config") And $info("config") <> "") ? _OpenCV_FindFile($info("config"), Default, Default, $FLTA_FILES, $aSearchPaths) : ""

	If $model == "" Or ($config == "" And $info.has("config")) Then
		Local $sZoo = @ScriptDir & "\models.yml"
		Local $sDestination = @ScriptDir & "\models"
		Local $cmd = "-ExecutionPolicy UnRestricted -File " & '"' & @ScriptDir & '\download_model.ps1" -Model ' & $name & ' -Zoo "' & $sZoo & '" -Destination "' & $sDestination & '"'
		ConsoleWrite("powershell.exe " & $cmd & @CRLF)
		Local $iPID = ShellExecute("powershell.exe", $cmd)
		ProcessWaitClose($iPID)
		$model = _OpenCV_FindFile($info("model"), Default, Default, $FLTA_FILES, $aSearchPaths)
		$config = $info.has("config") ? _OpenCV_FindFile($info("config"), Default, Default, $FLTA_FILES, $aSearchPaths) : ""
	EndIf

	Local $swapRB = $info.has("rgb") And $info("rgb") == "true"
	Local $framework = $info.has("framework") ? $info("framework") : ""
	Local $mean = $info.has("mean") ? $info("mean") : _OpenCV_Scalar()

	ControlSetText($FormGUI, "", $InputModelClassification, $model)
	ControlSetText($FormGUI, "", $InputModelNames, $names)
	ControlSetText($FormGUI, "", $InputModelConfiguration, $config)
	ControlSetText($FormGUI, "", $InputModelWidth, $info("width"))
	ControlSetText($FormGUI, "", $InputModelHeight, $info("height"))
	_GUICtrlComboBox_SetCurSel($ComboFramework, $oFrameworks.has($framework) ? $oFrameworks($framework) : 0)
	ControlSetText($FormGUI, "", $InputMean0, $mean[0])
	ControlSetText($FormGUI, "", $InputMean1, $mean[1])
	ControlSetText($FormGUI, "", $InputMean2, $mean[2])
	ControlSetText($FormGUI, "", $InputScale, $info("scale"))
	GUICtrlSetState($CheckboxSwapRB, $swapRB ? $GUI_CHECKED : $GUI_UNCHECKED)

	$running = True
	Main()
EndFunc   ;==>UpdateZooModel

Func UpdateCameraList()
	Local $sCamera = GUICtrlRead($ComboCamera)
	Local $sLongestString = ""
	Local $sOldCameraList = $sCameraList
	$sCameraList = ""

	Local $devices = _OpenCV_GetDevices()
	For $device In $devices
		$sCameraList &= "|" & $device

		If StringLen($sLongestString) < StringLen($device) Then
			$sLongestString = $device
		EndIf
	Next

	If StringLen($sCameraList) <> 0 Then
		$sCameraList = StringRight($sCameraList, StringLen($sCameraList) - 1)
	EndIf

	If StringCompare($sOldCameraList, $sCameraList, $STR_CASESENSE) == 0 Then Return

	_GUICtrlComboBox_ResetContent($ComboCamera)
	GUICtrlSetData($ComboCamera, $sCameraList)

	Local $avSize_Info = _StringSize($sLongestString)
	Local $aPos = ControlGetPos($FormGUI, "", $ComboCamera)
	GUICtrlSetPos($ComboCamera, $aPos[0], $aPos[1], _Max(145, $avSize_Info[2] + 20))

	If _GUICtrlComboBox_SelectString($ComboCamera, $sCamera) == -1 Then
		_GUICtrlComboBox_SetCurSel($ComboCamera, 0)
	EndIf
EndFunc   ;==>UpdateCameraList

; #FUNCTION# =======================================================================================
;
; Name...........: _StringSize
; Description ...: Returns size of rectangle required to display string - width can be chosen
; Syntax ........: _StringSize($sText[, $iSize[, $iWeight[, $iAttrib[, $sName[, $iWidth]]]]])
; Parameters ....: $sText   - String to display
;                 $iSize   - Font size in points - default AutoIt GUI default
;                 $iWeight - Font weight (400 = normal) - default AutoIt GUI default
;                 $iAttrib - Font attribute (0-Normal, 2-Italic, 4-Underline, 8 Strike - default AutoIt
;                 $sName   - Font name - default AutoIt GUI default
;                 $iWidth  - [optional] Width of rectangle - default is unwrapped width of string
; Requirement(s) : v3.2.12.1 or higher
; Return values .: Success - Returns array with details of rectangle required for text:
;                 |$array[0] = String formatted with @CRLF at required wrap points
;                 |$array[1] = Height of single line in selected font
;                 |$array[2] = Width of rectangle required to hold formatted string
;                 |$array[3] = Height of rectangle required to hold formatted string
;                 Failure - Returns 0 and sets @error:
;                 |1 - Incorrect parameter type (@extended = parameter index)
;                 |2 - Failure to create GUI to test label size
;                 |3 - Failure of _WinAPI_SelectObject
;                 |4 - Font too large for chosen width - longest word will not fit
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
;===================================================================================================
Func _StringSize($sText, $iSize = Default, $iWeight = Default, $iAttrib = Default, $sName = Default, $iWidth = 0)
	Local $hWnd, $hFont, $hDC, $oFont, $tSize, $hGUI, $hText_Label, $sTest_Line
	Local $iLine_Count, $iLine_Width, $iWrap_Count, $iLast_Word
	Local $asLines[1], $avSize_Info[4], $aiPos[4]
	If Not IsString($sText) Then Return SetError(1, 1, 0)
	If Not IsNumber($iSize) And $iSize <> Default Then Return SetError(1, 2, 0)
	If Not IsInt($iWeight) And $iWeight <> Default Then Return SetError(1, 3, 0)
	If Not IsInt($iAttrib) And $iAttrib <> Default Then Return SetError(1, 4, 0)
	If Not IsString($sName) And $sName <> Default Then Return SetError(1, 5, 0)
	If Not IsNumber($iWidth) Then Return SetError(1, 6, 0)
	$hGUI = GUICreate("", 1200, 500, 10, 10)
	If $hGUI = 0 Then Return SetError(2, 0, 0)
	GUISetFont($iSize, $iWeight, $iAttrib, $sName)
	$avSize_Info[0] = $sText
	If StringInStr($sText, @CRLF) = 0 Then StringRegExpReplace($sText, "[x0a|x0d]", @CRLF)
	$asLines = StringSplit($sText, @CRLF, 1)
	$hText_Label = GUICtrlCreateLabel($sText, 10, 10)
	$aiPos = ControlGetPos($hGUI, "", $hText_Label)
	GUICtrlDelete($hText_Label)
	$avSize_Info[1] = ($aiPos[3] - 8) / $asLines[0]
	$avSize_Info[2] = $aiPos[2]
	$avSize_Info[3] = $aiPos[3] - 4
	If $aiPos[2] > $iWidth And $iWidth > 0 Then
		$avSize_Info[0] = ""
		$avSize_Info[2] = $iWidth
		$iLine_Count = 0
		For $j = 1 To $asLines[0]
			$hText_Label = GUICtrlCreateLabel($asLines[$j], 10, 10)
			$aiPos = ControlGetPos($hGUI, "", $hText_Label)
			GUICtrlDelete($hText_Label)
			If $aiPos[2] < $iWidth Then
				$iLine_Count += 1
				$avSize_Info[0] &= $asLines[$j] & @CRLF
			Else
				$hText_Label = GUICtrlCreateLabel("", 0, 0)
				$hWnd = ControlGetHandle($hGUI, "", $hText_Label)
				$hFont = _SendMessage($hWnd, $WM_GETFONT)
				$hDC = _WinAPI_GetDC($hWnd)
				$oFont = _WinAPI_SelectObject($hDC, $hFont)
				If $oFont = 0 Then Return SetError(3, 0, 0)
				$iWrap_Count = 0
				While 1
					$iLine_Width = 0
					$iLast_Word = 0
					For $i = 1 To StringLen($asLines[$j])
						If StringMid($asLines[$j], $i, 1) = " " Then $iLast_Word = $i - 1
						$sTest_Line = StringMid($asLines[$j], 1, $i)
						GUICtrlSetData($hText_Label, $sTest_Line)
						$tSize = _WinAPI_GetTextExtentPoint32($hDC, $sTest_Line)
						$iLine_Width = DllStructGetData($tSize, "X")
						If $iLine_Width >= $iWidth - Int($iSize / 2) Then ExitLoop
					Next
					If $i > StringLen($asLines[$j]) Then
						$iWrap_Count += 1
						$avSize_Info[0] &= $sTest_Line & @CRLF
						ExitLoop
					Else
						$iWrap_Count += 1
						If $iLast_Word = 0 Then
							GUIDelete($hGUI)
							Return SetError(4, 0, 0)
						EndIf
						$avSize_Info[0] &= StringLeft($sTest_Line, $iLast_Word) & @CRLF
						$asLines[$j] = StringTrimLeft($asLines[$j], $iLast_Word)
						$asLines[$j] = StringStripWS($asLines[$j], 1)
					EndIf
				WEnd
				$iLine_Count += $iWrap_Count
				_WinAPI_ReleaseDC($hWnd, $hDC)
				GUICtrlDelete($hText_Label)
			EndIf
		Next
		$avSize_Info[3] = ($iLine_Count * $avSize_Info[1]) + 4
	EndIf
	GUIDelete($hGUI)
	Return $avSize_Info
EndFunc   ;==>_StringSize

Func _GUICtrlReadNumber($idControlID, $bSetData = False, $iDefault = 0)
	Local $sValue = GUICtrlRead($idControlID)
	Local $nNumber = Number($sValue, $NUMBER_32BIT)
	If $nNumber <= 0 Then $nNumber = $iDefault
	If $bSetData And $sValue <> String($nNumber) Then
		GUICtrlSetData($idControlID, $nNumber)
	EndIf
	Return $nNumber
EndFunc   ;==>_GUICtrlReadNumber

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _ConsoleTime($sMessage = Default, $iLine = @ScriptLineNumber)
	Local Static $hTimer
	If $sMessage == Default Then
		$hTimer = TimerInit()
	ElseIf $frameCounter == 0 Then
		ConsoleWrite('@@ Debug(' & $iLine & ') : ' & $sMessage & ' ' & TimerDiff($hTimer) & ' ms' & @CRLF)
	EndIf
EndFunc   ;==>_ConsoleTime

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
