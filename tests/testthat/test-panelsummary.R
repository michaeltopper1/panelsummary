

test_that("panelsummary produces output with single arguments", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 2)

  reg_2 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp, nthreads = 2)


  models <- list(reg_1, reg_1, reg_2)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))

  expect_error(panelsummary(reg_1, reg_1, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T), regexp = NA)
})



test_that("panelsummary produces error if too many arguments in labels and only one model argument", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 2)

  reg_2 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp, nthreads = 2)


  models <- list(reg_1, reg_1, reg_2)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))

  expect_error(panelsummary(reg_1,  gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T))
})



test_that("panelsummary produces output with list argument and non-list argument", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 2)

  reg_2 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp, nthreads = 2)


  models <- list(reg_1, reg_1, reg_2)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))

  expect_error(panelsummary(list(reg_1, reg_1, reg_2), reg_1,  gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T), regexp = NA)
})


test_that("panelsummary actually produces output with lists as arguments", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 2)

  reg_2 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp, nthreads = 2)


  models <- list(reg_1, reg_1, reg_2)


  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
             clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
             fmt = c(3, 0, 0 ,0))

  expect_error(panelsummary(list(reg_1, reg_1, reg_2), list(reg_2, reg_2), gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = T, stars = T), regexp = NA)
})

test_that("panelsummary actually produces an output with labels when panel_labels is NULL", {
  skip_on_cran()
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 2)

  reg_2 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp, nthreads = 2)


  models <- list(reg_1, reg_1, reg_2)


  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))
  expect_error(panelsummary(list(reg_1, reg_1, reg_2), list(reg_2, reg_2), gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            collapse_fe = F, stars = T), regexp = NA)
})
