# PYTHONPATH="$(realpath opencv-5.0.0-windows/opencv/sources/samples/dnn)" samples/.venv/Scripts/python.exe samples/dnn/object_detection/download_model.py
# PYTHONPATH="$(realpath opencv-5.0.0-windows/opencv/sources/samples/dnn)" samples/.venv/Scripts/python.exe samples/dnn/object_detection/download_model.py ssd_tf

from typing import Optional

import argparse
import platform
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


def get_or_create_python_venv(venv_dir: str):
    bin_path = "Scripts" if platform.system() == "Windows" else "bin"
    path_ext = ".exe" if platform.system() == "Windows" else ""
    python_venv_interpreter = os.path.join(venv_dir, bin_path, "python" + path_ext)
    python_venv_created = False

    if not os.path.exists(python_venv_interpreter):
        subprocess.run([python, '-m', 'venv', venv_dir])
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', '--upgrade', 'pip'], cwd=os.path.dirname(venv_dir))
        python_venv_created = True

    return python_venv_interpreter, python_venv_created


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
    if not os.path.exists(filepath):
        print(f"{filepath} does not exist. Skipping hashsum matching")
        return False
    print('  expected SHA1: {}'.format(expected_sha))
    actual_sha = getHashsumFromFile(filepath)
    print('  actual SHA1:{}'.format(actual_sha))
    hashes_matched = expected_sha == actual_sha
    if not hashes_matched and not silent:
        raise HashMismatchException(expected_sha, actual_sha)
    return hashes_matched


def download_file(name, prefix, info, save_dir, dest):
    fname = os.path.basename(dest)
    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get(prefix+"sha1")
    url = info.get(prefix+"url")
    download_sha = info.get(prefix+"download_sha")
    download_name = info.get(prefix+"download_name")
    archive_member = info.get(prefix+"member")
    if actual_sha != expected_sha:
        download_instance = download_models.produceDownloadInstance(name, fname, expected_sha, url, save_dir,
            download_name=download_name, download_sha=download_sha, archive_member=archive_member)

        print('Model: ' + name)
        filename = download_instance.get()
        if os.path.exists(dest):
            os.remove(dest)
        shutil.move(filename, os.path.dirname(dest))


def download_yolov5(name, prefix, info, save_dir, dest):
    if ('url' in info) and ('.onnx' in info.get(prefix+'url')):
        download_file(name, prefix, info, save_dir, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get(prefix+"sha1")
    if actual_sha == expected_sha:
        return

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov5')

    if not os.path.exists(os.path.join(repo, ".git")):
        subprocess.run(['git', 'clone', 'https://github.com/ultralytics/yolov5.git', repo], cwd=cwd)

    python_venv_interpreter, python_venv_created = get_or_create_python_venv(os.path.join(repo, '.venv'))

    if python_venv_created:
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python_venv_interpreter, os.path.join(repo, 'export.py'), 
                    '--include', 'onnx',
                    '--opset', '12',
                    '--simplify',
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt")
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov6(name, prefix, info, save_dir, dest):
    if ('url' in info) and ('.onnx' in info.get(prefix+'url')):
        download_file(name, prefix, info, save_dir, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get(prefix+"sha1")
    if actual_sha == expected_sha:
        return

    # download pt
    info["sha1"] = info.get(prefix+"download_sha")
    info.pop("download_sha", None)
    download_file(name, prefix, info, save_dir, dest.replace(".onnx", ".pt"))

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov6')

    if not os.path.exists(os.path.join(repo, ".git")):
        subprocess.run(['git', 'clone', 'https://github.com/meituan/YOLOv6.git', repo], cwd=cwd)

    python_venv_interpreter, python_venv_created = get_or_create_python_venv(os.path.join(repo, '.venv'))

    if python_venv_created:
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

        # ModuleNotFoundError: No module named 'pkg_resources'
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'uninstall', '-y', 'setuptools'], cwd=repo)
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', 'requests', 'setuptools<82'], cwd=repo)

        # In PyTorch 2.6, we changed the default value of the `weights_only` argument in `torch.load` from `False` to `True
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'uninstall', '-y', 'torchvision', 'torch'], cwd=repo)
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', 'torch<2.6.0', 'torchvision>=0.8.1,!=0.13.0'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python_venv_interpreter, os.path.join(repo, 'deploy', 'ONNX', 'export_onnx.py'),
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt"),
                    '--img', '640',
                    '--batch', '1',
                    '--simplify'
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov7(name, prefix, info, save_dir, dest):
    if ('url' in info) and ('.onnx' in info.get(prefix+'url')):
        download_file(name, prefix, info, save_dir, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get(prefix+"sha1")
    if actual_sha == expected_sha:
        return

    # download pt
    info["sha1"] = info.get(prefix+"download_sha")
    info.pop("download_sha", None)
    download_file(name, prefix, info, save_dir, dest.replace(".onnx", ".pt"))

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov7')

    if not os.path.exists(os.path.join(repo, ".git")):
        subprocess.run(['git', 'clone', 'https://github.com/WongKinYiu/yolov7.git', repo], cwd=cwd)

    python_venv_interpreter, python_venv_created = get_or_create_python_venv(os.path.join(repo, '.venv'))

    if python_venv_created:
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', '-r', 'requirements.txt'], cwd=repo)

        # ONNX export
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', 'onnx>=1.9.0', 'onnx-simplifier>=0.3.6'], cwd=repo)

        # In PyTorch 2.6, we changed the default value of the `weights_only` argument in `torch.load` from `False` to `True
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'uninstall', '-y', 'torchvision', 'torch'], cwd=repo)
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', 'torch<2.6.0', 'torchvision>=0.8.1,!=0.13.0'], cwd=repo)

    if os.path.exists(dest):
        os.remove(dest)

    env = os.environ.copy()
    env['PYTHONPATH'] = repo
    subprocess.run([python_venv_interpreter, os.path.join(repo, 'export.py'),
                    '--weights', os.path.basename(dest).replace(".onnx", ".pt"),
                    '--grid',
                    '--simplify',
                    '--img-size', '640', '640',
                    '--max-wh', '640'
                    ], cwd=cwd, env=env)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def download_yolov8(name, prefix, info, save_dir, dest):
    if ('url' in info) and ('.onnx' in info.get(prefix+'url')):
        download_file(name, prefix, info, save_dir, dest)
        return

    actual_sha = getHashsumFromFile(dest)
    expected_sha = info.get(prefix+"sha1")
    if actual_sha == expected_sha:
        return

    # convert to onnx
    cwd = os.path.dirname(dest)
    repo = os.path.join(cwd, 'yolov8')

    if os.path.exists(dest):
        os.remove(dest)

    python_venv_interpreter, python_venv_created = get_or_create_python_venv(os.path.join(repo, '.venv'))

    path_ext = ".exe" if platform.system() == "Windows" else ""
    yolo = os.path.join(os.path.dirname(python_venv_interpreter), "yolo" + path_ext)

    if python_venv_created or not os.path.exists(yolo):
        subprocess.run([python_venv_interpreter, '-m', 'pip', 'install', 'ultralytics'], cwd=repo)

    subprocess.run([yolo, 'export',
                    f'model={ os.path.basename(dest).replace(".onnx", ".pt") }',
                    'imgsz=640',
                    'format=onnx',
                    'opset=12'
                    ], cwd=cwd)

    checkHashsum(expected_sha, dest, silent=False)
    print("  Finished " + dest)


def parseYAMLFile(yaml_filepath, save_dir, model_name):
    with open(yaml_filepath, 'r') as stream:
        data_loaded = yaml.safe_load(stream)
        for name, params in data_loaded.items():
            if model_name != "" and name != model_name:
                continue

            for key in params.keys():
                if key.endswith("load_info"):
                    prefix = key[:-len('load_info')]
                    load_info = params.get(prefix+"load_info", None)
                    if load_info:
                        # print(prefix)
                        if prefix == "config_":
                            fname = abspath(params.get("config"))
                            download_file(name, "", load_info, save_dir, fname)
                        else:
                            fname = abspath(params.get(prefix+"model"))
                            should_download_yolo = (prefix+'download_sha' in load_info) or not (prefix+'url' in load_info)
                            if should_download_yolo and name.startswith("yolov5"):
                                download_yolov5(name, prefix, load_info, save_dir, fname)
                            elif should_download_yolo and name.startswith("yolov6"):
                                download_yolov6(name, prefix, load_info, save_dir, fname)
                            elif should_download_yolo and name.startswith("yolov7"):
                                download_yolov7(name, prefix, load_info, save_dir, fname)
                            elif should_download_yolo and name.startswith("yolov8"):
                                download_yolov8(name, prefix, load_info, save_dir, fname)
                            else:
                                download_file(name, prefix, load_info, save_dir, fname)


if __name__ == '__main__':
    __dirname__ = os.path.dirname(os.path.abspath(__file__))

    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('model_name', type=str, default="", nargs='?', action="store",
                        help='name of the model to download')
    parser.add_argument('--save_dir', action="store", default=os.path.join(__dirname__, "models", ".cache"),
                        help='Path to the directory to store downloaded files')
    parser.add_argument('--zoo', default=os.path.join(__dirname__, 'models.yml'),
                        help='An optional path to file with preprocessing parameters.')
    args = parser.parse_args()

    save_dir = args.save_dir
    selected_model_name = args.model_name
    parseYAMLFile(args.zoo, save_dir, selected_model_name)
