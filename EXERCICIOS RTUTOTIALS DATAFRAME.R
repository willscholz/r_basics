#EXERCICIOS:
#http://r-tutorials.com/r-exercises-31-40-data-frame-manipulations/

install.packages("ggplot2")
install.packages("tidyverse")
install.packages("OneR")

library(ggplot2)
library(tidyverse)
library(OneR)
#exercicios 1--------------------------------------------:
df_cars <- mtcars 

#1.a
df_cars %>% ggplot(aes(x=mpg)) + geom_histogram()
summary(df_cars$mpg)
hist(df_cars$mpg)

#1.b
head(df_cars)
colnames(df_cars)
nrow(df_cars)
ncol(df_cars)
summary(df_cars)
str(df_cars)

?mtcars


df_cars %>% group_by(am) %>% summarize(n())

sum(df_cars$am == 0)
sum(df_cars$am == 1)

#1.c
df_cars %>% ggplot(aes(x=hp,y=wt)) + geom_point()



#exercicios 2--------------------------------------------:

df_iris = iris
head(df_iris)
tail(df_iris)
str(df_iris)
summary(df_iris)


#2.a
iris.vers = df_iris[df_iris$Species == "versicolor",]
iris.vers

#alternativa:
iris.vers = subset(df_iris, Species == "versicolor")

#2.b
sepa.dif = iris.vers$Sepal.Length - iris.vers$Sepal.Width
sepa.dif 

#2.c
iris.vers$sepal.dif = iris.vers$Sepal.Length - iris.vers$Sepal.Width
iris.vers


#exercios 3 ----------------------------------------------------

#3.a
str(df_cars)

#3.b
newmt = df_cars
newmt$am = as.integer(newmt$am)
newmt$cyl = as.integer(newmt$cyl)
newmt$vs = as.integer(newmt$vs)
str(newmt)

#usando loop
conv_int = c("am","cyl","vs")
newmt = df_cars
for(i in conv_int){
  newmt[,i] = as.integer(newmt[,i])
}

#3.c
newmt= round(newmt,1)


#exercicios 4-----------------------------------------------------
#4.a
colnames(df_iris)
df_iris %>% filter(Species == "virginica", Sepal.Width > 3.5)
df_iris
#4.b
df_iris %>% filter(Species == "virginica", Sepal.Width > 3.5) %>% 
  select(-Species)

#4.c
#row.names() : fornece indexes!!!!!
row.names(iris[iris$Species == "virginica" & iris$Sepal.Width > 3.5, 1:4])



#exercicios 5------------------------------------------------------
#5.a
rep(df_iris$Sepal.Length, each = 2, times = 2)

#5.b
sep.lengthodd = iris[c(T,F),1]

#5.c
rep(sep.lengthodd,each=2)




#------------------------------------------------------------------



#exercicios 6----------------------------------------------------------------

#a
df_diam <- diamonds
str(df_diam)
head(df_diam)
summary(df_diam)
colnames(df_diam)

df_diam$ind = row.names(df_diam)
df_diam$ind

#b
#attach?
?subset

#c subset
diam.sd <- diamonds %>% subset(clarity == "SI2" & depth >= 70)
  
#d
row.names(diam.sd)

#e
index.pos = as.integer(row.names(diam.sd))

#------------------------------------------------------------------

#exerc 7 ----------------------------------------------------------
head(df_diam)

attach(diamonds)

#7.a
df_diam %>% filter(cut == "Ideal" & carat < 0.21) %>% nrow()
sum(cut == "Ideal" & carat < 0.21)
#7.b
df_diam %>% mutate(tot = x + y + z ) %>% filter(tot >40) %>% nrow()
sum ((x + y + z) > 40)
#7.c
df_diam %>% filter(price > 10000 | depth >= 70 ) %>% nrow()
sum(price > 10000 | depth >= 70)
#------------------------------------------------------------------


#exercicio 8-----------------------------------------------------

head(df_diam)
#8.a
df_diam[row.names(df_diam) %in% c("67", "982"), c("color", "y")]

#8.b
df_diam[row.names(df_diam) %in% c("453", "792", "10489"), ]

#8.c
head(df_diam[,c('x','y','z')], n=10)

#8.c
df_diam[1:6,'y']

#------------------------------------------------------------------


#exerc 9 ----------------------------------------------------------

#9.a
newdiam <- diamonds[1:1000,]
str(newdiam)

#9.b
newdiam %>% arrange(price,); head(newdiam)

?arrange

#9.c
newdiam <- newdiam %>% arrange(desc(price)); newdiam

#9.d
newdiam <- newdiam %>% arrange(desc(price),depth)
#------------------------------------------------------------------


#exercise10-----------------------------------------------

#10.a
set.seed(56)
diam750 <- df_diam %>% sample_n(750); str(diam750)

#10.b
summary(diam750)

#10.c

diam750 %>% ggplot(aes(x=price, y=depth)) + geom_point()


#---------------------------------------------------------