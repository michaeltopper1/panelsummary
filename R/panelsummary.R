
#' Create a regression table with multiple panels
#'
#' @description
#' `panelsummary` Creates a beautiful and customizable regression table with panels. This function is best used to summarize multiple dependent variables that are passed through the same regression models. This function returns a kableExtra object which can then be edited using kableExtra's suite of functions.
#'
#' @param ... A regression model or models (see panelsummary::models_supported for classes that are supported).
#'    * The regression model can be a list of models or a singular object.
#'    * If a list is passed in, one column for each list is created. Each argument will correspond to a panel.
#'    * If only one object is passed in, there will be no panels and the output will be similar to evaluating modelsummary::modelsummary() followed by kableExtra::kbl()
#' @param panel_labels A character vector. How to label each panel in the table.
#'    * `NULL` (the default): the panels will be labeled "Panel A:", "Panel B:",...etc.
#
#' @param mean_dependent A boolean. For use with fixest objects only.
#'    * `FALSE` (the default): the mean of the dependent variable will not be shown in the resulting table.
#'    * `TRUE`: the mean of the dependent variable will be shown in the resulting table.
#' @param colnames An optional vector of strings. The vector of strings should have the same length as the number columns of the table.
#'    * `NULL` (the default): colnames are defaulted to a whitespace, followed by (1), (2), ....etc.
#' @param caption A string. The table caption.
#' @param format A character string. Possible values are latex, html, pipe (Pandoc's pipe tables), simple (Pandoc's simple tables), and rst. The value of this argument will be automatically determined if the function is called within a knitr document. The format value can also be set in the global option knitr.table.format. If format is a function, it must return a character string.
#' @param collapse_fe A boolean. For use with fixest objects only. Determines whether fixed effects should only be included in the bottom of the table. This is suited for when each panel has the same models with the same fixed effects.
#'    * `FALSE` (the default): fixed effects are shown in each panel.
#'    * `TRUE`: fixed effects are shown only at the bottom of the final panel, separated by a horizontal line (see hline_before_fe)
#' @param bold A boolean. Determines whether the panel names should be in bold font.
#'    * `FALSE` (the default): the panel names are not in bold.
#'    * `TRUE`: the panel names are bolded
#' @param italic A boolean. Determines whether the panel names should be in italics.
#'    * `FALSE` (the default): the panel names are not in italics.
#'    * `TRUE`: the panel names will be in italics.
#' @param hline_after A boolean. Adds a horizontal line after the panel labels.
#'    * `FALSE` (the default): there is not horizonal line after the panel labels.
#'    * `TRUE`: a horizontal line will appear after the panel labels.
#' @param hline_before_fe A boolean. To be used only when collapse_fe = TRUE, and hence with fixest objects only. Adds a horizontal line before the fixed effects portion of the table.
#' @inheritParams modelsummary::modelsummary
#'
#' @returns A kableExtra object that is instantly customizable by kableExtra's suite of functions.
#'
#'
#'
#' @examples
#'
#' # Panelsummary with lm -------------------------
#'
#' reg_1 <- lm(mpg ~ hp + cyl, data = mtcars)
#' reg_2 <- lm(disp ~ hp + cyl, data = mtcars)
#'
#' panelsummary(reg_1, reg_2, panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
#'
#'
#' # Panelsummary with fixest -------------------------
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#' ols_2 <- mtcars |> fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)
#'
#' panelsummary(ols_1, ols_2, mean_dependent = TRUE,
#'             panel_labels = c("Panel A:MPG", "Panel B: DISP"),
#'             caption = "The effect of cyl on MPG and DISP",
#'             italic = TRUE, stars = TRUE)
#'
#'
#' ## Collapsing fixed effects (fixest-only)----------------
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_2 <- mtcars |> fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)
#'
#' panelsummary(ols_1, ols_2, mean_dependent = TRUE,
#'             collapse_fe = TRUE, panel_labels = c("Panel A: MPG", "Panel B: DISP"),
#'             caption = "The effect of cyl on MPG and DISP",
#'             italic = TRUE, stars = TRUE)
#'
#' ## Including multiple models------------------
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_3 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_4 <- mtcars |> fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)
#'
#' panelsummary(list(ols_1, ols_2, ols_3), ols_4,
#'              panel_labels = c("Panel A: MPG", "Panel B: DISP"),
#'               caption = "Multiple models",
#'               stars = TRUE)
#'
#'
#' @export
#'

#' @importFrom rlang .data
panelsummary <- function(
    ...,
    panel_labels = NULL,
    mean_dependent = FALSE,
    colnames = NULL,
    caption = NULL,
    format = NULL,
    collapse_fe = FALSE,
    bold = FALSE,
    italic = FALSE,
    hline_after = FALSE,
    hline_before_fe = TRUE,
    fmt         = 3,
    estimate    = "estimate",
    statistic   = "std.error",
    vcov        = NULL,
    conf_level  = 0.95,
    stars       = FALSE,
    coef_map    = NULL,
    coef_omit   = NULL,
    coef_rename = NULL,
    gof_map     = NULL,
    gof_omit    = NULL) {


  models <- list(...)

  num_panels <- length(models)

  ## checks if the dimensions match. If not, returns error.
  if (!is.null(panel_labels)) {
    check_dimensions_match(models, panel_labels = panel_labels)
  } else {
    ## if panels labels are not inputted, then panel_labels get the default values
    panel_labels <- create_panels_null(num_panels)
  }

  ## creates economic significance convention stars
  if (length(stars) == 1){
    if (stars == "econ"){
      stars <- econ_stars()
    }
  }


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
    warning("panelsummary does not check if the fixed effects in each panel match. It always assumes they do!")

    ## removing fixed effects from all but the last panel
    panel_df <- panel_df |>
      remove_fe(num_panels)

    ## updating the rows_per_model
   rows_per_model <- get_panel_indices_collapse(panel_df, num_panels)

  }

  ## binding each of the data.frames together again and getting rid of NAs
  panel_df <- panel_df |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), ~stringr::str_replace_na(., replacement = "")))

  panel_df_cleaned <- panel_df |>
    dplyr::mutate(term = ifelse(.data$statistic == "std.error", "", .data$term)) |>
    dplyr::select(-.data$part, -.data$statistic)

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









