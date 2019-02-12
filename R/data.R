#' --------------------------------------------------------------------------------------------------

#' 2016 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2016 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"fp_pp16"

#' 2016 General election data for first preference votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2016 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp16"

#' 2016 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2016 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tpp_pp16"

#' 2016 General election data for two party preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2016 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item DivisionID: Electoral division ID    
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

#' 2016 General election data for two candidate preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two candidate preferred vote counts,  polling place locations,
#' and other results for the House of Representatives from the 2016 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tcp_pp16"

#' 2016 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2016 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
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

#' --------------------------------------------------------------------------------------------------

#' 2013 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2013 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"fp_pp13"

#' 2013 General election data for first preference votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp13"

#' 2013 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2013 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tpp_pp13"

#' 2013 General election data for two party preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2013 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item DivisionID: Electoral division ID    
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

#' 2013 General election data for two candidate preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two candidate preferred vote counts,  polling place locations,
#' and other results for the House of Representatives from the 2013 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tcp_pp13"

#' 2013 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2013 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
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

#' --------------------------------------------------------------------------------------------------

#' 2010 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2010 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"fp_pp10"

#' 2010 General election data for first preference votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp10"

#' 2010 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2010 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tpp_pp10"

#' 2010 General election data for two party preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2010 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item DivisionID: Electoral division ID    
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

#' 2010 General election data for two candidate preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two candidate preferred vote counts,  polling place locations,
#' and other results for the House of Representatives from the 2010 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tcp_pp10"

#' 2010 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
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

#' --------------------------------------------------------------------------------------------------

#' 2007 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2007 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"fp_pp07"

#' 2007 General election data for first preference votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)           
#'     \item HistoricElected: Whether the candidate is the incumbent member  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp07"

#' 2007 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tpp_pp07"

#' 2007 General election data for two party preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item DivisionID: Electoral division ID    
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

#' 2007 General election data for two candidate preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two candidate preferred vote counts,  polling place locations,
#' and other results for the House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
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
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tcp_pp07"

#' 2007 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2007 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
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

#' --------------------------------------------------------------------------------------------------

#' 2004 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2004 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
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
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name           
#'     \item Elected: Whether the candidate was elected (Y/N)  
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"fp_pp04"

#' 2004 General election data for first preference votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item BallotPosition: Candidate's position on the ballot 
#'     \item CandidateID: Candidate ID       
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name            
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name      
#'     \item Elected: Whether the candidate was elected (Y/N)            
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Percent: Percentage of ordinary votes for the candidate     
#'     }
"fp04"

#' 2004 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2004 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name    
#'     \item DivisionID: Electoral division ID    
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlaceID: Polling place ID  
#'     \item PollingPlace: Polling place name  
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party     
#'     \item TotalVotes: Total number of votes cast     
#'     \item Swing: Percentage point change in two party preferred vote from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tpp_pp04"

#' 2004 General election data for two party preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, and other results for the House of Representatives from the 2004 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item DivisionID: Electoral division ID    
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

#' 2004 General election data for two candidate preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two candidate preferred vote counts,  polling place locations,
#' and other results for the House of Representatives from the 2004 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences for each polling place.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm} and 
#' \url{http://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}.
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
#'     \item PartyAb: Abbreviation for political party name           
#'     \item PartyNm: Political party name           
#'     \item OrdinaryVotes: Number of ordinary votes cast at the polling place for the candidate     
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election     
#'     \item PremisesPostCode: Post code of polling booth  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     }
"tcp_pp04"

#' 2004 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
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
#'     \item DivisionID: Electoral division ID    
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

#' --------------------------------------------------------------------------------------------------

#' 2001 General election data for first preference votes for candidates for the House of Representatives for each polling place
#' 
#' A dataset containing first preference vote counts, candidate names, polling place locations,
#' and other results for the
#' House of Representatives from the 2001 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name     
#'     \item DivisionNm:  Electoral division name   
#'     \item PollingPlace: Polling place name  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates
#'     \item TotalVotes: Total number of votes submitted at polling booth
#'     \item ALP: Percentage of votes for the Labor party
#'     \item GRN: Percentage of votes for the Greens
#'     \item ON: Percentage of votes for One Nation
#'     \item IND: Percentage of votes for independent candidates
#'     \item LNP: Percentage of votes for the Liberal National Coalition  
#'     \item Other: Percentage of votes for other parties
#'     }
"fp_pp01"

#' 2001 General election data for first preference votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing first preference vote counts, candidate names, and other results for the
#' House of Representatives from the 2001 Australian federal election. 
#' The data were obtained from the Australian Electoral Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
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

#' 2001 General election data for two party preferred votes for the House of Representatives for each polling place
#' 
#' A dataset containing two party preferred vote counts, winning candidate names, polling place locations,
#' and other results for the House of Representatives from the 2001 Australian federal election. Includes the count of votes for
#' the Australian Labor Party and the count of votes for the Liberal-National Coalition for each polling place.
#' The data were obtained from the Australian Electoral Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name 
#'     \item DivisionNm:  Electoral division name 
#'     \item PollingPlace: Polling place name  
#'     \item Latitude: Coordinates        
#'     \item Longitude: Coordinates  
#'     \item TotalVotes: Total number of votes cast   
#'     \item LNP_Votes: Count of two party preferred vote in favour of the Liberal National coalition
#'     \item LNP_Percent: Percentage of two party preferred vote in favour of the Liberal National coalition   
#'     \item ALP_Votes: Count of two party preferred vote in favour of the Labor party
#'     \item ALP_Percent: Percentage of two party preferred vote in favour of the Labor party
#'     }
"tpp_pp01"

#' 2001 General election data for two candidate preferred votes for candidates for the House of Representative for each electorate
#' 
#' A dataset containing two candidate preferred vote counts, and other results for the House of Representatives from the 2001 Australian federal election. Includes the count of votes for
#' the leading two candidates in the electorate after distribution of preferences.
#' The data were obtained from the Australian Electoral Commission.
#' 
#' @format A data frame with the following variables:
#' \itemize{
#'     \item StateAb: Abbreviation for state name   
#'     \item DivisionNm:  Electoral division name             
#'     \item Surname: Candidate surname          
#'     \item GivenNm: Candidate given name 
#'     \item Elected: Whether the candidate was elected (Y/N)  
#'     \item Percent: Percentage of ordinary votes cast for the candidate   
#'     \item PartyAb: Abbreviation for political party name    
#'     \item Swing: Percentage point change in ordinary votes for the party from the previous election      
#'     }
"tcp01"

#' --------------------------------------------------------------------------------------------------

#' Map of Australian Electorates from 2016
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2016 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' @examples 
#' 
#' data(nat_map16)
#' # choropleth map with Census data
#' nat_map16$region <- nat_map16$elect_div
#' data(abs2016)
#' abs2016$region <- abs2016$Electorate
#' library(ggplot2)
#' library(ggthemes)
#' both <- intersect(unique(abs2016$region), unique(nat_map16$region))
#' ggplot(aes(map_id=region), data=subset(abs2016, region %in% both)) +
#'   geom_map(aes(fill=MedianIncome), map=subset(nat_map16, region %in% both)) +
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
"nat_map13"

#' Map of Australian Electorates from 2010
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2010 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' 
"nat_map07"

#' Map of Australian Electorates from 2007
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2007 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' 
"nat_map07"

#' Map of Australian Electorates from 2004
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2004 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Bureau of Statistics, and downloaded 
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' 
"nat_map04"

#' Map of Australian Electorates from 2001
#'
#' A dataset containing the map of the all 150 Australian electorates using the 2001 boundaries of the 
#' electorates (and downsampled to a 5\% file to allow fast plotting).
#' The data were obtained from the Australian Government, and downloaded 
#' from \url{https://data.gov.au/dataset/ds-dga-0b939a62-e53e-4616-add5-77f909b58ddd/details?q=asgc%202001}.
#' 
"nat_map01"

#' Data of the Australian Electorates from 2016
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
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
#' data(nat_map16)
#' data(fp16)
#' winners <- fp16 %>% filter(Elected == "Y")
#' data(nat_data16)
#' nat_data16$DivisionNm <- toupper(nat_data16$elect_div)
#' nat_data16 <- nat_data16 %>% left_join(winners, by = "DivisionNm")
#' ggplot(data=nat_map16) + 
#' geom_polygon(aes(x=long, y=lat, group=group, order=order), fill="grey90", colour="white") +
#' geom_point(data=nat_data16, aes(x=x, y=y, colour=PartyNm), size=1.5, alpha=0.8) +
#' scale_colour_manual(name="Political Party", values=partycolours) +
#' theme_map + coord_equal() + theme(legend.position="bottom")
"nat_data16"

#' Data of the Australian Electorates from 2013
#'
#' A dataset containing some demographic information for each of the 150 Australian electorates.
#' The data were obtained from the Australian Electoral Commission, and downloaded 
#' from \url{http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
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
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
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
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
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
#' from \url{http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2923.0.30.0012006?OpenDocument}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
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
#' from \url{https://data.gov.au/dataset/ds-dga-0b939a62-e53e-4616-add5-77f909b58ddd/details?q=asgc%202001}.
#' The data is published 
#' @format A data frame with 150 rows with the following variables:
#' \itemize{
#'     \item id: numeric identifier that links the electorate with the corresponding polygon in `nat_map`.
#'     \item elect_div: Electorate division name   
#'     \item state: abbreviation of the state name
#'     \item long_c: longitude coordinate of electorate (polygon) centroid
#'     \item lat_c: latitude coordinate of electorate (polygon) centroid
#'     \item x: latitude coordinate for plotting a cartogram
#'     \item y: longitude coordinate for plotting a cartogram
#'     \item radius: variable used in the construction of cartogram points
#' }
"nat_data01"

