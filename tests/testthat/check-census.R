# Census data frames
context("Check that all Census data frames have matching variable names and 150 divisions")

test_that("Census variable are the same", {
  expect_equal(sum(!names(abs2016) %in% names(abs2011)), 0)
  expect_equal(sum(!names(abs2016) %in% names(abs2006)), 0)
  expect_equal(sum(!names(abs2016) %in% names(abs2006_e07)), 0)
  expect_equal(sum(!names(abs2016) %in% names(abs2001)), 0)
})


test_that("2016 Census has 150 divisions", {
  expect_equal(unique(length(abs2016$DivisionNm)), 150)
  expect_equal(unique(length(abs2011$DivisionNm)), 150)
  expect_equal(unique(length(abs2006$DivisionNm)), 150)
  expect_equal(unique(length(abs2006_e07$DivisionNm)), 150)
  expect_equal(unique(length(abs2001$DivisionNm)), 150)
})

