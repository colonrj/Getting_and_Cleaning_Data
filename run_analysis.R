# Getting and Cleaning Data Week 4 Project
#objectives:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#packages used on this project:  
#data.table  
#reshape2

#Load packages
packages<-  c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly= TRUE)
#Load data
path<- getwd()
url1<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url1, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")
#Load activity labels
activityLabels<- data.table::fread(file.path(path,"UCI HAR Dataset/activity_labels.txt")
                                   ,col.names = c("classLabels", "activityName"))

#Load feature data
feature <- data.table::fread(file.path(path,"UCI HAR Dataset/features.txt")
                             ,col.names = c("index","featureNames"))
#extract the information that contain the mean or standard deviation from feature
featuresWanted <- grep("(mean|std)\\(\\)", feature[, featureNames])
measurements <- feature[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)
measurements <- gsub("^f", "frequencyDomain", measurements)
measurements <- gsub("^t", "timeDomain", measurements)
measurements <- gsub("Acc", "Accelerometer", measurements)
measurements <- gsub("Gyro", "Gyroscope", measurements)
measurements <- gsub("Mag", "Magnitude", measurements)
measurements <- gsub("Freq", "Frequency", measurements)
measurements <- gsub("mean", "Mean", measurements)
measurements <- gsub("std", "StandardDeviation", measurements)

#correct typo on data
measurements <- gsub("BodyBody", "Body", measurements)
#Load train data
train <-data.table::fread(file.path(path,"UCI HAR Dataset/train/X_train.txt" )) 
train <- train [,featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- data.table::fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"  )
                                     ,col.names = c("activity"))
trainSubject<- data.table::fread(file.path(path,"UCI HAR Dataset/train/subject_train.txt" )
                                 ,col.names = c("subject"))
train <- cbind(trainSubject,trainActivities, train)

#Load test data
test<- data.table::fread(file.path(path,"UCI HAR Dataset/test/X_test.txt"))
test<- test[,featuresWanted, with=FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- data.table::fread(file.path(path,"UCI HAR Dataset/test/Y_test.txt")
                                    , col.names = c("activity"))
testSubject<- data.table::fread(file.path(path,"UCI HAR Dataset/test/subject_test.txt")
                                , col.names = c("subject"))
test <- cbind(testSubject, testActivities, test)

#merge train data and test 
mergeData1 <- rbind(train, test)
#Convert classLabels to activityName, more explicit
mergeData1 [["activity"]] <- factor(mergeData1[,activity]
                                    , levels = activityLabels[["classLabels"]]
                                    , labels = activityLabels[["activityName"]])
mergeData1[["subject"]] <- as.factor(mergeData1[, subject])
mergeData1<- reshape2::melt(data = mergeData1, id = c("subject","activity"))
mergeData1<-reshape2::dcast(data= mergeData1, subject + activity ~ variable, fun.aggregate = mean)




# Create a tidyData 
data.table::fwrite(x = mergeData1, file ="tidyData.txt", quote = FALSE)




