library(m6APrediction)

# Load the pre-trained model from the package
m6a_model <- readRDS(system.file("extdata", "rf_fit.rds", package = "m6APrediction"))

if (!is.null(m6a_model)) {
  # --- Example 1: Predicting a Single Site ---
  
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
  
  
  # --- Example 2: Batch Prediction for Multiple Sites ---
  
  batch_data <- data.frame(
    gc_content = c(0.6, 0.4),
    RNA_type = c("mRNA", "lncRNA"),
    RNA_region = c("CDS", "intron"),
    exon_length = c(12, 9),
    distance_to_junction = c(2, 20),
    evolutionary_conservation = c(0.95, 0.15),
    DNA_5mer = c("AAGAC", "TGCAT")
  )
  
  batch_results <- prediction_multiple(
    ml_fit = m6a_model,
    feature_df = batch_data
  )
  
  print("Batch Prediction Results:")
  print(batch_results)
} else {
  print("Failed to load the pre-trained model.")
}
