# para comprobar
# https://www.coursera.org/learn/data-cleaning/discussions/all/threads/dV0UQrlzEeWSsApeh9GXiQ?sort=createdAtAsc&page=1


# tips
# https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

# otro for interesante
# https://www.coursera.org/learn/data-cleaning/discussions/all/threads/dV0UQrlzEeWSsApeh9GXiQ?sort=createdAtAsc&page=1


# el paper 
# https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf

# 1 
X_test <- read.table("./UCI HAR dataset/test/X_test.txt")
subject_test <-read.table("./UCI HAR dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR dataset/test/y_test.txt")

unique(subject_test) # only 9 individuals


unique(y_test) # the 6 activities 
table(y_test)

# 2 
X_train <- read.table("./UCI HAR dataset/train/X_train.txt")
subject_train <-read.table("./UCI HAR dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR dataset/train/y_train.txt")


unique(subject_train) 
nrow(unique(subject_train))# only 9 individuals

unique(y_train) # the 6 activities 

# 3
################################################################################
features <- read.table("./UCI HAR dataset/features.txt")[,2]
features <-as.data.frame(features)
################################################################################


