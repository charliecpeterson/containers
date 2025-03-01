#!/bin/bash

# Install all required libraries at once
dnf install -y sqlite-devel libcurl libcurl-devel vim less bzip2-devel bzip2 gcc g++ \
               glibc-locale-source glibc-langpack-en iproute pcre-devel pcre \
               pcre2-devel pcre2 java-11-openjdk-devel java-11-openjdk \
               libtiff-devel libtiff libicu-devel libicu libjpeg-turbo-devel \
               libjpeg-turbo openssl-devel wget ca-certificates make cmake \
               clang procps zlib-devel zlib git libomp-devel libffi-devel perl perl-FindBin \
               --allowerasing

dnf clean all 

if [ "$USE_ONEAPI" = "TRUE" ]; then
        export CC="icx"
        export CXX="icpx"
        export F77="ifx"
        export F90="ifx"
        export FC="ifx"
        export CFLAGS="-g -fp-model strict -O3"
        export CXXFLAGS="-g -fp-model strict -O3"
        export FFLAGS="-g -fp-model strict -O3"
        export FCFLAGS="-g -fp-model strict -O3"
fi

# Download, extract, and install Python
wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz
tar -vxf Python-${PYTHON_VER}.tgz
cd Python-${PYTHON_VER}
./configure --enable-optimizations --enable-shared
make && make install
cd ..
rm -rf Python-${PYTHON_VER} *.tgz

ln -s /usr/local/bin/pip3 /usr/local/bin/pip
ln -s /usr/local/bin/python3 /usr/local/bin/python

