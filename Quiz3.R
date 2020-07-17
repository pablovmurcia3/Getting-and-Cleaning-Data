# 1

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="./data/house.csv",method="curl")
house <- read.csv("./data/house.csv")
str(house)

# Variables ACR and AGS


house$ACR == 3 & house$AGS == 6

agricultureLogical <- (house$ACR == 3 & house$AGS == 6)

which(agricultureLogical)

agricultureLogical[125]

?which

View(house)


# 2

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl,destfile="./data/jeff.jpg",method="curl")
install.packages("jpeg")
library(jpeg)
jeff <- readJPEG("./data/jeff.jpg", native = TRUE)

str(jeff)

quantile(jeff, probs = c(0.3,0.8))


# 3
library(data.table)

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1,destfile="./data/gdp.csv",method="curl")
gdp <- fread("./data/gdp.csv", skip = 5, nrows = 190)
?fread

fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl2,destfile="./data/educ.csv",method="curl")
educ <- fread("./data/educ.csv")

str(gdp)
str(educ)

mergedData <- merge(gdp,educ,by.x="V1",by.y="CountryCode")

sort<- arrange(mergedData, desc(V2))

sort$V4[13]
V2

# 4
library(dplyr)
mergedData  %>% group_by(`Income Group`)  %>%
        summarize(av = mean(V2, na.rm = TRUE))  %>% 
        print

# 5
library(Hmisc)

mergedData$rankgroup <- cut2(mergedData$V2,g=5) # cut2! only put the groups 
unique(mergedData$rankgroup )
table(mergedData$rankgroup)

ta <-table(mergedData$rankgroup, mergedData$`Income Group`)
ta
