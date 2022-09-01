library(fixest)

reg_1 <- mtcars |>
  feols(mpg ~  cyl | gear + carb, cluster = ~hp)

reg_2 <- mtcars |>
  feols(disp ~ cyl | gear + carb, cluster = ~hp)

reg_3 <- mtcars |>
  feols(mpg ~  cyl | gear + am, cluster = ~hp)

## might need a number of panels argument so they can also label
## num_panels
## panel_labels
panelsummary <- function(
    ...,
    output      = "data.frame",
    num_panels = 1,
    panel_labels = NULL,
    mean_dependent = F,
    colnames = NULL,
    caption = NULL,
    collapse_fe = F,
    fmt         = 3,
    estimate    = "estimate",
    statistic   = "std.error",
    vcov        = NULL,
    conf_level  = 0.95,
    exponentiate = FALSE,
    stars       = c('*' = .1, '**' = .05, '***' = .01),
    shape       = term + statistic ~ model,
    coef_map    = NULL,
    coef_omit   = NULL,
    coef_rename = NULL,
    gof_map     = NULL,
    gof_omit    = NULL) {



  models <- list(...)

  if (mean_dependent == T) {
    ### Defines the custom fixest glance function which allows mean of dependent variable
    glance_custom.fixest <- function(x, ...) {
      out <- data.frame("mean" = as.numeric(fitstat(x, type = "my")))
      return(out)
    }
  }


  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x, output = output,
                            fmt = fmt, estimate = estimate,
                            vcov = vcov, conf_level = 0.95, exponentiate = exponentiate, stars = stars, coef_map = coef_map,
                            gof_map = gof_map, gof_omit = gof_omit)) |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(where(is.character), ~stringr::str_replace_na(., replacement = "")))


  if (collapse_fe == T) {
    panel_df_cleaned <- panel_df |>
      dplyr::mutate(term = ifelse(statistic == "std.error", "", term)) |>
      dplyr::select(-part, -statistic)
  }
  panel_df_cleaned <- panel_df |>
    dplyr::mutate(term = ifelse(statistic == "std.error", "", term)) |>
    dplyr::select(-part, -statistic)

  ## getting number of rows per model:
  ## this helps to align where the pack_rows arguments will go.
  rows_per_model <- lapply(models, function(x) modelsummary::modelsummary(x, output = "data.frame",
                                                 fmt = fmt, estimate = estimate,
                                                 vcov = vcov, conf_level = 0.95, exponentiate = exponentiate, stars = stars, coef_map = coef_map,
                                                 gof_map = gof_map, gof_omit = gof_omit) |>
                          nrow()) |> as.vector() |> cumsum()


  ## getting column names
  number_models <- ncol(panel_df_cleaned) -1
  if (is.null(colnames)){
    colnames <- c(" ", paste0("(",1:number_models, ")"))
  }


  ## aligning models
  alignment <- paste(c("l", rep("c", number_models)), collapse = "")

  output <- kableExtra::kbl(panel_df_cleaned, col.names = colnames, align = alignment,
                caption = caption) |>
    kableExtra::kable_styling()

  if (num_panels == 1){
    output <- output
  }
  else if (num_panels == 2) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:",  panel_labels[1]), 1, rows_per_model[1], bold = F, italic = T) |>
      kableExtra::pack_rows(paste("Panel B:",  panel_labels[2]), rows_per_model[1] +1, rows_per_model[2], bold = F, italic = T, latex_gap_space = "0.5cm")
  }
  else if (num_panels == 3) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = F, italic = T) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] +1, rows_per_model[2], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] +1, rows_per_model[3], bold = F, italic = T, latex_gap_space = "0.5cm")
  }
  else if (num_panels == 4) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = F, italic = T) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] +1, rows_per_model[2], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] +1, rows_per_model[3], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] +1, rows_per_model[4], bold = F, italic = T, latex_gap_space = "0.5cm")
  }
  else if (num_panels == 5) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = F, italic = T) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] +1, rows_per_model[2], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] +1, rows_per_model[3], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] +1, rows_per_model[4], bold = F, italic = T, latex_gap_space = "0.5cm") |>
      kableExtra::pack_rows(paste("Panel E:", panel_labels[5]), rows_per_model[5] +1, rows_per_model[5], bold = F, italic = T, latex_gap_space = "0.5cm")
  }
  return(output)
}


## still need to make it so it works with 1 panel

gm <- tibble::tribble(
  ~raw,        ~clean,          ~fmt,
  "mean", "Mean of Dependent Variable", 3,
  "nobs",      "Observations",             0,
  "FE: gear", "FE: Gear", 0,
  "FE: carb", "FE: Carb", 0)





models <- list(reg_1, reg_2)
no_models <- length(models) -1
for (i in 1:100) {
  print(i)
}
for (i in 1:no_models) {
  print(modelsummary::modelsummary(models[i]))
}
gof_map.fixest
panelsummary(list(reg_1, reg_1, reg_3), list(reg_3, reg_3), gof_omit ='DF|Deviance|R2|AIC|BIC|R' , gof_map = gm,
             caption = "The Effect of cylinders on MPG and DISP", mean_dependent = T, num_panels = 2,
             coef_map = c("cyl" = "Cylinder"),
             panel_labels = c("MPG", "DISP"))

## this gets the number of fixed effects
map(list(reg_1, reg_2), ~.x |> fixest::fixef() |> length()) |>
  all_same()



## check if fixed effects are the same for collapsing purposes
all_same <- function(x) length(unique(x)) == 1
map(list(reg_1, reg_2), ~.x |>  fixest::fixef() |> names()) |>
  all_same()


## check fixed effects:
identical(reg_1 |>
  fixest::fixef() |>
  names(), reg_2 |>
    fixest::fixef() |>
    names())

all_same <- function(x) length(unique(x)) == 1
lenthreg_1$fixef_id
reg_2


glance_custom.fixest <- function(x, ...) {
  out <- data.frame("mean" = as.numeric(fitstat(x, type = "my")))
  return(out)
}
out <- data.frame(row.names = "firstrow")
for (n in reg_1$fixef_vars) {
  out[[paste('FE:', n)]] <- 'X'
}
glance_custom.fixest(reg_1)
as.numeric(fitstat(reg_1, type = "my"))



modelsummary(reg_1, gof_map = gm)
reg_1 |>
  fixef() |>
  names()
gof_map
## this is how to edit. looks like gop_map will provide ordering while gof_omit will still override which is great
modelsummary(reg_1, gof_map = modelsummary::gof_map |>
               add_row(raw = "mean", clean = "Mean of Dependent Variable", fmt = 3, omit = F, .before = 1) |>
               mutate(clean = ifelse(raw == "nobs", "Observations", clean)),
             gof_omit = 'DF|Deviance|R2|AIC|BIC|R')
get_gof(reg_1)
modelsummary(reg_1, output = "data.frame")
?gof_map
modelsummary::gof_map |>
  add_row(raw = "mean", clean = "Mean of Dependent Variable", fmt = 3, omit = F, .before = 1) |>
  mutate(clean = ifelse(raw == "nobs", "Observations", clean))

