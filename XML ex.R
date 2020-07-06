# XML exploration 

getwd()

fileUrl <- "https://www.w3schools.com/xml/simple.xml"

download.file(fileUrl, destfile = "simple.xml", method = "curl")

# or (problems)
library(RCurl)
library(XML)

fileUrl <- "https://www.w3schools.com/xml/simple.xml"
xData <- getURL(fileUrl) 
doc <- xmlTreeParse(xData,useInternalNodes = TRUE)



doc <- xmlTreeParse("simple.xml",useInternal=TRUE) # read data
# useinternal allows us to use later on the functions getNodeSet and
# xpathSApply which works only on objects class “XMLInternalDocument”
class(doc) # yes

# We now use the function xmlRoot to obtain access to the top node.

topNode <- xmlRoot(doc)
class(topNode)
xmlName(topNode)
# We now use the function xmlRoot to obtain access to the top node.  The top
# node is the node that  contains all the other nodes in the file if you look at 
# the file in page 1 it shows on top the opening tag <breakfast_menu>

# We now use the function getnodset to obtain all the nodes with the tag food, 
# including all the nodes between them
els <- getNodeSet(rootNode, "//food")
els
class(els)
# We can use the function xmlSApply and xmlValue to obtain all the values of the
# nodes in between the tags food

a <- xmlSApply(els, function(x)xmlSApply(x, xmlValue))
class(xmlSApply(els, function(x)xmlSApply(x, xmlValue)))
# We use the t function to invert the position of the rows and column

b <- t(xmlSApply(els, function(x)xmlSApply(x, xmlValue)))

d<-data.frame(t(xmlSApply(els, function(x)xmlSApply(x, xmlValue))))

# Another approach

els_name <- getNodeSet(topNode, "//name")
els_price <- getNodeSet(topNode, "//price")
els_desc <- getNodeSet(topNode, "//description")
els_calorie <- getNodeSet(topNode, "//calories")

food_names <- xmlSApply(els_name, xmlValue)
price <- xmlSApply(els_price, xmlValue)
description <- xmlSApply(els_desc, xmlValue)
calories <- xmlSApply(els_calorie, xmlValue)

df <- data.frame(name = food_names, price = price, description = description, 
           calories = calories)
df

# Another approach

els <- getNodeSet(topNode, "//food", fun = xmlToList)
els
class(els) # this time is a list

?getNodeSet

df<- data.frame(do.call(rbind, els))

# Another argument that we can pass on to the function getNodeSet is fun = 
# xmlToDATAframe.

els <- getNodeSet(topNode, "//food", fun = xmlToDataFrame)
els
class(els)
class(els[[1]])
df1<-els[[1]]

data.frame(t(do.call(cbind, els)),row.names = NULL)
food_df <-data.frame(t(do.call(cbind, els)),row.names = NULL)
names(food_df) <- c("name", "price", "description", "calories")

# Perhaps the easiest method to use when the data is organized neatly like in 
# our example is to use the function xmlToDataFrame function

els <- getNodeSet(rootNode, "//food")
df <- xmlToDataFrame(els)

################################################################################
################################################################################
library(XML)


doc <- htmlTreeParse("deezer1.xml",useInternal=TRUE) # read data
class(doc) 


topNode <- xmlRoot(doc)
class(topNode)
xmlName(topNode)

getNodeSet(rootNode)

artist <- xpathSApply(doc, "//a[@data-target= 'artist'] ", xmlValue)
artist
itemprop

track <- xpathSApply(doc, "//span[@itemprop= 'name'] ", xmlValue)
track

df <- data.frame(artist =artist, track =track)
