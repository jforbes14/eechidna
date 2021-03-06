% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{fp01}
\alias{fp01}
\alias{fp04}
\alias{fp07}
\alias{fp10}
\alias{fp13}
\alias{fp16}
\alias{fp19}
\title{First preference votes for candidates (House of Representatives) in each electorate.}
\format{
A data frame with the following variables:

\strong{For the 2001 election only:}

\itemize{
    \item UniqueID: Numeric identifier that links the electoral division with Census  
    and other election datasets.
    \item StateAb: Abbreviation for state name  
    \item DivisionNm:  Electoral division name   
    \item Surname: Candidate surname          
    \item GivenNm: Candidate given name            
    \item PartyAb: Abbreviation for political party name           
    \item PartyNm: Political party name      
    \item Elected: Whether the candidate was elected (Y/N)            
    \item Percent: Percentage of ordinary votes for the candidate     
    }

\strong{For the 2004 election onwards:}

\itemize{
\item StateAb: Abbreviation for state name
\item UniqueID: Numeric identifier that links the electoral division with Census
and other election datasets.
\item DivisionNm:  Electoral division name
\item BallotPosition: Candidate's position on the ballot
\item CandidateID: Candidate ID
\item Surname: Candidate surname
\item GivenNm: Candidate given name
\item PartyAb: Abbreviation for political party name
\item PartyNm: Political party name
\item Elected: Whether the candidate was elected (Y/N)
\item OrdinaryVotes: Number of ordinary votes cast at the electorate for the candidate
\item Percent: Percentage of ordinary votes for the candidate
}

{}

{}

{}

{}


}
\source{
\url{https://www.aec.gov.au/About_AEC/Publications/statistics/files/aec-2001-election-statistics.zip}

\url{https://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-csv.htm}

\url{https://www.aec.gov.au/elections/federal_elections/2004/downloads.htm}

\url{https://results.aec.gov.au/13745/Website/HouseDownloadsMenu-13745-csv.htm}

\url{https://www.aec.gov.au/elections/federal_elections/2007/downloads.htm}

\url{https://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm}

\url{https://www.aec.gov.au/elections/federal_elections/2010/downloads.htm}

\url{https://results.aec.gov.au/17496/Website/HouseDownloadsMenu-17496-csv.htm}

\url{https://www.aec.gov.au/elections/federal_elections/2013/downloads.htm}

\url{https://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-csv.htm}

\url{https://www.aec.gov.au/elections/federal_elections/2016/downloads.htm}

\url{https://results.aec.gov.au/24310/Website/HouseDownloadsMenu-24310-Csv.htm}
}
\usage{
fp01

fp04

fp07

fp10

fp13

fp16

fp19
}
\description{
A dataset containing first preference vote counts, candidate names, and other results for the
House of Representatives from Australian federal elections from 2001 to 2019.
}
\keyword{datasets}
