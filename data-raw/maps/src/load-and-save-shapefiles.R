# This file creates shapefiles, nat_map and nat_data
library(eechidna)
library(tidyverse)

# -------------------------------------

# Shapefiles

# Enter your path to shapefile

shapeFile_01 <- "data-raw/maps/data/Shapefiles/asgc2001.gpkg"
shapeFile_04 <- "data-raw/maps/data/Shapefiles/2923030001ced04aaust/CED04aAUST_region.shp"
shapeFile_07 <- "data-raw/maps/data/Shapefiles/2923030001ced07aaust/CED07aAUST_region.shp"
shapeFile_10 <- "data-raw/maps/data/Shapefiles/national-esri-2010/COM_ELB_2010_region.shp"
shapeFile_11 <- "data-raw/maps/data/Shapefiles/2011_CED_shape/CED_2011_AUST.shp"
shapeFile_13 <- "data-raw/maps/data/Shapefiles/national-midmif-16122011/COM20111216_ELB.MIF"
shapeFile_16 <- "data-raw/maps/data/Shapefiles/national-midmif-09052016/COM_ELB.TAB"
shapeFile_19 <- "data-raw/maps/data/Shapefiles/national-esri-fe2019/COM_ELB_region.shp"
shapeFile_21 <- "data-raw/maps/data/Shapefiles/CED_2021_AUST_GDA2020_SHP/CED_2021_AUST_GDA2020.shp"

# Load in shape file using load_shapefile function

sF_01 <- load_shapefile(shapeFile_01)
sF_04 <- load_shapefile(shapeFile_04)
sF_07 <- load_shapefile(shapeFile_07)
sF_10 <- load_shapefile(shapeFile_10)
sF_11 <- load_shapefile(shapeFile_11)
sF_13 <- load_shapefile(shapeFile_13)
sF_16 <- load_shapefile(shapeFile_16)
sF_19 <- load_shapefile(shapeFile_19)
sF_21 <- load_shapefile(shapeFile_21)

# Save

save(sF_01, file = "extra-data/sF_01.rda", compress = "xz")
save(sF_04, file = "extra-data/sF_04.rda", compress = "xz")
save(sF_07, file = "extra-data/sF_07.rda", compress = "xz")
save(sF_10, file = "extra-data/sF_10.rda", compress = "xz")
save(sF_13, file = "extra-data/sF_13.rda", compress = "xz")
save(sF_16, file = "extra-data/sF_16.rda", compress = "xz")
save(sF_19, file = "extra-data/sF_19.rda", compress = "xz")
save(sF_21, file = "extra-data/sF_21.rda", compress = "xz")

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
save(nat_data01, file = "extra-data/nat_data01.rda")
save(nat_data04, file = "extra-data/nat_data04.rda")
save(nat_data07, file = "extra-data/nat_data07.rda")
save(nat_data10, file = "extra-data/nat_data10.rda")
save(nat_data13, file = "extra-data/nat_data13.rda")
save(nat_data16, file = "extra-data/nat_data16.rda")
save(nat_data19, file = "extra-data/nat_data19.rda")

save(nat_map01, file = "extra-data/nat_map01.rda")
save(nat_map04, file = "extra-data/nat_map04.rda")
save(nat_map07, file = "extra-data/nat_map07.rda")
save(nat_map10, file = "extra-data/nat_map10.rda")
save(nat_map13, file = "extra-data/nat_map13.rda")
save(nat_map16, file = "extra-data/nat_map16.rda")
save(nat_map19, file = "extra-data/nat_map19.rda")
