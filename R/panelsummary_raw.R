
#' Create a regression data.frame to manually edit further
#'
#' @description
#' `panelsummary_raw` Creates a data.frame for further editing. The data.frame can be directly passed into kableExtra::kbl(), or alternatively, passed into panelsummary::clean_raw() to get typical defaults from kableExtra::kbl().
#'
#' @param mean_dependent A boolean. For use with fixest objects only.
#'    * `FALSE` (the default): the mean of the dependent variable will not be shown in the resulting table.
#'    * `TRUE`: the mean of the dependent variable will be shown in the resulting table.
#' @param colnames An optional vector of strings. The vector of strings should have the same length as the number columns of the table.
#'    * `NULL` (the default): colnames are defaulted to a whitespace, followed by (1), (2), ....etc.
#' @param caption A string. The table caption.
#' @param format A character string. Possible values are latex, html, pipe (Pandoc's pipe tables), simple (Pandoc's simple tables), and rst. The value of this argument will be automatically determined if the function is called within a knitr document. The format value can also be set in the global option knitr.table.format. If format is a function, it must return a character string.
#' @inheritParams modelsummary::modelsummary
#'
#' @returns A kableExtra object that is instantly customizable by kableExtra's suite of functions.
#'
#'
#' @examples
#'
#' ## Using panelsummary_raw
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
#'
#' panelsummary_raw(ols_1, ols_1)
#'
#'
#' ## Including multiple models------------------
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
#'
#' panelsummary_raw(list(ols_1, ols_1, ols_1), ols_1,
#'               caption = "Multiple models",
#'               stars = TRUE)
#'
#'
#' @export
#'
#' @importFrom rlang .data
panelsummary_raw <- function(
    ...,
    mean_dependent = FALSE,
    colnames = NULL,
    caption = NULL,
    format = NULL,
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

  ## creates economic significance convention stars
  if (length(stars) == 1){
    if (stars == "econ"){
      stars <- econ_stars()
    }
  }



  ## Finds the means of the dependent variable from fixest classes only
  if (isTRUE(mean_dependent)) {
    means <- get_means_fixest(models, fmt)
  }


  options(modelsummary_model_labels="model")

  panel_df <- lapply(models, function(x) modelsummary::modelsummary(x,
                                                                    output = "data.frame",
                                                                    fmt = fmt, estimate = estimate,
                                                                    vcov = vcov, conf_level = 0.95,
                                                                    stars = stars, coef_map = coef_map,
                                                                    gof_map = gof_map,
                                                                    gof_omit = gof_omit))

  ## connects the means to the data frame
  if (isTRUE(mean_dependent)) {
    panel_df <- panel_df |>
      connect_means(means)
  }

  ## if true, reorder the rows so that mean is before FEs
  if (isTRUE(mean_dependent)) {
    panel_df <- panel_df |>
      shift_means()
  }

  ## binding each of the data.frames together again and getting rid of NAs
  panel_df <- panel_df |>
    dplyr::bind_rows() |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), ~stringr::str_replace_na(., replacement = "")))

  panel_df_cleaned <- panel_df |>
    dplyr::mutate(term = ifelse(.data$statistic == "std.error", "", .data$term)) |>
    dplyr::select(-part, -statistic)

  ## getting the number of columns/models in the dataframe
  number_models <- ncol(panel_df_cleaned)

  ## if no columnnames inputted, create defaults (1), (2), ... (n)
  if (is.null(colnames)){
    colnames <- create_column_names(number_models)
  }
  return(panel_df_cleaned)
}


