## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.align = "center")

## ----echo = TRUE, message = FALSE----------------------------------------
library(eechidna)
library(tidyverse)

# Load data
data(fp16)
data(tpp16)
data(tcp16)

## ----who_won-------------------------------------------------------------
library(knitr)
who_won <- tcp16 %>% 
  filter(Elected == "Y") %>% 
  group_by(PartyNm) %>% 
  tally() %>% 
  arrange(desc(n)) 

# Inspect
who_won %>% 
  kable()

## ----total_votes_for_parties, message = F--------------------------------
total_votes_for_parties <- fp16 %>% 
  select(PartyNm, OrdinaryVotes) %>% 
  group_by(PartyNm) %>% 
  dplyr::summarise(total_votes = sum(OrdinaryVotes, rm.na = TRUE)) %>% 
  ungroup() %>%
  arrange(desc(total_votes))

# Plot the total votes for each party
ggplot(total_votes_for_parties, 
       aes(reorder(PartyNm, total_votes), 
           total_votes)) +
  geom_point(size = 2) + 
  coord_flip() + 
  scale_y_continuous(labels = scales::comma) +
  theme_bw() +
  ylab("Total number of first preference votes") +
  xlab("Party") +
  theme(text = element_text(size=8))

## ----message = F---------------------------------------------------------
# Download TPP for all elections
tpp_pollingbooth <- twoparty_pollingbooth_download()

# Plot the densities of the TPP vote in each election
tpp_pollingbooth %>% 
  filter(StateAb == "NSW") %>% 
  ggplot(aes(x = year, y = LNP_Percent, fill = factor(year))) + 
  geom_boxplot(alpha = 0.3) +
  theme_minimal() + 
  guides(fill=F) +
  labs(x = "Year", y = "Two party preferred % in favour \nof the Liberal/National Coalition")

## ------------------------------------------------------------------------
# Load
data(abs2016)

# Dimensions
dim(abs2016)

# Preview some of the data
abs2016 %>% 
  select(DivisionNm, State, Population, Area, AusCitizen, BachelorAbv, Indigenous, MedianAge, Unemployed) %>%
  head %>% 
  kable

## ------------------------------------------------------------------------
ggplot(data = abs2016,
       aes(x = reorder(State, -Unemployed),
           y = Unemployed,
           colour = State)) + 
  geom_boxplot() + 
  labs(x = "State",
       y = "% Unemployment") + 
  theme_minimal() + 
  theme(legend.position = "none") 

## ------------------------------------------------------------------------
ggplot(data = abs2016,
       aes(x = reorder(State, -MedianPersonalIncome),
           y = MedianPersonalIncome,
           colour = State)) + 
  geom_boxplot() + 
  geom_jitter(alpha = 0.35, 
              size = 2,
              width = 0.3) +
  theme_minimal() + 
  theme(legend.position = "none") + 
  labs(x = "State", y = "Median Personal Income ($)")

## ------------------------------------------------------------------------
# Load
data(abs2011)
data(abs2006)
data(abs2001)

# Bind and plot 
bind_rows(abs2016 %>% mutate(year = "2016"), abs2011 %>% mutate(year = "2011"), abs2006 %>% mutate(year = "2006"), abs2001 %>% mutate(year = "2001")) %>% 
  ggplot(aes(x = year, y = MedianAge, col = year)) + 
  geom_boxplot() +
  geom_jitter(alpha = 0.3) +
  guides(col = F) + 
  labs(x = "Year", y = "Median Age") +
  theme_minimal()
  

## ------------------------------------------------------------------------
library(ggthemes)
data(nat_map16)
data(nat_data16)

ggplot(aes(map_id=id), data=nat_data16) +
  geom_map(aes(fill=state), map=nat_map16, col = "grey50") +
  expand_limits(x=nat_map16$long, y=nat_map16$lat) + 
  theme_map() + coord_equal()

## ------------------------------------------------------------------------
# Get the electorate winners
map.winners <- fp16 %>% filter(Elected == "Y") %>% 
  select(DivisionNm, PartyNm) %>% 
  merge(nat_map16, by.x="DivisionNm", by.y="elect_div")

# Grouping
map.winners$PartyNm <- as.character(map.winners$PartyNm)
map.winners <- map.winners %>% arrange(group, order)

# Colour cells to match that parties colours
# Order = Australian Labor Party, Independent, Katters, Lib/Nats Coalition, Palmer, The Greens
partycolours = c("#FF0033", "#000000", "#CC3300", "#0066CC", "#FFFF00", "#009900")


ggplot(data=map.winners) + 
  geom_polygon(aes(x=long, y=lat, group=group, fill=PartyNm)) +
  scale_fill_manual(name="Political Party", values=partycolours) +
  theme_map() + coord_equal() + theme(legend.position="bottom")

## ------------------------------------------------------------------------
# Get winners
cart.winners <- fp16 %>% filter(Elected == "Y") %>% 
  select(DivisionNm, PartyNm) %>% 
  merge(nat_data16, by.x="DivisionNm", by.y="elect_div")

# Plot dorling cartogram
ggplot(data=nat_map16) +
  geom_polygon(aes(x=long, y=lat, group=group),
               fill="grey90", colour="white") +
  geom_point(data=cart.winners, aes(x=x, y=y, colour=PartyNm), size = 0.75, alpha=0.8) +
  scale_colour_manual(name="Political Party", values=partycolours) +
  theme_map() + coord_equal() + theme(legend.position="bottom")

## ------------------------------------------------------------------------
# Join
data16 <- left_join(tpp16 %>% select(LNP_Percent, DivisionNm), abs2016, by = "DivisionNm")

# Fit a model using all of the available population characteristics
lmod <- data16 %>% 
  select(-c(ends_with("NS"), Area, Population, DivisionNm, ID, State, EmuneratedElsewhere, InternetUse, Other_NonChrist, OtherChrist, EnglishOnly)) %>% 
  lm(LNP_Percent ~ ., data = .)

# See if the variables are jointly significant
library(broom)
lmod %>% 
  glance %>% 
  kable

## ------------------------------------------------------------------------
# See which variables are individually significant
lmod %>% 
  tidy %>% 
  filter(p.value < 0.05) %>% 
  arrange(p.value) %>% 
  kable

