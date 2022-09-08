
## might need a number of panels argument so they can also label
## num_panels
## panel_labels
panelsummary <- function(
    ...,
    num_panels = 1,
    panel_labels = NULL,
    mean_dependent = F,
    colnames = NULL,
    caption = NULL,
    format = NULL,
    collapse_fe = F,
    bold = F,
    italic = F,
    hline_after = F,
    hline_after_fe = T,
    fmt         = 3,
    estimate    = "estimate",
    statistic   = "std.error",
    vcov        = NULL,
    conf_level  = 0.95,
    exponentiate = FALSE,
    stars       = F,
    shape       = term + statistic ~ model,
    coef_map    = NULL,
    coef_omit   = NULL,
    coef_rename = NULL,
    gof_map     = NULL,
    gof_omit    = NULL) {


  models <- list(...)

  ## checks if the dimensions match. If not, returns error.
  check_dimensions_match(models, num_panels = num_panels)


  ## Defines the custom fixest glance_function which allows
  if (mean_dependent == T) {
    create_mean_fixest()
  }

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = "data.frame",
                                                                    fmt = fmt, estimate = estimate,
                                                                    vcov = vcov, conf_level = 0.95,
                                                                    exponentiate = exponentiate,
                                                                    stars = stars, coef_map = coef_map,
                                                                    gof_map = gof_map,
                                                                    gof_omit = gof_omit))


  ## getting number of rows per model:
  ## this helps to align where the pack_rows arguments will go.
  rows_per_model <- get_panel_indices(panel_df)

  if (collapse_fe == T & num_panels > 1) {

    ## removing fixed effects from all but the last panel
    panel_df <- panel_df |>
      remove_fe(num_panels)

    ## updating the rows_per_model
   rows_per_model <- get_panel_indices_collapse(panel_df, num_panels)

  }

  ## binding each of the data.frames together again and getting rid of NAs
  panel_df <- panel_df |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(where(is.character), ~stringr::str_replace_na(., replacement = "")))

  panel_df_cleaned <- panel_df |>
    dplyr::mutate(term = ifelse(statistic == "std.error", "", term)) |>
    dplyr::select(-part, -statistic)

  ## getting the number of columns/models in the dataframe
  number_models <- ncol(panel_df_cleaned)

  ## if no columnnames inputted, create defaults (1), (2), ... (n)
  if (is.null(colnames)){
    colnames <- create_column_names(number_models)
  }

  ## aligning models
  alignment <- create_alignment(number_models)


  table_initial <- kableExtra::kbl(panel_df_cleaned, col.names = colnames, align = alignment,
                                     caption = caption, format = format,
                                     booktabs = T)




  ## adding the final panels to the kable object. This creates the panels
  if (collapse_fe == T) {
    table_final <- table_initial |>
      add_panels_cfe(num_panels = num_panels,
                 panel_labels = panel_labels,
                 rows_per_model = rows_per_model,
                 bold = bold, italic = italic,
                 hline_after = hline_after,
                 hline_after_fe = hline_after_fe)
  } else{
    table_final <- table_initial |>
      add_panels(num_panels = num_panels,
                    panel_labels = panel_labels,
                    rows_per_model = rows_per_model,
                 bold = bold, italic = italic,
                 hline_after = hline_after)
  }



  return(table_final)
}









