#Getting and Cleaning Data - Course Project
##CODEBOOK.md
*Fernando Alfaro*

The following are a description of the steps followed to complete the task for the Course "Getting and Cleaning Data" final project.

##Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##Attribute Information:

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

##Prep work

Before starting with the code for this project some house keeping task to keep R environment clean

Deleting environment variable
```
rm(list=ls())
```
Create a folder all the working files
```
if(!file.exists("./data")){dir.create("./data")}
```
Set the working directory to the new "data" folder
```
setwd("data")
```
Download the data
```
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile="data.zip",
              method="curl")

unzip (zipfile="data.zip")
```
Load required packages
```
library("dplyr",
        "data.table",
        "tidyr")
```

##1 Merges the training and the test sets to create one data set.

Extracting and labeling Train data
```
SubjectTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","subject_train.txt")))
colnames (SubjectTrain) <- "SubjectIndex"
YTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","Y_train.txt")))
colnames (YTrain) <- "ActivityIndex"
XTrain <- tbl_df(read.table(file.path("./UCI HAR Dataset/train","X_train.txt")))
```
Extracting and labeling Test data
```
SubjectTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","subject_test.txt")))
colnames (SubjectTest) <- "SubjectIndex"
YTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","Y_test.txt")))
colnames (YTest) <- "ActivityIndex"
XTest <- tbl_df(read.table(file.path("./UCI HAR Dataset/test","X_test.txt")))
```
Extracting Features data
```
Features <- tbl_df(read.table(file.path("./UCI HAR Dataset","features.txt")))
```
Extracting and labeling Activity Labels data
```
ActivityLabels <- tbl_df(read.table(file.path("./UCI HAR Dataset","activity_labels.txt")))
colnames (ActivityLabels) <- c ('ActivityIndex','ActivityType')
```
Binding Train and Test data
```
DT <- rbind (XTrain, XTest)
```
Setting the column name using the seocnd column of the Features data.frame
```
colnames (DT) <- Features$V2
```
Combining Subject tables by rows
```
DataSubject <- rbind (SubjectTrain,SubjectTest)
```
Combining Activity tables by rows
```
DataActivity <- rbind (YTrain,YTest)
```
Merging by columns
```
SubAcc <- cbind(DataSubject, DataActivity)
DT <- cbind (SubAcc,DT)
```

##2 Merges the training and the test sets to create one data set.

Getting the columns with the Mean and STD
```
MeanStdCol <- grep (".*Mean.*|.*Std.*",
                    names(DT),
                    ignore.case=TRUE)
```
Extracting columns from MeanStdCol from the DT table
```
DT <- DT[,MeanStdCol]
```
##3 Uses descriptive activity names to name the activities in the data set

Merge DT witht he ActivityLabel by the ActivityIndex Column. The Activy Type is added at the right end of the table.
```
DT <- merge(DT,
            ActivityLabels,
            by='ActivityIndex',
            all.x=TRUE)
```

##4 Appropriately labels the data set with descriptive variable names.

Using regex to change names for more descriptive values
- std() for SD
- mean() for MEAN
- starting with t for time
- starting with f for frequency
- Acc for accelerometer
- Gyro for gyroscope
- Mag for magnitude
- BodyBody for body

```
names(DT) <- gsub("std()","SD", names(DT))
names(DT) <- gsub("mean()","MEAN", names(DT))
names(DT) <- gsub("^t","time", names(DT))
names(DT) <- gsub("^f","frequency", names(DT))
names(DT) <- gsub("Acc","accelerometer", names(DT))
names(DT) <- gsub("Gyro","gyroscope", names(DT))
names(DT) <- gsub("Mag","magnitude", names(DT))
names(DT) <- gsub("BodyBody","body", names(DT))
```
##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
finalData = aggregate(DT[,names(DT) != c('ActivityIndex','SubjectIndex','ActvityType')],
                     by=list(ActivityIndex=DT$ActivityIndex,
                             SubjectIndex = DT$SubjectIndex,
                             ActivityType = DT$ActivityType),
                     mean)
```
Deleting the extra column
```
finalData[,88]<-NULL
```
Saving on disc in a comma-separated values CSV file
```
write.table(tidyData,'./finalData.csv', row.names=FALSE, sep=',');
```
