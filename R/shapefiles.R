#' Extract shapefiles (of Australian electorates) from shp file
#' 
#' Extract polygon information and demographics for each of Australia's electorates. 
#' The map and data corresponding to the shapefiles of the 2013 Australian electorates (available at \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}) are part of this package as nat_map.rda and nat_data.rda in the data folder.
#' The function will take several minutes to complete.
#' @param shapeFile path to the shp file
#' @param mapinfo Is the data mapInfo format, rather than ESRI? default=TRUE
#' @param layer If the format is mapInfo, the layer name also needs to be provided, default is NULL
#' @param keep percent of polygon points to keep, the default is set to 5\%.
#' @return list with two data frames: map and data; `map` is a data set with geographic latitude and longitude, and a grouping variable to define each entity.
#' The `data` data set consists of demographic or geographic information for each electorate, such as size in square kilometers or corresponding state.
#' Additionally, geographic latitude and longitude of the electorate's centroid are added.
#' @export
#' @examples 
#' \dontrun{
#' fl <- "vignettes/national-midmif-09052016/COM_ELB.TAB"
#' electorates <- getElectorateShapes(shapeFile = fl, layer="COM_ELB", keep=0.01)
#' library(ggplot2)
#' ggplot(data=electorates$data) + 
#'    geom_map(aes(fill=Area_SqKm, map_id=id), map=electorates$map) + 
#'    expand_limits(
#'      x=range(electorates$map$long), 
#'      y=range(electorates$map$lat)
#'    )
#' }
 
getElectorateShapes <- function(shapeFile, mapinfo=TRUE, layer=NULL, keep=0.05) {

  # shapeFile contains the path to the shp file:
  if (mapinfo)
    rgdal::readOGR(dsn=shapeFile, layer=layer)
  else
    sF <- maptools::readShapeSpatial(shapeFile)
  
  # use instead of thinnedSpatialPoly
  sFsmall <- rmapshaper::ms_simplify(sF, keep=keep)
  
  nat_data <- sF@data
  nat_data$id <- row.names(nat_data)
  nat_map <- ggplot2::fortify(sFsmall)
  nat_map$group <- paste("g",nat_map$group,sep=".")
  nat_map$piece <- paste("p",nat_map$piece,sep=".")

  nms <- sFsmall@data %>% dplyr::select(Elect_div, State)
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
  nat_data <- nat_data %>% select(Elect_div, State, Numccds, Area_SqKm, id, long_c, lat_c)
  
  list(map=nat_map, data=nat_data)
}
