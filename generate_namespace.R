# This script generates the NAMESPACE file from roxygen2 comments.
# This is a necessary step before building and installing the package.
if (!requireNamespace("roxygen2", quietly = TRUE)) {
  stop("The 'roxygen2' package is required but not installed. Please install it by running: install.packages('roxygen2')")
}
roxygen2::roxygenise()
