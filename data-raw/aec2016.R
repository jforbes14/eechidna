## Importing federal election results for 2016, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)
## Download from: http://results.aec.gov.au/20499/Website/HouseDownloadsMenu-20499-Csv.htm

library(tidyverse)

#---- FIRST PREFERENCES ----
pref16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseDopByDivisionDownload-20499.csv", skip = 1)

fp16 <- pref16 %>% 
  filter(CalculationType %in% c("Preference Count", "Preference Percent")) %>% 
  group_by(StateAb, DivisionID, DivisionNm, CountNumber, BallotPosition, CandidateID, Surname, GivenNm, PartyAb, PartyNm, Elected, HistoricElected) %>% 
  spread(key = CalculationType, value = CalculationValue) %>%
  filter(CountNumber == 0) %>% 
  ungroup() %>% 
  select(-CountNumber) %>% #takes only % of first preference votes
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`)


#---- TWO CANDIDATE PREFERRED ----
# Distribution of preferences to the two candidates who came first and second in the election
# add here total votes as well
tcp16 <- pref16 %>% 
  group_by(DivisionID, PartyAb) %>%
  filter(CountNumber == max(CountNumber), CalculationType %in% c("Preference Count", "Preference Percent")) %>%
  arrange() %>%
  filter(CalculationValue != 0) %>% 
  spread(CalculationType, CalculationValue) %>% 
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`) %>% 
  select(-CountNumber) %>% 
  mutate(Elected = ifelse(is.na(SittingMemberFl), "N", "Y")) %>% 
  select(-SittingMemberFl)


#---- TWO PARTY PREFERRED ----
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseTppByDivisionDownload-20499.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


#---- Test that votes tally 100% ----
#test <- fp16 %>%
#  group_by(DivisionID) %>%
#  summarize(percentage = sum(CalculationValue))



#---- COUNT VOTES PER ELECTORATE ----
#votes16 <- pref16[seq(1, nrow(pref16), 4), ] %>%
#  filter(CountNumber == 0) %>% #takes number of first preferences
#  group_by(StateAb, DivisionID, DivisionNm) %>%
#  summarise(TotalVotes16 = sum(CalculationValue))
#votes16$DivisionNm <- toupper(votes16$DivisionNm)



#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp16$DivisionNm <- toupper(fp16$DivisionNm)
tcp16$DivisionNm <- toupper(tcp16$DivisionNm)
tpp16$DivisionNm <- toupper(tpp16$DivisionNm)


#---- FIX NAMES AND ABBREVATIONS OF PARTIES

# Function to re-label parties so that names are common
relabel_parties <- function(df, PartyNm = PartyNm) {
  out <- df %>% 
    ungroup %>% 
    mutate(PartyNm = ifelse(
      PartyNm %in% c("Australian Labor Party (Northern Territory) Branch",  "Labor"), "Australian Labor Party",
      ifelse(PartyNm %in% c("Country Liberals (NT)", "Liberal National Party of Queensland", "The Nationals", "National Party"), "Liberal", 
        ifelse(PartyNm %in% c("The Greens (WA)"), "The Greens", 
          ifelse(PartyNm %in% c(""), "Informal", 
            ifelse(is.na(PartyNm), "Independent", PartyNm
        ))))))
  return(out)
}

# Function to reabbreviate parties

reabbrev_parties <- function(df, PartyNm = PartyNm) {
  out <- df %>%
    ungroup %>% 
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
  fc_cols <- sapply(df, class) == 'factor'
  df[, fc_cols] <- lapply(df[, fc_cols], as.character)
  
  ch_cols <- sapply(df, class) == 'character'
  df[, ch_cols] <- lapply(df[, ch_cols], toupper)
  return(df)
}

# Apply

fp16 <- fp16 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp16 <- tcp16 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp16, file = "Clean/fp16.rda")
save(tpp16, file = "Clean/tpp16.rda")
save(tcp16, file = "Clean/tcp16.rda")
