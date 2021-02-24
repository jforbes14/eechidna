# eechidna 1.4.1 (2021-02-24)

* Resolved minor data quality issues for 2019 data: UniqueID, party labels and NAs

# eechidna 1.4.0 (2019-11-08)

* Revised imputation method for 2004, 2007, 2010 and 2013 data using SA1s
* Added SA1 centroid data from 2001, 2006, 2011 and 2016 Censuses
* Added election data, and imputed Census data, from the 2019 federal election
* Added `UniqueID` variable to datasets so that electorates can be tracked over time (note: these were manually assigned and an electorate inherits the same ID as an electorate in a previous election if these two electoral boundaries are roughly the same)
* Remove nat_map and nat_data objects from being loaded with eechidna, instead use the `nat_map_download` and `nat_data_download` functions to obtain these objects

# eechidna 1.3.0 (2019-03-15)

* Now covers all elections and Censuses between 2001-2016
* Includes polling booth data from each election (available using download functions in the pkg)
* Submitted to CRAN

# eechidna 1.1.0 (2019-01-23)

* Removed from CRAN

# eechidna 0.1.0 (2016-06-01)

* Added a `NEWS.md` file to track changes to the package (#8)
* Published on CRAN

# eechidna 0.1.0.9000

* `launchApp()` now displays densities, rather than dotplots, to avoid the potential confusion that each dot represents an electorate.
