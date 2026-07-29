# Script order

This folder contains the main analysis scripts for the HDS final project:

**Identifying Low Quality of Life among Older Adults in England Using Machine Learning: An Analysis of ELSA Wave 11**

The scripts are numbered in the order I used them. In general, they should be run from `00` to `11` in a clean R session. The raw ELSA Wave 11 data are not included here because access is restricted.

## GitHub upload note

For the GitHub version, I only include the project README, analysis scripts, exported result tables, and figures. The folders `data/wave11/` and `data/processed/` are kept locally and are not uploaded to GitHub. They contain the restricted ELSA Wave 11 raw files and intermediate analysis datasets, so they should not be shared publicly.

## Project folders

### data/

Stores the data files used or created during the analysis.

- `data/wave11/` contains the original ELSA Wave 11 files and data dictionaries. These files are access-restricted and should not be shared publicly.
- `data/upload/` contains manually prepared input files used by the scripts, such as the preliminary feature-selection spreadsheet.
- `data/processed/` contains intermediate datasets, model objects, train/test split IDs, and prediction files created by the scripts.

### output/

Contains exported result tables, mostly Excel files. These include sample summaries, feature-screening outputs, model performance tables, model-selection results, and exploratory threshold or ensemble results.

### pictures/

Contains figures produced during the analysis, such as CASP-19 distributions, sample plots, feature-importance plots, and the ensemble correlation heatmap.

### script/

Contains the R and R Markdown scripts for the full workflow. The scripts are numbered so the order is easier to follow.

### script/html/

Contains rendered HTML versions of some R Markdown files. These are useful for reading the analysis output without re-running every script.


## Files

### 00_packages.R

Loads the R packages used across the project and sets up the main folder paths. This file is sourced by later scripts.

### 00_packages.Rmd

A readable version of the package and path setup file.

### 01_import_wave11.Rmd

Imports the ELSA Wave 11 raw files and prepares the first saved version of the dataset used in the project.

### 02_functions.R

Contains helper functions used by later scripts, including functions for metadata handling, labels, feature checks, and exports.

### 02_functions.Rmd

A readable version of the helper functions file.

### 03_build_wave11_metadata.Rmd

Builds variable metadata and value-label information from the Wave 11 files. This makes it easier to search and understand variables before modelling.

### 04_variable_matching.Rmd

Records how candidate variables were identified and matched from the ELSA Wave 11 metadata.

### 05_filter_analysis_sample.Rmd

Creates the final analysis sample by applying the main inclusion criteria and cleaning key sample variables.

### 06_outcome_casp19.Rmd

Constructs the CASP-19 quality-of-life score and defines the binary low quality-of-life outcome used for modelling.

### 07_EDA01_base_features.Rmd

Builds the first version of the modelling dataset using the selected base features.

### 07_EDA02_additional_features.Rmd

Searches for and adds further candidate predictors from Wave 11, then combines them with the base feature set.

### 07_EDA03_feature_screening.Rmd

Screens candidate features for missingness and sparse categories, then saves the cleaned modelling dataset used in the machine learning scripts.

### 08_model_development_training_only.Rmd

Develops and compares the machine learning models using the training data only. This includes model tuning, feature importance checks, and selecting models for later evaluation.

### 09_heldout_test_evaluation.Rmd

Evaluates the fixed models on the held-out test set and saves the prediction results.

### 10_exploratory_lasso_weight_threshold.Rmd

Runs an exploratory check of class weights and decision thresholds for the LASSO logistic regression model.

### 11_exploratory_ensemble_analysis.Rmd

Explores whether majority-voting ensembles of the selected models improve the final prediction results.

### html/

Contains rendered HTML versions of some R Markdown scripts, if available.
