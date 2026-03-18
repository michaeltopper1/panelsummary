# Generates the mean of the dependent variable for each model

\`get_means_fixest\` generates the mean of the dependent variable for
each model supplied to the panelsummary::panelsummary. This function
only accepts fixest objects as it uses built-in fixest fitstat to
compute the means.

## Usage

``` r
get_means_fixest(models, fmt)
```

## Arguments

- models:

  A list of lists. Each list should contain fixest objects.

- fmt:

  An integer. This will denote how many decimal places to round to for
  the table.

## Value

A list of named vectors denoting the means of each model.
