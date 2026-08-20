# PYTHONPATH="$(realpath opencv-5.0.0-windows/opencv/sources/samples/dnn)" samples/.venv/Scripts/python.exe samples/dnn/object_detection/object_detection.py ssd_tf --input vtest.avi

import argparse
import math
import subprocess
import sys
import copy
import time
from threading import Thread

import numpy as np

if sys.version_info[0] == 2:
    import Queue as queue
else:
    import queue

from common import *
from tf_text_graph_common import readTextMessage
from tf_text_graph_ssd import createSSDGraph
from tf_text_graph_faster_rcnn import createFasterRCNNGraph

def help():
    print(
        '''
        Firstly, download required models using `download_models.py` (if not already done). Set environment variable OPENCV_DOWNLOAD_CACHE_DIR to specify where models should be downloaded. Also, point OPENCV_SAMPLES_DATA_PATH to opencv/samples/data.\n"\n

        To run:
            python object_detection.py model_name(e.g yolov8) --input=path/to/your/input/image/or/video (don't pass --input to use device camera)

        Sample command:
            python object_detection.py yolov8 --input=path/to/image
        Model path can also be specified using --model argument
        '''
    )

backends = ("default", "openvino", "opencv", "vkcom", "cuda")
targets = ("cpu", "opencl", "opencl_fp16", "ncs2_vpu", "hddl_vpu", "vulkan", "cuda", "cuda_fp16")

parser = argparse.ArgumentParser(add_help=False)
parser.add_argument('--zoo', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'models.yml'),
                    help='An optional path to file with preprocessing parameters.')
parser.add_argument('--input', help='Path to input image or video file. Skip this argument to capture frames from a camera.')
parser.add_argument('--out_tf_graph', default='graph.pbtxt',
                    help='For models from TensorFlow Object Detection API, you may '
                         'pass a .config file which was used for training through --config '
                         'argument. This way an additional .pbtxt file with TensorFlow graph will be created.')
parser.add_argument('--thr', type=float, default=0.5, help='Confidence threshold')
parser.add_argument('--nms', type=float, default=0.4, help='Non-maximum suppression threshold')
parser.add_argument('--backend', default="default", type=str, choices=backends,
                    help="Choose one of computation backends: "
                    "default: automatically (by default), "
                    "openvino: Intel's Deep Learning Inference Engine (https://software.intel.com/openvino-toolkit), "
                    "opencv: OpenCV implementation, "
                    "vkcom: VKCOM, "
                    "cuda: CUDA, "
                    "webnn: WebNN")
parser.add_argument('--target', default="cpu", type=str, choices=targets,
                    help="Choose one of target computation devices: "
                    "cpu: CPU target (by default), "
                    "opencl: OpenCL, "
                    "opencl_fp16: OpenCL fp16 (half-float precision), "
                    "ncs2_vpu: NCS2 VPU, "
                    "hddl_vpu: HDDL VPU, "
                    "vulkan: Vulkan, "
                    "cuda: CUDA, "
                    "cuda_fp16: CUDA fp16 (half-float preprocess)")
parser.add_argument('--async', type=int, default=0,
                    dest='use_threads',
                    help='Choose 0 for synchronous mode and 1 for asynchronous mode')
parser.add_argument('--fps', type=int, default=0, help='Input frames per second')
parser.add_argument('-H', '--dheight', type=int, default=0, help='Displayed height')
parser.add_argument('-W', '--dwidth', type=int, default=0, help='Displayed width')
args, _ = parser.parse_known_args()

# add hack to force argument add when the command line is empty
remove_alias = False
if len(sys.argv) <= 1:
    remove_alias = True
    sys.argv.append("--invalid")

add_preproc_args(args.zoo, parser, 'object_detection')

# remove hack to force argument add when the command line is empty
if remove_alias:
    sys.argv.pop()

parser = argparse.ArgumentParser(parents=[parser],
                                 description='Use this script to run object detection deep learning networks using OpenCV.',
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

args = parser.parse_args()

if args.alias is None or hasattr(args, 'help'):
    help()
    exit(1)

__dirname__ = os.path.dirname(os.path.abspath(__file__))
MODELS_PATH = os.getenv('MODELS_PATH') or os.path.join(__dirname__, 'models')

if not os.path.exists(MODELS_PATH):
    os.mkdir(MODELS_PATH)

if len(sys.argv) > 1:
    subprocess.run([
        sys.executable or 'python',
        os.path.join(__dirname__, 'download_model.py'),
        sys.argv[1],
        '--zoo',
        args.zoo
    ], cwd=MODELS_PATH)

cv.samples.addSamplesDataSearchPath(os.path.abspath(os.path.join(__dirname__, '../../../opencv-5.0.0-windows/opencv/sources/samples/data')))
cv.samples.addSamplesDataSearchPath(os.path.abspath(os.path.join(__dirname__, '../../../opencv-5.0.0-windows/opencv/sources/samples/data/dnn')))
cv.samples.addSamplesDataSearchPath(MODELS_PATH)
cv.samples.addSamplesDataSearchPath(__dirname__)

cv.utils.logging.setLogLevel(cv.utils.logging.LOG_LEVEL_INFO)
args.model = findModel(args.model, args.sha1)
if args.config is not None:
    args.config = findModel(args.config, args.config_sha1)
if args.labels is not None:
    args.labels = findFile(args.labels)

# If config specified, try to load it as TensorFlow Object Detection API's pipeline.
config = readTextMessage(args.config)
if 'model' in config:
    print('TensorFlow Object Detection API config detected')
    if 'ssd' in config['model'][0]:
        print('Preparing text graph representation for SSD model: ' + args.out_tf_graph)
        createSSDGraph(args.model, args.config, args.out_tf_graph)
        args.config = args.out_tf_graph
    elif 'faster_rcnn' in config['model'][0]:
        print('Preparing text graph representation for Faster-RCNN model: ' + args.out_tf_graph)
        createFasterRCNNGraph(args.model, args.config, args.out_tf_graph)
        args.config = args.out_tf_graph


# Load names of classes
labels = None
if args.labels:
    with open(args.labels, 'rt') as f:
        labels = f.read().rstrip('\n').split('\n')

# Load a network
engine = cv.dnn.ENGINE_AUTO
if args.backend != "default" or args.target != "cpu":
    engine = cv.dnn.ENGINE_CLASSIC
net = cv.dnn.readNet(args.model, args.config, "", engine)
net.setPreferableBackend(get_backend_id(args.backend))
net.setPreferableTarget(get_target_id(args.target))
if hasattr(cv.dnn, 'DNN_PROFILE_SUMMARY'):
    net.setProfilingMode(cv.dnn.DNN_PROFILE_SUMMARY)
outNames = net.getUnconnectedOutLayersNames()

confThreshold = args.thr
nmsThreshold = args.nms
stdSize = 0.8
stdWeight = 2
stdImgSize = 512
asyncN = 0

def get_color(class_id):
    r = min((class_id >> 0 & 1) * 128 + (class_id >> 3 & 1) * 64 + (class_id >> 6 & 1) * 32 + 80, 255)
    g = min((class_id >> 1 & 1) * 128 + (class_id >> 4 & 1) * 64 + (class_id >> 7 & 1) * 32 + 40, 255)
    b = min((class_id >> 2 & 1) * 128 + (class_id >> 5 & 1) * 64 + (class_id >> 8 & 1) * 32 + 40, 255)
    return (int(b), int(g), int(r))

def get_text_color(bg_color):
    luminance = 0.299 * bg_color[2] + 0.587 * bg_color[1] + 0.114 * bg_color[0]
    return (0, 0, 0) if luminance > 128 else (255, 255, 255)

UNSUPPORTED_YOLO_VERSION = 'Unsupported yolo version. Supported versions are v3, v4, v5, v6, v7, v8.'

DESIRED_HEIGHT = args.dheight
DESIRED_WIDTH = args.dwidth


def resize_and_show(title, image):
    h, w = image.shape[:2]

    if h < w:
        h = math.floor(h / (w / DESIRED_WIDTH))
        w = DESIRED_WIDTH
    else:
        w = math.floor(w / (h / DESIRED_HEIGHT))
        h = DESIRED_HEIGHT

    height, width = image.shape[:2]
    interpolation = cv.INTER_CUBIC if DESIRED_WIDTH > width or DESIRED_HEIGHT > height else cv.INTER_AREA
    img = cv.resize(image.astype(np.uint8), (w, h), interpolation=interpolation)
    cv.imshow(title, img)
    return img.shape[0] / image.shape[0]


def drawPred(frame, classIds, confidences, boxes, indices, fontSize, fontThickness):
    for i in indices:
        box = boxes[i]
        left = box[0]
        top = box[1]
        right = left + box[2]
        bottom = top + box[3]

        bg_color = get_color(classIds[i])

        # Draw a bounding box.
        cv.rectangle(frame, (left, top), (right, bottom), bg_color, fontThickness)

        label = '%.2f' % confidences[i]

        # Print a label of class.
        if labels:
            assert(classIds[i] < len(labels))
            label = '%s: %s' % (labels[classIds[i]], label)

        labelSize, baseLine = cv.getTextSize(label, cv.FONT_HERSHEY_SIMPLEX, fontSize, fontThickness)
        top = max(top, labelSize[1])
        cv.rectangle(frame, (int(left - fontThickness / 2), top - labelSize[1]), (left + labelSize[0], top + baseLine), bg_color, cv.FILLED)
        cv.putText(frame, label, (left, top - fontThickness), cv.FONT_HERSHEY_SIMPLEX, fontSize, get_text_color(bg_color), fontThickness)


def postprocess_yolo(box_scale_w, box_scale_h, out, classIds, confidences, boxes):
    for detection in out:
        if args.postprocessing == 'yolov8':
            scores = detection[4:]
            obj_conf = 1
        else:
            scores = detection[5:]
            obj_conf = detection[4]

        classId = np.argmax(scores)
        confidence = scores[classId] * obj_conf
        if confidence <= confThreshold:
            continue

        center_x = detection[0] * box_scale_w
        center_y = detection[1] * box_scale_h
        width = int(detection[2] * box_scale_w)
        height = int(detection[3] * box_scale_h)
        left = int(center_x - width / 2)
        top = int(center_y - height / 2)

        classIds.append(classId)
        confidences.append(float(confidence))
        boxes.append([left, top, width, height])


def postprocess(frame, imgScale, inpWidth, inpHeight, outs):
    startTime = time.time()

    classIds = []
    confidences = []
    boxes = []

    if args.postprocessing == 'ssd':
        # Network produces output blob with a shape 1x1xNx7 where N is a number of
        # detections and an every detection is a vector of values
        # [batchId, classId, confidence, left, top, right, bottom]
        for out in outs:
            for detection in out[0, 0]:
                if detection[5] - detection[3] < 1:
                    # relative coordinates
                    box_scale_w = inpWidth * imgScale
                    box_scale_h = inpHeight * imgScale
                else:
                    # absolute coordinate
                    box_scale_w = imgScale
                    box_scale_h = imgScale

                confidence = detection[2]
                if confidence <= confThreshold:
                    continue

                left = int(detection[3] * box_scale_w)
                top = int(detection[4] * box_scale_h)
                width = int(detection[5] * box_scale_w - left + 1)
                height = int(detection[6] * box_scale_h - top + 1)

                classIds.append(int(detection[1] - 1 if 0 <= args.background_label_id <= detection[1] else detection[1]))  # Skip background label
                confidences.append(float(confidence))
                boxes.append([left, top, width, height])
    elif args.postprocessing in ('yolov4', 'yolov3'):
        # boxes[b,N,1,4]+confs[b,N,classes] (normalized) or boxes[b,N,4]+scores[b,N]+classIdx[b,N] (model-px)
        if len(outs) == 3 and outs[0].ndim == 3 and outs[0].shape[2] == 4:
            # absolute coordinate
            box_scale_w = imgScale
            box_scale_h = imgScale

            boxesIndex = 0
            scoresIndex = 1
            classIdxIndex = 2

            for i in range(len(outNames)):
                outName = outNames[i]
                if outName == "boxes":
                    boxesIndex = i
                elif outName == "scores":
                    scoresIndex = i
                elif outName == "class_idx":
                    classIdxIndex = i
                else:
                    print('Unsupported outLayerName: ' + outName)
                    exit(1)

            boxesArr = outs[boxesIndex][0]
            scoresArr = outs[scoresIndex][0]
            classIdxArr = outs[classIdxIndex][0]
            for j in range(boxesArr.shape[0]):
                score = float(scoresArr[j])
                if score > confThreshold:
                    x1 = boxesArr[j][0] * box_scale_w
                    y1 = boxesArr[j][1] * box_scale_h
                    x2 = boxesArr[j][2] * box_scale_w
                    y2 = boxesArr[j][3] * box_scale_h
                    left = int(x1)
                    top = int(y1)
                    width = int(x2 - x1)
                    height = int(y2 - y1)
                    classIds.append(int(classIdxArr[j]))
                    confidences.append(score)
                    boxes.append([left, top, width, height])
        elif len(outs) == 2 and outs[0].ndim == 4 and outs[0].shape[-1] == 4:
            # relative coordinates
            box_scale_w = inpWidth * imgScale
            box_scale_h = inpHeight * imgScale

            boxesArr = outs[0].reshape(-1, 4)
            confsArr = outs[1].reshape(boxesArr.shape[0], -1)
            for j in range(boxesArr.shape[0]):
                classId = np.argmax(confsArr[j])
                confidence = float(confsArr[j][classId])
                if confidence > confThreshold:
                    box = boxesArr[j]
                    left = int(box[0] * box_scale_w)
                    top = int(box[1] * box_scale_h)
                    width = int((box[2] - box[0]) * box_scale_w)
                    height = int((box[3] - box[1]) * box_scale_h)
                    classIds.append(classId)
                    confidences.append(confidence)
                    boxes.append([left, top, width, height])
        else:
            print('Unsupported YOLO ONNX output format')
            exit(1)
    elif args.postprocessing in ('yolov8', 'yolov7', 'yolov6', 'yolov5'):
        for out in outs:
            if len(out.shape) != 3:
                print(UNSUPPORTED_YOLO_VERSION + " len(out.shape) != 3")
                exit(1)

            if out.shape[0] != 1:
                print(UNSUPPORTED_YOLO_VERSION + " out.shape[0] != 1")
                exit(1)

            out = out[0]

            # absolute coordinate
            box_scale_w = imgScale
            box_scale_h = imgScale

            if (out.shape[1] == len(labels) + 5):
                # yolo v5, v6, v7 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
                pass
            elif out.shape[0] == len(labels) + 4:
                # yolo v8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
                out = out.transpose(1, 0)
            else:
                print(UNSUPPORTED_YOLO_VERSION + " out.shape[0] != len(labels) + 4 && out.shape[1] != len(labels) + 5")
                exit(1)

            postprocess_yolo(box_scale_w, box_scale_h, out, classIds, confidences, boxes)
    else:
        print('Unknown postprocessing method: ' + args.postprocessing)
        exit(1)

    if predictionsQueue.counter == 1:
        print(f'postprocess : {time.time() - startTime} s')

    # Perform non maximum suppression to eliminate redundant overlapping bounding boxes with lower confidences.
    indices = cv.dnn.NMSBoxes(boxes, confidences, confThreshold, nmsThreshold)

    return boxes, classIds, confidences, indices


# Process inputs
winName = 'Deep learning object detection in OpenCV'
cv.namedWindow(winName, cv.WINDOW_AUTOSIZE)

def callback(pos):
    global confThreshold
    confThreshold = pos / 100.0

cv.createTrackbar('Confidence threshold, %', winName, int(confThreshold * 100), 99, callback)

cap = cv.VideoCapture(cv.samples.findFileOrKeep(args.input) if args.input else 0)

class QueueFPS(queue.Queue):
    def __init__(self):
        queue.Queue.__init__(self)
        self.startTime = 0
        self.counter = 0

    def put(self, v):
        queue.Queue.put(self, v)
        self.counter += 1
        if self.counter == 1:
            self.startTime = time.time()

    def getFPS(self):
        return self.counter / (time.time() - self.startTime)


process = True

#
# Frames capturing thread
#
framesQueue = QueueFPS()
inputFPS = args.fps
def framesThreadBody():
    global framesQueue, process, inputFPS, DESIRED_HEIGHT, DESIRED_WIDTH

    while process:
        hasFrame, frame = cap.read()
        if not hasFrame:
            break

        if framesQueue.counter == 0:
            if inputFPS == 0:
                inputFPS = cap.get(cv.CAP_PROP_FPS)
                if inputFPS == 0:
                    inputFPS = 30
                    cap.set(cv.CAP_PROP_FPS, inputFPS)

            if DESIRED_HEIGHT == 0:
                DESIRED_HEIGHT = int(cap.get(cv.CAP_PROP_FRAME_HEIGHT))
                if DESIRED_HEIGHT == 0:
                    DESIRED_HEIGHT = 640

            if DESIRED_WIDTH == 0:
                DESIRED_WIDTH = int(cap.get(cv.CAP_PROP_FRAME_WIDTH))
                if DESIRED_WIDTH == 0:
                    DESIRED_WIDTH = 640

            tickInit = cv.getTickCount()
        else:
            elapsed = (cv.getTickCount() - tickInit) / cv.getTickFrequency()
            expected = inputFPS * elapsed

            if expected < framesQueue.counter:
                time.sleep((framesQueue.counter - expected) / inputFPS)
                # elapsed = (cv.getTickCount() - tickInit) / cv.getTickFrequency()

        framesQueue.put(frame)


#
# Frames processing thread
#
processedFramesQueue = queue.Queue()
predictionsQueue = QueueFPS()
def processingThreadBody():
    global processedFramesQueue, predictionsQueue, args, process, asyncN

    futureOutputs = []
    while process:
        # Get a next frame
        frame = None
        try:
            frame = framesQueue.get_nowait()

            if asyncN:
                if len(futureOutputs) == asyncN:
                    frame = None  # Skip the frame
            else:
                framesQueue.queue.clear()  # Skip the rest of frames
        except queue.Empty:
            pass


        if not frame is None:
            frameHeight = frame.shape[0]
            frameWidth = frame.shape[1]

            # Create a 4D blob from a frame.
            inpWidth = args.width if args.width else frameWidth
            inpHeight = args.height if args.height else frameHeight

            imgScale = frameWidth / inpWidth if frameWidth > frameHeight else frameHeight / inpHeight

            # The model expects images of size [ inpWidth x inpHeight ]
            # Performing a high quality shrinking, instead of the provided one in blobFromImage
            # improves detection
            image = np.zeros((inpHeight, inpWidth, 3), np.uint8)
            imgWidth = math.floor(frameWidth / imgScale)
            imgHeight = math.floor(frameHeight / imgScale)
            image[0:imgHeight, 0:imgWidth] = cv.resize(frame,
                dsize=(imgWidth, imgHeight),
                interpolation=cv.INTER_CUBIC if imgScale < 1 else cv.INTER_AREA
            )

            blob = cv.dnn.blobFromImage(image, scalefactor=args.scale, mean=args.mean, size=(inpWidth, inpHeight), swapRB=args.rgb, ddepth=cv.CV_32F)
            processedFramesQueue.put((frame, imgScale, inpWidth, inpHeight))

            # Run a model
            net.setInput(blob)

            if asyncN and args.backend == cv.dnn.DNN_BACKEND_INFERENCE_ENGINE:
                futureOutputs.append(net.forwardAsync())
            else:
                outs = net.forward(outNames)
                # net.printPerfProfile()
                predictionsQueue.put(copy.deepcopy(outs))

        while futureOutputs and futureOutputs[0].wait_for(0):
            out = futureOutputs[0].get()
            predictionsQueue.put(copy.deepcopy([out]))

            del futureOutputs[0]


if args.use_threads:
    framesThread = Thread(target=framesThreadBody)
    framesThread.start()

    processingThread = Thread(target=processingThreadBody)
    processingThread.start()

    #
    # Postprocessing and rendering loop
    #
    while cv.waitKey(1) < 0:
        try:
            # Request prediction first because they put after frames
            outs = predictionsQueue.get_nowait()
            frame, imgScale, inpWidth, inpHeight = processedFramesQueue.get_nowait()

            fontSize = stdSize # 0.3 * imgScale
            fontThickness = 1 # max(1, int(imgScale * 0.5))

            boxes, classIds, confidences, indices = postprocess(frame, imgScale, inpWidth, inpHeight, outs)
            drawPred(frame, classIds, confidences, boxes, indices, fontSize, fontThickness)

            # Put efficiency information.
            if predictionsQueue.counter > 1:
                fontSize = fontSize / 2

                label = 'Camera: %.2f FPS' % (framesQueue.getFPS())
                cv.rectangle(frame, (0, 0), (int(260 * fontSize), int(80 * fontSize)), (255, 255, 255), cv.FILLED)
                cv.putText(frame, label, (0, int(25 * fontSize)), cv.FONT_HERSHEY_SIMPLEX, fontSize, (0, 0, 0), fontThickness)

                label = 'Network: %.2f FPS' % (predictionsQueue.getFPS())
                cv.putText(frame, label, (0, int(2 * 25 * fontSize)), cv.FONT_HERSHEY_SIMPLEX, fontSize, (0, 0, 0), fontThickness)

                label = 'Skipped frames: %d' % (framesQueue.counter - predictionsQueue.counter)
                cv.putText(frame, label, (0, int(3 * 25 * fontSize)), cv.FONT_HERSHEY_SIMPLEX, fontSize, (0, 0, 0), fontThickness)

            resize_and_show(winName, frame)
        except queue.Empty:
            pass


    process = False
    framesThread.join()
    processingThread.join()

else:
    # Non-threaded processing if --async is 0
    while cv.waitKey(1) < 0:
        hasFrame, frame = cap.read()
        if not hasFrame:
            cv.waitKey()
            break

        if DESIRED_HEIGHT == 0:
            DESIRED_HEIGHT = int(cap.get(cv.CAP_PROP_FRAME_HEIGHT))
            if DESIRED_HEIGHT == 0:
                DESIRED_HEIGHT = 640

        if DESIRED_WIDTH == 0:
            DESIRED_WIDTH = int(cap.get(cv.CAP_PROP_FRAME_WIDTH))
            if DESIRED_WIDTH == 0:
                DESIRED_WIDTH = 640

        frameHeight = frame.shape[0]
        frameWidth = frame.shape[1]

        # Create a 4D blob from a frame.
        inpWidth = args.width if args.width else frameWidth
        inpHeight = args.height if args.height else frameHeight

        imgScale = frameWidth / inpWidth if frameWidth > frameHeight else frameHeight / inpHeight

        # The model expects images of size [ inpWidth x inpHeight ]
        # Performing a high quality shrinking, instead of the provided one in blobFromImage
        # improves detection
        image = np.zeros((inpHeight, inpWidth, 3), np.uint8)
        imgWidth = math.floor(frameWidth / imgScale)
        imgHeight = math.floor(frameHeight / imgScale)
        image[0:imgHeight, 0:imgWidth] = cv.resize(frame,
            dsize=(imgWidth, imgHeight),
            interpolation=cv.INTER_CUBIC if imgScale < 1 else cv.INTER_AREA
        )

        blob = cv.dnn.blobFromImage(image, scalefactor=args.scale, mean=args.mean, size=(inpWidth, inpHeight), swapRB=args.rgb, ddepth=cv.CV_32F)

        net.setInput(blob)
        outs = net.forward(outNames)
        # net.printPerfProfile()

        fontSize = stdSize # 0.3 * imgScale
        fontThickness = 1 # max(1, int(imgScale * 0.5))

        boxes, classIds, confidences, indices = postprocess(frame, imgScale, inpWidth, inpHeight, outs)
        drawPred(frame, classIds, confidences, boxes, indices, fontSize, fontThickness)

        resize_and_show(winName, frame)
