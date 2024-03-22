#!/bin/bash

if [ "$USE_ONEAPI" = "TRUE" ]; then

source /opt/intel/oneapi/setvars.sh
pip install intel-tensorflow==2.14.0 tensorflow[and-cuda]
fi

wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz 
tar -vxf Python-${PYTHON_VER}.tgz ; rm Python-${PYTHON_VER}.tgz  
cd Python-${PYTHON_VER} ; ./configure --enable-optimizations --enable-shared
make ; make install 
cd .. ; rm -r Python-${PYTHON_VER}
ln -s /usr/local/bin/pip3 /usr/local/bin/pip 
ln -s /usr/local/bin/python3 /usr/local/bin/python 

pip install requests packaging tabulate future xgboost numpy scikit-learn scipy seaborn pandas matplotlib jupyterlab "dask[complete]"
pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

if [ -n "$CUDA_HOME" ] ; then
#GPU


git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout v2.16.1
export TF_TENSORRT_VERSION=8
export TF_CUDA_VERSION=12
export TF_CUDNN_VERSION=8
export TF_PYTHON_VERSION=3.10
export TF_CUDA_PATHS=$CUDA_HOME
export PYTHON_BIN_PATH=/usr/local/bin/python
export CLANG_CUDA_COMPILER_PATH=/usr/lib/llvm-17/bin/clang
export TF_ENABLE_ROCM=0
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=1
export CUDA_TOOLKIT_PATH=$CUDA_HOME
export TENSORRT_INSTALL_PATH=/usr
export CUDNN_INSTALL_PATH=/usr
export NCCL_INSTALL_PATH=/usr
export TF_CUDA_COMPUTE_CAPABILITIES="3.7,3.5,6.0,6.1,7.0,7.5,8.0,8.6,8.9,9.0"
export TF_NEED_CLANG_CUDA=0
export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
export CC_OPT_FLAGS="-Wno-sign-compare"
export USE_DEFAULT_PYTHON_LIB_PATH=1
export TF_NEED_ROCM=0
export TF_CUDA_CLANG=1
export TF_SET_ANDROID_WORKSPACE=0
export TF_NCCL_VERSION=2
./configure

if [ "$USE_ONEAPI" = "TRUE" ]; then
export TF_ENABLE_ONEDNN_OPTS=1
bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=cuda --config=mkl --copt=-Wno-unused-command-line-argument


else

bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=cuda --copt=-Wno-unused-command-line-argument
 

fi

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /test/tensorflow_pkg
pip install /test/tensorflow_pkg/tensorflow-*.whl
cd /
#rm -rf /test
#rm -rf /tensorflow

pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121


else 

##CPU

git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout v2.14.0
export TF_PYTHON_VERSION=3.10
export PYTHON_BIN_PATH=/usr/local/bin/python
export TF_ENABLE_ROCM=0
export TF_NEED_CUDA=0
export TF_NEED_TENSORRT=0
export TF_CUDA_COMPUTE_CAPABILITIES="3.7,3.5,6.0,6.1,7.0,7.5,8.0,8.6,8.9,9.0"
export TF_NEED_CLANG_CUDA=0
export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
export CC_OPT_FLAGS="-Wno-sign-compare"
export USE_DEFAULT_PYTHON_LIB_PATH=1
export TF_NEED_ROCM=0
export TF_CUDA_CLANG=0
export TF_NEED_CLANG=0
export TF_SET_ANDROID_WORKSPACE=0
./configure

if [ "$USE_ONEAPI" = "TRUE" ]; then
export TF_ENABLE_ONEDNN_OPTS=1
export CC_OPT_FLAGS="-Wno-sign-compare -fopenmp=libomp"
bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=mkl --copt=-Wno-unused-command-line-argument


else

bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --copt=-Wno-unused-command-line-argument
 

fi

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /test/tensorflow_pkg
pip install /test/tensorflow_pkg/tensorflow-*.whl
cd /
#rm -rf /test
#rm -rf /tensorflow

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

