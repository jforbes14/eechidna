#' @export
loadShapeFile <- function(path_to_shapeFile, tolerance = 0.0001) {

# geopackage (.gpkg) is to be treated differently so an if else statement is used

if (substr(path_to_shapeFile, nchar(path_to_shapeFile) - 3, nchar(path_to_shapeFile)) != "gpkg") {
  sF <- rgdal::readOGR(dsn=path_to_shapeFile)
} else {
  layers <- tolower(rgdal::ogrListLayers(path_to_shapeFile))
  index <- grep("commonwealth", layers)
  if (length(index) > 1) {
    print("Warning: Multiple layers with the name 'commonwealth electoral division'. Taking the first by default.")
  }
  sF <- rgdal::readOGR(dsn=path_to_shapeFile, layer = layers[index[1]])
}

# change colnames to lower case and rename
names(sF@data) <- tolower(names(sF@data))
colnm <- names(sF@data)

if (!"elect_div" %in% colnm) {
  
  if (sum(grepl("ced_name", colnm)) > 0) {
    names(sF@data)[grep("ced_name", colnm)] <- "elect_div"
  }
  
  if (sum(grepl("ste_name", colnm)) > 0) {
    names(sF@data)[grep("ste_name", colnm)] <- "state"
  } else {
    names(sF@data)[grep("name", colnm)] <- "elect_div"
    names(sF@data)[grep("state", colnm)] <- "state"
  } 
}

# Make all character fields upper case
chr_upper <- function(df) {
  fc_cols <- sapply(df, class) == 'factor'
  df[, fc_cols] <- lapply(df[, fc_cols], as.character)
  
  ch_cols <- sapply(df, class) == 'character'
  df[, ch_cols] <- lapply(df[, ch_cols], toupper)
  return(df)
}

# get centroids
if (!"lat_c" %in% names(sF@data)) {
  polys <- methods::as(sF, "SpatialPolygons")
  
  centroid <- function(i, polys) {
    ctr <- sp::Polygon(polys[i])@labpt
    data.frame(long_c=ctr[1], lat_c=ctr[2])
  }
  centroids <-  purrr::map_df(seq_along(polys), centroid, polys=polys)
  
  sF@data <- data.frame(sF@data, centroids)
}

sF@data <- chr_upper(sF@data)

# Simplify to make sure polygons are valid
polys_sF <- gSimplify(sF, tol = tolerance)

out <- SpatialPolygonsDataFrame(polys_sF, sF@data)

return(out)
}

#' @export
getElectorateShapes <- function(path_to_shapeFile = NULL, sF = NULL, mapinfo=TRUE, layer=NULL, tolerance=0.0001) {

if (is.null(sF)) {
  if (!is.null(path_to_shapeFile)) {
    sF <- loadShapeFile(path_to_shapeFile = path_to_shapeFile, tolerance = tolerance)
  } else {
    print("Enter path to shapefile or loaded shapefile from function loadShapeFile")
    break
  }
}

# Extract data and map to be ggplot friendly
nat_data <- sF@data
nat_data$id <- row.names(nat_data)
nat_map <- ggplot2::fortify(sFsmall)
nat_map$group <- paste("g",nat_map$group,sep=".")
nat_map$piece <- paste("p",nat_map$piece,sep=".")

if ("state" %in% names(sF@data)) {
  nms <- sFsmall@data %>% dplyr::select(elect_div, state)
} else {
  nms <- sFsmall@data %>% dplyr::select(elect_div)
}

nms$id <- as.character(1:150)
nat_map <- dplyr::left_join(nat_map, nms, by="id")

# get centroids
polys <- methods::as(sF, "SpatialPolygons")

centroid <- function(i, polys) {
  ctr <- sp::Polygon(polys[i])@labpt
  data.frame(long_c=ctr[1], lat_c=ctr[2])
}
centroids <-  purrr::map_df(seq_along(polys), centroid, polys=polys)

nat_data <- data.frame(nat_data, centroids)

# keep relevant variables
keep_index <- which(names(nat_data) %in% c("elect_div", "state", "numccds", "area_sqkm", "id", "long_c", "lat_c"))
nat_data <- nat_data[, keep_index]

list(map=nat_map, data=nat_data)
}

#' @export
mapping_fn <- function(aec_sF, abs_sF, area_thres = 0.995) {
  
  # Function for distance between two points
  cdist <- function(x1, y1, x2, y2) {
    dist = sqrt((x2 - x1)^2 + (y2 - y1)^2)
  }
  
  # Placeholder
  Mapping_df <- data.frame(AEC_division = 0, ABS_division = 0, Intersect_area = 0, ABS_division_area = 0, AEC_division_area = 0)[-1,]
  
  # Electoral division names at election time
  division_names <- aec_sF$elect_div
  
  # Loop for breakdown of electorates
  for (i in 1:length(division_names)) {
    
    div_name <- division_names[i]
    div_poly <- aec_sF %>% subset(as.character(elect_div) == as.character(div_name))
    div_lat_c <- div_poly$lat_c
    div_long_c <- div_poly$long_c
    div_area <- suppressWarnings(gArea(div_poly))
    
    # Ordering Census divisions by distance to electoral division
    comp <- abs_sF@data %>%
      dplyr::select(elect_div, long_c, lat_c) %>% rowwise %>%
      mutate(dist_centroid = cdist(lat_c, long_c, div_lat_c, div_long_c))
    
    comp <- comp[order(comp$dist_centroid),] # order by distance to centroid
    
    cens_names <- comp$elect_div
    cens_mapped <- data.frame(AEC_division = div_name, ABS_division = cens_names, 
      Intersect_area = 0, ABS_division_area = 0, AEC_division_area=div_area)
    
    # Loop for that electorate until break
    for (j in 1:length(cens_names)) {
      cens_poly <- abs_sF %>% subset(elect_div == cens_names[j])
      
      if (gIntersects(div_poly, cens_poly)) { # Only if polygons intersect
        poly_intersect <- gIntersection(div_poly, cens_poly)
        cens_mapped$Intersect_area[j] = suppressWarnings(gArea(poly_intersect))
      }
      
      # break if sum of intersection areas is over threshold (area_thres)
      if ( (sum(cens_mapped$Intersect_area[1:j])/div_area) > area_thres ) break
      
    } 
    
    Mapping_df <- rbind(Mapping_df, cens_mapped)
    
  }
  
  # Remove zero intersections
  Mapping_df <- filter(Mapping_df, Intersect_area > 0)
  
  # Adding area of Census divsions
  cens_area <- data.frame(ABS_division = abs_sF$elect_div, ABS_division_area = 0)
  
  for (i in 1:nrow(cens_area)) {
    cens_area$ABS_division_area[i] = gArea(abs_sF %>% subset(elect_div == cens_area[i,1]))
  }
  
  for (i in 1:nrow(Mapping_df)) {
    Mapping_df$ABS_division_area[i] = cens_area[which(cens_area$ABS_division == Mapping_df$ABS_division[i]), 2]
  }
  
  ### Adding percentage of Census and Electorate intersections
  Mapping_df <- Mapping_df %>%
    mutate(Percent_Elec_Composition = Intersect_area/AEC_division_area,
      Percent_Census_Composition = Intersect_area/ABS_division_area)
  
  return(Mapping_df)
}

#' @export
weighted_avg_census <- function(mapping_df, abs_df) {
  mapping_df <- mapping_df %>% 
    arrange(as.character(AEC_division), as.character(ABS_division))
  
  abs_df <- abs_df %>% 
    arrange(as.character(DivisionNm))
  
  divs <- unique(mapping_df$AEC_division)
  
  for (i in 1:nrow(out_df)) {
    # Election division
    div <- divs[i]
    
    # Mapping for the division
    mapping <- mapping_df %>% 
      filter(AEC_division == div)
    
    # Census info from the relevant divisions
    census_divs <- abs_df %>% 
      filter(DivisionNm %in% mapping$ABS_division) %>% 
      select(-c(ends_with("NS"), Area, ID, State)) %>% 
      left_join(mapping, by = c("DivisionNm" = "ABS_division")) %>% 
      # add imputed population
      mutate(imputed_population = Percent_ABS_division_Composition*Population)
    
    # Net imputed population
    census_divs <- census_divs %>% 
      mutate(total_pop = sum(census_divs$imputed_population),
        weight = imputed_population/total_pop)
    
    # Weighted average
    imputed_profile <- (census_divs %>% 
        select(c(Age00_04:BornElsewhere)) *
        census_divs$weight) %>% 
      colSums() %>% 
      t() %>% 
      data.frame() 
    
    imputed_profile <- imputed_profile %>% 
      select(noquote(order(colnames(imputed_profile)))) %>% 
      mutate(DivisionNm = div)
    
    if (i == 1) {
      keep_imputed_profiles <- imputed_profile
    } else {
      keep_imputed_profiles <- bind_rows(keep_imputed_profiles, imputed_profile)
    }
    
  }
  
  return(keep_imputed_profiles)
}