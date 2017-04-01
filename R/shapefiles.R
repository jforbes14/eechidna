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

#' Download a shapefile from the aec website
#' @param url url of aec website
#' @param stem base directory url of aec website
#' @param exdir relative path of folder where shapefile should be downloaded to 
#' @return object of class SpatialPolygonsDataFrame
#' @export
#' @examples 
#' \dontrun{
#' x <- download_ShapeFile(exdir = "Shapefiles")
#' # user input 21
#' sFsmall <- rmapshaper::ms_simplify(x, keep=0.05) # use instead of thinnedSpatialPoly
#' plot(sFsmall)
#' }

download_ShapeFile <- function(url = "http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm", exdir = ".", stem = "http://www.aec.gov.au/Electorates/gis/"){
  
  dir.create(exdir)
  
  pg <- xml2::read_html(url)
  fl <- pg %>% rvest::html_nodes("a") %>% rvest::html_attr("href")
  vector_for_url<- fl[grep("*.zip", fl)]
  
  vector_for_user <- sub("*.zip", "", vector_for_url)
  vector_for_user <- gsub(glob2rx("*/*"), "", vector_for_user)
  
  # for(i in 1:5){
  #   vector_for_user <- sub("^[^/]*", "", vector_for_user)
  # }
  # vector_for_user <- sub("/*", "", vector_for_user)
  dataframe_for_user <- data.frame(file = vector_for_user)
  
  print(dataframe_for_user)
  cat("Write number for file to download \n")
  #cat(paste(print.data.frame(dataframe_for_user)), "\n")
  which_file <- readline()
  which_file <- which_file %>% as.numeric()
  #print(which_file)
  
  file_url <- paste(stem, vector_for_url[which_file], sep = "")
  #print(file_url)
  
  destfile <- paste(exdir, "/", vector_for_user[which_file], ".zip", sep = "")
  
  #print(paste(exdir, "/", vector_for_user[which_file], ".zip", sep = ""))
  
  download.file(
    url = file_url,
    destfile = destfile
  )
  
  unzip_dir <- paste(exdir, "/", vector_for_user[which_file], sep = "")
  
  dir.create(unzip_dir)
  
  unzip(destfile, exdir = unzip_dir)
  
  if(grepl(glob2rx("*esri*"), ignore.case = TRUE, unzip_dir)){
    method = "ESRI"
  }
  
  if(grepl(glob2rx("*mif*"), ignore.case = TRUE, unzip_dir) | grepl(glob2rx("*tab*"), ignore.case = TRUE, unzip_dir)){
    method = "MapInfo"
  }
  
  filename <- findFile(method, unzip_dir)
  if(length(filename) > 1){
    filename <- filename[readline(prompt = cat(print(filename), "\n")) %>% as.numeric() %>% as.numeric]
  }
  
  MID <- grepl(glob2rx("*.MID*"), filename)
  if(MID){method = MID}
  
  #print(filename)
  #print(paste(unzip_dir, "/", filename, sep = ""))
  
  output <- readShapeSpatial_format(filename = paste(unzip_dir, "/", filename, sep = ""), method)
  
  
}



readShapeSpatial_format <- function(filename, method = "ESRI"){
  
  if(method == "ESRI"){
    return(maptools::readShapeSpatial(filename))
  }
  
  if(method == "MapInfo"){
    return(rgdal::readOGR(dsn=filename, layer="COM_ELB"))
  }
  
  if(method == "MID"){
    return(rgdal::readOGR(dsn=filename, layer = ogrListLayers(filename)[[1]]))
  }
  
}


findFile <- function(method, unzip_dir){
  file_loc <- list.files(unzip_dir, recursive = TRUE)
  
  if(method == "ESRI"){
    filename <- file_loc[grep(glob2rx("*.shp*"), file_loc)]
  }
  if(method == "MapInfo"){
    filename <- file_loc[grep(glob2rx("*.TAB*"), file_loc)]
    if(length(filename) == 0){
      filename <- file_loc[grep(glob2rx("*.MID*"), file_loc)]
    }
  }
  return(filename)
}






