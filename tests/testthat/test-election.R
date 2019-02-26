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
  fp_pp <- firstpref_pollingbooth_download()
  tpp_pp <- twoparty_pollingbooth_download()
  tcp_pp <- twocand_pollingbooth_download()
  
  expect_equal(fp_pp %>% select(DivisionNm, year) %>% unique() %>% nrow(), 900)
  expect_equal(tpp_pp %>% select(DivisionNm, year) %>% unique() %>% nrow(), 900)
  expect_equal(tcp_pp %>% select(DivisionNm, year) %>% unique() %>% nrow(), 750)
})
