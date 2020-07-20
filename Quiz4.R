# Quiz 

# 1

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/housing.csv", method = "curl")
housing <- read.csv("data/housing.csv")

strsplit(names(housing), split = "wgtp" ) 


# 2
library(data.table)

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1,destfile="./data/gdp.csv",method="curl")
gdp <- fread("./data/gdp.csv", skip = 5, nrows = 190)

class(gdp$V5)


gdp$V5 <- gsub(",","", gdp$V5)
gdp$V5 <- as.numeric(gdp$V5)
mean(gdp$V5)

# 3


names(gdp) <- sub("V4","countryNames",names(gdp))

grep("^United", gdp$countryNames, value = TRUE)



# 4

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1,destfile="./data/gdp.csv",method="curl")
gdp <- fread("./data/gdp.csv", skip = 5, nrows = 190)


fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl2,destfile="./data/educ.csv",method="curl")
educ <- fread("./data/educ.csv")


mergedData <- merge(gdp,educ,by.x="V1",by.y="CountryCode")

names(mergedData)
str(mergedData) # Special Notes 

vec <- grep("[Ff]iscal ([^ ]+ +){1,5}[Jj]une ", mergedData$`Special Notes`, value = TRUE)

length(vec)

# 5
install.packages("quantmod")
library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)
class(sampleTimes)

year12 <- grep("2012", sampleTimes, value = TRUE)
year12
length(year12)
class(year12)

year12 <- as.Date(year12)
week <- weekdays(year12)

monday <- grep("lunes", as.character(week), value = TRUE)
monday

length(monday)
