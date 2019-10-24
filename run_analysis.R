## Ensure the dplyr library is loaded
library(dplyr)

## read in features label as vector (removing the redundant count column)
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE) [2]
## read in the activity descriptors as a dataframe
activity <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

## read in the main test & train dataframes
testset <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
trainset <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)

## read in the test & train subject dataframes
testsubjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
trainsubjects <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

## read in the test & train activity label dataframes
testlabels <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
trainlabels <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)

## merge the test and train dataframes & vectors
## simply adding the rows of the training set after the rows of the test set
## note consistency of test first than train
mergedsubjects <-rbind(testsubjects,trainsubjects)
mergedlabels <- rbind(testlabels,trainlabels)
### PROJECT REQUIREMENT #1 ####
mergedset <- rbind(testset,trainset)

## Update the names of the columns in the new merged sets
names(mergedsubjects) = "Subject"
names(mergedlabels) = "Activity"

## rename the activity columns of the activity label dataframe
names(activity) = c("actnum","ActivityName")

### PROJECT REQUIREMENT #4 ####
## Appropriately labels the data set with descriptive variable names.
features[,1] <- as.character(features[,1])
names(mergedset)[1:length(mergedset[1,])] = features[,1]

### PROJECT REQUIREMENT #2 ###
## Extract only the measurements on the mean and standard deviation 
## for each measurement.

## create logical vector searching names including "mean()" or "std()"
meanorstd <- grepl("mean\\(\\)|std\\(\\)",names(mergedset))
## remove all columns that don't have "mean()" or "std()" in names
meanorstdset <- mergedset[,meanorstd]

### PROJECT REQUIREMENT #3 ###
##Use descriptive activity names to name the activities in the data set
mergedlabels$Activity <- factor(mergedlabels$Activity, levels = activity[,1], labels=activity[,2])

## Column bind the subjects and merged activity names into std & mean measurements
completedset <- cbind(mergedsubjects,mergedlabels,meanorstdset)

## PROJECT REQUIREMENT #5 ###
## use dplyr function piping to create a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## group by subject & activity, and then perform mean function on every 
## mean or std column
finaldataset <- completedset %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))

write.table(finaldataset, file="finaldataset.txt", row.name=FALSE)

