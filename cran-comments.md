## R CMD check results

0 errors | 0 warnings | 3 notes

Each note is described in the following bullet points:

* This is a new release.

* checking for unstated dependencies in vignettes ... NOTE

The package `tibble` is used in the vignette for demonstration purposes, but it is not necessary for package functions to work properly.

* checking R code for possible problems ... NOTE

A global function is created for one of the package features in `panelsummary::panelsummary`. The `mean_dependent` argument creates this global function and immediately deletes it. The global function is a necessary intermediary step for this feature to exist, however, since the function is deleted before the function finishes executing, the user will have no knowledge such a function was created in their environment.
