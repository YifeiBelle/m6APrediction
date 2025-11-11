library(m6APrediction)

# In a real scenario, you would load your powerful, pre-trained model like this:
# my_model <- readRDS("path/to/your/rf_fit.rds")

# For this example, we create a dummy model so the code can run:
if (requireNamespace("randomForest", quietly = TRUE)) {
  dummy_data <- data.frame(matrix(rnorm(220), 20, 11))
  colnames(dummy_data) <- c("gc_content", "RNA_type", "RNA_region", "exon_length",
                            "distance_to_junction", "evolutionary_conservation",
                            "nt_pos1", "nt_pos2", "nt_pos3", "nt_pos4", "nt_pos5")
  dummy_data$outcome <- factor(sample(c("Positive", "Negative"), 20, replace = TRUE))
  dummy_rf_model <- randomForest::randomForest(outcome ~ ., data = dummy_data, ntree = 10)
  
  
  # --- Example 1: Predicting a Single Site ---
  
  single_result <- prediction_single(
    ml_fit = dummy_rf_model,
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
    ml_fit = dummy_rf_model,
    feature_df = batch_data
  )
  
  print("Batch Prediction Results:")
  print(batch_results)
}