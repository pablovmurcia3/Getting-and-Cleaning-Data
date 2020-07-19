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

grep("[A]+(.*)[0-9]+",cameraData$intersection, value=TRUE)

grep("&(.*)Lane",cameraData$intersection, value=TRUE) # & followed by x characters
# and then Lane

# { and } are referred to as interval quantifiers; the let us specify the 
# minimum and maximum number of matches of an expression

# Interval quantifiers of the {n, m} form specify n, a min and m, a max 
# number of matches.


# m,n means at least m but not more than n matches 
# m means exactly m matches
# m, means at least m matches

[Bb]ush( +[^ ]+ +){1,5} debate

grep("Cold ([^ ]+ +){1,5}Hillen",cameraData$intersection, value=TRUE) 

x <- c("Bush has historically won all major debates he's done.",
       "in my view, Bush doesn't need these debates..",
       "Felix, I don't disagree that Bush was poorly prepared for the debate",
       "Keep repeating that Bush smirked and scowled during the debate",
       "Bush one word three words five six debate",
       "Bush debates Kerry", 
       "Bush doesn't debate anymore",
       "Bush onespace  twospace  twospace  debate")

grep("[Bb]ush ([^ ]+ +){1,5}debate", x, value = TRUE) # good
# Bush or bush followed by 1-5 words, followed by debate

grep("[Bb]ush( +[^ ]+ +){1,5} debate", x, value = TRUE) # bad

# In most implementations of regular expressions, the parentheses not only limit 
# the scope of alternatives divided by a “|”, but also can be used to “remember” 
# text matched by the subexpression enclosed We refer to the matched text with \1, \2, etc.

x <- c("el tonto tonto jeff")
grep("+([a-zA-Z]+) +\1 +", x, value = TRUE) # bad

# The * is “greedy” so it always matches the _longest_ possible string that 
# satisfies the regular expression. So

grep("^G(.*)i", cameraData$intersection, value = TRUE) 

grep("^G(.*?)i", cameraData$intersection, value = TRUE) # bad

# Summary

# Regular expressions are used in many different languages; not unique to R.
# Regular expressions are composed of literals and metacharacters that represent sets or classes of characters/words
# Text processing via regular expressions is a very powerful way to extract data from “unfriendly” sources (not all data comes as a CSV file)
# Used with the functions `grep`,`grepl`,`sub`,`gsub` and others that involve searching for text strings
# (Thanks to Mark Hansen for some material in this lecture.)

################################################################################

# Working with dates

# Starting simple

d1 <- date()
d1
class(d1)

# Date class
        
d2 <- Sys.Date()
d2
class(d2)

# Formatting dates

# `%d` = day as number (0-31), `%a` = abbreviated weekday,`%A` = unabbreviated 
# weekday, `%m` = month (00-12), `%b` = abbreviated month,
# %B` = unabbrevidated month, `%y` = 2 digit year, `%Y` = four digit year

format(d2,"%a %b %d")
format(d2,"%d %m %Y")

# Creating dates

x <- c("11jan1960", "12jan1960", "30mar1960", "30jul1960")
z <- as.Date(x, "%d%b%Y")
z

z[1] - z[2]
as.numeric(z[1]-z[2])

t<-dmy(x) # GOod!!!!!!!!
class(t)

# Converting to Julian 

weekdays(d2)
months(d2)
julian(d2)

# Lubridate 
        

install.packages("lubridate")
library(lubridate)

ymd("20140108")

mdy("08/04/2013")

dmy("03-04-2013")

# Dealing with times

t1 <- ymd_hms("2011-08-03 10:15:03")
class(t1)
t2 <- ymd_hms("2011-08-03 10:15:03",tz="Pacific/Auckland")
class(t2)

?Sys.timezone


# Some functions have slightly different syntax

x <- dmy(c("1jan2013", "2jan2013", "31mar2013", "30jul2013"))
wday(x[1])
wday(x[1],label=TRUE)

################################################################################

# Open Government Sites

#* United Nations [http://data.un.org/](http://data.un.org/)
#* U.S. [http://www.data.gov/](http://www.data.gov/)
#* [List of cities/states with open data](http://simplystatistics.org/2012/01/02/list-of-cities-states-with-open-data-help-me-find/)
#* United Kingdom [http://data.gov.uk/](http://data.gov.uk/)
#* France [http://www.data.gouv.fr/](http://www.data.gouv.fr/)
#* Ghana [http://data.gov.gh/](http://data.gov.gh/)
#* Australia [http://data.gov.au/](http://data.gov.au/)
#* Germany [https://www.govdata.de/](https://www.govdata.de/) 
#* Hong Kong [http://www.gov.hk/en/theme/psi/datasets/](http://www.gov.hk/en/theme/psi/datasets/)
#* Japan [http://www.data.go.jp/](http://www.data.go.jp/)
#* Many more [http://www.data.gov/opendatasites](http://www.data.gov/opendatasites)

# Gapminder
        

# http://www.gapminder.org/](http://www.gapminder.org/


# Survey data from the United States
        
# Infochimps Marketplace
        
# Kaggle
        
# Collections by data scientists
        
# * Hilary Mason http://bitly.com/bundles/hmason/1
# * Peter Skomoroch https://delicious.com/pskomoroch/dataset
# * Jeff Hammerbacher http://www.quora.com/Jeff-Hammerbacher/Introduction-to-Data-Science-Data-Sets
# * Gregory Piatetsky-Shapiro http://www.kdnuggets.com/gps.html
# * [http://blog.mortardata.com/post/67652898761/6-dataset-lists-curated-by-data-scientists](http://blog.mortardata.com/post/67652898761/6-dataset-lists-curated-by-data-scientists)

# More specialized collections

#* [Stanford Large Network Data](http://snap.stanford.edu/data/)
#* [UCI Machine Learning](http://archive.ics.uci.edu/ml/)
#* [KDD Nugets Datasets](http://www.kdnuggets.com/datasets/index.html)
#* [CMU Statlib](http://lib.stat.cmu.edu/datasets/)
#* [Gene expression omnibus](http://www.ncbi.nlm.nih.gov/geo/)
#* [ArXiv Data](http://arxiv.org/help/bulk_data)
#* [Public Data Sets on Amazon Web Services](http://aws.amazon.com/publicdatasets/)

# Some API's with R interfaces

#* [twitter](https://dev.twitter.com/) and [twitteR](http://cran.r-project.org/web/packages/twitteR/index.html) package
#* [figshare](http://api.figshare.com/docs/intro.html) and [rfigshare](http://cran.r-project.org/web/packages/rfigshare/index.html)
#* [PLoS](http://api.plos.org/) and [rplos](http://cran.r-project.org/web/packages/rplos/rplos.pdf)
#* [rOpenSci](http://ropensci.org/packages/index.html)
#* [Facebook](https://developers.facebook.com/) and [RFacebook](http://cran.r-project.org/web/packages/Rfacebook/)
#* [Google maps](https://developers.google.com/maps/) and [RGoogleMaps](http://cran.r-project.org/web/packages/RgoogleMaps/index.html)
