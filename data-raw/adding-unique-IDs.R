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
  full_join(abs2013 %>% select(DivisionNm)) %>% 
  full_join(abs2010 %>% select(DivisionNm)) %>% 
  full_join(abs2007 %>% select(DivisionNm)) %>% 
  full_join(abs2004 %>% select(DivisionNm)) %>% 
  full_join(abs2001 %>% select(DivisionNm))

# Add UniqueID for divisions that changed their name and for divisions that were abolished before 2016
# Renamed electorates: FRASER became FENNER, PROSPECT became MCMAHON, THROSBY became WHITLAM

my_ids <- my_ids %>% 
  mutate(UniqueID = ifelse(DivisionNm == "BONYTHON", 412, 
    ifelse(DivisionNm == "BURKE", 238, 
      ifelse(DivisionNm == "CHARLTON", 148,  
          ifelse(DivisionNm == "FRASER", 802, 
            ifelse(DivisionNm == "GWYDIR", 149,
            ifelse(DivisionNm == "KALGOORLIE", 517,
              ifelse(DivisionNm == "LOWE", 150,
                ifelse(DivisionNm == "PROSPECT", 128,
                  ifelse(DivisionNm == "THROSBY", 147, UniqueID
        ))))))))))

save(my_ids, file = "data-raw/supplement/my_ids.rda")

# Now replace any existing IDs

load("data-raw/supplement/my_ids.rda")

# 2016

fp16 <- fp16 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tpp16 <- tpp16 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tcp16 <- tcp16 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

abs2016 <- abs2016 %>% 
  rename(UniqueID = ID)

# 2013

fp13 <- fp13 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tpp13 <- tpp13 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tcp13 <- tcp13 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

abs2013 <- abs2013 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

# 2011

abs2011 <- abs2011 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything())

# 2010

fp10 <- fp10 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tpp10 <- tpp10 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tcp10 <- tcp10 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

abs2010 <- abs2010 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

# 2007

fp07 <- fp07 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tpp07 <- tpp07 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tcp07 <- tcp07 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

abs2007 <- abs2007 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

# 2006

abs2006 <- abs2006 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything())

abs2006_e07 <- abs2006_e07 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything())

# 2004

fp04 <- fp04 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tpp04 <- tpp04 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

tcp04 <- tcp04 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-DivisionID) %>% 
  select(UniqueID, everything())

abs2004 <- abs2004 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

# 2001

fp01 <- fp01 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

tpp01 <- tpp01 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

tcp01 <- tcp01 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(UniqueID, everything())

abs2001 <- abs2001 %>% 
  left_join(my_ids, by = "DivisionNm") %>% 
  select(-ID) %>% 
  select(UniqueID, everything())

# Save

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
usethis::use_data(abs2006_e07, overwrite = T, compress = "xz")
usethis::use_data(abs2006, overwrite = T, compress = "xz")
usethis::use_data(abs2004, overwrite = T, compress = "xz")
usethis::use_data(fp04, overwrite = T, compress = "xz")
usethis::use_data(tcp04, overwrite = T, compress = "xz")
usethis::use_data(tpp04, overwrite = T, compress = "xz")
usethis::use_data(abs2001, overwrite = T, compress = "xz")
usethis::use_data(fp01, overwrite = T, compress = "xz")
usethis::use_data(tcp01, overwrite = T, compress = "xz")
usethis::use_data(tpp01, overwrite = T, compress = "xz")