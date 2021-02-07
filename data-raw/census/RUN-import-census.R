## This script loads and wrangles census data (at electoral division level) for 2001, 2006, 2011 and 2016

## Download and unzip data for 2001 and 2006
source('data-raw/census/src/Download-Unzip-CensusData-CED.R')

## Import data and wrangle for 2001 and 2006
source('data-raw/census/src/Census-to-Dataframe-CED.R')

## Import and wrangle 2011
source('data-raw/census/src/abs2011-CED.R')

## Import and wrangle 2016
source('data-raw/census/src/abs2016-CED.R')

## The ABS census dataframes abs2001, abs2006, abs2011 and abs2016 can be found in the 'data' subdirectory
## of this folder. These dataframes are not final, as there needs to be another step to link them with the 
## election data over the years via UniqueIDs.
