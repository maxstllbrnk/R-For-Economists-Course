################################################################################
####R language basics
################################################################################

#Load package dpylr
pacman::p_load("dplyr")

#Modulo operator
100 %/% 60 #integer division
100 %% 60 #remainder

#Boolean operators
# &: and, |: or, isTrue(), !: negation
#Logical operators (>, =) are evaluarted before Boolean operators (& and |)
is.na(1:10) #is.na(): is a value missing, 1:10: Reihe von 1 bis 10

#Value matching: %in%
#To see whether an object is contained within (i.e. matches one of) a list of items
4 %in% 1:10
#Define new function with `new_function` = ...
`%ni%`= Negate(`%in%`)
4 %ni% 5:10

#Vignettes: Provides an introduction to a package and it's purpose through a series of helpful examples
vignette("dplyr")

#Objects:
d = data.frame(x = 1:2, y = 3:4) #create a small data frame
m = as.matrix(d) #convert data frame to a matrix
class(d) #evaluate its class => data.frame
typeof(d) #evaluate its type => list (data frame is a collection of lists => each column is its own list with its own class unlike in matrices)
str(d) # show its structure => 2 obs. of 2 var.

View(d) #view data set in separate tab

#Linear regression
lm(formula = y~ x, data = d) #need to tell from which dataset you pull the observations for the regression

#Create another data frame
d2 = data.frame(x = rnorm(10), y=runif(10))

#vector
my_vector = c(1,2,5)

#Solving namespace conflicts
#Whenever a namespace conflict arises, the most recently loaded package will gain preference.
#1. Use package::function()
#2. Assign function = package::function
#Tip: Use temporary solution and load the most important package last!!! (i.e. load tidyverse after loading other packages)

#Indexing:
#1. [] #[number] denotes the position of the output element
a = 1:10
a[4] #Get the 4th element of object "a"
a[c(4,6)] #Get 4th and 6th element of object "a"
starwars[1,1] #Show the cell corresponding to the 1st row & 1st column of the data
starwars[1:3,1]
#For lists: can contain a random assortment of objects that don't share the same class or have the same shape
my_list = list(a = "hello", b = c(1,2,3), c = data.frame(x=1:5, y = 6:10))
#Lists require two square brackets [[]] to index the parent list item and the then a standard [] within the parent item
my_list[[1]] # Return the 1st list object
my_list[[2]][3] # Return the 3rd item of the 2nd list object

#2. $
my_list$a #Return list object "a"
my_list$b[3] #Return the 3rd element of list object "b"
my_list$c$x #Return column "x" of list object "c"
# $ works for other object types too, like dataframes
starwars$name[1] #Just gives you the entry
starwars[1,1] #Returns a string
lm(d$y ~ d$x)

#Removing objects (and packages)
#Use rm() to remove an objects or objects from the working environment
a = "hello"
b = "world"
rm(a,b)
rm(list=ls()) #Removes all objects in your working environment (except packages)
detach(package:dplyr)

plot(1:10)
dev.off()#Remove any plots that have been generated during your session