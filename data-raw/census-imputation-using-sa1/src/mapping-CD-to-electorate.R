## This script maps Census collection districts / SA1 to an electorate.
## The centroid is extract for each CD/SA1 from the ABS shapefile. Tools from rgeos are then used to
## see which electorate contains that centroid.

library(eechidna)
library(tidyverse)
library(rgeos)
library(rgdal)
library(sp)

# ------------------------------------------------------------------------------------- #

# Load electorate shapefiles for each election to be imputed (2004, 2007, 2010, 2013)
load("./extra-data/sF_19.rda")
load("./extra-data/sF_13.rda")
load("./extra-data/sF_10.rda")
load("./extra-data/sF_07.rda")
load("./extra-data/sF_04.rda")

# Load CD/SA1 shapefiles for each Census
sF16_sa1 <- readOGR("/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/2016_SA1_shape/SA1_2016_AUST.shp")
sF11_sa1 <- readOGR("/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/2011_SA1_shape/SA1_2011_AUST.shp")
sF06_sa1 <- readOGR("/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/asgc2006.gpkg", layer = "census_collection_district_2006")
sF01_sa1 <- readOGR("/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/asgc2001.gpkg", layer = "census_collection_district_2001")

#save(sF16_sa1, file = "/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/sF16_sa1.rda")
#save(sF11_sa1, file = "/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/sF11_sa1.rda")
#save(sF06_sa1, file = "/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/sF06_sa1.rda")
#save(sF01_sa1, file = "/Volumes/J_External_HD/eechidna-paper-storage/shapefiles/sF01_sa1.rda")

# ------------------------------------------------------------------------------------- #

# Function to extract centroids from shapefile
extract_centroids <- function(shapefile) {
  
  # Change polygon format
  polys <- methods::as(shapefile, "SpatialPolygons")
  
  # Function to get centroid from polygon
  centroid <- function(i, polys) {
    ctr <- sp::Polygon(polys[i])@labpt
    data.frame(long_c=ctr[1], lat_c=ctr[2])
  }
  
  # Apply
  centroids <-  purrr::map_df(seq_along(polys), centroid, polys=polys)
  
  # Transform to SpatialPoints, consistent format
  spatial_centroids <- SpatialPoints(centroids)
  proj4string(spatial_centroids) <- proj4string(shapefile)
  
  # Create list with centroids and data from shapefile
  spatial_centroids_ls <- list(centroids = spatial_centroids, data = shapefile@data)
  
  return(spatial_centroids_ls)
}

# -------------------------------------------------------------------------------------------------------- #

# Extract CD/SA1 centroids
centroids_sa1_2016 <- extract_centroids(sF16_sa1)
centroids_sa1_2011 <- extract_centroids(sF11_sa1)
centroids_sa1_2006 <- extract_centroids(sF06_sa1)
centroids_sa1_2001 <- extract_centroids(sF01_sa1)

# save(centroids_sa1_2016, file = "data-raw/census-imputation-using-sa1/data/centroids_sa1_2016.rda")
# save(centroids_sa1_2011, file = "data-raw/census-imputation-using-sa1/data/centroids_sa1_2011.rda")
# save(centroids_sa1_2006, file = "data-raw/census-imputation-using-sa1/data/centroids_sa1_2006.rda")
# save(centroids_sa1_2001, file = "data-raw/census-imputation-using-sa1/data/centroids_sa1_2001.rda")

# -------------------------------------------------------------------------------------------------------- #

# Function to allocate centroids to electorates
allocate_electorate <- function(centroids_ls, electorates_sf, census_year = NA, election_year = NA) {
  
  # Column names to use
  if ("CD_CODE_2001" %in% colnames(centroids_ls$data)) {
    centroids_ls$data <- centroids_ls$data %>% 
      rename("SA1_7DIGIT" = "CD_CODE_2001", "STATE_NAME" = "STE_NAME_2001")
  }
  
  if ("CD_CODE_2006" %in% colnames(centroids_ls$data)) {
    centroids_ls$data <- centroids_ls$data %>% 
      rename("SA1_7DIGIT" = "CD_CODE_2006", "STATE_NAME" = "STE_NAME_2006")
  }
  
  # Dataframe with SA1 names and placeholder electorate
  assign_df <- data.frame(sa1 = centroids_ls$data$SA1_7DIGIT, electorate = 0, 
    census_year = census_year, election_year = election_year)
  
  # Fix state names to be consistent
  fix_state_names <- function(state) {
    if (state == "Australian Capital Territory") {state = "ACT"}
    if (state == "New South Wales") {state = "NSW"}
    if (state == "Northern Territory") {state = "NT"}
    if (state == "Other Territories") {state = "OT"}
    if (state == "Queensland") {state = "QLD"}
    if (state == "South Australia") {state = "SA"}
    if (state == "Tasmania") {state = "TAS"}
    if (state == "Victoria") {state = "VIC"}
    if (state == "Western Australia") {state = "WA"}
    
    return(state)
  }
  
  centroids_ls$data$STATE_NAME_ABV <- sapply(centroids_ls$data$STATE_NAME, fix_state_names)
  
  # Loop through point-in-polygon checking
  for (i in 1:length(centroids_ls$centroids)) {
    
    # Print for progress tracking
    if (i %% 2000 == 0) {print(i)}
    
    # Extract centroid
    centroid <- centroids_ls$centroids[i]
    centroid_state <- centroids_ls$data$STATE_NAME_ABV[i]
    
    # Loop through electorates (in state if possible - for efficiency)
    if (centroid_state %in% unique(electorates_sf$state)) {
      
      # Get polygons in state only
      state_electorates_sf <- subset(electorates_sf, state == centroid_state)
      
      # Loop through electorates to assign
      for (j in 1:length(state_electorates_sf@polygons)) {
        
        # Electorate name and polygon
        electorate_name <- state_electorates_sf$elect_div[j]
        electorate_poly <- subset(state_electorates_sf, elect_div == electorate_name)
        
        # Does it contain centroid
        electorate_contains = gContains(electorate_poly, centroid)
        
        if (electorate_contains == TRUE) {
          assign_df$electorate[i] = electorate_name
          break
        } 
        
      }
      
    } else { # Not assigned to state, must check all electorates
      
      # Loop through electorates to assign
      for (j in 1:length(electorates_sf@polygons)) {
        
        # Electorate name and polygon
        electorate_name <- electorates_sf$elect_div[j]
        electorate_poly <- subset(electorates_sf, elect_div == electorate_name)
        
        # Does it contain centroid
        electorate_contains = gContains(electorate_poly, centroid)
        
        if (electorate_contains == TRUE) {
          assign_df$electorate[i] = electorate_name
          break
        }
      }
    }
  }
  
  assign_df <- assign_df %>% 
    filter(electorate != 0)
  
  return(assign_df)
}

# ------------------------------------------------------------------------------------- #

# Running the mapping function for each election

# 2019 election (one-sided)
mapping_c16_e19 <- allocate_electorate(centroids_ls = centroids_sa1_2016, electorates_sf = sF_19, census_year = "2016", election_year = "2019")

# 2013 election
mapping_c16_e13 <- allocate_electorate(centroids_ls = centroids_sa1_2016, electorates_sf = sF_13, census_year = "2016", election_year = "2013")
mapping_c11_e13 <- allocate_electorate(centroids_ls = centroids_sa1_2011, electorates_sf = sF_13, census_year = "2011", election_year = "2013")

# 2010 election
mapping_c11_e10 <- allocate_electorate(centroids_ls = centroids_sa1_2011, electorates_sf = sF_10, census_year = "2011", election_year = "2010")
mapping_c06_e10 <- allocate_electorate(centroids_ls = centroids_sa1_2006, electorates_sf = sF_10, census_year = "2006", election_year = "2010")

# 2007 election
mapping_c11_e07 <- allocate_electorate(centroids_ls = centroids_sa1_2011, electorates_sf = sF_07, census_year = "2011", election_year = "2007")
mapping_c06_e07 <- allocate_electorate(centroids_ls = centroids_sa1_2006, electorates_sf = sF_07, census_year = "2006", election_year = "2007")

# 2004 election
mapping_c06_e04 <- allocate_electorate(centroids_ls = centroids_sa1_2006, electorates_sf = sF_04, census_year = "2006", election_year = "2004")
mapping_c01_e04 <- allocate_electorate(centroids_ls = centroids_sa1_2001, electorates_sf = sF_04, census_year = "2001", election_year = "2004")

# Save
save(mapping_c16_e19, file = "data-raw/census-imputation-using-sa1/data/mapping_c16_e19.rda")
save(mapping_c16_e13, file = "data-raw/census-imputation-using-sa1/data/mapping_c16_e13.rda")
save(mapping_c11_e13, file = "data-raw/census-imputation-using-sa1/data/mapping_c11_e13.rda")
save(mapping_c11_e10, file = "data-raw/census-imputation-using-sa1/data/mapping_c11_e10.rda")
save(mapping_c06_e10, file = "data-raw/census-imputation-using-sa1/data/mapping_c06_e10.rda")
save(mapping_c11_e07, file = "data-raw/census-imputation-using-sa1/data/mapping_c11_e07.rda")
save(mapping_c06_e07, file = "data-raw/census-imputation-using-sa1/data/mapping_c06_e07.rda")
save(mapping_c06_e04, file = "data-raw/census-imputation-using-sa1/data/mapping_c06_e04.rda")
save(mapping_c01_e04, file = "data-raw/census-imputation-using-sa1/data/mapping_c01_e04.rda")

# Test case using 2016
# It definitely works!
a <- Sys.time()
allocate_sa1_2016 <- allocate_electorate(centroids_ls = centroids_sa1_2016, electorates_sf = sF_16)
b <- Sys.time()
b-a #21 mins - not bad
# Verified with ABS records. This works.


