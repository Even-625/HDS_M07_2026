# 00_packages.R

# Purpose:
# Load all R packages used across the project and define common project paths.

# Inputs:
# None.

# Outputs:
# Shared path objects used by later scripts:
# - data_path
# - raw_upload_path
# - wave11_path
# - processed_path
# - output_path
# - picture_path

# Notes:
# This script does not install packages. Packages should be installed before
# running the final analysis scripts.

library(readr)
library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(writexl)
library(purrr)
library(tibble)
library(tidyr)
library(grid)
library(labelled)
library(here)
library(haven)
library(scales)
library(rsample)
library(forcats)
library(tidymodels)
library(yardstick)
library(glmnet)
library(ranger)
library(xgboost)
library(shapviz)
library(workflows)
library(recipes)
library(catboost)
library(nnet)
library(themis)
library(bonsai)
library(lightgbm)

# Prevent R from automatically converting character variables to factors when reading them
options(stringsAsFactors = FALSE)

data_path <- here::here("data")
raw_upload_path <- here::here("data", "upload")
wave11_path <- here::here("data", "wave11")
processed_path <- here::here("data", "processed")
output_path <- here::here("output")
picture_path <- here::here("pictures")

dir.create(processed_path, recursive = TRUE, showWarnings = FALSE)
dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
dir.create(picture_path, recursive = TRUE, showWarnings = FALSE)
