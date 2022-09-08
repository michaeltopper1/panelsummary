
## gets the indices of each of the breaks in the panel
get_panel_indices <- function(panel) {
  panel |>
    lapply(function(x) nrow(x)) |>
    as.vector() |>
    cumsum()
}


## gets the number of fixed effects in the final panel so that we can collapse panels
get_lpanel_fe <- function(df, panels){
  df[[panels]] |>
    dplyr::mutate(count_fe = sum(stringr::str_count(term, "^FE"))) |>
    dplyr::slice(1) |>
    dplyr::pull(count_fe)
}


## removes all fixed effects except the final panel: only used for collapsing
remove_fe <- function(panel_df, num_panels) {
  number_panels_minus_one <- num_panels - 1
  for (i in 1:number_panels_minus_one) {
    panel_df[[i]] <- panel_df[[i]] |>
      dplyr::filter(!stringr::str_detect(term, "^FE"))
  }
  return(panel_df)
}


## gets the indices of each of the breaks in the panel
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


## create column names
create_column_names <- function(number_models) {
  number_models_minus_one <- number_models - 1
  columns <- c(" ", paste0("(",1:number_models_minus_one, ")"))
  return(columns)
}

## create alignment
create_alignment <- function(number_models) {
  number_models_minus_one <- number_models - 1
  alignment <- paste(c("l", rep("c", number_models_minus_one)), collapse = "")
  return(alignment)
}



