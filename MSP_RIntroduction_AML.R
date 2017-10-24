### R script 1 ======================================================================================

# read data
## The following line should be exectuted only when running in Azure ML Studio.
## Port 1 should be "Salaries.csv".
salary <- maml.mapInputPort(1)
## Port 2 should be "Fielding.csv".
fielding <- maml.mapInputPort(2)

# install packages needed
#install.packages("dplyr")  #A Grammar of Data Manipulation

# load in packages installed
library(dplyr)

# select salary of players in 2016
salary_2016 <- salary %>% filter(yearID == 2016) %>% select(-yearID, -lgID)

# find out whether a player is a pitcher or a batter
POS_repeat <- fielding %>% 
  mutate(P_or_B = factor(POS == "P", levels = c(T, F), labels = c("Pitcher", "Batter"))) %>% 
  select(playerID, P_or_B) %>% distinct() %>% group_by(playerID) %>% 
  mutate(N = n()) %>% filter(N > 1) %>% filter(P_or_B == "Batter") %>% select(-N)

POS_no_repeat <- fielding %>% 
  mutate(P_or_B = factor(POS == "P", levels = c(T, F), labels = c("Pitcher", "Batter"))) %>% 
  select(playerID, P_or_B) %>% distinct() %>% group_by(playerID) %>% 
  mutate(N = n()) %>% filter(N == 1) %>% select(-N)

POS_all <- bind_rows(POS_repeat, POS_no_repeat)

# select salary of batters in 2016
salary_batter_2016 <- salary_2016 %>% 
  left_join(POS_all, by = "playerID") %>% filter(P_or_B == "Batter")

# calculate total salary of each team in 2015
team_salary_2015 <- salary %>% filter(yearID == 2015) %>% select(playerID, teamID, salary) %>%
  group_by(teamID) %>% summarise(team_salary = mean(salary))

# combine factors considered above
batter_data_v1 <- salary_batter_2016 %>% 
  left_join(team_salary_2015, by = "teamID") %>% select(-teamID, -P_or_B)

# replace rows of no team salary with the mean salary of the league
mean_salary_2015 <- mean(team_salary_2015$team_salary, na.rm = T)
batter_data_v1$team_salary <- 
  replace(batter_data_v1$team_salary, is.na(batter_data_v1$team_salary), mean_salary_2015)

# select data.frame to be sent to the output Dataset port
## The following line should be exectuted only when running in Azure ML Studio. 
maml.mapOutputPort("batter_data_v1")

### =================================================================================================
### R script 2 ======================================================================================

# read data
## The following line should be exectuted only when running in Azure ML Studio.
## Port 1 should be the output of R script 1 ("batter_data_v1").
batter_data_v1 <- maml.mapInputPort(1)
## Port 2 should be "Batting.csv".
batting <- maml.mapInputPort(2)

# install packages needed
#install.packages("dplyr")  #A Grammar of Data Manipulation

# load in packages installed
library(dplyr)

# calculate information of each batter in 2015
batting_2015 <- batting %>% filter(yearID == 2015) %>%
  select(-yearID, -stint, -teamID, -lgID) %>% group_by(playerID) %>%
  summarise(G = sum(G, na.rm=T), AB = sum(AB, na.rm=T), R = sum(R, na.rm=T), H = sum(H, na.rm=T),
            X2B = sum(X2B, na.rm=T), X3B = sum(X3B, na.rm=T), HR = sum(HR, na.rm=T), BB = sum(BB, na.rm=T))

# combine factors considered above
batter_data_v2 <- batter_data_v1 %>% left_join(batting_2015, by = "playerID")

# replace rows of no player stat with zero in each category
batter_data_v2 <- as.data.frame(lapply(batter_data_v2, function(x){replace(x, is.na(x), 0)})) %>% 
  mutate(playerID = as.character(playerID))

# select data.frame to be sent to the output Dataset port
## The following line should be exectuted only when running in Azure ML Studio. 
maml.mapOutputPort("batter_data_v2")

### =================================================================================================
### R script 3 ======================================================================================

# read data
## The following line should be exectuted only when running in Azure ML Studio.
## Port 1 should be the output of R script 2 ("batter_data_v2").
batter_data_v2 <- maml.mapInputPort(1)
## Port 2 should be "Master.csv".
master <- maml.mapInputPort(2)

# install packages needed
#install.packages("dplyr")  #A Grammar of Data Manipulation

# load in packages installed
library(dplyr)

# calculate years in MLB of each player in 2015
year_2015 <- master %>% 
  mutate(years_MLB = as.integer(as.Date("2015-12-31") - as.Date(debut)) / 365) %>% 
  select(playerID, years_MLB)

# combine factors considered above
batter_data_v3 <- batter_data_v2 %>% left_join(year_2015, by = "playerID")

# replace rows of no experience with zero year in MLB
batter_data_v3 <- as.data.frame(lapply(batter_data_v3, function(x){replace(x, is.na(x), 0)}))

# replace rows of negative years of experience with zero year in MLB
batter_data_v3$years_MLB <- 
  replace(batter_data_v3$years_MLB, batter_data_v3$years_MLB < 0, 0)

# select data.frame to be sent to the output Dataset port
## The following line should be exectuted only when running in Azure ML Studio. 
maml.mapOutputPort("batter_data_v3")

### =================================================================================================
