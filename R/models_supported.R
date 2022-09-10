

#' all models supported by panelsummary
#'
#' @returns a list of all modeltypes supported by panelsummary
#'
#' @examples
#'
#' models_supported()
#'
#' @export
models_supported <- function() {
  models_supported <- c("fixest", "lm")
  return(models_supported)
}
