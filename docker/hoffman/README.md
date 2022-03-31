# Dockerfiles

These dockerfiles are built for use on Hoffman2

These images have been built and stored on OARC RTG's [Docker hub](https://hub.docker.com/orgs/oarcrtg)

These images can also be founded on Hoffman2 located at `$H2_CONTAINER_LOC`

Any questions on using these images can be submited though [Hoffman2 Support](https://support.idre.ucla.edu/helpdesk/Tickets/New) or email Charles at cpeterson@oarc.ucla.edu

## Base Build

These images have the basic compilers, libraries, MPI, etc needed to build applications

- Dockerfile-H2-build-ubuntu20.04-gcc8.5.0-oneapi2022.1.2
	- GCC: 8.5.0
	- OneAPI: 2022.12

- Dockerfile-H2-build-ubuntu20.04-gcc10.3.0-oneapi2022.1.2
	- GCC: 10.3.0
	- OneAPI: 2022.12

- Dockerfile-H2-build-ubuntu20.04-gcc10.3.0-OB0.3.20-OMPI4.1.2
	- GCC: 10.3.0
	- OpenBLAS: 0.3.20
	- OpenMPI: 4.1.2

## Base Run

This images have the basic runtime libraries

- Dockerfile-H2-run-ubuntu20.04-gcc8.5.0-oneapi2022.1.2
	- GCC: 8.5.0
	- OneAPI: 2022.12

- Dockerfile-H2-run-ubuntu20.04-gcc10.3.0-oneapi2022.1.2
	- GCC: 10.3.0
	- OneAPI: 2022.12

- Dockerfile-H2-run-ubuntu20.04-gcc10.3.0-OB0.3.20-OMPI4.1.2
        - GCC: 10.3.0
        - OpenBLAS: 0.3.20
        - OpenMPI: 4.1.2

## NWChem

These images have [NWChem](https://nwchemgit.github.io/)

- Dockerfile-H2-nwchem-7.0.2

## LAMMPS

[LAMMPS](https://www.lammps.org/)

- Dockerfile-H2-lammps-29Sep2021

You can customize you own build of LAMMPS by chaning the `lammps-cmake` file

## Opensees

[OpenSees](https://opensees.berkeley.edu/)

- Dockerfile-H2-openseesmp-3.3.0

## Rstudio

[Rstudio](https://www.rstudio.com/) server for Hoffman2

These rstudio images were built using [Rocker](https://www.rocker-project.org)

- Dockerfile-H2-rstudio-4.1.0
- Dockerfile-H2-rstudio-4.0.5

