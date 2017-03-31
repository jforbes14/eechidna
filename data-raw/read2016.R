library(tidyverse)

senate <- read_csv("data/SenateSenatorsElectedDownload-20499.csv", skip = 1)
senate <- senate %>% 
  mutate(
    PartyNm = case_when(
      .$PartyNm == "Australian Labor Party (Northern Territory) Branch" ~ "Australian Labor Party",
      .$PartyNm == "Country Labor" ~ "Australian Labor Party",
      .$PartyNm == "National Party" ~ "The Nationals",
      .$PartyNm == "Liberal National Party of Queensland" ~ "Liberal",
      .$PartyNm == "Country Liberals (NT)" ~ "Liberal",
      .$PartyNm == "The Greens (WA)" ~ "The Greens",
      TRUE ~ .$PartyNm
    )
  )
write_csv(senate, path = "data/SenateSenatorsElected2016.csv")

# list of data frames with each state
wdir <- "data/HouseStateFirstPrefsByPollingPlace"
files <- list.files(wdir,  full.names = TRUE)
election_results_df <- files %>% 
  map_df(read_csv, skip = 1) %>% 
  filter(!is.na(PartyNm)) 
election_results_df <- election_results_df %>% 
  mutate(
    PartyNm = case_when(
      .$PartyNm == "Australian Labor Party (Northern Territory) Branch" ~ "Australian Labor Party",
      .$PartyNm == "Country Labor" ~ "Australian Labor Party",
      .$PartyNm == "National Party" ~ "The Nationals",
      .$PartyNm == "Liberal National Party of Queensland" ~ "Liberal",
      .$PartyNm == "Country Liberals (NT)" ~ "Liberal",
      .$PartyNm == "The Greens (WA)" ~ "The Greens",
      TRUE ~ .$PartyNm
    )
  )

# get lat long for polling places
polling_place_location <- read_csv("data/GeneralPollingPlacesDownload-20499.csv", 
  skip = 1)

# get two party preferred data
two_party_preferred_by_polling_place <- read_csv("data/HouseTppByPollingPlaceDownload-20499.csv", 
  skip = 1)

# add in different vote types
vote_types <- read_csv("data/HouseFirstPrefsByCandidateByVoteTypeDownload-20499.csv", skip = 1)
#  how to join? vote_types is only for each candidate, not each polling place...

aec_first_pref <- read_csv("data/HouseFirstPrefsByPartyDownload-20499.csv",
  skip = 1)
aec_first_pref <- aec_first_pref %>% 
  mutate(
    PartyNm = case_when(
      .$PartyNm == "Australian Labor Party (Northern Territory) Branch" ~ "Australian Labor Party",
      .$PartyNm == "Country Labor" ~ "Australian Labor Party",
      .$PartyNm == "National Party" ~ "The Nationals",
      .$PartyNm == "Liberal National Party of Queensland" ~ "Liberal",
      .$PartyNm == "Country Liberals (NT)" ~ "Liberal",
      .$PartyNm == "The Greens (WA)" ~ "The Greens",
      TRUE ~ .$PartyNm
    )
  )

aec_winners <- read_csv("data/HouseMembersElectedDownload-20499.csv", 
  skip = 1)
aec_winners <- aec_winners %>% 
  mutate(
    PartyNm = case_when(
      .$PartyNm == "Australian Labor Party (Northern Territory) Branch" ~ "Australian Labor Party",
      .$PartyNm == "Country Labor" ~ "Australian Labor Party",
      .$PartyNm == "National Party" ~ "The Nationals",
      .$PartyNm == "Liberal National Party of Queensland" ~ "Liberal",
      .$PartyNm == "Country Liberals (NT)" ~ "Liberal",
      .$PartyNm == "The Greens (WA)" ~ "The Greens",
      TRUE ~ .$PartyNm
    )
  )
# names(aec_winners)

# get two candidate preferred data

aec_2candidates <- read_csv("data/HouseTcpByCandidateByVoteTypeDownload-20499.csv", 
  skip = 1)
aec_2candidates_polling_place <- read_csv("data/HouseTcpByCandidateByPollingPlaceDownload-20499.csv", skip = 1)
aec_2candidates_polling_place <- aec_2candidates_polling_place %>% 
  mutate(
    PartyNm = case_when(
      .$PartyNm == "Australian Labor Party (Northern Territory) Branch" ~ "Australian Labor Party",
      .$PartyNm == "Country Labor" ~ "Australian Labor Party",
      .$PartyNm == "National Party" ~ "The Nationals",
      .$PartyNm == "Liberal National Party of Queensland" ~ "Liberal",
      .$PartyNm == "Country Liberals (NT)" ~ "Liberal",
      .$PartyNm == "The Greens (WA)" ~ "The Greens",
      TRUE ~ .$PartyNm
    )
  )

######################### end data ingest ####################

# join polling place locations to election results
election_results_df_loc <- election_results_df %>%   
  full_join(polling_place_location, by = c("DivisionID", "PollingPlaceID", "DivisionNm"))
# head(election_results_df_loc)

# do we have any polling places with no location data?
election_results_df_loc %>% 
  select(DivisionID, PollingPlace, StateAb, GivenNm, Surname, PartyNm, 
    Elected, Latitude, Longitude) %>% 
  filter(Elected == "Y") %>% 
  filter(is.na(Latitude)) 
# yes, 587 hospitals, etc.  

# plot 
ggplot(election_results_df_loc, aes(Longitude, Latitude)) +
  geom_point() +
  coord_equal() 

# str(election_results_df_loc)
# get rid of factors
election_results_df_loc_no_fac <- election_results_df_loc %>% 
  map_if(is.factor, as.character) %>% 
  bind_rows()
# str(election_results_df_loc_no_fac)

# how many polling places do we have with election data?
number_of_polling_places <- election_results_df_loc_no_fac %>% 
  group_by(PollingPlaceID) %>% 
  summarize(number_of_candidates_per_polling_place = n()) %>% 
  nrow()

####################### add locations to 2pp data ##############

# join with first pref data
# need to aggregate to we have only one polling place per row
election_results_df_loc_pp <- election_results_df_loc %>% 
  group_by(PollingPlaceID) %>% 
  filter(Elected == "Y") %>% 
  arrange(desc(PollingPlaceID)) %>% 
  slice(1) 

# check we have all the polling places
identical(number_of_polling_places, nrow(election_results_df_loc_pp))

# 8328
election_results_df_loc_pp <- election_results_df_loc_pp %>% 
  left_join(two_party_preferred_by_polling_place, 
    by = c("StateAb", "DivisionID", "DivisionNm", "PollingPlace", 
      "PollingPlaceID")
  )

# make some electorate names match the spatial data
election_results_df_loc_pp <- election_results_df_loc_pp %>% 
  ungroup() %>% 
  mutate(
    DivisionNm = case_when(
      .$DivisionNm == "McMillan" ~ "Mcmillan",
      .$DivisionNm == "McPherson" ~ "Mcpherson",
      TRUE ~ .$DivisionNm
      )
  )
######### end of working with the 2pp data ###########
### aggregate fp and 2pp by electorate #############
electorate_variables <-  c(
  "DivisionID", "DivisionNm", "CandidateID", "Surname", "GivenNm", 
  "BallotPosition", "Elected", "HistoricElected", "PartyAb", "PartyNm", "State"
  )
two_pp_variables <- c(
  "Australian Labor Party Votes", "Australian Labor Party Percentage", 
  "Liberal National Coalition Votes", "Liberal National Coalition Percentage", 
  "TotalVotes"
)

# votes per canditate in each electorate
aec2016_fp_electorate <- election_results_df_loc_no_fac %>% 
  group_by_(.dots = electorate_variables) %>% 
  summarise(Total_OrdinaryVotes_in_electorate = sum(OrdinaryVotes)) 

# check 
aec2016_fp_electorate %>% 
  group_by(PartyAb) %>% 
  summarise(Total_votes = sum(Total_OrdinaryVotes_in_electorate)) %>% 
  arrange(desc(Total_votes))
# yes, ok

# repeat for 2pp
aec2016_2pp_electorate <- election_results_df_loc_pp %>% 
  group_by_(.dots = electorate_variables) %>% 
  summarise(
    Total_Australian_Labor_Party_Votes_per_electorate = sum(`Australian Labor Party Votes`),
    Average_Australian_Labor_Party_Percentage_in_electorate = mean(`Australian Labor Party Percentage`),
    Total_Liberal_National_Coalition_Votes_per_electorate = sum(`Liberal/National Coalition Votes`),
    Average_Liberal_National_Coalition_Percentage_in_electorate = mean(`Liberal/National Coalition Percentage`),
    Total_2pp_votes_per_electorate = sum(TotalVotes)
  )


###### write data to disk #################

# save as CSV
write.csv(election_results_df_loc_no_fac, 
  "data/HouseFirstPrefsByPollingPlaceAllStates.csv")
write.csv(election_results_df_loc_pp,            
  "data/HouseTwoPartyPrefdByPollingPlaceAllStates.csv")
write.csv(aec2016_fp_electorate,                 
  "data/HouseFirstPrefsByElectorateAllStates.csv")
write.csv(aec2016_2pp_electorate,                
  "data/HouseTwoPartyPrefdByElectorateAllStates.csv")
write.csv(aec_2candidates,                   
  "data/HouseTwoCandidatePrefdByElectorateAllStates.csv")
write.csv(aec_2candidates_polling_place,     
  "data/HouseTwoCandidatePrefdByPollingPlaceAllStates.csv")

# rename to something neater and more logical (nameing is hard!)
aec2016_fp <- election_results_df_loc_no_fac
aec2016_fp_electorate <- aec2016_fp_electorate
aec2016_2pp <- election_results_df_loc_pp
aec2016_2pp_electorate <- aec2016_2pp_electorate
aec2016_2cp <- aec_2candidates_polling_place
aec2016_2cp_electorate <- aec_2candidates

# Change variable names to match abs2011 where possible.
match_abs_2011_names <- function(x){
  x <- rename(x, ID=DivisionID)
  x <- rename(x, Electorate=DivisionNm)
  x$StateAb <- NULL
  x
}

# put data objects in a list to save typing
list_of_data_objects_for_renaming <- list(
  aec2016_fp = aec2016_fp, 
  aec2016_fp_electorate = aec2016_fp_electorate, 
  aec2016_2pp = aec2016_2pp, 
  aec2016_2pp_electorate = aec2016_2pp_electorate,
  aec2016_2cp = aec2016_2cp, 
  aec2016_2cp_electorate = aec2016_2cp_electorate
)
# apply the function to change variable names
list_of_data_objects <- lapply(list_of_data_objects_for_renaming, function(i) match_abs_2011_names(i))
# remove objects from env to mimimize confusion
rm(list = names(list_of_data_objects))

# save to rds file (recommended for indiv. items)
for(i in seq_along(list_of_data_objects)){
  # can't save from a list, so make a temp object, with the right name
  temp <- list_of_data_objects[[i]]
  assign(names(list_of_data_objects)[i], temp)
  save(list = names(list_of_data_objects)[i], 
       file=paste0("data/", 
       names(list_of_data_objects)[i], ".rda"),
       compress =  "xz")
}

# load them in to this session
data_file_names <- list.files("data/", pattern = "aec2016", full.names = TRUE)
lapply(data_file_names, load, .GlobalEnv)

# check what we've got
list.files("data/")

########## end of data preparation and file-writing ###########
################################################################
