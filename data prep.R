
setwd("C:/Users/user/Desktop/R Tutorials/Data preparation")

url1 = "P3-Future-500-The-Dataset.csv"
url2 = "P3-Future-500-Marked-Up"

#df = read.csv(url1)
df = read.csv(url1, na.strings = c("")) #replace with na's values on the list


nrow(df)
head(df)
tail(df)
str(df)
summary(df)
colnames(df)
levels(df$State)

#changing from numeric to factor-----------------------------------------

#convert ID, inception to factor:
df$ID <- factor(df$ID)
df$Inception <- factor(df$Inception)


#-------------------------------------------------------------------------


#convert from factor to numeric-------------------------------------------
#(careful with trap!!!)


#example trap:
a <- factor(c("12","13","14"))
b <- as.numeric(a) #convert based on level: convert to number of categories
c <- as.numeric(as.character(a))

#convert Expenses, Revenue and Growth to value



#gsub(all instances) and sub(1st instance)

head(df$Expenses) 
df$Expenses <- df$Expenses %>% gsub(" Dollars","",.) %>% 
                gsub(",", "", .) %>% 
                as.character() %>% as.numeric()

summary(df$Expenses)


head(df$Revenue)
df$Revenue <- df$Revenue %>% gsub("\\$", "", .) %>% 
               gsub(",", "", .) %>% 
               as.character() %>% as.numeric()
summary(df$Revenue)
#escape character \\ : $ character special
    


head(df$Growth)
df$Growth <- df$Growth %>% gsub("%", "", .) %>% as.character() %>% as.numeric()
summary(df$Growth)


#-------------------------------------------------------------------------





#dealing with missing -----------------------------------------------------

colnames(df)
head(df)
summary(df)
str(df)

#locating missing:
df[complete.cases(df)==F,] #LOCATE ROWS THAT HAVE 1 NA IN ONE OF THE VARIABLES

#CHECK NUMBER OF NAS ON EACH COL
for(i in colnames(df)){
  print(c(i, sum(is.na(df[,i]))))
}


#filtering which for non missing:
df[df$Revenue == 9746272,] #picks NAs
df[which(df$Revenue == 9746272),] #dont pick NAs


#filtering using is.na
df[is.na(df$Expenses),]

#removing rows (with missing)
df[!complete.cases(df),]
df[is.na(df$Industry),]

df <- df[!is.na(df$Industry),] #select not NA in var and subscripe var

#resetting the dataframe index
rownames(df) <- 1:nrow(df)


#-------------------------------------------------------------------------


#replacing missing -------------------------------------------------------

df[is.na(df$State) & df$City == "New York",]
df[is.na(df$State) & df$City == "New York", "State"] <- "NY"
df[is.na(df$State) & df$City == "San Francisco", "State"] <- "CA"


df[df$ID=="11",]



#median imputation
df[!complete.cases(df),]

#employees
median_Retail <- median(df[df$Industry=="Retail","Employees"], na.rm=T) #store val
df[is.na(df$Employees) & df$Industry=="Retail" ,"Employees"] <- median_Retail

median_FinServ <- median(df[df$Industry=="Financial Services","Employees"], na.rm=T) #store val
df[is.na(df$Employees) & df$Industry=="Financial Services" ,"Employees"] <- median_FinServ


#growth
df[!complete.cases(df),]

med_growth_constr <- median(df[df$Industry == "Construction","Growth"], na.rm = T)
df[is.na(df$Growth) & df$Industry=="Construction" ,"Growth"] <- med_growth_constr




#-------------------------------------------------------------------------
