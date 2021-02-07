## This script loads and wrangles election data for 2001, 2004, 2007, 2010, 2013, 2016 and 2019

## Download and unzip data for 2001 and 2006
source('data-raw/elections/src/all-electorate-votes.R')

## The dataframes (`tcp`, `tpp` and `fp` for each year) can be found in the 'data' subdirectory
## of this folder. These dataframes are not final, as there needs to be another step to link them with the 
## census data over the years via UniqueIDs.
