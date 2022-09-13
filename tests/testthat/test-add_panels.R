
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
                            caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T,
                            coef_map = c("cyl" = "Cylinder"),
                            panel_labels = c("MPG", "DISP"),
                            format = "latex",
                            collapse_fe = T, stars = T, bold = T, hline_after = F, hline_before_fe = T), regexp = NA)
})

#
# test_that("add panels doesn't produce a null",{
#   reg_1 <- mtcars |>
#     fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#
#   reg_2 <- mtcars |>
#     fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)
#
#   reg_3 <- mtcars |>
#     fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)
#
#
#   models <- list(reg_1, reg_2, reg_3)
#   panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
#                                                                     output = "data.frame",
#                                                                     conf_level = 0.95))
#
#   rows_per_model <- get_panel_indices(panel_df)
#
#   panel_df <- panel_df |>
#     dplyr::bind_rows() |>
#     dplyr::mutate(dplyr::across(where(is.character), ~stringr::str_replace_na(., replacement = "")))
#
#   panel_df_cleaned <- panel_df |>
#     dplyr::mutate(term = ifelse(statistic == "std.error", "", term)) |>
#     dplyr::select(-part, -statistic)
#   number_models <- ncol(panel_df_cleaned)
#
#   ## if no columnnames inputted, create defaults (1), (2), ... (n)
#   if (is.null(colnames)){
#     colnames <- create_column_names(number_models)
#   }
#
#   alignment <- create_alignment(number_models)
#
#   table_initial <- kableExtra::kbl(panel_df_cleaned, align = alignment,
#                                    booktabs = T)
#   panel_labels <- c("MPG", "DISP", "MPG")
#   table_initial |> kableExtra::pack_rows(panel_labels[1], 1, rows_per_model[1],
#                                          bold = T,
#                                          italic = F,
#                                          hline_after = F)
#
#   for (i in seq_along(panel_labels)) {
#     print(panel_labels[i])}
# })
