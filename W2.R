################################################################################
                                # WEEK 2 #                                                                                                                   
################################################################################

# Reading data from mySQLb

# Database software

# Data -> Databases -> Tables -> fields (culumns) and records (rows)

library(RMySQL)


ucscDB <- dbConnect(MySQL(), user = "genome",  # assign a handle ("ucscDB") to a connection of a database
                    host = "genome-mysql.cse.ucsc.edu")

result <-  dbGetQuery(ucscDB, "show databases;") #show databases; A MYSQL command
dbDisconnect(ucscDB) # disconnect from the server



hg19 <- dbConnect(MySQL(), user = "genome",   db = "hg19", #  ---- db data-base
                    host = "genome-mysql.cse.ucsc.edu")


allTables <- dbListTables(hg19) # look to all the tables that exist in hg19 data-base
length(allTables)

allTables[1:5]


dbListFields(hg19, "affyU133Plus2") # look fields (columns) in affyU133Plus2 table

dbGetQuery(hg19, "select count(*) from affyU133Plus2")# look rows in affyU133Plus2 table 

# read form the table
                  
affyData <- dbReadTable(hg19, "affyU133Plus2") #extract the table from the database
head(affyData)

# Select only a subset

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
# in this case y restrict the table IN the Server not in my computer
affyMis <- fetch(query)
quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10) #"suck" only the 10 first rows of the data table
dim(affyMisSmall)

dbClearResult(query) #clears query from remote databas

dbDisconnect(hg19) # always!

################################################################################
################################################################################

# read HDF5

# Hierarchical Data Format (HDF) is a set of file formats (HDF4, HDF5) 
# designed to store and organize large amounts of data.

# HDF5 simplifies the file structure to include only two major types of object:

# Datasets, which are multidimensional arrays of a homogeneous type
# datasets have: header and a data array
# Groups, which are container structures which can hold datasets and other groups
# groups have : header and symbol table



if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")

BiocManager::install("rhdf5")
library(rhdf5)

#create a hdf5 file
created = h5createFile("example.h5")
created

# create groups

created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa") #subgroup of foo called foobaa
h5ls("example.h5")

# write in the file 
 A <- matrix(1:10, nrow = 5)
h5write(A, "example.h5", "foo/A") 

B <- array(seq(0.1,2.0, by = 0.1), dim = c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B" )

h5ls("example.h5")

df2 <- data.frame(1L:5L, seq(0,1, length.out = 5), LETTERS[1:5], 
                 stringsAsFactors = FALSE) 
df2
h5write(df2, "example.h5", "df2" ) # in the to level group

h5ls("example.h5")

# read data

readA <- h5read("example.h5", "foo/A") # last arg is the path of the dataset
readA

readB <- h5read("example.h5", "foo/foobaa/B") 
readB

readdf2 <- h5read("example.h5", "df2")
readdf2
# writing and reading chunks

h5write(c(12,13,14), "example.h5", "foo/A", index=list(1:3,1) ) # write in only a chunk
h5read("example.h5", "foo/A")


h5read("example.h5", "foo/A", index=list(3:5,2) ) # read only small chunks

################################################################################
################################################################################

# Reading data from the web 

# Webscraping: Programatically extracting data from the html code of websites

# in some cases is against the terms of service of the websites (ip address blocked)

# Example

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
class(htmlCode)
close(con) # close the connection 
htmlCode[10]



library(XML)
library(httr)

url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(rawToChar(GET(url)$content), useInternalNodes = TRUE)
xpathSApply(html, "//title", xmlValue)


# Other option #################################################################
url1 <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
download.file(url1, destfile = "jeff.html", method = "curl")
html <- htmlTreeParse("jeff.html",useInternal=TRUE)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)

################################################################################

xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)


# GET - httr package

library(httr)

html2=GET("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")

content2=content(html2,as="text")

parsedHtml=htmlParse(content2,asText=TRUE)

xpathSApply(parsedHtml, "//title",xmlValue)

# Accessing websites with passwords

pg1 = GET("http://httpbin.org/basic-auth/user/passwd")

pg1

pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2

names(pg2)

# Using handles 
google = handle("http://google.com") #save the authentication
pg1 = GET(handle=google,path="/")
names(pg1)
pg2 = GET(handle=google,path="search")
names(pg2)

################################################################################
################################################################################

# Reading data from API

# API: Application Programming Interfaces

library(httr)

myapp = oauth_app("twitter",
                  key="k5kGZ7nhuquMmhTGrv0r32Yv4",secret="Of8AjvBRa5QDy4C0LMAINVR5340qbBemulfmDfdXzUlmHZmRDC")


sig = sign_oauth1.0(myapp,
                    token = "3411628671-HSFKPbNHDfjsLskDNOQ9l9h3gBkW0hHviZPSkV1",
                    token_secret = "tlwMWtRnDAtbxpeU6qMfqAMV4LNnt2Hh5W61DuUxXybqZ")

homeTL = GET("https://api.twitter.com/1.1/statuses/user_timeline.json?count=70", sig)

# Converting the json object

library(RJSONIO)

json1 = content(homeTL)
json1[1]
json2 = jsonlite::fromJSON(toJSON(json1)) #structure a data-frame
dim(json2)
dt<-data.frame(json2[,1:9])



