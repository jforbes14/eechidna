#' Load shapefile into R as a SpatialDataFrame, extract polygon information, thin
#' polygon, fix any problematic polygons, and format variable names.
#' "nat_map" and "nat_data" objects for every Australian federal election between 
#' 2001-2016 can be readily loaded from the package for analysis. 
#' 
#' The function will take several minutes to complete.
#' 
#' @param path_to_shapeFile path to object in local machine
#' @param tolerance numerical tolerance value to be used by the Douglas-Peuker algorithm
#' @return object of class SpatialPolygonsDataFrame
#' @export
#' @examples 
#' \dontrun{
#' fl <- "vignettes/national-midmif-09052016/COM_ELB.TAB"
#' sF_2016 <- loadShapeFile("local/path/to/shapefile.shp")
#' }

loadShapeFile <- function(path_to_shapeFile, tolerance = 0.005) {
  
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
  polys_sF <- rgeos::gSimplify(sF, tol = tolerance)
  
  # Ensure all polygons are valid
  #new_sF <- sF %>% subset(elect_div == "")
  #for (i in 1:nrow(sF@data)) {
  #  temp <- sF %>% subset(elect_div == sF@data$elect_div[i])
  #  if (!rgeos::gIsValid(temp)) {
  #    temp <- rgeos::gBuffer(temp, byid = TRUE, width = 0)
  #  }
  #  new_sF <- raster::bind(new_sF, temp)
  #}
  
  out <- sp::SpatialPolygonsDataFrame(polys_sF, sF@data)
  
  return(out)
}

#' Extract shapefiles (of Australian electorates) from shp file
#' 
#' Extract polygon information and demographics for each of Australia's electorates. 
#' The map and data corresponding to the shapefiles of the 2013 Australian electorates (available at \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}) are part of this package as nat_map.rda and nat_data.rda in the data folder.
#' The function will take several minutes to complete.
#' @param path_to_shapeFile path to object in local machine (only if shapefile has not already loaded)
#' @param sF Shapefile object loaded to environment using loadShapeFile
#' @param mapinfo Is the data mapInfo format, rather than ESRI? default=TRUE
#' @param layer If the format is mapInfo, the layer name also needs to be provided, default is NULL
#' @param tolerance Numerical tolerance value to be used by the Douglas-Peuker algorithm (only if shapefile has not already loaded)
#' @return list with two data frames: map and data; `map` is a data set with geographic latitude and longitude, and a grouping variable to define each entity.
#' The `data` data set consists of demographic or geographic information for each electorate, such as size in square kilometers or corresponding state.
#' Additionally, geographic latitude and longitude of the electorate's centroid are added.
#' @export
#' @examples 
#' \dontrun{
#' fl <- "PATH-ON-YOUR-COMPUTER/national-midmif-09052016/COM_ELB.TAB"
#' map_and_data16 <- getElectorateShapes(path_to_shapefile = fl)
#' }

getElectorateShapes <- function(path_to_shapeFile = NULL, sF = NULL, mapinfo=TRUE, layer=NULL, tolerance=0.005) {

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
  nat_map <- ggplot2::fortify(sF)
  nat_map$group <- paste("g",nat_map$group,sep=".")
  nat_map$piece <- paste("p",nat_map$piece,sep=".")
  
  if ("state" %in% names(sF@data)) {
    nms <- dplyr::select(sF@data, elect_div, state)
  } else {
    nms <- dplyr::select(sF@data, elect_div)
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
  
  # Function: Fix state labels
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
  
  # Function: characters upper case
  chr_upper <- function(df) {
    fc_cols <- sapply(df, class) == 'factor'
    df[, fc_cols] <- lapply(df[, fc_cols], as.character)
    
    ch_cols <- sapply(df, class) == 'character'
    df[, ch_cols] <- lapply(df[, ch_cols], toupper)
    return(df)
  }
  
  # Apply along with cartogram
  nat_map <- nat_map %>% 
    chr_upper() %>% state_label()
  nat_data <- nat_data %>% 
    chr_upper() %>% state_label() %>% 
    aec_add_carto_f() %>% 
    select(-radius) %>% 
    rename("carto_x" = "x", "carto_y" = "y")
  
  # Out
  return(list(map=nat_map, data=nat_data))
}
