
fixest::setFixest_nthreads(1)

# testing change_to_lists function ----------------------------------------


test_that("giving a list of both lists and non-lists returns a list of only list class", {
  ols_1 <- lm(mpg ~ hp + cyl, data = mtcars)
  ols_2 <- lm(mpg ~ hp + cyl, data = mtcars)
  potential_input <- list(list(ols_1, ols_2), ols_2)
  expect_equal(lapply(change_to_lists(potential_input), class), list("list", "list"))
})


test_that("giving a list of only lists of class lists", {
  ols_1 <- lm(mpg ~ hp + cyl, data = mtcars)
  ols_2 <- lm(mpg ~ hp + cyl, data = mtcars)
  potential_input <- list(list(ols_1, ols_2), list(ols_2))
  expect_equal(lapply(change_to_lists(potential_input), class), list("list", "list"))
})


# testing the check_class_fixest function -----------------------------------------------

test_that("make certain to return false if a non-fixest object is supplied", {
  skip_on_cran()
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  ols_2 <- lm(disp ~  cyl, data = mtcars)
  potential_input <- list(list(ols_1, ols_2), list(ols_2))
  expect_equal(potential_input |>
                 change_to_lists() |>
                 check_class_fixest(), FALSE )
})

test_that("make certain to return false if a non-fixest object is supplied (but not in a list)", {
  skip_on_cran()
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  ols_2 <- lm(disp ~  cyl, data = mtcars)
  potential_input <- list(list(ols_1, ols_2), ols_2)
  expect_equal(potential_input |>
                 change_to_lists() |>
                 check_class_fixest(), FALSE )
})

test_that("make certain to return TRUE when fixest object is supplied", {
  skip_on_cran()
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  potential_input <- list(list(ols_1, ols_2), ols_2)
  expect_equal(potential_input |>
                 change_to_lists() |>
                 check_class_fixest(), TRUE )
})


# checking get_means function ---------------------------------------------

test_that("make certain means are computed with list and non-list", {
  skip_on_cran()
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  potential_input <- list(list(ols_1, ols_2), ols_2)
  expect_equal(potential_input |>
                 get_means_fixest(fmt = 3), list(c( "Model 1" = sprintf("%.3f", mean(mtcars$mpg)), "Model 2" =sprintf("%.3f", mean(mtcars$mpg))),
                                                 c("Model 1" =sprintf("%.3f", mean(mtcars$mpg)))) )
})

test_that("make certain means are computed with one component", {
  skip_on_cran()
  ols_1 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  ols_2 <- mtcars |> fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp, nthreads = 1)
  potential_input <- list(ols_1)
  expect_equal(potential_input |>
                 get_means_fixest(fmt = 3), list(c( "Model 1" = sprintf("%.3f", mean(mtcars$mpg))) ))
})

