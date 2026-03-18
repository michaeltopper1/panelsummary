# Adding Rows to a panelsummary Table

This vignette shows how to add rows to `panelsummary` tables. Since
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md)
returns `kableExtra` objects, adding rows is impossible using the base
function
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md).
This can be a nuisance when you want to include additional statistics to
your table. However, the workaround is to use the
[`panelsummary::panelsummary_raw`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary_raw.md)
function.

## panelsummary::panelsummary_raw

The
[`panelsummary::panelsummary_raw`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary_raw.md)
function returns a dataframe that can be manipulated. The trade-off is
that the table will need to be customized using the `kableExtra`
package, although some of this customization can be completed using the
[`panelsummary::clean_raw`](https://michaeltopper1.github.io/panelsummary/reference/clean_raw.md)
function (see example).

## Workflow

If you want to create a table with panels that has additional
statistical rows, the workflow will be the following:

- Estimate your models (preferably with the `fixest` package).
- Pass your models into
  [`panelsummary::panelsummary_raw`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary_raw.md)
  to get a manipulable dataframe.
- Manipulate the dataframe (preferably with
  [`dplyr::add_row`](https://tibble.tidyverse.org/reference/add_row.html)).
- Use
  [`panelsummary::clean_raw`](https://michaeltopper1.github.io/panelsummary/reference/clean_raw.md)
  to return a `kableExtra` object.
- Use
  [`kableExtra::pack_rows`](https://rdrr.io/pkg/kableExtra/man/group_rows.html)
  to create panel labels.

## Example: Adding Additional Rows to Each Panel

To demonstrate how to add a row to each panel of a
[`panelsummary::panelsummary_raw`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary_raw.md)
table, I will assume that each panel needs one additional row for the
wild-cluster-bootstrap p-values of the `cyl` column from the `mtcars`
data. While I will not explicitly calculate these (in fact, they will be
completely made up), the following steps will show how to complete such
task.

Consider the following models, estimated using the `fixest` package:

``` r
library(panelsummary)

## Panel A: mpg dependent variable
mpg_1 <- fixest::feols(mpg ~cyl + disp, data = mtcars)
mpg_2 <- fixest::feols(mpg ~ cyl + am, data = mtcars)

## Panel B: wt dependent variable
wt_1 <- fixest::feols(wt ~ cyl + disp, data = mtcars)
wt_2 <- fixest::feols(wt ~ cyl + am, data = mtcars)
```

Recall that putting each of these two models in a list will result in
multiple specifications per-panel.

``` r
## putting each panel's models into a list—one for each panel
panel_a_mpg <- list(mpg_1, mpg_2)
panel_b_wt <- list(wt_1, wt_2)
```

Now, I will pass these two lists into
[`panelsummary::panelsummary_raw`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary_raw.md).
Note that this function shares many of the same arguments as
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md).
In the following, I will also use the arguments `stars` (significance
stars), `mean_dependent` (for dependent variable mean), and `gof_omit`
(to omit $R^{2}$ statistics):

``` r
## creating the dataframe
panelsummary_raw(panel_a_mpg, panel_b_wt,
                 stars = "econ",
                 mean_dependent = T,
                 gof_omit = "^R")
#>                          term   Model 1   Model 2
#> 1                 (Intercept) 34.661*** 34.522***
#> 2                               (2.547)   (2.603)
#> 3                         cyl  -1.587** -2.501***
#> 4                               (0.712)   (0.361)
#> 5                        disp   -0.021*          
#> 6                               (0.010)          
#> 7                          am              2.567*
#> 8                                         (1.291)
#> 9  Mean of Dependent Variable    20.091    20.091
#> 10                   Num.Obs.        32        32
#> 11                        AIC     165.1     165.2
#> 12                        BIC     169.5     169.6
#> 13                 Std.Errors       IID       IID
#> 14                (Intercept)  1.773***  1.566***
#> 15                              (0.386)   (0.453)
#> 16                        cyl    -0.054  0.317***
#> 17                              (0.108)   (0.063)
#> 18                       disp  0.008***          
#> 19                              (0.002)          
#> 20                         am           -0.765***
#> 21                                        (0.225)
#> 22 Mean of Dependent Variable     3.217     3.217
#> 23                   Num.Obs.        32        32
#> 24                        AIC      44.4      53.3
#> 25                        BIC      48.8      57.7
#> 26                 Std.Errors       IID       IID
```

The return value of this output is a dataframe without panel labels.
Given that it is a dataframe, you can use `dplyr` functions to easily
manipulate. For instance, I will use the `dplyr::add_rows` function to
add the pseudo wild-cluster-bootstrap p-values to the table:

``` r
## adding rows using dplyr::add_row
bootstrap_table <- panelsummary_raw(panel_a_mpg, panel_b_wt,
                 stars = "econ",
                 mean_dependent = T,
                 gof_omit = "R") |> 
  dplyr::add_row(term = "Wild Cluster Boot P-value (cyl)",
                 `Model 1` = ".001",
                 `Model 2` = ".002",
                .before = 10) |> 
  dplyr::add_row(term = "Wild Cluster Boot P-value (cyl)",
                 `Model 1` = ".001",
                 `Model 2` = ".005",
                 .before = 22)

bootstrap_table
#>                               term   Model 1   Model 2
#> 1                      (Intercept) 34.661*** 34.522***
#> 2                                    (2.547)   (2.603)
#> 3                              cyl  -1.587** -2.501***
#> 4                                    (0.712)   (0.361)
#> 5                             disp   -0.021*          
#> 6                                    (0.010)          
#> 7                               am              2.567*
#> 8                                              (1.291)
#> 9       Mean of Dependent Variable    20.091    20.091
#> 10 Wild Cluster Boot P-value (cyl)      .001      .002
#> 11                        Num.Obs.        32        32
#> 12                             AIC     165.1     165.2
#> 13                             BIC     169.5     169.6
#> 14                      Std.Errors       IID       IID
#> 15                     (Intercept)  1.773***  1.566***
#> 16                                   (0.386)   (0.453)
#> 17                             cyl    -0.054  0.317***
#> 18                                   (0.108)   (0.063)
#> 19                            disp  0.008***          
#> 20                                   (0.002)          
#> 21                              am           -0.765***
#> 22 Wild Cluster Boot P-value (cyl)      .001      .005
#> 23                                             (0.225)
#> 24      Mean of Dependent Variable     3.217     3.217
#> 25                        Num.Obs.        32        32
#> 26                             AIC      44.4      53.3
#> 27                             BIC      48.8      57.7
#> 28                      Std.Errors       IID       IID
```

Now the dataframe is ready to be passed into
[`kableExtra::kbl`](https://rdrr.io/pkg/kableExtra/man/kbl.html) to
further customize it with panel headers/column names etc. Alternatively,
you can use the
[`panelsummary::clean_raw`](https://michaeltopper1.github.io/panelsummary/reference/clean_raw.md)
function to get a few desirable traits and speed up the process. In
particular, the
[`panelsummary::clean_raw`](https://michaeltopper1.github.io/panelsummary/reference/clean_raw.md)
function does the following by default:

- Passes the dataframe into
  [`kableExtra::kbl`](https://rdrr.io/pkg/kableExtra/man/kbl.html)
- Changes the alignment to Left for the first column, and Center for all
  remaining columns.
- Changes the names of the columns to a blank white space for the first
  column, and consecutive numbers in the remaining columns.

However, you can also pass in a caption using the `caption` argument:

``` r
## creating a kableExtra object with a few desirable defaults
bootstrap_table |> 
  clean_raw(caption = "A customized panelsummary table with added rows.")
```

[TABLE]

A customized panelsummary table with added rows.

Finally, to get the desired panel labels, you will need to use
[`kableExtra::pack_rows`](https://rdrr.io/pkg/kableExtra/man/group_rows.html):

``` r
## creating the final panels.
bootstrap_table |> 
  clean_raw(caption = "A customized panelsummary table with added rows.") |> 
  kableExtra::pack_rows("Panel A: MPG", 1, 14,
                        italic = T,
                        bold = F) |> 
  kableExtra::pack_rows("Panel B: Cyl", 15, 28, 
                        italic = T,
                        bold = F) |> 
  kableExtra::footnote(list("* p < 0.1, ** p < 0.05, *** p < 0.01")) |> 
  kableExtra::kable_classic(full_width = F, html_font = "Cambria") 
```

[TABLE]

A customized panelsummary table with added rows.
