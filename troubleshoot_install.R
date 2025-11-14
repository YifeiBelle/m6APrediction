# This script helps troubleshoot the installation of the m6APrediction package.
# It handles common issues like permission errors and package version conflicts
# by using a local library and unloading conflicting packages before installation.
#
# To use it, open your R console, set the working directory to the project root,
# and run: source("troubleshoot_install.R")

# --- Unload Conflicting Packages ---
# If a conflicting package is already loaded, unload it to prevent errors.
if ("devtools" %in% loadedNamespaces()) {
  unloadNamespace("devtools")
}
if ("fs" %in% loadedNamespaces()) {
  unloadNamespace("fs")
}
if ("cli" %in% loadedNamespaces()) {
  unloadNamespace("cli")
}

# --- Setup Local Library to avoid permission issues ---
# Create a local library path inside the project directory
local_lib_path <- file.path(getwd(), ".rlib")
if (!dir.exists(local_lib_path)) {
  dir.create(local_lib_path)
}

# Add the local library to the list of library paths for this R session
.libPaths(c(local_lib_path, .libPaths()))
message("Using temporary library for dependencies: ", local_lib_path)

# --- Install Dependencies ---
# We need devtools, which has dependencies like 'fs'.
# Installing it will place it and its dependencies in our new local library,
# avoiding permission errors and version conflicts.
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# --- Attempt Installation ---
# Now that dependencies are in a writable location and are the correct version,
# we can try installing the main package.

# Try to install from GitHub
tryCatch({
  print("Attempting to install m6APrediction from GitHub...")
  devtools::install_github("YifeiBelle/m6APrediction")
  print("Package installed successfully from GitHub.")
}, error = function(e) {
  print("GitHub installation failed. Attempting local installation...")
  print(paste("Error message:", e$message))
  
  # Install the package from the current directory
  tryCatch({
    devtools::install()
    print("Package installed successfully from local directory.")
  }, error = function(e_local) {
    print("Local installation also failed.")
    print(paste("Error message:", e_local$message))
  })
})
