# This script, when run, builds a data frame for each of the 2001 and 2006 Censuses, containing socio-demographic information relating to each Census collection district.

# Census Community Profiles: must be downloaded and unzipped using the "Download-Unzip-CensusData-CD.Rmd"

# ------------------------------------------------------------------------------------------------------------

require(tidyverse)
require(readxl)

# Create quiet read_excel
quiet_excel <- quietly(read_excel)

# Load CD lists

load(file = "data-raw/imputing-using-sa1/data/CD_list_wdata_2001.rda")
load(file = "data-raw/imputing-using-sa1/data/CD_list_wdata_2006.rda")

print(CD_list_wdata_2001 %>% head())

CD_2001 <- CD_list_wdata_2001 %>% filter(valid_data == T) %>% select(CD) %>% unname %>% unlist %>% as.character()
CD_2006 <- CD_list_wdata_2006 %>% filter(valid_data == T) %>% select(CD) %>% unname %>% unlist %>% as.character()

#CD_2001 <- CD_2001[1:10]
#CD_2006 <- CD_2006[1:10]

# Remove CD 5081002, 5102205 because it only contains sheets up to B 21. 
CD_2001 <- CD_2001[-which(CD_2001 %in% c("5081002", "5102205"))]

# ------------------------------------------------------------------------------------------------------------

# Creating blank data frames

abs2001_cd <- data.frame(CD = CD_2001, Population = 0, Area = 0, MedianPersonalIncome = 0, Unemployed = 0, LFParticipation = 0, BachelorAbv = 0, Christianity = 0, Catholic = 0, Buddhism = 0, Islam = 0, Judaism = 0, NoReligion = 0, Age00_04 = 0, Age05_14 = 0, Age15_19 = 0, Age20_24 = 0, Age25_34 = 0, Age35_44 = 0, Age45_54 = 0, Age55_64 = 0, Age65_74 = 0, Age75_84 = 0, Age85plus = 0, BornOverseas = 0, Indigenous = 0, EnglishOnly = 0, OtherLanguageHome = 0, Married = 0, DeFacto = 0, FamilyRatio = 0, CurrentlyStudying = 0, HighSchool = 0, InternetUse = 0, InternetAccess = 0, AusCitizen = 0, AverageHouseholdSize = 0, MedianHouseholdIncome = 0, MedianFamilyIncome = 0, MedianRent = 0, MedianLoanPay = 0, MedianAge = 0, EmuneratedElsewhere = 0, Volunteer = 0, SP_House = 0, Couple_NoChild_House = 0, OneParent_House = 0, Couple_WChild_House = 0, Owned = 0, Mortgage = 0, Renting = 0, PublicHousing = 0, Born_UK = 0, Born_SE_Europe = 0, Born_MidEast = 0, Born_Asia = 0, DiffAddress = 0, Extractive = 0, Transformative = 0, Distributive = 0, Finance = 0, SocialServ = 0, ManagerAdminClericalSales = 0, Professional = 0, Tradesperson = 0, Laborer = 0, DipCert = 0, Anglican = 0, OtherChrist = 0, Other_NonChrist = 0)

abs2006_cd <- data.frame(CD = CD_2006, Population = 0, Area = 0, MedianPersonalIncome = 0, Unemployed = 0, LFParticipation = 0, BachelorAbv = 0, Christianity = 0, Catholic = 0, Buddhism = 0, Islam = 0, Judaism = 0, NoReligion = 0, Age00_04 = 0, Age05_14 = 0, Age15_19 = 0, Age20_24 = 0, Age25_34 = 0, Age35_44 = 0, Age45_54 = 0, Age55_64 = 0, Age65_74 = 0, Age75_84 = 0, Age85plus = 0, BornOverseas = 0, Indigenous = 0, EnglishOnly = 0, OtherLanguageHome = 0, Married = 0, DeFacto = 0, FamilyRatio = 0, CurrentlyStudying = 0, HighSchool = 0, InternetUse = 0, InternetAccess = 0, AusCitizen = 0, AverageHouseholdSize = 0, MedianHouseholdIncome = 0, MedianFamilyIncome = 0, MedianRent = 0, MedianLoanPay = 0, MedianAge = 0, EmuneratedElsewhere = 0, Volunteer = 0, SP_House = 0, Couple_NoChild_House = 0, OneParent_House = 0, Couple_WChild_House = 0, Owned = 0, Mortgage = 0, Renting = 0, PublicHousing = 0, Born_UK = 0, Born_SE_Europe = 0, Born_MidEast = 0, Born_Asia = 0, DiffAddress = 0, Extractive = 0, Transformative = 0, Distributive = 0, Finance = 0, SocialServ = 0, ManagerAdminClericalSales = 0, Professional = 0, Tradesperson = 0, Laborer = 0, DipCert = 0, Anglican = 0, OtherChrist = 0, Other_NonChrist = 0)

# ------------------------------------------------------------------------------------------------------------

# Construction of 2001 Census
a <- Sys.time()

# Each of the following chunks corresponds with a particular sheet, which may have numerous metrics derived from it. 

# B 01

sheet_ref <- "B 01"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Metrics
  a <- as.character(temp_sheet[1,1], " ")
  abs2001_cd$Area[i] = as.numeric(strsplit(a, " ")[[1]][lengths(strsplit(a, " ")) - 2])
  
  
  popl = as.numeric(temp_sheet[8,4]) - as.numeric(temp_sheet[32,4]) #less overseas visitors
  
  abs2001_cd$Population[i] = popl
  
  abs2001_cd$BornOverseas[i] = (as.numeric(temp_sheet[19,4])/(as.numeric(temp_sheet[18,4])+as.numeric(temp_sheet[19,4])))*100 #removed not stated implicitly
  
  abs2001_cd$Indigenous[i] = (as.numeric(temp_sheet[24,4])/popl)*100
  
  abs2001_cd$EnglishOnly[i] = (as.numeric(temp_sheet[21,4])/(as.numeric(temp_sheet[21,4])+as.numeric(temp_sheet[22,4])))*100 #removed not stated implicitly
  
  abs2001_cd$OtherLanguageHome[i] = 100 - abs2001_cd$EnglishOnly[i]
  
  abs2001_cd$AusCitizen[i] = (as.numeric(temp_sheet[26,4])/popl)*100
  
  abs2001_cd$EmuneratedElsewhere[i] = (as.numeric(temp_sheet[30,4])/as.numeric(temp_sheet[8,4]))*100 #includes overseas visitors in numerator and denomenator
}

# B 03

sheet_ref <- "B 03"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2001_cd$Population[i]
  
  #Metrics
  abs2001_cd$Age00_04[i] = (as.numeric(temp_sheet[13,4])/popl)*100
  
  abs2001_cd$Age05_14[i] = ((as.numeric(temp_sheet[19,4])+as.numeric(temp_sheet[25,4]))/popl)*100
  
  abs2001_cd$Age15_19[i] = (as.numeric(temp_sheet[31,4])/popl)*100
  
  abs2001_cd$Age20_24[i] = (as.numeric(temp_sheet[37,4])/popl)*100
  
  abs2001_cd$Age25_34[i] = ((as.numeric(temp_sheet[43,4])+as.numeric(temp_sheet[13,9]))/popl)*100
  
  abs2001_cd$Age35_44[i] = ((as.numeric(temp_sheet[19,9])+as.numeric(temp_sheet[25,9]))/popl)*100
  
  abs2001_cd$Age45_54[i] = ((as.numeric(temp_sheet[31,9])+as.numeric(temp_sheet[37,9]))/popl)*100
  
  abs2001_cd$Age55_64[i] = ((as.numeric(temp_sheet[43,9])+as.numeric(temp_sheet[13,14]))/popl)*100
  
  abs2001_cd$Age65_74[i] = ((as.numeric(temp_sheet[19,14])+as.numeric(temp_sheet[25,14]))/popl)*100
  
  abs2001_cd$Age75_84[i] = ((as.numeric(temp_sheet[31,14])+as.numeric(temp_sheet[32,14]))/popl)*100
  
  abs2001_cd$Age85plus[i] = ((as.numeric(temp_sheet[33,14])+as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[36,14]))/popl)*100
}


# B_04

sheet_ref <- "B 04"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Married
  abs2001_cd$Married[i] = ((as.numeric(temp_sheet[26,2]) + as.numeric(temp_sheet[26,3]) - as.numeric(temp_sheet[24,2]) - as.numeric(temp_sheet[24,3])) / (as.numeric(temp_sheet[26,19]) - as.numeric(temp_sheet[24,19]))) * 100 #only % of respondents
}


# B 07A and B 07B

sheet_ref <- "B 07A"
sheet_refB <- "B 07B"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  temp_sheetB <- quiet_excel(excel_ref, sheet = sheet_refB)$result
  
  question_popl <- as.numeric(temp_sheetB[37,4])
  
  #Birthplace
  abs2001_cd$Born_MidEast[i] = (as.numeric(temp_sheet[30,4]) / question_popl) * 100 
  
  abs2001_cd$Born_SE_Europe[i] = (as.numeric(temp_sheet[25,4]) / question_popl) * 100 
  
  abs2001_cd$Born_UK[i] = (as.numeric(temp_sheet[14,4]) / question_popl) * 100 
  
  abs2001_cd$Born_Asia[i] = ((as.numeric(temp_sheet[37,4]) + as.numeric(temp_sheetB[11,4]) + as.numeric(temp_sheetB[17,4])) / question_popl) * 100 
  
}


# B 10

sheet_ref <- "B 10"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2001_cd$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[36,4]) - as.numeric(temp_sheet[37,4]) #remove not stated, inadequately described
  
  #Metric
  abs2001_cd$Christianity[i] = (as.numeric(temp_sheet[27,4])/popl)*100
  abs2001_cd$Catholic[i] = (as.numeric(temp_sheet[13,4])/popl)*100
  abs2001_cd$Anglican[i] = (as.numeric(temp_sheet[10,4])/popl)*100
  
  abs2001_cd$OtherChrist[i] = ((as.numeric(temp_sheet[27,4]) - as.numeric(temp_sheet[10,4]) - as.numeric(temp_sheet[13,4]))/popl)*100
  
  abs2001_cd$Buddhism[i] = (as.numeric(temp_sheet[8,4])/popl)*100
  abs2001_cd$Islam[i] = (as.numeric(temp_sheet[29,4])/popl)*100
  abs2001_cd$Judaism[i] = (as.numeric(temp_sheet[30,4])/popl)*100
  abs2001_cd$NoReligion[i] = (as.numeric(temp_sheet[35,4])/popl)*100
  
  abs2001_cd$Other_NonChrist[i] = 100 - abs2001_cd$NoReligion[i] - abs2001_cd$Christianity[i]
  
}


# B 11

sheet_ref <- "B 11"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2001_cd$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[35,4]) #remove not stated*
  
  #Metric
  abs2001_cd$CurrentlyStudying[i] = (1 - as.numeric(temp_sheet[34,4])/popl) * 100
}


# B 12

sheet_ref <- "B 12"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[17,4])
  #question_popl = as.numeric(temp_sheet[17,4]) - as.numeric(temp_sheet[15,4]) #people aged 15+, remove not stated
  
  #Percentage of total population that have finished high school
  abs2001_cd$HighSchool[i] = (as.numeric(temp_sheet[12,4])/popl) * 100
}

# B 14

sheet_ref <- "B 14"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2001_cd$Population[i]
  question_popl = as.numeric(temp_sheet[57,10])
  
  #Percentage of total population are in a DeFacto marriage
  abs2001_cd$DeFacto[i] = (as.numeric(temp_sheet[45,10])/question_popl) * 100
}


# B 16

sheet_ref <- "B 16"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2001_cd$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[18,4]) #remove not stated
  
  #Percentage of total population that used internet in last week
  abs2001_cd$InternetUse[i] = (as.numeric(temp_sheet[16,4])/popl) * 100
}


# B 17

sheet_ref <- "B 17"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Family ratio = people / families
  abs2001_cd$FamilyRatio[i] = (as.numeric(temp_sheet[32,6])/as.numeric(temp_sheet[32,2]))
  
  # Couple without children household
  abs2001_cd$Couple_NoChild_House[i] = (as.numeric(temp_sheet[18,2])/as.numeric(temp_sheet[32,2]))*100
  
  # One parent family household
  abs2001_cd$OneParent_House[i] = (as.numeric(temp_sheet[28,2])/as.numeric(temp_sheet[32,2]))*100
  
  # Couples with children household
  abs2001_cd$Couple_WChild_House[i] = (as.numeric(temp_sheet[16,2])/as.numeric(temp_sheet[32,2]))*100
}


# B 19

sheet_ref <- "B 19"
print(paste("2001", sheet_ref))

for (i in 1:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  tot_houses <- as.numeric(temp_sheet[19,11]) - as.numeric(temp_sheet[19,10])
  
  abs2001_cd$Owned[i] = (as.numeric(temp_sheet[19,2])/tot_houses) * 100 #excludes not stated
  
  abs2001_cd$Mortgage[i] = ((as.numeric(temp_sheet[19,3])+as.numeric(temp_sheet[19,4]))/tot_houses) * 100 #excludes not stated
  
  abs2001_cd$Renting[i] = (as.numeric(temp_sheet[19,8])/tot_houses) * 100 #excludes not stated
  
  abs2001_cd$PublicHousing[i] = (as.numeric(temp_sheet[19,5])/tot_houses) * 100 #excludes not stated
  
}


# B 22

sheet_ref <- "B 22"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Unemployment Rate
  abs2001_cd$Unemployed[i] = as.numeric(temp_sheet[16,4]) * 100 #Unemployed / Labour Force
  
  # Labor force participation
  abs2001_cd$LFParticipation[i] = (as.numeric(temp_sheet[14,4]) / (as.numeric(temp_sheet[14,4])+as.numeric(temp_sheet[15,4]))) * 100 #LF participation rate
  
  # Same address as 5 years ago
  abs2001_cd$DiffAddress[i] = (as.numeric(temp_sheet[22,4])/(as.numeric(temp_sheet[22,4])+as.numeric(temp_sheet[21,4]))) * 100 #Unemployed / Labour Force
  
  if (i %% 1000 == 0) {print(i)}
}


# B 23

sheet_ref <- "B 23"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  if (i %% 1000 == 0) {print (i)}
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl <- abs2001_cd$Population[i]
  popl_15 <- popl*(100 - abs2001_cd$Age00_04[i] - abs2001_cd$Age05_14[i])/100 
  #question_popl <- as.numeric(temp_sheet[16,4]) - as.numeric(temp_sheet[13,4]) #Excludes not stated from total pop over 15
  
  #Bachelor and above
  abs2001_cd$BachelorAbv[i] = ((as.numeric(temp_sheet[8,4]) + as.numeric(temp_sheet[9,4]) + as.numeric(temp_sheet[10,4])) / popl_15) * 100
  
  # Diploma or Certificate
  abs2001_cd$DipCert[i] = ((as.numeric(temp_sheet[11,4]) + as.numeric(temp_sheet[12,4]))/ popl_15) * 100
}


# B 26B

sheet_ref <- "B 26B"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  if (i %% 1000 == 0) {print (i)}
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[30,9])
  #question_popl <- as.numeric(temp_sheet[30,9]) - as.numeric(temp_sheet[28,9])
  
  # Industry of employment
  abs2001_cd$Extractive[i] = ((as.numeric(temp_sheet[10,9]) + as.numeric(temp_sheet[11,9]) + as.numeric(temp_sheet[13,9])) / popl) * 100
  abs2001_cd$Transformative[i] = ((as.numeric(temp_sheet[12,9]) + as.numeric(temp_sheet[14,9])) / popl) * 100
  abs2001_cd$Distributive[i] = ((as.numeric(temp_sheet[15,9]) + as.numeric(temp_sheet[16,9]) + as.numeric(temp_sheet[18,9])) / popl) * 100
  abs2001_cd$Finance[i] = (as.numeric(temp_sheet[20,9]) / popl) * 100
  abs2001_cd$SocialServ[i] = ((as.numeric(temp_sheet[23,9]) + as.numeric(temp_sheet[24,9]) + as.numeric(temp_sheet[25,9])) / popl) * 100
}



# B 27B

sheet_ref <- "B 27B"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  if (i %% 1000 == 0) {print (i)}
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[22,9])
  #question_popl <- as.numeric(temp_sheet[22,9]) - as.numeric(temp_sheet[20,9])- as.numeric(temp_sheet[19,9]) #excludes inadequately answered and not stated
  
  # Occupation 
  abs2001_cd$ManagerAdminClericalSales[i] = ((as.numeric(temp_sheet[10,9]) + as.numeric(temp_sheet[14,9]) + as.numeric(temp_sheet[15,9]) + as.numeric(temp_sheet[17,9])) / popl) * 100
  abs2001_cd$Professional[i] = ((as.numeric(temp_sheet[11,9])) / popl) * 100
  abs2001_cd$Tradesperson[i] = (as.numeric(temp_sheet[13,9]) / popl) * 100
  abs2001_cd$Laborer[i] = (as.numeric(temp_sheet[18,9]) / popl) * 100
  
}



# B 32

sheet_ref <- "B 32"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  if (i %% 1000 == 0) {print (i)}
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  # Single person household (% of households)
  abs2001_cd$SP_House[i] = (as.numeric(temp_sheet[10,7])/as.numeric(temp_sheet[17,7])) * 100
}




# B 33
# This deals with medians, which only have ranges - decided to use midpoint of range

sheet_ref <- "B 33"
print(paste("2001", sheet_ref))

for (i in 31709:length(CD_2001)) {
  if (i %% 1000 == 0) {print (i)}
  CD <- CD_2001[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2001/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #All Medians are weekly
  #Median Income
  a <- strsplit(temp_sheet[9,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001_cd$MedianPersonalIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HouseHoldSize
  abs2001_cd$AverageHouseholdSize[i] = as.numeric(temp_sheet[12,2])
  
  #Median FamilyIncome
  a <- strsplit(temp_sheet[10,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001_cd$MedianFamilyIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HouseholdIncome
  a <- strsplit(temp_sheet[11,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001_cd$MedianHouseholdIncome[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median Rent
  a <- strsplit(temp_sheet[8,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001_cd$MedianRent[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median HousingLoanPayments
  a <- strsplit(temp_sheet[7,2][[1]], "-")
  min <- substr(a[[1]][1], 2, nchar(a[[1]][1]))
  min <- sub(",", "", min)
  max <- substr(a[[1]][2], 2, nchar(a[[1]][1]))
  max <- sub(",", "", max)
  abs2001_cd$MedianLoanPay[i] = (as.numeric(min)+as.numeric(max))/2
  
  #Median Age
  abs2001_cd$MedianAge[i] = as.numeric(temp_sheet[6,2])
}

b <- Sys.time()
print(paste("2001 took", b-a))

# ------------------------------------------------------------------------------------------------------------


# 2006 Census
# The unzipped files have states in their names - need to get a list of them or adjust the CD names as required.
c <- Sys.time()

#B 01a

sheet_ref <- "B 01a"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Metrics
  abs2006_cd$Area[i] = as.numeric(strsplit(strsplit(temp_sheet[1,1][[1]], ") ")[[1]][2], " sq")[[1]][1])
  
  popl = as.numeric(temp_sheet[9,4])
  
  abs2006_cd$Population[i] = popl
  
  abs2006_cd$BornOverseas[i] = (as.numeric(temp_sheet[36,4])/(as.numeric(temp_sheet[36,4])+as.numeric(temp_sheet[35,4])))*100 #not stated implicitly excluded
  
  abs2006_cd$Indigenous[i] = (as.numeric(temp_sheet[32,4])/popl)*100
  
  abs2006_cd$EnglishOnly[i] = (as.numeric(temp_sheet[39,4])/(as.numeric(temp_sheet[39,4])+as.numeric(temp_sheet[40,4])))*100 #not stated implicitly excluded
  
  abs2006_cd$OtherLanguageHome[i] = 100 - abs2006_cd$EnglishOnly[i]
  
  abs2006_cd$AusCitizen[i] = (as.numeric(temp_sheet[42,4])/popl)*100
}


# B_02

sheet_ref <- "B 02"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #All Medians are weekly
  abs2006_cd$MedianPersonalIncome[i] = as.numeric(temp_sheet[10,2])
  
  abs2006_cd$AverageHouseholdSize[i] = as.numeric(temp_sheet[14,5])
  
  abs2006_cd$MedianHouseholdIncome[i] = as.numeric(temp_sheet[14,2])
  
  abs2006_cd$MedianFamilyIncome[i] = as.numeric(temp_sheet[12,2])
  
  abs2006_cd$MedianRent[i] = as.numeric(temp_sheet[10,5])
  
  abs2006_cd$MedianLoanPay[i] = as.numeric(temp_sheet[8,5])
  
  #Median Age
  abs2006_cd$MedianAge[i] = as.numeric(temp_sheet[8,2])
}


# B 04

sheet_ref <- "B 04"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2006_cd$Population[i]
  
  #Metrics
  abs2006_cd$Age00_04[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  
  abs2006_cd$Age05_14[i] = ((as.numeric(temp_sheet[22,4])+as.numeric(temp_sheet[28,4]))/popl)*100
  
  abs2006_cd$Age15_19[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  
  abs2006_cd$Age20_24[i] = (as.numeric(temp_sheet[40,4])/popl)*100
  
  abs2006_cd$Age25_34[i] = ((as.numeric(temp_sheet[46,4])+as.numeric(temp_sheet[16,9]))/popl)*100
  
  abs2006_cd$Age35_44[i] = ((as.numeric(temp_sheet[22,9])+as.numeric(temp_sheet[28,9]))/popl)*100
  
  abs2006_cd$Age45_54[i] = ((as.numeric(temp_sheet[34,9])+as.numeric(temp_sheet[40,9]))/popl)*100
  
  abs2006_cd$Age55_64[i] = ((as.numeric(temp_sheet[46,9])+as.numeric(temp_sheet[16,14]))/popl)*100
  
  abs2006_cd$Age65_74[i] = ((as.numeric(temp_sheet[22,14])+as.numeric(temp_sheet[28,14]))/popl)*100
  
  abs2006_cd$Age75_84[i] = ((as.numeric(temp_sheet[34,14])+as.numeric(temp_sheet[35,14]))/popl)*100
  
  abs2006_cd$Age85plus[i] = ((as.numeric(temp_sheet[36,14])+as.numeric(temp_sheet[37,14])+as.numeric(temp_sheet[38,14])+as.numeric(temp_sheet[39,14]))/popl)*100
}


# B 06

sheet_ref <- "B 06"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl <- abs2006_cd$Population[i]
  question_popl = as.numeric(temp_sheet[49,5])
  
  #Percentage of DeFacto
  abs2006_cd$DeFacto[i] = (as.numeric(temp_sheet[49,3])/question_popl) * 100
  abs2006_cd$Married[i] = (as.numeric(temp_sheet[49,2])/question_popl) * 100
}


# B 09

sheet_ref <- "B 09"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[47,4]) 
  #question_popl = as.numeric(temp_sheet[47,4]) - as.numeric(temp_sheet[45,4])
  
  #Birthplace
  abs2006_cd$Born_MidEast[i] = ((
    as.numeric(temp_sheet[14,4]) + as.numeric(temp_sheet[22,4]) + as.numeric(temp_sheet[27,4]) + as.numeric(temp_sheet[40,4]) + as.numeric(temp_sheet[14,4]) ) / popl) * 100 
  
  abs2006_cd$Born_SE_Europe[i] = ((
    as.numeric(temp_sheet[10,4]) + as.numeric(temp_sheet[13,4]) + as.numeric(temp_sheet[16,4]) + as.numeric(temp_sheet[18,4]) + as.numeric(temp_sheet[37,4]) ) / popl) * 100 
  
  abs2006_cd$Born_UK[i] = (as.numeric(temp_sheet[41,4]) / popl) * 100
  
  abs2006_cd$Born_Asia[i] = ((
    as.numeric(temp_sheet[12,4]) + as.numeric(temp_sheet[20,4]) + as.numeric(temp_sheet[21,4]) + as.numeric(temp_sheet[25,4]) + as.numeric(temp_sheet[26,4]) + as.numeric(temp_sheet[28,4]) + as.numeric(temp_sheet[33,4]) + as.numeric(temp_sheet[35,4]) + as.numeric(temp_sheet[38,4]) + as.numeric(temp_sheet[39,4]) + as.numeric(temp_sheet[43,4]) ) / popl) * 100 
  
}


# B 13

sheet_ref <- "B 13"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  popl = abs2006_cd$Population[i]
  #question_popl = popl - as.numeric(temp_sheet[41,4]) - as.numeric(temp_sheet[40,4]) #remove not stated and inadequately described*
  
  #Religion
  abs2006_cd$Christianity[i] = (as.numeric(temp_sheet[31,4])/popl)*100
  abs2006_cd$Catholic[i] = (as.numeric(temp_sheet[16,4])/popl)*100
  abs2006_cd$Anglican[i] = (as.numeric(temp_sheet[12,4])/popl)*100
  abs2006_cd$Buddhism[i] = (as.numeric(temp_sheet[10,4])/popl)*100
  abs2006_cd$Islam[i] = (as.numeric(temp_sheet[33,4])/popl)*100
  abs2006_cd$Judaism[i] = (as.numeric(temp_sheet[34,4])/popl)*100
  abs2006_cd$NoReligion[i] = (as.numeric(temp_sheet[39,4])/popl)*100
  
  abs2006_cd$OtherChrist[i] = ((as.numeric(temp_sheet[31,4]) - as.numeric(temp_sheet[12,4]) - as.numeric(temp_sheet[16,4]))/popl)*100
  abs2006_cd$Other_NonChrist[i] = 100 - abs2006_cd$NoReligion[i] - abs2006_cd$Christianity[i] #Non Christian and not no religion
  
}


# B 14

sheet_ref <- "B 14"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = abs2006_cd$Population[i]
  
  #Percentage of total population that are currently studying at any level
  abs2006_cd$CurrentlyStudying[i] = (as.numeric(temp_sheet[51,4])/popl) * 100
}


# B 15

sheet_ref <- "B 15"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[49,11]) 
  #question_popl = as.numeric(temp_sheet[49,11]) - as.numeric(temp_sheet[47,11]) #only of aged 15+, removing "not stated"
  
  #Percentage of total population that have finished high school
  abs2006_cd$HighSchool[i] = (as.numeric(temp_sheet[39,11])/popl) * 100
}


# B 18

sheet_ref <- "B 18"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[48,5])
  #question_popl = as.numeric(temp_sheet[48,5]) - as.numeric(temp_sheet[48,4]) #aged 15+ and remove "not stated"
  
  #Percentage of people over 15 who volunteer
  abs2006_cd$Volunteer[i] = (as.numeric(temp_sheet[48,2])/popl) * 100
}


# B 24

sheet_ref <- "B 24"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  temp_sheet2 <- read_excel(excel_ref, sheet = "B 25")
  
  question_popl <- as.numeric(temp_sheet[45,2]) # Number of families
  
  #Family Ratio
  abs2006_cd$FamilyRatio[i] = as.numeric(temp_sheet2[46,4]) / question_popl #number of people in families / number of families
  
  # Couple without children household
  abs2006_cd$Couple_NoChild_House[i] = (as.numeric(temp_sheet[9,2]) / question_popl) * 100
  
  # One parent family household
  abs2006_cd$OneParent_House[i] = (as.numeric(temp_sheet[41,2]) / question_popl) * 100
  
  # Couple with children household
  abs2006_cd$Couple_WChild_House[i] = (as.numeric(temp_sheet[25,2]) / question_popl) * 100
  
}

remove(temp_sheet2)


# B 30

sheet_ref <- "B 30"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  # Single person household (% of total households)
  abs2006_cd$SP_House[i] = (as.numeric(temp_sheet[12,4]) / as.numeric(temp_sheet[19,4])) * 100
}


# B 32

sheet_ref <- "B 32"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Percentage of total population that do not own/mortgage their dwelling
  abs2006_cd$Owned[i] = (as.numeric(temp_sheet[12,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_cd$Mortgage[i] = (as.numeric(temp_sheet[14,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_cd$Renting[i] = (as.numeric(temp_sheet[23,7])/(as.numeric(temp_sheet[29,7]))) * 100
  abs2006_cd$PublicHousing[i] = (as.numeric(temp_sheet[18,7])/(as.numeric(temp_sheet[29,7]))) * 100
  
}


# B 35

sheet_ref <- "B 35"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Percentage of Dwellings with internet access
  abs2006_cd$InternetAccess[i] = (as.numeric(temp_sheet[16,7]) / (as.numeric(temp_sheet[20,7]) - as.numeric(temp_sheet[18,7]))) * 100 #excludes not stated
}


# B 36

sheet_ref <- "B 36"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  #Unemployment Rate
  abs2006_cd$Unemployed[i] = as.numeric(temp_sheet[21,4]) #Unemployed / Labour Force
  abs2006_cd$LFParticipation[i] = as.numeric(temp_sheet[22,4])#LF participation rate
}


# B 38

sheet_ref <- "B 38"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  # Different address to 5 years ago
  abs2006_cd$DiffAddress[i] = as.numeric(temp_sheet[27,4])/(as.numeric(temp_sheet[31,4])-as.numeric(temp_sheet[29,4])) * 100
}



# B 39b

sheet_ref <- "B 39b"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl <- abs2006_cd$Population[i]
  popl_15 <- popl*(100 - abs2006_cd$Age00_04[i] - abs2006_cd$Age05_14[i])/100 #population aged 15+
  #question_popl <- popl_15 - as.numeric(temp_sheet[27,10]) #Excludes not stated from total pop over 15
  
  #Bachelor and Postgraduate
  abs2006_cd$BachelorAbv[i] = ((as.numeric(temp_sheet[15,10]) + as.numeric(temp_sheet[11,10]) + as.numeric(temp_sheet[13,10])) / popl_15) * 100
  abs2006_cd$DipCert[i] = ((as.numeric(temp_sheet[17,10])+as.numeric(temp_sheet[23,10])) / popl_15) * 100
}


# B 42c

sheet_ref <- "B 42c"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[33,11])
  #question_popl <- as.numeric(temp_sheet[33,11]) - as.numeric(temp_sheet[31,11])
  
  # Industry of employment
  abs2006_cd$Extractive[i] = ((as.numeric(temp_sheet[11,11]) + as.numeric(temp_sheet[12,11]) + as.numeric(temp_sheet[14,11])) / popl) * 100
  abs2006_cd$Transformative[i] = ((as.numeric(temp_sheet[13,11]) + as.numeric(temp_sheet[15,11])) / popl) * 100
  abs2006_cd$Distributive[i] = ((as.numeric(temp_sheet[16,11]) + as.numeric(temp_sheet[17,11]) + as.numeric(temp_sheet[19,11])) / popl) * 100
  abs2006_cd$Finance[i] = (as.numeric(temp_sheet[21,11]) / popl) * 100
  abs2006_cd$SocialServ[i] = ((as.numeric(temp_sheet[26,11]) + as.numeric(temp_sheet[27,11]) + as.numeric(temp_sheet[28,11])) / popl) * 100
}


# B 44

sheet_ref <- "B 44"
print(paste("2006", sheet_ref))

for (i in 1:length(CD_2006)) {
  CD <- CD_2006[i]
  excel_ref <- paste0("/Volumes/J_External_HD/eechidna-paper-storage/ABS2006/Unzipped/BCP_", CD, ".xls")
  
  temp_sheet <- quiet_excel(excel_ref, sheet = sheet_ref)$result
  
  popl = as.numeric(temp_sheet[51,11])
  #question_popl <- as.numeric(temp_sheet[51,11]) - as.numeric(temp_sheet[51,10])
  
  # Occupation 
  abs2006_cd$ManagerAdminClericalSales[i] = ((as.numeric(temp_sheet[51,2]) + as.numeric(temp_sheet[51,6]) + as.numeric(temp_sheet[51,7])) / popl) * 100
  abs2006_cd$Professional[i] = ((as.numeric(temp_sheet[51,3])) / popl) * 100
  abs2006_cd$Tradesperson[i] = (as.numeric(temp_sheet[51,4]) / popl) * 100
  abs2006_cd$Laborer[i] = (as.numeric(temp_sheet[51,9]) / popl) * 100
  
}


# Change BornOverseas to BornElsewhere

abs2001_cd <- abs2001_cd %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas)

abs2006_cd <- abs2006_cd %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas)


d <- Sys.time()
print(paste("2006 took", d-c))

abs2006_cd_nominal <- abs2006_cd
save(abs2006_cd_nominal, file = "/Volumes/J_External_HD/eechidna-paper-storage/ABS2006_cd_nominal.rda")


# ------------------------------------------------------------------------------------------------------------

# Inflation

inflation_rates <- c(1.151, 1.330, 1.461)

abs2006_cd <- abs2006_cd %>%
  mutate(MedianFamilyIncome = MedianFamilyIncome/inflation_rates[1],
    MedianHouseholdIncome = MedianHouseholdIncome/inflation_rates[1],
    MedianLoanPay = MedianLoanPay/inflation_rates[1],
    MedianPersonalIncome = MedianPersonalIncome/inflation_rates[1],
    MedianRent = MedianRent/inflation_rates[1])

# Save
save(abs2001_cd, file = "/Volumes/J_External_HD/eechidna-paper-storage/ABS2001_cd.rda")
save(abs2001_cd, file = "data-raw/imputing-using-sa1/data/ABS2001_cd.rda")
save(abs2006_cd, file = "/Volumes/J_External_HD/eechidna-paper-storage/ABS2006_cd.rda")
save(abs2006_cd, file = "data-raw/imputing-using-sa1/data/ABS2006_cd.rda")
#usethis::use_data(abs2001_cd, overwrite = T, compress = "xz")
#usethis::use_data(abs2006_cd, overwrite = T, compress = "xz")

