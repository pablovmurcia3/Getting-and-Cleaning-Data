################################################################################
                                        # WEEK 3 #                                                                                                                   
################################################################################

# Get to tidy data!

# subsetting and sorting data

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
library(reshape2)

data(mtcars)
head(mtcars) 

# Melt the data set 

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
# melt the variables in one column
head(carMelt,n=3)
tail(carMelt,n=3)

table(carMelt$cyl)

# With the melt data set we can RE-Cast it into different shapes
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

com <- mutate(InsectSprays, holis = ddply(InsectSprays,.(spray),summarize,sum = ave(count,FUN=sum))[,2])
com

################################################################################
################################################################################

# Dplyr package! 

# The data frame is a key data structure in statistics and in R.

# There is one observation per row
 
#  Each column represents a variable or measure or characteristic

#  Primary implementation that you will use is the default R
# implementation

#  Other implementations, particularly relational databases systems



# Is faster tha plyr because is coded in C ++ in the low level


# The important verbs
# 1. select--- subset of columns
# 2. filter--- subset of rows
# 3. Arrange --- reorder 
# 4. Rename
# 5. Mutate
# 6. Summarise

# dplyr.function(data.frame, other arguments) -> returns a data frame
install.packages("dplyr")
library(dplyr)



if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://github.com/DataScienceSpecialization/courses/raw/master/03_GettingData/dplyr/chicago.rds"
download.file(fileUrl,destfile="./data/chicago.rds")
chicago <- readRDS("./data/chicago.rds")

dim(chicago)
str(chicago)
names(chicago)

# Select

head(select(chicago, city:dptp)) # : a notation to select all the columns 
# between city and dptp

head(select(chicago, -(city:dptp))) # select all the columns except the ones in
# the -(:)

# Filter 

chic.f <- filter(chicago, chicago$pm25tmean2 > 30)
head(chic.f)


chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f)

# the nice thing of these functions -- you can refer to the variable using their 
# names

# Arrange

chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)

chicago <- arrange(chicago, desc(date))
head(chicago)
tail(chicago)

# Rename 

chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint=dptp)
names(chicago)
head(chicago)

# Mutate 

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(chicago)

# Group by + summarize

chicago <- mutate(chicago, tempcat = factor(1*(tmpd > 80), labels = c("cold","hot")))

################################################################################
nums <- sample(70:90, 20, replace = TRUE)

factor(nums > 80) # displays TRUE and FALSE
factor(1*(nums > 80)) # displays 0 and 1
nums <- as.numeric(factor(nums > 80)) # displays 1 and 2
nums
################################################################################

hotcold <- group_by(chicago, tempcat)
hotcold

summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), 
          no2 = median(no2tmean2))
################################################################################

chicago$date[1000]

as.POSIXlt(chicago$date)$year[1000] + 1900

chicago$date[1]
as.POSIXlt(chicago$date)$mon[1]

################################################################################

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)

years <- group_by(chicago, year)

summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), 
          no2 = median(no2tmean2, na.rm = TRUE))

# Special operator -- chain different operations together -- pipe line

chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% 
          summarize(pm25 = mean(pm25, na.rm = TRUE), 
              o3 = max(o3tmean2, na.rm = TRUE), 
              no2 = median(no2tmean2, na.rm = TRUE))
# i dont have to specify the name of the data frame 


# we can use the dplyr with data.table!!!

################################################################################

# Merging Data 

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/reviews.csv"
fileUrl2 = "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/solutions.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)

names(reviews)
names(solutions)

mergedData <- merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
#  all -- include all the variables
head(mergedData)


# Using join in the plyr package 

# Faster, but less full featured - defaults to left join,
library(plyr)
df1 <- data.frame(id=sample(1:10),x=rnorm(10))
df2 <- data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id) # only can merge in the base of common names between 
# the data.frames

# If you have multiple data frames, the plyr packages is recomended (id the names 
# are the same) -- join_all


df1 <- data.frame(id=sample(1:10),x=rnorm(10))
df2 <- data.frame(id=sample(1:10),y=rnorm(10))
df3 <- data.frame(id=sample(1:10),z=rnorm(10))
dfList <- list(df1,df2,df3) # all the data frames need to be in a list
join_all(dfList)
?join_all
