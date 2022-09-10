
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
add_panels <- function(regression_table, num_panels, bold = F, italic = T, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = F) {
  if (num_panels == 1) {
    regression_table <- regression_table
  } else if (num_panels == 2) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 3) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 4) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 5) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel E:", panel_labels[5]), rows_per_model[5] + 1, rows_per_model[5], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels > 5){
    stop("panelsummary does not support models with over 5 panels to incentivize the author to maintain conciseness.")
  }
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
add_panels_cfe <- function(regression_table, num_panels, bold = F, italic = T, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = F, hline_before_fe = T) {
  if (num_panels == 1) {
    regression_table <- regression_table
  } else if (num_panels == 2) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_before_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 3) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_before_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 4) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_before_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 5) {
    regression_table <- regression_table |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel E:", panel_labels[5]), rows_per_model[5] + 1, rows_per_model[5], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_before_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels > 5){
    stop("panelsummary does not support models with over 5 panels to incentivize the author to maintain conciseness.")
  }
}
