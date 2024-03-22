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

apt update ; apt install -y cuda-12-1 libnccl2 libnccl-dev tensorrt=8.6.1.6-1+cuda12.0 libcudnn8-dev=8.9.3.28-1+cuda12.1 libcudnn8=8.9.3.28-1+cuda12.1
fi

echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" > /etc/apt/sources.list.d/llvm-toolchain-jammy-17.list
echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list.d/llvm-toolchain-jammy-17.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

apt update ; apt-get install -y llvm-17 clang-17
wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
mv bazelisk-linux-amd64 /usr/local/bin/bazel
apt install -y libstdc++-12-dev


