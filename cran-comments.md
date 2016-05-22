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
  