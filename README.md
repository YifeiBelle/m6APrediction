---
title: "README"
output: html_document
---

# m6APrediction: An R Package for Predicting m6A Modification Sites

[![R-CMD-check](https://github.com/YifeiBelle/m6APrediction/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/YifeiBelle/m6APrediction/actions/workflows/R-CMD-check.yaml)

## Overview

`m6APrediction` is an R package that provides a toolkit for the prediction of N6-methyladenosine (m6A) modification sites in RNA. As the most abundant internal modification in eukaryotic mRNA, m6A plays a critical role in regulating gene expression. This package aims to provide an accessible and easy-to-use tool for researchers to apply a predictive model to their own data.

The core functionalities are:
-   **DNA Sequence Encoding**: A utility function to convert k-mer sequences into a factor-based format suitable for machine learning.
-   **Batch Prediction**: Apply a pre-trained random forest model to predict m6A status for a large dataset of candidate sites.
-   **Single Prediction**: Interactively predict the m6A status for a single site with specified features.

---

## Installation

You can install the development version of `m6APrediction` from GitHub using the `devtools` package:

```r
# If you haven't installed devtools yet:
# install.packages("devtools")

# Install the package
devtools::install_github("YifeiBelle/m6APrediction")