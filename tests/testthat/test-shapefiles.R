# Checking that shapefile import functions work

test_that("load_shapefile works properly", {
  setwd("/Users/Jeremy/Documents/R/eechidna")
  my_sF <- load_shapefile("data-raw/Shapefiles/national-midmif-09052016/COM_ELB.TAB")
  sF_16 <- sF_download(2016)
  
  expect_equal(names(my_sF), names(sF_16))
  expect_equal(object.size(my_sF), object.size(my_sF))
  expect_equal(typeof(my_sF), typeof(sF_16))
})


test_that("getElectroateShapes works properly", {
  setwd("/Users/Jeremy/Documents/R/eechidna")
  my_sF_fortified <- get_electorate_shapes("data-raw/Shapefiles/national-midmif-09052016/COM_ELB.TAB")
  
  expect_equal(names(my_sF_fortified$map), names(nat_map16))
  expect_equal(object.size(my_sF_fortified$map), object.size(nat_map16))
  expect_equal(typeof(my_sF_fortified$map), typeof(nat_map16))
  
  expect_equal(names(my_sF_fortified$data), names(nat_data16))
  expect_equal(object.size(my_sF_fortified$data), object.size(nat_data16))
  expect_equal(typeof(my_sF_fortified$data), typeof(nat_data16))
  
  file.remove("Rplots.pdf")
})
