## Test environments
* local macOS Mojave install, R 3.5.2
* ubuntu 14.04 (on travis-ci), R 3.5.2
* windows Visual Studio 2015 (on appveyor), R 3.5.3
* win-builder (devel and release) R Under development (unstable) (2019-03-12 r76226)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (r-hub)
* Fedora Linux, R-devel, clang, gfortran (r-hub)

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Reverse dependencies

There are no reverse dependencies.

## CRAN submission notes

* This is a substantial data update from the last version of the pkg, which was recently removed from CRAN. More Census and election data has been made available and spans more years. Shapefiles and polling booth data can be obtained functions in the pkg that download directly from the github repo. 