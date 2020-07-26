
setwd("C:/Users/user/Desktop/R Tutorials/Ggplot")

#GGPLOT2

#importing libraries
library(ggplot2)


url = "P2-Movie-Ratings.csv"
df = read.csv(url)

#exploring==============================================

head(df)
tail(df)
str(df)
summary(df)
colnames(df)

#=======================================================


#treating==============================================

colnames(df) <- c("Film","Genre","CriticsRating", "AudienceRating", "BudgetMM","Year")
head(df,n=1)

df$Year <- factor(df$Year)




#=======================================================





#GGPLOT2==============================================

p = ggplot(data=df, aes(x=CriticsRating, y=AudienceRating))
p + geom_point()
p + geom_point(aes(color=Genre))
p + geom_point(aes(color=Genre, size=BudgetMM))
p + geom_point(aes(color=Genre, size=BudgetMM)) + geom_line()



p = ggplot(data=df, aes(x=CriticsRating, y=AudienceRating))
p + geom_point(aes(color=Genre, alpha=0.1, size=BudgetMM))

#the last aes overide the first ones
q = p + geom_point(aes(color=Genre, alpha=0.1, size=BudgetMM))
q + geom_point(aes(size=CriticsRating, alpha=0.1))


#changing x axis:
p + geom_point(aes(color=Genre, alpha=0.1, size=BudgetMM))+ xlab("whatever")


#!!!!!!!!!!!!!!
#when not using variable to set a thing, put outside of AES

#1.mapping
p + geom_point(aes(color=Genre, alpha=0.1, size=BudgetMM))
p + geom_point(aes(color="DarkGreen", alpha=0.1, size=BudgetMM))
#when it is inside of aes, it maps in Aesthetics

#2. setting
p + geom_point(color="DarkGreen",aes( alpha=0.1, size=BudgetMM))




#-------------------histogram
s <- ggplot(data=df, aes(x=BudgetMM))
s + geom_histogram(binwidth = 10, aes(fill = Genre, alpha=0.1))

#add border
s + geom_histogram(binwidth = 10, aes(fill = Genre, alpha=0.1), colour="Black")



#--------------------density chart
s + geom_density(aes(fill=Genre, alpha=0.1), position = "stack")


#-----------------layer tips

t <- ggplot(data=df)
t + geom_histogram(binwidth = 10, aes(x=AudienceRating), fill="White", colour="Blue")



#----------------statistical transfo

?geom_smooth

u <- ggplot(data=df, aes(x=CriticsRating,y=AudienceRating, colour=Genre))
u + geom_point() + geom_smooth(fill=NA)


#----------------boxplots

u <- ggplot(data=df, aes(x=Genre,y=AudienceRating, colour=Genre))
u + geom_boxplot(size=1.2) 
u + geom_boxplot(size=1.2) + geom_point()
u + geom_boxplot(size=1.2, alpha=0.5) + geom_jitter()



#---------------facets

v <- ggplot(data=df, aes(x=BudgetMM))

v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black")

v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black")+
  facet_grid(Genre~., scales="free")

#facets

v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black")+
  facet_grid(Genre~Year, scales="free")

v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black")+
  facet_grid(.~Year, scales="free")


#------------coordinates

m <- ggplot(data=df, aes(x=CriticsRating, y=AudienceRating), 
            size=BudgetMM, colour=Genre)

m + geom_point()

m + geom_point() + xlim(50,100) + ylim(50,100) #eliminates points
#dont work always, to zoom in:

coord_cartesian(ylim=c(0,100)) #examples histogram



#----------------theme

#relabel axis
xlab("zzz")
ylab("saa")


#tick mark formatting
theme()

#title:
ggtile("TTTTT")
theme(plot.title = ...)







#=======================================================
