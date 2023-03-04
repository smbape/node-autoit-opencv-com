from typing import Optional

import argparse

import download_models
import hashlib
import shutil
import yaml

from common import *
from tf_text_graph_common import readTextMessage
from tf_text_graph_ssd import createSSDGraph
from tf_text_graph_faster_rcnn import createFasterRCNNGraph


def getHashsumFromFile(filepath: str) -> str:
    sha = hashlib.sha1()
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            while True:
                buf = f.read(10*1024*1024)
                if not buf:
                    break
                sha.update(buf)
    hashsum = sha.hexdigest()
    return hashsum


def abspath(filepath: Optional[str]) -> Optional[str]:
    if filepath is None:
        return filepath
    return os.path.abspath(filepath)


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
            if not name.startswith(args.model_name):
                continue

            model = os.path.abspath(params.get("model"))
            load_info = params.get("load_info", None)
            if load_info:
                fname = os.path.basename(model)
                actual_sha = getHashsumFromFile(model)
                expected_sha = load_info.get("sha1")
                url = load_info.get("url")
                download_sha = load_info.get("download_sha")
                download_name = load_info.get("download_name")
                archive_member = load_info.get("member")
                if actual_sha != expected_sha:
                    download_instance = download_models.produceDownloadInstance(name, fname, expected_sha, url, cache_dir,
                        download_name=download_name, download_sha=download_sha, archive_member=archive_member)

                    print('Model: ' + name)
                    filename = download_instance.get()
                    if os.path.exists(model):
                        os.remove(model)
                    shutil.move(filename, os.path.dirname(model))

            config = os.path.abspath(params.get("config"))
            config_info = params.get("config_info", None)
            if config_info:
                fname = config_info.get("filename")
                if fname is None:
                    fname = config

                fname = os.path.basename(fname)
                actual_sha = getHashsumFromFile(fname)
                expected_sha = config_info.get("sha1")
                url = config_info.get("url")
                download_sha = config_info.get("download_sha")
                download_name = config_info.get("download_name")
                archive_member = config_info.get("member")
                if actual_sha != expected_sha:
                    download_instance = download_models.produceDownloadInstance(name, fname, expected_sha, url, cache_dir,
                        download_name=download_name, download_sha=download_sha, archive_member=archive_member)

                    print('Config: ' + fname)
                    filename = download_instance.get()
                    if os.path.exists(fname):
                        os.remove(fname)
                    shutil.move(filename, os.path.dirname(config))

                config = os.path.join(os.path.dirname(config), fname)

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
