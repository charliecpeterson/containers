# Repo of container file

## Singularity container

Ending in .def

## Docker images

Dockerfile-XXX


- base-centos7.def

CentOS 7 base container with Intel's oneapi toolkit, with HPC and AI toolkits

GCC 10.2.0

- base-ubuntu-20.04.def

Ubuntu 20.02 base container with Intel's oneapi toolkit, with HPC and AI toolkits

- nwchem-702.def

A Nwchem 7.0.2 container. (With modifing atomscf subroutine to increase number of basis functions)

Example for input file of water.nw

singularity run nwchem-702.sif mpirun nwchem water.nw > water.out

- rstudio-rocker-4.1.0.def

A Rstudio server container based on Rocker images.

Built for UCLA's Hoffman2 HPC resources

- of-9-h2.def

Container for OpenFoam version 9

To be ran on UCLA's Hoffman2 resource

- of-4-h2.def

Container for OpenFoam version 4

To be ran on UCLA's Hoffman2 resource


## Docker images

- Dockerfile-base-rocky8.5

Dockerfile to create rocky 8.5 with GCC and Intel's oneapi toolkit

- Dockerfile-nwchem-7.0.2

Dockerfile to build nwchem with the base-rocky8.5 image 


