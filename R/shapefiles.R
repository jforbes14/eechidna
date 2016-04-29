#' Extract shapefiles (of Australian electorates) from shp file
#' 
#' Extract polygon information and demographics for each of Australia's electorates. 
#' The map and data corresponding to the shapefiles of the 2013 Australian electorates (available at \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}) are part of this package as nat_map.rda and nat_data.rda in the data folder.
#' The function will take several minutes to complete.
#' @param shapeFile path to the shp file
#' @param keep percent of polygon points to keep, the default is set to 5\%.
#' @return list with two data frames: map and data; `map` is a data set with geographic latitude and longitude, and a grouping variable to define each entity.
#' The `data` data set consists of demographic or geographic information for each electorate, such as size in square kilometers or corresponding state.
#' Additionally, geographic latitude and longitude of the electorate's centroid are added.
#' @export
#' @examples 
#' \dontrun{
#' url <- "national-esri-16122011/COM20111216_ELB_region.shp"
#' electorates <- getElectorateShapes(url)
#' library(ggplot2)
#' ggplot(data=electorates$data) + 
#'    geom_map(aes(fill=AREA_SQKM, map_id=id), map=electorates$map) + 
#'    expand_limits(
#'      x=range(electorates$map$long), 
#'      y=range(electorates$map$lat)
#'    )
#' }
 
getElectorateShapes <- function(shapeFile, keep=0.05) {

  # shapeFile contains the path to the shp file:
  sF <- maptools::readShapeSpatial(shapeFile)
  # require(rmapshaper)
  # devtools::install_github("ateucher/rmapshaper")`.
  
  sFsmall <- rmapshaper::ms_simplify(sF, keep=keep) # use instead of thinnedSpatialPoly
  
  nat_data <- sF@data
  nat_data$id <- row.names(nat_data)
  nat_map <- ggplot2::fortify(sFsmall)
  nat_map$group <- paste("g",nat_map$group,sep=".")
  nat_map$piece <- paste("p",nat_map$piece,sep=".")
  
  # get centroids
  polys <- as(sF, "SpatialPolygons")
  
  library(dplyr)
  centroid <- function(i, polys) {
    ctr <- sp::Polygon(polys[i])@labpt
    data.frame(long_c=ctr[1], lat_c=ctr[2])
  }
  centroids <- seq_along(polys) %>% purrr::map_df(centroid, polys=polys)
  
  nat_data <- data.frame(nat_data, centroids)
  
  list(map=nat_map, data=nat_data)
}
