
#' 2011 Census data on all 150 electorates
#'
#' A dataset containing demographic and other information about each electorate.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item ID: Commonwealth Electoral District identifier.
#'   \item Name: Name of electorate
#'   \item State: State containing electorate.
#'   \item Population: Total population of electorate.
#'   \item Area: Area of electorate in square kilometres.
#'   \item MedianIncome: Weekly median income of people within electorate (in $).
#'   \item Unemployed: Percentage of people unemployed.
#'   \item Bachelor: Percentage of people whose highest qualification is a Bachelor degree.
#'   \item Postgraduate: Percentage of people whose highest qualification is a postgraduate degree.
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations).
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation.
#'   \item Buddhist: Percentage of people affiliated with the Buddhist religion.
#'   \item Islam: Percentage of people affiliated with the Islam religion.
#'   \item Judaism: Percentageof people affiliated with the Jewish religion. 
#'   \item NoReligion: Percentage of people with no religious affiliation.
#'   \item Age0_4: Percentage of people aged 0-4.
#'   \item Age5_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item BornOverseas: Percentage of people born outside Australia.
#'   \item Indigenous: Percentage of people who are Indigenous.
#'   \item EnglishOnly: Percentage of people who speak only English.
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home.
#'   \item Married: Percentage of people who are married.
#'   \item DeFacto: Percentage of people who are in a de facto marriage.
#'   \item FamilyRatio: Total number of families to total number of people (times 100).
#'   \item Internet: Percentage of people with home internet.
#'   \item NotOwned: Percentage of dwellings not owned (either outright or with a mortgage).
#' }
"abs2011"

#' 2013 General election data for the House of Representatives
#' 
#' A dataset containing vote counts, candidate names, polling place locations,
#' and other national, state, divisional and polling place results for the
#' House of Representatives from the 2013 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for State name           
#'     \item DivisionID.x: Electoral division ID    
#'     \item DivisionNm.x:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name     
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item BallotPosition: Candidate's position on the ballot    
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected:   
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name           
#'     \item OrdinaryVotes: Number of ordinates votes cast at the polling place for the candidate     
#'     \item Swing:             
#'     \item State: State name             
#'     \item PollingPlaceTypeID:
#'     \item Premises Nm:        
#'     \item PremisesAddress1:  
#'     \item PremisesAddress2:  
#'     \item PremisesAddress3:  
#'     \item PremisesSuburb:    
#'     \item PremisesStateAb:   
#'     \item PremisesPostCode:  
#'     \item Latitude:          
#'     \item Longitude:S
"aec2013"


#' Map of Australian Electorate from 2013
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2013 boundaries of the 
#' electorates (and downsampled to a 1% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' @examples 
#' data(nat_map)
#' # choropleth map with Census data
#' nat_map$region <- nat_map$ELECT_DIV
#' data(abs2011)
#' abs2011$region <- abs2011$Name
#' library(ggplot2)
#' library(ggthemes)
#' both <- intersect(unique(abs2011$region), unique(nat_map$region))
#' ggplot(aes(map_id=region), data=subset(abs2011, region %in% both)) +
#' geom_map(aes(fill=MedianIncome), map=subset(nat_map, region %in% both)) +
#' expand_limits(x=nat_map$long, y=nat_map$lat) + 
#' theme_map()
"nat_map"

