from typing import Optional

import argparse
import subprocess

import download_models
import hashlib
import shutil
import yaml

from common import *
from tf_text_graph_common import readTextMessage
from tf_text_graph_ssd import createSSDGraph
from tf_text_graph_faster_rcnn import createFasterRCNNGraph

python = sys.executable or 'python'


def abspath(filepath: Optional[str]) -> Optional[str]:
    if filepath is None:
        return filepath
    return os.path.abspath(filepath)


def replace_string(filepath: str, match: str, replace: str) -> None:
    # Read in the file
    with open(filepath, 'r') as file:
        filedata = file.read()

    # Replace the target string
    filedata = filedata.replace(match, replace)

    # Write the file out again
    with open(filepath, 'w') as file:
        file.write(filedata)


class HashMismatchException(Exception):
    def __init__(self, expected, actual):
        Exception.__init__(self)
        self.expected = expected
        self.actual = actual

    def __str__(self):
        return 'Hash mismatch: expected {} vs actual of {}'.format(self.expected, self.actual)


def getHashsumFromFile(filepath: str) -> str:
    sha = hashlib.sha1()
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            while True:
                buf = f.read(10 * 1024 * 1024)
                if not buf:
                    break
                sha.update(buf)
    hashsum = sha.hexdigest()
    return hashsum


def checkHashsum(expected_sha, filepath, silent=True):
    print('  expected SHA1: {}'.format(expected_sha))
    actual_sha = getHashsumFromFile(filepath)
    print('  actual SHA1:{}'.format(actual_sha))
    hashes_matched = expected_sha == actual_sha
    if not hashes_matched and not silent:
        raise HashMismatchException(expected_sha, actual_sha)
    return hashes_matched


def download_file(info, dest):
    fname = os.path.basename(dest)
    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get("sha1")
    url = info.get("url")
    download_sha = info.get("download_sha")
    download_name = info.get("download_name")
    archive_member = info.get("member")
    if actual_sha != expected_sha:
        download_instance = download_models.produceDownloadInstance(name, fname, expected_sha, url, cache_dir,
            download_name=download_name, download_sha=download_sha, archive_member=archive_member)

        print('Model: ' + name)
        filename = download_instance.get()
        if os.path.exists(dest):
            os.remove(dest)
        shutil.move(filename, os.path.dirname(dest))


def download_yolov5(info, dest):
    if ('url' in info) and ('.onnx' in info.get('url')):
        download_file(info, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get("sha1")
    if actual_sha == expected_sha:
        return

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov5')

    if not os.path.exists(repo):
        subprocess.run(['git', 'clone', 'https://github.com/ultralytics/yolov5.git', 'yolov5'], cwd=cwd)
        subprocess.run([python, '-m', 'pip', 'install', '--upgrade', 'pip'], cwd=repo)
        subprocess.run([python, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python, os.path.join(repo, 'export.py'), 
                    '--include', 'onnx',
                    '--opset', '12',
                    '--simplify',
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt")
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov6(info, dest):
    if ('url' in info) and ('.onnx' in info.get('url')):
        download_file(info, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get("sha1")
    if actual_sha == expected_sha:
        return

    # download pt
    info["sha1"] = info.get("download_sha")
    info.pop("download_sha", None)
    download_file(info, dest.replace(".onnx", ".pt"))

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'YOLOv6')

    if not os.path.exists(repo):
        subprocess.run(['git', 'clone', 'https://github.com/meituan/YOLOv6.git', 'YOLOv6'], cwd=cwd)
        subprocess.run([python, '-m', 'pip', 'install', '--upgrade', 'pip'], cwd=repo)
        subprocess.run([python, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python, os.path.join(repo, 'deploy', 'ONNX', 'export_onnx.py'),
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt"),
                    '--img', '640',
                    '--batch', '1',
                    '--simplify'
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov7(info, dest):
    if ('url' in info) and ('.onnx' in info.get('url')):
        download_file(info, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get("sha1")
    if actual_sha == expected_sha:
        return

    # download pt
    info["sha1"] = info.get("download_sha")
    info.pop("download_sha", None)
    download_file(info, dest.replace(".onnx", ".pt"))

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov7')

    if not os.path.exists(repo):
        subprocess.run(['git', 'clone', 'https://github.com/WongKinYiu/yolov7.git', 'yolov7'], cwd=cwd)
        subprocess.run([python, '-m', 'pip', 'install', '--upgrade', 'pip'], cwd=repo)
        subprocess.run([python, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python, os.path.join(repo, 'export.py'),
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt"),
                    '--grid',
                    '--simplify',
                    '--img-size', '640', '640',
                    '--max-wh', '640'
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov8(info, dest):
    if ('url' in info) and ('.onnx' in info.get('url')):
        download_file(info, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get("sha1")
    if actual_sha == expected_sha:
        return

    # convert to onnx
    cwd = os.path.dirname(dest)

    if os.path.exists(dest):
        os.remove(dest)

    subprocess.run([python, '-m', 'pip', 'install', '--upgrade', 'pip'], cwd=cwd)
    subprocess.run([python, '-m', 'pip', 'install', 'ultralytics'], cwd=cwd)
    subprocess.run(['yolo', 'export',
                    f'model={ os.path.basename(dest).replace(".onnx", ".pt") }',
                    'imgsz=640',
                    'format=onnx',
                    'opset=12'
                    ], cwd=cwd)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


backends = (cv.dnn.DNN_BACKEND_DEFAULT, cv.dnn.DNN_BACKEND_HALIDE, cv.dnn.DNN_BACKEND_INFERENCE_ENGINE, cv.dnn.DNN_BACKEND_OPENCV,
            cv.dnn.DNN_BACKEND_VKCOM, cv.dnn.DNN_BACKEND_CUDA)
targets = (cv.dnn.DNN_TARGET_CPU, cv.dnn.DNN_TARGET_OPENCL, cv.dnn.DNN_TARGET_OPENCL_FP16, cv.dnn.DNN_TARGET_MYRIAD, cv.dnn.DNN_TARGET_HDDL,
           cv.dnn.DNN_TARGET_VULKAN, cv.dnn.DNN_TARGET_CUDA, cv.dnn.DNN_TARGET_CUDA_FP16)

parser = argparse.ArgumentParser(add_help=False)
parser.add_argument('model_name', type=str, default="", nargs='?', action="store",
                   help='name of the model to download')
parser.add_argument('--zoo', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'models.yml'),
                    help='An optional path to file with preprocessing parameters.')
parser.add_argument('--input', help='Path to input image or video file. Skip this argument to capture frames from a camera.')
parser.add_argument('--out_tf_graph', default='graph.pbtxt',
                    help='For models from TensorFlow Object Detection API, you may '
                         'pass a .config file which was used for training through --config '
                         'argument. This way an additional .pbtxt file with TensorFlow graph will be created.')
parser.add_argument('--framework', choices=['caffe', 'tensorflow', 'torch', 'darknet', 'dldt'],
                    help='Optional name of an origin framework of the model. '
                         'Detect it automatically if it does not set.')
parser.add_argument('--thr', type=float, default=0.5, help='Confidence threshold')
parser.add_argument('--nms', type=float, default=0.4, help='Non-maximum suppression threshold')
parser.add_argument('--backend', choices=backends, default=cv.dnn.DNN_BACKEND_DEFAULT, type=int,
                    help="Choose one of computation backends: "
                         "%d: automatically (by default), "
                         "%d: Halide language (http://halide-lang.org/), "
                         "%d: Intel's Deep Learning Inference Engine (https://software.intel.com/openvino-toolkit), "
                         "%d: OpenCV implementation, "
                         "%d: VKCOM, "
                         "%d: CUDA" % backends)
parser.add_argument('--target', choices=targets, default=cv.dnn.DNN_TARGET_CPU, type=int,
                    help='Choose one of target computation devices: '
                         '%d: CPU target (by default), '
                         '%d: OpenCL, '
                         '%d: OpenCL fp16 (half-float precision), '
                         '%d: NCS2 VPU, '
                         '%d: HDDL VPU, '
                         '%d: Vulkan, '
                         '%d: CUDA, '
                         '%d: CUDA fp16 (half-float preprocess)' % targets)
parser.add_argument('--async', type=int, default=0,
                    dest='asyncN',
                    help='Number of asynchronous forwards at the same time. '
                         'Choose 0 for synchronous mode')
args, _ = parser.parse_known_args()
add_preproc_args(args.zoo, parser, 'object_detection')
parser = argparse.ArgumentParser(parents=[parser],
                                 description='Use this script to run object detection deep learning networks using OpenCV.',
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)

args = parser.parse_args()

# if model does not exist, download it
if args.model_name:
    cache_dir = os.path.join(os.getcwd(), ".cache")

    with open(args.zoo, 'r') as stream:
        data_loaded = yaml.safe_load(stream)
        for name, params in data_loaded.items():
            if name != args.model_name:
                continue

            model = abspath(params.get("model"))
            load_info = params.get("load_info", None)
            if load_info:
                if name.startswith("yolov5"):
                    download_yolov5(load_info, model)
                elif name.startswith("yolov6"):
                    download_yolov6(load_info, model)
                elif name.startswith("yolov7"):
                    download_yolov7(load_info, model)
                elif name.startswith("yolov8"):
                    download_yolov8(load_info, model)
                else:
                    download_file(load_info, model)

            config = abspath(params.get("config"))
            config_info = params.get("config_info", None)
            if config_info:
                config_filename = config_info.get("filename")
                if not (config_filename is None):
                    config = os.path.join(os.path.dirname(config), config_filename)
                download_file(config_info, config)

            # If config is specified, try to load it as TensorFlow Object Detection API's pipeline.
            in_tf_config = config
            out_tf_graph = params.get("config")
            if model.endswith('.pb') and not os.path.exists(out_tf_graph):
                config = readTextMessage(in_tf_config)
                if 'model' in config:
                    print('TensorFlow Object Detection API config detected')
                    if 'ssd' in config['model'][0]:
                        print('Preparing text graph representation for SSD model: ' + out_tf_graph)
                        createSSDGraph(model, in_tf_config, out_tf_graph)
                    elif 'faster_rcnn' in config['model'][0]:
                        print('Preparing text graph representation for Faster-RCNN model: ' + out_tf_graph)
                        createFasterRCNNGraph(model, in_tf_config, out_tf_graph)

args.model = findFile(args.model)
args.config = findFile(args.config)
# args.classes = findFile(args.classes)

# print(f'''
#     model       : {abspath(args.model)}
#     config      : {abspath(args.config)}
#     framework   : {args.framework}
#     classes     : {abspath(args.classes)}
#     width       : {args.width}
#     height      : {args.height}
#     scale       : {args.scale}
#     rgb         : {args.rgb}
#     mean        : {args.mean}
#     thr         : {args.thr}
#     nms         : {args.nms}
# ''')
