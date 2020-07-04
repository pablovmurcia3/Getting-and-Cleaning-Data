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

