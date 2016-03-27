# Create a folder all the working files 
if(!file.exists("./data")){dir.create("./data")}

# Set the working directory to the new "data" folder
setwd("data")

# Download the data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile="data.zip", 
              method="curl")

unzip (zipfile="data.zip")

# Load required packages
library("dplyr",
        "data.table",
        "tidyr")

# Extracting Train data
SubjectTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","subject_train.txt")))
ActivityTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","Y_train.txt")))
Train <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","X_train.txt")))

# Extracting Test data
SubjectTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","subject_test.txt")))
ActivityTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","Y_test.txt")))
Test <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","X_test.txt")))


