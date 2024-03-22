#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
export CRAN=https://cloud.r-project.org/

source /opt/intel/oneapi/setvars.sh


R -q -e "sessionInfo()"
R -q -e 'install.packages(c("reticulate","torchvision","luz","remotes","devtools","snow","future","reshape","microbenchmark","torch","curl", "RCurl", "jsonlite", "mice", "missForest", "dplyr", "ggplot2", "tidyr", "caret", "randomForest", "stringr", "tidymodels", "shiny", "e1071","nnet", "rpart", "xgboost", "glmnet"))'
R -q -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")))'
R -q -e 'torch::install_torch()'

