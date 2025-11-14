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

Below is a brief guide on how to use the `m6APrediction` package. For more detailed examples, please refer to the package's documentation.

### Loading the Model

First, load the pre-trained Random Forest model provided with the package.

```r
library(m6APrediction)
library(randomForest)

# Load the pre-trained model
m6a_model <- readRDS(system.file("extdata", "rf_fit.rds", package = "m6APrediction"))
```

### Making Predictions

You can predict m6A sites for single or multiple instances.

- **Single Prediction**: Use `prediction_single()` for individual predictions by providing the required features.
- **Batch Prediction**: Use `prediction_multiple()` for batch predictions by passing a data frame with the necessary features.

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
