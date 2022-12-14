

test_that("panelsummary_raw returns a data.frame, not other object", {
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  table <- panelsummary::panelsummary_raw(ols_1, ols_2)
  expect_equal(class(table), "data.frame")
})


test_that("panelsummary_raw returns a data.frame, not other object when using lists as inputs", {
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  table <- panelsummary::panelsummary_raw(list(ols_1, ols_1), ols_2)
  expect_equal(class(table), "data.frame")
})


test_that("panelsummary_raw does not generate an error when ran with other arguments", {
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  expect_error(panelsummary::panelsummary_raw(ols_1, ols_2,
                                              mean_dependent = T,
                                              stars = "econ"), regexp = NA)
})
