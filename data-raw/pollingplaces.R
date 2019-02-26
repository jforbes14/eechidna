# Polling place locations and results

# For 2001 election data, download the folder in the link: https://www.aec.gov.au/About_AEC/Publications/statistics/files/aec-2001-election-statistics.zip
# Change the directory in this code as required (2001 section only).

# -------------------------------------

library(tidyverse)
# Latest version of ggmap from github
# install_github("https://github.com/dkahle/ggmap/")
library(ggmap)

# -------------------------------------

# 2016

pollplace_16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/GeneralPollingPlacesDownload-20499.csv", skip = 1)

# 2013

pollplace_13 <- read_csv("http://results.aec.gov.au/17496/Website/Downloads/GeneralPollingPlacesDownload-17496.csv", skip=1)

# 2010

pollplace_10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/GeneralPollingPlacesDownload-15508.csv", skip = 1)

# 2007

pollplace_07 <- read_csv("https://results.aec.gov.au/13745/website/Downloads/GeneralPollingPlacesDownload-13745.csv", skip = 1)

# 2004
# Doesn't have lat and long but if IDs and name match other years, it is the same location

pollplace_04_blank <- read_csv("https://results.aec.gov.au/12246/results/Downloads/GeneralPollingPlacesDownload-12246.csv", skip = 1) %>% 
  left_join(pollplace_07 %>% select(PollingPlaceID, Latitude, Longitude, PollingPlaceNm), by = c("PollingPlaceNm", "PollingPlaceID"))
    
add1 <- left_join(pollplace_04_blank %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_07 %>% select(PollingPlaceNm, PremisesNm, PremisesPostCode, State, Latitude, Longitude), by = c("PremisesNm","PollingPlaceNm", "PremisesPostCode", "State"))

add2 <- left_join(add1 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_10 %>% select(PollingPlaceID, PollingPlaceNm, Latitude, Longitude), by = c("PollingPlaceNm", "PollingPlaceID"))

add3 <- left_join(add2 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_10 %>% select(PollingPlaceNm, PremisesNm, PremisesPostCode, Latitude, Longitude), by = c("PremisesNm", "PremisesPostCode", "PollingPlaceNm"))

add4 <- left_join(add3 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_13 %>% select(PollingPlaceID, PollingPlaceNm, Latitude, Longitude), by = c("PollingPlaceNm", "PollingPlaceID"))

add5 <- left_join(add4 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_13 %>% select(PollingPlaceNm, PremisesNm, PremisesPostCode, Latitude, Longitude), by = c("PremisesNm", "PremisesPostCode", "PollingPlaceNm"))

add6 <- left_join(add5 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_16 %>% select(PollingPlaceID, PollingPlaceNm, Latitude, Longitude), by = c("PollingPlaceNm", "PollingPlaceID"))

add7 <- left_join(add6 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  pollplace_16 %>% select(PollingPlaceNm, PremisesNm, PremisesPostCode, Latitude, Longitude), by = c("PremisesNm", "PremisesPostCode", "PollingPlaceNm"))

# Google Maps to get remaining geocodes

get_geos <- add7 %>% 
  filter(is.na(Latitude)) %>% 
  mutate(address = gsub(" NA ", " ", paste(PremisesNm, PremisesAddress1, PremisesAddress2, 
    PremisesAddress3, PremisesSuburb, PremisesStateAb, PremisesPostCode, "AUSTRALIA"))) %>% 
  mutate_geocode(address) %>% 
  rename(Latitude = lat, Longitude = lon)

get_geos <- get_geos %>% 
  rename(Latitude = lat, Longitude = lon)

# Now combine into (almost) complete dataset

pollplace_04 <- pollplace_04_blank %>% filter(!is.na(Longitude)) %>% 
  bind_rows(add1 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add2 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add3 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add4 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add5 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add6 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add7 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(get_geos) %>% 
  select(-address)

# Export

#write_csv(pollplace_04, "PollingBooth2004GeoCodes.csv")

# -------------------------------------

# Function to group parties into larger parties and other
group_parties <- function(df, PartyAb = PartyAb) {
  out <- df %>% 
    mutate(PartyAb = ifelse(
      PartyAb %in% c("CLP", "LP", "LNP", "NP"), "LNP", 
      ifelse(PartyAb == "ALP", "ALP",
        ifelse(PartyAb == "IND", "IND", 
          ifelse(PartyAb == "GRN", "GRN",
            ifelse(PartyAb %in% c("HAN","ON"), "ON",
              "Other"))))))
  return(out)
}

# Function to re-label parties so that names are common
relabel_parties <- function(df, PartyNm = PartyNm) {
  out <- df %>% 
    mutate(PartyNm = ifelse(
      PartyNm %in% c("Australian Labor Party (Northern Territory) Branch", "Australian Labor Party (ACT Branch)", "Labor"), "Australian Labor Party",
      ifelse(PartyNm %in% c("Country Liberals (NT)", "Liberal National Party of Queensland", "The Nationals", "National Party"), "Liberal", 
        ifelse(PartyNm %in% c("The Greens (WA)"), "The Greens", 
          ifelse(is.na(PartyNm), "Independent", PartyNm
          )))))
  return(out)
}

# Function to reabbreviate parties
    
reabbrev_parties <- function(df, PartyNm = PartyNm) {
      out <- df %>%
    mutate(PartyAb = ifelse(PartyAb %in% c("CLR", "ALP"), "ALP", 
      ifelse(PartyAb %in% c("CLP", "LP", "LNP", "NP"), "LNP", 
        ifelse(PartyAb %in% c("GRN", "GWA", "TG"), "GRN", 
          ifelse(PartyAb %in% c("HAN","ON"), "ON",
            ifelse(is.na(PartyAb), "INFL", 
              PartyAb))))))
  return(out)
}

# Make all character fields upper case
chr_upper <- function(df) {
  cols <- sapply(df, class) == 'character'
  df[, cols] <- lapply(df[, cols], toupper)
  return(df)
}

# -------------------------------------

# Download polling place division of preferences, two party preferred and two candidate preferred (where available)
# In long format, where each candidate has their own row. Alternative is wide format with code in next section.

# ------------------------------------------------------------------------------------------

# 2016

tcp_pp16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseTcpByCandidateByPollingPlaceDownload-20499.csv", skip = 1) %>% 
  relabel_parties() %>% reabbrev_parties() %>% chr_upper()

tpp_pp16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseTppByPollingPlaceDownload-20499.csv", skip = 1) %>%
  rename(LNP_Votes = `Liberal/National Coalition Votes`,
    LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`,
    ALP_Percent = `Australian Labor Party Percentage`) %>% 
  chr_upper()

fp_pp16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-NSW.csv", skip = 1) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-VIC.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-QLD.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-SA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-TAS.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-WA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-NT.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-20499-ACT.csv", skip = 1)) %>% 
  relabel_parties() %>% reabbrev_parties()  %>% 
  chr_upper()

# ------------------------------------------------------------------------------------------

# 2013

tcp_pp13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseTcpByCandidateByPollingPlaceDownload-17496.csv", skip = 1) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper() 

tpp_pp13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseTppByPollingPlaceDownload-17496.csv", skip = 1) %>%
  rename(LNP_Votes = `Liberal/National Coalition Votes`,
    LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`,
    ALP_Percent = `Australian Labor Party Percentage`) %>% 
  chr_upper()

fp_pp13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-NSW.csv", skip = 1) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-VIC.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-QLD.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-SA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-TAS.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-WA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-NT.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-17496-ACT.csv", skip = 1))  %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper() 

# ------------------------------------------------------------------------------------------

# 2010

tcp_pp10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseTcpByCandidateByPollingPlaceDownload-15508.csv", skip = 1) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper() 

tpp_pp10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseTppByPollingPlaceDownload-15508.csv", skip = 1) %>%
  rename(LNP_Votes = `Liberal/National Coalition Votes`,
    LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`,
    ALP_Percent = `Australian Labor Party Percentage`) %>% 
  chr_upper()

fp_pp10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-NSW.csv", skip = 1) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-VIC.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-QLD.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-SA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-TAS.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-WA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-NT.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-15508-ACT.csv", skip = 1)) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper() 

# ------------------------------------------------------------------------------------------

# 2007

tcp_pp07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseTcpByCandidateByPollingPlaceDownload-13745.csv", skip = 1) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper() 

tpp_pp07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseTppByPollingPlaceDownload-13745.csv", skip = 1) %>%
  rename(LNP_Votes = `Liberal/National Coalition Votes`,
    LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`,
    ALP_Percent = `Australian Labor Party Percentage`) %>% 
  chr_upper()

fp_pp07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-NSW.csv", skip = 1) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-VIC.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-QLD.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-SA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-TAS.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-WA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-NT.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-13745-ACT.csv", skip = 1)) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  chr_upper()

# ------------------------------------------------------------------------------------------

# 2004

tcp_pp04 <- read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseTcpByCandidateByPollingPlaceDownload-12246.csv", skip = 1) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  mutate(Elected = ifelse(is.na(SittingMemberFl), "N", "Y")) %>% 
  select(-SittingMemberFl) %>% 
  chr_upper()

tpp_pp04 <- read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseTppByPollingPlaceDownload-12246.csv", skip = 1) %>%
  rename(LNP_Votes = `Liberal/National Coalition Votes`,
    LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`,
    ALP_Percent = `Australian Labor Party Percentage`) %>% 
  chr_upper()

fp_pp04 <- read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-NSW.csv", skip = 1) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-VIC.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-QLD.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-SA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-TAS.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-WA.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-NT.csv", skip = 1)) %>% 
  bind_rows(read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseStateFirstPrefsByPollingPlaceDownload-12246-ACT.csv", skip = 1)) %>% 
  relabel_parties() %>% reabbrev_parties() %>% 
  mutate(Elected = ifelse(is.na(SittingMemberFl), "N", "Y")) %>% 
  select(-SittingMemberFl) %>% 
  chr_upper()

# ------------------------------------------------------------------------------------------

# 2001

# Get locations of polling places (extract address from first preferences)

votes <- read_delim("data-raw/results_pollingplace_table(/hppdop.txt", delim = ";")
candidates <- read_delim("data-raw/results_pollingplace_2001/hcands.txt", delim = ";")

all <- left_join(votes, candidates, by = c("State", "Division", "Ballot Position"))

firstpref <- all %>% 
  filter(Count == 1) %>% 
  dplyr::select(-c(`Elected Swing`, `Exhausted Transfer`, Exhausted, `Vote Percent`, Swing, Vote.y, `Vote Distributed`, Count)) %>% 
  mutate(PollingPlace = gsub("\\s*\\([^\\)]+\\)","",as.character(`Polling Place`) %>% toupper()),
    PollingPlaceBracket = `Polling Place` %>% toupper(),
    Division = toupper(Division),
    Elected = ifelse(is.na(Member), "N", "Y")) %>% 
  rename(Vote = Vote.x, StateAb = State, DivisionNm = Division)

# Get coordinates from other years
# PollingPlace format varies across years

locations <- firstpref %>% 
  select(PollingPlace, PollingPlaceBracket, DivisionNm, StateAb) %>% 
  group_by(PollingPlace, PollingPlaceBracket, DivisionNm, StateAb) %>% 
  unique() %>% 
  ungroup()

pollplace_01_start <- locations %>% left_join(
  fp_pp04 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(),
  by = c("StateAb", "DivisionNm", "PollingPlaceBracket" = "PollingPlace"))

add1 <- left_join(pollplace_01_start %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  fp_pp07 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(), by = c("StateAb", "DivisionNm", "PollingPlaceBracket" = "PollingPlace"))

add2 <- left_join(add1 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  fp_pp10 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(), by = c("StateAb", "DivisionNm", "PollingPlaceBracket" = "PollingPlace"))

add3 <- left_join(add2 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  fp_pp13 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(), by = c("StateAb", "DivisionNm", "PollingPlace"))

add4 <- left_join(add3 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)),
  fp_pp16 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(), by = c("StateAb", "DivisionNm", "PollingPlace"))

# Checking for matches with PPVC suffix

add_ppvc <- add4 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)) %>% 
  mutate(address = paste(PollingPlace, DivisionNm, StateAb, "AUSTRALIA"),
    match = paste(PollingPlace, DivisionNm, "PPVC")) %>%
  unique()

add5 <- left_join(add_ppvc, fp_pp10 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(),
  by = c("StateAb", "DivisionNm", "match" = "PollingPlace"))

add6 <- left_join(add5 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)), 
  fp_pp13 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(),
  by = c("StateAb", "DivisionNm", "match" = "PollingPlace"))

add7 <- left_join(add6 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)), 
  fp_pp16 %>% select(PollingPlace, DivisionNm, StateAb, Latitude, Longitude) %>% unique(),
  by = c("StateAb", "DivisionNm", "match" = "PollingPlace"))

# Remaining, excluding special votes

remain <- add7 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)) %>% 
  filter(!PollingPlace %in% c("ABSENT", "POSTAL", "PRE POLL", "PROVISIONAL", "DIVISION SUMMARY"),
    !grepl("SPECIAL", PollingPlace)) %>%
  mutate(address = paste(PollingPlace, StateAb, "AUSTRALIA")) 

special_votes <- add7 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)) %>% 
  filter(PollingPlace %in% c("ABSENT", "POSTAL", "PRE POLL", "PROVISIONAL", "DIVISION SUMMARY"))

special_place <- add7 %>% filter(is.na(Longitude)) %>% select(-c(Longitude, Latitude)) %>% 
  filter(grepl("SPECIAL", PollingPlace))

# ------------------------------------------------------------------------------------------

# Google Maps API to get the remaining polling place locations
# You need to have an API from a Google cloud account (can get 12 month trial for free)
# https://cloud.google.com/maps-platform/
# Ensure you have the latest ggmap version from github

# Enter your 
register_google(key = "YOUR-API-KEY-GOES-HERE")

# Search for geocodes
# This is imperfect - the remaining 930 polling places may not be accurate
remain <- remain %>% 
  mutate_geocode(address) %>% 
  rename(Latitude = lat, Longitude = lon)

my_geos <- data.frame(Longitude = remain$Longitude, Latitude = remain$Latitude)

# Combine

pollplace_01 <- pollplace_01_start %>% filter(!is.na(Longitude)) %>% 
  bind_rows(add1 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add2 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add3 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add4 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add5 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add6 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(add7 %>% filter(!is.na(Longitude))) %>% 
  bind_rows(remain %>% filter(!is.na(Longitude))) %>% 
  bind_rows(special_votes) %>% bind_rows(special_place) %>% 
  select(-c(address, match, PollingPlaceBracket))

# First preference

fp_pp01 <- firstpref %>% 
  left_join(pollplace_01, by = c("StateAb", "PollingPlace", "DivisionNm")) %>% 
  separate(Candidate, c("Surname", "GivenNm"), ", ") %>% 
  mutate(GivenNm = toupper(GivenNm)) %>% 
  rename(BallotPosition = `Ballot Position`, OrdinaryVotes = Vote, PartyAb = Party) %>% 
  select(StateAb,  DivisionNm, PollingPlace, Surname, GivenNm, BallotPosition, PartyAb, Elected, OrdinaryVotes, Latitude, Longitude)

# Two party preferred

tpp_pp01 <- read_delim("data-raw/results_pollingplace_2001/htppbypp.txt", delim = ";") %>% 
  mutate(DivisionNm = toupper(Division), 
    PollingPlace = gsub("\\s*\\([^\\)]+\\)", "", as.character(`Polling Place`) %>% toupper())) %>% 
  select(-c(Division, `Polling Place`)) %>% 
  left_join(pollplace_01, by = c("PollingPlace", "DivisionNm")) %>% 
  rename(ALP_Votes = `ALP TPP Vote`, LNP_Votes = `Coalition TPP Vote`, 
    ALP_Percent = `ALP TPP Pc`, Swing = `ALP Swing`) %>% 
  mutate(TotalVotes = ALP_Votes + LNP_Votes, LNP_Percent = 100 - ALP_Percent) %>% 
  select(StateAb, DivisionNm, PollingPlace, LNP_Votes, LNP_Percent, ALP_Votes, 
    ALP_Percent, TotalVotes, Swing, Latitude, Longitude)

# -------------------------------------

# Adding locations of polling places

fp_pp16 <- fp_pp16 %>% 
  left_join(pollplace_16 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tcp_pp16 <- tcp_pp16 %>% 
  left_join(pollplace_16 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tpp_pp16 <- tpp_pp16 %>% 
  left_join(pollplace_16 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")

fp_pp13 <- fp_pp13 %>% 
  left_join(pollplace_13 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tcp_pp13 <- tcp_pp13 %>% 
  left_join(pollplace_13 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tpp_pp13 <- tpp_pp13 %>% 
  left_join(pollplace_13 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")

fp_pp10 <- fp_pp10 %>% 
  left_join(pollplace_10 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tcp_pp10 <- tcp_pp10 %>% 
  left_join(pollplace_10 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tpp_pp10 <- tpp_pp10 %>% 
  left_join(pollplace_10 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")

fp_pp07 <- fp_pp07 %>% 
  left_join(pollplace_07 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tcp_pp07 <- tcp_pp07 %>% 
  left_join(pollplace_07 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tpp_pp07 <- tpp_pp07 %>% 
  left_join(pollplace_07 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")

fp_pp04 <- fp_pp04 %>% 
  left_join(pollplace_04 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tcp_pp04 <- tcp_pp04 %>% 
  left_join(pollplace_04 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")
tpp_pp04 <- tpp_pp04 %>% 
  left_join(pollplace_04 %>% select(PollingPlaceID, PremisesPostCode, Latitude, Longitude), by = "PollingPlaceID")

# --------------------------------------------------------------------------------------------------

# Still many NA coordinates, so for those that are NA, try to match PollingPlace (and State) with any from other years

# Get polling places via two party preferred
tpp_pp_all <- dplyr::bind_rows(tpp_pp01 %>% mutate(year = 2001),
  tpp_pp04 %>% mutate(year = 2004),
  tpp_pp07 %>% mutate(year = 2007),
  tpp_pp10 %>% mutate(year = 2010),
  tpp_pp13 %>% mutate(year = 2013),
  tpp_pp16 %>% mutate(year = 2016)
)

# Add coordinates for any NA that have an address in a different year
tpp_nocord <- tpp_pp_all %>% 
  filter(is.na(Latitude)) %>%
  mutate(PollingPlace = toupper(PollingPlace)) %>% 
  select(-c(Latitude, Longitude))

all_cord <- tpp_pp_all %>% 
  filter(!is.na(Latitude)) %>% 
  select(PollingPlace, StateAb, year, Latitude, Longitude) %>% 
  mutate(PollingPlace = toupper(PollingPlace)) %>% 
  group_by(PollingPlace, StateAb) %>% 
  arrange(-year) %>% 
  filter(row_number(year) == 1) %>% 
  select(-year)

tpp_nocord_filled <- left_join(tpp_nocord, all_cord, by = c("PollingPlace", "StateAb"))

tpp_pp <- tpp_pp_all %>% 
  filter(!is.na(Latitude)) %>% 
  bind_rows(tpp_nocord_filled)

# First preferences
fp_pp_all <- dplyr::bind_rows(fp_pp01 %>% mutate(year = 2001),
  fp_pp04 %>% mutate(year = 2004),
  fp_pp07 %>% mutate(year = 2007),
  fp_pp10 %>% mutate(year = 2010),
  fp_pp13 %>% mutate(year = 2013),
  fp_pp16 %>% mutate(year = 2016)
)

fp_nocord <- fp_pp_all %>% 
  filter(is.na(Latitude)) %>%
  mutate(PollingPlace = toupper(PollingPlace)) %>% 
  select(-c(Latitude, Longitude))

fp_nocord_filled <- left_join(fp_nocord, all_cord, by = c("PollingPlace", "StateAb"))

fp_pp <- fp_pp_all %>% 
  filter(!is.na(Latitude)) %>% 
  bind_rows(fp_nocord_filled) %>% 
  ungroup()


# Two candidate preferences
tcp_pp_all <- dplyr::bind_rows(
  tcp_pp04 %>% mutate(year = 2004),
  tcp_pp07 %>% mutate(year = 2007),
  tcp_pp10 %>% mutate(year = 2010),
  tcp_pp13 %>% mutate(year = 2013),
  tcp_pp16 %>% mutate(year = 2016)
)

tcp_nocord <- tcp_pp_all %>% 
  filter(is.na(Latitude)) %>%
  mutate(PollingPlace = toupper(PollingPlace)) %>% 
  select(-c(Latitude, Longitude)) %>% 
  ungroup()

tcp_nocord_filled <- left_join(tcp_nocord, all_cord, by = c("PollingPlace", "StateAb"))

tcp_pp <- tcp_pp_all %>% 
  filter(!is.na(Latitude)) %>% 
  bind_rows(tcp_nocord_filled) %>% 
  ungroup()


# --------------------------------------------------------------------------------

# Save
save(fp_pp, file = "extra-data/fp_pp.rda")
save(tcp_pp, file = "extra-data/tcp_pp.rda")
save(tpp_pp, file = "extra-data/tpp_pp.rda")
