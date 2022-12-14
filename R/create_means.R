

#' Changes all models passed into panelsummary into a list
#' @keywords internal
#'
#' `change_to_lists` changes all models passed into panelsummary::panelsummary into a list. This is
#' mostly done to ensure that getting the means is done correctly when applying functions over lists.
#'
#' @param models Input list. This is the input list of models taken from the user.
#'
#' @returns A list of lists. It will change any non-list component to a list.
#'

change_to_lists <- function(models){
  for (i in seq_along(models)){
    if (class(models[[i]]) != "list"){
      models[[i]] <- list(models[[i]])
    }
  }
  return(models)
}


#' Checks that the class of each regression is of the type "fixest"
#'
#' `check_class_fixest` ensures that each class is of the type "fixest" so that the mean of the
#' dependent variable can be taken using fixest built-in methods.
#'
#' @param models Input list. This is the input list of models taken from the user.
#'
#' @returns A Boolean of TRUE/FALSE indicating whether the elements are of fixest type.
#'
#' @keywords internal
#'

check_class_fixest <- function(models) {
  unique_classes <- lapply(models, function(x) sapply(x, function(y) y |> class())) |> unlist() |> unique()
  if (length(unique_classes) >1) {
    return(FALSE)
  } else if (unique_classes == "fixest") {
    return(TRUE)
  }
}


#' Generates the mean of the dependent variable for each model
#'
#' `get_means_fixest` generates the mean of the dependent variable for each model supplied to the panelsummary::panelsummary.
#' This function only accepts fixest objects as it uses built-in fixest fitstat to compute the means.
#'
#' @param models A list of lists. Each list should contain fixest objects.
#' @param fmt An integer. This will denote how many decimal places to round to for the table.
#'
#' @returns A list of named vectors denoting the means of each model.
#'
#' @keywords internal


get_means_fixest <- function(models, fmt){
  models <- change_to_lists(models)
  if (isTRUE(check_class_fixest(models))) {
    means <- lapply(models, function(x) sapply(x, function(y) y |> fixest::fitstat(type = "my") |> unlist()))
    ## converting to characters with sprintf - need to make it better for digits
    means <- lapply(means, function(x) sprintf(paste0("%.", fmt, "f"), x))
    ## finding the number of columns
    number_columns <- lapply(means, function(x) x |> length())
    ## making the names of the columns to match modelsummary's output
    names_columns <- lapply(number_columns, function(x) paste("Model",rep(1:x)))
    ## changing the names
    for (i in seq_along(means)) {
      names(means[[i]]) <- names_columns[[i]]
    }
    return(means)
  }
}


#' Merges the means to the modelsummary output dataframe
#'
#' `connect_means` connects the means to the modelsummary dataframe.
#'
#' @param panel_df The modelsummary dataframe supplied from modelsummary::modelsummary(x, output = "data.frame")
#' @param means The list of named vectors of means which correspond to each model.
#'
#' @returns A data.frame with the attached means.
#'
connect_means <- function(panel_df, means) {
  for (i in seq_along(panel_df)){
    panel_df[[i]] <- panel_df[[i]] |>
      dplyr::bind_rows(means[[i]])
  }
  panel_df <- lapply(panel_df, function(x) x|>
                       dplyr::mutate(term = ifelse(is.na(.data$term), "mean", .data$term),
                                     part = ifelse(is.na(.data$part), "gof", .data$part)))
  return(panel_df)
}







