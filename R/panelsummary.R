
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

  ## Defines the custom fixest glance_function which allows
  if (mean_dependent == T) {
    create_mean_fixest()
  }

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = output,
                                                                    fmt = fmt, estimate = estimate,
                                                                    vcov = vcov, conf_level = 0.95,
                                                                    exponentiate = exponentiate,
                                                                    stars = stars, coef_map = coef_map,
                                                                    gof_map = gof_map,
                                                                    gof_omit = gof_omit))
  print(panel_df)



  number_panels_minus_one <- num_panels -1

  ## getting number of rows per model:
  ## this helps to align where the pack_rows arguments will go.
  rows_per_model <- panel_df |>
    lapply(function(x) nrow(x)) |>
    as.vector()|>
    cumsum()

  if (collapse_fe == T & num_panels > 1) {
    for (i in 1:number_panels_minus_one) {
      panel_df[[i]] <- panel_df[[i]] |>
        dplyr::filter(!stringr::str_detect(term, "^FE"))
    }
    ## this will override the rows per model made before
    rows_per_model <- panel_df |>
      lapply(function(x) nrow(x)) |>
      as.vector()|>
      cumsum()
  }

  ## binding each of the data.frames together again and getting rid of NAs
  panel_df <- panel_df |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(where(is.character), ~stringr::str_replace_na(., replacement = "")))

  panel_df_cleaned <- panel_df |>
    dplyr::mutate(term = ifelse(statistic == "std.error", "", term)) |>
    dplyr::select(-part, -statistic)

  ## getting column names
  number_models <- ncol(panel_df_cleaned)
  number_models_minus_one <- number_models - 1
  if (is.null(colnames)){
    colnames <- c(" ", paste0("(",1:number_models_minus_one, ")"))
  }


  ## aligning models
  alignment <- paste(c("l", rep("c", number_models_minus_one)), collapse = "")

  table_initial <- kableExtra::kbl(panel_df_cleaned, col.names = colnames, align = alignment,
                caption = caption) |>
    kableExtra::kable_styling()


  ## adding the final panels to the kable object. This creates the panels
  table_final <- table_initial |>
    add_panels(num_panels = num_panels,
               panel_labels = panel_labels,
               rows_per_model = rows_per_model)


  return(table_final)
}









