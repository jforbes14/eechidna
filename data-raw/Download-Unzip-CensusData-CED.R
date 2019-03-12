#This script, when run, downloads the requires Commonwealth Electoral Division community profiles for 2001 and 2006. It then unzips the downloaded files and places them in the folders to be accessed by the Census-to-Dataframe file.

# Profiles are split into separate folders for ABS2001 and ABS2006, of which have folders for the Zipped and Unzipped files.

# ------------------------------------------------------------------------------------------------------------

# Download Census data for each CED, 2001

# CED List

CED_list_2001 <- read.csv("data-raw/supplement/CED_Definitions/CED2001.csv")
CED_no_2001 <- CED_list_2001$CED


# Loop over each CED for 2001
url_p1 = "http://www.censusdata.abs.gov.au/CensusOutput/copsub2006.NSF/All%20docs%20by%20catNo/2001~Community%20Profile~CED"
url_p2 = "/$File/BCP_CED"
url_p3 = ".zip?OpenElement"

for (i in 1:length(CED_no_2001)) {
  CED <- toString(CED_no_2001[i])
  url_temp <- paste0(url_p1, CED, url_p2, CED, url_p3)
  dest_temp = paste0("data-raw/ABS2001/Zipped/CED", CED, ".zip") #set destination directory
  download.file(url_temp, dest_temp, quiet = TRUE)
}


# Unzip abs 2001
zip_p1 <- "data-raw/ABS2001/Zipped/CED"
zip_p2 <- ".zip"

for (i in 1:length(CED_no_2001)) {
  CED <- toString(CED_no_2001[i])
  zip_temp <- paste0(zip_p1, CED, zip_p2)
  unzip(zip_temp, exdir = "data-raw/ABS2001/Unzipped", overwrite = TRUE) #set destination directory
}


# ------------------------------------------------------------------------------------------------------------


#Download Census data for each CED, 2006 - using 2004 boundaries

# CED list 2006 with 2004 boundaries
CED_list_2006_04 <- read.csv("data-raw/supplement/CED_Definitions/CED2006_04.csv")
CED_no_2006_04 <- CED_list_2006_04$CED

# Loop over each CED for 2006
url_p1 = "http://www.censusdata.abs.gov.au/CensusOutput/copsub2006.NSF/All%20docs%20by%20catNo/2006~Community%20Profile~CED"
url_p2 = "/$File/BCP_CED"
url_p3 = ".zip?OpenElement"

for (i in 1:length(CED_no_2006_04)) {
  CED <- toString(CED_no_2006_04[i])
  url_temp <- paste0(url_p1, CED, url_p2, CED, url_p3)
  dest_temp = paste0("data-raw/ABS2006/Zipped/CED2004/CED", CED, ".zip") #set destination directory
  download.file(url_temp, dest_temp, quiet = TRUE)
}


# Unzip
zip_p1 <- "data-raw/ABS2006/Zipped/CED2004/CED"
zip_p2 <- ".zip"

for (i in 1:length(CED_no_2006_04)) {
  CED <- toString(CED_no_2006_04[i])
  zip_temp <- paste0(zip_p1, CED, zip_p2)
  unzip(zip_temp, exdir = "data-raw/ABS2006/Unzipped/CED2004", overwrite = TRUE) #set destination directory
}


# ------------------------------------------------------------------------------------------------------------

# Download Census data for each CED, 2006 - using 2007 boundaries
library(RCurl)

CED_list_full <- read.csv("data-raw/supplement/CED_Definitions/CED2006_07.csv")
CED_no_2006_07 <- CED_list_full$CED

# Loop over each CED for 2006 (Boundaries 2007)
  
  url_p1 = "http://www.censusdata.abs.gov.au/CensusOutput/copsub2006.NSF/All%20docs%20by%20catNo/2006~Community%20Profile~CED07"
  url_p2 = "/$File/BCP_CED07"
  url_p3 = ".zip?OpenElement"
  
  CED_no_2006_07 = c(0)
  for (i in 100:1000) {
  CED <- toString(i)
  url_temp <- paste0(url_p1, CED, url_p2, CED, url_p3)
  dest_temp = paste0("data-raw/ABS2006/Zipped/CED2007/CED", CED, ".zip") #set destination directory
  if (url.exists(url_temp) == TRUE) {download.file(url_temp, dest_temp, quiet = TRUE)} else {}
  }
  
  # Get IDs
  CED_no_2006_07 <- list.files("data-raw/ABS2006/Zipped/CED2007") %>%
  substr(4,6)
  
  # Unzip
  zip_p1 <- "data-raw/ABS2006/Zipped/CED2007/CED"
  zip_p2 <- ".zip"
  
  for (i in 1:length(CED_no_2006_07)) {
  CED <- toString(CED_no_2006_07[i])
  zip_temp <- paste0(zip_p1, CED, zip_p2)
  unzip(zip_temp, exdir = "data-raw/ABS2006/Unzipped/CED2007", overwrite = TRUE) #set destination directory
  }
  
  # Trimming file names
  temp <- list.files("data-raw/ABS2006/Unzipped/CED2007") 
  
  for (i in 1:length(temp)) {
  file_name <- paste0("data-raw/ABS2006/Unzipped/CED2007/", temp[i])
  file.rename(from = file_name,
  to = gsub(" ", "", file_name))
  }
  
  remove(temp)
  

  CED_name_2006_e07 <- list.files("data-raw/ABS2006/Unzipped/CED2007")
  
  CED_list_2006_e07 <- data.frame(CED = CED_no_2006_07, Electorate = 0, State = 0)
  
  for (i in 1:length(CED_name_2006_e07)) {
  CED_list_2006_e07$Electorate[i] = substr(strsplit(strsplit(CED_name_2006_e07[i], 'CED')[[1]][1], 'BCP-')[[1]][2],1,nchar(strsplit(strsplit(CED_name_2006_e07[i], 'CED')[[1]][1], 'BCP-')[[1]][2]) - 1)
  CED_list_2006_e07$State[i] = substr(strsplit(strsplit(CED_name_2006_e07[i], '07' )[[1]][2], 'Com')[[1]][1], 3, nchar(strsplit(strsplit(CED_name_2006_e07[i], '07' )[[1]][2], 'Com')[[1]][1]) - 1)
  }
  
  
  
  