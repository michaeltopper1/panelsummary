#
#
# change_to_lists <- function(models){
#   for (i in seq_along(models)){
#     if (class(models[[i]]) != "list"){
#       models[[i]] <- list(models[[i]])
#     }
#   }
#   return(models)
# }
#
# check_class_fixest <- function(models) {
#   unique_classes <- lapply(models, function(x) sapply(x, function(y) y |> class())) |> unlist() |> unique()
#   return(unique_classes == "fixest")
# }
#
#
#
# get_means_fixest <- function(models, fmt){
#   models <- change_to_lists(models)
#     if (isTRUE(check_class_fixest(models))) {
#       means <- lapply(models, function(x) sapply(x, function(y) y |> fixest::fitstat(type = "my") |> unlist()))
#       ## converting to characters with sprintf - need to make it better for digits
#       means <- lapply(means, function(x) sprintf(paste0("%.", fmt, "f"), x))
#       ## finding the number of columns
#       number_columns <- lapply(means, function(x) x |> length())
#       ## making the names of the columns to match modelsummary's output
#       names_columns <- lapply(number_columns, function(x) paste("Model",rep(1:x)))
#       ## changing the names
#       for (i in seq_along(means)) {
#         names(means[[i]]) <- names_columns[[i]]
#       }
#       return(means)
#     }
#   }
#
# connect_means <- function(panel_df, means) {
#   for (i in seq_along(panel_df)){
#     panel_df[[i]] <- panel_df[[i]] |>
#       dplyr::bind_rows(means[[i]])
#   }
#   panel_df <- lapply(panel_df, function(x) x|>
#            dplyr::mutate(term = ifelse(is.na(.data$term), "mean", .data$term),
#                          part = ifelse(is.na(.data$part), "gof", .data$part)))
#   return(panel_df)
# }
#
#
#
#
