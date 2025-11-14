# This script runs the R CMD check on the package to identify issues.
# It mimics the command run in the GitHub Actions workflow.

# Install rcmdcheck if it's not already installed
if (!requireNamespace("rcmdcheck", quietly = TRUE)) {
  install.packages("rcmdcheck")
}

# Run the check
# The arguments match the GitHub workflow to ensure consistency.
# The check will fail on any warning, helping us catch issues early.
check_results <- rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")

# Print the results to the console
print(check_results)
