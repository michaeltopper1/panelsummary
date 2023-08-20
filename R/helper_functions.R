
#' gets the row numbers for break points in the panels
#'
#' @keywords internal
#'
get_panel_indices <- function(panel) {
  panel |>
    lapply(function(x) nrow(x)) |>
    as.vector() |>
    cumsum()
}

#' gets the number of fixed effects in the last panel for collapse_fe purposes
#'
#' @keywords internal
#'
get_lpanel_fe <- function(df, panels){
  df[[panels]] |>
    dplyr::mutate(count_fe = sum(stringr::str_count(term, "^FE"))) |>
    dplyr::slice(1) |>
    dplyr::pull(count_fe)
}

#' removes all fixed effects except the final panel (for collapse_fe)
#'
#' @keywords internal
#'
remove_fe <- function(panel_df, num_panels) {
  number_panels_minus_one <- num_panels - 1
  for (i in 1:number_panels_minus_one) {
    panel_df[[i]] <- panel_df[[i]] |>
      dplyr::filter(!stringr::str_detect(term, "^FE"))
  }
  return(panel_df)
}

#' gets the indices of each of the breaks in the panel
#'
#' @keywords internal
#'
get_panel_indices_collapse <- function(panel_df, num_panels) {

  ## this will override the rows per model made before
  rows_per_model <- get_panel_indices(panel_df)

  ## gets the number of fixed effects in the final panel
  number_fe_final_panel <- get_lpanel_fe(panel_df, num_panels)

  rows_per_model[num_panels] <- rows_per_model[num_panels] - number_fe_final_panel

  ## append the fe into another panel
  rows_per_model <- rows_per_model |>
    append(rows_per_model[num_panels] + number_fe_final_panel)
}


#' creates the column names of (1), (2), ...
#'
#' @keywords internal
#'
create_column_names <- function(number_models) {
  number_models_minus_one <- number_models - 1
  columns <- c(" ", paste0("(",1:number_models_minus_one, ")"))
  return(columns)
}

#' creates alignment of left, center, center, ...
#'
#' @keywords internal
create_alignment <- function(number_models) {
  number_models_minus_one <- number_models - 1
  alignment <- paste(c("l", rep("c", number_models_minus_one)), collapse = "")
  return(alignment)
}

#' shifts the custom glance means to above observations and renames
#'
#' @keywords internal
shift_means <- function(df) {
  df <- lapply(df, function(x) x |>
           dplyr::arrange(match(stringr::str_to_lower(part), "estimates"), match(stringr::str_to_lower(term), "mean")) |>
             dplyr::mutate(term = ifelse(stringr::str_to_lower(term) == "mean", "Mean of Dependent Variable", term)))
  return(df)
}

#' creates economics convention significance stars
#'
#' @keywords internal
econ_stars <- function() {
  stars <- c('*' = .1, '**' = .05, '***' = .01)
  return(stars)
}


#' creates prettyNum with commas for anything larger than 1000
#'
#' @keywords internal
create_pretty_numbers <- function(df){
  df <- df |>
    dplyr::mutate(dplyr::across(.cols = c(-1), ~prettyNum(.,digits = 2, big.mark = ",", format = "f"))) |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), ~stringr::str_replace(., pattern = "NA", replacement = "")))
  return(df)
}
