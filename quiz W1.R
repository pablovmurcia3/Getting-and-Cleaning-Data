#1 

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl, destfile = "./data/housing.csv", method = "curl")

library(readr)

housing <- read_csv("data/housing.csv")

sum(housing$VAL == 24, na.rm = TRUE)

# 2

housing$FES

# 3 

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

download.file(fileUrl, destfile = "./data/gas.xlsx", method = "curl")


library(readxl)
dat <- read_excel("data/gas.xlsx", range ="G18:O23")

sum(dat$Zip*dat$Ext,na.rm=T)

# 4

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

download.file(fileUrl, destfile = "restaurantsF.xml", method = "curl")

library(XML)
doc <- xmlTreeParse("restaurantsF.xml",useInternal=TRUE) # read data
class(doc) 

topNode <- xmlRoot(doc)
xmlName(topNode)

zip <- xpathSApply(topNode,"//zipcode", xmlValue)

sum(zip == 21231)

# 5

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

download.file(fileUrl, destfile = "./data/housing.xlsx", method = "curl")

library(data.table)
?fread

DT <- fread("data/housing.xlsx")
class(DT)

DT[,mean(pwgtp15), by = SEX]
