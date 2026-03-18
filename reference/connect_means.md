# Merges the means to the modelsummary output dataframe

\`connect_means\` connects the means to the modelsummary dataframe.

## Usage

``` r
connect_means(panel_df, means)
```

## Arguments

- panel_df:

  The modelsummary dataframe supplied from modelsummary::modelsummary(x,
  output = "data.frame")

- means:

  The list of named vectors of means which correspond to each model.

## Value

A data.frame with the attached means.
