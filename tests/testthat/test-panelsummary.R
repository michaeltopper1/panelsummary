

test_that("panelsummary produces output with single arguments", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)


  models <- list(reg_1, reg_2, reg_3)

  gm <- tibble::tribble(
    ~raw,        ~clean,          ~fmt,
    "mean", "Mean of Dependent Variable", 3,
    "nobs",      "Observations",             0,
    "FE: gear", "FE: Gear", 0,
    "FE: carb", "FE: Carb", 0)


  expect_error(panelsummary(reg_1, reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T), regexp = NA)
})



test_that("panelsummary produces error if too many arguments in labels and only one model argument", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)


  models <- list(reg_1, reg_2, reg_3)

  gm <- tibble::tribble(
    ~raw,        ~clean,          ~fmt,
    "mean", "Mean of Dependent Variable", 3,
    "nobs",      "Observations",             0,
    "FE: gear", "FE: Gear", 0,
    "FE: carb", "FE: Carb", 0)


  expect_error(panelsummary(reg_1,  gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T))
})



test_that("panelsummary produces output with list argument and non-list argument", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)


  models <- list(reg_1, reg_2, reg_3)

  gm <- tibble::tribble(
    ~raw,        ~clean,          ~fmt,
    "mean", "Mean of Dependent Variable", 3,
    "nobs",      "Observations",             0,
    "FE: gear", "FE: Gear", 0,
    "FE: carb", "FE: Carb", 0)


  expect_error(panelsummary(list(reg_1, reg_2, reg_3), reg_1,  gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T), regexp = NA)
})


test_that("panelsummary actually produces output with lists as arguments", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)


  models <- list(reg_1, reg_2, reg_3)

  gm <- tibble::tribble(
    ~raw,        ~clean,          ~fmt,
    "mean", "Mean of Variable", 3,
    "nobs",      "Observations",             0,
    "FE: gear", "FE: Gear", 0,
    "FE: carb", "FE: Carb", 0)


  expect_error(panelsummary(list(reg_1, reg_2, reg_3), list(reg_3, reg_3), gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T), regexp = NA)
})
