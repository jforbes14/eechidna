## This script loads and saves the shapefiles containing geographic boundaries for censuses, elections
## and more (e.g. states).

## Load and save the shapefiles
source('data-raw/maps/src/load-and-save-shapefiles.R')

## Generate placeholder dataframes for `nat_map` and `nat_data` objects
source('data-raw/maps/src/nat_map_and_data_placeholders.R')
