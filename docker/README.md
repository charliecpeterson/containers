# Dockerfiles

## Base Build

These images have the basic compilers, libraries, MPI, etc needed to build applications

- Dockerfile-base-ubuntu20.04-gcc10.3.0-oneapi2021.4

This Dockerfile uses ubuntu 20.04 with GCC 10.3.0 and OneAPI 2021.4

- Dockerfile-base-rocky8.5-gcc10.3.0-oneapi2021.4

This Dockerfile uses Rocky linux 8.5 with GCC 10.3.0 and OneAPI 2021.4

## NWChem

These images have NWChem 

- Dockerfile-nwchem-7.0.2-ubuntu

NWchem 7.0.2 using docker://charliecpeterson:ubuntu20.04-gcc10.3.0-oneapi2021.4


- Dockerfile-nwchem-7.0.2-rocky

NWchem 7.0.2 using docker://charliecpeterson:rocky8.5-gcc10.3.0-oneapi2021.4


