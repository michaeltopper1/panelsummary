
#' Pass a panelsummary::panelsummary_raw dataframe into kableExtra::kbl() with typical defaults
#'
#' @description
#' `clean_raw` Passes a panelsummary::panelsummary_raw dataframe that has (or has not) been edited further into kableExtra::kbl() with default settings that look publication-ready. This includes changing the column names and fixing the alignment.
#'
#' @param data.frame The data.frame (or tibble) from panelsummary::panelsummary_raw() that has been manipulated.
#' @param colnames An optional vector of strings. The vector of strings should have the same length as the number columns of the table.
#'    * `NULL` (the default): colnames are defaulted to a whitespace, followed by (1), (2), ....etc.
#' @param caption A string. The table caption.
#' @param format A character string. Possible values are latex, html, pipe (Pandoc's pipe tables), simple (Pandoc's simple tables), and rst. The value of this argument will be automatically determined if the function is called within a knitr document. The format value can also be set in the global option knitr.table.format. If format is a function, it must return a character string.
#' @param alignment A character string. By default, it is set to left adjusting the first column, and centering the rest of the columns. For example, a model with three columns will have adjustment of "lcc".
#'
#' @returns A raw data frame that is ready for further manipulation.
#'
#' @examples
#'
#' ## Cleaning a panelsummary_raw dataframe with clean_raw
#'
#' ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
#'
#' ols_2 <- mtcars |> fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)
#'
#' panelsummary_raw(ols_1, ols_2) |> clean_raw()
#'
#'
#'
#'
#' @export
#'
#'
clean_raw <- function(data.frame,
                      alignment = NULL,
                      colnames = NULL,
                      format = NULL,
                      caption = NULL){
  number_models <- ncol(data.frame)
  if (is.null(alignment)){
    alignment <- create_alignment(number_models)
  }
  if (is.null(colnames)){
    colnames <- create_column_names(number_models)
  }
  panel_df_cleaned <- kableExtra::kbl(data.frame,
                                      col.names = colnames,
                                      align = alignment,
                                      caption = caption,
                                      format = format,
                                      booktabs = TRUE)
  return(panel_df_cleaned)
}

