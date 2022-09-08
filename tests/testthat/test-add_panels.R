
test_that("add rows works with bold argument", {
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


  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T, num_panels = 2,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T, bold = T), regexp = NA)
})


test_that("add rows works with italic argument", {
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


  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T, num_panels = 2,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T, bold = T, italic = T), regexp = NA)
})


test_that("add rows works with bold argument/italic/hline", {
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


  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T, num_panels = 2,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            format = "latex",
                            collapse_fe = T, stars = T, bold = T, hline_after = F, hline_after_fe = T), regexp = NA)
})

