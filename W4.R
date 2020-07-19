################################################################################
                                # WEEK 4 #                                                                                                                   
################################################################################

# Editing Text Variables

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/cameras.csv",method="curl")
cameraData <- read.csv("./data/cameras.csv")

names(cameraData)
names(cameraData) <- tolower(names(cameraData)) # make all the names lowercase

names(cameraData)

# split variables (in this case split where is a point)

splitNames <- strsplit(names(cameraData),"\\.")

splitNames[[5]]
splitNames[[6]]

# take out the first element before the period -- use sapply

splitNames[[6]][1]

firstElement <- function(x){x[1]}
sapply(splitNames,firstElement)

# Peer review Data

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/reviews.csv"
fileUrl2 = "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/solutions.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")

# substitude out characters

names(reviews)
names(reviews) <- sub("_","",names(reviews))
?sub

# in the case that we want to replace more than one _

testName <- "this_is_a_test"
sub("_","",testName) # it replaces only the first
gsub("_","",testName) # replaces all the _ 

# Finding values - grep(),grepl()

grep("Alameda",cameraData$intersection)
table(grepl("Alameda",cameraData$intersection)) # grepl is for a logical vector
grep("Alameda",cameraData$intersection,value=TRUE) # returns the values


cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),] # subset

# check if a  value appear
grep("JeffStreet",cameraData$intersection)
length(grep("JeffStreet",cameraData$intersection))

# More useful string functions
library(stringr)
nchar("Jeffrey Leek")
substr("Jeffrey Leek",1,7)
paste("Jeffrey","Leek")
paste("Jeffrey","Leek", sep = ".") #different separator

paste0("Jeffrey","Leek")
str_trim("Jeff      ")

# Important points about text in data sets

# Names of variables should be  all lower case when possible
# Descriptive (Diagnosis versus Dx)
# Not duplicated
# Not have underscores or dots or white spaces

# Variables with character values:
# Should usually be made into factor variables (depends on application)
# Should be descriptive (use TRUE/FALSE instead of 0/1 and Male/Female versus
# 0/1 or M/F)

################################################################################

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/cameras.csv",method="curl")
cameraData <- read.csv("./data/cameras.csv")

# Regular expressions (search in strings) -- used in many languages!

# Regular expressions can be thought of as a combination of literals and _metacharacters_
# To draw an analogy with natural language, think of literal text forming the 
# words of this language, and the metacharacters defining its grammar
# Regular expressions have a rich set of metacharacters

# Literals

# Simplest pattern consists only of literals.

grep("North",cameraData$intersection, value=TRUE)

# Regular Expressions

# We need a way to express 
# whitespace word boundaries 
# sets of literals
# the beginning and end of a line 
# alternatives (“war” or “peace”)
# Metacharacters to the rescue!

# Metacharacters

# Some metacharacters represent the start of a line ---- ^
grep("^North",cameraData$intersection, value=TRUE)


# Metacharacters

# $ represents the end of a line

grep("Ave$",cameraData$intersection, value=TRUE)

# Character Classes with []

# We can list a set of characters we will accept at a given point in the match

grep("[Bb]",cameraData$intersection, value=TRUE) # strings that have Bb
grep("[BbH]",cameraData$intersection, value=TRUE) # strings that have B or b or H 

#  combination

grep("^[HPE]",cameraData$intersection, value=TRUE) # strings that Start in H or P or E
grep("[a]$",cameraData$intersection, value=TRUE)  # strings that ends in a

# Similarly, you can specify a range of letters [a-z] or [a-zA-Z]; notice that 
# the order doesn’t matter

grep("[a-d]$",cameraData$intersection, value=TRUE)

grep("[0-9]$",cameraData$intersection, value=TRUE)

     
# When used at the beginning of a character class, the “\^” is also a metacharacter
# and indicates matching characters NOT in the indicated class

grep("[^aetd]$",cameraData$intersection, value=TRUE) # strings that dont end witg a e t d

# “.” is used to refer to any character. So

grep("&.B",cameraData$intersection, value=TRUE) # & followed by B separated by any charcter

grep("&.[A-Z]",cameraData$intersection, value=TRUE)

# This does not mean “pipe” in the context of regular expressions; instead it 
# translates to “or”; we can use it to combine two expressions, the subexpressions
# being called alternatives

grep("Blvd|Ave",cameraData$intersection, value=TRUE)

grep("Voilet|Road|Drive",cameraData$intersection, value=TRUE)

# The alternatives can be real expressions and not just literals

grep("^[Nn]orth|^Cold",cameraData$intersection, value=TRUE)
grep("^[Nn]orth|Cold",cameraData$intersection, value=TRUE) # cold doesnt have 
# to be in the first character 

# Subexpressions are often contained in parentheses to constrain the alternatives

grep("^([Nn]orth|Cold)",cameraData$intersection, value=TRUE)

# The question mark indicates that the indicated expression is optional

[Gg]eorge( [Ww]\.)? [Bb]ush 

# we wanted to match a “.” as a literal period; to do that, we had to “escape” 
# the metacharacter, preceding it with a backslash In general, we have to do this
#for any metacharacter we want to include in our match

# The * and + signs are metacharacters used to indicate repetition; * means
# “any number, including none, of the item” and + means “at least one of the item”

grep("(.*)",cameraData$intersection, value=TRUE) # repetition of any number of charactera

grep("[0-9]+",cameraData$intersection, value=TRUE)

grep("&(.*)Lane",cameraData$intersection, value=TRUE) # & followed by x characters
# and then Lane
