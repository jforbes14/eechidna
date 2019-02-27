# Imputing Census information for electorates at the time of the 2004, 2007, 2010 and 2013 federal elections

library(tidyverse)
library(eechidna)

# ------------------------------------------------------------------------------------------------------

# Warning function to check that DivisionNm matches
divname_warning <- function(census_aec_1, census_aec_2) {
  if (sum(census_aec_1$DivisionNm == census_aec_2$DivisionNm) != 150) {
    warning("Division names do not match - check that the correct election shapefile has been used for both Censuses.")
  }
}

# ------------------------------------------------------------------------------------------------------

# 2013 Federal election
# Estimates use Census data aggregated at electorate level from 2011 and 2016

# Load shapefiles and Census
sF_11 <- sF_download(2011)
sF_13 <- sF_download(2013)
sF_16 <- sF_download(2016)
data("abs2011")
data("abs2016")

# Begin with estimating Census information for electoral boundaries at time of 2016 Census
# Use default threshold parameter
mapping_aec13_16 <- mapping_fn(aec_sF = sF_13, abs_sF = sF_16)
census_aec13_16 <- weighted_avg_census(mapping_df = mapping_aec13_16, abs_df = abs2016)

# Census information for electoral boundaries at time of 2011 Census
# Use default threshold parameter
mapping_aec13_11 <- mapping_fn(aec_sF = sF_13, abs_sF = sF_11)
census_aec13_11 <- weighted_avg_census(mapping_df = mapping_aec13_11, abs_df = abs2011)

# Check that DivisionNm matches
divname_warning(census_aec13_11, census_aec13_16)

# Linearly interpolate using inverse distance weighting (power of 1)
abs2013 <- (2/5)*(select(census_aec13_16, -DivisionNm)) + (3/5)*(select(census_aec13_11, -DivisionNm))

# Maintain division names
abs2013$DivisionNm <- census_aec13_16$DivisionNm

# Save
save(abs2013, file = "data/abs2013.rda")

# ------------------------------------------------------------------------------------------------------

# 2010 Federal election
# Estimates use Census data aggregated at electorate level from 2006 and 2011
# Note that 2006 Census is aggregated to electoral boundaries from the 2004 election, so we use this map

# Load shapefiles and Census
sF_04 <- sF_download(2004)
sF_10 <- sF_download(2010)
data("abs2006")

# Begin with estimating Census information for electoral boundaries at time of 2016 Census
# Use default threshold parameter
mapping_aec10_06 <- mapping_fn(aec_sF = sF_10, abs_sF = sF_04)
census_aec10_06 <- weighted_avg_census(mapping_df = mapping_aec10_06, abs_df = abs2006)

# Census information for electoral boundaries at time of 2011 Census
# Use default threshold parameter
mapping_aec10_11 <- mapping_fn(aec_sF = sF_10, abs_sF = sF_11)
census_aec10_11 <- weighted_avg_census(mapping_df = mapping_aec10_11, abs_df = abs2011)

# Check that DivisionNm matches
divname_warning(census_aec10_06, census_aec10_11)

# Linearly interpolate using inverse distance weighting (power of 1)
abs2010 <- (1/5)*(select(census_aec10_06, -DivisionNm)) + (4/5)*(select(census_aec10_11, -DivisionNm))

# Maintain division names
abs2010$DivisionNm <- census_aec10_11$DivisionNm

# Save
save(abs2010, file = "data/abs2010.rda")

# ------------------------------------------------------------------------------------------------------

# 2007 Federal election
# Estimates use Census data aggregated at electorate level from 2006 and 2011
# The 2006 Census data aggregated to electoral boundaries from the 2007 election is also available. This means that we don't have to do any estimate for 2006, but still do for 2011.

# Load shapefiles and Census
sF_11 <- sF_download(2007)
data("abs2006_e07")

# Census information for electoral boundaries at time of 2011 Census
# Use default threshold parameter
mapping_aec07_11 <- mapping_fn(aec_sF = sF_07, abs_sF = sF_11)
census_aec07_11 <- weighted_avg_census(mapping_df = mapping_aec07_11, abs_df = abs2011)

# 2006 Census information for the 2007 boundaries
census_aec07_06 <- abs2006_e07 %>% 
  select(-c(ends_with("NS"), Area, ID, State, Population))

# Check that DivisionNm matches
divname_warning(census_aec07_06, census_aec07_11)

# Linearly interpolate using inverse distance weighting (power of 1)
# Division name is removed due to * operation - ignore warning
abs2007 <- (4/5)*(select(census_aec07_06, -DivisionNm)) + (1/5)*(select(census_aec07_11, -DivisionNm))

# Maintain division names
abs2007$DivisionNm <- census_aec07_11$DivisionNm

# Save
save(abs2007, file = "data/abs2007.rda")

# ------------------------------------------------------------------------------------------------------

# 2004 Federal election
# Estimates use Census data aggregated at electorate level from 2001 and 2006
# The 2006 Census data aggregated to electoral boundaries from the 2004 election is available. This means that we don't have to do any estimate for 2006, but still do for 2001.

# Load shapefiles and Census
sF_01 <- sF_download(2001)
data("abs2006")
data("abs2001")

# Census information for electoral boundaries at time of 2011 Census
# Use default threshold parameter
mapping_aec04_01 <- mapping_fn(aec_sF = sF_04, abs_sF = sF_01)
census_aec04_01 <- weighted_avg_census(mapping_df = mapping_aec04_01, abs_df = abs2001) %>% 
  select(DivisionNm, everything())

# 2004 Census information for the 2007 boundaries
census_aec04_06 <- abs2006 %>% 
  select(-c(ends_with("NS"), Area, ID, State, Population))

# Check that DivisionNm matches
divname_warning(census_aec04_06, census_aec04_01)

# Linearly interpolate using inverse distance weighting (power of 1)
# Division name is removed due to * operation - ignore warning
abs2004 <- (2/5)*(select(census_aec04_01, -DivisionNm)) + (3/5)*(select(census_aec04_06, -DivisionNm))

# Maintain division names
abs2004$DivisionNm <- census_aec04_01$DivisionNm

# Save
save(abs2004, file = "data/abs2004.rda")
