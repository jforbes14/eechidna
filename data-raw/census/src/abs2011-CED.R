## This script creates the abs2011 dataframe from the ABS Census 2011 Datapacks
## Metrics are consistent with Census from 2001, 2006 and 2016.
## The individual csv files must be held locally. They come from a zip file and can be downloaded from:
## https://datapacks.censusdata.abs.gov.au/datapacks/
## Select: 2011 Census Datapacks, General Community Profile, Commonwealth Electoral Divisons
## Download for all of Australia

library(tidyverse)
library(readxl)

B1_Main<- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B01_AUST_CED_short.csv")
B02_Medians <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B02_AUST_CED_short.csv")
B06_Marriage <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B06_AUST_CED_short.csv")
B09_BornOverseas <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B09_AUST_CED_short.csv")
B13_LanguageHome <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B13_AUST_CED_short.csv")
B14_Religion <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B14_AUST_CED_short.csv")
B15_Study <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B15_AUST_CED_short.csv")
B16A_HighSchool <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B16A_AUST_CED_short.csv")
B16B_HighSchool <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B16B_AUST_CED_short.csv")
B17B_Income <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B17B_AUST_CED_short.csv")
B19_Volunteer <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B19_AUST_CED_short.csv")
B25_Family <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B25_AUST_CED_short.csv")
B26_FamilyIncome <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B26_AUST_CED_short.csv")
B28_HouseholdIncome <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B28_AUST_CED_short.csv")
B30_NumberInHouse <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B30_AUST_CED_short.csv")
B32_Tenure <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B32_AUST_CED_short.csv")
B34_Rent <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B34_AUST_CED_short.csv")
B35_Internet <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B35_AUST_CED_short.csv")
B37_Employ <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B37_AUST_CED_short.csv")
B39_Address <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B39_AUST_CED_short.csv")
B40B_Uni <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B40B_AUST_CED_short.csv")
B43C_Industry <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B43C_AUST_CED_short.csv")
B43D_Industry <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B43D_AUST_CED_short.csv")
B45B_Occupation <- read_csv("data-raw/census/data/2011_BCP_CED_for_AUST_short-header/2011Census_B45B_AUST_CED_short.csv")


CED <- read_csv("data-raw/supplement/tidy_CED11.csv")

new_2011 <- B1_Main %>% mutate(
  ID = CED$CED,
  Electorate = CED$Electorate,
  State = CED$State,
  
  #B01
  Population = Tot_P_P,
  Age00_04 = (Age_0_4_yr_P/Tot_P_P)*100, 
  Age05_14 = (Age_5_14_yr_P/Tot_P_P)*100,
  Age15_19 = (Age_15_19_yr_P/Tot_P_P)*100,
  Age20_24 = (Age_20_24_yr_P/Tot_P_P)*100,
  Age25_34 = (Age_25_34_yr_P/Tot_P_P)*100,
  Age35_44 = (Age_35_44_yr_P/Tot_P_P)*100,
  Age45_54 = (Age_45_54_yr_P/Tot_P_P)*100,
  Age55_64 = (Age_55_64_yr_P/Tot_P_P)*100,
  Age65_74 = (Age_65_74_yr_P/Tot_P_P)*100,
  Age75_84 = (Age_75_84_yr_P/Tot_P_P)*100,
  Age85plus = (Age_85ov_P/Tot_P_P)*100,
  Age15plus = Tot_P_P - Age_0_4_yr_P - Age_5_14_yr_P,
  AusCitizen = (Australian_citizen_P / Tot_P_P)*100,
  BornOverseas = (Birthplace_Elsewhere_P/ (Birthplace_Elsewhere_P + Birthplace_Australia_P))*100,
  Indigenous = (Indigenous_P_Tot_P/Tot_P_P)*100,
  OtherLanguageHome = (Lang_spoken_home_Oth_Lang_P/ (Lang_spoken_home_Oth_Lang_P + Lang_spoken_home_Eng_only_P))*100,
  EnglishOnly = 100 - OtherLanguageHome,
  
  #B02
  AverageHouseholdSize = B02_Medians$Average_household_size,
  MedianHouseholdIncome = B02_Medians$Median_Tot_hhd_inc_weekly,
  MedianFamilyIncome = B02_Medians$Median_Tot_fam_inc_weekly,
  MedianRent = B02_Medians$Median_rent_weekly,
  MedianLoanPay = B02_Medians$Median_mortgage_repay_monthly,
  MedianAge = B02_Medians$Median_age_persons,
  MedianPersonalIncome = B02_Medians$Median_Tot_prsnl_inc_weekly,
  
  #B06
  Married = (B06_Marriage$P_Tot_Marrd_reg_marrge/B06_Marriage$P_Tot_Total)*100,
  DeFacto = (B06_Marriage$P_Tot_Married_de_facto/B06_Marriage$P_Tot_Total)*100,
  
  #B09
  BornOverseas_NS = (B09_BornOverseas$Country_birth_not_stated_P / B09_BornOverseas$Tot_P)*100, #potential fix needed for NA and 100%
  Born_UK = (B09_BornOverseas$UK_Channel_Islands_Isle_Man_P / (B09_BornOverseas$Tot_P)) * 100,
  Born_MidEast = ((B09_BornOverseas$Egypt_P + B09_BornOverseas$Iraq_P + B09_BornOverseas$Lebanon_P + B09_BornOverseas$Turkey_P) / (B09_BornOverseas$Tot_P)) * 100,
  Born_SE_Europe = ((B09_BornOverseas$Bosnia_Herzegovina_P + B09_BornOverseas$Croatia_P + B09_BornOverseas$Greece_P + B09_BornOverseas$Frmr_Yug_Repc_Mac_FYROM_P + B09_BornOverseas$South_Eastern_Europe_nfd_P) / (B09_BornOverseas$Tot_P)) * 100,
  Born_Asia = ((B09_BornOverseas$Cambodia_P + B09_BornOverseas$China_excl_SARs_Taiwan_P + B09_BornOverseas$Hong_Kong_SAR_China_P + B09_BornOverseas$India_P + B09_BornOverseas$Indonesia_P + B09_BornOverseas$Japan_Tot + B09_BornOverseas$Korea_Republic_South_P + B09_BornOverseas$Malaysia_P + B09_BornOverseas$Philippines_P + B09_BornOverseas$Singapore_P + B09_BornOverseas$Sri_Lanka_P + B09_BornOverseas$Thailand_P + B09_BornOverseas$Vietnam_P) / (B09_BornOverseas$Tot_P)) * 100,
  
  #B13
  Language_NS = (B13_LanguageHome$Language_spoken_home_ns_P / B13_LanguageHome$Total_P)*100,
  
  #B14
  Christianity = (B14_Religion$Christianity_Tot_P/(B14_Religion$Tot_P))*100,
  Anglican = (B14_Religion$Christianity_Anglican_P/(B14_Religion$Tot_P))*100,
  Catholic = (B14_Religion$Christianity_Catholic_P/(B14_Religion$Tot_P))*100,
  Buddhism = (B14_Religion$Buddhism_P/(B14_Religion$Tot_P))*100,
  Islam = (B14_Religion$Islam_P/(B14_Religion$Tot_P))*100,
  Judaism = (B14_Religion$Judaism_P/(B14_Religion$Tot_P))*100,
  NoReligion = (B14_Religion$No_Religion_P/(B14_Religion$Tot_P))*100,
  OtherChrist = ((B14_Religion$Christianity_Tot_P - B14_Religion$Christianity_Anglican_P - B14_Religion$Christianity_Catholic_P)/(B14_Religion$Tot_P))*100,
  Religion_NS = (B14_Religion$Religious_affiliation_ns_P/B14_Religion$Tot_P)*100,
  Other_NonChrist = 100 - NoReligion - Christianity,
  #Other_NonChrist = (1- ((B14_Religion$Christianity_Tot_P + B14_Religion$No_Religion_P)/(B14_Religion$Tot_P)))*100,
  
  #B15
  CurrentlyStudying = (B15_Study$Tot_P / Tot_P_P)*100, #of total population
  
  #B16
  HighSchool = (B16A_HighSchool$P_Y12e_Tot/(B16B_HighSchool$P_Tot_Tot))*100,
  HighSchool_NS = (B16B_HighSchool$P_Hghst_yr_schl_ns_Tot/B16B_HighSchool$P_Tot_Tot)*100, #of age appropriate population
  
  #B17B
  PersonalIncome_NS = (B17B_Income$P_PI_NS_ns_Tot / B17B_Income$P_Tot_Tot)*100,
  
  #B19
  Volunteer = (B19_Volunteer$P_Tot_Volunteer / (B19_Volunteer$P_Tot_Tot))*100,
  Volunteer_NS = (B19_Volunteer$P_Tot_Voluntary_work_ns / B19_Volunteer$P_Tot_Tot)*100,

  #B25
  FamilyRatio = B25_Family$Total_P/B25_Family$Total_F, #average number of people per family
  Couple_NoChild_House = (B25_Family$CF_no_children_F/B25_Family$Total_F)*100,
  Couple_WChild_House = (B25_Family$CF_Total_F/B25_Family$Total_F)*100,
  OneParent_House = (B25_Family$OPF_Total_F/B25_Family$Total_F)*100,
  
  #B26
  FamilyIncome_NS = ((B26_FamilyIncome$Partial_income_stated_Tot + B26_FamilyIncome$All_incomes_ns_Tot) / B26_FamilyIncome$Tot_Tot)*100,
  #includes no income and partial income entries
  
  #B28
  HouseholdIncome_NS = ((B28_HouseholdIncome$Partial_income_stated_Tot + B28_HouseholdIncome$All_incomes_not_stated_Tot) / B28_HouseholdIncome$Tot_Tot)*100,
  #includes no income and partial income entries
  
  #B30
  SP_House = (B30_NumberInHouse$Num_Psns_UR_1_Total/B30_NumberInHouse$Total_Total)*100,
  
  #B32
  Owned = (B32_Tenure$O_OR_Total/(B32_Tenure$Total_Total))*100,
  Mortgage = ((B32_Tenure$O_MTG_Total)/(B32_Tenure$Total_Total))*100,
  Renting = (B32_Tenure$R_Tot_Total/(B32_Tenure$Total_Total))*100,
  PublicHousing = (B32_Tenure$R_ST_h_auth_Total/(B32_Tenure$Total_Total))*100,

  Tenure_NS = (B32_Tenure$Ten_type_NS_Total / B32_Tenure$Total_Total)*100,
  
  #B34
  Rent_NS = (B34_Rent$Rent_ns_Tot / B34_Rent$Tot_Tot)*100,
  
  #B35
  InternetAccess = (B35_Internet$Tof_IC_Tot_Total/(B35_Internet$Total_Total))*100,
  InternetAccess_NS = (B35_Internet$IC_not_stated_Total / B35_Internet$Total_Total)*100,
  
  #B37
  Unemployed = B37_Employ$Percent_Unem_loyment_P,
  LFParticipation = B37_Employ$Percnt_LabForc_prticipation_P,
  
  #B39
  DiffAddress = (1 - (B39_Address$Sme_Usl_ad_5_yr_ago_as_2011_P/(B39_Address$Tot_P)))*100,
  
  #B40B
  BachelorAbv = ((B40B_Uni$P_BachDeg_Total + B40B_Uni$P_PGrad_Deg_Total + B40B_Uni$P_GradDip_and_GradCert_Total)/ (Population*(100 - Age00_04 - Age05_14)/100))*100,
  DipCert = ((B40B_Uni$P_AdvDip_and_Dip_Total + B40B_Uni$P_Cert_Lev_Tot_Total) /(Population*(100 - Age00_04 - Age05_14)/100))*100,
  University_NS = ((B40B_Uni$P_Lev_Edu_IDes_Total + B40B_Uni$P_Lev_Edu_NS_Total) / (Population*(100 - Age00_04 - Age05_14)/100))*100,
  #Using the total population 15+ in the denominator, instead of the total given in the response
  
  #B43
  Extractive = ((B43C_Industry$P_Ag_For_Fshg_Tot + B43C_Industry$P_Mining_Tot + B43C_Industry$P_El_Gas_Wt_Waste_Tot) / (B43D_Industry$P_Tot_Tot)) * 100,
  Transformative = ((B43C_Industry$P_Constru_Tot + B43C_Industry$P_Manufact_Tot) / (B43D_Industry$P_Tot_Tot)) * 100,
  Distributive = ((B43C_Industry$P_WhlesaleTde_Tot + B43C_Industry$P_RetTde_Tot + B43C_Industry$P_Trans_post_wrehsg_Tot) / (B43D_Industry$P_Tot_Tot)) * 100,
  Finance = (B43C_Industry$P_Fin_Insur_Tot / (B43D_Industry$P_Tot_Tot)) * 100,
  SocialServ = ((B43C_Industry$P_Educ_trng_Tot + B43C_Industry$P_HlthCare_SocAs_Tot + B43C_Industry$P_Art_recn_Tot) / (B43D_Industry$P_Tot_Tot)) * 100,
  
  #B45
  ManagerAdminClericalSales = ((B45B_Occupation$P_Tot_Managers + B45B_Occupation$P_Tot_ClericalAdminis_W + B45B_Occupation$P_Tot_Sales_W) / (B45B_Occupation$P_Tot_Tot))*100,
  Professional = (B45B_Occupation$P_Tot_Professionals / (B45B_Occupation$P_Tot_Tot))*100,
  Tradesperson = (B45B_Occupation$P_Tot_TechnicTrades_W / (B45B_Occupation$P_Tot_Tot))*100,
  Laborer = (B45B_Occupation$P_Tot_Labourers / (B45B_Occupation$P_Tot_Tot))*100,
  
  #Area
  Area = as.numeric(CED$Area.sqkm),
  
  #Other
  EmuneratedElsewhere = 0,
  InternetUse = 0,
  InternetUse_NS = 0
)

rows_select <- as.numeric(CED$Area.sqkm) != 0

abs2011 <- new_2011[rows_select ,c(110:124,126:ncol(new_2011))]


# inflation
inflation_rates <- c(1.151, 1.330, 1.461)
abs2011 <- abs2011 %>%
  mutate(MedianFamilyIncome = MedianFamilyIncome/inflation_rates[2],
         MedianHouseholdIncome = MedianHouseholdIncome/inflation_rates[2],
         MedianLoanPay = MedianLoanPay/inflation_rates[2],
         MedianPersonalIncome = MedianPersonalIncome/inflation_rates[2],
         MedianRent = MedianRent/inflation_rates[2])

# Change BornOverseas to BornElsewhere
abs2011 <- abs2011 %>%
  mutate(BornElsewhere = BornOverseas - Born_MidEast - Born_SE_Europe - Born_UK) %>% 
  select(-BornOverseas) 

# Order electorate alphabetically, rename electorate column to match election data and reorder columns

abs2011 <- abs2011 %>% 
  rename(DivisionNm = Electorate) %>% 
  arrange(DivisionNm) %>% 
  mutate(DivisionNm = toupper(DivisionNm)) %>% 
  select(order(colnames(.))) %>% 
  select(ID, DivisionNm, State, Population, Area, everything())

# Save
save(abs2011, file = "data-raw/census/data/abs2011.rda")

# Remove objects from environment
objs = ls()[grepl("^B[0-9]{1-2}", ls())]
for (ob in objs) {remove(list=ob)}
remove(objs)
