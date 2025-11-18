context("Prediction Functions")

# Load the pre-trained model
m6a_model <- readRDS(system.file("extdata", "rf_fit.rds", package = "m6APrediction"))

test_that("prediction_single returns correct format", {
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
  expect_s3_class(single_result, "data.frame")
  expect_equal(nrow(single_result), 1)
  expect_equal(ncol(single_result), 2)
  expect_true(all(c("predicted_m6A_prob", "predicted_m6A_status") %in% colnames(single_result)))
})

test_that("prediction_multiple returns correct format", {
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
  
  expect_is(batch_results, "data.frame")
  expect_equal(nrow(batch_results), 2)
  expect_true("predicted_m6A_prob" %in% colnames(batch_results))
  expect_true("predicted_m6A_status" %in% colnames(batch_results))
})
