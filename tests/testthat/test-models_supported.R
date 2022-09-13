test_that("models_supported returns no errors", {
  expect_error(models_supported(), regexp = NA)
})
