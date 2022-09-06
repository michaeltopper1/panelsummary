# library(fixest)
#
# reg_1 <- mtcars |>
#   feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#
# reg_2 <- mtcars |>
#   feols(disp ~ cyl | gear + carb, cluster = ~hp)
#
# reg_3 <- mtcars |>
#   feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)
#
#
# models <- list(reg_1, reg_2, reg_3)
#
# gm <- tibble::tribble(
#   ~raw,        ~clean,          ~fmt,
#   "mean", "Mean of Dependent Variable", 3,
#   "nobs",      "Observations",             0,
#   "FE: gear", "FE: Gear", 0,
#   "FE: carb", "FE: Carb", 0)
# #
# panelsummary(list(reg_1, reg_1, reg_3), list(reg_3, reg_3), gof_omit ='DF|Deviance|R2|AIC|BIC|R' , gof_map = gm,
#              caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T, num_panels = 2,
#              coef_map = c("cyl" = "Cylinder"),
#              panel_labels = c("MPG", "DISP"),
#              collapse_fe = F)
