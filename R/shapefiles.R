#' Load shapefile of Australia into R
#'
#' This is only used to create the new electorate map data, for future years.
#' Load shapefile into R as an sf (simple features) object, extract polygon information, thin
#' polygon, fix any problematic polygons, and format variable names.
#' "nat_map" and "nat_data" objects for every Australian federal election between
#' 2001-2019 can be readily loaded from the package for analysis.
#'
#' The function will take several minutes to complete.
#'
#' @param path_to_shapeFile path to object in local machine
#' @param tolerance numerical tolerance value to be used by the Douglas-Peuker algorithm
#' @return object of class SpatialPolygonsDataFrame
#' @export
#' @examples
#' \dontrun{
#' # Load electorate shapefile into R
#'
#' # Path to your shapefile
#' fl <- "local/path/to/shapefile.shp"
#'
#' # Load
#' my_sF <- load_shapefile(fl)
#' }

load_shapefile <- function(path_to_shapeFile, tolerance = 0.001) {

  sF <- read_sf(dsn=path_to_shapeFile)

  names(sF) <- tolower(names(sF))
  colnm <- names(sF)

  if (!"elect_div" %in% colnm) {

    if (sum(grepl("ced_name", colnm)) > 0) {
      names(sF)[grep("ced_name", colnm)] <- "elect_div"
    }

    if (sum(grepl("ste_name", colnm)) > 0) {
      names(sF)[grep("ste_name", colnm)] <- "state"
    } else {
      names(sF)[grep("name", colnm)] <- "elect_div"
      names(sF)[grep("state", colnm)] <- "state"
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
  if (!"lat_c" %in% names(sF)) {

    centroid <- function(i, polys) {
      ctr <- st_centroid(st_geometry(sF)[[i]])
      data.frame(long_c=ctr[1], lat_c=ctr[2])
    }
    centroids <-  purrr::map_df(1:nrow(sF), centroid, polys=sF)

    sF_data <- data.frame(sF, centroids)
  }

  sF_data <- chr_upper(sF_data)

  # Simplify to make sure polygons are valid
  sF_polys <- rmapshaper::ms_simplify(sF, keep = tolerance)

  out <- st_as_sf(sF_data)
  st_geometry(out) <- st_geometry(sF_polys)

  return(out)
}

#' Extract shapefiles (of Australian electorates) from raw file into fortified
#' map and data components.
#'
#' This function is only used to create new map data in future elections
#' Extract polygon information and demographics for each of Australia's electorates.
#' The map and data corresponding to the shapefiles of the 2013 Australian electorates (available at \url{https://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}) are part of this package as nat_map.rda and nat_data.rda in the data folder.
#' The function may take several minutes to complete.
#' @param path_to_shapeFile path to object in local machine (only if shapefile has not already loaded)
#' @param sF Shapefile object loaded to environment using load_shapefile
#' @param mapinfo Is the data mapInfo format, rather than ESRI? default=TRUE
#' @param layer If the format is mapInfo, the layer name also needs to be provided, default is NULL
#' @param tolerance Numerical tolerance value to be used by the Douglas-Peuker algorithm (only if shapefile has not already loaded)
#' @return list with two data frames: map and data; `map` is a data set with geographic latitude and longitude, and a grouping variable to define each entity.
#' The `data` data set consists of demographic or geographic information for each electorate, such as size in square kilometers or corresponding state.
#' Additionally, geographic latitude and longitude of the electorate's centroid are added.
#' @export
#' @examples
#' \dontrun{
#' # Get electorate shapes in data.frame format
#'
#' # Path to your shapefile
#' fl <- "local/path/to/shapefile.shp"
#'
#' map_and_data16 <- get_electorate_shapes(path_to_shapefile = fl)
#' }

get_electorate_shapes <- function(path_to_shapeFile = NULL, sF = NULL, mapinfo=TRUE, layer=NULL, tolerance=0.001) {

  # Read the shapefile first, if not given an sf object
  if (is.null(sF)) {
    if (!is.null(path_to_shapeFile)) {
      sF <- read_sf(dsn=path_to_shapeFile)
    } else {
      stop("Enter path to shapefile or loaded shapefile from function load_shapefile")
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

  # Process data part of sF
  names(sF) <- tolower(names(sF))
  colnm <- names(sF)

  # For data analysis don't need detailed map, thin it
  sF_polys <- rmapshaper::ms_simplify(sF, keep = tolerance)

  # get centroids
  if (!"lat_c" %in% names(sF)) {

    centroid <- function(i, polys) {
      ctr <- st_centroid(st_geometry(sF)[[i]])
      data.frame(long_c=ctr[1], lat_c=ctr[2])
    }
    centroids <-  purrr::map_df(1:nrow(sF), centroid, polys=sF)

    nat_data <- st_set_geometry(sF, NULL)
    nat_data <- data.frame(nat_data, centroids)
  }

  # Make character columns all upper case
  nat_data <- chr_upper(nat_data)

  # Extract data and map to be ggplot friendly
  nat_data$id <- row.names(nat_data)

  # Add state
  if (!("state" %in% names(nat_data))) {
    states <- states22
    states$elect_div <- toupper(states$elect_div)
    nat_data <- nat_data %>%
      left_join(states) %>%
      select(id, elect_div, state, numccds, area_sqkm, long_c, lat_c)
  }

  nat_map <- spbabel::sptable(sF_polys)
  colnames(nat_map) <- c("id", "long", "lat", "hole", "piece", "order")
  nat_map$group <- paste("g",nat_map$piece, sep=".")
  nat_map$point <- paste("p", nat_map$id, nat_map$piece, nat_map$order, sep=".")
  nat_map$id <- as.character(nat_map$id)

  # nms$id <- as.character(row.names(nat_data))
  nms <- nat_data %>% select(id, elect_div, state)
  nat_map <- dplyr::left_join(nat_map, nms, by="id")

  # Apply along with cartogram
  nat_data <- nat_data %>%
    aec_add_carto_f()

  # Out
  return(list(map=nat_map, data=nat_data))
}
