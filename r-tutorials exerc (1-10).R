#EXERC 1-10


df <- lynx

#exerc 1--------------------------------------------
#1.a
length(df)

#1.b
order(df)
?order
sort(df)

#1.c
which(df<500) #which retorna indexes de determinada condição
df[df<500]
#---------------------------------------------------


#exerc 2--------------------------------------------------------

#2.1
hist(lynx)

#2.b
hist(lynx, breaks = 7)

#2.c e d
?hist
hist(lynx, col=c("salmon2", "darkblue"), breaks=7,
     sub="r-tutorials.com", xlab="", ylab="",
     main="Exercise Question\nHistogram")


#---------------------------------------------------------------


#exerc3---------------------------------------------------------
iris
df2 <- iris

#3.a
mysepal <- iris$Sepal.Length
is.vector(mysepal)
head(mysepal)

#3.b
stats <- c(Sum = sum(mysepal), Mean = mean(mysepal), Median = median(mysepal), Max = max(mysepal), Min = min(mysepal)); stats

#3.c
summary(mysepal)



#---------------------------------------------------------------


#exerc4---------------------------------------------------------

#4.a
#install.packages(dplyr)
library("dplyr")

#4.b
?arrange

#4.c
remove.packages("dplyr")


#---------------------------------------------------------------



#exerc5---------------------------------------------------------

x <- c(3,6,9)
c(1,rep(x,4),1); myvec
myvec[5]
nth(myvec, 5) #dplyr function to extract value in position from a vector
?nth

#---------------------------------------------------------------



#exerc6---------------------------------------------------------

mtcars
?mtcars
df3 <- mtcars

#6.a
mysubset <- df3[mtcars$am == 1,]
#ou
df3 %>% filter(am == 1)
#ou
subset(mtcars, am==1)

#6.b
mysubset[1:2,1:2]


#---------------------------------------------------------------


#exerc7---------------------------------------------------------

#7.a
mtcars[1:9,]
head(mtcars, 9)

#7.b
df_mtcars <- mtcars

df_mtcars <- df_mtcars %>% arrange(carb)
head(df_mtcars)
#---------------------------------------------------------------



#exerc8---------------------------------------------------------

df_iris <- iris
head(df_iris)

#8.a Get the means of the first 2 columns in the "iris" dataset by Species

df_iris %>% select(Sepal.Length, Sepal.Width, Species) %>% 
  group_by(Species) %>% 
  summarise(mean(Sepal.Length), mean(Sepal.Width))

#8b. Create vector x which is the alternation of 1 and 2, 75 times, check the length
x <- rep(c(1,2), 75)
x
length(x)

#8c. Attach x to iris as dataframe "irisx", check the head

irisx <- iris
irisx$x <- x
head(irisx)

#8

#---------------------------------------------------------------



#exerc9---------------------------------------------------------

#9.a 
sum(lynx<500)

#9.c 
sum(iris$Sepal.Length >= 5)


#---------------------------------------------------------------




#exerc10---------------------------------------------------------

#10.a
plot(iris$Sepal.Length, iris$Sepal.Width)

#ou
attach(iris)
plot(Sepal.Length, Sepal.Width)

plot(iris$Sepal.Length, iris$Sepal.Width, ylim=c(0,5), xlim = c(3,9))
text(6,1, "r-tutorials.com", col="red", cex=2, lwd=2)




#---------------------------------------------------------------