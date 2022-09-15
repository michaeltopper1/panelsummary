
#' creates panel labels when the argument is null
#'
#' @param num_panels the number of panels in the regression table.
#'
#' @return default panel labels named "Panel A:", "Panel B:", ..."Panel E:"
#'
#' @keywords internal
#'
create_panels_null <- function(num_panels) {
  panel_labels <- rep(" ", num_panels)
  for (i in seq_along(panel_labels)){
    panel_labels[i] <- paste0("Panel ", LETTERS[i], ":")
  }
  return(panel_labels)
}

