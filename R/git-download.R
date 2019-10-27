#' Download SpatialPolygonsDataFrame containing polygons of Australian federal electorates
#' 
#' @param year Desired year, must be one of 2001, 2004, 2007, 2010, 2011, 2013, 2016
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns a large SpatialPolygonsDataFrame containing the polygons 
#' and associated data for each of the 150 Australian electorates in the 2001 federal election. 
#' This object is obtained using the `sF_download` function. The data were obtained from the 
#' Australian Electoral Commission and the Australian Bureau of Statistics.
#'
#' @return A SpatialPolygonsDataFrame containing polygons of the 150 Australian federal electorates
#' 
#' @examples
#' \dontrun{
#' sF_16 <- sF_download(year = 2016)
#' # Plot a map of the electorates
#' library(sp)
#' plot(sF_16)
#' }
#' 
#' @export
sF_download <- function(year, ...){
  
  year = as.numeric(year)
  suffix = substr(year, 3, 4)
  url_git = paste0("https://github.com/ropenscilabs/eechidna/raw/master/extra-data/sF_", suffix, ".rda")
  
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
#' Downloads and returns first preference votes for candidates in the House of 
#' Representatives, for each polling both, in the six Australian Federal elections 
#' between 2001 and 2016. 
#'
#' @return A data frame containing first preference votes
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the House of Representatives from the 2001, 2004, 2007, 2010,
#' 2013 and 2016 Australian federal elections. This data set is obtained using the 
#' `firstpref_pollingbooth_download` function. The data were obtained from the Australian Electoral 
#' Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name     
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item BallotPosition: Candidate's position on the ballot    
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name           
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place
#'     for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party 
#'     from the previous election
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     \item year: Election year
#'     }
#' 
#' @examples
#' \dontrun{
#' fp_pp <- firstpref_pollingbooth_download()
#' library(dplyr)
#' fp_pp %>% filter(year == 2016) %>% arrange(-OrdinaryVotes) %>% head
#' }
#' 
#' @export
firstpref_pollingbooth_download <- function(...){
  fp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/ropenscilabs/eechidna/raw/master/extra-data/fp_pp.rda", tmp)
  load(tmp)
  fp_pp 
}

#' Download two party preference voting data from each polling booth, from the six 
#' Australian Federal elections between 2001 and 2016.
#' 
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns the wo party preferred votes for candidates in the House of 
#' Representatives, for each polling both, in the six Australian Federal elections between
#' 2001 and 2016. 
#'
#' @return A data frame containing two party preference votes
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, 
#' polling place locations, and other results for the House of Representatives from 
#' each of the 2001, 2004, 2007, 2010, 2013 and 2016 Australian federal elections.
#' Includes the count of votes for the Australian Labor Party and the count of votes 
#' for the Liberal-National Coalition for each polling place. This data set is obtained 
#' using the `twoparty_pollingbooth_download` function. The data were obtained from the 
#' Australian Electoral Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the 
#'     Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour 
#'     of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the 
#'     Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour 
#'     of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from 
#'     the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     \item year: Election year
#'     }
#' 
#' @examples
#' \dontrun{
#' tpp_pp <- twoparty_pollingbooth_download()
#' library(dplyr)
#' tpp_pp %>% filter(year == 2016) %>% arrange(-LNP_Percent) %>% head
#' }
#' 
#' @export
twoparty_pollingbooth_download <- function(...){
  tpp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/ropenscilabs/eechidna/raw/master/extra-data/tpp_pp.rda", tmp)
  load(tmp)
  tpp_pp 
}

#' Download two candidate preference voting data from each polling booth, from the five 
#' Australian Federal elections between 2004 and 2016.
#' 
#' @param ... Additional arguments passed to `download.file`
#'
#' Downloads and returns the two candidate preferred votes for candidates in the House of 
#' Representatives, for each polling both, in the five Australian Federal elections between
#' 2004 and 2016. 
#'
#' @return A data frame containing two candidate preference votes
#' 
#' A dataset containing two candidate preferred vote counts, polling place locations,
#' and other results for the House of Representatives from each of the 2004, 
#' 2007, 2010, 2013 and 2016 Australian federal elections. Includes the count of votes
#' for the leading two candidates in the electorate after distribution of preferences 
#' for each polling place. Note that 2001 two candidate preferred vote is not available
#' in this package. This data set is obtained using the `twocand_pollingbooth_download` function.
#' The data were obtained from the Australian Electoral Commission,
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name     
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item BallotPosition: Candidate's position on the ballot    
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name           
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place 
#'     for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party 
#'     from the previous election
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     \item year: Election year
#'     }
#'     
#' @examples
#' \dontrun{
#' tcp_pp <- twocand_pollingbooth_download()
#' library(dplyr)
#' tcp_pp %>% filter(year == 2016) %>% arrange(-OrdinaryVotes) %>% head
#' }
#' 
#' @export
twocand_pollingbooth_download <- function(...){
  tcp_pp <- 1
  tmp <- tempfile()
  utils::download.file("https://github.com/ropenscilabs/eechidna/raw/master/extra-data/tcp_pp.rda", tmp)
  load(tmp)
  tcp_pp 
}
