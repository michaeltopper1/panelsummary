
test_that("add rows works with bold argument", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))


  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T, bold = T), regexp = NA)
})


test_that("add rows works with italic argument", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))

  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            collapse_fe = F, stars = T, bold = T, italic = T), regexp = NA)
})


test_that("add rows works with bold argument/italic/hline", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                         clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                         fmt = c(3, 0, 0 ,0))


  expect_error(panelsummary(list(reg_1), reg_2, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            format = "latex",
                            collapse_fe = T, stars = T, bold = T, hline_after = F, hline_before_fe = T), regexp = NA)
})

test_that("add gives error if too many panels", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)

  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))


  expect_error(panelsummary(list(reg_1), reg_2, reg_2, reg_1, reg_1, reg_1, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = NULL,
                            collapse_fe = F, stars = T, bold = T))
})

test_that("add gives error if too many panels- collapsed_fe", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)


  gm <- data.frame(raw = c("mean", "nobs", "FE: gear", "FE: carb"),
                   clean = c("Mean of Variable", "Observations", "FE: Gear", "FE: Carb"),
                   fmt = c(3, 0, 0 ,0))


  expect_error(panelsummary(list(reg_1), reg_2, reg_2, reg_1, reg_1, reg_1, gof_omit ='DF|Deviance|R2|AIC|BIC|R', gof_map = gm,
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = NULL,
                            collapse_fe = T, stars = T, bold = T))
})
