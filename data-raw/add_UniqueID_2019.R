# Add UniqueID to 2019 data
abs2019 <- abs2019 %>% 
  left_join(abs2016 %>% select(DivisionNm, UniqueID))

fp19 <- fp19 %>% 
  left_join(fp16 %>% select(DivisionNm, UniqueID))

tpp19 <- tpp19 %>% 
  left_join(tpp16 %>% select(DivisionNm, UniqueID))

tcp19 <- tcp19 %>% 
  left_join(tcp16 %>% select(DivisionNm, UniqueID))

new_names <- c("BEAN", "CLARK", "COOPER", "FRASER", "MACNAMARA", "MONASH", "NICHOLLS", "SPENCE")
new_IDs <- c(803, 603, 203, 238, 232, 230, 234, 411)

for (i in 1:length(new_names)) {
  abs2019$UniqueID[which(abs2019$DivisionNm == new_names[i])] <- new_IDs[i]
  fp19$UniqueID[which(fp19$DivisionNm == new_names[i])] <- new_IDs[i]
  tpp19$UniqueID[which(tpp19$DivisionNm == new_names[i])] <- new_IDs[i]
  tcp19$UniqueID[which(tcp19$DivisionNm == new_names[i])] <- new_IDs[i]
}

usethis::use_data(abs2019, overwrite = T, compress = "xz")
usethis::use_data(fp19, overwrite = T, compress = "xz")
usethis::use_data(tpp19, overwrite = T, compress = "xz")
usethis::use_data(tcp19, overwrite = T, compress = "xz")