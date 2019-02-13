# Temporary file for holding test code

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

#shapeFile_esri <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/national-esri-16122011/COM20111216_ELB_region.shp"
#shapeFile_midmif <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/national-midmif-16122011/COM20111216_ELB.MIF"
#shapeFile_tab <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/national-midmif-09052016/COM_ELB.TAB"
#shapeFile_abs <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/2011_CED_shape/CED_2011_AUST.shp"

#shapeFile_01 <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/asgc2001.gpkg"
#shapeFile_04 <- "/Users/Jeremy/Documents/R/Data/Raw/Shapefiles/2923030001ced04aaust/CED04aAUST_region.shp"
#shapeFile_07 <- "/Users/Jeremy/Documents/R/Data/Raw/Shapefiles/2923030001ced07aaust/CED07aAUST_region.shp"

#sF1 <- readOGR(dsn = shapeFile_01, layer = ogrListLayers(shapeFile_01)[3])
#sF3 <- getElectorateShapes(shapeFile = shapeFile_01, keep = 0.05)
#sF4 <- getElectorateShapes(shapeFile = shapeFile_04, keep = 0.05)
#sF5 <- getElectorateShapes(shapeFile = shapeFile_07, keep = 0.05)
#sF6 <- getElectorateShapes(shapeFile = shapeFile_abs, keep = 0.05)

shapeFile_01 <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/asgc2001.gpkg"
shapeFile_04 <- "/Users/Jeremy/Documents/R/Data/Raw/Shapefiles/2923030001ced04aaust/CED04aAUST_region.shp"
shapeFile_07 <- "/Users/Jeremy/Documents/R/Data/Raw/Shapefiles/2923030001ced07aaust/CED07aAUST_region.shp"
shapeFile_10 <- "/Users/Jeremy/Documents/R/Data/Raw/Shapefiles/national-esri-2010/COM_ELB_2010_region.shp"
shapeFile_13 <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/national-midmif-16122011/COM20111216_ELB.MIF"
shapeFile_16 <- "/Users/Jeremy/Documents/R/eechidna/Shapefiles/national-midmif-09052016/COM_ELB.TAB"

sF_01 <- getElectorateShapes(shapeFile_01, keep = 0.01)
sF_04 <- getElectorateShapes(shapeFile_04, keep = 0.01)
sF_07 <- getElectorateShapes(shapeFile_07, keep = 0.01)
sF_10 <- getElectorateShapes(shapeFile_10, keep = 0.01)
sF_13 <- getElectorateShapes(shapeFile_13, keep = 0.01)
sF_16 <- getElectorateShapes(shapeFile_16, keep = 0.01)

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

nat_map01 <- sF_01$map %>% 
  chr_upper() %>% state_label()
nat_map04 <- sF_04$map %>% 
  chr_upper() %>% state_label()
nat_map07 <- sF_07$map %>% 
  chr_upper() %>% state_label()
nat_map10 <- sF_10$map %>% 
  chr_upper()
nat_map13 <- sF_13$map %>% 
  chr_upper()
nat_map16 <- sF_16$map %>% 
  chr_upper()

# Save

save(nat_map01, file = "data/nat_map01.rda")
save(nat_map04, file = "data/nat_map04.rda")
save(nat_map07, file = "data/nat_map07.rda")
save(nat_map10, file = "data/nat_map10.rda")
save(nat_map13, file = "data/nat_map13.rda")
save(nat_map16, file = "data/nat_map16.rda")


# ------------------------------------

# Now add cartogram for each year

# Writing another internal function to compute the cartogram coordinates from just inputting the map

aec_add_carto_f <- function(nat_data) {
  
  # fixed locations of main Australian cities
  cities <- list(c(151.2, -33.8), # Sydney
    c(153.0, -27.5), # Brisbane
    c(145.0, -37.8), # Melbourne
    c(138.6, -34.9), # Adelaide,
    c(115.9, -32.0)) # Perth
  
  # parameters of expansion
  expand <- list(c(2,3.8), c(2,3), c(2.6,4.1), c(4,3), c(12,6))
  
  # clusters in major cities
  sydney <- aec_extract_f(nat_data, ctr=nat_data %>% filter(elect_div == "Sydney") %>% select(long_c, lat_c) %>% unlist %>% unname, expand = c(2,3.8))
  sydney_carto <- aec_carto_f(sydney) %>% dplyr::rename(id=region)
  sydney_all <- merge(sydney, sydney_carto, by="id")
  
  brisbane <- aec_extract_f(nat_data, ctr=nat_data %>% filter(elect_div == "Brisbane") %>% select(long_c, lat_c) %>% unlist %>% unname, expand = c(2,3))
  brisbane_carto <- aec_carto_f(brisbane) %>% dplyr::rename(id=region)
  brisbane_all <- merge(brisbane, brisbane_carto, by="id")
  
  melbourne <- aec_extract_f(nat_data, ctr=nat_data %>% filter(elect_div == "Melbourne") %>% select(long_c, lat_c) %>% unlist %>% unname, expand = c(2.6,4.1))
  melbourne_carto <- aec_carto_f(melbourne) %>% dplyr::rename(id=region)
  melbourne_all <- merge(melbourne, melbourne_carto, by="id")
  
  adelaide <- aec_extract_f(nat_data, ctr=nat_data %>% filter(elect_div == "Adelaide") %>% select(long_c, lat_c) %>% unlist %>% unname, expand = c(4,3))
  adelaide_carto <- aec_carto_f(adelaide) %>% dplyr::rename(id=region)
  adelaide_all <- merge(adelaide, adelaide_carto, by="id")
  
  perth <- aec_extract_f(nat_data, ctr=nat_data %>% filter(elect_div == "Perth") %>% select(long_c, lat_c) %>% unlist %>% unname, expand = c(12,6))
  perth_carto <- aec_carto_f(perth) %>% dplyr::rename(id=region)
  perth_all <- merge(perth, perth_carto, by="id")
  
  # compute cartogram
  
  nat_carto <- suppressWarnings(purrr::map2(.x=cities, .y=expand, .f=aec_extract_f, aec_data=nat_data) %>%
    purrr::map_df(aec_carto_f) %>%
    mutate(region=as.integer(as.character(region))) %>%
    dplyr::rename(id=region))
    
  
  # join
  
  nat_data_cart <- aec_carto_join_f(nat_data, nat_carto)
  
}


# Each election

nat_data01 <- aec_add_carto_f(sF_01$data) %>% 
  chr_upper() %>% state_label()
nat_data04 <- aec_add_carto_f(sF_04$data) %>% 
  chr_upper() %>% state_label()
nat_data07 <- aec_add_carto_f(sF_07$data) %>% 
  chr_upper() %>% state_label()
nat_data10 <- aec_add_carto_f(sF_10$data) %>% 
  chr_upper()
nat_data13 <- aec_add_carto_f(sF_13$data) %>% 
  chr_upper()
nat_data16 <- aec_add_carto_f(sF_16$data) %>% 
  chr_upper()

# Save

save(nat_data01, file = "data/nat_data01.rda")
save(nat_data04, file = "data/nat_data04.rda")
save(nat_data07, file = "data/nat_data07.rda")
save(nat_data10, file = "data/nat_data10.rda")
save(nat_data13, file = "data/nat_data13.rda")
save(nat_data16, file = "data/nat_data16.rda")

# -------------------------------------



