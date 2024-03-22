#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

apt update && apt install -y lsb-release wget software-properties-common gnupg pkg-config zlib1g zlib1g-dev openssl wget make git vim less libhdf5-dev gcc gfortran g++ ca-certificates cmake ant libreadline-dev libx11-dev libxt-dev bzip2 xz-utils libpcre2-dev libcurl4-openssl-dev gnupg curl libbz2-dev liblzma-dev iproute2 tzdata locales 
apt update -y && apt install -y patchelf flex bison fontconfig libfreetype6-dev libxml2-dev libproj-dev libgsl-dev bc \
                   libfontconfig1-dev pkg-config libharfbuzz-dev libfribidi-dev \
                   zstd libzstd-dev libwebp-dev \
           libtiff-dev libicu-dev openjdk-11-jdk xorg libx11-dev libxt-dev libjpeg-dev libpng-dev libcairo2-dev libglpk-dev fftw3-dev patch libhdf5-serial-dev

locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
update-locale LANG=en_US.UTF-8

if [ "$USE_ONEAPI" = "TRUE" ]; then

	wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor |  tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

	echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list
	
	apt update -y ; apt install -y intel-basekit intel-hpckit
fi

if [ -n "$CUDA_HOME" ]; then


wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
echo | add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"

apt update ; apt install -y cuda-11-8  tensorrt=8.5.3.1-1+cuda11.8 libnvinfer8=8.5.3-1+cuda11.8 libnvinfer-plugin8=8.5.3-1+cuda11.8 libnvparsers8=8.5.3-1+cuda11.8 libnvonnxparsers8=8.5.3-1+cuda11.8 libnvinfer-bin=8.5.3-1+cuda11.8 libnvinfer-dev=8.5.3-1+cuda11.8 libnvinfer-plugin-dev=8.5.3-1+cuda11.8 libnvparsers-dev=8.5.3-1+cuda11.8 libnvonnxparsers-dev=8.5.3-1+cuda11.8 libnvinfer-samples=8.5.3-1+cuda11.8 libcudnn8-dev=8.9.7.29-1+cuda11.8 libcudnn8=8.9.7.29-1+cuda11.8

fi

apt install -y python3-dev python3-pip
ln -s /usr/bin/python3 /usr/bin/python

pip install requests packaging tabulate future xgboost numpy scikit-learn scipy seaborn pandas matplotlib jupyterlab "dask[complete]"

