

setwd("C:/Users/user/Desktop/R Tutorials/If else e loops")

#data types

#integer: put L at the end
x <- 2L
typeof(x)

#double
y <- 2
typeof(y)

#character
a <- "Will"
typeof(a)

#logical
b <- T
typeof(b)

#glue characters
a <- "hello,"
b <- "Will"
paste(a,b)

#logical operators
4<5
10 > 100
4 == 5
# isTRUE()
#!: not operator
!TRUE
sum(TRUE)
sum(FALSE)

T & F
T & T
F & F

T | T
F | T
F | F


#loops ----------------------------------------------------------

#!!!! break quebra loop

#while
i = 0 
while(i<10){
  print(i)
  i = i + 1
}

#for 

for(i in 1:5){
  print("Hello R")
  print(i)
}

1:5

for(i in c('a','b','c')){
  print(i)
}


#---------------------------------------------------------------------


#if e else------------------------------------------------------------

x <- 1.2

#if e else
rm(answer)
if(x>1){
  answer <- "greater than 1"
  print(answer)
} else{
  answer <- "smaller than 1"
  print(answer)
}

#else if:

if(x>1){
  answer <- "greater than 1"
  print(answer)
} else if(x >= -1){
  answer <- "smaller than 1"
  print(answer)
} else{
  answer <- "whatever"
  print(answer)
}


#---------------------------------------------------------------------



#functions------------------------------------------------------------



function_name <- function(arg1, arg2){
  
  result= arg1^arg2
  
  return(result) #multiple return in a list or whatever
  
}








#---------------------------------------------------------------------

