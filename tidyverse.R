
install.packages("tidyverse")



library(tidyverse)
library(ggplot2)
library(dplyr)


install.packages("tidyverse")

install.packages("devtools")
devtools::install_github("rstudio/EDAWR")
library(EDAWR)



diamonds
str(diamonds)

#see dataframe as excel sheet
View(iris)

df = diamonds


#=======================pipe operator %>%
df$x %>% 
  round(2) %>%
  mean()
#========================================

storms
cases
pollution


#tidying data ===================================


#gather and spread()------------


df_cases = cases
df_cases

#gather: transpor colunas de anos
df_cases %>% gather("year","n",2:4) 
#gather(data, "name_newkey_col", "name_newvalue_col", <selected columns>)

#spread
df_pollution = pollution
df_pollution
df_pollution %>% spread(size, amount)
#spread(df, column_to_use_key, column_to_use_asvalue)


#separate e unite:
#usar para separar dados em coluna ou juntar baseado em caracter de separacao




#======================================================



#acessing new info ====================================


install.packages("nycflights13")
library(nycflights13)
?airlines
?airports
?flights
?planes
?weather

#select: select columns: more flexible than base R
#can select with contains, columns who ends or start with a string, every col, name matches etc
df = storms
storms
storms %>% select(-storm) #everything except
storms %>% select(storm, pressure) #list
storms %>% select(wind, wind:date)



#filter:
storms %>% filter(wind >= 50)
storms %>% filter(wind >= 50, storm %in% c("Alberto", "Alex")) #filter more than 1 cond: use ,

#any (any true)
#all (all true)
#& and | or
#! not
#NAs: is.na ou !is.na


#mutate: create variable
mutate(storms, ratio = pressure / wind, inverse = ratio^-1) #can use created
#can use with a lot of functions


#summarise: calculate statistics: generate dataframe with stats
pollution %>% summarise(median = median(amount), variance = var(amount), n=n())
#useful with summary functions: return unique value from multiple


#arrange: to sort rearreng based on variable
arrange(storms, desc(wind)) #without desc: ascendent
arrange(storms,wind,date) #var desempate

#CMD SHIFT M : PIP


#group_by: calculate stats for each category -always with summarise
pollution %>% 
  group_by(city) %>% 
  summarise(mean = mean(amount), sum=sum(amount), n= n())


#MEAN OF CITYS

pollution %>% 
  group_by(city) %>% 
  summarise(mean = mean(amount)) #summarise info by groups







#========================================================




#===========working with two datasets

bind_cols(y,z)
bind_rows(y,z)



left_join(songs, artists, by="name")
left_join(tab1, tab2, by="key")
left_join(tab1, tab2, by=c("key", "key2") #two keys

          
#inner_join: tem nos dois
#full_join: todos
#semi_join: doesnt glue tables, only select data that is avail in the other table
#anti_join: rows that will not be jointed
          









#================================================














