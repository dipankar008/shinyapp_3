library(tidyr)
library(ggplot2)
library(stringr)
library(dplyr)

data <- who

table1 <- read.csv("table1.csv")
table2 <- read.csv("table2.csv")
table3 <- read.csv("table3.csv")
table4a <- read.csv("table4a.csv")
table4b <- read.csv("table4b.csv")

#use table2 to show the change in cases for each country from 1999 to year 2000
##table2 is not tidy, we can do that with table1

ggplot(table1, aes(x = year, y = cases, color = country)) +
  geom_line()
# table2, table3 and table4a and table4b are not tidy.. we will use two functions to clean them up

#gathering the data

g_table4a <- table4a %>%
  gather(X1999:X2000, key =  "Year", value = "Cases")

g_table4b <- table4b %>%
  gather(X1999:X2000, key = "Year", value = "Population")
gather(table4a, X1999:X2000,key =  "Year", value = "Cases")

# get rid of x fro year colunm

g_table4a$Year <- str_sub(g_table4a$Year, start = 2)
g_table4a$Year <- as.numeric(g_table4a$Year)

ggplot(g_table4a, aes(x = Year, y = Cases, color = country)) +
  geom_line()


#spreading the data


# Table2 is not tidy because the column "type" has two category. We need o spread it into two variables

table2 %>%
  spread(key = type, value = count)


#### both spread and gather are opposite of each other

table4a %>%
  gather(X1999:X2000, key = "Year", value = "Cases") %>%
  spread(key = Year, value = Cases)

# Unite and separate 

# table3 is not tidy if we want to have separated casesa dn population 


g_table3 <- table3 %>%
  separate(col = rate, into = c("Cases", "Population"), sep = "/", remove = F, convert = T)

#separate the year into century and year

table5 <- table3 %>%
  separate(col = year, into = c("century","year"), sep = 2)

new_table5<- table5 %>%
  unite(col = "united_year", century:year, sep = "")


# Create a bar chart that shows the numer of tb cases among each gender in "Cameroon" in 1995.
# the last few observation has newrel_f014 instead of new_rel, we need to replace them and then separate.
# variables (New, Diagnosis, SexAge)
Cameroon <- data %>%
  gather(new_sp_m014:newrel_f65, key = "code", value = "Cases") %>%
  filter(country == "Cameroon", year == 1995 )

Cameroon$code <- str_replace(string = Cameroon$code, pattern = "newrel", replacement = "new_rel")
Cameroon <- Cameroon %>%
  separate(col =code, into = c("New","Diagnosis", "SexAge"), sep = "_", remove = F) %>%
  separate(col = SexAge, into= c("Gender","AgeGroup"), sep = 1 )

ggplot(Cameroon, aes(x=Gender, y= Cases)) +
  geom_col(position = position_dodge())
  


  
  
  
  



