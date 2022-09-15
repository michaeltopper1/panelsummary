

test_that("creating panels when the argument is null is correct", {
  panels <- create_panels_null(num_panels = 5)
  expect_equal(panels, c("Panel A:", "Panel B:", "Panel C:", "Panel D:", "Panel E:"))
})
