#' 2016 Australian Federal election data: First preference votes for candidates (House of 
#' Representatives) in each electorate.
#' 
#' A dataset containing first preference vote counts, candidate names, and 
#' other results for the House of Representatives from the 2016 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp16"

#' 2016 Australian Federal election data: Two party preferred votes for candidates (House of 
#' Representative) in each electorate.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other 
#' results for the House of Representatives from the 2016 Australian federal election. 
#' Includes the count of votes for the Australian Labor Party and the count of votes for 
#' the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets. 
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp16"


#' 2016 Australian Federal election data: Two candidate preferred votes for candidates
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the 
#' House of Representatives from the 2016 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name             
#'     \item BallotPosition: Candidate's position on the ballot      
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name        
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member      
#'     \item OrdinaryVotes: Number of ordinary votes cast for the candidate 
#'     \item Percent: Percentage of ordinary votes cast for the candidate    
#'     }
"tcp16"

#' 2013 Australian Federal election data: First preference votes for candidates (House of 
#' Representatives) in each electorate.
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2013 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp13"

#' 2013 Australian Federal election data: Two party preferred votes for candidates (House of 
#' Representatives) in each electorate.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, 
#' and other results for the House of Representatives from the 2013 Australian federal 
#' election. Includes the count of votes for the Australian Labor Party and the count 
#' of votes for the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp13"

#' 2013 Australian Federal election data: Two candidate preferred votes for candidates 
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the 
#' House of Representatives from the 2013 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name             
#'     \item BallotPosition: Candidate's position on the ballot      
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name        
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member      
#'     \item OrdinaryVotes: Number of ordinary votes cast for the candidate 
#'     \item Percent: Percentage of ordinary votes cast for the candidate    
#'     }
"tcp13"

#' 2010 Australian Federal election data: First preference votes for candidates (House of House of 
#' Representative for each electorate
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2010 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.   
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp10"

#' 2010 Australian Federal election data: Two party preferred votes for candidates (House of Representatives) in each electorate.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2010 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp10"

#' 2010 Australian Federal election data: Two candidate preferred votes for candidates
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2010 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name             
#'     \item BallotPosition: Candidate's position on the ballot      
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name        
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member      
#'     \item OrdinaryVotes: Number of ordinary votes cast for the candidate 
#'     \item Percent: Percentage of ordinary votes cast for the candidate    
#'     }
"tcp10"

#' 2007 Australian Federal election data: First preference votes for candidates (House of Representatives) in each electorate.
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2007 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.   
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp07"

#' 2007 Australian Federal election data: Two party preferred votes for candidates (House of Representatives) in each electorate.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.   
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp07"

#' 2007 Australian Federal election data: Two candidate preferred votes for candidates 
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the 
#' House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name             
#'     \item BallotPosition: Candidate's position on the ballot      
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name        
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member      
#'     \item OrdinaryVotes: Number of ordinary votes cast for the candidate 
#'     \item Percent: Percentage of ordinary votes cast for the candidate    
#'     }
"tcp07"

#' 2004 Australian Federal election data: First preference votes for candidates (House of 
#' Representatives) in each electorate.
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2004 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)            
#'     \item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp04"

#' 2004 Australian Federal election data: Two party preferred votes for candidates (House of 
#' Representatives) in each electorate.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2004 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.  
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp04"

#' 2004 Australian Federal election data: Two candidate preferred votes for candidates 
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2004 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item DivisionNm:  Electoral division name             
#'     \item BallotPosition: Candidate's position on the ballot      
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name        
#'     \item Elected: Whether the candidate was elected (Y/N)                 
#'     \item OrdinaryVotes: Number of ordinary votes cast for the candidate 
#'     \item Percent: Percentage of ordinary votes cast for the candidate    
#'     }
"tcp04"

#' 2001 Australian Federal election data: First preference votes for candidates (House of Representatives) in each electorate.
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2001 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{https://www.aec.gov.au/About_AEC/Publications/statistics/files/aec-2001-election-statistics.zip}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item StateAb: Abbreviation for state name  
#'     \item DivisionNm:  Electoral division name   
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)            
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp01"

#' 2001 Australian Federal election data: Two party preferred votes for candidates (House of Representatives) in each electorate. where Labor and Liberal parties were the two most popular parties.
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for 
#' the House of Representatives from the 2001 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each electorate.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{https://www.aec.gov.au/About_AEC/Publications/statistics/files/aec-2001-election-statistics.zip}.
#' 
#' @format A data frame with the following variables:
#' \itemize{ 
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item DivisionNm:  Electoral division name   
#'     \item StateAb: Abbreviation for state name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election      
#'     }
"tpp01"

#' 2001 Australian Federal election data: Two candidate preferred votes for candidates 
#' (House of Representatives) in each electorate.
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2001 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{https://www.aec.gov.au/About_AEC/Publications/statistics/files/aec-2001-election-statistics.zip}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item UniqueID: numeric identifier that links the electoral division with Census  
#'     and other election datasets.
#'     \item StateAb: Abbreviation for state name   
#'     \item DivisionNm:  Electoral division name             
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item Elected: Whether the candidate was elected (Y/N)  
#'     \item Percent: Percentage of ordinary votes cast for the candidate   
#'     \item PartyAb: Abbreviation for political party name            
#'     \item PartyNm: Political party name      
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election      
#'     }
"tcp01"

#' Map of Australian Electorates from 2016
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2016 boundaries of the 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
#' 
#' @examples 
#' 
#' library(eechidna)
#' data(nat_map16)
#' # choropleth map with Australian Census data
#' nat_map16$region <- nat_map16$elect_div
#' data(abs2016)
#' abs2016$region <- abs2016$DivisionNm
#' library(ggplot2)
#' library(ggthemes)
#' both <- intersect(unique(abs2016$region), unique(nat_map16$region))
#' ggplot(aes(map_id=region), data=subset(abs2016, region %in% both)) +
#'   geom_map(aes(fill=MedianPersonalIncome), map=subset(nat_map16, region %in% both)) +
#'   expand_limits(x=nat_map16$long, y=nat_map16$lat) + 
#'   theme_map()
#' 
"nat_map16"

#' Map of Australian Electorates from 2013
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2013 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#'
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
"nat_map13"

#' Map of Australian Electorates from 2010
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2010 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
"nat_map10"

#' Map of Australian Electorates from 2007
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2007 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
"nat_map07"

#' Map of Australian Electorates from 2004
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2004 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
"nat_map04"

#' Map of Australian Electorates from 2001
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2001 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Government, and downloaded 
#' from \url{https://data.gov.au/dataset/ds-dga-0b939a62-e53e-4616-add5-77f909b58ddd/details?q=asgc\%202001}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item long: longitude coordinate of point in polygon
#'     \item lat: latitude coordinate of point in polygon
#'     \item order: order for polygon points
#'     \item hole: whether polygon has a hole
#'     \item piece: piece for polygon
#'     \item group: group for polygon
#'     \item elect_div: Electoral division name
#'     \item state: Abbreviation for state name
#' }
"nat_map01"

#' Data of the Australian Electorates from 2016
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item numccds: AEC variable that might be filled with meaning or a description down the road
#'     \item area_sqkm: combined square kilometers of each electorate
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
#' @examples 
#' 
#' library(eechidna)
#' library(tidyverse)
#' library(ggthemes)
#' data(nat_map16)
#' data(fp16)
#' winners <- fp16 %>% filter(Elected == "Y")
#' data(nat_data16)
#' nat_data16$DivisionNm <- toupper(nat_data16$elect_div)
#' nat_data16 <- nat_data16 %>% left_join(winners, by = "DivisionNm")
#' 
#' # Plot
#' partycolours = c("#FF0033", "#000000", "#CC3300", "#0066CC", "#FFFF00", "#009900")
#' 
#' ggplot(data=nat_map16) + 
#' geom_polygon(aes(x=long, y=lat, group=group), fill="grey90", colour="white") +
#' geom_point(data=nat_data16, aes(x=x, y=y, colour=PartyNm), size=1.5, alpha=0.8) +
#' scale_colour_manual(name="Political Party", values=partycolours) +
#' theme_map() + coord_equal() + theme(legend.position="bottom")
"nat_data16"

#' Data of the Australian Electorates from 2013
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item numccds: AEC variable that might be filled with meaning or a description down the road
#'     \item area_sqkm: combined square kilometers of each electorate
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data13"

#' Data of the Australian Electorates from 2010
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item numccds: AEC variable that might be filled with meaning or a description down the road
#'     \item area_sqkm: combined square kilometers of each electorate
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data10"

#' Data of the Australian Electorates from 2007
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data07"

#' Data of the Australian Electorates from 2004
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data04"

#' Data of the Australian Electorates from 2001
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Government, and downloaded 
#' from \url{https://data.gov.au/dataset/ds-dga-0b939a62-e53e-4616-add5-77f909b58ddd/details?q=asgc\%202001}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier for the polygon
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data01"

#' 2016 Australian Census data on all 150 electorates
#'
#' A dataset containing demographic and other information about each electorate from the
#' Australian Census of Population and Housing.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#' Electorate boundaries match those in place at the time of the 2016 Federal election.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item UniqueID: numeric identifier that links the electoral division with Census 
#'   and other election datasets.
#'   \item DivisionNm: Name of electorate
#'   \item State: State containing electorate
#'   \item Population: Total population of electorate
#'   \item Area: Area of electorate division in square kilometres
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item BornOverseas_NS: Percentage of people who did not answer the question relating to birthplace
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyIncome_NS: Percentage of people who did not answer the question relating to family income
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item HighSchool_NS: Rate of nonresponse for questions relating to high school completion
#'   \item HouseholdIncome_NS: Percentage of people who did not answer the question relating to household income
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetAccess_NS: Rate of nonresponse for questions relating to internal access
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item InternetUse_NS: Rate of nonresponse for questions relating to internet use (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item Language_NS: Rate of nonresponse for questions relating to language spoken at home
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item PersonalIncome_NS: Rate of nonresponse for questions relating to personal income
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Religion_NS: Rate of nonresponse for questions relating to religion
#'   \item Rent_NS: Rate of nonresponse for questions relating to rental costs
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tenure_NS: Rate of nonresponse for questions relating to tenure
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item University_NS: Rate of nonresponse for questions relating to University
#'   \item Volunteer: Percentage of people who work as a volunteer
#'   \item Volunteer_NS: Rate of nonresponse for questions relating to working as a volunteer
#' }
#' 
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2016)
#' abs2016 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp16)
#' election2016 <- left_join(abs2016, tpp16, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2016, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2016"  

#' 2011 Australian Census data on all 150 electorates
#'
#' A dataset containing demographic and other information about each electorate from the
#' Australian Census of Population and Housing.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#' Electorate boundaries match those in place at the time of the 2011 Census.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item UniqueID: numeric identifier that links the electoral division with Census 
#'   and other election datasets.
#'   \item DivisionNm: Name of electorate
#'   \item State: State containing electorate
#'   \item Population: Total population of electorate
#'   \item Area: Area of electorate division in square kilometres
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item BornOverseas_NS: Percentage of people who did not answer the question relating to birthplace
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyIncome_NS: Percentage of people who did not answer the question relating to family income
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item HighSchool_NS: Rate of nonresponse for questions relating to high school completion
#'   \item HouseholdIncome_NS: Percentage of people who did not answer the question relating to household income
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetAccess_NS: Rate of nonresponse for questions relating to internal access
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item InternetUse_NS: Rate of nonresponse for questions relating to internet use (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item Language_NS: Rate of nonresponse for questions relating to language spoken at home
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item PersonalIncome_NS: Rate of nonresponse for questions relating to personal income
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Religion_NS: Rate of nonresponse for questions relating to religion
#'   \item Rent_NS: Rate of nonresponse for questions relating to rental costs
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tenure_NS: Rate of nonresponse for questions relating to tenure
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item University_NS: Rate of nonresponse for questions relating to University
#'   \item Volunteer: Percentage of people who work as a volunteer
#'   \item Volunteer_NS: Rate of nonresponse for questions relating to working as a volunteer
#' }
#' 
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2011)
#' abs2011 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
"abs2011" 

#' 2006 Australian Census data on all 150 electorates (2004 boundaries)
#'
#' A dataset containing demographic and other information about each electorate from the
#' Australian Census of Population and Housing.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#' Electorate boundaries match those in place at the time of the 2004 Federal election.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item UniqueID: numeric identifier that links the electoral division with Census 
#'   and other election datasets.
#'   \item DivisionNm: Name of electorate
#'   \item State: State containing electorate
#'   \item Population: Total population of electorate
#'   \item Area: Area of electorate division in square kilometres
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item BornOverseas_NS: Percentage of people who did not answer the question relating to birthplace
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyIncome_NS: Percentage of people who did not answer the question relating to family income
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item HighSchool_NS: Rate of nonresponse for questions relating to high school completion
#'   \item HouseholdIncome_NS: Percentage of people who did not answer the question relating to household income
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetAccess_NS: Rate of nonresponse for questions relating to internal access
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item InternetUse_NS: Rate of nonresponse for questions relating to internet use (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item Language_NS: Rate of nonresponse for questions relating to language spoken at home
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item PersonalIncome_NS: Rate of nonresponse for questions relating to personal income
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Religion_NS: Rate of nonresponse for questions relating to religion
#'   \item Rent_NS: Rate of nonresponse for questions relating to rental costs
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tenure_NS: Rate of nonresponse for questions relating to tenure
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item University_NS: Rate of nonresponse for questions relating to University
#'   \item Volunteer: Percentage of people who work as a volunteer
#'   \item Volunteer_NS: Rate of nonresponse for questions relating to working as a volunteer
#' }
#' 
#' @examples
#' library(eechidna)
#' library(dplyr) 
#' data(abs2006)
#' abs2006 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
"abs2006" 

#' 2006 Australian Census data on all 150 electorates (2007 boundaries)
#'
#' A dataset containing demographic and other information about each electorate from the
#' Australian Census of Population and Housing.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#' Electorate boundaries match those in place at the time of the 2007 Federal election.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item UniqueID: numeric identifier that links the electoral division with Census 
#'   and other election datasets.
#'   \item DivisionNm: Name of electorate
#'   \item State: State containing electorate
#'   \item Population: Total population of electorate
#'   \item Area: Area of electorate division in square kilometres
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item BornOverseas_NS: Percentage of people who did not answer the question relating to birthplace
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyIncome_NS: Percentage of people who did not answer the question relating to family income
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item HighSchool_NS: Rate of nonresponse for questions relating to high school completion
#'   \item HouseholdIncome_NS: Percentage of people who did not answer the question relating to household income
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetAccess_NS: Rate of nonresponse for questions relating to internal access
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item InternetUse_NS: Rate of nonresponse for questions relating to internet use (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item Language_NS: Rate of nonresponse for questions relating to language spoken at home
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item PersonalIncome_NS: Rate of nonresponse for questions relating to personal income
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Religion_NS: Rate of nonresponse for questions relating to religion
#'   \item Rent_NS: Rate of nonresponse for questions relating to rental costs
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tenure_NS: Rate of nonresponse for questions relating to tenure
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item University_NS: Rate of nonresponse for questions relating to University
#'   \item Volunteer: Percentage of people who work as a volunteer
#'   \item Volunteer_NS: Rate of nonresponse for questions relating to working as a volunteer
#' }
#'
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2006_e07)
#' abs2006_e07 %>% 
#' select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% 
#' head()
#'
"abs2006_e07"  

#' 2001 Australian Census data on all 150 electorates
#'
#' A dataset containing demographic and other information about each electorate from the
#' Australian Census of Population and Housing.
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{https://www.censusdata.abs.gov.au/datapacks/}.
#' Electorate boundaries match those in place at the time of the 2001 Federal election.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item UniqueID: numeric identifier that links the electoral division with Census 
#'   and other election datasets.
#'   \item DivisionNm: Name of electorate
#'   \item State: State containing electorate
#'   \item Population: Total population of electorate
#'   \item Area: Area of electorate division in square kilometres
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item BornOverseas_NS: Percentage of people who did not answer the question relating to birthplace
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyIncome_NS: Percentage of people who did not answer the question relating to family income
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item HighSchool_NS: Rate of nonresponse for questions relating to high school completion
#'   \item HouseholdIncome_NS: Percentage of people who did not answer the question relating to household income
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetAccess_NS: Rate of nonresponse for questions relating to internal access
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item InternetUse_NS: Rate of nonresponse for questions relating to internet use (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item Language_NS: Rate of nonresponse for questions relating to language spoken at home
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item PersonalIncome_NS: Rate of nonresponse for questions relating to personal income
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Religion_NS: Rate of nonresponse for questions relating to religion
#'   \item Rent_NS: Rate of nonresponse for questions relating to rental costs
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tenure_NS: Rate of nonresponse for questions relating to tenure
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item University_NS: Rate of nonresponse for questions relating to University
#'   \item Volunteer: Percentage of people who work as a volunteer
#'   \item Volunteer_NS: Rate of nonresponse for questions relating to working as a volunteer 
#' }
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2001)
#' abs2001 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp01)
#' election2001 <- left_join(abs2001, tpp01, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2001, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2001"  

#' Imputed Australian Census data for the electorates in place at time of the 2013 Federal election
#'
#' A dataset containing estimated demographic and other information about each electorate.
#' The data is imputed using Census information from 2011 and 2016. See the imputing-census-data
#' vignette for more details.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item DivisionNm: Name of electorate
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item Volunteer: Percentage of people who work as a volunteer
#' }
#' 
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2013)
#' abs2013 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp13)
#' election2013 <- left_join(abs2013, tpp13, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2013, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2013"  

#' Imputed Australian Census data for the electorates in place at time of the 2010 Federal election
#'
#' A dataset containing estimated demographic and other information about each electorate.
#' The data is imputed using Census information from 2006 and 2011. See the imputing-census-data
#' vignette for more details.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item DivisionNm: Name of electorate
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item Volunteer: Percentage of people who work as a volunteer
#' }
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2010)
#' abs2010 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp10)
#' election2010 <- left_join(abs2010, tpp10, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2010, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2010"  

#' Imputed Australian Census data for the electorates in place at time of the 2007 Federal election
#'
#' A dataset containing estimated demographic and other information about each electorate.
#' The data is imputed using Census information from 2006 and 2011. See the imputing-census-data
#' vignette for more details.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item DivisionNm: Name of electorate
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item Volunteer: Percentage of people who work as a volunteer
#' }
#' 
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2007)
#' abs2007 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp07)
#' election2007 <- left_join(abs2007, tpp07, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2007, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2007"  

#' Imputed Australian Census data for the electorates in place at time of the 2004 Federal election
#'
#' A dataset containing estimated demographic and other information about each electorate.
#' The data is imputed using Census information from 2001 and 2006. See the imputing-census-data
#' vignette for more details.
#'
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'   \item DivisionNm: Name of electorate
#'   \item Age00_04: Percentage of people aged 0-4.
#'   \item Age05_14: Percentage of people aged 5-9.
#'   \item Age15_19: Percentage of people aged 15-19.
#'   \item Age20_24: Percentage of people aged 20-24.
#'   \item Age25_34: Percentage of people aged 25-34.
#'   \item Age35_44: Percentage of people aged 35-44.
#'   \item Age45_54: Percentage of people aged 45-54.
#'   \item Age55_64: Percentage of people aged 55-64.
#'   \item Age65_74: Percentage of people aged 65-74.
#'   \item Age75_84: Percentage of people aged 75-84.
#'   \item Age85plus: Percentage of people aged 85 or higher.
#'   \item Anglican: Percentage of people affiliated with the Anglican denomimation
#'   \item AusCitizen: Percentage of people who are Australian Citizens
#'   \item AverageHouseholdSize: Average number of people in a household 
#'   \item BachelorAbv: Percentage of people who have completed a Bachelor degree or above
#'   \item Born_Asia: Percentage of people born in Asia
#'   \item Born_MidEast: Percentage of people born in the Middle East
#'   \item Born_SE_Europe: Percentage of people born in South Eastern Europe
#'   \item Born_UK: Percentage of people born in the United Kingdom
#'   \item BornElsewhere: Percentage of people who were born overseas, outside of Asia, Middle East, South Eastern Europe and the UK
#'   \item Buddhism: Percentage of people affiliated with the Buddhist religion
#'   \item Catholic: Percentage of people affiliated with the Catholic denomimation
#'   \item Christianity: Percentage of people affiliated with the Christian religion (of all denominations)
#'   \item Couple_NoChild_House: Percentage of households made up of a couple with no children
#'   \item Couple_WChild_House: Percentage of households made up of a couple with children
#'   \item CurrentlyStudying: Percentage of people who are currently studying
#'   \item DeFacto: Percentage of people who are in a de facto marriage
#'   \item DiffAddress: Percentage of people who live at a different address to what they did 5 years ago
#'   \item DipCert: Percentage of people who have completed a diploma or certificate
#'   \item Distributive: Percentage of employed persons who work in wholesale trade, retail trade, transport, post or warehousing related industries
#'   \item EmuneratedElsewhere: Percentage of people who receive emuneration outside of Australia, out of the total population plus overseas visitors
#'   \item EnglishOnly: Percentage of people who speak only English
#'   \item Extractive: Percentage of employed persons who work in extractive industries (includes mining, gas, water, agriculture, waste, electricity)
#'   \item FamilyRatio: Average number of people per family
#'   \item Finance: Percentage of employed persons who work in finance or insurance related industries
#'   \item HighSchool: Percentage of people who have completed high school
#'   \item Indigenous: Percentage of people who are Indigenous
#'   \item InternetAccess: Percentage of people with access to the internet
#'   \item InternetUse: Percentage of people who used internet in the last week (2001 only)
#'   \item Islam: Percentage of people affiliated with the Islamic religion
#'   \item Judaism: Percentage of people affiliated with the Jewish religion
#'   \item Laborer: Percentage of employed persons who work as a laborer
#'   \item LFParticipation: Labor force participation rate
#'   \item ManagerAdminClericalSales: Percentage of employed persons who work in management, administration, clerical duties and sales
#'   \item Married: Percentage of people who are married
#'   \item MedianAge: Median age
#'   \item MedianFamilyIncome: Median weekly family income (in $)
#'   \item MedianHouseholdIncome: Median weekly household income (in $)
#'   \item MedianLoanPay: Median mortgage loan repayment amount (of mortgage payments, in $)
#'   \item MedianPersonalIncome: Median weekly personal income (in $)
#'   \item MedianRent: Median weekly rental payment amount (of those who rent, in $)
#'   \item Mortgage: Percentage of dwellings that are on a mortgage
#'   \item NoReligion: Percentage of people with no religion
#'   \item OneParent_House: Percentage of households made up of one parent with children
#'   \item Other_NonChrist: Percentage of people affiliated with a religion other than Christianity, Buddhism, Islam and Judaism
#'   \item OtherChrist: Percentage of people affiliated with a denomination of the Christian religion other than Anglican or Catholic
#'   \item OtherLanguageHome: Percentage of people who speak a language other than English at home
#'   \item Owned: Percentage of dwellings that are owned outright
#'   \item Professional: Percentage of employed persons who work as a professional
#'   \item PublicHousing: Percentage of dwellings that are owned by the government, and rented out to tenants
#'   \item Renting: Percentage of dwellings that are being rented
#'   \item SocialServ: Percentage of employed persons who work in education and training, healthcare, social work, community, arts and recreation
#'   \item SP_House: Percentage of households occupied by a single person
#'   \item Tradesperson: Percentage of employed persons who specialise in a trade
#'   \item Transformative: Percentage of employed persons who work in construction or manufacturing related industries
#'   \item Unemployed: Unemployment rate
#'   \item Volunteer: Percentage of people who work as a volunteer
#' }
#' 
#' @examples 
#' library(eechidna)
#' library(dplyr)
#' data(abs2004)
#' abs2004 %>% select(DivisionNm, MedianAge, Unemployed, NoReligion, MedianPersonalIncome) %>% head()
#' 
#' # Join with two-party preferred voting data
#' library(ggplot2)
#' data(tpp04)
#' election2004 <- left_join(abs2004, tpp04, by = "UniqueID")
#' # See relationship between personal income and Liberal/National support
#' ggplot(election2004, aes(x = MedianPersonalIncome, y = LNP_Percent)) + geom_point() + geom_smooth()
"abs2004"  

