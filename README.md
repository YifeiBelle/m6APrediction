# m6APrediction: An R Package for Predicting m6A Modification Sites

[![R-CMD-check](https://github.com/YifeiBelle/m6APrediction/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/YifeiBelle/m6APrediction/actions/workflows/R-CMD-check.yaml)

## Overview

`m6APrediction` is an R package that provides a robust toolkit for the prediction of N6-methyladenosine (m6A) modification sites in RNA. As the most abundant internal modification in eukaryotic mRNA, m6A plays a critical role in regulating gene expression, from RNA splicing and export to stability and translation. This package provides an accessible and easy-to-use tool for researchers to apply a pre-trained Random Forest model to their own data, facilitating the identification of potential m6A sites for further investigation.

---

## Features

*   **DNA Sequence Encoding**: Includes a utility function to convert k-mer DNA sequences into a numerical format suitable for machine learning models.
*   **Batch Prediction**: Apply the pre-trained random forest model to predict m6A status for a large dataset of candidate sites, returning probabilities and final classifications.
*   **Single Prediction**: Interactively predict the m6A status for a single site by providing its specific features.
*   **Pre-trained Model**: Comes with a pre-trained Random Forest model (`rf_fit.rds`) for immediate use.

---

## Installation

You can install the development version of `m6APrediction` from GitHub using the `devtools` package:

```r
# If you haven't installed devtools yet:
# install.packages("devtools")

# Install the package
devtools::install_github("YifeiBelle/m6APrediction")
```

---

## Usage

Here is a practical example of how to use the `m6APrediction` package to get predictions for single and multiple RNA sites.

### Step 1: Load the Package and the Model

First, load the package and the pre-trained Random Forest model included with the project.

```r
library(m6APrediction)
library(randomForest)

# Load the pre-trained model
# Make sure the path to 'rf_fit.rds' is correct
m6a_model <- readRDS("rf_fit.rds") 
```

### Step 2: Predict a Single Site

Use the `prediction_single()` function for quick, interactive predictions on one site. You need to provide all the required features as arguments.

```r
single_result <- prediction_single(
  ml_fit = m6a_model,
  gc_content = 0.55,
  RNA_type = "mRNA",
  RNA_region = "3'UTR",
  exon_length = 10,
  distance_to_junction = 5,
  evolutionary_conservation = 0.8,
  DNA_5mer = "GGACA"
)

print("Single Prediction Result:")
print(single_result)
```

### Step 3: Predict Multiple Sites in Batch

For larger datasets, use the `prediction_multiple()` function. You need to prepare a data frame where each row represents a site and columns correspond to the required features.

```r
# Create a data frame with new data to predict
batch_data <- data.frame(
  gc_content = c(0.6, 0.4),
  RNA_type = c("mRNA", "lncRNA"),
  RNA_region = c("CDS", "intron"),
  exon_length = c(12, 9),
  distance_to_junction = c(2, 20),
  evolutionary_conservation = c(0.95, 0.15),
  DNA_5mer = c("AAGAC", "TGCAT")
)

# Get batch predictions
batch_results <- prediction_multiple(
  ml_fit = m6a_model,
  feature_df = batch_data
)

print("Batch Prediction Results:")
print(batch_results)
```

---

## Input Data Format

The prediction functions require a `data.frame` with the following specific columns:

*   `gc_content` (numeric): The GC content of the sequence region.
*   `RNA_type` (character or factor): The type of RNA. Must be one of: `"mRNA"`, `"lincRNA"`, `"lncRNA"`, `"pseudogene"`.
*   `RNA_region` (character or factor): The region of the RNA. Must be one of: `"CDS"`, `"intron"`, `"3'UTR"`, `"5'UTR"`.
*   `exon_length` (numeric): The length of the exon.
*   `distance_to_junction` (numeric): The distance to the nearest splice junction.
*   `evolutionary_conservation` (numeric): A score representing the evolutionary conservation of the site.
*   `DNA_5mer` (character): The 5-base-pair DNA sequence (k-mer) centered on the site.
