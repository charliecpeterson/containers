#!/bin/bash

# Configure GNU gold linker for use with Bazel
export BAZEL_LINKOPTS="-fuse-ld=gold"

# Install Python packages
pip install --no-cache-dir transforms datasets wheel plotly requests packaging tabulate future xgboost numpy scikit-learn scipy seaborn pandas matplotlib jupyterlab "dask[complete]"
pip install --no-cache-dir -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o
# Spark SQL
pip install --no-cache-dir pyspark[sql]
# pandas API on Spark
pip install --no-cache-dir pyspark[pandas_on_spark] plotly  
# Spark Connect
pip install --no-cache-dir pyspark[connect]


# Download and configure Bazelisk
wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazel
# Check if CUDA is available for GPU support
if [ -n "$CUDA_HOME" ]; then
    # GPU specific setup
    git clone https://github.com/tensorflow/tensorflow.git
    cd tensorflow
    git checkout v${TF_VERSION}

    # Configure environment variables for TensorFlow with CUDA
    export TF_TENSORRT_VERSION=8
    export TF_CUDA_VERSION=11
    export TF_CUDNN_VERSION=8
    export TF_PYTHON_VERSION=3.10
    export TF_CUDA_PATHS=$CUDA_HOME
    export PYTHON_BIN_PATH=/usr/local/bin/python
    export TF_NEED_CUDA=1
    export TF_NEED_TENSORRT=1
    export CUDA_TOOLKIT_PATH=$CUDA_HOME
    export TENSORRT_INSTALL_PATH=/usr/local
    export CUDNN_INSTALL_PATH=/usr/local
    export NCCL_INSTALL_PATH=/usr/local
    export TF_NCCL_VERSION=2
    export TF_CUDA_COMPUTE_CAPABILITIES="3.7,6.0,6.1,7.0,7.5,8.0,8.6,8.9,9.0"
    export TF_NEED_CLANG_CUDA=1
    export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
    export CC_OPT_FLAGS="-Wno-sign-compare"
    export USE_DEFAULT_PYTHON_LIB_PATH=1
    export TF_NEED_ROCM=0
    export TF_CUDA_CLANG=0
    export TF_SET_ANDROID_WORKSPACE=0
    export TF_DOWNLOAD_CLANG=0
    ./configure

    # Build TensorFlow package with GPU support
    if [ "$USE_ONEAPI" = "TRUE" ]; then
        bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=cuda --config=mkl  -c opt --copt=-Wno-implicit-function-declaration --copt=-Wno-error=switch

else
       bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=cuda  -c opt --copt=-Wno-implicit-function-declaration --copt=-Wno-error=switch 
    fi

else
    # CPU specific setup
    git clone https://github.com/tensorflow/tensorflow.git
    cd tensorflow
    git checkout v${TF_VERSION}
    export TF_PYTHON_VERSION=3.10
    export PYTHON_BIN_PATH=/usr/local/bin/python
    export TF_NEED_CUDA=0
    export TF_NEED_TENSORRT=0
    export TF_NEED_CLANG_CUDA=0
    export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
    export CC_OPT_FLAGS="-Wno-sign-compare"
    export USE_DEFAULT_PYTHON_LIB_PATH=1
    export TF_NEED_ROCM=0
    export TF_CUDA_CLANG=0
    export TF_SET_ANDROID_WORKSPACE=0
    export TF_DOWNLOAD_CLANG=0
    ./configure

    # Build TensorFlow package for CPU only
    if [ "$USE_ONEAPI" = "TRUE" ]; then
        bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow --config=mkl  -c opt --copt=-Wno-implicit-function-declaration --copt=-Wno-error=switch
    else
        bazel build //tensorflow/tools/pip_package:build_pip_package --repo_env=WHEEL_NAME=tensorflow
    fi

fi

# Package and install TensorFlow
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /test/tensorflow_pkg
pip install /test/tensorflow_pkg/tensorflow-*.whl
cd /
rm -rf tensorflow
rm -rf /test
rm -rf /root/.cache

if [ -n "$CUDA_HOME" ]; then
	 if [ "$USE_ONEAPI" = "TRUE" ]; then

		export  USE_CUDA=1
		export USE_CUDNN=1
		export USE_MKLDNN=1
		export USE_SYSTEM_NCCL=1
		export MKL_THREADING=OMP
		export USE_SYSTEM_TBB=1

	 else
		 export  USE_CUDA=1
		export USE_CUDNN=1
		export USE_MKLDNN=0
		export USE_SYSTEM_NCCL=1
		export USE_SYSTEM_TBB=0
	fi
else

	if [ "$USE_ONEAPI" = "TRUE" ]; then
		export  USE_CUDA=1
		export USE_CUDNN=0
		export USE_MKLDNN=1
		export USE_SYSTEM_NCCL=0
		export MKL_THREADING=OMP
		export USE_SYSTEM_TBB=1
	else
		export  USE_CUDA=0
		export USE_CUDNN=0
		export USE_MKLDNN=0
		export USE_SYSTEM_NCCL=0
		export USE_SYSTEM_TBB=0
	fi
fi

cd /usr/local
git clone https://github.com/pytorch/pytorch
cd pytorch
git checkout v${TORCH_VER}
python setup.py develop

export PYTHON_VER_NUMERIC=$(echo ${PYTHON_VER//[^0-9]/} | cut -c 1-3)
pip3 install /usr/local/lib/tensorrtpython/tensorrt-*-cp${PYTHON_VER_NUMERIC}-none-linux_x86_64.whl

cd /
git clone https://github.com/pytorch/vision.git
cd vision
git checkout v0.18.0
python setup.py install
cd /
rm -rf vision


rm -rf /root/.cache

