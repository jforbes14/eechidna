# Check which abs dataframes are missing state
'State' %in% colnames(abs2001)
'State' %in% colnames(abs2004) # missing
'State' %in% colnames(abs2006)
'State' %in% colnames(abs2007) # missing
'State' %in% colnames(abs2010) # missing
'State' %in% colnames(abs2011)
'State' %in% colnames(abs2013) # missing
'State' %in% colnames(abs2016)
'State' %in% colnames(abs2019) # missing

# Every election year (imputed) is missing a state
# Get state from election data

# Check that there are matches for each election
abs2004$DivisionNm[which(!abs2004$DivisionNm %in% fp04$DivisionNm)]
abs2007$DivisionNm[which(!abs2007$DivisionNm %in% fp07$DivisionNm)]
abs2010$DivisionNm[which(!abs2010$DivisionNm %in% fp10$DivisionNm)]
abs2013$DivisionNm[which(!abs2013$DivisionNm %in% fp13$DivisionNm)]
abs2019$DivisionNm[which(!abs2019$DivisionNm %in% fp19$DivisionNm)]
# All fp objects have all division namnes
abs2004 %>% 
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

# Check State is present and capitalised
abs2001$State %>% unique()
abs2004$State %>% unique()
abs2006$State %>% unique()
abs2007$State %>% unique()
abs2010$State %>% unique()
abs2011$State %>% unique()
abs2013$State %>% unique()
abs2016$State %>% unique()
abs2019$State %>% unique()