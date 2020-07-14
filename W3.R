################################################################################
                                        # WEEK 3 #                                                                                                                   
################################################################################

# Get to tidy data!

set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X
X <- X[sample(1:5),] #scramble the data frame 
X
X$var2[c(1,3)] = NA # make some values missing 
X

X[,1]
X[,"var1"] #the same

X[1:2, "var2"] # subset rows and column at the same time


X[(X$var1 <= 3 & X$var3 > 11),] # with logical args (AND)
X[(X$var1 <= 3 | X$var3 > 15),] #(#OR)

# Dealing with missing values

X[X$var2 > 8,] # problem because NA
X[which(X$var2 > 8),] # subset with NAs

## Sorting

sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE) # with the na at the end of the sort
sort(X$var2)


## Ordering

X[order(X$var1),]
X[order(X$var1,X$var3),] # first sort var 1 the by var 3
X <- data.frame(a = c(3,3,2,2),b= c(1,2,4,3))
X[order(X$a,X$b),]

# We can do the same with plyr package
install.packages("plyr")
library(plyr)

arrange(X,var1) #sorting

arrange(X, desc(var1))

# Add rows and columns

X$var4 <- rnorm(5) # var4 new variable.. assign new vector
X

Y <- cbind(X, rnorm(5)) # The same

Z <- rbind(Y, rnorm(5))


################################################################################
################################################################################

#Summarizing data

# crucial step in cleaning data

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/restaurants.csv",method="curl")
restData <- read.csv("./data/restaurants.csv")

# look a bit of the data

head(restData, n=3) # n number of rows
tail(restData, n=3)  

summary(restData) #info of variables

str(restData)
restData$name <-as.factor(restData$name)


quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9)) # Look at different percentage


# Make table 
table(restData$Location.1, useNA = "ifany") # useNA ifany to know the numer of Na
# in this case there are not na

table(restData$councilDistrict,restData$zipCode) # two variables 

# check for missing values

sum(is.na(restData$councilDistrict))

any(is.na(restData$councilDistrict))

all(restData$zipCode > 0) # we hop tha zipc are greater than 0--- so we have a problem
##   INTERESTING!!!!!


#row and column sums

colSums(is.na(restData)) # for every variable !

all(colSums(is.na(restData)) == 0) # we have a problem!!!

# Values with specific characteristics

table(restData$zipCode %in% c("21212")) # all the zipc that are 21212
# are there any valuas that fall into the vector
sum(restData$zipCode == 21212)
table(restData$zipCode %in% c("21213"))
table(restData$zipCode %in% c("21212","21213"))
# are there any valuas that are either  equal to one or the other of these values


a<-restData[restData$zipCode %in% c("21212","21213"),] # more easy to subset
b<-restData[ restData$zipCode == "21212" |  restData$zipCode == "21213",  ]
identical(a,b)


# Cross tabs

data(UCBAdmissions)

DF <- as.data.frame(UCBAdmissions)
summary(DF)


xt <- xtabs(Freq ~ Gender + Admit,data=DF) # CROSS TAB
xt
?xtabs

# Falt tables
warpbreaks <- as.data.frame(warpbreaks)
summary(warpbreaks)

warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks)
xt

ftable(xt)

# Size of a data set


fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")


################################################################################
################################################################################

# Creating new data


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/restaurants.csv",method="curl")
restData <- read.csv("./data/restaurants.csv")


# creating sequences

s1 <- seq(1,10,by=2) ; s1
s2 <- seq(1,10,length=3); s2
x <- c(1,3,8,25,100); seq(along = x)
seq_along(x)

# Subsetting variables
restData$nearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

# Creating binary variables 

restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong,restData$zipCode < 0)

as.numeric(restData$nearMe)

# Creating categorical variables 

quantile(restData$zipCode)
restData$zipGroups <- cut(restData$zipCode,breaks=quantile(restData$zipCode))
# break the variable according to the quantiles
table(restData$zipGroups)
class(restData$zipGroups)

table(restData$zipGroups,restData$zipCode) 


# Easier cutting
install.packages("Hmisc")
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode,g=4) # cut2! only put the groups 
table(restData$zipGroups)

#Cutting produces factor variables

# Creating factor variables
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)


# Levels of factor variables

yesno <- sample(c("yes","no"),size=10,replace=TRUE)
yesnofac <- factor(yesno,levels=c("yes","no"))
relevel(yesnofac,ref="yes")
as.numeric(yesnofac) # see as numeric

#  Using the mutate function

library(Hmisc); library(plyr)
restData2 <- mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)

# Common transforms

# `abs(x)` absolute value
# `sqrt(x)` square root
# `ceiling(x)` ceiling(3.475) is 4
# `floor(x)` floor(3.475) is 3
# `round(x,digits=n)` round(3.475,digits=2) is 3.48
# `signif(x,digits=n)` signif(3.475,digits=2) is 3.5
# `cos(x), sin(x)` etc.
# `log(x)` natural logarithm
# `log2(x)`, `log10(x)` other common logs
# `exp(x)` exponentiating x


################################################################################
################################################################################

# Reshape the data --- get to tidy!

# each variable forms a column
# each observation a row


install.packages("reshape2")
library(reshape2 )

data(mtcars)
head(mtcars) 

# Melt the data set 

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)

table(carMelt$cyl)

# Cast the data set

cylData <- dcast(carMelt, cyl ~ variable) # summarize the data set 
cylData # cyl in the rows and variable in the column
 
cylData <- dcast(carMelt, cyl ~ variable,mean) # re-summarize
cylData

# Average values
data(InsectSprays)
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum)

# Another way - split

spIns <-  split(InsectSprays$count,InsectSprays$spray)
spIns

sprCount <- lapply(spIns,sum)
sprCount

unlist(sprCount)

sapply(spIns,sum)



# Another way - plyr package

library(plyr)

ddply(InsectSprays,.(spray),summarize,sum=sum(count))

?ddply

# Creating a new variable
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
head(spraySums)

# usual combination --- Mutate + ddply 

com <- mutate(InsectSprays, sum = ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))[,2])
com


