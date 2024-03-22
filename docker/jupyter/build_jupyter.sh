#!/bin/bash

export JUPYTER_VER=3.10.10
SUFFIXES=("gpu" "cpu" "oneapi-gpu" "oneapi-cpu")

# Check if a command line argument was provided
if [ $# -eq 1 ]; then
    # Use only the provided suffix
    SUFFIXES=($1)
fi

for SUFFIX in "${SUFFIXES[@]}"; do
    podman build . -t jupyter:charlie-${JUPYTER_VER}-${SUFFIX} -f Dockerfile-jupyter-${JUPYTER_VER}-${SUFFIX}
    podman save jupyter:charlie-${JUPYTER_VER}-${SUFFIX} -o jupyter-${JUPYTER_VER}-${SUFFIX}.tar
    rm -f charliebox-jupyter_${JUPYTER_VER}-${SUFFIX}.sif
    apptainer build charliebox-jupyter_${JUPYTER_VER}-${SUFFIX}.sif docker-archive://jupyter-${JUPYTER_VER}-${SUFFIX}.tar
    rm -f jupyter-${JUPYTER_VER}-${SUFFIX}.tar
    mv charliebox-jupyter_${JUPYTER_VER}-${SUFFIX}.sif $HOME/mycontainers
done
