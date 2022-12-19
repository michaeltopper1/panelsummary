
#' add panels to the regression table
#'
#' @description Adds panels (such as Panel A, Panel B,...) to the regression tables.
#'
#' @param regression_table the regression table to be given panels to.
#' @param num_panels the number of panels in the regression table. Passed in from panelsummary.
#' @param bold whether the panel labels should be bold or not.
#' @param italic whether the panel labels should be in italics.
#' @param latex_gap_space the amount of space between the two panels. This is the optimal spacing.
#' @param panel_labels the text to come after each Panel A:... and Panel B:...
#' @param rows_per_model the number of rows in each of the panels.
#' @param hline_after whether to add a horizontal line after each Panel
#'
#' @keywords internal
#'
add_panels <- function(regression_table, num_panels, bold = FALSE, italic = TRUE, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = FALSE) {
 if (dplyr::between(num_panels, 2, 5)) {
    for (i in seq_along(panel_labels)) {
      if (i == 1) {
        regression_table <- regression_table |>
          kableExtra::pack_rows(panel_labels[i], i, rows_per_model[i],
                                bold = bold,
                                italic = italic,
                                hline_after = hline_after)
      } else{
        regression_table <- regression_table |>
          kableExtra::pack_rows(panel_labels[i], rows_per_model[i - 1] + 1, rows_per_model[i],
                                bold = bold,
                                italic = italic,
                                hline_after = hline_after,
                                latex_gap_space = "0.5cm")
      }
    }
  } else if (num_panels > 5){
    stop("panelsummary does not support models with over 5 panels to incentivize the author to maintain conciseness.")
  }
  return(regression_table)
}


#' add panels to the regression table for collapsed_fe = T
#'
#' @description Adds panels (such as Panel A, Panel B,...) to the regression tables.
#'
#' @param regression_table the regression table to be given panels to.
#' @param num_panels the number of panels in the regression table. Passed in from panelsummary.
#' @param bold whether the panel labels should be bold or not.
#' @param italic whether the panel labels should be in italics.
#' @param latex_gap_space the amount of space between the two panels. This is the optimal spacing.
#' @param panel_labels the text to come after each Panel A:... and Panel B:...
#' @param rows_per_model the number of rows in each of the panels.
#' @param hline_after whether to add a horizontal line after each Panel
#' @param hline_before_fe whether a horizontal line before the fixed effects panel should occur.
#'
#' @keywords internal
#'
add_panels_cfe <- function(regression_table, num_panels, bold = FALSE, italic = TRUE, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = FALSE, hline_before_fe = TRUE) {
  if (dplyr::between(num_panels, 2, 5)) {
    length_labels <- length(panel_labels)
    for (i in seq_along(panel_labels)) {
      if (i == 1) {
        regression_table <- regression_table |>
          kableExtra::pack_rows(panel_labels[i], i, rows_per_model[i],
                                bold = bold,
                                italic = italic,
                                hline_after = hline_after)
      } else if (i > 1 & i != length_labels) {
        regression_table <- regression_table |>
          kableExtra::pack_rows(panel_labels[i], rows_per_model[i - 1] + 1, rows_per_model[i],
                                bold = bold,
                                italic = italic,
                                hline_after = hline_after,
                                latex_gap_space = "0.5cm")
      } else if (i > 1 & i == length_labels) {
        regression_table <- regression_table |>
          kableExtra::pack_rows(panel_labels[i], rows_per_model[i - 1] + 1, rows_per_model[i],
                                bold = bold,
                                italic = italic,
                                hline_after = hline_after,
                                latex_gap_space = "0.5cm") |>
          kableExtra::row_spec(rows_per_model[num_panels +1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]),
                               hline_after = hline_before_fe) |>
          kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
      }
    }
    }
    else if (num_panels > 5){
      stop("panelsummary does not support models with over 5 panels to incentivize the author to maintain conciseness.")
    }
  return(regression_table)
}

