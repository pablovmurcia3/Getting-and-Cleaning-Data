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
stop_for_status(req)
ms <- content(req)
str(ms)
library(RJSONIO)
 
json <- jsonlite::fromJSON(toJSON(ms))
dim(json)
json$name

datasharing <- json[json$name == "datasharing",]
datasharing$created_at # "2013-11-07T13:25:07Z"

# 2


