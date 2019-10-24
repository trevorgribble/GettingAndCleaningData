## Ensure the dplyr library is loaded
library(dplyr)

## read in features label as vector (removing the redundant count column)
features <- read.csv("features.txt", sep="", header=FALSE) [2]
## read in the activity descriptors as a dataframe
activity <- read.csv("activity_labels.txt", sep="", header=FALSE)

## read in the main test & train dataframes
testset <- read.csv("test/X_test.txt", header=FALSE)
trainset <- read.csv("train/X_train.txt", header=FALSE)

## read in the test & train subject dataframes
testsubjects <- read.csv("test/subject_test.txt", header=FALSE)
trainsubjects <- read.csv("train/subject_train.txt", header=FALSE)

## read in the test & train activity label dataframes
testlabels <- read.csv("test/Y_test.txt", header=FALSE)
trainlabels <- read.csv("train/Y_train.txt", header=FALSE)

## merge the test and train dataframes & vectors
## simply adding the rows of the training set after the rows of the test set
## note consistency of test first than train
mergedsubjects <-rbind(testsubjects,trainsubjects)
mergedlabels <- rbind(testlabels,trainlabels)
### PROJECT REQUIREMENT #1 ####
mergedset <- rbind(testset,trainset)

## Update the names of the columns in the new merged sets
names(mergedsubjects) = "Subject"
names(mergedlabels) = "actnum"

## rename the activity columns of the activity label dataframe
names(activity) = c("actnum","Activity")

### PROJECT REQUIREMENT #4 ####
## Appropriately labels the data set with descriptive variable names.
names(mergedset)[1:length(mergedset[,])] = features[,]

### PROJECT REQUIREMENT #2 ###
## Extract only the measurements on the mean and standard deviation 
## for each measurement.

## create logical vector searching names including "mean()" or "std()"
meanorstd <- grepl("mean\\(\\)|std\\(\\)",names(mergedset))
## remove all columns that don't have "mean()" or "std()" in names
meanorstdset <- mergedset[,meanorstd]

### PROJECT REQUIREMENT #3 ###
##Use descriptive activity names to name the activities in the data set
## merge will use the actnum label as default as both dataframes share the label
mergedactivities<-merge(mergedlabels,activity)

## Column bind the subjects and merged activity names into std & mean measurements
completedset <- cbind(mergedsubjects,mergedactivities,meanorstdset)

## Remove now redundant actnum column
completedset <- completedset[,-2]

## PROJECT REQUIREMENT #5 ###
## use dplyr function piping to create a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## group by subject & activity, and then perform mean function on every 
## mean or std column
finaldataset <- completedset %>% group_by(Subject,Activity) %>% summarise_all(funs(mean))



