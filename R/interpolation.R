#' Extract centroids from the polygons within a shapefile.
#'
#' @param shapefile sf object containing polygon geometry
#' @return list containing centroids as sf points object and a dataframe with
#' basic data on each polygon (e.g. name)
#' @export
#' @examples
#' \dontrun{
#' sF_download(year = 2016)
#' electorate_centroids_2016 <- extract_centroids(sF_16)
#' }
# Function to extract centroids from shapefile
extract_centroids <- function(shapefile) {

  # Function to get centroid from polygon
  centroid <- function(i, polys) {
    ctr <- st_centroid(st_geometry(sF)[[i]])
    data.frame(long_c=ctr[1], lat_c=ctr[2])
  }
  # Apply
  centroids <-  purrr::map_df(1:nrow(shapefile), centroid, polys=shapefile)

  # Transform to SpatialPoints, consistent format
  spatial_centroids <- centroids
  colnames(spatial_centroids) <- c("long", "lat")
  spatial_centroids$geom <- st_geometry(shapefile)
  spatial_centroids <- st_as_sf(spatial_centroids)

  # Create list with centroids and data from shapefile
  spatial_centroids_ls <- list(centroids = spatial_centroids, data = st_set_geometry(shapefile, NULL))

  return(spatial_centroids_ls)
}

#' Determine which electoral division contains the centroid from each of the Census polygons.
#'
#' Using the electoral boundaries at the time of an election and the centroids from the SA1
#' polygons from a neighbouring Census, allocate each SA1 to the electoral division that contains
#' its centroid.
#'
#' @param centroids_ls list containing centroids as SpatialPoints and a dataframe with
#' basic data on each polygon (e.g. name)
#' @param electorates_sf shapefile with electoral boundaries
#' @param census_year census year
#' @param election_year election year
#' @return data frame detailing which electoral division each Census polygon is allocated to
#' @export
#' @examples
#' \dontrun{
#' # Mapping each SA1 from the 2011 Census to the 2013 electoral boundaries
#' mapping_c11_e13 <- allocate_electorate(centroids_ls = centroids_sa1_2011, electorates_sf = sF_13,
#' census_year = "2011", election_year = "2013")
#' }


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
      state_electorates_sf <- electorates_sf %>%
        dplyr::filter(state == centroid_state)

      # Loop through electorates to assign
      for (j in 1:length(st_geometry(state_electorates_sf))) {

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


#' Function to compute weighted average of Census information
#' using imputed populations as weights
#'
#' @param mapping_df data frame detailing how much Census divisions intersect with each
#' electoral division at the time of the election.
#' @param abs_df data frame holding Census information from Census year
#' @return data frame with imputed Census data for electoral boundaries at the time of
#' the Census
#' @export
#'
#' @examples
#' \dontrun{
#' # Each 2013 electorate boundary's characteristics as at the time of the 2016 Census
#' mapping_c16_e13 <- allocate_electorate(centroids_ls = centroids_sa1_2016, electorates_sf = sF_13,
#' census_year = "2016", election_year = "2013")
#'
#' # Estimate 2016 Census data for the 2013 electorates
#' imputed_data_2016 <- weighted_avg_census_sa1(mapping_df = mapping_2016, abs_df = abs2016_cd)
#' }
weighted_avg_census_sa1 <- function(mapping_df, abs_df) {
  mapping_df <- mapping_df %>%
    arrange(electorate) %>%
    mutate(sa1 = as.character(sa1))

  abs_df <- abs_df %>%
    mutate(CD = as.character(CD)) %>%
    filter(!is.na(Population), Population > 0) %>%
    select(-c(ends_with("NS"), Area)) %>%
    select(sort(tidyselect::peek_vars())) %>%
    select(CD, Population, everything())

  divs <- unique(mapping_df$electorate)
  divs <- divs[divs != "0"]

  for (i in 1:length(divs)) {
    # Election division
    div <- divs[i]

    # Mapping for the division
    mapping_div <- mapping_df %>%
      filter(electorate == div)

    # Census info from the relevant divisions
    census_divs <- abs_df %>%
      filter(CD %in% mapping_div$sa1)

    # Weighted average of each variable, using only valid numbers
    imputed_df <- data.frame(
      vars = colnames(census_divs %>% select(-CD)),
      value = 0)

    for (j in 1:nrow(imputed_df)) {

      # Variable
      var_name <- as.character(imputed_df$vars[j])
      var_vals <- census_divs[, var_name] %>% unlist
      var_population <- census_divs[, "Population"] %>% unlist

      # Filter valid numbers
      valid_var_index <- which(!var_vals %in% c(NA, Inf, NaN))
      valid_pop_index <- which(!var_population %in% c(NA, Inf, NaN, 0))
      valid_index <- intersect(valid_var_index, valid_pop_index)
      valid_var_vals <- var_vals[valid_index]
      valid_var_population <- var_population[valid_index]

      if (var_name != "Population") {
        # Imputation weights
        var_imputation_weights <- valid_var_population/sum(valid_var_population)

        # Imputed value
        imputed_df$value[j] <- sum(valid_var_vals * var_imputation_weights)

      } else {
        # Imputed Population
        imputed_df$value <- sum(valid_var_vals)
      }

    }


    # Imputed profile
    imputed_profile <- imputed_df %>%
      column_to_rownames(var = "vars") %>%
      t() %>%
      data.frame() %>%
      mutate(DivisionNm = div)

    # Update
    if (i == 1) {
      keep_imputed_profiles <- imputed_profile
    } else {
      keep_imputed_profiles <- bind_rows(keep_imputed_profiles, imputed_profile)
    }

  }

  return(keep_imputed_profiles)
}







#' Compute areas of intersection between each election boundary and those in
#' the Census of interest. This is a less refined method than using SA1 centroids.
#'
#' At the time of an election, compute how much each electoral division
#' intersects with the divisions in place at the time of the Census.
#' This is to be used in interpolating Census information for electoral
#' divisions in a year that a Census did not occur.
#'
#' @param aec_sF shapefile with boundaries at election time
#' @param abs_sF shapefile with boundaries at census time
#' @param area_thres threshold for which mapping is sufficient (default is 99.5\%)
#' @return data frame detailing how much Census divisions intersect with each
#' electoral division at the time of the election.
#' @export
#' @examples
#' \dontrun{
#' # Each 2013 electorate boundary's composition in terms of the
#' # boundaries in place for the 2016 Census
#' aec_sF_2013 <- loadShapeFile(path_to_aec_shapefile)
#' abs_sF_2016 <- loadShapeFile(path_to_abs_shapefile)
#'
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
    div_area <- suppressWarnings(rgeos::gArea(div_poly))

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

      if (rgeos::gIntersects(div_poly, cens_poly)) { # Only if polygons intersect
        poly_intersect <- rgeos::gIntersection(div_poly, cens_poly)
        cens_mapped$Intersect_area[j] = suppressWarnings(rgeos::gArea(poly_intersect))
      }

      # break if sum of intersection areas is over threshold (area_thres)
      if ( (sum(cens_mapped$Intersect_area[1:j])/div_area) > area_thres ) {
        break
        }

    }

    Mapping_df <- rbind(Mapping_df, cens_mapped)

  }

  # Remove zero intersections
  Mapping_df <- filter(Mapping_df, Intersect_area > 0)

  # Adding area of Census divsions
  cens_area <- data.frame(ABS_division = abs_sF$elect_div, ABS_division_area = 0)

  for (i in 1:nrow(cens_area)) {
    cens_area$ABS_division_area[i] = rgeos::gArea(abs_sF %>% subset(elect_div == cens_area[i,1]))
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

#' Function to compute weighted average of Census information
#' using imputed populations as weights.
#'
#' This is a less refined method than using SA1 centroids, because it uses Census data
#' aggregated at Census division level.
#'
#' @param mapping_df data frame detailing how much Census divisions intersect with each
#' electoral division at the time of the election.
#' @param abs_df data frame holding Census information from Census year
#' @return data frame with imputed Census data for electoral boundaries at the time of
#' the Census
#' @export
#'
#' @examples
#' \dontrun{
#' data("abs2016")
#'
#' # Each 2013 electorate boundary's composition in terms of the
#' # boundaries in place for the 2016 Census
#' aec_sF_2013 <- loadShapeFile(path_to_aec_shapefile)
#' abs_sF_2016 <- loadShapeFile(path_to_abs_shapefile)
#' mapping_2016 <- mapping_fn(aec_sF = aec_sF_2013, abs_sF = abs_sF_2016)
#'
#' # Estimate 2016 Census data for the 2013 electorates
#' imputed_data_2016 <- weighted_avg_census(mapping_df = mapping_2016, abs_df = abs2016)
#' }

weighted_avg_census <- function(mapping_df, abs_df) {
  mapping_df <- mapping_df %>%
    arrange(as.character(AEC_division), as.character(ABS_division))

  abs_df <- abs_df %>%
    arrange(as.character(DivisionNm))

  divs <- unique(mapping_df$AEC_division)

  for (i in 1:length(divs)) {
    # Election division
    div <- divs[i]

    # Mapping for the division
    mapping <- mapping_df %>%
      filter(AEC_division == div)

    # Census info from the relevant divisions
    census_divs <- abs_df %>%
      filter(DivisionNm %in% mapping$ABS_division) %>%
      select(-c(ends_with("NS"), Area, UniqueID, State)) %>%
      left_join(mapping, by = c("DivisionNm" = "ABS_division")) %>%
      # add imputed population
      mutate(imputed_population = Percent_Census_Composition*Population)

    # Net imputed population
    census_divs <- census_divs %>%
      mutate(total_pop = sum(census_divs$imputed_population),
        weight = imputed_population/total_pop)

    # Weighted average
    imputed_profile <- (census_divs %>%
        select(c(Age00_04:Volunteer)) *
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
