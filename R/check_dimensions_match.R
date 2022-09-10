
#' check if the dimensions work
#' @param models the regression models to check the dimensions of
#' @param num_panels the number of panels passed from panelsummary
#'
#' @keywords internal
#'
check_dimensions_match <- function(models, num_panels) {
  if (length(models) != num_panels) {
    stop("The number of panels does not match the number of arguments you put into panelsummary.")
  }
}
