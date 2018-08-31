# Getting_and_Cleaning_Data
Getting and Cleaning Data Course Project

Introduction

This repository contains the work required to the “Getting and Cleaning Data: Course Project”. Of the Data Science specialization. The raw data for this project can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The raw data contains 561 items that are unlabeled in the x_test.txt file, activity labels in the y_test.txt file and subjects are in the subject_test.txt file. The training data set contain the structure than the text data set. 

The objective for this project are to:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Results

A script was created (run_analysis.R) that merge the train and test data sets together,  extracting the means and standard deviations of the measurements. In addition, the file will provide descriptive names to the activities and measurements. Finally, an independent tidy data set (tidyData.txt) was created providing the results of this transformation. To achieve this the data.table and reshape2 packages were used. 

To read the tidyData.txt files the following R script can be used:

readTidyData <- data.table::fread(file.path(path,"tidyData.txt"))
View(readTidyData)


Code Book
The CodeBook.md file explains the transformations performed and the resulting data and variables.

