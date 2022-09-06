

## object fixing for regression objects:


## fixest: creates a mean called 'mean'
create_mean_fixest <- function() {
  glance_custom.fixest <<- function(x, ...) {
    out <- data.frame("mean" = as.numeric(fixest::fitstat(x, type = "my")))
    return(out)
  }
}

create_mean_lm <- function() {
  glance_custom.lm <<- function(x, ...) {
    out <- data.frame("mean" = sprintf("%.3f",mean(x$model[[1]], na.rm = T)))
  }
}

