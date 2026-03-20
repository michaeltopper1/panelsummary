# Pass a panelsummary::panelsummary_raw dataframe into kableExtra::kbl() with typical defaults

\`clean_raw\` Passes a panelsummary::panelsummary_raw dataframe that has
(or has not) been edited further into kableExtra::kbl() with default
settings that look publication-ready. This includes changing the column
names and fixing the alignment.

## Usage

``` r
clean_raw(
  data.frame,
  alignment = NULL,
  colnames = NULL,
  format = NULL,
  caption = NULL,
  pretty_num = FALSE,
  booktabs = FALSE,
  linesep = if (booktabs) c("", "", "", "", "\\addlinespace") else "\\hline"
)
```

## Arguments

- data.frame:

  The data.frame (or tibble) from panelsummary::panelsummary_raw() that
  has been manipulated.

- alignment:

  A character string. By default, it is set to left adjusting the first
  column, and centering the rest of the columns. For example, a model
  with three columns will have adjustment of "lcc".

- colnames:

  An optional vector of strings. The vector of strings should have the
  same length as the number columns of the table. \* \`NULL\` (the
  default): colnames are defaulted to a whitespace, followed by (1),
  (2), ....etc.

- format:

  A character string. Possible values are latex, html, pipe (Pandoc's
  pipe tables), simple (Pandoc's simple tables), and rst. The value of
  this argument will be automatically determined if the function is
  called within a knitr document. The format value can also be set in
  the global option knitr.table.format. If format is a function, it must
  return a character string.

- caption:

  A string. The table caption.

- pretty_num:

  A logical. If TRUE, then numbers over 999 have a comma printing
  format.

- booktabs:

  T/F for whether to enable the booktabs format for tables. I personally
  would recommend you turn this on for every latex table except some
  special cases.

- linesep:

  By default, in booktabs tables, kable insert an extra space every five
  rows for clear display. If you don't want this feature or if you want
  to do it in a different pattern, you can consider change this option.
  The default is c(”, ”, ”, ”, '\addlinespace'). Also, if you are not
  using booktabs, but you want a cleaner display, you can change this to
  ”.

## Value

A raw data frame that is ready for further manipulation.

## Examples

``` r
## Cleaning a panelsummary_raw dataframe with clean_raw

ols_1 <- lm(mpg ~ hp + cyl, data = mtcars)

panelsummary_raw(ols_1, ols_1) |> clean_raw()
#> <table>
#>  <thead>
#>   <tr>
#>    <th style="text-align:left;">   </th>
#>    <th style="text-align:center;"> (1) </th>
#>   </tr>
#>  </thead>
#> <tbody>
#>   <tr>
#>    <td style="text-align:left;"> (Intercept) </td>
#>    <td style="text-align:center;"> 36.908 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (2.191) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> hp </td>
#>    <td style="text-align:center;"> -0.019 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (0.015) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> cyl </td>
#>    <td style="text-align:center;"> -2.265 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (0.576) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> Num.Obs. </td>
#>    <td style="text-align:center;"> 32 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> R2 </td>
#>    <td style="text-align:center;"> 0.741 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> R2 Adj. </td>
#>    <td style="text-align:center;"> 0.723 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> AIC </td>
#>    <td style="text-align:center;"> 169.6 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> BIC </td>
#>    <td style="text-align:center;"> 175.4 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> Log.Lik. </td>
#>    <td style="text-align:center;"> -80.781 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> RMSE </td>
#>    <td style="text-align:center;"> 3.02 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> (Intercept) </td>
#>    <td style="text-align:center;"> 36.908 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (2.191) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> hp </td>
#>    <td style="text-align:center;"> -0.019 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (0.015) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> cyl </td>
#>    <td style="text-align:center;"> -2.265 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;">  </td>
#>    <td style="text-align:center;"> (0.576) </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> Num.Obs. </td>
#>    <td style="text-align:center;"> 32 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> R2 </td>
#>    <td style="text-align:center;"> 0.741 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> R2 Adj. </td>
#>    <td style="text-align:center;"> 0.723 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> AIC </td>
#>    <td style="text-align:center;"> 169.6 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> BIC </td>
#>    <td style="text-align:center;"> 175.4 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> Log.Lik. </td>
#>    <td style="text-align:center;"> -80.781 </td>
#>   </tr>
#>   <tr>
#>    <td style="text-align:left;"> RMSE </td>
#>    <td style="text-align:center;"> 3.02 </td>
#>   </tr>
#> </tbody>
#> </table>



```
