#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
export CRAN=https://cloud.r-project.org/


if [ "$USE_ONEAPI" = "TRUE" ]; then

	source /opt/intel/oneapi/setvars.sh

	export MKL_INTERFACE_LAYER=GNU,LP64
	export MKL_THREADING_LAYER=GNU
	export CC="icx"
	export CXX="icpx"
	export F77="ifx"
	export F90="ifx"
	export FC="ifx"
	export CFLAGS="-g -fp-model strict -O3 -xHost"
	export CXXFLAGS="-g -fp-model strict -O3 -xHost"
	export FFLAGS="-g -fp-model strict -O3 -xHost"
	export FCFLAGS="-g -fp-model strict -O3 -xHost"
fi


curl -O https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz
tar -xzvf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
./configure  --with-blas --enable-R-shlib  --with-lapack  --with-tcltk  --enable-threads=posix --enable-memory-profiling --with-x=yes --with-cairo --with-jpeglib --with-readline --enable-R-profiling
make ; make install
echo 'options(repos=c(CRAN="https://cloud.r-project.org/"))' >>"${R_HOME}/etc/Rprofile.site"

if [ "$USE_ONEAPI" = "TRUE" ]; then

	# Link the MKL libraries to /lib/intel64
	mkdir -p /lib/intel64/ ; ln -s /opt/intel/oneapi/mkl/lastest/lib/* /lib/intel64/

	cd /usr/local/lib/R/lib
	mv libRblas.so libRblas.so.keep
	mv libRlapack.so libRlapack.so.keep
	ln -s ${MKLROOT}/lib/libmkl_rt.so libRblas.so
	ln -s ${MKLROOT}/lib/libmkl_rt.so libRlapack.so
fi

