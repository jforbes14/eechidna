# This script, when run, builds all electorate level voting data for the six Australian federal elections between 2001 and 2016.

library(readxl)
library(tidyverse)


# ---------------------------------------------------------------------------------------------------------

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

# Function to make all character fields upper case
chr_upper <- function(df) {
  fc_cols <- sapply(df, class) == 'factor'
  df[, fc_cols] <- lapply(df[, fc_cols], as.character)
  
  ch_cols <- sapply(df, class) == 'character'
  df[, ch_cols] <- lapply(df[, ch_cols], toupper)
  return(df)
}

# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2001
####################################################################################################

## Importing federal election results for 2001, and forming a dataframe for each vote count
## Vote counts are: first preference and two party preferred (2pp)
## Cannot be directly downloaded, but available on request from Australian Electoral Commission via email.
## Files are titled "DOP_(StateAb).xls", for example: "DOP_VIC.xls"

## One minor change made to raw files, so that they can be read in properly
## ACT, NSW, SA & NT adjusted so all candidate names in the same column as "Votes"
## VIC, WA, QLD & TAS adjusted so all candidate names in the same column as "%"

#--- FIRST PREFERENCES ---#
# Loop over each state (j), and each division within the state (i)
states = c("ACT","NSW","SA","NT","TAS","VIC","QLD","WA")

fp01 <- data.frame(StateAb = 0, DivisionNm = 0, Surname = 0, GivenNm = 0, PartyAb = 0, Elected = 0, CalculationValue = 0)


#For ACT, NSW, SA and NT
for (j in 1:(length(states) - 4)) {
  state_name = states[j]
  xls_ref <- paste0("data-raw/House-Dop-Division-2001/DOP_", state_name, ".xls")
  pref01_temp <- read_xls(xls_ref)
  count_rows <- as.data.frame(which(pref01_temp == "Count", arr.ind=TRUE))
  n_divisions <- nrow(count_rows)
  row_div_id <- count_rows[,1] - 4 #where divisions are stored
  row_surname <- count_rows[,1] - 3 #surnames
  row_firstname <- count_rows[,1] - 2 #first names
  row_party <- count_rows[,1] - 1 #party
  row_votes <- count_rows[,1] + 1 #FIRST
  col_vals <- as.data.frame(which(pref01_temp == "Votes", arr.ind=TRUE))
  
  #Loop over i = divisions, to generate one row for each candidate
  for (i in 1:n_divisions) {
    locate = sort(unique(col_vals$row))[i]
    
    divname = toupper(pref01_temp[row_div_id,1][[1]][i])
    
    surnames = toupper(pref01_temp[row_surname[i],col_vals[col_vals$row == locate,2]]) #is a tibble of the names
    firstnames = toupper(pref01_temp[row_firstname[i],col_vals[col_vals$row == locate,2]])
    partyabrev = toupper(pref01_temp[row_party[i],col_vals[col_vals$row == locate,2]])
    votes <- pref01_temp[row_votes[i],as.logical(!is.na(pref01_temp[row_votes[i],]))][-1]
    votes <- as.numeric(votes[seq(2,length(votes),2)])
    
    temp <- data.frame(StateAb = rep(state_name,length(partyabrev)), DivisionNm = rep(divname,length(partyabrev)), Surname = surnames, GivenNm = firstnames, PartyAb = partyabrev, Elected = ifelse(votes == max(votes), "Y", "N"), CalculationValue = votes)
    fp01 <- rbind(fp01,temp)
  }
  
}

#For TAS, VIC, QLD, WA
for (j in (length(states)-3):length(states)) {
  state_name = states[j]
  xls_ref <- paste0("data-raw/House-Dop-Division-2001/DOP_", state_name, ".xls")
  pref01_temp <- read_xls(xls_ref)
  count_rows <- as.data.frame(which(pref01_temp == "Count", arr.ind=TRUE))
  n_divisions <- nrow(count_rows)
  row_div_id <- count_rows[,1] - 4 #where divisions are stored
  row_surname <- count_rows[,1] - 3 #surnames
  row_firstname <- count_rows[,1] - 2 #first names
  row_party <- count_rows[,1] - 1 #party
  row_votes <- count_rows[,1] + 1 #FIRST
  col_vals <- as.data.frame(which(pref01_temp == "%", arr.ind=TRUE))
  
  #Loop over i = divisions, to generate one row for each candidate
  
  for (i in 1:n_divisions) {
    locate = sort(unique(col_vals$row))[i]
    
    divname = toupper(pref01_temp[row_div_id,1][[1]][i])
    
    surnames = toupper(pref01_temp[row_surname[i],col_vals[col_vals$row == locate,2]]) #is a tibble of the names
    firstnames = toupper(pref01_temp[row_firstname[i],col_vals[col_vals$row == locate,2]])
    partyabrev = toupper(pref01_temp[row_party[i],col_vals[col_vals$row == locate,2]])
    votes <- pref01_temp[row_votes[i],as.logical(!is.na(pref01_temp[row_votes[i],]))][-1]
    votes <- as.numeric(votes[seq(2,length(votes),2)])
    
    temp <- data.frame(StateAb = rep(state_name,length(partyabrev)), DivisionNm = rep(divname,length(partyabrev)), Surname = surnames, GivenNm = firstnames, PartyAb = partyabrev, Elected = ifelse(votes == max(votes), "Y", "N"), CalculationValue = votes)
    fp01 <- rbind(fp01,temp)
  }
  
}

#Remove first row of zeros, and reset rownames
fp01 <- fp01[-1,]
rownames(fp01) <- 1:nrow(fp01)

#Now to fix PartyAb and replace NA with IND
fp01$PartyAb <- substring(fp01$PartyAb, 2, nchar(fp01$PartyAb)-1)
fp01$PartyAb[is.na(fp01$PartyAb)] <- "IND"

# Rename
fp01 <- fp01 %>% rename(Percent = CalculationValue)



#--- TWO CANDIDATE PREFERRED ---#
# Distribution of preferences to the two candidates who came first and second in the election

# Loop over each state (j), and each division within the state (i)
states = c("ACT","NSW","SA","NT","TAS","VIC","QLD","WA")

tcp01 <- data.frame(StateAb = 0, DivisionNm = 0, Surname = 0, GivenNm = 0, PartyAb = 0, Elected = 0, CalculationValue = 0, Swing = 0)

#For ACT, NSW, SA and NT
for (j in 1:length(states)) {
  state_name = states[j]
  xls_ref <- paste0("data-raw/House-Tcp-Division-2001/TCP_", state_name, ".xls")
  tcp01_temp <- read_xls(xls_ref)
  row_cand <- as.data.frame(which(tcp01_temp == "Candidates", arr.ind=TRUE))
  row_fulldist <- as.data.frame(which(tcp01_temp == "Full Distribution of Preferences", arr.ind=TRUE))[,1]
  n_divisions <- nrow(row_cand)
  row_div_id <- row_cand[,1] - 2 #where divisions are stored
  col_party <- unique(which(tcp01_temp == "Party", arr.ind=TRUE)[,2]) #column reference for party name
  
  #Loop over i = divisions, to generate one row for each candidate
  for (i in 1:n_divisions) {
    divname = toupper(tcp01_temp[row_div_id,1][[1]][i])
    
    name1 = toupper(tcp01_temp[row_fulldist[i] + 1, col_party - 1])
    name2 = toupper(tcp01_temp[row_fulldist[i] + 2, col_party - 1])
    names = strsplit(c(name1, name2), ", ")
    firstnames = c(names[[1]][2], names[[2]][2])
    surnames = c(names[[1]][1], names[[2]][1])
    
    party1 = tcp01_temp[row_fulldist[i] + 1, col_party][[1]]
    party2 = tcp01_temp[row_fulldist[i] + 2, col_party][[1]]
    partyabrev = c(party1, party2)
    
    swing1 = tcp01_temp[row_fulldist[i] + 1, col_party + 3][[1]]
    swing2 = tcp01_temp[row_fulldist[i] + 2, col_party + 3][[1]]
    swing = c(swing1, swing2)
    
    votes1 = tcp01_temp[row_fulldist[i] + 1, col_party + 2][[1]]
    votes2 = tcp01_temp[row_fulldist[i] + 2, col_party + 2][[1]]
    votes = c(votes1, votes2)
    
    temp <- data.frame(StateAb = rep(state_name,length(partyabrev)), DivisionNm = rep(divname,length(partyabrev)), Surname = surnames, GivenNm = firstnames, PartyAb = partyabrev, Elected = ifelse(votes == max(votes), "Y", "N"), CalculationValue = votes, Swing = swing)
    tcp01 <- rbind(tcp01,temp)
  }
  
}

#Remove first row of zeros, and reset rownames
tcp01 <- tcp01[-1,] %>% 
  rename(Percent = CalculationValue)
rownames(tcp01) <- 1:nrow(tcp01)
tcp01$DivisionNm <- as.character(tcp01$DivisionNm)
for (i in 1:nrow(tcp01)) {
  if(strsplit(tcp01$DivisionNm[i], " ")[[1]] %>% length > 2) {
    tcp01$DivisionNm[i] <- paste(strsplit(tcp01$DivisionNm[i], " ")[[1]][1],strsplit(tcp01$DivisionNm[i], " ")[[1]][2])
  } else {
    tcp01$DivisionNm[i] <- strsplit(tcp01$DivisionNm[i], " ")[[1]][1]
  }
}




#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.
# The full data set is NOT available, so TPP is only calculated for the electorates who had ALP/LNP candidates in their two
# candidate preferred.

## Filtering TCP to get those with ALP and LNP only.
in_tpp <- tcp01 %>% 
  filter(PartyAb %in% c("ALP", "CLR", "CLP", "LP", "NP")) %>% 
  count(DivisionNm)

tpp01 <- tcp01 %>% 
  filter(DivisionNm %in% in_tpp$DivisionNm) %>% 
  mutate(PartyFixed = ifelse(PartyAb %in% c("ALP", "CLR"), "ALP", "LNP")) %>% 
  select(-PartyAb) %>% 
  rename(PartyAb = PartyFixed) %>% 
  filter(PartyAb == "LNP", !is.na(Swing))

#---- RELABEL PARTY NAMES ----

# Function in aec2016.R

# Apply

fp01 <- fp01 %>% reabbrev_parties() %>% chr_upper()
tcp01 <- tcp01 %>% reabbrev_parties() %>% chr_upper()
tpp01 <- tpp01 %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp01, file = "data/fp01.rda")
save(tpp01, file = "data/tpp01.rda")
save(tcp01, file = "data/tcp01.rda")


# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2004
####################################################################################################

## Importing federal election results for 2004, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)

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



#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp04$DivisionNm <- toupper(fp04$DivisionNm)
tcp04$DivisionNm <- toupper(tcp04$DivisionNm)
tpp04$DivisionNm <- toupper(tpp04$DivisionNm)


#---- RELABEL PARTY NAMES ----

# Apply

fp04 <- fp04 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp04 <- tcp04 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tpp04 <- tpp04 %>% chr_upper()

#---- SAVE ----
save(fp04, file = "data/fp04.rda")
save(tpp04, file = "data/tpp04.rda")
save(tcp04, file = "data/tcp04.rda")

# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2007
####################################################################################################

## Importing federal election results for 2007, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)

#--- FIRST PREFERENCES ---#

pref07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseDopByDivisionDownload-13745.csv", skip = 1)

fp07 <- pref07 %>% 
  filter(CalculationType %in% c("Preference Count", "Preference Percent")) %>% 
  group_by(StateAb, DivisionID, DivisionNm, CountNumber, BallotPosition, CandidateID, Surname, GivenNm, PartyAb, PartyNm, Elected, HistoricElected) %>% 
  spread(key = CalculationType, value = CalculationValue) %>%
  filter(CountNumber == 0) %>% 
  ungroup() %>% 
  select(-CountNumber) %>% #takes only % of first preference votes
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`)


#--- TWO CANDIDATE PREFERRED ---#
# Distribution of preferences to the two candidates who came first and second in the election
tcp07 <- pref07 %>% 
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

tpp07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseTppByDivisionDownload-13745.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)

#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp07$DivisionNm <- toupper(fp07$DivisionNm)
tcp07$DivisionNm <- toupper(tcp07$DivisionNm)
tpp07$DivisionNm <- toupper(tpp07$DivisionNm)


#---- RELABEL PARTY NAMES ----

# Apply

fp07 <- fp07 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp07 <- tcp07 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp07, file = "data/fp07.rda")
save(tpp07, file = "data/tpp07.rda")
save(tcp07, file = "data/tcp07.rda")



# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2010
####################################################################################################

## Importing federal election results for 2010, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)

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


#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp10$DivisionNm <- toupper(fp10$DivisionNm)
tcp10$DivisionNm <- toupper(tcp10$DivisionNm)
tpp10$DivisionNm <- toupper(tpp10$DivisionNm)


#---- RELABEL PARTY NAMES ----

# Apply

fp10 <- fp10 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp10 <- tcp10 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp10, file = "data/fp10.rda")
save(tpp10, file = "data/tpp10.rda")
save(tcp10, file = "data/tcp10.rda")


# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2013
####################################################################################################

## Importing federal election results for 2013, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)

#--- FIRST PREFERENCES ---#

pref13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseDopByDivisionDownload-17496.csv", skip = 1)

fp13 <- pref13 %>% 
  filter(CalculationType %in% c("Preference Count", "Preference Percent")) %>% 
  group_by(StateAb, DivisionID, DivisionNm, CountNumber, BallotPosition, CandidateID, Surname, GivenNm, PartyAb, PartyNm, Elected, HistoricElected) %>% 
  spread(key = CalculationType, value = CalculationValue) %>%
  filter(CountNumber == 0) %>% 
  ungroup() %>% 
  select(-CountNumber) %>% #takes only % of first preference votes
  rename(OrdinaryVotes = `Preference Count`, Percent = `Preference Percent`)


#--- TWO CANDIDATE PREFERRED ---#
# Distribution of preferences to the two candidates who came first and second in the election
tcp13 <- pref13 %>% 
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

tpp13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseTppByDivisionDownload-17496.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp13$DivisionNm <- toupper(fp13$DivisionNm)
tcp13$DivisionNm <- toupper(tcp13$DivisionNm)
tpp13$DivisionNm <- toupper(tpp13$DivisionNm)

#---- RELABEL PARTY NAMES ----

# Apply

fp13 <- fp13 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp13 <- tcp13 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()

#---- SAVE ----
save(fp13, file = "data/fp13.rda")
save(tpp13, file = "data/tpp13.rda")
save(tcp13, file = "data/tcp13.rda")


# ---------------------------------------------------------------------------------------------------------

####################################################################################################
# 2016
####################################################################################################

## Importing federal election results for 2016, and forming a dataframe for each vote count
## Vote counts are: first preference, two candidate preferred (2cp) and two party preferred (2pp)

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

#---- MAKE ALL ELECTORATE NAMES UPPER CASE ----
fp16$DivisionNm <- toupper(fp16$DivisionNm)
tcp16$DivisionNm <- toupper(tcp16$DivisionNm)
tpp16$DivisionNm <- toupper(tpp16$DivisionNm)


# Apply

fp16 <- fp16 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()
tcp16 <- tcp16 %>% relabel_parties() %>% reabbrev_parties() %>% chr_upper()


#---- SAVE ----
save(fp16, file = "data/fp16.rda")
save(tpp16, file = "data/tpp16.rda")
save(tcp16, file = "data/tcp16.rda")
