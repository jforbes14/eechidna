# This script, when run, builds all electorate level voting data for the six Australian federal elections between 2001 and 2016.

library(readxl)
library(tidyverse)


# ---------------------------------------------------------------------------------------------------------

# Function to re-label parties so that names are common
relabel_parties <- function(df, PartyNm = PartyNm) {
  out <- df %>% 
    ungroup %>% 
    mutate(PartyNm = ifelse(
      PartyNm %in% c("AUSTRALIAN LABOR PARTY (NORTHERN TERRITORY) BRANCH",  "LABOR", "AUSTRALIAN LABOR PARTY (ACT BRANCH)", "AUSTRALIAN LABOR PARTY (ALP)", "COUNTRY LABOR"), "AUSTRALIAN LABOR PARTY",
      ifelse(PartyNm %in% c("C.L.P.", "COUNTRY LIBERALS (NT)", "LIBERAL NATIONAL PARTY OF QUEENSLAND", "THE NATIONALS", "NATIONAL PARTY", "CLP-THE TERRITORY PARTY", "LIBERALS", "NATIONALS"), "LIBERAL", 
        ifelse(PartyNm %in% c("THE GREENS (WA)", "AUSTRALIAN GREENS"), "THE GREENS", 
          ifelse(PartyNm %in% c(""), "INFORMAL", 
            ifelse(PartyNm %in% c("AUSTRALIAN DEMOCRATS"), "DEMOCRATS",
              ifelse(PartyNm %in% c("NEW COUNTRY"), "NEW COUNTRY PARTY",
                ifelse(PartyNm %in% c("ONE NATION WA", "PAULINE HANSON'S ONE NATION (NSW DIVISION)", "PAULINE HANSON'S ONE NATION"), "ONE NATION", 
                  ifelse(PartyNm %in% c("SEX PARTY"), "AUSTRALIAN SEX PARTY", 
                    ifelse(PartyNm %in% c("CHRISTIAN DEMOCRATIC PARTY (FRED NILE GROUP)", "CDP CHRISTIAN PARTY"), "CHRISTIAN DEMOCRATIC PARTY",
                      ifelse(PartyNm %in% c("CITIZENS ELECTORAL COUNCIL OF AUSTRALIA"), "CITIZENS ELECTORAL COUNCIL",
                        ifelse(PartyNm %in% c("AUSTRALIAN COUNTRY PARTY"), "COUNTRY ALLIANCE", 
                          ifelse(PartyNm %in% c("DEMOCRATIC LABOUR PARTY (DLP)", "DLP DEMOCRATIC LABOUR PARTY", "D.L.P. - DEMOCRATIC LABOR PARTY"), "DEMOCRATIC LABOR PARTY",
                            ifelse(PartyNm %in% c("FAMILY FIRST PARTY"), "FAMILY FIRST", 
                              ifelse(PartyNm %in% c("SCIENCE PARTY"), "FUTURE PARTY",
                                ifelse(PartyNm %in% c("HELP END MARIJUANA PROHIBITION"), "MARIJUANA (HEMP) PARTY",
                                  ifelse(PartyNm %in% c("LDP", "LIBERAL DEMOCRATS (LDP)"), "LIBERAL DEMOCRATS",
                                    ifelse(PartyNm %in% c("NON-CUSTODIAL PARENTS PARTY (EQUAL PARENTING)"), "NON-CUSTODIAL PARENTS PARTY",
                                      ifelse(PartyNm %in% c("SENATOR ONLINE (INTERNET VOTING BILLS/ISSUES)", "ONLINE DIRECT DEMOCRACY - (EMPOWERING THE PEOPLE!)"), "SENATOR ONLINE",
                                        ifelse(PartyNm %in% c("STABLE POPULATION PARTY"), "SUSTAINABLE AUSTRALIA",
                                          ifelse(PartyNm %in% c("AUSTRALIAN VOICE"), "AUSTRALIAN VOICE PARTY",
                                 ifelse(is.na(PartyNm), "INDEPENDENT", PartyNm
            ))))))))))))))))))))))
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
            ifelse(is.na(PartyAb), "IND", 
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
  select(-CountNumber)

#---- TWO PARTY PREFERRED ----
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp16 <- read_csv("https://results.aec.gov.au/20499/Website/Downloads/HouseTppByDivisionDownload-20499.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


# Apply

fp16 <- fp16 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tcp16 <- tcp16 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tpp16 <- tpp16 %>% chr_upper()


#---- SAVE ----
usethis::use_data(fp16, overwrite = T, compress = "xz")
usethis::use_data(tcp16, overwrite = T, compress = "xz")
usethis::use_data(tpp16, overwrite = T, compress = "xz")


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
  select(-CountNumber)


#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp13 <- read_csv("https://results.aec.gov.au/17496/Website/Downloads/HouseTppByDivisionDownload-17496.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


#---- RELABEL PARTY NAMES ----

# Apply

fp13 <- fp13 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tcp13 <- tcp13 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tpp13 <- tpp13 %>% chr_upper()

#---- SAVE ----
usethis::use_data(fp13, overwrite = T, compress = "xz")
usethis::use_data(tcp13, overwrite = T, compress = "xz")
usethis::use_data(tpp13, overwrite = T, compress = "xz")


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
  select(-CountNumber)


#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp10 <- read_csv("https://results.aec.gov.au/15508/Website/Downloads/HouseTppByDivisionDownload-15508.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


#---- RELABEL PARTY NAMES ----

# Apply

fp10 <- fp10 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tcp10 <- tcp10 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tpp10 <- tpp10 %>% chr_upper()


#---- SAVE ----
usethis::use_data(fp10, overwrite = T, compress = "xz")
usethis::use_data(tcp10, overwrite = T, compress = "xz")
usethis::use_data(tpp10, overwrite = T, compress = "xz")



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
  select(-CountNumber)


#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp07 <- read_csv("https://results.aec.gov.au/13745/Website/Downloads/HouseTppByDivisionDownload-13745.csv", skip = 1) %>%
  arrange(DivisionID) %>% 
  rename(LNP_Votes = `Liberal/National Coalition Votes`, LNP_Percent = `Liberal/National Coalition Percentage`,
    ALP_Votes = `Australian Labor Party Votes`, ALP_Percent = `Australian Labor Party Percentage`) %>% 
  select(-PartyAb)


#---- RELABEL PARTY NAMES ----

# Apply

fp07 <- fp07 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tcp07 <- tcp07 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tpp07 <- tpp07 %>% chr_upper()


#---- SAVE ----
usethis::use_data(fp07, overwrite = T, compress = "xz")
usethis::use_data(tcp07, overwrite = T, compress = "xz")
usethis::use_data(tpp07, overwrite = T, compress = "xz")



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

#---- RELABEL PARTY NAMES ----

# Apply

fp04 <- fp04 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tcp04 <- tcp04 %>% reabbrev_parties() %>% chr_upper() %>% relabel_parties()
tpp04 <- tpp04 %>% chr_upper()

#---- SAVE ----
usethis::use_data(fp04, overwrite = T, compress = "xz")
usethis::use_data(tcp04, overwrite = T, compress = "xz")
usethis::use_data(tpp04, overwrite = T, compress = "xz")



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

# Add party names *HERE*
#temp <- fp04 %>% select(PartyAb, PartyNm) %>% unique() %>% filter(PartyNm %in% c("AUSTRALIAN LABOR PARTY (ACT BRANCH)", "COUNTRY LABOR", "AUSTRALIAN LABOR PARTY (ALP)"))
#temp2 <- fp01 %>% left_join(temp, by = "PartyAb")


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

# Make Percent and Swing numeric
tcp01 <- tcp01 %>% 
  mutate(Percent = as.numeric(Percent), Swing = as.numeric(Swing))


#--- TWO PARTY PREFERRED ---#
# Preferences distribution only to Labor (ALP) and Coalition (LP, NP, LNQ, CLP)
# A distribution of preferences where, by convention, comparisons are made between the ALP and the leading Liberal/National candidates. In seats where the final two candidates are not from the ALP and the Liberal or National parties, a two party preferred count may be conducted to find the result of preference flows to the ALP and the Liberal/National candidates.

tpp01 <- read_csv("data-raw/HouseTppByDivision2001.csv")[-(1:17), ] %>% 
  rename("DivisionNm" = "House of Representatives: Election 2001 - National", "ALP_Votes" = "X2", "ALP_Percent" = "X3", "LNP_Votes" = "X4", "LNP_Percent" = "X5", "TotalVotes" = "X6", "Swing" = "X7") %>% 
  filter(!is.na(DivisionNm), !DivisionNm %in% c("Division", "State Total", "Territory Total")) %>% 
  select(-X8) %>% 
  mutate(StateAb = c(rep("NSW", 51), rep("VIC", 38), rep("QLD", 28), rep("WA", 16), rep("SA", 13), rep("TAS", 6), rep("ACT", 3), rep("NT", 3)),
    LNP_Votes = as.numeric(LNP_Votes), LNP_Percent = as.numeric(LNP_Percent), ALP_Votes = as.numeric(ALP_Votes), ALP_Percent = as.numeric(ALP_Percent), TotalVotes = as.numeric(TotalVotes), Swing = as.numeric(Swing)) %>% 
  filter(!is.na(ALP_Votes)) %>% 
  select(DivisionNm, StateAb, LNP_Votes, LNP_Percent, ALP_Votes, ALP_Percent, TotalVotes, Swing)


# Apply

fp01 <- fp01 %>% reabbrev_parties() %>% chr_upper()
tcp01 <- tcp01 %>% reabbrev_parties() %>% chr_upper()
tpp01 <- tpp01 %>% chr_upper()


#---- ADD PARTY NAMES ----
# Get all possible PartyNm and group
allpartynms <- bind_rows(select(fp16, PartyAb, PartyNm), select(fp13, PartyAb, PartyNm), select(fp10, PartyAb, PartyNm), select(fp07, PartyAb, PartyNm), select(fp04, PartyAb, PartyNm)) %>% unique() %>% bind_rows(data.frame(PartyAb = c("CTA", "AFI", "UNI", "NGST", "TFP", "CLA"),
  PartyNm = c("CHRISTIAN DEMOCRATIC PARTY", "AUSTRALIANS AGAINST FURTHER IMMIGRATION", "UNITY - SAY NO TO HANSON", "NO GOODS AND SERVICES TAX PARTY", "TASMANIA FIRST PARTY", "CURTIN LABOR ALLIANCE")))

fp01 <- fp01 %>% left_join(allpartynms, by = "PartyAb")
tcp01 <- tcp01 %>% left_join(allpartynms, by = "PartyAb")

#---- SAVE ----
usethis::use_data(fp01, overwrite = T, compress = "xz")
usethis::use_data(tcp01, overwrite = T, compress = "xz")
usethis::use_data(tpp01, overwrite = T, compress = "xz")



