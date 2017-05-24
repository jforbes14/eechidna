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

#' Download electorate shapefiles
#' @param url url of aec website
#' @param exdir relative path of folder where shapefile should be downloaded to 
#' @param debug boolean for dev people to debug this thing!
#' @return object of class SpatialPolygonsDataFrame
#' @export
#' @examples 
#' \dontrun{
#' x <- download_ShapeFile(exdir = "Shapefiles")
#' # user input 21
#' sFsmall <- rmapshaper::ms_simplify(x, keep=0.01) # use instead of thinnedSpatialPoly
#' plot(sFsmall)
#' 
#' # Download NSW state electorates
#' # the URLs are split to avoid CRAN notes about long line widths
#' url <- paste0("http://www.elections.nsw.gov.au/", 
#' "about_elections/electoral_boundaries/",
#' "electoral_maps/gda94_geographical_midmif_files")
#' x <- download_ShapeFile(exdir = "temp", url = url)
#' 
#' # Download WA state electorates
#' url <- paste0("http://boundaries.wa.gov.au/",
#' "electoral-boundaries/,"
#' "11-march-2017-state-general-election-boundaries")
#' x <- download_ShapeFile(exdir = "temp", url = url)
#' }

download_ShapeFile <- function(url = "http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm", exdir = "temp", debug = FALSE){
  
  dir.create(exdir)
  stem = paste(dirname(url), "/", sep = "")
  
  pg <- xml2::read_html(url)
  fl <- pg %>% rvest::html_nodes("a") %>% rvest::html_attr("href")
  vector_for_url<- fl[grep("*.zip", fl)]
  
  real_files <- fl[grep("*.zip", fl)]
  vector_for_user <- basename(real_files)
  
  dataframe_for_user <- data.frame(file = vector_for_user)
  
  print(dataframe_for_user)
  cat("Write number for file to download \n")

  which_file <- readline()
  which_file <- which_file %>% as.numeric()
  
  if(grepl(glob2rx("*www.*"), real_files[which_file], ignore.case = TRUE)){
    file_url <- real_files[which_file]
  } else {
    file_url <- paste(stem, real_files[which_file], sep = "")
  }

  destfile <- paste(exdir, "/", vector_for_user[which_file], sep = "")
  
  if(debug){
  print("destfile")
  print(destfile)
  print("file_url")
  print(file_url)
  }

  #print(paste(exdir, "/", vector_for_user[which_file], ".zip", sep = ""))
  
  download.file(
    url = file_url,
    destfile = destfile, 
    cacheOK = FALSE
  )
  
  #unzip_dir <- paste(exdir, "/", vector_for_user[which_file], ".zip", sep = "")
  unzip_dir <- paste(exdir, "/", vector_for_user[which_file], sep = "")
  unzip_dir <- sub("*.zip", "", unzip_dir, ignore.case = TRUE)
  
  if(debug){
    print("unzip_dir")
    print(unzip_dir)
  }
  
  suppressWarnings(dir.create(unzip_dir))
  
  unzip(destfile, exdir = unzip_dir)
  
  method <- which_shape_format(
    paste(c(unzip_dir, list.files(unzip_dir)), collapse = " ")
  )
  
  filename <- findFile(method, unzip_dir)
  if(length(filename) > 1){
    filename <- filename[readline(prompt = cat(print(filename), "\n")) %>% as.numeric() %>% as.numeric]
  }
  
  output <- readShapeSpatial_format(filename = paste(unzip_dir, "/", filename, sep = ""), method)
  
  return(output)
}



readShapeSpatial_format <- function(filename, method = "esri"){
  
  if(method == "esri"){
    return(maptools::readShapeSpatial(filename))
  }
  
  if(method == "tab"){
    return(rgdal::readOGR(dsn=filename, layer= rgdal::ogrListLayers(filename)[[1]]))
  }
  
  if(method == "mif"){
    return(rgdal::readOGR(dsn=filename, layer = rgdal::ogrListLayers(filename)[[1]]))
  }
  
}


findFile <- function(method, unzip_dir){
  file_loc <- list.files(unzip_dir, recursive = TRUE)
  
  strings_to_check <- data_frame(
    format = c("esri", "mif", "tab"), 
    extension = c("*.shp", "*.tab", "*.mid")
  )
  
  extension = strings_to_check %>% 
    filter(format == method) %>% 
    select(extension) %>% 
    glob2rx()
  
  filename <- file_loc[grep(extension, file_loc, ignore.case = TRUE)]

  return(filename)
}

which_shape_format <- function(dir){
  
  method <- NA
  
  strings_to_check <- data_frame(
    strings = glob2rx(c("*esri*", "*mif*", "*tab*", "*.shp*")), 
    format = c("esri", "mif", "tab", "esri")
  )
  
  method <- lapply(1:length(strings_to_check$strings), FUN = function(i, ...){
    if(grepl(strings_to_check$strings[i], ignore.case = TRUE, dir)){
      method <- strings_to_check$format[i]
    }
  })
  
  method <- unlist(method)[1]
  
  return(method)
}
  




