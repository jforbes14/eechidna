# Election vote data

test_that("Division names are the same across vote types - electorate", {
  expect_equal(tpp16$DivisionNm %>% table %>% names, fp16$DivisionNm %>% table %>% names)
  expect_equal(tcp16$DivisionNm %>% table %>% names, fp16$DivisionNm %>% table %>% names)
  
  expect_equal(tpp13$DivisionNm %>% table %>% names, fp13$DivisionNm %>% table %>% names)
  expect_equal(tcp13$DivisionNm %>% table %>% names, fp13$DivisionNm %>% table %>% names)
  
  expect_equal(tpp10$DivisionNm %>% table %>% names, fp10$DivisionNm %>% table %>% names)
  expect_equal(tcp10$DivisionNm %>% table %>% names, fp10$DivisionNm %>% table %>% names)
  
  expect_equal(tpp07$DivisionNm %>% table %>% names, fp07$DivisionNm %>% table %>% names)
  expect_equal(tcp07$DivisionNm %>% table %>% names, fp07$DivisionNm %>% table %>% names)
  
  expect_equal(tpp04$DivisionNm %>% table %>% names, fp04$DivisionNm %>% table %>% names)
  expect_equal(tcp04$DivisionNm %>% table %>% names, fp04$DivisionNm %>% table %>% names)
  
  expect_equal(tcp01$DivisionNm %>% table %>% names, fp01$DivisionNm %>% table %>% names)
})

test_that("Division names are the same across vote types - polling booth", {
  expect_equal(tpp_pp16$DivisionNm %>% table %>% names, fp_pp16$DivisionNm %>% table %>% names)
  expect_equal(tcp_pp16$DivisionNm %>% table %>% names, fp_pp16$DivisionNm %>% table %>% names)
  
  expect_equal(tpp_pp13$DivisionNm %>% table %>% names, fp_pp13$DivisionNm %>% table %>% names)
  expect_equal(tcp_pp13$DivisionNm %>% table %>% names, fp_pp13$DivisionNm %>% table %>% names)
  
  expect_equal(tpp_pp10$DivisionNm %>% table %>% names, fp_pp10$DivisionNm %>% table %>% names)
  expect_equal(tcp_pp10$DivisionNm %>% table %>% names, fp_pp10$DivisionNm %>% table %>% names)
  
  expect_equal(tpp_pp07$DivisionNm %>% table %>% names, fp_pp07$DivisionNm %>% table %>% names)
  expect_equal(tcp_pp07$DivisionNm %>% table %>% names, fp_pp07$DivisionNm %>% table %>% names)
  
  expect_equal(tpp_pp04$DivisionNm %>% table %>% names, fp_pp04$DivisionNm %>% table %>% names)
  expect_equal(tcp_pp04$DivisionNm %>% table %>% names, fp_pp04$DivisionNm %>% table %>% names)
  
  expect_equal(tpp_pp01$DivisionNm %>% table %>% names, fp_pp01$DivisionNm %>% table %>% names)
})
