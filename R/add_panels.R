
## Helper Functions
add_panels <- function(output, num_panels, bold = F, italic = T, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = F) {
  if (num_panels == 1) {
    output <- output
  } else if (num_panels == 2) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 3) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 4) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  } else if (num_panels == 5) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel E:", panel_labels[5]), rows_per_model[5] + 1, rows_per_model[5], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after)
  }
}


add_panels_cfe <- function(output, num_panels, bold = F, italic = T, latex_gap_space = "0.5cm", panel_labels,
                       rows_per_model, hline_after = F, hline_after_fe = T) {
  if (num_panels == 1) {
    output <- output
  } else if (num_panels == 2) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_after_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 3) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_after_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 4) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_after_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  } else if (num_panels == 5) {
    output <- output |>
      kableExtra::pack_rows(paste("Panel A:", panel_labels[1]), 1, rows_per_model[1], bold = bold, italic = italic, hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel B:", panel_labels[2]), rows_per_model[1] + 1, rows_per_model[2], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel C:", panel_labels[3]), rows_per_model[2] + 1, rows_per_model[3], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel D:", panel_labels[4]), rows_per_model[3] + 1, rows_per_model[4], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::pack_rows(paste("Panel E:", panel_labels[5]), rows_per_model[5] + 1, rows_per_model[5], bold = bold, italic = italic, latex_gap_space = "0.5cm", hline_after = hline_after) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1] - (rows_per_model[num_panels + 1] - rows_per_model[num_panels]), hline_after=hline_after_fe) |>
      kableExtra::row_spec(rows_per_model[num_panels + 1], hline_after = T)
  }
}
