# Create a regression data.frame to manually edit further

\`panelsummary_raw\` Creates a data.frame for further editing. The
data.frame can be directly passed into kableExtra::kbl(), or
alternatively, passed into panelsummary::clean_raw() to get typical
defaults from kableExtra::kbl().

## Usage

``` r
panelsummary_raw(
  ...,
  mean_dependent = FALSE,
  colnames = NULL,
  caption = NULL,
  format = NULL,
  fmt = 3,
  estimate = "estimate",
  statistic = "std.error",
  vcov = NULL,
  conf_level = 0.95,
  stars = FALSE,
  coef_map = NULL,
  coef_omit = NULL,
  coef_rename = NULL,
  gof_map = NULL,
  gof_omit = NULL
)
```

## Arguments

- ...:

  all other arguments are passed through to three functions. See the
  documentation of these functions for lists of available arguments.

  - [parameters::model_parameters](https://easystats.github.io/parameters/reference/model_parameters.html)
    extracts parameter estimates. Available arguments depend on model
    type, but include:

    - `standardize`, `include_reference`, `centrality`, `dispersion`,
      `test`, `ci_method`, `prior`, `diagnostic`, `rope_range`, `power`,
      `cluster`, etc.

  - [performance::model_performance](https://easystats.github.io/performance/reference/model_performance.html)
    extracts goodness-of-fit statistics. Available arguments depend on
    model type, but include:

    - `metrics`, `estimator`, etc.

  - [tinytable::tt](https://vincentarelbundock.github.io/tinytable/man/tt.html),
    [kableExtra::kbl](https://rdrr.io/pkg/kableExtra/man/kbl.html) or
    [gt::gt](https://gt.rstudio.com/reference/gt.html) draw tables,
    depending on the value of the `output` argument. For example, by
    default `modelsummary` creates tables with
    [tinytable::tt](https://vincentarelbundock.github.io/tinytable/man/tt.html),
    which accepts a `width` and `theme` arguments.

- mean_dependent:

  A boolean. For use with fixest objects only. \* \`FALSE\` (the
  default): the mean of the dependent variable will not be shown in the
  resulting table. \* \`TRUE\`: the mean of the dependent variable will
  be shown in the resulting table.

- colnames:

  An optional vector of strings. The vector of strings should have the
  same length as the number columns of the table. \* \`NULL\` (the
  default): colnames are defaulted to a whitespace, followed by (1),
  (2), ....etc.

- caption:

  A string. The table caption.

- format:

  A character string. Possible values are latex, html, pipe (Pandoc's
  pipe tables), simple (Pandoc's simple tables), and rst. The value of
  this argument will be automatically determined if the function is
  called within a knitr document. The format value can also be set in
  the global option knitr.table.format. If format is a function, it must
  return a character string.

- fmt:

  how to format numeric values: integer, user-supplied function, or
  `modelsummary` function.

  - Integer: Number of decimal digits

  - User-supplied functions:

    - Any function which accepts a numeric vector and returns a
      character vector of the same length.

  - `modelsummary` functions:

    - `fmt = fmt_significant(2)`: Two significant digits (at the
      term-level)

    - `fmt = fmt_decimal(digits = 2, pdigits = 3)`: Decimal digits for
      estimate and p values

    - `fmt = fmt_sprintf("%.3f")`: See
      [`?sprintf`](https://rdrr.io/r/base/sprintf.html)

    - `fmt = fmt_term("(Intercept)" = 1, "X" = 2)`: Format terms
      differently

    - `fmt = fmt_statistic("estimate" = 1, "r.squared" = 6)`: Format
      statistics differently.

    - `fmt = fmt_identity()`: unformatted raw values

  - string: Passing the string `s` is equivalent to passing
    `fmt_sprintf(s)`

  - Note on LaTeX output: To ensure proper typography, all numeric
    entries are enclosed in the `\num{}` command, which requires the
    `siunitx` package to be loaded in the LaTeX preamble. This behavior
    can be altered with global options. See the 'Details' section.

- estimate:

  a single string or a character vector of length equal to the number of
  models. Valid entries include any column name of the data.frame
  produced by `get_estimates(model)`, and strings with curly braces
  compatible with the `glue` package format. Examples:

  - `"estimate"`

  - `"{estimate} ({std.error}){stars}"`

  - `"{estimate} [{conf.low}, {conf.high}]"`

  - Numbers are automatically rounded and converted to strings. To let
    glue apply functions to numeric values, users must set `fmt=NULL`.
    For more complex formatting, users are encouraged to use the `fmt`
    argument, which accepts custom functions.

- statistic:

  vector of strings or `glue` strings which select uncertainty
  statistics to report vertically below the estimate (ex: standard
  errors, confidence intervals, p values). NULL omits all uncertainty
  statistics.

  - "conf.int", "std.error", "statistic", "p.value", "conf.low",
    "conf.high", or any column name produced by `get_estimates(model)`

  - `glue` package strings with braces, with or without R functions,
    such as:

    - `"{p.value} [{conf.low}, {conf.high}]"`

    - `"Std.Error: {std.error}"`

    - `"{exp(estimate) * std.error}"`

  - Notes:

    - The names of the `statistic` are used a column names when using
      the `shape` argument to display statistics as columns:

      - `statistic=c("p"="p.value", "["="conf.low", "]"="conf.high")`

    - Some statistics are not supported for all models. See column names
      in `get_estimates(model)`, and visit the website to learn how to
      add custom statistics.

    - Parentheses are added automatically unless the string includes
      `glue` curly braces [`{}`](https://rdrr.io/r/base/Paren.html).

- vcov:

  robust standard errors and other manual statistics. The `vcov`
  argument accepts six types of input (see the 'Details' and 'Examples'
  sections below):

  - NULL returns the default uncertainty estimates of the model object

  - string, vector, or (named) list of strings. "iid", "classical", and
    "constant" are aliases for `NULL`, which returns the model's default
    uncertainty estimates. The strings "HC", "HC0", "HC1" (alias:
    "stata"), "HC2", "HC3" (alias: "robust"), "HC4", "HC4m", "HC5",
    "HAC", "NeweyWest", "Andrews", "panel-corrected", "outer-product",
    and "weave" use variance-covariance matrices computed using
    functions from the `sandwich` package, or equivalent method. "BS",
    "bootstrap", "residual", "mammen", "webb", "xy", "wild" use the
    [`sandwich::vcovBS()`](https://sandwich.R-Forge.R-project.org/reference/vcovBS.html).
    The behavior of those functions can (and sometimes *must*) be
    altered by passing arguments to `sandwich` directly from
    `modelsummary` through the ellipsis (`...`), but it is safer to
    define your own custom functions as described in the next bullet.

  - function or (named) list of functions which return
    variance-covariance matrices with row and column names equal to the
    names of your coefficient estimates (e.g.,
    [`stats::vcov`](https://rdrr.io/r/stats/vcov.html),
    [`sandwich::vcovHC`](https://sandwich.R-Forge.R-project.org/reference/vcovHC.html),
    `function(x) vcovPC(x, cluster="country")`).

  - formula or (named) list of formulas with the cluster variable(s) on
    the right-hand side (e.g., ~clusterid).

  - named list of `length(models)` variance-covariance matrices with row
    and column names equal to the names of your coefficient estimates.

  - a named list of length(models) vectors with names equal to the names
    of your coefficient estimates. See 'Examples' section below.
    Warning: since this list of vectors can include arbitrary strings or
    numbers, `modelsummary` cannot automatically calculate p values. The
    `stars` argument may thus use incorrect significance thresholds when
    `vcov` is a list of vectors.

- conf_level:

  numeric value between 0 and 1. confidence level to use for confidence
  intervals. Setting this argument to `NULL` does not extract confidence
  intervals, which can be faster for some models.

- stars:

  to indicate statistical significance

  - FALSE (default): no significance stars.

  - TRUE: `c("+" = .1, "*" = .05, "**" = .01, "***" = 0.001)`

  - Named numeric vector for custom stars such as
    `c('*' = .1, '+' = .05)`

  - Note: a legend will not be inserted at the bottom of the table when
    the `estimate` or `statistic` arguments use "glue strings" with
    `{stars}`.

- coef_map:

  character vector. Subset, rename, and reorder coefficients.
  Coefficients omitted from this vector are omitted from the table. The
  order of the vector determines the order of the table. `coef_map` can
  be a named or an unnamed character vector. If `coef_map` is a named
  vector, its values define the labels that must appear in the table,
  and its names identify the original term names stored in the model
  object: `c("hp:mpg"="HPxM/G")`. If `coef_map` is an unnamed vector,
  its values must be raw variable names if `coef_rename=FALSE` and
  variable labels if `coef_rename=TRUE`. See
  [`modelsummary::get_estimates`](https://modelsummary.com/man/get_estimates.html)
  to get the coefficient out of a model. See Examples section below.

- coef_omit:

  integer vector or regular expression to identify which coefficients to
  omit (or keep) from the table. Positive integers determine which
  coefficients to omit. Negative integers determine which coefficients
  to keep. A regular expression can be used to omit coefficients, and
  perl-compatible "negative lookaheads" can be used to specify which
  coefficients to *keep* in the table. Examples:

  - c(2, 3, 5): omits the second, third, and fifth coefficients.

  - c(-2, -3, -5): negative values keep the second, third, and fifth
    coefficients.

  - `"ei"`: omit coefficients matching the "ei" substring.

  - `"^Volume$"`: omit the "Volume" coefficient.

  - `"ei|rc"`: omit coefficients matching either the "ei" or the "rc"
    substrings.

  - `"^(?!Vol)"`: keep coefficients starting with "Vol" (inverse match
    using a negative lookahead).

  - `"^(?!.*ei)"`: keep coefficients matching the "ei" substring.

  - `"^(?!.*ei|.*pt)"`: keep coefficients matching either the "ei" or
    the "pt" substrings.

  - See the Examples section below for complete code.

- coef_rename:

  logical, named or unnamed character vector, or function

  - Logical: TRUE renames variables based on the "label" attribute of
    each column. See the Example section below. Note: renaming is done
    by the `parameters` package at the extraction stage, before other
    arguments are applied like `coef_omit`. Therefore, this only works
    for models with builtin support and not for custom models.

  - Unnamed character vector of length equal to the number of
    coefficients in the final table, after `coef_omit` is applied.

  - Named character vector: Values refer to the variable names that will
    appear in the table. Names refer to the original term names stored
    in the model object. Ex: c("hp:mpg"="hp X mpg")

  - Function: Accepts a character vector of the model's term names and
    returns a named vector like the one described above. The
    `modelsummary` package supplies a `coef_rename()` function which can
    do common cleaning tasks:
    `modelsummary(model, coef_rename = coef_rename)`

- gof_map:

  rename, reorder, and omit goodness-of-fit statistics and other model
  information. This argument accepts 4 types of values:

  - NULL (default): the
    [`modelsummary::gof_map`](https://modelsummary.com/man/gof_map.html)
    dictionary is used for formatting, and all unknown statistic are
    included.

  - character vector: "all", "none", or a vector of statistics such as
    `c("rmse", "nobs", "r.squared")`. Elements correspond to colnames in
    the data.frame produced by `get_gof(model)`. The
    [`modelsummary::gof_map`](https://modelsummary.com/man/gof_map.html)
    default dictionary is used to format and rename statistics.

  - NA: excludes all statistics from the bottom part of the table.

  - data.frame with 3 columns named "raw", "clean", "fmt". Unknown
    statistics are omitted. See the 'Examples' section below. The `fmt`
    column in this data frame only accepts integers. For more
    flexibility, use a list of lists, as described in the next bullet.

  - list of lists, each of which includes 3 elements named "raw",
    "clean", "fmt". Unknown statistics are omitted. The `fmt` element
    can be a string (`?fmt_sprintf`), numeric value (`?fmt_decimal`), or
    function which will be used to round/format the string in question.
    See the 'Examples section below'.

- gof_omit:

  string regular expression (perl-compatible) used to determine which
  statistics to omit from the bottom section of the table. A "negative
  lookahead" can be used to specify which statistics to *keep* in the
  table. Examples:

  - `"IC"`: omit statistics matching the "IC" substring.

  - `"BIC|AIC"`: omit statistics matching the "AIC" or "BIC" substrings.

  - `"^(?!.*IC)"`: keep statistics matching the "IC" substring.

## Value

A kableExtra object that is instantly customizable by kableExtra's suite
of functions.

## Examples

``` r
## Using panelsummary_raw

ols_1 <- lm(mpg ~ hp + cyl, data = mtcars)

panelsummary_raw(ols_1, ols_1)
#>           term Model 1
#> 1  (Intercept)  36.908
#> 2              (2.191)
#> 3           hp  -0.019
#> 4              (0.015)
#> 5          cyl  -2.265
#> 6              (0.576)
#> 7     Num.Obs.      32
#> 8           R2   0.741
#> 9      R2 Adj.   0.723
#> 10         AIC   169.6
#> 11         BIC   175.4
#> 12    Log.Lik. -80.781
#> 13        RMSE    3.02
#> 14 (Intercept)  36.908
#> 15             (2.191)
#> 16          hp  -0.019
#> 17             (0.015)
#> 18         cyl  -2.265
#> 19             (0.576)
#> 20    Num.Obs.      32
#> 21          R2   0.741
#> 22     R2 Adj.   0.723
#> 23         AIC   169.6
#> 24         BIC   175.4
#> 25    Log.Lik. -80.781
#> 26        RMSE    3.02


## Including multiple models------------------

panelsummary_raw(list(ols_1, ols_1, ols_1), ols_1,
              caption = "Multiple models",
              stars = TRUE)
#>           term   Model 1   Model 2   Model 3
#> 1  (Intercept) 36.908*** 36.908*** 36.908***
#> 2                (2.191)   (2.191)   (2.191)
#> 3           hp    -0.019    -0.019    -0.019
#> 4                (0.015)   (0.015)   (0.015)
#> 5          cyl -2.265*** -2.265*** -2.265***
#> 6                (0.576)   (0.576)   (0.576)
#> 7     Num.Obs.        32        32        32
#> 8           R2     0.741     0.741     0.741
#> 9      R2 Adj.     0.723     0.723     0.723
#> 10         AIC     169.6     169.6     169.6
#> 11         BIC     175.4     175.4     175.4
#> 12    Log.Lik.   -80.781   -80.781   -80.781
#> 13        RMSE      3.02      3.02      3.02
#> 14 (Intercept) 36.908***                    
#> 15               (2.191)                    
#> 16          hp    -0.019                    
#> 17               (0.015)                    
#> 18         cyl -2.265***                    
#> 19               (0.576)                    
#> 20    Num.Obs.        32                    
#> 21          R2     0.741                    
#> 22     R2 Adj.     0.723                    
#> 23         AIC     169.6                    
#> 24         BIC     175.4                    
#> 25    Log.Lik.   -80.781                    
#> 26        RMSE      3.02                    

```
