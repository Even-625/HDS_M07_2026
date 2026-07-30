# M07 HDS Final Project

This repository contains the code and reproducibility materials for my HDS final project:

**Identifying Low Quality of Life among Older Adults in England Using Machine Learning: An Analysis of ELSA Wave 11**

The GitHub version includes the analysis scripts, README, output tables, and figures. The raw ELSA Wave 11 data and processed datasets are not uploaded because they are subject to UK Data Service access and licence restrictions.

## Data source

The data come from the English Longitudinal Study of Ageing (ELSA), Wave 11. The study page is available here:

https://datacatalogue.ukdataservice.ac.uk/studies/study/5050#details

![UK Data Service ELSA study page](pictures/data_access/data_access_01_study_page.png)

After signing in to the UK Data Service, add the study to your account. The data are listed as safeguarded, so users need to follow the UK Data Service licence conditions.

![Add ELSA study to UK Data Service account](pictures/data_access/data_access_02_add_to_account.png)

Download the TAB version of the dataset and unzip it locally. From the extracted `UKDA-5050-tab/tab/` folder, use the seven Wave 11 `.tab` files. The matching Wave 11 data dictionary Excel files are in the documentation folders, such as `mrdoc/excel/`.

![UK Data Service download options](pictures/data_access/data_access_03_download_options.png)

Place the seven Wave 11 TAB files and seven data dictionary Excel files in:

```text
data/wave11/
```

![Wave 11 files used locally](pictures/data_access/data_access_04_wave11_files.png)

## Running the scripts

Run the scripts in number order from a clean R session.

For the paired files `00_packages.R` / `00_packages.Rmd` and `02_functions.R` / `02_functions.Rmd`, use the `.R` files for execution or sourcing. The `.Rmd` versions were kept mainly for readable rendered output/HTML.

General order:

```text
00_packages.R
01_import_wave11.Rmd
02_functions.R
03_build_wave11_metadata.Rmd
04_variable_matching.Rmd
05_filter_analysis_sample.Rmd
06_outcome_casp19.Rmd
07_EDA01_base_features.Rmd
07_EDA02_additional_features.Rmd
07_EDA03_feature_screening.Rmd
08_model_development_training_only.Rmd
09_heldout_test_evaluation.Rmd
10_exploratory_lasso_weight_threshold.Rmd
11_exploratory_ensemble_analysis.Rmd
```

## Script overview

- `00_packages.R`: loads packages and sets shared paths.
- `01_import_wave11.Rmd`: imports the Wave 11 raw data files.
- `02_functions.R`: stores helper functions used by later scripts.
- `03_build_wave11_metadata.Rmd`: builds variable metadata and value-label information.
- `04_variable_matching.Rmd`: records how candidate variables were identified.
- `05_filter_analysis_sample.Rmd`: applies the main sample filters.
- `06_outcome_casp19.Rmd`: creates the CASP-19 score and binary low quality-of-life outcome.
- `07_EDA01_base_features.Rmd`: builds the first modelling dataset using selected base features.
- `07_EDA02_additional_features.Rmd`: adds further candidate predictors from Wave 11.
- `07_EDA03_feature_screening.Rmd`: screens features for missingness and sparse categories.
- `08_model_development_training_only.Rmd`: develops and tunes the machine learning models on the training data.
- `09_heldout_test_evaluation.Rmd`: evaluates the fixed models on the held-out test set.
- `10_exploratory_lasso_weight_threshold.Rmd`: checks class weights and decision thresholds for the LASSO model.
- `11_exploratory_ensemble_analysis.Rmd`: explores majority-voting ensembles across selected models.

## Folder overview

- `data/wave11/`: local folder for raw ELSA Wave 11 files and data dictionaries. Only a README placeholder is uploaded.
- `data/upload/`: manual input files used by the scripts, such as the preliminary feature-selection spreadsheet.
- `data/processed/`: local folder for generated intermediate datasets, model objects, and prediction files. Only a README placeholder is uploaded.
- `output/`: exported result tables.
- `pictures/`: figures used in the analysis and README.
- `script/`: R and R Markdown analysis scripts.
- `script/html/`: optional rendered HTML files, if generated locally.

## Notes

The full workflow requires authorised access to ELSA Wave 11. Files in `data/wave11/` and `data/processed/` are intentionally excluded from GitHub and should be regenerated or added locally by users with the appropriate data access.
