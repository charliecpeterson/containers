#!/bin/bash

R -q -e 'install.packages(c("keras","reticulate","remotes","devtools"))'
echo "options(rstudio.python.installationPath = \"/usr/local/bin/python\")" >> ${R_HOME}/etc/Rprofile.site
echo "RETICULATE_PYTHON=\"/usr/local/bin/python\"" >> ${R_HOME}/etc/Renviron

pip install jiver gradio typing-extensions

R -q -e 'remotes::install_github("rstudio/tensorflow")'
R -q -e 'devtools::install_github("IRkernel/IRkernel")'
R -q -e 'IRkernel::installspec(user = FALSE)'

