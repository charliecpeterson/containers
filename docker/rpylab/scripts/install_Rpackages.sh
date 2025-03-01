#!/bin/bash


R -q -e "sessionInfo()"
R -q -e 'install.packages(c("tidyverse", "palmerpenguins", "torchvision","luz","remotes","devtools","snow","future","reshape","microbenchmark","torch","curl", "RCurl", "jsonlite", "mice", "missForest", "dplyr", "ggplot2", "tidyr", "caret", "randomForest", "stringr", "tidymodels", "shiny", "e1071","nnet", "rpart", "xgboost", "glmnet"))'
R -q -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")))'
R -q -e 'torch::install_torch()'

