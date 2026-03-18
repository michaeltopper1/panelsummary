# add panels to the regression table

Adds panels (such as Panel A, Panel B,...) to the regression tables.

## Usage

``` r
add_panels(
  regression_table,
  num_panels,
  bold = FALSE,
  italic = TRUE,
  latex_gap_space = "0.5cm",
  panel_labels,
  rows_per_model,
  hline_after = FALSE
)
```

## Arguments

- regression_table:

  the regression table to be given panels to.

- num_panels:

  the number of panels in the regression table. Passed in from
  panelsummary.

- bold:

  whether the panel labels should be bold or not.

- italic:

  whether the panel labels should be in italics.

- latex_gap_space:

  the amount of space between the two panels. This is the optimal
  spacing.

- panel_labels:

  the text to come after each Panel A:... and Panel B:...

- rows_per_model:

  the number of rows in each of the panels.

- hline_after:

  whether to add a horizontal line after each Panel
