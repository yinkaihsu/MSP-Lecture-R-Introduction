install.packages("Lahman") #Lahman Baseball Database
install.packages("dplyr")  #A Grammar of Data Manipulation

library(Lahman)
library(dplyr)

# tbl_df
tbl_Salaries <- tbl_df(Salaries)

# select
select(tbl_Salaries, yearID, playerID, salary)

# filter
filter(tbl_Salaries, yearID == 2016)

# mutate
mutate(tbl_Salaries, salary = salary / 10000)

# arrange
arrange(tbl_Salaries, salary)
arrange(tbl_Salaries, desc(salary))

# summarise
summarise(tbl_Salaries, m_salary = mean(salary), N = n())

# group_by
group_by(tbl_Salaries, teamID)

# group_by + summarise
summarise(group_by(tbl_Salaries, teamID),
          m_salary = mean(salary), N = n())

# The pipe operator
tbl_Salaries %>% select(yearID, playerID, salary)
tbl_Salaries %>%
  filter(yearID == 2016) %>% 
  mutate(salary = salary / 10000) %>%
  group_by(teamID) %>% 
  summarise(m_salary = mean(salary), N = n()) %>%
  arrange(desc(m_salary))

# left_join, right_join, inner_join
tbl_Batting <- tbl_df(Batting)

left_join(tbl_Batting, tbl_Salaries, by = c("playerID", "yearID"))
right_join(tbl_Batting, tbl_Salaries, by = c("playerID", "yearID"))
inner_join(tbl_Batting, tbl_Salaries, by = c("playerID", "yearID"))


### Addition ============================================
# bind_cols
tbl_Salaries_no_salary = select(tbl_Salaries, -salary)
tbl_Salaries_salary = select(tbl_Salaries, salary)

bind_cols(tbl_Salaries_no_salary, tbl_Salaries_salary)

# bind_rows
tbl_Salaries_2016 <- filter(tbl_Salaries, yearID == 2016)
tbl_Salaries_no_2016 <- filter(tbl_Salaries, yearID != 2016)

bind_rows(tbl_Salaries_2016, tbl_Salaries_no_2016)

# union, intersect, setdiff
tbl_Salaries_2016_team <- tbl_Salaries %>% 
  filter(yearID == 2016) %>% select(playerID, teamID)
tbl_Salaries_2015_team <- tbl_Salaries %>% 
  filter(yearID == 2015) %>% select(playerID, teamID)

union(tbl_Salaries_2016_team, tbl_Salaries_2015_team)
intersect(tbl_Salaries_2016_team, tbl_Salaries_2015_team)
setdiff(tbl_Salaries_2016_team, tbl_Salaries_2015_team)
