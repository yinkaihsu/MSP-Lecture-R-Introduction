# MSP-Lecture-R-Introduction
This was the Data Science lecture in NTU on 171025, presented by Ian Hsu (Microsoft Student Partners 12th in Taiwan).

2017 / 10 / 02

Created by <font color="#006699">**Ian Hsu**</font> in MSP 12th

---

## 講座介紹

*    日期: 10 / 25
*    地點: 國立台灣大學
*    主題: R Introduction

---

## 分享內容 Agenda

*    An useful package in R for data manipulation: **dplyr** (20 mins)
        *    tbl_df
        *    select
        *    filter
        *    mutate
        *    arrange
        *    summarise
        *    group_by
        *    group_by + summarise
        *    The pipe operator
        *    left_join, right_join, inner_join
        *    bind_cols, bind_rows
        *    union, intersect, setdiff

*    Using **dplyr** package and **Azure Machine Learning Studio** to predict salaries of MLB batters (10 mins)
        *    Very quick overview of AML

---

## 分享內容 Detail

### Motivation of this share

*    **Data preprocessing** will take 50-80% of your time in data analysis

*    Goal of **Data preprocessing**
        *    Make data suitable to use with a particular piece of software
        *    Reveal information

### Introduction of R package dplyr

Author of R package dplyr: **Hadley Wickham**
*    Functions are easy to understand
        *    Similar to SQL query
                *    select, filter, mutate, arrange, group_by, summarise, ……

*    Build under c++
        *    Compile faster with higher efficiency

*    Support many database connection

### Dataset used

*    **Lahman Database (Baseball Data)**
The Lahman database contains pitching, hitting, and fielding
statistics for Major League Baseball from 1871 through 2016. It
includes data from the two current leagues (American and National),
the four other ”major” leagues (American Association, Union
Association, Players League, and Federal League), and the National
Association of 1871-1875.

*    **Variables**
        *    Output: Salaries of batters in 2016
        *    Input: Information about batters and their team in 2015

### Code Illustration

``` r=
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

```

### Learn More

1. [Manual of dplyr package - The R Project for Statistical Computing](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)

2. [Cheat sheet of dplyr package - RStudio](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

3. [Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/)

4. [Elements of Statistical Learning: data mining, inference, and prediction](https://web.stanford.edu/~hastie/ElemStatLearn/)

5. Facebook Page: [Microsoft Student Partners in Taiwan 微軟學生大使 - MSP](https://www.facebook.com/MSPTaiwan/)

### Lecturer Introduction

**徐英愷 Ian Hsu**

*    國立成功大學 交通管理科學系

*    國立成功大學 巨量資料分析學分學程

*    R 資料分析專案 with 健保資料庫

*    R 資料分析專案 with 高速公路 ETC 資料

*    Microsoft Student Partners 12th

*    喜愛跨領域交流、旅遊、欣賞運動賽事

