# 1.Merges the training and the test sets to create one data set.

# Deleting eviroment variable
rm(list=ls())

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
colnames (ActivityLabels) <- c ('ActivityIndex','ActivityType')

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


#2. Merges the training and the test sets to create one data set.

# Getting the columns with the Mean and STD 
MeanStdCol <- grep (".*Mean.*|.*Std.*",
                    names(DT),
                    ignore.case=TRUE)

# Extracting columns from MeanStdCol from the DT table
DT <- DT[,MeanStdCol]

# 3. Uses descriptive activity names to name the activities in the data set

# Merge DT witht he ActivityLabel by the ActivityIndex Column. The Activy Type is added at the right end of the table. 
DT <- merge(DT,
            ActivityLabels,
            by='ActivityIndex', 
            all.x=TRUE)


# 4. Appropriately labels the data set with descriptive variable names.

names(DT) <- gsub("std()","SD", names(DT))
names(DT) <- gsub("mean()","MEAN", names(DT))
names(DT) <- gsub("^t","time", names(DT))
names(DT) <- gsub("^f","frequency", names(DT))
names(DT) <- gsub("Acc","accelerometer", names(DT))
names(DT) <- gsub("Gyro","gyroscope", names(DT))
names(DT) <- gsub("Mag","magnitude", names(DT))
names(DT) <- gsub("BodyBody","body", names(DT))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

finalData = aggregate(DT[,names(DT) != c('ActivityIndex','SubjectIndex','ActvityType')],
                     by=list(ActivityIndex=DT$ActivityIndex,
                             SubjectIndex = DT$SubjectIndex,
                             ActivityType = DT$ActivityType),
                     mean)
# Deleting the extracolumn
finalData[,88]<-NULL

# Saving on disc in a comma-separated values CSV file
write.table(tidyData,'./finalData.csv', row.names=FALSE, sep=',');

