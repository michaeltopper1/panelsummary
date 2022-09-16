
#' creates a custom glance function for fixest objects with a mean
#'
#' @keywords internal
#'
create_mean_fixest <- function() {
  glance_custom.fixest <<- function(x, ...) {
    out <- data.frame("mean" = as.numeric(fixest::fitstat(x, type = "my")))
    return(out)
  }
}

# create_mean_lm <- function() {
#   glance_custom.lm <<- function(x, ...) {
#     out <- data.frame("mean" = sprintf("%.3f",mean(x$model[[1]], na.rm = T)))
#   }
# }


