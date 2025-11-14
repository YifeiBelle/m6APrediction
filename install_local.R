# This script installs the m6APrediction package from the local directory.
# To use it, open your R console (e.g., in RStudio or the R GUI),
# set the working directory to the 'm6APrediction' folder, and then run:
# source("install_local.R")

# Check if devtools is installed, and install it if it's not
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install the package from the current directory
devtools::install()
