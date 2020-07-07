################################################################################
                                # WEEK 1 #                                                                                                                   
################################################################################

# The goal of this class

# raw data -> processing script -> tidy data -> data analysis -> data comunication 

# 1. Raw data and processed data

# raw data - the original source of data
# The raw data may only need to be processed once, but regardless of how often 
# you process it, you need to keep a record of all the different things you did.
# Because it can have a major impact on the data stream analysis. 

# 2. Processed data

# Data that is ready for analysis

#  So the processing of the data might include merging, subsetting, transforming

# All the steps must be recorded!!

# GETTING DATA: taking raw data and turning it into processed data.

# 3. The target: the final objective

# you should have 4 things:
# - A raw data
# right formant if: you ran no software in the data

# - A tidy data 
# variable - column
# observation - row

# one table from every kind of variable
# important: a key to match tables

# - A code book

# information about the variables --UNITS!

# - An explicit an exact recipe to transform the raw data into tidy

# R script

################################################################################
################################################################################

# Downloading files


# first: take account the working directory 
# (relative and absolute)

# relative "../" moving up "./data" moving down


# check sub-directory to put the data and create it

if (!file.exists("data")){   # !
         
        dir.create("data")
        
}


# download command -- download.file -- increase reproducibility
# useful to download -- tab delimited, csv

# copy link address of the data (in some repositories of data in the export page)

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
# some important parameters:
# destfile: destination-- directory and the name of the file
# method : ?

list.files("./data")
?list.files

dateDownloaded <- date() #keep track of when you downloaded  the data
dateDownloaded

################################################################################
################################################################################

# reading local files 
# read.table: tab delimited file
# read.csv:  coma separated file

cameraData <- read.csv("./data/cameras.csv")
str(cameraData)

# read excel: read.xlsx
# need library library(xlsx)

install.packages("read.xls")


###############################################################################

# read XML files

# XML: two components 

# 1. Markup: labels that give the text estructure
# 2. Content: The actual text of the document

# tag: correspond to general lables
# elements: specific examples of tags
<greeting> hellow, world </greeting>
# attributes:  components of the label

install.packages("XML")
library(XML)

install.packages("bitops") # in the forum 
install.packages("RCurl")
library(RCurl)
fileUrl <- "https://www.w3schools.com/xml/simple.xml"
xData <- getURL(fileUrl)
doc <- xmlParse(xData)
rootNode <- xmlRoot(doc)
xmlName(rootNode)


fileUrl <- "http://www.w3schools.com/xml/simple.xml" # in the class (not work)
doc <- xmlTreeParse(fileUrl, useInternalNodes = TRUE) # load the document and parse it 
rootNode <- xmlRoot(doc)
xmlName(rootNODE)


names(rootNode)
rootNode[[1]] # show the first part of the xml file (like a list)
xmlValue(rootNode[[1]]) # extract the text (that is beetwen the tags)

rootNode[[1]][[1]]

xmlSApply(rootNode,xmlValue)


# Xpath -- language to acces the data of the xml

# /node: top level node
# //node: Node at any level 
# node[@attr-name] : node with an attribute name
# node[@attr-name== bob]

xpathSApply(rootNode,"//name", xmlValue) #target in one name of tag

xpathSApply(rootNode,"//price", xmlValue) #target in one name of tag

xpathSApply(rootNode,"/breakfast_menu", xmlValue) #top level node

# Example

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"

doc <- htmlTreeParse(fileUrl, useInternalNodes = TRUE)


fileUrl <- "https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens.xml"
download.file(fileUrl, destfile = "raven.xml", method = "curl")
doc <- xmlTreeParse("raven.xml",useInternal=TRUE)


library(RCurl) 
fileUrl <- "https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens" 
xData <- getURL(fileUrl) 
doc <- htmlTreeParse(xData,useInternalNodes = TRUE)

scores <- xpathSApply(doc, "//div[@class='score']", xmlValue) 
scores 


scores <- xpathSApply(doc, "//div[@class= 'score'] ", xmlValue)
scores
teams <- xpathSApply(doc, "//div[@class= 'game-info'] ", xmlValue)
teams



# Other option
install.packages("xml2")
library(xml2)
suppressWarnings(dx<-read_xml("https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens", as_html=TRUE))
teams<-as.character(xml_contents(xml_find_all(dx,"//div[@class='game-info']")))
scores<-as.character(xml_contents(xml_find_all(dx,"//div[@class='score']")))
teams
scores

################################################################################
################################################################################

# Reading JSON

# JSON = JavaScript Object Notation
# lightweight data storage, common format for data from application programming
# interfaces (API)
# similar to XML in structure but different in syntax/format
# data can be stored as: numbers, strings, boolean, array, object

install.packages("jsonlite")
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos") # strips data
names(jsonData) # i get a structured data frame

names(jsonData$owner) 

jsonData$owner$login

# converts data frame into JSON format

data <- toJSON(iris, pretty = TRUE) #  pretty = TRUE ;formats the code nicely
cat(data)

iris2 <- fromJSON(data) # ..converts from JSON object/code back to data frame
head(iris2)             # not only URL!

################################################################################
################################################################################

# data.table

# inherits from data.frame (external package) → all functions that accept 
# data.frame work on data.table 

# can be much faster (written in C), much much faster at subsetting/grouping/
# updating

install.packages("data.table")
library(data.table)

dt <- data.table(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9)) 
dt                 

tables() # returns all data tables in memory

# row subsetting 

dt[2, ]
dt[dt$y=="a",] 
dt[c(2, 3)] # we can only use one index (different from data frame) 

# Expressions: statements enclosed in {}

{
    x = 1
    y =2
}


k = {print(10);5}
k

#  argument after comma is called an expression (collection of statements 
# enclosed in {})

# Index in column is for summarazing data
set.seed(123)
dt <- data.table(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9)) 
dt
dt[,c(2,3)] # oooo i can subset

dt[,list(mean(x), sum(z))] # returns mean of x column and sum of z column 
# (no "" needed to specify column names, x and z in example) 
dt[, table(y)] #  get table of y value (perform any functions) 
class(dt)
#add new columns

dt[,w:=z^2] # in a data frame this process spent more memory 
dt

df <- data.frame(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9)) 
df[,4] <- df[,3]^2
names(df) <-c("x","y","z","w")
df

# detail 
dt2 <- dt
dt2
dt[, y:= 2] 
dt
dt2 # when changes are made to dt, changes get translated to dt2 

# muti-steps operations

dt[, m:= {temp <- (x+z); log2(temp +5)}]  # adds a column that equals log2(x+z +5) 
dt

# plyr like operations 


dt[,a:=x>0]
dt
dt[,b:=mean(x+w), by=a] 
dt
?sample

# special variables 
# .N = returns integer, length 1, containing the number (essentially count) 
set.seed(123)
dt <- data.table (x=sample(letters[1:3], 1E5, TRUE)) # generates data table 

dt[, .N, by=x] # creates a table to count observations by the value of x 

# keys (quickly ﬁlter/subset) 
dt <- data.table(x = rep(c("a", "b", "c"), each = 100), y = rnorm(300)) 

setkey(dt, x) # set the key to the x column 

dt["a"] # returns a data frame, where x = ‘a’ (eﬀectively ﬁlter) 

# joins (merging tables) 
DT1 <- data.table(x = c("a", "a","b", "dt1"), y = 1:4)
DT1
DT2 <- data.table(x= c("a","b","dt2"), z = 5:7) 
DT2
setkey(DT1, x); setkey(DT2, x) # sets the keys for both data tables to be column x
merge(DT1,DT2)#  returns a table, combine the two tables using column x, 
# ﬁltering to only the values that match up between common elements the two x 
# columns (i.e. ‘a’) and the data is merged together 


# fast reading of ﬁles
big_df <- data.frame(x=rnorm(1E6), y= rnorm(1E6))
file <- tempfile() 
write.table(big_df, file=file, row.names=FALSE, col.names = TRUE, sep = "\t",
            quote = FALSE) 
fread(file) # read ﬁle and load data.table much faster than read.table()
system.time(fread(file)) 

system.time(read.table(fread(file), header = "TRUE", sep ="/t")) 

            