#!/bin/bash

dnf install -y epel-release
dnf install -y libcurl libcurl-devel --allowerasing
dnf install -y vim less bzip2-devel bzip2 \
               glibc-locale-source glibc-langpack-en \
               iproute  pcre-devel pcre pcre2-devel pcre2  \
               readline-devel libX11-devel libXt-devel libXt libxml2 libxml2-devel \
               java-11-openjdk-devel java-11-openjdk hdf5-devel \
               libtiff-devel libtiff libicu-devel libicu libjpeg-turbo-devel libjpeg-turbo \
               libpng12-devel libpng12 cairo-devel cairo glpk-devel glpk fftw-devel fftw bc \
               openssl-devel psmisc pwgen wget sudo ca-certificates \
               pandoc fribidi-devel fribidi harfbuzz-devel harfbuzz

if [ "$USE_ONEAPI" = "TRUE" ]; then
	export MKL_INTERFACE_LAYER=GNU,LP64
	export MKL_THREADING_LAYER=GNU
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


curl -O https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz
tar -xzvf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
./configure  --with-blas --enable-R-shlib  --with-lapack  --with-tcltk  --enable-threads=posix --enable-memory-profiling --with-x=yes --with-cairo --with-jpeglib --with-readline --enable-R-profiling
make ; make install
cd ..
rm -rf R-${R_VERSION}

echo 'options(repos=c(CRAN="https://cloud.r-project.org/"))' >>"${R_HOME}/etc/Rprofile.site"

if [ "$USE_ONEAPI" = "TRUE" ]; then

	# Link the MKL libraries to /lib/intel64
	mkdir -p /lib/intel64/ ; ln -s /opt/intel/oneapi/mkl/lastest/lib/* /lib/intel64/

	cd ${R_HOME}/lib
	mv libRblas.so libRblas.so.keep
	mv libRlapack.so libRlapack.so.keep
	ln -s ${MKLROOT}/lib/libmkl_rt.so libRblas.so
	ln -s ${MKLROOT}/lib/libmkl_rt.so libRlapack.so
fi


