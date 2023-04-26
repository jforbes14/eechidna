## Run this file to do the final steps for wrangling census and election data
## Primarily, this generates a unique ID that can be used to track the same electoral 
## divison (roughly) over time
## The objects generated here are saved in the data folder of the main directory

# --- Load census and election objects --- #
# Census
load("data-raw/census/data/abs2001.rda")
load("data-raw/census/data/abs2006.rda")
load("data-raw/census/data/abs2011.rda")
load("data-raw/census/data/abs2016.rda")
load("data-raw/census/data/abs2021.rda")

# Imputed census
load("data-raw/census-imputation-using-sa1/data/abs2019.rda")
load("data-raw/census-imputation-using-sa1/data/abs2013.rda")
load("data-raw/census-imputation-using-sa1/data/abs2010.rda")
load("data-raw/census-imputation-using-sa1/data/abs2007.rda")
load("data-raw/census-imputation-using-sa1/data/abs2004.rda")

# Election
load("data-raw/elections/data/fp22.rda")
load("data-raw/elections/data/tpp22.rda")
load("data-raw/elections/data/tcp22.rda")
load("data-raw/elections/data/fp19.rda")
load("data-raw/elections/data/tpp19.rda")
load("data-raw/elections/data/tcp19.rda")
load("data-raw/elections/data/fp16.rda")
load("data-raw/elections/data/tpp16.rda")
load("data-raw/elections/data/tcp16.rda")
load("data-raw/elections/data/fp13.rda")
load("data-raw/elections/data/tpp13.rda")
load("data-raw/elections/data/tcp13.rda")
load("data-raw/elections/data/fp10.rda")
load("data-raw/elections/data/tpp10.rda")
load("data-raw/elections/data/tcp10.rda")
load("data-raw/elections/data/fp07.rda")
load("data-raw/elections/data/tpp07.rda")
load("data-raw/elections/data/tcp07.rda")
load("data-raw/elections/data/fp04.rda")
load("data-raw/elections/data/tpp04.rda")
load("data-raw/elections/data/tcp04.rda")
load("data-raw/elections/data/fp01.rda")
load("data-raw/elections/data/tpp01.rda")
load("data-raw/elections/data/tcp01.rda")

# --- Creating UniqueID --- #

# Creating unique electoral division IDs
# All objects must be in global environment before running this script - this is the last script to be run

library(dplyr)

# Use the 2016 Census IDs as the default

my_ids <- abs2016 %>% 
  select(ID, DivisionNm) %>% 
  rename(UniqueID = ID) %>% 
  unique() %>% 
  arrange(UniqueID)

# Add DivisionNms that are not in 2016

my_ids <- my_ids %>% 
  full_join(abs2019 %>% select(DivisionNm)) %>% 
  full_join(abs2013 %>% select(DivisionNm)) %>% 
  full_join(abs2010 %>% select(DivisionNm)) %>% 
  full_join(abs2007 %>% select(DivisionNm)) %>% 
  full_join(abs2004 %>% select(DivisionNm)) %>% 
  full_join(abs2001 %>% select(DivisionNm))

# Add UniqueID for divisions that changed their name and for divisions that were abolished before 2016
# Renamed electorates: FRASER became FENNER, PROSPECT became MCMAHON, THROSBY became WHITLAM,
# DENISON became CLARK, BATMAN became COOPER, MELBOURNE PORTS became MACNAMARA, MCMILLAN became MONASH, 
# MURRAY became NICHOLLS, WAKEFIELD became SPENCE
# New electorates in 2019: BEAN, FRASER (same name as an extinct electorate, but is actually a new distinct one)
# New electorate in 2021: HAWKE (new electorate, doesn't supersede any existing electorates)

my_ids <- my_ids %>% 
  mutate(UniqueID = ifelse(DivisionNm == "BONYTHON", 412, 
    ifelse(DivisionNm == "BURKE", 238, 
      ifelse(DivisionNm == "CHARLTON", 148,  
        ifelse(DivisionNm == "FRASER", 802, 
          ifelse(DivisionNm == "GWYDIR", 149,
            ifelse(DivisionNm == "KALGOORLIE", 517,
              ifelse(DivisionNm == "LOWE", 150,
                ifelse(DivisionNm == "PROSPECT", 128,
                  ifelse(DivisionNm == "THROSBY", 147, 
                    ifelse(DivisionNm == "SPENCE", 411, 
                      ifelse(DivisionNm == "BEAN", 803, 
                        ifelse(DivisionNm == "CLARK", 603, 
                          ifelse(DivisionNm == "COOPER", 203, 
                            ifelse(DivisionNm == "MACNAMARA", 232, 
                              ifelse(DivisionNm == "MONASH", 230, 
                                ifelse(DivisionNm == "NICHOLLS", 234,
                                  ifelse(DivisionNm == "HAWKE", 148, UniqueID
                                )))))))))))))))))) %>% unique() %>% 
  # Add last year used where needed
  mutate(LastYearRelevant = ifelse(DivisionNm %in% c("FRASER"), 2013, 9999)) %>% 
  bind_rows(data.frame(DivisionNm = 'FRASER', UniqueID = 238, LastYearRelevant = 9999))

save(my_ids, file = "data-raw/supplement/my_ids.rda")

# Function to get IDs relevant for a given year
get_year_ids <- function(year, my_ids) {
  filtered_ids <- my_ids %>% 
    filter(LastYearRelevant >= year) %>% 
    group_by(DivisionNm) %>% 
    filter(LastYearRelevant == min(LastYearRelevant)) %>% 
    select(-LastYearRelevant)
  
  return(filtered_ids)
  }

# Now replace any existing IDs

load("data-raw/supplement/my_ids.rda")

# 2022
# TODO: Add abs2022 objects

fp22 <- fp22 %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp22 <- tpp22 %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp22 <- tcp22 %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

# 2021
my_ids_2021 <- get_year_ids(year = 2021, my_ids = my_ids)

abs2021 <- abs2021 %>% 
  left_join(my_ids_2021, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    State = toupper(State)
  )

# 2019
my_ids_2019 <- get_year_ids(year = 2019, my_ids = my_ids)

fp19 <- fp19 %>% 
  left_join(my_ids_2019, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp19 <- tpp19 %>% 
  left_join(my_ids_2019, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp19 <- tcp19 %>% 
  left_join(my_ids_2019, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2019 <- abs2019 %>% 
  left_join(my_ids_2019, by = "DivisionNm") %>%
  select(UniqueID, DivisionNm, Population, everything()) %>% 
  left_join(
    fp19 %>% select(c('DivisionNm', 'StateAb')) %>% unique(),
    on = 'DivisionNm'
  ) %>% 
  rename(
    State = StateAb
  ) %>% 
  mutate(
    State = toupper(State)
  ) %>% 
  select(
    UniqueID, DivisionNm, State, everything()
  )

# 2016
my_ids_2016 <- get_year_ids(year = 2016, my_ids = my_ids)

fp16 <- fp16 %>% 
  left_join(my_ids_2016, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp16 <- tpp16 %>% 
  left_join(my_ids_2016, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp16 <- tcp16 %>% 
  left_join(my_ids_2016, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2016 <- abs2016 %>% 
  left_join(my_ids_2016, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    State = toupper(State)
  )

# 2013
my_ids_2013 <- get_year_ids(year = 2013, my_ids = my_ids)

fp13 <- fp13 %>% 
  left_join(my_ids_2013, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp13 <- tpp13 %>% 
  left_join(my_ids_2013, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp13 <- tcp13 %>% 
  left_join(my_ids_2013, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2013 <- abs2013 %>% 
  left_join(my_ids_2013, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  left_join(
    fp13 %>% select(c('DivisionNm', 'StateAb')) %>% unique(),
    on = 'DivisionNm'
  ) %>% 
  rename(
    State = StateAb
  ) %>% 
  mutate(
    State = toupper(State)
  ) %>% 
  select(
    UniqueID, DivisionNm, State, everything()
  )

# 2011
my_ids_2011 <- get_year_ids(year = 2010, my_ids = my_ids)

abs2011 <- abs2011 %>% 
  left_join(my_ids_2011, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    State = toupper(State)
  )

# 2010
my_ids_2010 <- get_year_ids(year = 2010, my_ids = my_ids)

fp10 <- fp10 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp10 <- tpp10 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp10 <- tcp10 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2010 <- abs2010 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  left_join(
    fp10 %>% select(c('DivisionNm', 'StateAb')) %>% unique(),
    on = 'DivisionNm'
  ) %>% 
  rename(
    State = StateAb
  ) %>% 
  mutate(
    State = toupper(State)
  ) %>% 
  select(
    UniqueID, DivisionNm, State, everything()
  )

# 2007
my_ids_2007 <- get_year_ids(year = 2007, my_ids = my_ids)

fp07 <- fp07 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp07 <- tpp07 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp07 <- tcp07 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2007 <- abs2007 %>% 
  left_join(my_ids_2010, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  left_join(
    fp07 %>% select(c('DivisionNm', 'StateAb')) %>% unique(),
    on = 'DivisionNm'
  ) %>% 
  rename(
    State = StateAb
  ) %>% 
  mutate(
    State = toupper(State)
  ) %>% 
  select(
    UniqueID, DivisionNm, State, everything()
  )

# 2006
my_ids_2006 <- get_year_ids(year = 2006, my_ids = my_ids)

abs2006 <- abs2006 %>% 
  left_join(my_ids_2006, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    State = toupper(State)
  )

# 2004
my_ids_2004 <- get_year_ids(year = 2004, my_ids = my_ids)

fp04 <- fp04 %>% 
  left_join(my_ids_2004, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp04 <- tpp04 %>% 
  left_join(my_ids_2004, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp04 <- tcp04 %>% 
  left_join(my_ids_2004, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2004 <- abs2004 %>% 
  left_join(my_ids_2004, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  left_join(
    fp04 %>% select(c('DivisionNm', 'StateAb')) %>% unique(),
    on = 'DivisionNm'
  ) %>% 
  rename(
    State = StateAb
  ) %>% 
  mutate(
    State = toupper(State)
  ) %>% 
  select(
    UniqueID, DivisionNm, State, everything()
  )

# 2001
my_ids_2001 <- get_year_ids(year = 2001, my_ids = my_ids)

fp01 <- fp01 %>% 
  left_join(my_ids_2001, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tpp01 <- tpp01 %>% 
  left_join(my_ids_2001, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

tcp01 <- tcp01 %>% 
  left_join(my_ids_2001, by = "DivisionNm") %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    StateAb = toupper(StateAb)
  )

abs2001 <- abs2001 %>% 
  left_join(my_ids_2001, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything()) %>% 
  mutate(
    State = toupper(State)
  )

# Save

usethis::use_data(fp22, overwrite = T, compress = "xz")
usethis::use_data(tcp22, overwrite = T, compress = "xz")
usethis::use_data(tpp22, overwrite = T, compress = "xz")
usethis::use_data(abs2021, overwrite = T, compress = "xz")
usethis::use_data(abs2019, overwrite = T, compress = "xz")
usethis::use_data(fp19, overwrite = T, compress = "xz")
usethis::use_data(tcp19, overwrite = T, compress = "xz")
usethis::use_data(tpp19, overwrite = T, compress = "xz")
usethis::use_data(abs2016, overwrite = T, compress = "xz")
usethis::use_data(fp16, overwrite = T, compress = "xz")
usethis::use_data(tcp16, overwrite = T, compress = "xz")
usethis::use_data(tpp16, overwrite = T, compress = "xz")
usethis::use_data(abs2013, overwrite = T, compress = "xz")
usethis::use_data(fp13, overwrite = T, compress = "xz")
usethis::use_data(tcp13, overwrite = T, compress = "xz")
usethis::use_data(tpp13, overwrite = T, compress = "xz")
usethis::use_data(abs2011, overwrite = T, compress = "xz")
usethis::use_data(abs2010, overwrite = T, compress = "xz")
usethis::use_data(fp10, overwrite = T, compress = "xz")
usethis::use_data(tcp10, overwrite = T, compress = "xz")
usethis::use_data(tpp10, overwrite = T, compress = "xz")
usethis::use_data(abs2007, overwrite = T, compress = "xz")
usethis::use_data(fp07, overwrite = T, compress = "xz")
usethis::use_data(tcp07, overwrite = T, compress = "xz")
usethis::use_data(tpp07, overwrite = T, compress = "xz")
usethis::use_data(abs2006, overwrite = T, compress = "xz")
usethis::use_data(abs2004, overwrite = T, compress = "xz")
usethis::use_data(fp04, overwrite = T, compress = "xz")
usethis::use_data(tcp04, overwrite = T, compress = "xz")
usethis::use_data(tpp04, overwrite = T, compress = "xz")
usethis::use_data(abs2001, overwrite = T, compress = "xz")
usethis::use_data(fp01, overwrite = T, compress = "xz")
usethis::use_data(tcp01, overwrite = T, compress = "xz")
usethis::use_data(tpp01, overwrite = T, compress = "xz")


# Remove my_ids objects from environment

objs = ls()[grepl("my_ids", ls())]
for (ob in objs) {remove(list=ob)}
remove(objs)