## Importing federal election results for 2010, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)
## Download from: http://results.aec.gov.au/15508/Website/HouseDownloadsMenu-15508-csv.htm

library(tidyverse)

#--- FIRST PREFERENCES ---#

pref10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseDopByDivisionDownload-15508.csv", skip = 1)

fp10 <- pref10 %>% 
  filter(CalculationType %in% c("Preference Count", "Preference Percent")) %>% 
  group_by(StateAb, DivisionID, DivisionNm, CountNumber, BallotPosition, CandidateID, Surname, GivenNm, PartyAb, PartyNm, Elected, HistoricElected) %>% 
  spread(key = CalculationType, value = CalculationValue) %>%
  filter(CountNumber == 0) %>% 
  ungroup() %>% 
  select(-CountNumber) %>% #takes only % of first preference votes
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`)


#--- TWO CANDIDATE PREFERRED ---#
# Distribution of preferences to the two candidates who came first and second in the election
tcp10 <- pref10 %>% 
  group_by(DivisionID, PartyAb) %>%
  filter(CountNumber == max(CountNumber), CalculationType %in% c("Preference Count", "Preference Percent")) %>%
  arrange() %>%
  filter(CalculationValue != 0) %>% 
  spread(CalculationType, CalculationValue) %>% 
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`) %>% 
  select(-CountNumber) %>% 
  mutate(Elected = ifelse(is.na(SittingMemberFl), "N", "Y")) %>% 
  select(-SittingMemberFl)




#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseTppByDivisionDownload-15508.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)




#---- COUNT VOTES PER ELECTORATE ----
#votes10 <- pref10[seq(1, nrow(pref13), 4), ] %>%
#  filter(CountNumber == 0) %>% #takes number of first preferences
#  group_by(StateAb, DivisionID, DivisionNm) %>%
#  summarise(TotalVotes10 = sum(CalculationValue))
#votes10$DivisionNm <- toupper(votes10$DivisionNm)


#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp10$DivisionNm <- toupper(fp10$DivisionNm)
tcp10$DivisionNm <- toupper(tcp10$DivisionNm)
tpp10$DivisionNm <- toupper(tpp10$DivisionNm)


#---- RELABEL PARTY NAMES ----

# Function in aec2016.R

# Apply

fp10 <- fp10 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp10 <- tcp10 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp10, file = "Clean/fp10.rda")
save(tpp10, file = "Clean/tpp10.rda")
save(tcp10, file = "Clean/tcp10.rda")