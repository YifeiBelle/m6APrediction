# This script will update the 'fs' package and then install the 'm6APrediction' package.
# Please run this script from your R console or RStudio.

# Update the 'fs' package
install.packages('fs', repos='http://cran.rstudio.com/')

# Install the 'm6APrediction' package from GitHub
# Make sure you have the 'devtools' and 'randomForest' packages installed.
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
if (!requireNamespace("randomForest", quietly = TRUE)) {
  install.packages("randomForest")
}
devtools::install_github("YifeiBelle/m6APrediction")

print("Installation process finished.")
