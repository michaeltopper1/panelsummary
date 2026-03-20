# Introduction to panelsummary

`panelsummary` consists of one main function,
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md),
to provide a simple, yet customizable way to create a regression table
with multiple panels. As of this writing, the package is intended for
use with regressions of class `lm` and `fixest`, with an emphasis on the
latter. There are more classes in the pipeline, and you can always check
[`panelsummary::models_supported`](https://michaeltopper1.github.io/panelsummary/reference/models_supported.md)
for an exhaustive list of models supported. However, it is likely that a
regression package will work if `modelsummary` supports it, although
some functionality may be limited (e.g., `mean_dependent` argument will
only work with `fixest` regressions).

To begin, load in the `panelsummary` package.

``` r
library(panelsummary)
```

## Motivating Example

To motivate the power of `panelsummary`, consider a model using the
`mtcars` dataset:

$$Y_{i} = \beta_{0} + \beta_{1}hp_{i} + \beta_{2}cyl_{i} + e_{i}$$ Where
$Y_{i}$ is the dependent variable, which can be either $mpg_{i}$ or
$disp$ of car $i$, $hp_{i}$ is the horsepower, $cyl_{i}$ is the number
of cylinders, and $e_{i}$ is the error term. To estimate this model with
both of the dependent variables, the following code is provided:

``` r
## estimating the model with two depedent variables:
## 1) mpg and 2) disp
mpg_1 <- lm(mpg ~ hp + cyl, data = mtcars)
disp_1 <- lm(disp ~ hp + cyl, data = mtcars)
```

While one option to present the regression coefficients in a table would
be to create a separate regression table for each, there is a more
concise, and cleaner way to present this information. This is where
`panelsummary` is most useful. With a simple pass of
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md),
a beautiful regression table is created without any additional editing,
and can immediately be viewed in the RStudio Viewer panel.

``` r
## creating a beautiful regression table with panelsummary
panelsummary(mpg_1, disp_1, 
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
```

[TABLE]

Note that the number of arguments passed into `...` is how the
delineation of panels is determined. Importantly, the length of the
character vector passed into `panel_labels` must match the number of
arguments passed into `...`. This ensures that each panel has its own
label.

## Cleaning Variable Names

Behind the scenes, `panelsummary` uses `modelsummary` to help create the
regression tables. The benefit of this is the ability to use `coef_map`
argument (which is passed through to
[`modelsummary::modelsummary`](https://modelsummary.com/man/modelsummary.html))
to clean variable names. Recall that to use `coef_map`, the syntax is
`c("old_name" = "new_name")`:

``` r
panelsummary(mpg_1, disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder"),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
```

[TABLE]

For more information on `coef_map`, see the `modelsummary`
documentation.

## Excluding Goodness-of-Fit Statistics

Similar to cleaning names, `panelsummary` also supports the `gof_map`
and `gof_omit` arguments from `modelsummary`. In the following,
`gof_map` will be used to change the name of “Num.Obs” to “Observations”
and “F” to “F-stat”, while removing the other goodness-of-fit
statistics:

``` r
## mapping the goodness of fit statistics to new names - see modelsummary for more details
gm <- tibble::tribble(
        ~raw,      ~clean,          ~fmt,  ~omit,
        "nobs",      "Observations",     0,  FALSE,
        "F", "F-stat",               3,  FALSE
)
panelsummary(mpg_1, disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
```

[TABLE]

For more information on how to use `gof_map`, see the modelsummary
documentation.

## Adding Additional Models to the Table

It is simple to add additional models to each panel in the table. This
is most useful when presenting robustness of estimates with a variety of
different explanatory variables. As an example, consider three more
models with `mpg` as the dependent variable:

``` r
## creating two additional models for the first panel 
mpg_2 <- lm(mpg ~ hp + cyl + drat, data = mtcars)
mpg_3 <- lm(mpg ~hp + cyl + drat + wt, data = mtcars)
```

To add these models to Panel A, simply replace `mpg_1` with
`list(mpg_1, mpg_2, mpg_3)` in the original code:

``` r
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
```

[TABLE]

## Adding Additional Panels to the Table

As alluded to, the number of arguments passed into `...` will determine
the number of panels created in the table. Hence, simply add another
argument to `...`, and a corresponding label to `panel_labels`:

``` r
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, list(mpg_1, mpg_2),
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement", "Panel C: Demonstration of Additional Panel"))
```

[TABLE]

At this time, `panelsummary` **will only support up to five panels**.
This is done intentionally to discourage an overly long table.

## Adding Significance-Stars

To add significance stars, simply set the `stars` argument to `TRUE`. By
default, `panelsummary` uses the following convention (symbol=pvalue):
+=.1, \*=.05, \*\*=.01, \*\*\*=0.001.

However, you can also change the significance stars by passing in a
vector of corresponding significance:

``` r
## change the significance stars to match economic convention
table_stars <- panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             stars = c('*' = .1, '**' = .05, '***' = .01),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
table_stars 
```

[TABLE]

However, you if you plan on using the economics convention of \*=.1,
\*\*=.05, \*\*\*=.01, you can simply pass in the word “econ”.

## Customizing With `kableExtra`

When
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md)
is executed, a `kableExtra` object is created. The benefit of this
feature is that all of `kableExtra`’s customizing functions are ready to
pipe into. For instance, suppose a table calls for a new theme, a header
above the model numbers, a footnote denoting significance:

``` r
library(kableExtra)

## customizing the table with kableExtra
table_stars |> 
  kable_classic(full_width = F, html_font = "Cambria") |> 
  add_header_above(c(" " = 1, "Models Using mtcars" = 3)) |> 
  footnote(list("* p < 0.1, ** p < 0.05, *** p < 0.01",
                "Customizations done using kableExtra package"))
```

[TABLE]

## Renaming Colnames

By default, `panelsummary` names the first column with an empty space,
and each subsequent column with the numbers (1), (2), (3)…etc. To rename
the columns, use the `colnames` argument and pass in a character vector
which matches the length of the columns in the table. In this particular
example, the column names are set to “Column 1”, “Column 2”, “Column 3”,
and “Column 4”. Note that no element in the vector may be empty and
hence, a single whitespace character is needed to give a blank look (not
shown here):

``` r
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             stars =c('*' = .1, '**' = .05, '***' = .01),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"),
             colnames = c("Column 1", "Column 2", "Column 3", "Column 4")) |> 
  kable_classic(full_width = F, html_font = "Cambria") 
```

| Column 1              | Column 2     | Column 3 | Column 4     |
|-----------------------|--------------|----------|--------------|
| Panel A: MPG          |              |          |              |
| Horse Power           | -0.019       | -0.029\* | -0.021       |
|                       | (0.015)      | (0.015)  | (0.013)      |
| Cylinder              | -2.265\*\*\* | -1.361\* | -0.762       |
|                       | (0.576)      | (0.735)  | (0.635)      |
| Rear Axle Ratio       |              | 2.841\*  | 0.818        |
|                       |              | (1.522)  | (1.387)      |
| Weight (1000lbs)      |              |          | -2.973\*\*\* |
|                       |              |          | (0.818)      |
| Observations          | 32           | 32       | 32           |
| Panel B: Displacement |              |          |              |
| Horse Power           | 0.236        |          |              |
|                       | (0.258)      |          |              |
| Cylinder              | 55.063\*\*\* |          |              |
|                       | (9.898)      |          |              |
| Observations          | 32           |          |              |

## Italics/Bolds/Horizontal Lines

The labels passed into `panel_labels` can be changed to bold and/or
italics using the `bold` and `italic` arguments. Furthermore, horizontal
lines can be added below each label using the `hline_after` argument.

## Pretty Numbers

Setting the `pretty_num` argument to `TRUE` will give comma-separated
numbers. For instance, default printing of the number one-thousand is
“1000”, while with `pretty_num = TRUE`, this would be “1,000”.

## Output

The output is controlled using the `format` argument. By default, a
`kableExtra` object is created which works seamlessly with Rmarkdown and
knits automatically to LaTeX and HTML. For users that prefer to use
their own LaTeX software over Rmarkdown, the `format` option can be
switched to “latex” to give the corresponding LaTeX code for the table.
*Note:* the tables are automatically set to booktabs style and therefore
the booktabs LaTeX package is necessary (`usepackage{booktabs}`) in your
tex file if the LaTeX output is copy and pasted.

## Use with `fixest`

The `panelsummary` package works best with the `fixest` package to fully
take advantage of its offerings. See the [Using `panelsummary` with
`fixest`
vignette](https://michaeltopper1.github.io/panelsummary/articles/with_fixest.html).
Some of the capabilities include:

- Collapsing fixed effects
- Including the mean of the dependent variable.

## Adding rows to a panelsummary table

Adding custom rows requires a different workflow rather than simply
calling
[`panelsummary::panelsummary`](https://michaeltopper1.github.io/panelsummary/reference/panelsummary.md),
although it is still quite simple. See the [Adding Rows to a
panelsummary
Table](https://michaeltopper1.github.io/panelsummary/articles/adding_rows.html)
vignette for a detailed example.
