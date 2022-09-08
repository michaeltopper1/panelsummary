
## checks if the dimensions match. Need to make sure the number of elements in the list matches the number of
## panels.
check_dimensions_match <- function(models, num_panels) {
  if (length(models) != num_panels) {
    stop("The number of panels does not match the number of arguments you put into panelsummary.")
  }
}
