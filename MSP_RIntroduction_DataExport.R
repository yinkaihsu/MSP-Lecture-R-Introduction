# install packages needed
install.packages("Lahman") #Lahman Baseball Database

# load in packages installed
library(Lahman)

# export data needed
data("Salaries")
write.csv(Salaries, "MSP_RIntroduction_Data/Salaries.csv")

data("Fielding")
write.csv(Fielding, "MSP_RIntroduction_Data/Fielding.csv")

data("Batting")
write.csv(Batting, "MSP_RIntroduction_Data/Batting.csv")

data("Master")
write.csv(Master, "MSP_RIntroduction_Data/Master.csv")

