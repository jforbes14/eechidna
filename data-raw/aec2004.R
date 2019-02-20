## Importing federal election results for 2004, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)
## Download from: http://results.aec.gov.au/12246/results/HouseDownloadsMenu-12246-Csv.htm

library(tidyverse)

#--- FIRST PREFERENCES ---#

pref04 <- read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseDopByDivisionDownload-12246.csv", skip = 1)

pref04 %>% 
  group_by(DivisionNm) %>% 
  filter(CountNumber == max(CountNumber)) %>% 
  filter(CalculationType == "Preference Percent") 

fp04 <- pref04 %>% 
  filter(CalculationType %in% c("Preference Count", "Preference Percent")) %>% 
  mutate(Elected = ifelse(is.na(SittingMemberFl), "N", "Y")) %>% 
  select(-SittingMemberFl) %>% 
  group_by(StateAb, DivisionID, DivisionNm, CountNumber, BallotPosition, CandidateID, Surname, GivenNm, PartyAb, PartyNm, Elected) %>% 
  spread(key = CalculationType, value = CalculationValue) %>%
  filter(CountNumber == 0) %>% 
  ungroup() %>% 
  select(-CountNumber) %>% #takes only % of first preference votes
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`)


#--- TWO CANDIDATE PREFERRED ---#
# Distribution of preferences to the two candidates who came first and second in the election
tcp04 <- pref04 %>% 
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

tpp04 <- read_csv("https://results.aec.gov.au/12246/results/Downloads/HouseTppByDivisionDownload-12246.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)




#---- COUNT VOTES PER ELECTORATE ----
#votes04 <- pref04[seq(1, nrow(pref04), 4), ] %>%
#  filter(CountNumber == 0) %>% #takes number of first preferences
#  group_by(StateAb, DivisionID, DivisionNm) %>%
#  summarise(TotalVotes04 = sum(CalculationValue))
#votes04$DivisionNm <- toupper(votes04$DivisionNm)


#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp04$DivisionNm <- toupper(fp04$DivisionNm)
tcp04$DivisionNm <- toupper(tcp04$DivisionNm)
tpp04$DivisionNm <- toupper(tpp04$DivisionNm)


#---- RELABEL PARTY NAMES ----

# Function in aec2016.R

# Apply

fp04 <- fp04 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp04 <- tcp04 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tpp04 <- tpp04 %>% chr_upper()

#---- SAVE ----
save(fp04, file = "Clean/fp04.rda")
save(tpp04, file = "Clean/tpp04.rda")
save(tcp04, file = "Clean/tcp04.rda")
