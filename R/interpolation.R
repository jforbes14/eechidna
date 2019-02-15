#' At the time of an election, compute how much each electoral division
#' intersects with the divisions in place at the time of the Census.
#' This is to be used in interpolating Census information for electoral
#' divisions in a year that a Census did not occur.
#' 
#' @export
#' @param aec_sF shapefile with boundaries at election time
#' @param abs_sF shapefile with boundaries at census time
#' @param area_thres threshold for which mapping is sufficient (default is 99.5%)
#'
#' @examples 
#' aec_sF_2013 <- get_electorate_shapefile(path_to_aec_shapefile)
#' abs_sF_2016 <- get_electorate_shapefile(path_to_abs_shapefile)
#' mapping_df <- mapping_fn(aec_sF = aec_sF_2013, abs_sF = abs_sF_2016, area_thres = 0.995)


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
      Percent_ABS_division_Composition = Intersect_area/ABS_division_area)
  
  return(Mapping_df)
}

# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
get_electorate_shapefile <- function(path_to_shapeFile) {
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
  polys_sF <- gSimplify(sF, tol = 0.0001)
  
  # Ensure all polygons are valid
  #new_sF <- sF %>% subset(elect_div == "")
  #for (i in 1:nrow(sF@data)) {
  #  temp <- sF %>% subset(elect_div == sF@data$elect_div[i])
  #  if (!gIsValid(temp)) {
  #    temp <- gBuffer(temp, byid = TRUE, width = 0)
  #  }
  #  new_sF <- raster::bind(new_sF, temp)
  #}
  
  out <- SpatialPolygonsDataFrame(polys_sF, sF@data)
  
  return(out)
}



