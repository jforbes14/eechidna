# Checking that shapefile import functions work

test_that("loadShapeFile works properly", {
  setwd("/Users/Jeremy/Documents/R/eechidna")
  my_sF <- loadShapeFile("data-raw/Shapefiles/national-midmif-09052016/COM_ELB.TAB")
  
  expect_equal(names(my_sF), names(sF_16))
  expect_equal(object.size(my_sF), object.size(my_sF))
  expect_equal(typeof(my_sF), typeof(sF_16))
})


test_that("getElectroateShapes works properly", {
  setwd("/Users/Jeremy/Documents/R/eechidna")
  my_sF_fortified <- getElectorateShapes("data-raw/Shapefiles/national-midmif-09052016/COM_ELB.TAB")
  
  expect_equal(names(my_sF_fortified$map), names(nat_map16))
  expect_equal(object.size(my_sF_fortified$map), object.size(nat_map16))
  expect_equal(typeof(my_sF_fortified$map), typeof(nat_map16))
  
  expect_equal(names(my_sF_fortified$data), names(nat_data16))
  expect_equal(object.size(my_sF_fortified$data), object.size(nat_data16))
  expect_equal(typeof(my_sF_fortified$data), typeof(nat_data16))
})
