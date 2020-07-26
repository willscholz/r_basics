

#FUNDAMENTALS OF R: VECTOR, FUNCTIONS, MATRICES


#VECTORs------------------------------------------------------------------

#vetor tem variaveis de somente um tipo: NUM, INT, CHR

#funcoes de teste e conversão:
typeof()
is.numeric
is.integer()
is.double()
is.character()
as.numeric()
as.integer()
as.double()
as.character()



A <- c(1,2,3)
B <- c('a','b',3) #se tem unico caracter, o vetor vira caracter indep de ter numero
length(A)
typeof(A)

is.numeric(A)
is.numeric(B)

#como colocar inteiros: L
is.integer(A)
A2 <- c(1L,2L,3L) #para passar valor inteiro: L
is.integer(A2)
is.double(A)

A3 <- as.integer(A)
is.integer(A3)
is.double(A3)

C <- c("3","9","1")
as.numeric(C)


#funções seq() e rep()---------------------

#sequence
1:15
seq(1,15,by = 2) #seq: mais flex, consegue colocar step
?seq

#replicate
rep(3,50) #repetir numero X vezes
a<-rep(c(1,2,3),50) #repetir vetor
rep("Hi",3)
length(a)
?rep
#--------------------------------------------

#combine
b <- c(1,44,134, 88, 99)

#acessing by index: can put vector inside to acess
b[1]
b[-1] #all, except 1
b[c(-2,-3)]
b[-3:-5]
b[c(1,3,5)]
b[1:3]

#vectorized operations: you can do vectorized operations without looping
c <- c(3,5,7)
d <- c(1,2,3)
c+d

#when vectors not the same length: recycles the small vector
e <- c(8,9,4,6,7)
f <- c(1,2)
e+f

#vectors can be input in function or output of function

#usefull functions in R
x<-'aaa'
y<-'bbb'
paste(x,y, sep='.') #concatenating strings


#packages:



#-------------------------------------------------------------------------







#MATRICES---------------------------------------------------------------
#rodar codigo s4-Basketball

Salary
row = 2
col = 3
#index matrix: A[row,col]
Salary[row,col]
Salary[row,] #all cols for row
Salary[,col] #all rows for a col


#building matrix----------------------------------------------------------

#using matrix funct: populate starting with col or row
m <- 1:9
M1 <- matrix(m, 3, 3); M1 #populate by col
M2 <- matrix(m, 3, 3, byrow = T); M2 #populate by row
?matrix

#rbind and cbind
m1 <- 1:4
m2 <- 5:8
R <- rbind(m1,m2); R
C <- cbind(m1,m2); C

#naming dimensions
colnames(R) <- c("A","B","C","D")
R["m2",]
R[,"D"]
R[,4]

names(m1) <- colnames(R)
m1

names(m1) <- NULL #tirando nomes

#Matrix operations ===========

FieldGoals
Games
round(FieldGoalAttempts/Games,1) #division element by element (need same dimension)
#can add mat, subt, mult


#Subsetting
d<- Games[1,,drop=F]
is.matrix(d)
d2<- Games[1,,drop=F]
is.matrix(d2)

Games[1:3,6:10] #just like vectors, but 1 more dimension


#-------------------------------------------------------------------------


#-------------------------------------------------------------------------


