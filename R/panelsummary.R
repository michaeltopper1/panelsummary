
#' Create a regression table with multiple panels
#'
#' @param ... A regression model or models (see panelsummary::models_supported for classes that are supported). The regression model can be a list of models or a singular object. If a list is passed in, one column for each list is created. Each argument will correspond to a panel.
#' @param num_panels A numeric. The number of panels in the regression table. Note that this should match with the number of arguments passed into `...`.
#' @param mean_dependent A boolean.
#'    * `FALSE` (the default): the mean of the dependent variable will not be shown in the resulting table.
#'    * `TRUE`: the mean of the dependent variable will be shown in the resulting table.
#' @param colnames An optional vector of strings. The vector of strings should have the same length as the number columns of the table.
#'    * `NULL` (the default): colnames are defaulted to a whitespace, followed by (1), (2), ....etc.
#' @inheritParams kableExtra::caption
#' @inheritParams kableExtra::format
#'
#' @param collapse_fe A boolean. Determines whether fixed effects should only be included in the bottom of the table. This is suited for when each panel has the same models with the same fixed effects.
#'    * `FALSE` (the default): fixed effects are shown in each panel.
#'    * `TRUE`: fixed effects are shown only at the bottom of the final panel, separated by a horizontal line (see hline_before_fe)
#' @param bold A boolean. Determines whether the panel names should be in bold font.
#'    * `FALSE` (the default): the panel names are not in bold.
#'    * `TRUE`: the panel names are bolded
#'
#' @param italic A boolean. Determines whether the panel names should be in italics.
#'    * `FALSE` (the default): the panel names are not in italics.
#'    * `TRUE`: the panel names will be in italics.
#'
#'
#'



panelsummary <- function(
    ...,
    num_panels = 1,
    panel_labels = NULL,
    mean_dependent = FALSE,
    colnames = NULL,
    caption = NULL,
    format = NULL,
    collapse_fe = F,
    bold = FALSE,
    italic = FALSE,
    hline_after = FALSE,
    hline_before_fe = TRUE,
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
    # warning("fixest will always output a mean until glance_custom.fixest is removed from the global environment")
    ## creating the custom glance function
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

  ## omits the custom fixest from the global environment so no warning necessary
  if (isTRUE(mean_dependent)) {
    rm(glance_custom.fixest, envir = globalenv())
  }

  ## if true, reorder the rows so that mean is before FEs
  if (isTRUE(mean_dependent) & is.null(gof_map)) {
    panel_df <- panel_df |>
      shift_means()
  }


  ## getting number of rows per model:
  ## this helps to align where the pack_rows arguments will go.
  rows_per_model <- get_panel_indices(panel_df)

  if (collapse_fe == T & num_panels > 1) {
    warning("panelsummary does not check if the fixed effects in each panel match—it always assumes they do!")

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
                 hline_before_fe = hline_before_fe)
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









