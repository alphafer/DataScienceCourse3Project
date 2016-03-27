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

# Extracting and labeling Train data
SubjectTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","subject_train.txt")))
colnames (SubjectTrain) <- "SubjectIndex"
YTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","Y_train.txt")))
colnames (YTrain) <- "ActivityIndex"
XTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","X_train.txt")))

# Extracting and labeling Test data
SubjectTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","subject_test.txt")))
colnames (SubjectTest) <- "SubjectIndex"
YTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","Y_test.txt")))
colnames (YTest) <- "ActivityIndex"
XTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","X_test.txt")))

# Extracting Features data
Features <- tbl_df(read.table(file.path("./UCI HAR Dataset","features.txt")))

# Extracting and labeling Activity Labels data
ActivityLabels <- tbl_df(read.table(file.path("./UCI HAR Dataset","activity_labels.txt")))
colnames (ActivityLabels) <- c ('ActivityId','ActivityType')

# Binding Train and Test data
DT <- rbind (XTrain, XTest)

# Setting the column name using the seocnd column of the Features data.frame
colnames (DT) <- Features$V2

# Combining Subject tables by rows
DataSubject <- rbind (SubjectTrain,SubjectTest)

# Combining Activty tables by rows
DataActivity <- rbind (YTrain,YTest)

# Merging by columns
SubAcc <- cbind(DataSubject, DataActivity)
DT <- cbind (SubAcc,DT)

