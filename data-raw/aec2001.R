## Importing federal election results for 2001, and forming a dataframe for each vote count
## Vote counts are: first preference and two party preferred (2pp)
## Cannot be directly downloaded, but available on request from AEC via email.
## Files are titled "DOP_(StateAb).xls", for example: "DOP_VIC.xls"

## One minor change made to raw files, so that they can be read in properly
## ACT, NSW, SA & NT adjusted so all candidate names in the same column as "Votes"
## VIC, WA, QLD & TAS adjusted so all candidate names in the same column as "%"


library(readxl)
library(tidyverse)

#--- FIRST PREFERENCES ---#
# Loop over each state (j), and each division within the state (i)
states = c("ACT","NSW","SA","NT","TAS","VIC","QLD","WA")

fp01 <- data.frame(StateAb = 0, DivisionNm = 0, Surname = 0, GivenNm = 0, PartyAb = 0, Elected = 0, CalculationValue = 0)


#For ACT, NSW, SA and NT
for (j in 1:(length(states) - 4)) {
  state_name = states[j]
  xls_ref <- paste0("./Raw/House-Dop-Division-2001/DOP_", state_name, ".xls")
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
  xls_ref <- paste0("./Raw/House-Dop-Division-2001/DOP_", state_name, ".xls")
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
  xls_ref <- paste0("./Raw/House-Tcp-Division-2001/TCP_", state_name, ".xls")
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
save(fp01, file = "Clean/fp01.rda")
save(tpp01, file = "Clean/tpp01.rda")
save(tcp01, file = "Clean/tcp01.rda")

