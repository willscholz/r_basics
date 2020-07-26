
#LOOPS E IF ELSE 71-80

#http://r-tutorials.com/r-exercises-71-80-loops-loop-loop-repeat-loop-ifelse-statements-r/


student.df = data.frame( name = c("Sue", "Eva", "Henry", "Jan"),
                         sex = c("f", "f", "m", "m"), 
                         years = c(21,31,29,19)); student.df



#EXERCICIO 1=======================================================


student.df$male.teen = ifelse(student.df$sex == "m" & student.df$years<20, T, F)
student.df

#==================================================================



#EXERCICIO 2=======================================================


for (i in c(1,2,3)){
  #print(i)
  
  for (j in 0:9)
    print(i + j)
  
}

#==================================================================




#EXERCICIO 3=======================================================

set.seed(3)
rand = rnorm(3)

for (i in 1:10){
  print(rand)
}


#==================================================================



#EXERCICIO 4=======================================================

mtcars
df_cars = mtcars

for (i in df_cars$disp){
  if (i>=160){
    print(i)
    }
}


#b

i=1
while (df_cars$disp[i] >= 160){
print(df_cars$disp[i])
i=i+1
}

#pelo for:
for (i in mtcars$disp){
  if(i<160)
    break
  print(i)
}


#==================================================================


#EXERCICIO 5=======================================================

a = c(3,7,NA, 9)
b = c(2,NA,9,3)
f = c(5,2,5,6)
d = c(NA,3,4,NA)

mydf = data.frame(a=a,b=b,f=f,d=d);mydf
mydf
mydf$5 <- ifelse()

library(dplyr)

if (is.na(mydf$a)){
  
}

mydf$V5 = ifelse(is.na(mydf$a),
       ifelse(is.na(mydf$b),ifelse(is.na(mydf$d),mydf$f, mydf$d),mydf$b),
       mydf$a)

mydf


#==================================================================

#EXERCICIO 6=======================================================


x = 0
while(x <= 35){
  
  if (x!=7) {
    print(x)
  }
  x = x+1
}





#==================================================================


#EXERCICIO 7=====================================================


x = 0
while(x <= 35){
  
  if (!(x %in% c(3,9,13,19,23,29))) {
    print(x)
  }
  
  x = x+1
  
}

#==================================================================


#EXERCICIO 8=====================================================


set.seed(23)
round(runif(1,0,100),0)
numb_iter = rep(NULL,10000)
for (i in 1:1000){
  x=0
  n=0
  while(x != 55){
    x = round(runif(1,0,100),0)
    n=n+1
  }
  numb_iter[i] = n
}

mean(numb_iter)



#==================================================================


#EXERC9===========================================================

round(runif(1,0,6),0)


nexp=1000
vec_ans=rep(NA,nexp)

for (i in 1:nexp){
casts=1
d=0
while(!(d %in% c(11,12)) | (casts==1)){
  #print(d)
  d1=round(runif(1,0,6),0)
  d2=round(runif(1,0,6),0)
  d=d1+d2 
  #print(d)
  if((d %in% c(5,6,7,8,9)) & casts==1){
    break
  }
  casts=casts+1
}
vec_ans[i]=casts
}

mean(vec_ans)



casts
d


#==================================================================





