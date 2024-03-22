#!/bin/bash

## Download and install RStudio server & dependencies uses.
##
## In order of preference, first argument of the script, the RSTUDIO_VERSION variable.
## ex. stable, preview, daily, 1.3.959, 2021.09.1+372, 2021.09.1-372, 2022.06.0-daily+11

set -e

RSTUDIO_VERSION=${1:-${RSTUDIO_VERSION:-"stable"}}
#DEFAULT_USER=${DEFAULT_USER:-"rstudio"}
# shellcheck source=/dev/null
source /etc/os-release
export DEBIAN_FRONTEND=noninteractive
# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
    ca-certificates \
    lsb-release \
    file \
    git \
    libapparmor1 \
    libclang-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libobjc4 \
    libssl-dev \
    libpq5 \
    psmisc \
    procps \
    python-setuptools \
    pwgen \
    sudo \
    wget

ARCH=$(dpkg --print-architecture)


## Download RStudio Server for Ubuntu 18+
DOWNLOAD_FILE=rstudio-server.deb

if [ "$RSTUDIO_VERSION" = "latest" ]; then
    RSTUDIO_VERSION="stable"
fi

if [ "$UBUNTU_CODENAME" = "focal" ]; then
    UBUNTU_CODENAME="bionic"
fi

if [ "$RSTUDIO_VERSION" = "stable" ] || [ "$RSTUDIO_VERSION" = "preview" ] || [ "$RSTUDIO_VERSION" = "daily" ]; then
    if [ "$UBUNTU_CODENAME" = "bionic" ]; then
        UBUNTU_CODENAME="focal"
    fi
    wget "https://rstudio.org/download/latest/${RSTUDIO_VERSION}/server/${UBUNTU_CODENAME}/rstudio-server-latest-${ARCH}.deb" -O "$DOWNLOAD_FILE"
else
    wget "https://download2.rstudio.org/server/${UBUNTU_CODENAME}/${ARCH}/rstudio-server-${RSTUDIO_VERSION/"+"/"-"}-${ARCH}.deb" -O "$DOWNLOAD_FILE" ||
        wget "https://s3.amazonaws.com/rstudio-ide-build/server/${UBUNTU_CODENAME}/${ARCH}/rstudio-server-${RSTUDIO_VERSION/"+"/"-"}-${ARCH}.deb" -O "$DOWNLOAD_FILE"
fi

dpkg -i "$DOWNLOAD_FILE"
rm "$DOWNLOAD_FILE"

ln -fs /usr/lib/rstudio-server/bin/rstudio-server /usr/local/bin
ln -fs /usr/lib/rstudio-server/bin/rserver /usr/local/bin

# https://github.com/rocker-org/rocker-versioned2/issues/137
rm -f /var/lib/rstudio-server/secure-cookie-key

## RStudio wants an /etc/R, will populate from $R_HOME/etc
mkdir -p /etc/R

## Make RStudio compatible with case when R is built from source
## (and thus is at /usr/local/bin/R), because RStudio doesn't obey
## path if a user apt-get installs a package
R_BIN=$(which R)
echo "rsession-which-r=${R_BIN}" >/etc/rstudio/rserver.conf
echo "auth-timeout-minutes=600" >/etc/rstudio/rserver.conf
## use more robust file locking to avoid errors when using shared volumes:
echo "lock-type=advisory" >/etc/rstudio/file-locks

## Prepare optional configuration file to disable authentication
## To de-activate authentication, `disable_auth_rserver.conf` script
## will just need to be overwrite /etc/rstudio/rserver.conf.
## This is triggered by an env var in the user config
cp /etc/rstudio/rserver.conf /etc/rstudio/disable_auth_rserver.conf
echo "auth-none=1" >>/etc/rstudio/disable_auth_rserver.conf

## Set up RStudio init scripts
mkdir -p /etc/services.d/rstudio
cat <<"EOF" >/etc/services.d/rstudio/run
#!/usr/bin/with-contenv bash
## load /etc/environment vars first:
for line in $( cat /etc/environment ) ; do export $line > /dev/null; done
exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0
EOF

cat <<EOF >/etc/services.d/rstudio/finish
#!/bin/bash
/usr/lib/rstudio-server/bin/rstudio-server stop
EOF

# If CUDA enabled, make sure RStudio knows (config_cuda_R.sh handles this anyway)
if [ -n "$CUDA_HOME" ]; then
    sed -i '/^rsession-ld-library-path/d' /etc/rstudio/rserver.conf
    echo "rsession-ld-library-path=$LD_LIBRARY_PATH" >>/etc/rstudio/rserver.conf
fi

# Set the default bitmapType to 'cairo'
echo "options(bitmapType='cairo')" >> /usr/local/lib/R/etc/Rprofile.site
echo "options(rstudio.python.installationPath = \"/usr/local/bin/python\")" >> /usr/local/lib/R/etc/Rprofile.site
# Log to stderr
cat <<EOF >/etc/rstudio/logging.conf
[*]
log-level=warn
logger-type=syslog
EOF

echo "r-libs-user=~/R/APPTAINER/rstudio_${R_VERSION}" > /etc/rstudio/rsession.conf

cp /scripts/pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

# Clean up
rm -rf /var/lib/apt/lists/*

# Check the RStudio Server
echo -e "Check the RStudio Server version...\n"

rstudio-server version

echo -e "\nInstall RStudio Server, done!"


## CUDA environmental variables configuration for RStudio

## These should be exported as ENV vars too
if [ -n "$CUDA_HOME" ]; then

PATH={$PATH:-$PATH:$CUDA_HOME/bin}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-$LD_LIBRARY_PATH:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64}
NVBLAS_CONFIG_FILE=${NVBLAS_CONFIG_FILE:-/etc/nvblas.conf}

## cli R inherits these, but RStudio needs to have these set in as follows:
## (From https://tensorflow.rstudio.com/tools/local_gpu.html#environment-variables)
	echo "CUDA_HOME=$CUDA_HOME" >> ${R_HOME}/etc/Renviron.site
	echo "PATH=$PATH" >> ${R_HOME}/etc/Renviron.site

## Configure R & RStudio to use drop-in CUDA blas
## Allow R to use CUDA for BLAS, with fallback on openblas
## NOTE: NVBLAS_CPU_BLAS_LIB must be correct for UBUNTU_VERSION selected in scripts/install_R.sh#L25
        echo 'NVBLAS_LOGFILE /var/log/nvblas.log
        NVBLAS_CPU_BLAS_LIB /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
        NVBLAS_GPU_LIST ALL' > /etc/nvblas.conf

        echo "NVBLAS_CONFIG_FILE=$NVBLAS_CONFIG_FILE" >> ${R_HOME}/etc/Renviron.site
## nvblas configuration
        touch /var/log/nvblas.log && chown :staff /var/log/nvblas.log
        chmod a+rw /var/log/nvblas.log

fi
if test -f /etc/rstudio/rserver.conf; then
  sed -i '/^rsession-ld-library-path/d' /etc/rstudio/rserver.conf
  echo "rsession-ld-library-path=$LD_LIBRARY_PATH" >> /etc/rstudio/rserver.conf
fi

touch /etc/rstudio/rsession.conf
echo "r-libs-user=~/R/APPTAINER/rstudio_${R_VERSION}" > /etc/rstudio/rsession.conf


