#' At the time of an election, compute how much each electoral division
#' intersects with the divisions in place at the time of the Census.
#' This is to be used in interpolating Census information for electoral
#' divisions in a year that a Census did not occur.
#' 
#' @export
#' @param aec_sF shapefile with boundaries at election time
#' @param abs_sF shapefile with boundaries at census time
#' @param area_thres threshold for which mapping is sufficient (default is 99.5%)
#' @return data frame detailing how much Census divisions intersect with each 
#' electoral division at the time of the election.
#' 
#' @examples 
#' \dontrun{
#' aec_sF_2013 <- loadShapeFile(path_to_aec_shapefile)
#' abs_sF_2016 <- loadShapeFile(path_to_abs_shapefile)
#' mapping_df <- mapping_fn(aec_sF = aec_sF_2013, abs_sF = abs_sF_2016, area_thres = 0.995)
#' }

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

