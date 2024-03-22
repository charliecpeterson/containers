#!/bin/bash

export RSTUDIO_VER=4.3.3
SUFFIXES=("gpu" "cpu" "oneapi-gpu" "oneapi-cpu")

# Check if a command line argument was provided
if [ $# -eq 1 ]; then
    # Use only the provided suffix
    SUFFIXES=($1)
fi

for SUFFIX in "${SUFFIXES[@]}"; do
    podman build . -t rstudio:charlie-${RSTUDIO_VER}-${SUFFIX} -f Dockerfile-rstudio-${RSTUDIO_VER}-${SUFFIX}
    podman save rstudio:charlie-${RSTUDIO_VER}-${SUFFIX} -o rstudio-${RSTUDIO_VER}-${SUFFIX}.tar
    rm -f charliebox-rstudio_${RSTUDIO_VER}-${SUFFIX}.sif
    apptainer build charliebox-rstudio_${RSTUDIO_VER}-${SUFFIX}.sif docker-archive://rstudio-${RSTUDIO_VER}-${SUFFIX}.tar
    rm -f rstudio-${RSTUDIO_VER}-${SUFFIX}.tar
    mv charliebox-rstudio_${RSTUDIO_VER}-${SUFFIX}.sif $HOME/mycontainers
done
