# Repo of container file

- oneapi.def

container with Intel's oneapi toolkit, with HPC and AI toolkits

- nwchem-702.def

A Nwchem 7.0.2 container. (With modifing atomscf subroutine to increase number of basis functions)

Example for input file of water.nw

singularity run nwchem-702.sif mpirun nwchem water.nw > water.out

- rstudio-rocker-4.1.0.def

A Rstudio server container based on Rocker images.

Built for UCLA's Hoffman2 HPC resources

