

## check if objects are compatable with the package

check_objects <- function(models) {
  ## creating an empty list to track listed lists
  listed_lists <- c()

  ## looping through models to find any nested lists.
  ## keeping track of all nested lists in the listed lists
  for (i in seq_along(models)) {
    ## checks if the class is a list which should imply a list of lists
    if (class(models[[i]]) == "list") {
      listed_lists <- listed_lists |>
        append(i)
    }
  }
  ## if there are no nested lists of regressions, continue as normal
  ## If there are, they should show up in the listed_lists. Here is where I fix
  ## the models to essentially flatten the components that need to be flattened
  if (!is.null(listed_lists)) {
    ## gives all models that are now flattened out
    models_flattened <- models[listed_lists] |>
      unlist(recursive = F)
    ## appends all models that were not nested lists
    models_flattened <- models_flattened |>
      append(models[-listed_lists])
    ## updates the models to the flattened models
    models <- models_flattened
  }
  ## tests if any of the models are unsupported by this package. If so, return an error message.
  for (i in seq_along(models)) {
    if (!class(models[[i]]) %in% models_supported()) {
      stop(paste("Error in Model", i, ". Model class:", class(models[[i]]), "is not supported (yet) by this package. Please check the `models_supported` function for supported model types."))
    }
  }
}




