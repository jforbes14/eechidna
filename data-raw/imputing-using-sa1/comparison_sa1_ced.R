# comparing imputations

comp <- abs2013_cd %>% 
  gather(key = "Variable", value = "Value", -DivisionNm) %>% 
  mutate(type = "SA1") %>% 
  bind_rows(abs2013 %>% 
      select(-UniqueID) %>% 
      gather("Variable", "Value", -DivisionNm) %>% 
      mutate(type = "CED")) %>% 
  spread(key = "type", value = "Value") %>% 
  filter(!Variable %in% c("EmuneratedElsewhere", "InternetUse"))

comp %>% 
  mutate(error = abs((CED-SA1)/SA1)) %>% 
  group_by(Variable) %>% 
  summarise(avg_error = mean(error)) %>% 
  filter(avg_error > 0.1) %>% 
  ggplot(aes(x = Variable, y = avg_error)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 60))

  #filter(SA1 <= 110) %>% 
  #ggplot(aes(x = SA1, y = CED)) +
  #geom_point(alpha = 0.1)

# Do a percentage difference for each metric and plot distributions

# Aggregating 2016 just using SA1
sa1_list <- centroids_sa1_2016$data %>% 
  left_join(allocate_sa1_2016, by = c("SA1_MAIN16" = "sa1")) %>% 
  select(SA1_7DIGIT, electorate) %>% 
  mutate(SA1_7DIGIT = as.character(SA1_7DIGIT))

sa1_list_abs <- left_join(abs2016_cd %>% mutate(CD = as.character(CD)), sa1_list, by = c("CD" = "SA1_7DIGIT"))

sa1_list_abs %>% filter(electorate == "SYDNEY") %>% select(Population, Indigenous) %>% mutate(Indigenous = ifelse(is.na(Indigenous), 0, Indigenous)) %>% mutate(tot = Population*Indigenous/100) %>% colSums()
abs2016 %>% filter(DivisionNm == "SYDNEY") %>% select(ID, Population, Indigenous) %>% mutate(Total = Population*Indigenous/100)


# Plotting quantiles 
quantiles <- abs2016 %>% 
  select(-c(ends_with("NS"), ID, State)) %>% 
  gather("key", "value", -DivisionNm) %>% 
  mutate(year = "2016") %>% 
  bind_rows(abs2011 %>% 
      select(-c(ends_with("NS"), UniqueID, State)) %>% 
      gather("key", "value", -DivisionNm) %>% 
      mutate(year = "2011")) %>% 
  bind_rows(abs2013_cd %>% 
      gather("key", "value", -DivisionNm) %>% 
      mutate(year = "2013")) %>% 
  mutate(year = as.factor(year)) %>% 
  group_by(year, key) %>% 
    summarise(q0 = min(value), 
      q1 = quantile(value, probs= 0.25),
      q2 = quantile(value, probs= 0.5),
      q3 = quantile(value, probs= 0.75),
      q4 = max(value)) %>% 
  gather("quantile", "value", -c(year, key)) %>% 
  filter(value < 100)

quantiles %>% 
  ggplot(aes(x = key, y = value)) +
  geom_line(aes(group = quantile, col = quantile)) +
  guides(col = F)

# Boxplots
abs2016 %>% 
  select(-c(ends_with("NS"), ID, State)) %>% 
  mutate(year = "2016") %>% 
  bind_rows(abs2011 %>% 
      select(-c(ends_with("NS"), UniqueID, State)) %>% 
      mutate(year = "2011")) %>% 
  bind_rows(abs2013_cd %>% 
      mutate(year = "2013")) %>% 
  mutate(year = as.factor(year)) %>% 
  gather("key", "value", -c(year, DivisionNm)) %>% 
  mutate(value = as.numeric(value)) %>% 
  ggplot(aes(x = year, y = value)) +
    geom_boxplot() +
    facet_wrap(~key, scales = "free")
  