test_that("class objects are checked correctly when in lists of lists", {
  reg_1 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb, cluster = ~hp)
  reg_2 <- mtcars |>
    fixest::feols(disp ~ cyl | gear + carb, cluster = ~hp)
  reg_3 <- mtcars |>
    fixest::feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)
  reg_lfe <- lfe::felm(mpg ~cyl, data = mtcars)
  models <- list(reg_1, reg_2, reg_3)
  models_nested <- list(models, reg_lfe)
  expect_error(check_objects(models_nested))
})

test_that("class objects are checked correctly when not in nested lists", {
  reg_lfe <- lfe::felm(mpg ~cyl, data = mtcars)
  models <- list(reg_lfe)
  expect_error(check_objects())
})
