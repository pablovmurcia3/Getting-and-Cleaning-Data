# XML exploration 

getwd()


fileUrl <- "https://www.w3schools.com/xml/simple.xml"

download.file(fileUrl, destfile = "simple.xml", method = "curl")

doc <- xmlTreeParse("simple.xml",useInternal=TRUE) # read data
# useinternal allows us to use later on the functions getNodeSet and
# xpathSApply which works only on objects class “XMLInternalDocument”
class(doc) # yes

# We now use the function xmlRoot to obtain access to the top node.

rootNode <- xmlRoot(doc)
class(rootNode)
xmlName(rootNode)
# We now use the function xmlRoot to obtain access to the top node.  The top
# node is the node that  contains all the other nodes in the file if you look at 
# the file in page 1 it shows on top the opening tag <breakfast_menu>


els <- getNodeSet(rootNode, "//food")
els
