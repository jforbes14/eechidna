# Nat data and nat maps
context("Check that all electoral map data frames don't have any null values")

test_that("Census variable are the same", {
  expect_equal(sum(is.na(nat_map19)), 0)
  expect_equal(sum(is.na(nat_data19)), 0)
  expect_equal(sum(is.na(nat_map16)), 0)
  expect_equal(sum(is.na(nat_data16)), 0)
  expect_equal(sum(is.na(nat_map13)), 0)
  expect_equal(sum(is.na(nat_data13)), 0)
  expect_equal(sum(is.na(nat_map10)), 0)
  expect_equal(sum(is.na(nat_data10)), 0)
  expect_equal(sum(is.na(nat_map07)), 0)
  expect_equal(sum(is.na(nat_data07)), 0)
  expect_equal(sum(is.na(nat_map04)), 0)
  expect_equal(sum(is.na(nat_data04)), 0)
  expect_equal(sum(is.na(nat_map01)), 0)
  expect_equal(sum(is.na(nat_data01)), 0)
})
