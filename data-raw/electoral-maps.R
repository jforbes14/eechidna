# This file creates shapefiles, nat_map and nat_data
library(eechidna)
library(tidyverse)

# -------------------------------------

# Make all character fields upper case
chr_upper <- function(df) {
  fc_cols <- sapply(df, class) == 'factor'
  df[, fc_cols] <- lapply(df[, fc_cols], as.character)
  
  ch_cols <- sapply(df, class) == 'character'
  df[, ch_cols] <- lapply(df[, ch_cols], toupper)
  return(df)
}

# -------------------------------------

# Shapefiles

shapeFile_01 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/asgc2001.gpkg"
shapeFile_04 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/2923030001ced04aaust/CED04aAUST_region.shp"
shapeFile_07 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/2923030001ced07aaust/CED07aAUST_region.shp"
shapeFile_10 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/national-esri-2010/COM_ELB_2010_region.shp"
shapeFile_13 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/national-midmif-16122011/COM20111216_ELB.MIF"
shapeFile_16 <- "/Users/Jeremy/Documents/R/eechidna-removed-docs/Shapefiles/national-midmif-09052016/COM_ELB.TAB"

sF_01 <- loadShapeFile(shapeFile_01)
sF_04 <- loadShapeFile(shapeFile_04)
sF_07 <- loadShapeFile(shapeFile_07)
sF_10 <- loadShapeFile(shapeFile_10)
sF_13 <- loadShapeFile(shapeFile_13)
sF_16 <- loadShapeFile(shapeFile_16)

save(sF_01, file = "data/sF_01.rda")
save(sF_04, file = "data/sF_04.rda")
save(sF_07, file = "data/sF_07.rda")
save(sF_10, file = "data/sF_10.rda")
save(sF_13, file = "data/sF_13.rda")
save(sF_16, file = "data/sF_16.rda")

sF_01_fortified <- getElectorateShapes(shapeFile_01)
sF_04_fortified <- getElectorateShapes(shapeFile_04)
sF_07_fortified <- getElectorateShapes(shapeFile_07)
sF_10_fortified <- getElectorateShapes(shapeFile_10)
sF_13_fortified <- getElectorateShapes(shapeFile_13)
sF_16_fortified <- getElectorateShapes(shapeFile_16)

temp <- getElectorateShapes(shapeFile_01)


# ------------------------------------

# Relabel states appropriately with abbreviations

state_label <- function(df) {
  new <- df
  
  if("1" %in% levels(factor(new$state))) {
    new <- new %>% 
      mutate(state = recode_factor(state, `1` = "NSW", `2` = "VIC", `3` = "QLD", `4` = "SA", `5` = "WA", 
        `6` = "TAS", `7` = "NT", `8` = "ACT", "OTHER TERR" = "ACT"))
  }
  
  if("VICTORIA" %in% levels(factor(new$state))) {
    new <- new %>%
      mutate(state = recode_factor(factor(state), "NEW SOUTH WALES" = "NSW", "VICTORIA" = "VIC", 
        "QUEENSLAND" = "QLD", "SOUTH AUSTRALIA" = "SA", "WESTERN AUSTRALIA" = "WA", 
        "TASMANIA" = "TAS", "NORTHERN TERRITORY" = "NT", "AUSTRALIAN CAPITAL TERRITORY" = "ACT", 
        "OTHER TERRITORIES" = "ACT", "OTHER TERR" = "ACT"))
  }
  
  if("OTHER TERR" %in% levels(factor(new$state))) {
    new <- new %>%
      mutate(state = recode_factor(factor(state), "OTHER TERR" = "ACT"))
  }
  
  return(new)
}

# ------------------------------------

# Separate map and data

nat_map01 <- sF_01_fortified$map %>% 
  chr_upper() %>% state_label()
nat_map04 <- sF_04_fortified$map %>% 
  chr_upper() %>% state_label()
nat_map07 <- sF_07_fortified$map %>% 
  chr_upper() %>% state_label()
nat_map10 <- sF_10_fortified$map %>% 
  chr_upper()
nat_map13 <- sF_13_fortified$map %>% 
  chr_upper()
nat_map16 <- sF_16_fortified$map %>% 
  chr_upper()


# Now add cartogram for each year

nat_data01 <- aec_add_carto_f(sF_01_fortified$data) %>% 
  chr_upper() %>% state_label()
nat_data04 <- aec_add_carto_f(sF_04_fortified$data) %>% 
  chr_upper() %>% state_label()
nat_data07 <- aec_add_carto_f(sF_07_fortified$data) %>% 
  chr_upper() %>% state_label()
nat_data10 <- aec_add_carto_f(sF_10_fortified$data) %>% 
  chr_upper()
nat_data13 <- aec_add_carto_f(sF_13_fortified$data) %>% 
  chr_upper()
nat_data16 <- aec_add_carto_f(sF_16_fortified$data) %>% 
  chr_upper()

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

