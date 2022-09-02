

## object fixing for regression objects:


## fixest: creates a mean called 'mean'
create_mean_fixest <- function(){
  glance_custom.fixest <<- function(x, ...) {
    out <- data.frame("mean" = as.numeric(fitstat(x, type = "my")))
    return(out)
  }
}

