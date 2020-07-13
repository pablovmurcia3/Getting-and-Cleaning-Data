################################################################################
                                        # WEEK 3 #                                                                                                                   
################################################################################

# Get to tidy data!

set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X
X <- X[sample(1:5),] #scramble the data frame 
X
X$var2[c(1,3)] = NA # make some values missing 
X

X[,1]
X[,"var1"] #the same

X[1:2, "var2"] # subset rows and column at the same time


X[(X$var1 <= 3 & X$var3 > 11),] # with logical args (AND)
X[(X$var1 <= 3 | X$var3 > 15),] #(#OR)

# Dealing with missing values

X[X$var2 > 8,] # problem because NA
X[which(X$var2 > 8),] # subset with NAs

## Sorting

sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE) # with the na at the end of the sort
sort(X$var2)


## Ordering

X[order(X$var1),]
X[order(X$var1,X$var3),] # first sort var 1 the by var 3
X <- data.frame(a = c(3,3,2,2),b= c(1,2,4,3))
X[order(X$a,X$b),]

# We can do the same with plyr package
install.packages("plyr")
library(plyr)

arrange(X,var1) #sorting

arrange(X, desc(var1))

# Add rows and columns

X$var4 <- rnorm(5) # var4 new variable.. assign new vector
X

Y <- cbind(X, rnorm(5)) # The same

Z <- rbind(Y, rnorm(5))
