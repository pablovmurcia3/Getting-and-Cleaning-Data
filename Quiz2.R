# 1
install.packages("httpuv")
library(httpuv)
library(httr)
myapp <- oauth_app("github",
                   key = "91485c044c249468f3d5",
                   secret = "35ed1f13f1509d6b84d20b15245d956feddb9241"
)

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token =github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
req
stop_for_status(req)
class(req)

library(RJSONIO)
ms <- content(req) #extract the json data .-- create a structured r object (that is raw)
ms
str(ms)
class(ms) # a list

p <- toJSON(ms)
class(p)

json <- jsonlite::fromJSON(toJSON(ms))
dim(json)
json$name
str(json)

datasharing <- json[json$name == "datasharing",]
datasharing$created_at # "2013-11-07T13:25:07Z"

# 2

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/america.csv", method = "curl")

acs <- read.csv("./data/america.csv")
str(acs)

acs$pwgtp1

install.packages("sqldf")
library(sqldf)


df <- sqldf("select pwgtp1 from acs where AGEP < 50")

unique(acs$AGEP)


# 3

df <- sqldf("select distinct AGEP from acs")

# 4


con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
class(htmlCode)
close(con) # close the connection 

nchar(c(htmlCode[10], htmlCode[20], htmlCode[30], htmlCode[100]))

# 5

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(fileUrl, destfile = "./data/cpc.for", method = "curl")

dffr4<- read.fwf("./data/cpc.for", widths=c(-27,5), skip =4)
head(dffr4)
c4 <- sum(dffr4)
c4








