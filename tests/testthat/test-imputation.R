# Checking that imputation functions work


test_that("Mapping and weighted_avg_census functions", {
  sF_11 <- sF_download(2011)
  sF_13 <- sF_download(2013)
  sF_16 <- sF_download(2016)
  cowan <- subset(sF_13, elect_div == "COWAN")
  
  map16 <- mapping_fn(cowan, sF_16)
  map11 <- mapping_fn(cowan, sF_11)
  
  cens16 <- weighted_avg_census(map16, abs2016)
  cens11 <- weighted_avg_census(map11, abs2011)
  
  cowan_imputed <- (2/5)*(select(cens16, -DivisionNm)) + (3/5)*(select(cens11, -DivisionNm))
  cowan_imputed$DivisionNm <- cens16$DivisionNm
  
  # Now test
  expect_equal(sum(!names(cowan_imputed) %in% names(abs2013)), 0)
  expect_equal(cowan_imputed$DipCert, 
    abs2013$DipCert[which(as.character(abs2013$DivisionNm)==as.character(cowan_imputed$DivisionNm))])
})
