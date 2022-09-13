
#' check if the dimensions work
#' @param models the regression models to check the dimensions of
#' @param panel_labels the labels for each panel.
#'
#' @keywords internal
#'
check_dimensions_match <- function(models, panel_labels) {
  if (length(models) != length(panel_labels)) {
    stop("The length of panel_labels does not match the length of the arguments you put into panelsummary.")
  }
}
