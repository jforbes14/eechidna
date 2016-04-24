# eechidna

## Exploring Election and Census Highly Informative Data Nationally for Australia

The R package *eechidna* provides data from the 2013 Australian Federal Election and 2011 Australian Census for each House of Representatives electorate, along with some tools for visualizing and analysing the data. 

This package was developed during the [rOpenSci auunconf event](http://auunconf.ropensci.org/) in Brisbane, Queensland, during 21-22 April 2016. [Peter Ellis'](https://github.com/ellisp/) work on the NZ electoral data was an important inspiration for this package.

## How to install

You can install the package from github using `devtools`, like this:

```s
devtools::install_github("ropenscilabs/ausElectR", 
                         subdir = "echidnaR")
library(eechidna)
```

## How to use

In brief, the package consists of several datasets, including the 2011 Australian Census, the 2013 Australian Federal Election (House of Representatives), and shapefiles for all Australian electoral districts. 

We have a few vignettes that show the structure of the data  included with this package, and demonstrate a few methods for exploring it. 

We also have a shiny app that can be run locally with `eechidna::launchApp()`

## License

This package is free and open source software, licensed under GPL (>= 2).
