#!/bin/bash



dnf install -y libcurl libcurl-devel --allowerasing
dnf install -y perl python3-devel python3-pip vim less bzip2-devel bzip2 \
               glibc-locale-source glibc-langpack-en \
               iproute pcre-devel pcre pcre2-devel pcre2  \
               readline-devel libX11-devel libXt-devel libXt libxml2 libxml2-devel \
               java-11-openjdk-devel java-11-openjdk hdf5-devel \
               libtiff-devel libtiff libicu-devel libicu libjpeg-turbo-devel libjpeg-turbo \
               libpng12-devel libpng12 cairo-devel cairo glpk-devel glpk fftw-devel fftw bc \
               openssl-devel psmisc pwgen wget sudo ca-certificates \
               pandoc fribidi-devel fribidi harfbuzz-devel harfbuzz

dnf install clang-devel

wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazel

if [ "$USE_ONEAPI" = "TRUE" ]; then

pip install intel-tensorflow==2.14.0 tensorflow[and-cuda]
fi

wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz 
tar -vxf Python-${PYTHON_VER}.tgz ; rm -f Python-${PYTHON_VER}.tgz  
cd Python-${PYTHON_VER} ; ./configure --enable-optimizations --enable-shared
make ; make install 
cd .. ; rm -fr Python-${PYTHON_VER}
ln -s /usr/local/bin/pip3 /usr/local/bin/pip 
ln -s /usr/local/bin/python3 /usr/local/bin/python 

pip install requests packaging tabulate future xgboost numpy scikit-learn scipy seaborn pandas matplotlib jupyterlab "dask[complete]"
pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

if [ -n "$CUDA_HOME" ] ; then
#GPU


git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout v${TF_VERSION}
export TF_TENSORRT_VERSION=10
export TF_CUDA_VERSION=12
export TF_CUDNN_VERSION=8
export TF_PYTHON_VERSION=3.10
export TF_CUDA_PATHS=$CUDA_HOME
export PYTHON_BIN_PATH=/usr/local/bin/python
export CLANG_CUDA_COMPILER_PATH=/usr/bin/clang
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

