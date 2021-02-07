# This script, when run, builds three data frames. One holding metrics relating to the 2001 Census, one for the 2006 Census aggregated to 2004 electoral divisions, and one for the 2006 Census aggregated to 2007 electoral divisions . It draws on the following files that are imported (sometimes within loops).

# Census Community Profiles: must be downloaded and unzipped using the "Download-Unzip-CensusData-CED.Rmd"

# ------------------------------------------------------------------------------------------------------------

require(tidyverse)
require(readxl)

# Begin by loading CED (Commonwealth electoral division) lists

CED_list_2001 <- read.csv("data-raw/supplement/CED_Definitions/CED2001.csv")

CED_list_2006_04 <- read.csv("data-raw/supplement/CED_Definitions/CED2006_04.csv")
CED_list_2006_04$State <- as.character(CED_list_2006_04$State)

for (i in 1:nrow(CED_list_2006_04)) {
  if(CED_list_2006_04$State[i] == "VIC") {
    CED_list_2006_04$State[i] <- "Vic"
  }
  else if(CED_list_2006_04$State[i] == "QLD") {
    CED_list_2006_04$State[i] <- "Qld"
  }
  else if(CED_list_2006_04$State[i] == "TAS") {
    CED_list_2006_04$State[i] <- "Tas"
  }
}

CED_list_2006_e07 <- read.csv("data-raw/supplement/CED_Definitions/CED2006_07.csv")
CED_list_2006_e07$State <- as.character(CED_list_2006_e07$State)

for (i in 1:nrow(CED_list_2006_e07)) {
  if(CED_list_2006_e07$State[i] == "VIC") {
    CED_list_2006_e07$State[i] <- "Vic"
  }
  if(CED_list_2006_e07$State[i] == "QLD") {
    CED_list_2006_e07$State[i] <- "Qld"
  }
  if(CED_list_2006_e07$State[i] == "TAS") {
    CED_list_2006_e07$State[i] <- "Tas"
  }
}
CED_list_2006_e07$Electorate <- tolower(CED_list_2006_e07$Electorate)

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
    sep="", collapse=" ")
}

for (i in 1:nrow(CED_list_2006_e07)) {
  CED_list_2006_e07$Electorate[i] <- simpleCap(CED_list_2006_e07$Electorate[i])
}

CED_list_2006_e07$Electorate[44] <- "Eden-Monaro"

CED_list_2006_e07$Electorate[117] <- "O'Connor"

CED_list_2006_e07$Electorate_Names <- CED_list_2006_e07$Electorate
CED_list_2006_e07$Electorate <- gsub(" ", "", CED_list_2006_e07$Electorate)

# ------------------------------------------------------------------------------------------------------------

# Creating blank data frames

abs2001 <- data.frame(ID = CED_list_2001$CED, Electorate = CED_list_2001$Electorate, State = CED_list_2001$State, Population = 0, Area = 0, MedianPersonalIncome = 0, Unemployed = 0, LFParticipation = 0, BachelorAbv = 0, Christianity = 0, Catholic = 0, Buddhism = 0, Islam = 0, Judaism = 0, NoReligion = 0, Age00_04 = 0, Age05_14 = 0, Age15_19 = 0, Age20_24 = 0, Age25_34 = 0, Age35_44 = 0, Age45_54 = 0, Age55_64 = 0, Age65_74 = 0, Age75_84 = 0, Age85plus = 0, BornOverseas = 0, Indigenous = 0, EnglishOnly = 0, OtherLanguageHome = 0, Married = 0, DeFacto = 0, FamilyRatio = 0, CurrentlyStudying = 0, HighSchool = 0, InternetUse = 0, InternetAccess = 0, AusCitizen = 0, AverageHouseholdSize = 0, MedianHouseholdIncome = 0, MedianFamilyIncome = 0, MedianRent = 0, MedianLoanPay = 0, MedianAge = 0, EmuneratedElsewhere = 0, Volunteer = 0, PersonalIncome_NS = 0, FamilyIncome_NS = 0, HouseholdIncome_NS = 0, Rent_NS = 0, Religion_NS = 0, BornOverseas_NS = 0, Language_NS = 0, Tenure_NS = 0, HighSchool_NS = 0, InternetUse_NS = 0, University_NS = 0, Volunteer_NS = 0, InternetAccess_NS = 0, SP_House = 0, Couple_NoChild_House = 0, OneParent_House = 0, Couple_WChild_House = 0, Owned = 0, Mortgage = 0, Renting = 0, PublicHousing = 0, Born_UK = 0, Born_SE_Europe = 0, Born_MidEast = 0, Born_Asia = 0, DiffAddress = 0, Extractive = 0, Transformative = 0, Distributive = 0, Finance = 0, SocialServ = 0, ManagerAdminClericalSales = 0, Professional = 0, Tradesperson = 0, Laborer = 0, DipCert = 0, Anglican = 0, OtherChrist = 0, Other_NonChrist = 0)

abs2006 <- abs2001 %>% 
  mutate(ID = CED_list_2006_04$CED,
    Electorate = CED_list_2006_04$Electorate, 
    State = CED_list_2006_04$State)

abs2006_e07 <- abs2001 %>% 
  mutate(ID = CED_list_2006_e07$CED,
    Electorate = CED_list_2006_e07$Electorate, 
    State = CED_list_2006_e07$State)

# ------------------------------------------------------------------------------------------------------------

# Construction of 2001 Census

# Each of the following chunks corresponds with a particular sheet, which may have numerous metrics derived from it. 

# B 01

sheet_ref <- "B 01"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Metrics
  a <- as.character(temp_sheet[1,1], " ")
  abs2001$Area[i] = as.numeric(strsplit(a, " ")[[1]][lengths(strsplit(a, " ")) - 2])
  
  
  popl = as.numeric(temp_sheet[8,4]) - as.numeric(temp_sheet[32,4]) #less overseas visitors
  
  abs2001$Population[i] = popl
  
  abs2001$BornOverseas[i] = (as.numeric(temp_sheet[19,4])/(as.numeric(temp_sheet[18,4])+as.numeric(temp_sheet[19,4])))*100 #removed not stated implicitly
  
  abs2001$Indigenous[i] = (as.numeric(temp_sheet[24,4])/popl)*100
  
  abs2001$EnglishOnly[i] = (as.numeric(temp_sheet[21,4])/(as.numeric(temp_sheet[21,4])+as.numeric(temp_sheet[22,4])))*100 #removed not stated implicitly
  
  abs2001$OtherLanguageHome[i] = 100 - abs2001$EnglishOnly[i]
  
  abs2001$AusCitizen[i] = (as.numeric(temp_sheet[26,4])/popl)*100
  
  abs2001$EmuneratedElsewhere[i] = (as.numeric(temp_sheet[30,4])/as.numeric(temp_sheet[8,4]))*100 #includes overseas visitors in numerator and denomenator
}


# B 03

sheet_ref <- "B 03"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  #Metrics
  abs2001$Age00_04[i] = (as.numeric(temp_sheet[13,4])/popl)*100
  
  abs2001$Age05_14[i] = ((as.numeric(temp_sheet[19,4])+as.numeric(temp_sheet[25,4]))/popl)*100
  
  abs2001$Age15_19[i] = (as.numeric(temp_sheet[31,4])/popl)*100
  
  abs2001$Age20_24[i] = (as.numeric(temp_sheet[37,4])/popl)*100
  
  abs2001$Age25_34[i] = ((as.numeric(temp_sheet[43,4])+as.numeric(temp_sheet[13,9]))/popl)*100
  
  abs2001$Age35_44[i] = ((as.numeric(temp_sheet[19,9])+as.numeric(temp_sheet[25,9]))/popl)*100
  
  abs2001$Age45_54[i] = ((as.numeric(temp_sheet[31,9])+as.numeric(temp_sheet[37,9]))/popl)*100
  
  abs2001$Age55_64[i] = ((as.numeric(temp_sheet[43,9])+as.numeric(temp_sheet[13,14]))/popl)*100
  
  abs2001$Age65_74[i] = ((as.numeric(temp_sheet[19,14])+as.numeric(temp_sheet[25,14]))/popl)*100
  
  abs2001$Age75_84[i] = ((as.numeric(temp_sheet[31,14])+as.numeric(temp_sheet[32,14]))/popl)*100
  
  abs2001$Age85plus[i] = ((as.numeric(temp_sheet[33,14])+as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[36,14]))/popl)*100
}


# B_04

sheet_ref <- "B 04"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Married
  abs2001$Married[i] = ((as.numeric(temp_sheet[26,2]) + as.numeric(temp_sheet[26,3]) - as.numeric(temp_sheet[24,2]) - as.numeric(temp_sheet[24,3])) / (as.numeric(temp_sheet[26,19]) - as.numeric(temp_sheet[24,19]))) * 100 #only % of respondents
}


# B 07A and B 07B

sheet_ref <- "B 07A"
sheet_refB <- "B 07B"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  temp_sheetB <- read_excel(excel_ref, sheet = sheet_refB)
  
  #Birthplace
  abs2001$Born_MidEast[i] = (as.numeric(temp_sheet[30,4]) / (as.numeric(temp_sheetB[37,4]) -  as.numeric(temp_sheet[35,4]))) * 100 #only % of respondents
  
  abs2001$Born_SE_Europe[i] = (as.numeric(temp_sheet[25,4]) / (as.numeric(temp_sheetB[37,4]) -  as.numeric(temp_sheet[35,4]))) * 100 #only % of respondents
  
  abs2001$Born_UK[i] = (as.numeric(temp_sheet[14,4]) / (as.numeric(temp_sheetB[37,4]) -  as.numeric(temp_sheet[35,4]))) * 100 #only % of respondents
  
  abs2001$Born_Asia[i] = ((as.numeric(temp_sheet[37,4]) + as.numeric(temp_sheetB[11,4]) + as.numeric(temp_sheetB[17,4])) / (as.numeric(temp_sheetB[37,4]) -  as.numeric(temp_sheet[35,4]))) * 100 #only % of respondents
  
}


# B 10

sheet_ref <- "B 10"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[36,4]) - as.numeric(temp_sheet[37,4]) #remove not stated, inadequately described
  
  #Metric
  abs2001$Christianity[i] = (as.numeric(temp_sheet[27,4])/popl)*100
  abs2001$Catholic[i] = (as.numeric(temp_sheet[13,4])/popl)*100
  abs2001$Anglican[i] = (as.numeric(temp_sheet[10,4])/popl)*100
  
  abs2001$OtherChrist[i] = ((as.numeric(temp_sheet[27,4]) - as.numeric(temp_sheet[10,4]) - as.numeric(temp_sheet[13,4]))/popl)*100
  
  abs2001$Buddhism[i] = (as.numeric(temp_sheet[8,4])/popl)*100
  abs2001$Islam[i] = (as.numeric(temp_sheet[29,4])/popl)*100
  abs2001$Judaism[i] = (as.numeric(temp_sheet[30,4])/popl)*100
  abs2001$NoReligion[i] = (as.numeric(temp_sheet[35,4])/popl)*100
  
  abs2001$Religion_NS[i] = (as.numeric(temp_sheet[37,4]) / popl)*100
  abs2001$Other_NonChrist[i] = 100 - abs2001$NoReligion[i] - abs2001$Christianity[i]
  
}


# B 11

sheet_ref <- "B 11"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[35,4]) #remove not stated*
  
  #Metric
  abs2001$CurrentlyStudying[i] = (1 - as.numeric(temp_sheet[34,4])/popl) * 100
}


# B 12

sheet_ref <- "B 12"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[17,4])
  #question_popl = as.numeric(temp_sheet[17,4]) - as.numeric(temp_sheet[15,4]) #people aged 15+, remove not stated
  
  #Percentage of total population that have finished high school
  abs2001$HighSchool[i] = (as.numeric(temp_sheet[12,4])/popl) * 100
  abs2001$HighSchool_NS[i] = (as.numeric(temp_sheet[15,4]) / popl)*100 #not stated out of the over 15 population
}


# B 14

sheet_ref <- "B 14"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  question_popl = as.numeric(temp_sheet[57,10])
  
  #Percentage of total population are in a DeFacto marriage
  abs2001$DeFacto[i] = (as.numeric(temp_sheet[45,10])/question_popl) * 100
}


# B 16

sheet_ref <- "B 16"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[18,4]) #remove not stated
  
  #Percentage of total population that used internet in last week
  abs2001$InternetUse[i] = (as.numeric(temp_sheet[16,4])/popl) * 100
}


# B 17

sheet_ref <- "B 17"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Family ratio = people / families
  abs2001$FamilyRatio[i] = (as.numeric(temp_sheet[32,6])/as.numeric(temp_sheet[32,2]))
  
  # Couple without children household
  abs2001$Couple_NoChild_House[i] = (as.numeric(temp_sheet[18,2])/as.numeric(temp_sheet[32,2]))*100
  
  # One parent family household
  abs2001$OneParent_House[i] = (as.numeric(temp_sheet[28,2])/as.numeric(temp_sheet[32,2]))*100
  
  # Couples with children household
  abs2001$Couple_WChild_House[i] = (as.numeric(temp_sheet[16,2])/as.numeric(temp_sheet[32,2]))*100
}


# B 19

sheet_ref <- "B 19"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  tot_houses <- as.numeric(temp_sheet[19,11]) - as.numeric(temp_sheet[19,10])
  
  abs2001$Tenure_NS[i] = (as.numeric(temp_sheet[19,10]) / as.numeric(temp_sheet[19,11]))*100 #% not stated
  
  abs2001$Owned[i] = (as.numeric(temp_sheet[19,2])/tot_houses) * 100 #excludes not stated
  
  abs2001$Mortgage[i] = ((as.numeric(temp_sheet[19,3])+as.numeric(temp_sheet[19,4]))/tot_houses) * 100 #excludes not stated
  
  abs2001$Renting[i] = (as.numeric(temp_sheet[19,8])/tot_houses) * 100 #excludes not stated
  
  abs2001$PublicHousing[i] = (as.numeric(temp_sheet[19,5])/tot_houses) * 100 #excludes not stated
  
}


# B 22

sheet_ref <- "B 22"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Unemployment Rate
  abs2001$Unemployed[i] = as.numeric(temp_sheet[16,4]) * 100 #Unemployed / Labour Force
  
  # Labor force participation
  abs2001$LFParticipation[i] = (as.numeric(temp_sheet[14,4]) / (as.numeric(temp_sheet[14,4])+as.numeric(temp_sheet[15,4]))) * 100 #LF participation rate
  
  # Same address as 5 years ago
  abs2001$DiffAddress[i] = (as.numeric(temp_sheet[22,4])/(as.numeric(temp_sheet[22,4])+as.numeric(temp_sheet[21,4]))) * 100 #Unemployed / Labour Force
  
}


# B 23

sheet_ref <- "B 23"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl <- abs2001$Population[i]
  popl_15 <- popl*(100 - abs2006$Age00_04[i] - abs2006$Age05_14[i])/100 
  #question_popl <- as.numeric(temp_sheet[16,4]) - as.numeric(temp_sheet[13,4]) #Excludes not stated from total pop over 15
  
  #Bachelor and above
  abs2001$BachelorAbv[i] = ((as.numeric(temp_sheet[8,4]) + as.numeric(temp_sheet[9,4]) + as.numeric(temp_sheet[10,4])) / popl_15) * 100
  abs2001$University_NS = (as.numeric(temp_sheet[13,4]) / popl_15)*100 #not stated (includes inadequately described) out of age 15+
  
  # Diploma or Certificate
  abs2001$DipCert[i] = ((as.numeric(temp_sheet[11,4]) + as.numeric(temp_sheet[12,4]))/ popl_15) * 100
}


# B 26B

sheet_ref <- "B 26B"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[30,9])
  #question_popl <- as.numeric(temp_sheet[30,9]) - as.numeric(temp_sheet[28,9])
  
  # Industry of employment
  abs2001$Extractive[i] = ((as.numeric(temp_sheet[10,9]) + as.numeric(temp_sheet[11,9]) + as.numeric(temp_sheet[13,9])) / popl) * 100
  abs2001$Transformative[i] = ((as.numeric(temp_sheet[12,9]) + as.numeric(temp_sheet[14,9])) / popl) * 100
  abs2001$Distributive[i] = ((as.numeric(temp_sheet[15,9]) + as.numeric(temp_sheet[16,9]) + as.numeric(temp_sheet[18,9])) / popl) * 100
  abs2001$Finance[i] = (as.numeric(temp_sheet[20,9]) / popl) * 100
  abs2001$SocialServ[i] = ((as.numeric(temp_sheet[23,9]) + as.numeric(temp_sheet[24,9]) + as.numeric(temp_sheet[25,9])) / popl) * 100
}



# B 27B

sheet_ref <- "B 27B"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[22,9])
  #question_popl <- as.numeric(temp_sheet[22,9]) - as.numeric(temp_sheet[20,9])- as.numeric(temp_sheet[19,9]) #excludes inadequately answered and not stated
  
  # Occupation 
  abs2001$ManagerAdminClericalSales[i] = ((as.numeric(temp_sheet[10,9]) + as.numeric(temp_sheet[14,9]) + as.numeric(temp_sheet[15,9]) + as.numeric(temp_sheet[17,9])) / popl) * 100
  abs2001$Professional[i] = ((as.numeric(temp_sheet[11,9])) / popl) * 100
  abs2001$Tradesperson[i] = (as.numeric(temp_sheet[13,9]) / popl) * 100
  abs2001$Laborer[i] = (as.numeric(temp_sheet[18,9]) / popl) * 100
  
}



# B 32

sheet_ref <- "B 32"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  # Single person household (% of households)
  abs2001$SP_House[i] = (as.numeric(temp_sheet[10,7])/as.numeric(temp_sheet[17,7])) * 100
}




# B 33
# This deals with medians, which only have ranges - decided to use midpoint of range

sheet_ref <- "B 33"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #All Medians are weekly
  #Median Income
  a <- strsplit(temp_sheet[9,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001$MedianPersonalIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HouseHoldSize
  abs2001$AverageHouseholdSize[i] = as.numeric(temp_sheet[12,2])
  
  #Median FamilyIncome
  a <- strsplit(temp_sheet[10,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001$MedianFamilyIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HouseholdIncome
  a <- strsplit(temp_sheet[11,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001$MedianHouseholdIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median Rent
  a <- strsplit(temp_sheet[8,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001$MedianRent[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HousingLoanPayments
  a <- strsplit(temp_sheet[7,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001$MedianLoanPay[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median Age
  abs2001$MedianAge[i] = as.numeric(temp_sheet[6,2])
}


# Additional sheets - determine percentage of population that are not answering the question.

#BornOverseas
sheet_ref <- "B 06"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  abs2001$BornOverseas_NS[i] = (as.numeric(temp_sheet[40,4]) / popl)*100
}

#Language_NS
sheet_ref <- "B 08"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  abs2001$Language_NS[i] = (as.numeric(temp_sheet[46,4]) / popl)*100
}

#PersonalIncome_NS
sheet_ref <- "B 13B"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2001$PersonalIncome_NS[i] = (as.numeric(temp_sheet[25,10]) / as.numeric(temp_sheet[28,10]))*100
}

#InternetUse_NS
sheet_ref <- "B 16"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  abs2001$InternetUse_NS[i] = (as.numeric(temp_sheet[18,4]) / popl)*100
}

#Rent_NS
sheet_ref <- "B 21"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2001$Rent_NS[i] = (as.numeric(temp_sheet[19,6]) / as.numeric(temp_sheet[21,6]))*100
}

#FamilyIncome_NS
sheet_ref <- "B 30"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  abs2001$FamilyIncome_NS[i] = ((as.numeric(temp_sheet[22,6]) + as.numeric(temp_sheet[23,6])) / as.numeric(temp_sheet[25,6]))*100 #includes some incomes not stated and all incomes not stated
}

#HouseholdIncome_NS
sheet_ref <- "B 31"

for (i in 1:nrow(CED_list_2001)) {
  CED <- CED_list_2001$CED[i]
  excel_ref <- paste0("data-raw/census/data/ABS2001/Unzipped/BCP_CED", CED, ".xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2001$Population[i]
  
  abs2001$HouseholdIncome_NS[i] = ((as.numeric(temp_sheet[22,4]) + as.numeric(temp_sheet[23,4])) / as.numeric(temp_sheet[25,4]))*100 #includes some incomes not stated and all incomes not stated
}


# ------------------------------------------------------------------------------------------------------------


# 2006 Using 2004 CED boundaries.

#B 01a

sheet_ref <- "B 01a"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Metrics
  abs2006$Area[i] = as.numeric(strsplit(strsplit(temp_sheet[1,1][[1]], ") ")[[1]][2], " sq")[[1]][1])
  
  popl = as.numeric(temp_sheet[9,4])
  
  abs2006$Population[i] = popl
  
  abs2006$BornOverseas[i] = (as.numeric(temp_sheet[36,4])/(as.numeric(temp_sheet[36,4])+as.numeric(temp_sheet[35,4])))*100 #not stated implicitly excluded
  
  abs2006$Indigenous[i] = (as.numeric(temp_sheet[32,4])/popl)*100
  
  abs2006$EnglishOnly[i] = (as.numeric(temp_sheet[39,4])/(as.numeric(temp_sheet[39,4])+as.numeric(temp_sheet[40,4])))*100 #not stated implicitly excluded
  
  abs2006$OtherLanguageHome[i] = 100 - abs2006$EnglishOnly[i]
  
  abs2006$AusCitizen[i] = (as.numeric(temp_sheet[42,4])/popl)*100
}


# B_02

sheet_ref <- "B 02"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #All Medians are weekly
  abs2006$MedianPersonalIncome[i] = as.numeric(temp_sheet[10,2])
  
  abs2006$AverageHouseholdSize[i] = as.numeric(temp_sheet[14,5])
  
  abs2006$MedianHouseholdIncome[i] = as.numeric(temp_sheet[14,2])
  
  abs2006$MedianFamilyIncome[i] = as.numeric(temp_sheet[12,2])
  
  abs2006$MedianRent[i] = as.numeric(temp_sheet[10,5])
  
  abs2006$MedianLoanPay[i] = as.numeric(temp_sheet[8,5])
  
  #Median Age
  abs2006$MedianAge[i] = as.numeric(temp_sheet[8,2])
}


# B 04

sheet_ref <- "B 04"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006$Population[i]
  
  #Metrics
  abs2006$Age00_04[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  
  abs2006$Age05_14[i] = ((as.numeric(temp_sheet[22,4])+as.numeric(temp_sheet[28,4]))/popl)*100
  
  abs2006$Age15_19[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  
  abs2006$Age20_24[i] = (as.numeric(temp_sheet[40,4])/popl)*100
  
  abs2006$Age25_34[i] = ((as.numeric(temp_sheet[46,4])+as.numeric(temp_sheet[16,9]))/popl)*100
  
  abs2006$Age35_44[i] = ((as.numeric(temp_sheet[22,9])+as.numeric(temp_sheet[28,9]))/popl)*100
  
  abs2006$Age45_54[i] = ((as.numeric(temp_sheet[34,9])+as.numeric(temp_sheet[40,9]))/popl)*100
  
  abs2006$Age55_64[i] = ((as.numeric(temp_sheet[46,9])+as.numeric(temp_sheet[16,14]))/popl)*100
  
  abs2006$Age65_74[i] = ((as.numeric(temp_sheet[22,14])+as.numeric(temp_sheet[28,14]))/popl)*100
  
  abs2006$Age75_84[i] = ((as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[35,14]))/popl)*100
  
  abs2006$Age85plus[i] = ((as.numeric(temp_sheet[36,14])+as.numeric(temp_sheet[37,14])+as.numeric(temp_sheet[38,14])+as.numeric(temp_sheet[39,14]))/popl)*100
}


# B 06

sheet_ref <- "B 06"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl <- abs2006$Population[i]
  popl_15 <- popl - abs2006$Age00_04[i] - abs2006$Age05_14[i]
  question_popl = as.numeric(temp_sheet[49,5])
  
  #Percentage of DeFacto
  abs2006$DeFacto[i] = (as.numeric(temp_sheet[49,3])/question_popl) * 100
  abs2006$Married[i] = (as.numeric(temp_sheet[49,2])/question_popl) * 100
}


# B 09

sheet_ref <- "B 09"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[47,4]) 
  #question_popl = as.numeric(temp_sheet[47,4]) - as.numeric(temp_sheet[45,4])
  
  #Birthplace
  abs2006$Born_MidEast[i] = ((
    as.numeric(temp_sheet[14,4]) + as.numeric(temp_sheet[22,4]) + as.numeric(temp_sheet[27,4]) + as.numeric(temp_sheet[40,4]) + as.numeric(temp_sheet[14,4]) ) / popl) * 100 
  
  abs2006$Born_SE_Europe[i] = ((
    as.numeric(temp_sheet[10,4]) + as.numeric(temp_sheet[13,4]) + as.numeric(temp_sheet[16,4]) + as.numeric(temp_sheet[18,4]) + as.numeric(temp_sheet[37,4]) ) / popl) * 100 
  
  abs2006$Born_UK[i] = (as.numeric(temp_sheet[41,4]) / popl) * 100 #only % of respondents
  
  abs2006$Born_Asia[i] = ((
    as.numeric(temp_sheet[12,4]) + as.numeric(temp_sheet[20,4]) + as.numeric(temp_sheet[21,4]) + as.numeric(temp_sheet[25,4]) + as.numeric(temp_sheet[26,4]) + as.numeric(temp_sheet[28,4]) + as.numeric(temp_sheet[33,4]) + as.numeric(temp_sheet[35,4]) + as.numeric(temp_sheet[38,4]) + as.numeric(temp_sheet[39,4]) + as.numeric(temp_sheet[43,4]) ) / popl) * 100 
  
}


# B 13

sheet_ref <- "B 13"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[41,4]) - as.numeric(temp_sheet[40,4]) #remove not stated and inadequately described*
  
  #Religion
  abs2006$Christianity[i] = (as.numeric(temp_sheet[31,4])/popl)*100
  abs2006$Catholic[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  abs2006$Anglican[i] = (as.numeric(temp_sheet[12,4])/popl)*100
  abs2006$Buddhism[i] = (as.numeric(temp_sheet[10,4])/popl)*100
  abs2006$Islam[i] = (as.numeric(temp_sheet[33,4])/popl)*100
  abs2006$Judaism[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  abs2006$NoReligion[i] = (as.numeric(temp_sheet[39,4])/popl)*100
  
  abs2006$OtherChrist[i] = ((as.numeric(temp_sheet[31,4]) - as.numeric(temp_sheet[12,4]) - as.numeric(temp_sheet[16,4]))/popl)*100
  abs2006$Other_NonChrist[i] = 100 - abs2006$NoReligion[i] - abs2006$Christianity[i] #Non Christian and not no religion
  
  abs2006$Religion_NS[i] = (as.numeric(temp_sheet[41,4])/as.numeric(temp_sheet[43,4]))*100
}


# B 14

sheet_ref <- "B 14"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = abs2006$Population[i]
  
  #Percentage of total population that are currently studying at any level
  abs2006$CurrentlyStudying[i] = (as.numeric(temp_sheet[51,4])/popl) * 100
}


# B 15

sheet_ref <- "B 15"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[49,11]) 
  #question_popl = as.numeric(temp_sheet[49,11]) - as.numeric(temp_sheet[47,11]) #only of aged 15+, removing "not stated"
  
  #Percentage of total population that have finished high school
  abs2006$HighSchool[i] = (as.numeric(temp_sheet[39,11])/popl) * 100
  abs2006$HighSchool_NS[i] = (as.numeric(temp_sheet[47,11])/as.numeric(temp_sheet[49,11])) * 100
}


# B 18

sheet_ref <- "B 18"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[48,5])
  #question_popl = as.numeric(temp_sheet[48,5]) - as.numeric(temp_sheet[48,4]) #aged 15+ and remove "not stated"
  
  #Percentage of people over 15 who volunteer
  abs2006$Volunteer[i] = (as.numeric(temp_sheet[48,2])/popl) * 100
  abs2006$Volunteer_NS[i] = (as.numeric(temp_sheet[48,4])/as.numeric(temp_sheet[48,5])) * 100
}


# B 24

sheet_ref <- "B 24"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  temp_sheet2 <- read_excel(excel_ref, sheet = "B 25")
  
  question_popl <- as.numeric(temp_sheet[45,2]) # Number of families
  
  #Family Ratio
  abs2006$FamilyRatio[i] = as.numeric(temp_sheet2[46,4]) / question_popl #number of people in families / number of families
  
  # Couple without children household
  abs2006$Couple_NoChild_House[i] = (as.numeric(temp_sheet[9,2]) / question_popl) * 100
  
  # One parent family household
  abs2006$OneParent_House[i] = (as.numeric(temp_sheet[41,2]) / question_popl) * 100
  
  # Couple with children household
  abs2006$Couple_WChild_House[i] = (as.numeric(temp_sheet[25,2]) / question_popl) * 100
  
}

remove(temp_sheet2)


# B 30

sheet_ref <- "B 30"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  # Single person household (% of total households)
  abs2006$SP_House[i] = (as.numeric(temp_sheet[12,4]) / as.numeric(temp_sheet[19,4])) * 100
}


# B 32

sheet_ref <- "B 32"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Percentage of total population that do not own/mortgage their dwelling
  abs2006$Owned[i] = (as.numeric(temp_sheet[12,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006$Mortgage[i] = (as.numeric(temp_sheet[14,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006$Renting[i] = (as.numeric(temp_sheet[23,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006$PublicHousing[i] = (as.numeric(temp_sheet[18,7])/(as.numeric(temp_sheet[29,7]))) * 100
  
  abs2006$Tenure_NS[i] = (as.numeric(temp_sheet[27,7])/as.numeric(temp_sheet[29,7]))*100
}


# B 35

sheet_ref <- "B 35"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Percentage of Dwellings with internet access
  abs2006$InternetAccess[i] = (as.numeric(temp_sheet[16,7]) / (as.numeric(temp_sheet[20,7]) - as.numeric(temp_sheet[18,7]))) * 100 #excludes not stated
  abs2006$InternetAccess_NS[i] = ((as.numeric(temp_sheet[18,7]) / as.numeric(temp_sheet[20,7]))) * 100 #percentage of dwellings not stating their internet access
}


# B 36

sheet_ref <- "B 36"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Unemployment Rate
  abs2006$Unemployed[i] = as.numeric(temp_sheet[21,4]) #Unemployed / Labour Force
  abs2006$LFParticipation[i] = as.numeric(temp_sheet[22,4])#LF participation rate
}


# B 38

sheet_ref <- "B 38"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  # Different address to 5 years ago
  abs2006$DiffAddress[i] = as.numeric(temp_sheet[27,4])/(as.numeric(temp_sheet[31,4])-as.numeric(temp_sheet[29,4])) * 100
}



# B 39b

sheet_ref <- "B 39b"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl <- abs2006$Population[i]
  popl_15 <- popl*(100 - abs2006$Age00_04[i] - abs2006$Age05_14[i])/100 #population aged 15+
  #question_popl <- popl_15 - as.numeric(temp_sheet[27,10]) #Excludes not stated from total pop over 15
  
  #Bachelor and Postgraduate
  abs2006$BachelorAbv[i] = ((as.numeric(temp_sheet[15,10]) + as.numeric(temp_sheet[11,10]) + as.numeric(temp_sheet[13,10])) / popl_15) * 100
  abs2006$DipCert[i] = ((as.numeric(temp_sheet[17,10])+as.numeric(temp_sheet[23,10])) / popl_15) * 100
  abs2006$University_NS[i] = ((as.numeric(temp_sheet[25,10]) + as.numeric(temp_sheet[27,10])) / popl_15)*100 #not stated and inadequately described out of population 15+
}


# B 42c

sheet_ref <- "B 42c"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[33,11])
  #question_popl <- as.numeric(temp_sheet[33,11]) - as.numeric(temp_sheet[31,11])
  
  # Industry of employment
  abs2006$Extractive[i] = ((as.numeric(temp_sheet[11,11]) + as.numeric(temp_sheet[12,11]) + as.numeric(temp_sheet[14,11])) / popl) * 100
  abs2006$Transformative[i] = ((as.numeric(temp_sheet[13,11]) + as.numeric(temp_sheet[15,11])) / popl) * 100
  abs2006$Distributive[i] = ((as.numeric(temp_sheet[16,11]) + as.numeric(temp_sheet[17,11]) + as.numeric(temp_sheet[19,11])) / popl) * 100
  abs2006$Finance[i] = (as.numeric(temp_sheet[21,11]) / popl) * 100
  abs2006$SocialServ[i] = ((as.numeric(temp_sheet[26,11]) + as.numeric(temp_sheet[27,11]) + as.numeric(temp_sheet[28,11])) / popl) * 100
}


# B 44

sheet_ref <- "B 44"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[51,11])
  #question_popl <- as.numeric(temp_sheet[51,11]) - as.numeric(temp_sheet[51,10])
  
  # Occupation 
  abs2006$ManagerAdminClericalSales[i] = ((as.numeric(temp_sheet[51,2]) + as.numeric(temp_sheet[51,6]) + as.numeric(temp_sheet[51,7])) / popl) * 100
  abs2006$Professional[i] = ((as.numeric(temp_sheet[51,3])) / popl) * 100
  abs2006$Tradesperson[i] = (as.numeric(temp_sheet[51,4]) / popl) * 100
  abs2006$Laborer[i] = (as.numeric(temp_sheet[51,9]) / popl) * 100
  
}


# Additional sheets - determine percentage of population that are not answering the question.

#BornOverseas
sheet_ref <- "B 09"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006$Population[i]
  
  abs2006$BornOverseas_NS[i] = (as.numeric(temp_sheet[45,4]) / popl)*100
}

#Language
sheet_ref <- "B 12"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006$Population[i]
  
  abs2006$Language_NS[i] = (as.numeric(temp_sheet[53,4]) / popl)*100
}

#PersonalIncome_NS
sheet_ref <- "B 16b"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006$Population[i]
  
  abs2006$PersonalIncome_NS[i] = (as.numeric(temp_sheet[23,11]) / as.numeric(temp_sheet[25,11]))*100
}

#PersonalIncome_NS
sheet_ref <- "B 26"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006$FamilyIncome_NS[i] = ((as.numeric(temp_sheet[25,6]) + as.numeric(temp_sheet[26,6])) / as.numeric(temp_sheet[28,6]))*100
}

#HouseholdIncome_NS
sheet_ref <- "B 28"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006$HouseholdIncome_NS[i] = ((as.numeric(temp_sheet[26,4]) + as.numeric(temp_sheet[27,4])) / as.numeric(temp_sheet[29,4]))*100
}

#Rent_NS
sheet_ref <- "B 34"

for (i in 1:nrow(CED_list_2006_04)) {
  elec <- CED_list_2006_04$Electorate[i]; state <- CED_list_2006_04$State[i]; ES <- paste0(paste0(elec,"-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2004/20010-BCP-", ES, " (Commonwealth Electoral Division 2004).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006$Rent_NS[i] = (as.numeric(temp_sheet[22,8])/ as.numeric(temp_sheet[24,8]))*100
}

# ------------------------------------------------------------------------------------------------------------

# 2006 Using 2007 CED boundaries.

# B 01a

sheet_ref <- "B 01a"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i]; 
  state <- CED_list_2006_e07$State[i]; 
  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  if (file.exists(excel_ref) == TRUE) {
    temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
    
    # CED Number
    abs2006_e07$ID[i] = substr(strsplit(as.character(temp_sheet[1,1]), split = 'CED07 ')[[1]][2],1,3)
    
    #Metrics
    abs2006_e07$Area[i] = as.numeric(strsplit(strsplit(temp_sheet[1,1][[1]], ") ")[[1]][3], " sq")[[1]][1])
    
    popl = as.numeric(temp_sheet[9,4])
    
    abs2006_e07$Population[i] = popl
    
    abs2006_e07$BornOverseas[i] = (as.numeric(temp_sheet[36,4])/(as.numeric(temp_sheet[36,4])+as.numeric(temp_sheet[35,4])))*100 #not stated implicitly excluded
    
    abs2006_e07$Indigenous[i] = (as.numeric(temp_sheet[32,4])/popl)*100
    
    abs2006_e07$EnglishOnly[i] = (as.numeric(temp_sheet[39,4])/(as.numeric(temp_sheet[39,4])+as.numeric(temp_sheet[40,4])))*100 #not stated implicitly excluded
    
    abs2006_e07$OtherLanguageHome[i] = 100 - abs2006_e07$EnglishOnly[i]
    
    abs2006_e07$AusCitizen[i] = (as.numeric(temp_sheet[42,4])/popl)*100
  }
}


# B_02

sheet_ref <- "B 02"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #All Medians are weekly
  abs2006_e07$MedianPersonalIncome[i] = as.numeric(temp_sheet[10,2])
  
  abs2006_e07$AverageHouseholdSize[i] = as.numeric(temp_sheet[14,5])
  
  abs2006_e07$MedianHouseholdIncome[i] = as.numeric(temp_sheet[14,2])
  
  abs2006_e07$MedianFamilyIncome[i] = as.numeric(temp_sheet[12,2])
  
  abs2006_e07$MedianRent[i] = as.numeric(temp_sheet[10,5])
  
  abs2006_e07$MedianLoanPay[i] = as.numeric(temp_sheet[8,5])
  
  #Median Age
  abs2006_e07$MedianAge[i] = as.numeric(temp_sheet[8,2])
}


# B 04

sheet_ref <- "B 04"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006_e07$Population[i]
  
  #Metrics
  abs2006_e07$Age00_04[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  
  abs2006_e07$Age05_14[i] = ((as.numeric(temp_sheet[22,4])+as.numeric(temp_sheet[28,4]))/popl)*100
  
  abs2006_e07$Age15_19[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  
  abs2006_e07$Age20_24[i] = (as.numeric(temp_sheet[40,4])/popl)*100
  
  abs2006_e07$Age25_34[i] = ((as.numeric(temp_sheet[46,4])+as.numeric(temp_sheet[16,9]))/popl)*100
  
  abs2006_e07$Age35_44[i] = ((as.numeric(temp_sheet[22,9])+as.numeric(temp_sheet[28,9]))/popl)*100
  
  abs2006_e07$Age45_54[i] = ((as.numeric(temp_sheet[34,9])+as.numeric(temp_sheet[40,9]))/popl)*100
  
  abs2006_e07$Age55_64[i] = ((as.numeric(temp_sheet[46,9])+as.numeric(temp_sheet[16,14]))/popl)*100
  
  abs2006_e07$Age65_74[i] = ((as.numeric(temp_sheet[22,14])+as.numeric(temp_sheet[28,14]))/popl)*100
  
  abs2006_e07$Age75_84[i] = ((as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[35,14]))/popl)*100
  
  abs2006_e07$Age85plus[i] = ((as.numeric(temp_sheet[36,14])+as.numeric(temp_sheet[37,14])+as.numeric(temp_sheet[38,14])+as.numeric(temp_sheet[39,14]))/popl)*100
}


# B 06

sheet_ref <- "B 06"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl <- abs2006_e07$Population[i]
  popl_15 <- popl - abs2006_e07$Age00_04[i] - abs2006_e07$Age05_14[i]
  question_popl = as.numeric(temp_sheet[49,5])
  
  #Percentage of DeFacto
  abs2006_e07$DeFacto[i] = (as.numeric(temp_sheet[49,3])/question_popl) * 100
  abs2006_e07$Married[i] = (as.numeric(temp_sheet[49,2])/question_popl) * 100
}


# B 09

sheet_ref <- "B 09"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[47,4])
  #question_popl = as.numeric(temp_sheet[47,4]) - as.numeric(temp_sheet[45,4])
  
  #Birthplace
  abs2006_e07$Born_MidEast[i] = ((
    as.numeric(temp_sheet[14,4]) + as.numeric(temp_sheet[22,4]) + as.numeric(temp_sheet[27,4]) + as.numeric(temp_sheet[40,4]) + as.numeric(temp_sheet[14,4]) ) / popl) * 100 
  
  abs2006_e07$Born_SE_Europe[i] = ((
    as.numeric(temp_sheet[10,4]) + as.numeric(temp_sheet[13,4]) + as.numeric(temp_sheet[16,4]) + as.numeric(temp_sheet[18,4]) + as.numeric(temp_sheet[37,4]) ) / popl) * 100 
  
  abs2006_e07$Born_UK[i] = (as.numeric(temp_sheet[41,4]) / popl) * 100 #only % of respondents
  
  abs2006_e07$Born_Asia[i] = ((
    as.numeric(temp_sheet[12,4]) + as.numeric(temp_sheet[20,4]) + as.numeric(temp_sheet[21,4]) + as.numeric(temp_sheet[25,4]) + as.numeric(temp_sheet[26,4]) + as.numeric(temp_sheet[28,4]) + as.numeric(temp_sheet[33,4]) + as.numeric(temp_sheet[35,4]) + as.numeric(temp_sheet[38,4]) + as.numeric(temp_sheet[39,4]) + as.numeric(temp_sheet[43,4]) ) / popl) * 100 
  
}


# B 13

sheet_ref <- "B 13"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006_e07$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[41,4]) - as.numeric(temp_sheet[40,4]) #remove not stated and inadequately described*
  
  #Religion
  abs2006_e07$Christianity[i] = (as.numeric(temp_sheet[31,4])/popl)*100
  abs2006_e07$Catholic[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  abs2006_e07$Anglican[i] = (as.numeric(temp_sheet[12,4])/popl)*100
  abs2006_e07$Buddhism[i] = (as.numeric(temp_sheet[10,4])/popl)*100
  abs2006_e07$Islam[i] = (as.numeric(temp_sheet[33,4])/popl)*100
  abs2006_e07$Judaism[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  abs2006_e07$NoReligion[i] = (as.numeric(temp_sheet[39,4])/popl)*100
  
  abs2006_e07$OtherChrist[i] = ((as.numeric(temp_sheet[31,4]) - as.numeric(temp_sheet[12,4]) - as.numeric(temp_sheet[16,4]))/popl)*100
  abs2006_e07$Other_NonChrist[i] = 100 - abs2006_e07$NoReligion[i] - abs2006_e07$Christianity[i] #Non Christian and not no religion
  abs2006_e07$Religion_NS[i] = (as.numeric(temp_sheet[41,4])/as.numeric(temp_sheet[43,4]))*100
}


# B 14

sheet_ref <- "B 14"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = abs2006_e07$Population[i]
  
  #Percentage of total population that are currently studying at any level
  abs2006_e07$CurrentlyStudying[i] = (as.numeric(temp_sheet[51,4])/popl) * 100
}


# B 15

sheet_ref <- "B 15"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[49,11])
  #question_popl = as.numeric(temp_sheet[49,11]) - as.numeric(temp_sheet[47,11]) #only of aged 15+, removing "not stated"
  
  #Percentage of total population that have finished high school
  abs2006_e07$HighSchool[i] = (as.numeric(temp_sheet[39,11])/popl) * 100
  abs2006_e07$HighSchool_NS[i] = (as.numeric(temp_sheet[47,11])/as.numeric(temp_sheet[49,11])) * 100
}


# B 18

sheet_ref <- "B 18"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl = as.numeric(temp_sheet[48,5])
  #question_popl = as.numeric(temp_sheet[48,5]) - as.numeric(temp_sheet[48,4]) #aged 15+ and remove "not stated"
  
  #Percentage of people over 15 who volunteer
  abs2006_e07$Volunteer[i] = (as.numeric(temp_sheet[48,2])/popl) * 100
  abs2006_e07$Volunteer_NS[i] = (as.numeric(temp_sheet[48,4])/as.numeric(temp_sheet[48,5])) * 100
}


# B 24

sheet_ref <- "B 24"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  temp_sheet2 <- read_excel(excel_ref, sheet = "B 25")
  
  question_popl <- as.numeric(temp_sheet[45,2]) # Number of families
  
  #Family Ratio
  abs2006_e07$FamilyRatio[i] = as.numeric(temp_sheet2[46,4]) / question_popl #number of people in families / number of families
  
  # Couple without children household
  abs2006_e07$Couple_NoChild_House[i] = (as.numeric(temp_sheet[9,2]) / question_popl) * 100
  
  # One parent family household
  abs2006_e07$OneParent_House[i] = (as.numeric(temp_sheet[41,2]) / question_popl) * 100
  
  # Couple with children household
  abs2006_e07$Couple_WChild_House[i] = (as.numeric(temp_sheet[25,2]) / question_popl) * 100
  
}

remove(temp_sheet2)


# B 30

sheet_ref <- "B 30"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  # Single person household (% of total households)
  abs2006_e07$SP_House[i] = (as.numeric(temp_sheet[12,4]) / as.numeric(temp_sheet[19,4])) * 100
}


# B 32

sheet_ref <- "B 32"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Percentage of total population that do not own/mortgage their dwelling
  abs2006_e07$Owned[i] = (as.numeric(temp_sheet[12,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_e07$Mortgage[i] = (as.numeric(temp_sheet[14,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_e07$Renting[i] = (as.numeric(temp_sheet[23,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_e07$PublicHousing[i] = (as.numeric(temp_sheet[18,7])/(as.numeric(temp_sheet[29,7]))) * 100
  
  abs2006_e07$Tenure_NS[i] = (as.numeric(temp_sheet[27,7])/as.numeric(temp_sheet[29,7]))*100
}


# B 35

sheet_ref <- "B 35"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Percentage of Dwellings with internet access
  abs2006_e07$InternetAccess[i] = (as.numeric(temp_sheet[16,7]) / (as.numeric(temp_sheet[20,7]))) * 100 #excludes not stated
  abs2006_e07$InternetAccess_NS[i] = ((as.numeric(temp_sheet[18,7]) / as.numeric(temp_sheet[20,7]))) * 100 #percentage of dwellings not stating their internet access
}


# B 36

sheet_ref <- "B 36"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  #Unemployment Rate
  abs2006_e07$Unemployed[i] = as.numeric(temp_sheet[21,4]) #Unemployed / Labour Force
  abs2006_e07$LFParticipation[i] = as.numeric(temp_sheet[22,4])#LF participation rate
}


# B 38

sheet_ref <- "B 38"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  # Different address to 5 years ago
  abs2006_e07$DiffAddress[i] = as.numeric(temp_sheet[27,4])/(as.numeric(temp_sheet[31,4])) * 100
}


# B 39b

sheet_ref <- "B 39b"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl <- abs2006_e07$Population[i]
  popl_15 <- popl*(100 - abs2006_e07$Age00_04[i] - abs2006_e07$Age05_14[i])/100 #population aged 15+
  #question_popl <- popl_15 - as.numeric(temp_sheet[27,10]) #Excludes not stated from total pop over 15
  
  #Bachelor and DipCert
  abs2006_e07$BachelorAbv[i] = ((as.numeric(temp_sheet[15,10]) + as.numeric(temp_sheet[11,10]) + as.numeric(temp_sheet[13,10])) / popl_15) * 100
  abs2006_e07$DipCert[i] = ((as.numeric(temp_sheet[17,10]) + as.numeric(temp_sheet[23,10])) / popl_15) * 100
  abs2006_e07$University_NS[i] = ((as.numeric(temp_sheet[25,10]) + as.numeric(temp_sheet[27,10])) / popl_15)*100 #not stated and inadequately described out of population 15+
}


# B 42c

sheet_ref <- "B 42c"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl <- as.numeric(temp_sheet[33,11])
  #question_popl <- as.numeric(temp_sheet[33,11]) - as.numeric(temp_sheet[31,11])
  
  # Industry of employment
  abs2006_e07$Extractive[i] = ((as.numeric(temp_sheet[11,11]) + as.numeric(temp_sheet[12,11]) + as.numeric(temp_sheet[14,11])) / popl) * 100
  abs2006_e07$Transformative[i] = ((as.numeric(temp_sheet[13,11]) + as.numeric(temp_sheet[15,11])) / popl) * 100
  abs2006_e07$Distributive[i] = ((as.numeric(temp_sheet[16,11]) + as.numeric(temp_sheet[17,11]) + as.numeric(temp_sheet[19,11])) / popl) * 100
  abs2006_e07$Finance[i] = (as.numeric(temp_sheet[21,11]) / popl) * 100
  abs2006_e07$SocialServ[i] = ((as.numeric(temp_sheet[26,11]) + as.numeric(temp_sheet[27,11]) + as.numeric(temp_sheet[28,11])) / popl) * 100
}


# B 44

sheet_ref <- "B 44"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  popl <- as.numeric(temp_sheet[51,11])
  #question_popl <- as.numeric(temp_sheet[51,11]) - as.numeric(temp_sheet[51,10])
  
  # Occupation 
  abs2006_e07$ManagerAdminClericalSales[i] = ((as.numeric(temp_sheet[51,2]) + as.numeric(temp_sheet[51,6]) + as.numeric(temp_sheet[51,7])) / popl) * 100
  abs2006_e07$Professional[i] = ((as.numeric(temp_sheet[51,3])) / popl) * 100
  abs2006_e07$Tradesperson[i] = (as.numeric(temp_sheet[51,4]) / popl) * 100
  abs2006_e07$Laborer[i] = (as.numeric(temp_sheet[51,9]) / popl) * 100
  
}



# Additional sheets - determine percentage of population that are not answering the question.

#BornOverseas
sheet_ref <- "B 09"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006_e07$Population[i]
  
  abs2006_e07$BornOverseas_NS[i] = (as.numeric(temp_sheet[45,4]) / popl)*100
}

#Language
sheet_ref <- "B 12"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006_e07$Population[i]
  
  abs2006_e07$Language_NS[i] = (as.numeric(temp_sheet[53,4]) / popl)*100
}

#PersonalIncome_NS
sheet_ref <- "B 16b"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  popl = abs2006_e07$Population[i]
  
  abs2006_e07$PersonalIncome_NS[i] = (as.numeric(temp_sheet[23,11]) / as.numeric(temp_sheet[25,11]))*100
}

#PersonalIncome_NS
sheet_ref <- "B 26"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006_e07$FamilyIncome_NS[i] = ((as.numeric(temp_sheet[25,6]) + as.numeric(temp_sheet[26,6])) / as.numeric(temp_sheet[28,6]))*100
}

#HouseholdIncome_NS
sheet_ref <- "B 28"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006_e07$HouseholdIncome_NS[i] = ((as.numeric(temp_sheet[26,4]) + as.numeric(temp_sheet[27,4])) / as.numeric(temp_sheet[29,4]))*100
}

#Rent_NS
sheet_ref <- "B 34"

for (i in 1:nrow(CED_list_2006_e07)) {
  elec <- CED_list_2006_e07$Electorate[i];  state <- CED_list_2006_e07$State[i];  ES <- paste0(paste0(elec,"(CED07)-"),state)
  excel_ref <- paste0("data-raw/census/data/ABS2006/Unzipped/CED2007/20010-BCP-", ES, "(CommonwealthElectoralDivision2007).xls")
  
  temp_sheet <- read_excel(excel_ref, sheet = sheet_ref)
  
  abs2006_e07$Rent_NS[i] = (as.numeric(temp_sheet[22,8])/ as.numeric(temp_sheet[24,8]))*100
}

# ------------------------------------------------------------------------------------------------------------

# Inflation

inflation_rates <- c(1.151, 1.330, 1.461)

abs2006 <- abs2006 %>%
  mutate(MedianFamilyIncome = MedianFamilyIncome/inflation_rates[1],
    MedianHouseholdIncome = MedianHouseholdIncome/inflation_rates[1],
    MedianLoanPay = MedianLoanPay/inflation_rates[1],
    MedianPersonalIncome = MedianPersonalIncome/inflation_rates[1],
    MedianRent = MedianRent/inflation_rates[1])

abs2006_e07 <- abs2006_e07 %>%
  mutate(MedianFamilyIncome = MedianFamilyIncome/inflation_rates[1],
    MedianHouseholdIncome = MedianHouseholdIncome/inflation_rates[1],
    MedianLoanPay = MedianLoanPay/inflation_rates[1],
    MedianPersonalIncome = MedianPersonalIncome/inflation_rates[1],
    MedianRent = MedianRent/inflation_rates[1])

# Change BornOverseas to BornElsewhere

abs2001 <- abs2001 %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas)

abs2006 <- abs2006 %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas)

abs2006_e07 <- abs2006_e07 %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas)

# Rename Electorate Column to match election data and same column order for all data frames
abs2001$Electorate <- as.character(abs2001$Electorate)
abs2001$Electorate[136] <- "O'Connor"
abs2001$Electorate <- as.factor(abs2001$Electorate)

abs2001 <- abs2001 %>% 
  rename(DivisionNm = Electorate) %>% 
  mutate(DivisionNm = toupper(DivisionNm)) %>% 
  select(order(colnames(.))) %>% 
  select(ID, DivisionNm, State, Population, Area, everything())

abs2006 <- abs2006 %>% 
  rename(DivisionNm = Electorate) %>% 
  mutate(DivisionNm = toupper(DivisionNm)) %>% 
  select(order(colnames(.))) %>% 
  select(ID, DivisionNm, State, Population, Area, everything())

abs2006_e07 <- abs2006_e07 %>% 
  rename(DivisionNm = Electorate) %>% 
  mutate(DivisionNm = toupper(DivisionNm)) %>% 
  select(order(colnames(.))) %>% 
  select(ID, DivisionNm, State, Population, Area, everything())

# Fix electorate names for abs2006_e07
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "KINGSFORDSMITH")] <- "KINGSFORD SMITH"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "LATROBE")] <- "LA TROBE"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "MELBOURNEPORTS")] <- "MELBOURNE PORTS"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "NEWENGLAND")] <- "NEW ENGLAND"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "NORTHSYDNEY")] <- "NORTH SYDNEY"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "PORTADELAIDE")] <- "PORT ADELAIDE"
abs2006_e07$DivisionNm[which(abs2006_e07$DivisionNm == "WIDEBAY")] <- "WIDE BAY"

# Alphabetical order of electorates

abs2001 <- abs2001 %>% 
  arrange(DivisionNm)

abs2006 <- abs2006 %>% 
  arrange(DivisionNm)

abs2006_e07 <- abs2006_e07 %>% 
  arrange(DivisionNm)

# Save

save(abs2001, file = "data-raw/census/data/abs2001.rda")
save(abs2006, file = "data-raw/census/data/abs2006.rda")
save(abs2006_e07, file = "data-raw/census/data/abs2006_e07.rda")


