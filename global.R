library(shiny)
library(googleVis)
library(plotly)
library(dplyr)
library(tidyr)

#Loading Lost Time Cases per Category
ltc_cat = read.csv('Lost Time Injuries per Category and State.csv')
ltc_cat = select(ltc_cat,c(2,3,5,6,7,8,9))
colnames(ltc_cat) = c('State','Category', '2011', '2012','2013','2014','2015')
ltc_cat = gather(ltc_cat, key = 'Year', value = 'Lost Time Cases',3:7)
ltc_cat$Year = as.numeric(ltc_cat$Year)
ltc_cat = ltc_cat %>% mutate('ID' = paste0(State,Year,substr(ltc_cat$Category,1,4)))
ltc_cat$ID = as.character(ltc_cat$ID)

#Loading Fatalities per Category
fat_cat = read.csv('Fatalities per category and state.csv')
fat_cat = select(fat_cat,c(2,3,5,6,7,8,9))
colnames(fat_cat) = c('State','Category', '2011', '2012','2013','2014','2015')
fat_cat = gather(fat_cat, key = 'Year', value = 'Work Related Fatalities',3:7)
fat_cat$Year = as.numeric(fat_cat$Year)
fat_cat = fat_cat %>% mutate('ID' = paste0(State,Year,substr(fat_cat$Category,1,4)))
fat_cat$ID = as.character(fat_cat$ID)

#Loading Lost Time Cases Frequency Rate per Category
ltcfr = read.csv('Lost Time Injury Freq Rate per Category and State.csv')
ltcfr = select(ltcfr,c(2,3,5,6,7,8,9))
colnames(ltcfr) = c('State','Category', '2011', '2012','2013','2014','2015')
ltcfr = gather(ltcfr, key = 'Year', value = 'Lost Time Cases Frequency Rate',3:7)
ltcfr$Year = as.numeric(ltcfr$Year)
ltcfr = ltcfr %>% mutate('ID' = paste0(State,Year,substr(ltcfr$Category,1,4)))
ltcfr$ID = as.character(ltcfr$ID)

#Creating the final database:
plotmap = full_join(fat_cat, ltc_cat, by = 'ID')
plotmap = left_join(plotmap, ltcfr, by = "ID")
plotmap$Category.x = as.character(plotmap$Category.x)
plotmap$Category.y = as.character(plotmap$Category.y)
plotmap$State.x = as.character(plotmap$State.x)
plotmap$State.y = as.character(plotmap$State.y)

plotmap = plotmap %>%
  mutate('Final Category' = ifelse(is.na(plotmap$Category.x),plotmap$Category.y,plotmap$Category.x),
         'Final State' = ifelse(is.na(plotmap$State.x),plotmap$State.y,plotmap$State.x),
         'Final Year' = ifelse(is.na(plotmap$Year.x),plotmap$Year.y,plotmap$Year.x)) %>%
  select('Final State', 'Final Year', 'Final Category', 'Work Related Fatalities', 'Lost Time Cases', 'Lost Time Cases Frequency Rate') %>%
  mutate('MHW' = `Lost Time Cases` *20000000/`Lost Time Cases Frequency Rate`,
         'Fatality Frequency Rate' = `Work Related Fatalities`*20000000/`MHW`) %>%
  arrange(`Final State`,`Final Year`,`Final Category`)
colnames(plotmap)[1:3] = c('State', 'Year', 'Category')

plotmap$Category = as.factor(plotmap$Category)
levels(plotmap$Category)[5:6] = c('Fires and explosions','Fires and explosions')
choice = unique(plotmap$State)
choice = choice[-46]
choice[53] = "US"

#Fixing missing values of Fatality Frequency Rate from the database (source: https://www.bls.gov/iif/state_archive.htm#SD)
plotmap["254","Fatality Frequency Rate"] = 0.29 
plotmap["247","Fatality Frequency Rate"] = 0.33
plotmap["240","Fatality Frequency Rate"] = 0.27
plotmap["233","Fatality Frequency Rate"] = 0.35
plotmap["226","Fatality Frequency Rate"] = 0.39
plotmap["424","Fatality Frequency Rate"] = 0.31
plotmap["417","Fatality Frequency Rate"] = 0.27
plotmap["410","Fatality Frequency Rate"] = 0.28
plotmap["403","Fatality Frequency Rate"] = 0.27
plotmap["396","Fatality Frequency Rate"] = 0.29
plotmap["549","Fatality Frequency Rate"] = 0.48
plotmap["542","Fatality Frequency Rate"] = 0.47
plotmap["535","Fatality Frequency Rate"] = 0.43
plotmap["528","Fatality Frequency Rate"] = 0.27
plotmap["521","Fatality Frequency Rate"] = 0.51
plotmap["1074","Fatality Frequency Rate"] = 0.68
plotmap["1067","Fatality Frequency Rate"] = 0.71
plotmap["1060","Fatality Frequency Rate"] = 0.62
plotmap["1053","Fatality Frequency Rate"] = 0.55
plotmap["1046","Fatality Frequency Rate"] = 0.55
plotmap["1289","Fatality Frequency Rate"] = 0.27
plotmap["1282","Fatality Frequency Rate"] = 0.26
plotmap["1275","Fatality Frequency Rate"] = 0.21
plotmap["1268","Fatality Frequency Rate"] = 0.22
plotmap["1261","Fatality Frequency Rate"] = 0.12
plotmap["1504","Fatality Frequency Rate"] = 1.25
plotmap["1497","Fatality Frequency Rate"] = 0.98
plotmap["1490","Fatality Frequency Rate"] = 1.49
plotmap["1483","Fatality Frequency Rate"] = 1.77
plotmap["1476","Fatality Frequency Rate"] = 1.24
plotmap["1592","Fatality Frequency Rate"] = 0.55
plotmap["1583","Fatality Frequency Rate"] = 0.62
plotmap["1574","Fatality Frequency Rate"] = 0.58
plotmap["1752","Fatality Frequency Rate"] = 0.12
plotmap["1748","Fatality Frequency Rate"] = 0.21
plotmap["1744","Fatality Frequency Rate"] = 0.21
plotmap["1740","Fatality Frequency Rate"] = 0.17
plotmap["1736","Fatality Frequency Rate"] = 0.15
plotmap["1829","Fatality Frequency Rate"] = 0.49
plotmap["1822","Fatality Frequency Rate"] = 0.72
plotmap["1815","Fatality Frequency Rate"] = 0.47
plotmap["1808","Fatality Frequency Rate"] = 0.67
plotmap["1801","Fatality Frequency Rate"] = 0.67
plotmap["1511","Fatality Frequency Rate"] = 0.31

plotmap["254","MHW"] = plotmap["254","Work Related Fatalities"] *20000000/0.29
plotmap["247","MHW"] = plotmap["247","Work Related Fatalities"] *20000000/0.33
plotmap["240","MHW"] = plotmap["240","Work Related Fatalities"] *20000000/0.27
plotmap["233","MHW"] = plotmap["233","Work Related Fatalities"] *20000000/0.35
plotmap["226","MHW"] = plotmap["226","Work Related Fatalities"] *20000000/0.39
plotmap["424","MHW"] = plotmap["424","Work Related Fatalities"] *20000000/0.31
plotmap["417","MHW"] = plotmap["417","Work Related Fatalities"] *20000000/0.27
plotmap["410","MHW"] = plotmap["410","Work Related Fatalities"] *20000000/0.28
plotmap["403","MHW"] = plotmap["403","Work Related Fatalities"] *20000000/0.27
plotmap["396","MHW"] = plotmap["396","Work Related Fatalities"] *20000000/0.29
plotmap["549","MHW"] = plotmap["549","Work Related Fatalities"] *20000000/0.48
plotmap["542","MHW"] = plotmap["542","Work Related Fatalities"] *20000000/0.47
plotmap["535","MHW"] = plotmap["535","Work Related Fatalities"] *20000000/0.43
plotmap["528","MHW"] = plotmap["528","Work Related Fatalities"] *20000000/0.27
plotmap["521","MHW"] = plotmap["521","Work Related Fatalities"] *20000000/0.51
plotmap["1074","MHW"] = plotmap["1074","Work Related Fatalities"] *20000000/0.68
plotmap["1067","MHW"] = plotmap["1067","Work Related Fatalities"] *20000000/0.71
plotmap["1060","MHW"] = plotmap["1060","Work Related Fatalities"] *20000000/0.62
plotmap["1053","MHW"] = plotmap["1053","Work Related Fatalities"] *20000000/0.55
plotmap["1046","MHW"] = plotmap["1046","Work Related Fatalities"] *20000000/0.55
plotmap["1289","MHW"] = plotmap["1289","Work Related Fatalities"] *20000000/0.27
plotmap["1282","MHW"] = plotmap["1282","Work Related Fatalities"] *20000000/0.26
plotmap["1275","MHW"] = plotmap["1275","Work Related Fatalities"] *20000000/0.21
plotmap["1268","MHW"] = plotmap["1268","Work Related Fatalities"] *20000000/0.22
plotmap["1261","MHW"] = plotmap["1261","Work Related Fatalities"] *20000000/0.12
plotmap["1504","MHW"] = plotmap["1504","Work Related Fatalities"] *20000000/1.25
plotmap["1497","MHW"] = plotmap["1497","Work Related Fatalities"] *20000000/0.98
plotmap["1490","MHW"] = plotmap["1490","Work Related Fatalities"] *20000000/1.49
plotmap["1483","MHW"] = plotmap["1483","Work Related Fatalities"] *20000000/1.77
plotmap["1476","MHW"] = plotmap["1476","Work Related Fatalities"] *20000000/1.24
plotmap["1592","MHW"] = plotmap["1592","Work Related Fatalities"] *20000000/0.55
plotmap["1583","MHW"] = plotmap["1583","Work Related Fatalities"] *20000000/0.62
plotmap["1574","MHW"] = plotmap["1574","Work Related Fatalities"] *20000000/0.58
plotmap["1752","MHW"] = plotmap["1752","Work Related Fatalities"] *20000000/0.12
plotmap["1748","MHW"] = plotmap["1748","Work Related Fatalities"] *20000000/0.21
plotmap["1744","MHW"] = plotmap["1744","Work Related Fatalities"] *20000000/0.21
plotmap["1740","MHW"] = plotmap["1740","Work Related Fatalities"] *20000000/0.17
plotmap["1736","MHW"] = plotmap["1736","Work Related Fatalities"] *20000000/0.15
plotmap["1829","MHW"] = plotmap["1829","Work Related Fatalities"] *20000000/0.49
plotmap["1822","MHW"] = plotmap["1822","Work Related Fatalities"] *20000000/0.72
plotmap["1815","MHW"] = plotmap["1815","Work Related Fatalities"] *20000000/0.47
plotmap["1808","MHW"] = plotmap["1808","Work Related Fatalities"] *20000000/0.67
plotmap["1801","MHW"] = plotmap["1801","Work Related Fatalities"] *20000000/0.67
plotmap["1511","MHW"] = plotmap["1511","Work Related Fatalities"] *20000000/0.31

