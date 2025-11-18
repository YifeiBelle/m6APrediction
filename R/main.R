# ===================================================================
# Main Source File for the m6APrediction Package
# ===================================================================
# Author: [Your Name]
# Date: [Current Date]
# Description:
#   This script contains the core functions for the m6APrediction
#   package. It includes utilities for encoding DNA sequences and applying
#   a pre-trained model to predict m6A modification status.
# ===================================================================


#' Encode DNA Sequences into a Factor-Based Data Frame
#'
#' @description
#' This function is a preprocessing utility that converts a character vector of
#' equal-length DNA sequences (e.g., k-mers) into a data frame suitable for
#' use in machine learning models. Each position in the sequence is transformed
#' into a separate column, and the nucleotide at that position is represented
#' as a factor with predefined levels ("A", "T", "C", "G"). This ensures
#' consistent encoding for model training and prediction.
#'
#' @param dna_strings A character vector where each element is a DNA sequence.
#'   It is crucial that all sequences in the vector have the same length.
#'
#' @return A `data.frame` where each row corresponds to an input DNA sequence.
#'   The columns are named `nt_pos1`, `nt_pos2`, etc., representing each
#'   position in the sequence.
#'
#' @export
#'
#' @examples
#' # Example with a vector of 5-mers
#' sequences <- c("GGACA", "ATTGC", "CCTAG")
#' encoded_data <- dna_encoding(sequences)
#'
#' # View the structure of the output
#' str(encoded_data)
#'
#' # View the first few rows
#' head(encoded_data)
#'
dna_encoding <- function(dna_strings) {
  # Get the length of the sequences from the first element
  sequence_length <- nchar(dna_strings[1])
  
  # Split all strings into a single vector of characters
  split_chars <- unlist(strsplit(dna_strings, ""))
  
  # Arrange the characters into a matrix where each row is a sequence
  sequence_matrix <- matrix(split_chars, ncol = sequence_length, byrow = TRUE)
  
  # Assign column names based on position
  colnames(sequence_matrix) <- paste0("nt_pos", 1:sequence_length)
  
  # Convert the matrix to a data frame
  sequence_df <- as.data.frame(sequence_matrix)
  
  # Convert all columns to factors with consistent levels for modeling
  sequence_df[] <- lapply(sequence_df, factor, levels = c("A", "T", "C", "G"))
  
  return(sequence_df)
}


#' Predict m6A Modification Status for a Batch of Sites
#'
#' @description
#' This is the primary batch prediction function. It takes a pre-trained
#' machine learning model and a data frame of new candidate sites, then returns
#' the data frame augmented with prediction probabilities and final class predictions.
#'
#' @param ml_fit A pre-trained model object that has a `predict` method
#'   (e.g., an object of class `randomForest`). The model must have been trained
#'   on predictors with the same names and data types as those in `feature_df`.
#' @param feature_df A `data.frame` containing the feature data for the sites
#'   to be predicted. It must include the following columns:
#'   \itemize{
#'     \item `gc_content` (numeric)
#'     \item `RNA_type` (character or factor)
#'     \item `RNA_region` (character or factor)
#'     \item `exon_length` (numeric)
#'     \item `distance_to_junction` (numeric)
#'     \item `evolutionary_conservation` (numeric)
#'     \item `DNA_5mer` (character)
#'   }
#' @param positive_threshold A numeric value between 0 and 1. The probability
#'   threshold for classifying a site as "Positive". Defaults to 0.5.
#'
#' @return The original input `feature_df` with two new columns appended:
#'   \item{`predicted_m6A_prob`}{The predicted probability of the site being "Positive".}
#'   \item{`predicted_m6A_status`}{The final predicted class ("Positive" or "Negative") based on the threshold.}
#'
#' @importFrom stats predict
#' @export
#'
#' @examples
#' # This is a conceptual example, as it requires a pre-trained model object.
#' # In a real use case, `my_rf_model` would be loaded from a file.
#' \dontrun{
#' # Load your pre-trained model
#' my_rf_model <- readRDS("path/to/your/rf_fit.rds")
#'
#' # Create a data frame with new data to predict
#' new_data <- data.frame(
#'   gc_content = c(0.55, 0.45),
#'   RNA_type = c("mRNA", "lncRNA"),
#'   RNA_region = c("3'UTR", "intron"),
#'   exon_length = c(10, 15),
#'   distance_to_junction = c(5, 8),
#'   evolutionary_conservation = c(0.8, 0.1),
#'   DNA_5mer = c("GGACU", "AAUGC")
#' )
#'
#' # Get predictions
#' results <- prediction_multiple(ml_fit = my_rf_model, feature_df = new_data)
#' print(results)
#' }
#'
prediction_multiple <- function(ml_fit, feature_df, positive_threshold = 0.5) {
  # Check for the presence of all required columns
  required_cols <- c("gc_content", "RNA_type", "RNA_region", "exon_length",
                     "distance_to_junction", "evolutionary_conservation", "DNA_5mer")
  if (!all(required_cols %in% colnames(feature_df))) {
    stop("The input data frame is missing one or more required columns.")
  }
  
  # Ensure categorical predictors are factors with the correct levels
  feature_df$RNA_type <- factor(feature_df$RNA_type, levels = c("mRNA", "lincRNA", "lncRNA", "pseudogene"))
  feature_df$RNA_region <- factor(feature_df$RNA_region, levels = c("CDS", "intron", "3'UTR", "5'UTR"))
  
  # Encode the DNA k-mer sequence
  encoded_dna <- dna_encoding(feature_df$DNA_5mer)
  
  # Combine all features into the final data frame for prediction
  # The column order and names must match the model's training data
  model_input <- cbind(
    feature_df[, c("gc_content", "RNA_type", "RNA_region", "exon_length",
                   "distance_to_junction", "evolutionary_conservation")],
    encoded_dna
  )
  
  # Use the model to predict the probability of the "Positive" class
  # Note: `stats::` prefix ensures the generic `predict` from the stats package is used.
  prediction_probabilities <- stats::predict(ml_fit, model_input, type = "prob")[, "Positive"]
  
  # Append results to the original data frame
  feature_df$predicted_m6A_prob <- round(prediction_probabilities, 3)
  feature_df$predicted_m6A_status <- ifelse(prediction_probabilities >= positive_threshold, "Positive", "Negative")
  
  return(feature_df)
}


#' Predict m6A Status for a Single Site
#'
#' @description
#' A wrapper function for making a prediction on a single candidate site by
#' providing its features as individual arguments. This is particularly useful
#' for interactive applications (e.g., Shiny apps) or for quick tests.
#'
#' @param ml_fit A pre-trained model object (e.g., of class `randomForest`).
#' @param gc_content Numeric value for the GC content.
#' @param RNA_type Character string for the RNA type (e.g., "mRNA").
#' @param RNA_region Character string for the RNA region (e.g., "CDS").
#' @param exon_length Numeric value for the exon length.
#' @param distance_to_junction Numeric value for the distance to a splice junction.
#' @param evolutionary_conservation Numeric value for the conservation score.
#' @param DNA_5mer A 5-character string for the DNA sequence motif.
#' @param positive_threshold The numeric probability threshold (0-1) to classify
#'   a site as "Positive". Defaults to 0.5.
#'
#' @return A `data.frame` with one row and two columns:
#'   `predicted_m6A_prob` and `predicted_m6A_status`.
#'
#' @importFrom stats predict
#' @export
#'
#' @examples
#' # This is a conceptual example, as it requires a pre-trained model object.
#' \dontrun{
#' # Load your pre-trained model
#' my_rf_model <- readRDS("path/to/your/rf_fit.rds")
#'
#' # Predict a single site
#' single_result <- prediction_single(
#'   ml_fit = my_rf_model,
#'   gc_content = 0.5,
#'   RNA_type = "mRNA",
#'   RNA_region = "CDS",
#'   exon_length = 12,
#'   distance_to_junction = 3,
#'   evolutionary_conservation = 0.9,
#'   DNA_5mer = "AGACU"
#' )
#'
#' print(single_result)
#' }
#'
prediction_single <- function(ml_fit, gc_content, RNA_type, RNA_region, exon_length,
                              distance_to_junction, evolutionary_conservation, DNA_5mer,
                              positive_threshold = 0.5) {
  
  # Create a one-row data frame from the input arguments
  feature_df <- data.frame(
    gc_content = gc_content,
    RNA_type = RNA_type,
    RNA_region = RNA_region,
    exon_length = exon_length,
    distance_to_junction = distance_to_junction,
    evolutionary_conservation = evolutionary_conservation,
    DNA_5mer = DNA_5mer,
    stringsAsFactors = FALSE # Important for character columns
  )
  
  # Use the batch prediction function to handle the encoding and prediction
  # This avoids code duplication and ensures consistency
  prediction_result_df <- prediction_multiple(
    ml_fit = ml_fit,
    feature_df = feature_df,
    positive_threshold = positive_threshold
  )
  
  # Extract the relevant columns to return
  final_result <- prediction_result_df[, c("predicted_m6A_prob", "predicted_m6A_status")]
  
  return(final_result)
}
