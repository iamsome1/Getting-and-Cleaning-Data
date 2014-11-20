# Getting and Cleaning Data Project Code book
Data set for this project can be downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The downloaded zip file contains test and train folders, activity_labels.txt, features.txt, features_info.txt and README.txt. 

Data sets needed for this project tasks are:
* subject_test.txt, X_test.txt and y_test.txt from test folder.
* subject_train.txt, X_train.txt and y_train.txt from test folder.
* activity_labels.txt and features.txt from main folder (UCI HAR Dataset folder).

Feature selection details can be found in feature_info.txt file.
#####Task 1: Merges the training and the test sets to create one data set.
Load test data set
```
test_x<-read.table("test/X_test.txt")
test_y<-read.table("test/y_test.txt")
test_subj<-read.table("test/subject_test.txt")
```
Load train data set
```
train_x<-read.table("train/X_train.txt")
train_y<-read.table("train/y_train.txt")
train_subj<-read.table("train/subject_train.txt")
```
Merge test_x and train_x data sets into x
```
x<-rbind(test_x, train_x)
```
Merge test_y and train_y data sets into Y
```
y<-rbind(test_y, train_y)
```
Merge test_subj and train_subj data sets into subj
```
subj<-rbind(test_subj, train_subj)
```
#####Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
Load features data set
```
features<-read.table("features.txt")
```
Extract mean and standard deviation from features data set. Matching patterns "-(mean|std)\\(\\)" from features data set names.
```
mean_and_stddev <- grep("-(mean|std)\\(\\)", features[, 2])
```
Subset the data we need
```
x <- x[, mean_and_stddev]
```
Set names for data set x
```
names(x) <- features[mean_and_stddev, 2]
```
Remove the brackets "()" in column names matching with brackets.
```
names(x) <- gsub("\\(\\)", "", features[mean_and_stddev, 2])
```
#####Task 3: Uses descriptive activity names to name the activities in the data set 
Load data set activity_labels.txt
```
acts <- read.table("activity_labels.txt")
```
Name the activities
```
y[, 1] <- acts[y[, 1], 2]
```
Set column name
```
names(y) <- "Activity"
```
#####Task 4:Appropriately labels the data set with descriptive variable names.
Set colum title
```
names(subj)<-"Subject"
```
Merge x, y and subj data sets and make one data set
```
final <- cbind(x, y, subj)
```
#####Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Create tidy data set with average and write to txt file name "tidy_data_set.txt"
```
library(plyr) #load the library
tidy <- ddply(final, .(Subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy, "tidy_data_set.txt", row.name=FALSE)
```

