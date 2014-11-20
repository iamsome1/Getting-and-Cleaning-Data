library(plyr)
setwd("G:/Projects/Coursera/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
##Task 1: Merges the training and the test sets to create one data set.

#read test data set
test_x<-read.table("test/X_test.txt")
test_y<-read.table("test/y_test.txt")
test_subj<-read.table("test/subject_test.txt")

#read train data set
train_x<-read.table("train/X_train.txt")
train_y<-read.table("train/y_train.txt")
train_subj<-read.table("train/subject_train.txt")

#merge data set X
x<-rbind(test_x, train_x)
#merge data set Y
y<-rbind(test_y, train_y)
#merge subject data set
subj<-rbind(test_subj, train_subj)

##Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
features<-read.table("features.txt")
#extract mean and standard deviation from features
mean_and_stddev <- grep("-(mean|std)\\(\\)", features[, 2])
#subset data
x <- x[, mean_and_stddev]
names(x) <- features[mean_and_stddev, 2]
#Replace the "()" with "" and remove "()"
names(x) <- gsub("\\(\\)", "", features[mean_and_stddev, 2])
##Task 3: Uses descriptive activity names to name the activities in the data set
#Naming the columns
acts <- read.table("activity_labels.txt")
#Name the activities
y[, 1] <- acts[y[, 1], 2]
#Column title
names(y) <- "Activity"

#Task 4:Appropriately labels the data set with descriptive variable names.
#Set colum title
names(subj)<-"Subject"
#Merge x, y and subj data sets as one data set
final <- cbind(x, y, subj)


##Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Create tidy data set with average
tidy <- ddply(final, .(Subject, activity), function(x) colMeans(x[, 1:66]))
#Write the tidy data set to at text file
write.table(tidy, "tidy_data_set.txt", row.name=FALSE)
