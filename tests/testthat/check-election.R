# Election vote data

test_that("Division names are the same across vote types (in same election)", {
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
