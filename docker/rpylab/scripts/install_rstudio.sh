#!/bin/bash

## Download and install RStudio server & dependencies uses.
##

set -e

RSTUDIO_VERSION=${1:-${RSTUDIO_VERSION:-"stable"}}

wget https://download2.rstudio.org/server/rhel9/x86_64/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm
dnf install -y rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm

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
echo "options(bitmapType='cairo')" >> ${R_HOME}/etc/Rprofile.site
echo "Sys.setenv(PATH=\"$PATH\")" >> ${R_HOME}/etc/Rprofile.site
# Log to stderr
cat <<EOF >/etc/rstudio/logging.conf
[*]
log-level=warn
logger-type=syslog
EOF

echo "r-libs-user=~/R/APPTAINER/rstudio_${R_VERSION}" > /etc/rstudio/rsession.conf

cp /scripts/pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

for bin in /usr/lib/rstudio-server/bin/*; do ln -s "$bin" /usr/local/bin/; done

# Check the RStudio Server
echo -e "Check the RStudio Server version...\n"

rstudio-server version

echo -e "\nInstall RStudio Server, done!"


## CUDA environmental variables configuration for RStudio

## These should be exported as ENV vars too
if [ -n "$CUDA_HOME" ]; then

PATH={$PATH:-$PATH:$CUDA_HOME/bin}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-$LD_LIBRARY_PATH:$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64}

	echo "CUDA_HOME=$CUDA_HOME" >> ${R_HOME}/etc/Renviron.site

fi
if test -f /etc/rstudio/rserver.conf; then
  sed -i '/^rsession-ld-library-path/d' /etc/rstudio/rserver.conf
  echo "rsession-ld-library-path=$LD_LIBRARY_PATH" >> /etc/rstudio/rserver.conf
fi
#echo "PATH=$PATH" >> ${R_HOME}/etc/Renviron.site
touch /etc/rstudio/rsession.conf
echo "r-libs-user=~/R/APPTAINER/rstudio_${R_VERSION}" > /etc/rstudio/rsession.conf



