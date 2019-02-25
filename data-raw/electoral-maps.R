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

# Load in shape file using loadShapeFile function

sF_01 <- loadShapeFile(shapeFile_01)
sF_04 <- loadShapeFile(shapeFile_04)
sF_07 <- loadShapeFile(shapeFile_07)
sF_10 <- loadShapeFile(shapeFile_10)
sF_11 <- loadShapeFile(shapeFile_11)
sF_13 <- loadShapeFile(shapeFile_13)
sF_16 <- loadShapeFile(shapeFile_16)

# Save

save(sF_01, file = "data/sF_01.rda")
save(sF_04, file = "data/sF_04.rda")
save(sF_07, file = "data/sF_07.rda")
save(sF_10, file = "data/sF_10.rda")
save(sF_11, file = "data/sF_11.rda")
save(sF_13, file = "data/sF_13.rda")
save(sF_16, file = "data/sF_16.rda")

# ------------------------------------

# Transform into separate map and data data frames
# Compatible with ggplot2

sF_01_fortified <- getElectorateShapes(shapeFile_01)
sF_04_fortified <- getElectorateShapes(shapeFile_04)
sF_07_fortified <- getElectorateShapes(shapeFile_07)
sF_10_fortified <- getElectorateShapes(shapeFile_10)
sF_13_fortified <- getElectorateShapes(shapeFile_13)
sF_16_fortified <- getElectorateShapes(shapeFile_16)


# Separate map and data

nat_map01 <- sF_01_fortified$map

nat_map04 <- sF_04_fortified$map

nat_map07 <- sF_07_fortified$map

nat_map10 <- sF_10_fortified$map

nat_map13 <- sF_13_fortified$map

nat_map16 <- sF_16_fortified$map

nat_data01 <- sF_01_fortified$data

nat_data04 <- sF_04_fortified$data

nat_data07 <- sF_07_fortified$data

nat_data10 <- sF_10_fortified$data

nat_data13 <- sF_13_fortified$data

nat_data16 <- sF_16_fortified$data


# Save

save(nat_data01, file = "data/nat_data01.rda")
save(nat_data04, file = "data/nat_data04.rda")
save(nat_data07, file = "data/nat_data07.rda")
save(nat_data10, file = "data/nat_data10.rda")
save(nat_data13, file = "data/nat_data13.rda")
save(nat_data16, file = "data/nat_data16.rda")

save(nat_map01, file = "data/nat_map01.rda")
save(nat_map04, file = "data/nat_map04.rda")
save(nat_map07, file = "data/nat_map07.rda")
save(nat_map10, file = "data/nat_map10.rda")
save(nat_map13, file = "data/nat_map13.rda")
save(nat_map16, file = "data/nat_map16.rda")

