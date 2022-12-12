
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
#' @param bold A boolean. Determines whether the panel names should be in bold font.
#'    * `FALSE` (the default): the panel names are not in bold.
#'    * `TRUE`: the panel names are bolded
#' @param italic A boolean. Determines whether the panel names should be in italics.
#'    * `FALSE` (the default): the panel names are not in italics.
#'    * `TRUE`: the panel names will be in italics.
#' @inheritParams modelsummary::modelsummary
#'
#' @returns A kableExtra object that is instantly customizable by kableExtra's suite of functions.
#'
#'
#' @examples
#'
#' ## Using panelsummary_raw
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_2 <- mtcars |> fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)
#'
#' panelsummary_raw(ols_1, ols_2)
#'
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
#' panelsummary_raw(list(ols_1, ols_2, ols_3), ols_4,
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
    bold = FALSE,
    italic = FALSE,
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
  return(panel_df_cleaned)
}


