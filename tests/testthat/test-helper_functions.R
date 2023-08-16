fixest::setFixest_nthreads(1)

test_that("row indices for each panel appear and are correct::fixest", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)
  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)

  models <- list(reg_1, reg_2, reg_3)

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = "data.frame"))
  truth <-  c(nrow(panel_df[[1]]), nrow(panel_df[[1]]) + nrow(panel_df[[2]]), nrow(panel_df[[1]]) + nrow(panel_df[[2]]) + nrow(panel_df[[3]]))
  function_output <- get_panel_indices(panel_df)

  expect_equal(function_output, truth)

})

test_that("row indices for each panel appear and are correct::lm", {
  reg_1 <- lm(mpg ~  cyl + gear + carb, data = mtcars)
  reg_2 <- lm(disp ~ cyl + gear + carb, data = mtcars)
  reg_3 <- lm(mpg ~  cyl + gear + carb + am, data = mtcars)

  models <- list(reg_1, reg_2, reg_3)

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = "data.frame"))
  truth <- c(nrow(panel_df[[1]]), nrow(panel_df[[1]]) + nrow(panel_df[[2]]), nrow(panel_df[[1]]) + nrow(panel_df[[2]]) + nrow(panel_df[[3]]))
  function_output <- get_panel_indices(panel_df)

  expect_equal(function_output, truth)

})


test_that("row indices for each panel appear and are correct::fixest with collapsed fe", {
  skip_on_cran()
  reg_mt1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  reg_mt2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)
  reg_mt3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)

  models <- list(reg_mt1, reg_mt2, reg_mt3)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = "data.frame",
                                                                    gof_omit ='DF|Deviance|R2|AIC|BIC|R',
                                                                    gof_map = gm))
  panel_df <- panel_df |>
    remove_fe(3)

  number_panels <-  3

  truth <- c(3, 6, 9, 11)

  function_output <- get_panel_indices_collapse(panel_df, number_panels)

  expect_equal(function_output, truth)

})
