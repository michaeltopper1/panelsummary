test_that("the check dimensions match function does what it's supposed to", {
  stuff <- list(list(c(1:10), c(1:10)), c(1:10))
  labels <- c("panel A", "panel B")
  expect_error(check_dimensions_match(stuff, labels), regexp = NA)
})
