
<!-- README.md is generated from README.Rmd. Please edit that file -->

# panelsummary

<!-- badges: start -->

    #> ✔ Setting active project to '/Users/michaeltopper/panelsummary'
    #> ✔ Saving 'r-lib/actions/examples/check-standard.yaml@v2' to '.github/workflows/R-CMD-check.yaml'
    #> • Learn more at <https://github.com/r-lib/actions/blob/v2/examples/README.md>.

[![Codecov test
coverage](https://codecov.io/gh/michaeltopper1/panelsummary/branch/master/graph/badge.svg)](https://app.codecov.io/gh/michaeltopper1/panelsummary?branch=master)
[![R-CMD-check](https://github.com/michaeltopper1/panelsummary/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/michaeltopper1/panelsummary/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`panelsummary` creates publication-quality regression tables that have
multiple panels. Multiple panel regression tables are particularly
useful for showing output for models that are estimated with multiple
dependent variables. A simple call to `panelsummary::panelsummary` will
create a regression table that can be viewed in the RStudio Viewer
panel, be edited with `kableExtra`’s suite of customization functions,
and be saved to latex. Moreover, `panelsummary` allows the mean of the
dependent variable to be automatically added to the regression table—a
feature that is currently absent out-of-the-box for most popular
regression table packages.

As of now, `panelsummary` is intended for use with the `fixest` package,
although more model classes are planned. Please use the
`panelsummary::models_supported` function to view a list of all model
classes that are currently supported.

## Installation

You can install the development version of panelsummary from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("michaeltopper1/panelsummary")
```

## What makes panelsummary different?

As a motivating example, consider the following (nonsensical) models:

``` r
library(fixest)
library(panelsummary)

## mpg regressions--------
mpg_model_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)

mpg_model_2 <- mtcars |>
    fixest::feols(mpg ~ cyl | gear + carb + am, cluster = ~hp)

## disp regressions --------
disp_model_1 <- mtcars |>
    fixest::feols(disp ~  cyl | gear + carb, cluster = ~hp)

disp_model_2 <- mtcars |>
    fixest::feols(disp ~  cyl | gear + carb + am, cluster = ~hp)
```

Observe that of the four models specified above, the first two and last
two mimic explanatory variables and differ only by dependent variables.
Instead of creating a table for the two models with `mpg` as the
dependent variable, and another for the two models with `disp` as the
dependent variable, `panelsummary::panelsummary` can create one
regression table with two (or more!) panels:

``` r
example_table <- panelsummary(list(mpg_model_1, mpg_model_2), list(disp_model_1, disp_model_2), 
             num_panels = 2, 
             panel_labels = c("MPG", "Displacement"), 
             stars = T,
             caption = "The correlation of cyl on disp and mpg")

example_table
```

<table>
<caption>
The correlation of cyl on disp and mpg
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">

1)  </th>
    <th style="text-align:center;">

    2)  </th>
        </tr>
        </thead>
        <tbody>
        <tr grouplength="14">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel A: MPG
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        cyl
        </td>
        <td style="text-align:center;">
        -0.907
        </td>
        <td style="text-align:center;">
        -1.093
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (0.789)
        </td>
        <td style="text-align:center;">
        (0.801)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Num.Obs.
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.818
        </td>
        <td style="text-align:center;">
        0.835
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Adj.
        </td>
        <td style="text-align:center;">
        0.755
        </td>
        <td style="text-align:center;">
        0.768
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within
        </td>
        <td style="text-align:center;">
        0.058
        </td>
        <td style="text-align:center;">
        0.088
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within Adj.
        </td>
        <td style="text-align:center;">
        0.017
        </td>
        <td style="text-align:center;">
        0.046
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        AIC
        </td>
        <td style="text-align:center;">
        154.3
        </td>
        <td style="text-align:center;">
        151.1
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        BIC
        </td>
        <td style="text-align:center;">
        157.2
        </td>
        <td style="text-align:center;">
        154.0
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        RMSE
        </td>
        <td style="text-align:center;">
        2.53
        </td>
        <td style="text-align:center;">
        2.41
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Std.Errors
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: am
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr grouplength="14">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel B: Displacement
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        cyl
        </td>
        <td style="text-align:center;">
        43.306\*\*
        </td>
        <td style="text-align:center;">
        43.905\*\*
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (13.075)
        </td>
        <td style="text-align:center;">
        (13.489)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Num.Obs.
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.909
        </td>
        <td style="text-align:center;">
        0.910
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Adj.
        </td>
        <td style="text-align:center;">
        0.878
        </td>
        <td style="text-align:center;">
        0.873
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within
        </td>
        <td style="text-align:center;">
        0.399
        </td>
        <td style="text-align:center;">
        0.401
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within Adj.
        </td>
        <td style="text-align:center;">
        0.373
        </td>
        <td style="text-align:center;">
        0.373
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        AIC
        </td>
        <td style="text-align:center;">
        325.5
        </td>
        <td style="text-align:center;">
        325.4
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        BIC
        </td>
        <td style="text-align:center;">
        328.4
        </td>
        <td style="text-align:center;">
        328.3
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        RMSE
        </td>
        <td style="text-align:center;">
        36.76
        </td>
        <td style="text-align:center;">
        36.68
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Std.Errors
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: am
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        </tbody>
        </table>
        With one simple function, a variety of customization has taken
        place. However, `panelsummary` has plenty more to offer.

### Customize with `kableExtra`

`panelsummary` outputs an object with `kableExtra` class. This means
that editing with `kableExtra`’s functions is as simple as piping in
`kableExtra` functions:

``` r
library(kableExtra)

example_table |>
  add_header_above(c(" " = 1, "Models" = 2)) |>
  kable_styling() |>
  footnote("This table was created with a combination of panelsummary and kableExtra.")
```

<table class="table" style="margin-left: auto; margin-right: auto;border-bottom: 0;">
<caption>
The correlation of cyl on disp and mpg
</caption>
<thead>
<tr>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="1">
</th>
<th style="border-bottom:hidden;padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2">

<div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">

Models

</div>

</th>
</tr>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">

1)  </th>
    <th style="text-align:center;">

    2)  </th>
        </tr>
        </thead>
        <tbody>
        <tr grouplength="14">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel A: MPG
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        cyl
        </td>
        <td style="text-align:center;">
        -0.907
        </td>
        <td style="text-align:center;">
        -1.093
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (0.789)
        </td>
        <td style="text-align:center;">
        (0.801)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Num.Obs.
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.818
        </td>
        <td style="text-align:center;">
        0.835
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Adj.
        </td>
        <td style="text-align:center;">
        0.755
        </td>
        <td style="text-align:center;">
        0.768
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within
        </td>
        <td style="text-align:center;">
        0.058
        </td>
        <td style="text-align:center;">
        0.088
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within Adj.
        </td>
        <td style="text-align:center;">
        0.017
        </td>
        <td style="text-align:center;">
        0.046
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        AIC
        </td>
        <td style="text-align:center;">
        154.3
        </td>
        <td style="text-align:center;">
        151.1
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        BIC
        </td>
        <td style="text-align:center;">
        157.2
        </td>
        <td style="text-align:center;">
        154.0
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        RMSE
        </td>
        <td style="text-align:center;">
        2.53
        </td>
        <td style="text-align:center;">
        2.41
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Std.Errors
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: am
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr grouplength="14">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel B: Displacement
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        cyl
        </td>
        <td style="text-align:center;">
        43.306\*\*
        </td>
        <td style="text-align:center;">
        43.905\*\*
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (13.075)
        </td>
        <td style="text-align:center;">
        (13.489)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Num.Obs.
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.909
        </td>
        <td style="text-align:center;">
        0.910
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Adj.
        </td>
        <td style="text-align:center;">
        0.878
        </td>
        <td style="text-align:center;">
        0.873
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within
        </td>
        <td style="text-align:center;">
        0.399
        </td>
        <td style="text-align:center;">
        0.401
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2 Within Adj.
        </td>
        <td style="text-align:center;">
        0.373
        </td>
        <td style="text-align:center;">
        0.373
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        AIC
        </td>
        <td style="text-align:center;">
        325.5
        </td>
        <td style="text-align:center;">
        325.4
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        BIC
        </td>
        <td style="text-align:center;">
        328.4
        </td>
        <td style="text-align:center;">
        328.3
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        RMSE
        </td>
        <td style="text-align:center;">
        36.76
        </td>
        <td style="text-align:center;">
        36.68
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Std.Errors
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        <td style="text-align:center;">
        by: hp
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: am
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <span style="font-style: italic;">Note: </span>
        </td>
        </tr>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <sup></sup> This table was created with a combination of
        panelsummary and kableExtra.
        </td>
        </tr>
        </tfoot>
        </table>

        ### Customize with `modelsummary` arguments

The backend of `panelsummary` actually calls `modelsummary` and
therefore, many `panelsummary` arguments are shared with `modelsummary`
and work entirely the same. For instance, to reduce/rename the number of
statistics shown on the table and clean up the variable names, you can
use the arguments, `gof_map` and `coef_map` exactly as you would in
`modelsummary`:

``` r
## creating a tibble to include only observations and fixed effects
gm <- tibble::tribble(
    ~raw,        ~clean,          ~fmt,
    "nobs",      "Observations", 0,
    "r.squared", "R2", 3,
    "FE: gear", "FE: Gear", 0,
    "FE: carb", "FE: Carb", 0,
    "FE: am", "FE: AM", 0)


## adding in the gof_map and coef_map arguments - identical to modelsummary
panelsummary(list(mpg_model_1, mpg_model_2), list(disp_model_1, disp_model_2), 
             num_panels = 2, 
             panel_labels = c("MPG", "Displacement"), 
             stars = T,
             caption = "The correlation of cyl on disp and mpg",
             gof_map = gm,
             coef_map = c("cyl" = "Cylinder")) |>
  add_header_above(c(" " = 1, "Models" = 2)) |>
  kable_styling() |>
  footnote("This table was created with a combination of panelsummary and kableExtra.")
```

<table class="table" style="margin-left: auto; margin-right: auto;border-bottom: 0;">
<caption>
The correlation of cyl on disp and mpg
</caption>
<thead>
<tr>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="1">
</th>
<th style="border-bottom:hidden;padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2">

<div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">

Models

</div>

</th>
</tr>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">

1)  </th>
    <th style="text-align:center;">

    2)  </th>
        </tr>
        </thead>
        <tbody>
        <tr grouplength="7">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel A: MPG
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Cylinder
        </td>
        <td style="text-align:center;">
        -0.907
        </td>
        <td style="text-align:center;">
        -1.093
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (0.789)
        </td>
        <td style="text-align:center;">
        (0.801)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Observations
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.818
        </td>
        <td style="text-align:center;">
        0.835
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: Gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: Carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: AM
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr grouplength="7">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel B: Displacement
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Cylinder
        </td>
        <td style="text-align:center;">
        43.306\*\*
        </td>
        <td style="text-align:center;">
        43.905\*\*
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (13.075)
        </td>
        <td style="text-align:center;">
        (13.489)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Observations
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.909
        </td>
        <td style="text-align:center;">
        0.910
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: Gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: Carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        FE: AM
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <span style="font-style: italic;">Note: </span>
        </td>
        </tr>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <sup></sup> This table was created with a combination of
        panelsummary and kableExtra.
        </td>
        </tr>
        </tfoot>
        </table>

### Collapsing fixed effects

While the tables displayed are clear, there is a lot of redundant
information in the fixed effects. It is common that multiple dependent
variables are tested against the same variety of models. To increase
clarity, you can collapse the fixed effects to their own panel using the
`collapse_fe` argument:

``` r
panelsummary(list(mpg_model_1, mpg_model_2), list(disp_model_1, disp_model_2), 
             num_panels = 2, 
             panel_labels = c("MPG", "Displacement"), 
             stars = T,
             caption = "The correlation of cyl on disp and mpg",
             gof_map = gm,
             coef_map = c("cyl" = "Cylinder"),
             collapse_fe = T) |>
  add_header_above(c(" " = 1, "Models" = 2)) |>
  kable_styling() |>
  footnote("This table was created with a combination of panelsummary and kableExtra.")
#> Warning in panelsummary(list(mpg_model_1, mpg_model_2), list(disp_model_1, :
#> panelsummary does not check if the fixed effects in each panel match—it always
#> assumes they do!
```

<table class="table" style="margin-left: auto; margin-right: auto;border-bottom: 0;">
<caption>
The correlation of cyl on disp and mpg
</caption>
<thead>
<tr>
<th style="empty-cells: hide;border-bottom:hidden;" colspan="1">
</th>
<th style="border-bottom:hidden;padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2">

<div style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">

Models

</div>

</th>
</tr>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">

1)  </th>
    <th style="text-align:center;">

    2)  </th>
        </tr>
        </thead>
        <tbody>
        <tr grouplength="4">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel A: MPG
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Cylinder
        </td>
        <td style="text-align:center;">
        -0.907
        </td>
        <td style="text-align:center;">
        -1.093
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (0.789)
        </td>
        <td style="text-align:center;">
        (0.801)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Observations
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.818
        </td>
        <td style="text-align:center;">
        0.835
        </td>
        </tr>
        <tr grouplength="4">
        <td colspan="3" style="border-bottom: 1px solid;">
        Panel B: Displacement
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Cylinder
        </td>
        <td style="text-align:center;">
        43.306\*\*
        </td>
        <td style="text-align:center;">
        43.905\*\*
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        </td>
        <td style="text-align:center;">
        (13.075)
        </td>
        <td style="text-align:center;">
        (13.489)
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        Observations
        </td>
        <td style="text-align:center;">
        32
        </td>
        <td style="text-align:center;">
        32
        </td>
        </tr>
        <tr>
        <td style="text-align:left;padding-left: 2em;" indentlevel="1">
        R2
        </td>
        <td style="text-align:center;">
        0.909
        </td>
        <td style="text-align:center;">
        0.910
        </td>
        </tr>
        <tr>
        <td style="text-align:left;">
        FE: Gear
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;">
        FE: Carb
        </td>
        <td style="text-align:center;">
        X
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        <tr>
        <td style="text-align:left;">
        FE: AM
        </td>
        <td style="text-align:center;">
        </td>
        <td style="text-align:center;">
        X
        </td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <span style="font-style: italic;">Note: </span>
        </td>
        </tr>
        <tr>
        <td style="padding: 0; " colspan="100%">
        <sup></sup> This table was created with a combination of
        panelsummary and kableExtra.
        </td>
        </tr>
        </tfoot>
        </table>

### Adding the mean of the dependent variables

One of the most enticing features of `panelsummary` is that it can
automatically add in the mean of the dependent variables by setting the
`mean_dependent` argument to `TRUE` which adds the mean to each panel:

``` r
panelsummary(mpg_model_1, disp_model_1, 
             mean_dependent = T, 
             num_panels = 2,
             panel_labels = c("MPG", "Displacement"),
             gof_omit = "R|A|B",
             coef_map = c("cyl" = "Cylinder")) |>
  kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">

1)  </th>
    </tr>
    </thead>
    <tbody>
    <tr grouplength="7">
    <td colspan="2" style="border-bottom: 1px solid;">
    Panel A: MPG
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Cylinder
    </td>
    <td style="text-align:center;">
    -0.907
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    </td>
    <td style="text-align:center;">
    (0.789)
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Mean of Dependent Variable
    </td>
    <td style="text-align:center;">
    20.091
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Num.Obs.
    </td>
    <td style="text-align:center;">
    32
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Std.Errors
    </td>
    <td style="text-align:center;">
    by: hp
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    FE: gear
    </td>
    <td style="text-align:center;">
    X
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    FE: carb
    </td>
    <td style="text-align:center;">
    X
    </td>
    </tr>
    <tr grouplength="7">
    <td colspan="2" style="border-bottom: 1px solid;">
    Panel B: Displacement
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Cylinder
    </td>
    <td style="text-align:center;">
    43.306
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    </td>
    <td style="text-align:center;">
    (13.075)
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Mean of Dependent Variable
    </td>
    <td style="text-align:center;">
    230.722
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Num.Obs.
    </td>
    <td style="text-align:center;">
    32
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    Std.Errors
    </td>
    <td style="text-align:center;">
    by: hp
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    FE: gear
    </td>
    <td style="text-align:center;">
    X
    </td>
    </tr>
    <tr>
    <td style="text-align:left;padding-left: 2em;" indentlevel="1">
    FE: carb
    </td>
    <td style="text-align:center;">
    X
    </td>
    </tr>
    </tbody>
    </table>
