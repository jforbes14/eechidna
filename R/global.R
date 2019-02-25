# to appease R CMD check
# most of these are in R/app.R
utils::globalVariables(
  c("variable", "value", "ID", "Electorate", "State", "BallotPosition",
    "PartyAb", "OrdinaryVotes", "formal", "total_formal", "fill", "prop",
    "xcent", "ycent", "x", "y", "group", "lat", "long", "Elected",
    "PartyNm", "difference", "nseats", "Total_OrdinaryVotes_in_electorate",
    "Average_Australian_Labor_Party_Percentage_in_electorate",
    "Average_Liberal_National_Coalition_Percentage_in_electorate",
    "Average_Australian_Labor_Party_Percentage_in_electorate",
    "Average_Liberal_National_Coalition_Percentage_in_electorate",
    "Total_OrdinaryVotes_in_electorate", "aec2013_2cp_electorate",
    "GivenNm", "Surname", "TotalVotes", "FullName", "parties", 
    "candidates","tooltip", "Elect_div", "Numccds", "Area_SqKm", 
    "long_c", "lat_c", "config", "glob2rx","download.file","unzip",
    "ogrListLayers",
    "elect_div", "region", "state", "DivisionNm", "tcp13", 
    "Intersect_area", "AEC_division_area", "ABS_division_area",
    "AEC_division", "ABS_division", "Area", "Percent_Census_Composition",
    "Population", "imputed_population", "total_pop", "Age00_04", "Volunteer",
    "tolerance_rad"))
