#' Download SpatialPolygonsDataFrame containing polygons of Australian federal electorates
#' 
#' @param year Desired year, must be one of 2001, 2004, 2007, 2010, 2011, 2013, 2016
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns a SpatialPolygonsDataFrame containing polygons of the 150 Australian 
#' federal electorates in the year specified.
#'
#' @return A SpatialPolygonsDataFrame containing polygons of the 150 Australian federal electorates
#' 
#' @examples
#' sF_16 <- sF_download(year = 2016)
#' plot(sF_16)
#' 
#' @export
sF_download <- function(year, ...){
  
    year = as.numeric(year)
    suffix = substr(year, 3, 4)
    url_git = paste0("https://github.com/jforbes14/eechidna/raw/master/extra-data/sF_", suffix, ".rda")
    
    if (year == 2001) {
      sF_01 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_01      
    } else if (year == 2004) {
      sF_04 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_04      
    } else if (year == 2007) {
      sF_07 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_07      
    } else if (year == 2010) {
      sF_10 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_10      
    } else if (year == 2011) {
      sF_11 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_11      
    } else if (year == 2013) {
      sF_13 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_13      
    } else if (year == 2016) {
      sF_16 <- 1
      tmp <- tempfile()
      utils::download.file(url_git, tmp, ...)
      load(tmp)
      sF_16      
    } else {
      warning("Electoral boundaries for desired year are not available: select from 2001, 2004, 2007, 2010, 2011, 2013, 2016") 
      return()
    }
      
}


#' Download first preference voting data from each polling booth, from the six 
#' Australian Federal elections between 2001 and 2016.
#' 
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns a data frame containing first preference votes from each polling booth
#' in each of the six Australian federal elections between 2001 and 2016.
#'
#' @return A data frame containing first preference votes
#' 
#' @examples
#' fp_pp <- firstpref_pollingbooth_download()
#' library(dplyr)
#' fp_pp %>% filter(year == 2016) %>% arrange(-OrdinaryVotes) %>% head
#' 
#' @export
firstpref_pollingbooth_download <- function(...){
  fp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/jforbes14/eechidna/raw/master/extra-data/fp_pp.rda", tmp)
  load(tmp)
  fp_pp 
}

#' Download two party preference voting data from each polling booth, from the six 
#' Australian Federal elections between 2001 and 2016.
#' 
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns a data frame containing two party preferred votes from each 
#' polling booth in each of the six Australian federal elections between 2001 and 2016.
#'
#' @return A data frame containing two party preference votes
#' 
#' @examples
#' tpp_pp <- twoparty_pollingbooth_download()
#' library(dplyr)
#' tpp_pp %>% filter(year == 2016) %>% arrange(-LNP_Percent) %>% head
#' 
#' @export
twoparty_pollingbooth_download <- function(...){
  tpp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/jforbes14/eechidna/raw/master/extra-data/tpp_pp.rda", tmp)
  load(tmp)
  tpp_pp 
}

#' Download two candidate preference voting data from each polling booth, from the five 
#' Australian Federal elections between 2004 and 2016.
#' 
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns a data frame containing two candidate preference votes from each polling booth
#' in each of the five Australian federal elections between 2004 and 2016. Note that 2001 is unavailable.
#'
#' @return A data frame containing two candidate preference votes
#' 
#' @examples
#' tcp_pp <- twocand_pollingbooth_download()
#' library(dplyr)
#' tcp_pp %>% filter(year == 2016) %>% arrange(-OrdinaryVotes) %>% head
#' 
#' @export
twocand_pollingbooth_download <- function(...){
  tcp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/jforbes14/eechidna/raw/master/extra-data/tcp_pp.rda", tmp)
  load(tmp)
  tcp_pp 
}
