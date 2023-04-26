## Run this file to do all of the Census imputation for necessary elections
## All this file does is execute the other scripts in order

# Construct data frames for 2001 and 2006 Census SA1 data
source('data-raw/census-imputation-using-sa1/src/Census-to-Dataframe-Compact-CD.R')

# Construct data frame for 2011 Census SA1 data
source('data-raw/census-imputation-using-sa1/src/abs2011-SA1.R')

# Construct data frame for 2016 Census SA1 data
source('data-raw/census-imputation-using-sa1/src/abs2016-SA1.R')

# Map SA1s (collection districts, "CD") to electorates
source('data-raw/census-imputation-using-sa1/src/mapping-CD-to-electorate.R')

# Do imputation using the mapping and census data
source('data-raw/census-imputation-using-sa1/src/imputing-census-sa1.R')

## The imputed dataframes abs2019, abs2013, abs2010, abs2007, abs2004 can be found in the 'data' subdirectory
## of this folder. These dataframes are not final, as there needs to be another step to link them with the 
## election data over the years via UniqueIDs.