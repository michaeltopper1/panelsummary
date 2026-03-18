# Checks that the class of each regression is of the type "fixest"

\`check_class_fixest\` ensures that each class is of the type "fixest"
so that the mean of the dependent variable can be taken using fixest
built-in methods.

## Usage

``` r
check_class_fixest(models)
```

## Arguments

- models:

  Input list. This is the input list of models taken from the user.

## Value

A Boolean of TRUE/FALSE indicating whether the elements are of fixest
type.
