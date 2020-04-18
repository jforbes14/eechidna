# This file creates shapefiles, nat_map and nat_data
library(eechidna)
library(tidyverse)

# -------------------------------------

# Shapefiles

# Enter your path to shapefile

shapeFile_01 <- "data-raw/Shapefiles/asgc2001.gpkg"
shapeFile_04 <- "data-raw/Shapefiles/2923030001ced04aaust/CED04aAUST_region.shp"
shapeFile_07 <- "data-raw/Shapefiles/2923030001ced07aaust/CED07aAUST_region.shp"
shapeFile_10 <- "data-raw/Shapefiles/national-esri-2010/COM_ELB_2010_region.shp"
shapeFile_11 <- "data-raw/Shapefiles/2011_CED_shape/CED_2011_AUST.shp"
shapeFile_13 <- "data-raw/Shapefiles/national-midmif-16122011/COM20111216_ELB.MIF"
shapeFile_16 <- "data-raw/Shapefiles/national-midmif-09052016/COM_ELB.TAB"
#shapeFile_19 <- "data-raw/Shapefiles/national-esri-fe2019/COM_ELB_region.shp"
# Download 2019 data from: https://aec.gov.au/Electorates/gis/gis_datadownload.htm
shapeFile_19 <- "data-raw/Shapefiles/national-mapinfo-fe2019/COM_ELB.TAB"


# Load in shape file using load_shapefile function

sF_01 <- load_shapefile(shapeFile_01)
sF_04 <- load_shapefile(shapeFile_04)
sF_07 <- load_shapefile(shapeFile_07)
sF_10 <- load_shapefile(shapeFile_10)
sF_11 <- load_shapefile(shapeFile_11)
sF_13 <- load_shapefile(shapeFile_13)
sF_16 <- load_shapefile(shapeFile_16)
sF_19 <- load_shapefile(shapeFile_19)

# Save

save(sF_01, file = "extra-data/sF_01.rda", compress = "xz")
save(sF_04, file = "extra-data/sF_04.rda", compress = "xz")
save(sF_07, file = "extra-data/sF_07.rda", compress = "xz")
save(sF_10, file = "extra-data/sF_10.rda", compress = "xz")
save(sF_13, file = "extra-data/sF_13.rda", compress = "xz")
save(sF_16, file = "extra-data/sF_16.rda", compress = "xz")
save(sF_19, file = "extra-data/sF_19.rda", compress = "xz")

# ------------------------------------

# Transform into separate map and data data frames
# Compatible with ggplot2

sF_01_fortified <- get_electorate_shapes(shapeFile_01)
sF_04_fortified <- get_electorate_shapes(shapeFile_04)
sF_07_fortified <- get_electorate_shapes(shapeFile_07)
sF_10_fortified <- get_electorate_shapes(shapeFile_10)
sF_13_fortified <- get_electorate_shapes(shapeFile_13)
sF_16_fortified <- get_electorate_shapes(shapeFile_16)
sF_19_fortified <- get_electorate_shapes(shapeFile_19)


# Separate map and data

nat_map01 <- sF_01_fortified$map

nat_map04 <- sF_04_fortified$map

nat_map07 <- sF_07_fortified$map

nat_map10 <- sF_10_fortified$map

nat_map13 <- sF_13_fortified$map

nat_map16 <- sF_16_fortified$map

nat_map19 <- sF_19_fortified$map

nat_data01 <- sF_01_fortified$data

nat_data04 <- sF_04_fortified$data

nat_data07 <- sF_07_fortified$data

nat_data10 <- sF_10_fortified$data

nat_data13 <- sF_13_fortified$data

nat_data16 <- sF_16_fortified$data

nat_data19 <- sF_19_fortified$data


# Save
usethis::use_data(nat_data01, overwrite = T, compress = "xz")
usethis::use_data(nat_data04, overwrite = T, compress = "xz")
usethis::use_data(nat_data07, overwrite = T, compress = "xz")
usethis::use_data(nat_data10, overwrite = T, compress = "xz")
usethis::use_data(nat_data13, overwrite = T, compress = "xz")
usethis::use_data(nat_data16, overwrite = T, compress = "xz")
usethis::use_data(nat_data19, overwrite = T, compress = "xz")

usethis::use_data(nat_map01, overwrite = T, compress = "xz")
usethis::use_data(nat_map04, overwrite = T, compress = "xz")
usethis::use_data(nat_map07, overwrite = T, compress = "xz")
usethis::use_data(nat_map10, overwrite = T, compress = "xz")
usethis::use_data(nat_map13, overwrite = T, compress = "xz")
usethis::use_data(nat_map16, overwrite = T, compress = "xz")
usethis::use_data(nat_map19, overwrite = T, compress = "xz")


# new one requires map data to be moved to extra-data though??
# see nat_map_download and nat_data_download
# adding below to move data to extra-data folder

# there is no base function to move a file, so will copy then delete
# nat map

purrr::walk(seq(1, 19, by = 3), ~{
  from <- sprintf("data/nat_map%.2d.rda", .x)
  to <- sprintf("extra-data/nat_map%.2d.rda", .x)
  file.copy(from, to, overwrite = TRUE)
  file.remove(from)
})

# nat data
purrr::walk(seq(1, 19, by = 3), ~{
  from <- sprintf("data/nat_data%.2d.rda", .x)
  to <- sprintf("extra-data/nat_data%.2d.rda", .x)
  file.copy(from, to, overwrite = TRUE)
  file.remove(from)
})
