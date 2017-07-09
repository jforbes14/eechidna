## Test environments
* local Windows 7 install, R 3.4.0
* Debian Linux, R-devel, GCC (on r-hub.io), R 3.4.0
* win-builder (devel and release) R Under development (unstable) (2017-05-20 r72708)

3 July 2017

CRAN reports:

##
https://cran.r-project.org/web/checks/check_results_eechidna.html

Quitting from lines 155-172 (exploring-election-data.Rmd) 
    Error: processing vignette ‘exploring-election-data.Rmd’ failed with diagnostics:
    Value of SET_STRING_ELT() must be a 'CHARSXP' not a 'character'
    Execution halted 
##

I can't reliably reproduce this. Fifty runs of `devtools::check()` gives failed builds 29/50, build with warning 1/21, and 20 builds with no warning. Similar results with smaller scale testing on `devtools::build_win()` and `rhub::check_for_cran()`. Not sure what to do.

The locus of the problem is in these lines, in the chunk at lines 155-172 of exploring-election-data.Rmd: 

```
dplyr::mutate(prop_votes = round(sum_votes / sum(sum_votes), 3),
              sum_votes = as.character(prettyNum(sum_votes, ","))) %>% 
dplyr::ungroup() %>% 
dplyr::arrange(dplyr::desc(prop_votes))
```

---

## R CMD check results

0 errors | 0 warnings | 1 note

## Reverse dependencies

There are no reverse dependencies.

---

* I have not run R CMD check on the downstream dependencies.

## CRAN submission notes

* This is a minor update in response to an email from Kurt Hornik on 21 May 2017 alerting us to warnings emitted from CRAN builds. The warnings come from the function `dmap` having been moved from the purrr package to the new purrrlyer package. We've now fixed this and the warnings have gone from our tests. 

* We have one note
-- installed package size 6.3 Mb: these are the data files that are needed for the pkg to function

---------------------------------------------------------------------------------
## Test environments
* local Windows 7 install, R 3.2.3
* ubuntu 12.04 (on travis-ci), R 3.2.3
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* I have not run R CMD check on the downstream dependencies.

## CRAN submission notes

> 1. Please do not wrap all examples in \dontrun{}...

I've removed most of the \dontrun{} now. We do have one example for aec_carto_f that takes 5.3 sec to run

Some functions in this package are taken from packages currently only on github. We do not explot these, or include runnable examples because we do not want this package to be canonical version of those functions. We want users to refer to original author's work on github if they want to use those functions. We note this in the documentation of these functions in our package. 

> 2. Please mention all authors and copyright holder

I've updated DESCRIPTION to use the Authors@R format

> 3. Also, this is too huge: Size of tarball: 28698012 bytes is > 5MB (max size for a CRAN package)

I've removed the 35 MB shapefile in the vignettes folder, which was not necessary for any of the core functions. 
  