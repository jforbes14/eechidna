# eechidna

## Exploring Election and Census Highly Informative Data Nationally for Australia

The R package *eechidna* provides data from the 2013 Australian Federal Election and 2011 Australian Census for each House of Representatives electorate, along with some tools for visualizing and analysing the data. 

## How to install

You can install the package from github using `devtools`:

```s
devtools::install_github("ropenscilabs/ausElectR", 
                         subdir = "echidnaR")
library(eechidna)
```

## How to use

In brief, the package consists of several datasets, include the 2011 Australian Census, the 2013 Australian Federal Election (House of Representatives), and shapefiles for all Australian electoral districts. 

Please have a look at our many vignettes to learn more about the structure of the data included with this package, and how to explore it. 

We also have a shiny app that can be run locally with `eechidna::launchApp()`

## License

This package is free and open source software, licensed under GPL (>= 2).
