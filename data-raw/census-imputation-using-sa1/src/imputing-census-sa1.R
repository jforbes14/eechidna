# Imputing Census information for electorates at the time of the 2004, 2007, 2010 and 2013 federal elections

library(tidyverse)
library(eechidna)

# ------------------------------------------------------------------------------------------------------

# Checking how many NAs/0/Inf

checker <- function(x) {
  s = rep(0, nrow(x))
  for (i in 1:nrow(x)) {
    y <- x[i, ] %>% unlist
    s[i] = sum(is.na(y)) + sum(is.nan(y)) + sum(y == Inf)
  }
  
  return(s)
}

test <- checker(abs2016_cd)

# ------------------------------------------------------------------------------------------------------

# Function to do the imputation
weighted_avg_census_sa1 <- function(mapping_df, abs_df) {
  mapping_df <- mapping_df %>% 
    arrange(electorate) %>% 
    mutate(sa1 = as.character(sa1))
  
  abs_df <- abs_df %>% 
    mutate(CD = as.character(CD)) %>% 
    filter(!is.na(Population), Population > 0) %>%
    select(-c(ends_with("NS"), Area)) %>% 
    select(sort(tidyselect::peek_vars())) %>% 
    select(CD, Population, everything())
  
  divs <- unique(mapping_df$electorate)
  divs <- divs[divs != "0"]
  
  for (i in 1:length(divs)) {
    # Election division
    div <- divs[i]
    
    # Mapping for the division
    mapping_div <- mapping_df %>% 
      filter(electorate == div)
    
    # Census info from the relevant divisions
    census_divs <- abs_df %>%
      filter(CD %in% mapping_div$sa1) 

    # Weighted average of each variable, using only valid numbers
    imputed_df <- data.frame(
      vars = colnames(census_divs %>% select(-CD)), 
      value = 0)
    
    for (j in 1:nrow(imputed_df)) {
      
      # Variable
      var_name <- as.character(imputed_df$vars[j])
      var_vals <- census_divs[, var_name] %>% unlist
      var_population <- census_divs[, "Population"] %>% unlist
      
      # Filter valid numbers
      valid_var_index <- which(!var_vals %in% c(NA, Inf, NaN))
      valid_pop_index <- which(!var_population %in% c(NA, Inf, NaN, 0))
      valid_index <- intersect(valid_var_index, valid_pop_index)
      valid_var_vals <- var_vals[valid_index]
      valid_var_population <- var_population[valid_index]
      
      if (var_name != "Population") {
        # Imputation weights
        var_imputation_weights <- valid_var_population/sum(valid_var_population)
        
        # Imputed value
        imputed_df$value[j] <- sum(valid_var_vals * var_imputation_weights)
        
      } else {
        # Imputed Population
        imputed_df$value <- sum(valid_var_vals)
      }
      
    }
    
    
    # Imputed profile
    imputed_profile <- imputed_df %>% 
      column_to_rownames(var = "vars") %>% 
      t() %>% 
      data.frame() %>% 
      mutate(DivisionNm = div)
    
    # Update
    if (i == 1) {
      keep_imputed_profiles <- imputed_profile
    } else {
      keep_imputed_profiles <- bind_rows(keep_imputed_profiles, imputed_profile)
    }
    
  }
  
  return(keep_imputed_profiles)
}

# ------------------------------------------------------------------------------------------------------

# Warning function to check that DivisionNm matches
divname_warning <- function(census_aec_1, census_aec_2) {
  if (sum(census_aec_1$DivisionNm == census_aec_2$DivisionNm) != 150) {
    warning("Division names do not match - check that the correct election shapefile has been used for both Censuses.")
  }
}

# ------------------------------------------------------------------------------------------------------

# Apply
census_aec19_16 <- weighted_avg_census_sa1(mapping_df = mapping_c16_e19, abs_df = abs2016_cd)
census_aec13_16 <- weighted_avg_census_sa1(mapping_df = mapping_c16_e13, abs_df = abs2016_cd)
census_aec13_11 <- weighted_avg_census_sa1(mapping_df = mapping_c11_e13, abs_df = abs2011_cd)
census_aec10_11 <- weighted_avg_census_sa1(mapping_df = mapping_c11_e10, abs_df = abs2011_cd)
census_aec10_06 <- weighted_avg_census_sa1(mapping_df = mapping_c06_e10, abs_df = abs2006_cd)
census_aec07_11 <- weighted_avg_census_sa1(mapping_df = mapping_c11_e07, abs_df = abs2011_cd)
census_aec07_06 <- weighted_avg_census_sa1(mapping_df = mapping_c06_e07, abs_df = abs2006_cd)
census_aec04_06 <- weighted_avg_census_sa1(mapping_df = mapping_c06_e04, abs_df = abs2006_cd)
census_aec04_01 <- weighted_avg_census_sa1(mapping_df = mapping_c01_e04, abs_df = abs2001_cd)

# Check that DivisionNm matches
divname_warning(census_aec13_11, census_aec13_16)
divname_warning(census_aec10_06, census_aec10_11)
divname_warning(census_aec07_06, census_aec07_11)
divname_warning(census_aec04_01, census_aec04_06)

# Linearly interpolate using inverse distance weighting (power of 1)
abs2019 <- census_aec19_16
abs2013 <- (2/5)*(select(census_aec13_16, -DivisionNm)) + (3/5)*(select(census_aec13_11, -DivisionNm))
abs2010 <- (4/5)*(select(census_aec10_11, -DivisionNm)) + (1/5)*(select(census_aec10_06, -DivisionNm))
abs2007 <- (1/5)*(select(census_aec07_11, -DivisionNm)) + (4/5)*(select(census_aec07_06, -DivisionNm))
abs2004 <- (3/5)*(select(census_aec04_06, -DivisionNm)) + (2/5)*(select(census_aec04_01, -DivisionNm))

# Maintain division names
abs2019$DivisionNm <- census_aec19_16$DivisionNm
abs2013$DivisionNm <- census_aec13_16$DivisionNm
abs2010$DivisionNm <- census_aec10_11$DivisionNm
abs2007$DivisionNm <- census_aec07_11$DivisionNm
abs2004$DivisionNm <- census_aec04_06$DivisionNm

# Reset rownames
rownames(abs2019) <- NULL
rownames(abs2013) <- NULL
rownames(abs2010) <- NULL
rownames(abs2007) <- NULL
rownames(abs2004) <- NULL

# Save
save(abs2019, file = "data-raw/census-imputation-using-sa1/data/abs2019.rda")
save(abs2013, file = "data-raw/census-imputation-using-sa1/data/abs2013.rda")
save(abs2010, file = "data-raw/census-imputation-using-sa1/data/abs2010.rda")
save(abs2007, file = "data-raw/census-imputation-using-sa1/data/abs2007.rda")
save(abs2004, file = "data-raw/census-imputation-using-sa1/data/abs2004.rda")
