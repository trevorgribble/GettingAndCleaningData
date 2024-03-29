## README for the Analysis of the UCI Human Activity Recognition Using Smartphones Dataset

* We were asked to perform an analysis on the entire data set provided by UCI which can be found at this link: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

* Our goal was to create an output data set that analyzed & tidied up the full dataset according to the following specifications:

> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

* All code was written and ran on `R version 3.6.1 (2019-07-05)` on Macintosh platform `x86_64-apple-darwin15.6.0`

* The following is a high level description of each portion of the resulting script found in `run_analysis.R`, which outputs to `finaldataset.txt`.  The codebook for the output data set is found in `codebook.md` 


### Read in all the data and store it
```
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE) [2]
activity <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
testset <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
trainset <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
testsubjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
trainsubjects <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
testlabels <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
trainlabels <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
```

### merge the test and train dataframes
```
mergedsubjects <-rbind(testsubjects,trainsubjects)
mergedlabels <- rbind(testlabels,trainlabels)
mergedset <- rbind(testset,trainset)
```

### Update the names of the columns in the newly merged dataframes
```
names(mergedsubjects) = "Subject"
names(mergedlabels) = "actnum"
features[,1] <- as.character(features[,1])
names(mergedset)[1:length(mergedset[1,])] = features[,1]
```

### Extract only the measurements on the mean and standard deviation for each measurement.
```
meanorstd <- grepl("mean\\(\\)|std\\(\\)",names(mergedset))
meanorstdset <- mergedset[,meanorstd]
```

### Use descriptive activity names to name the activities in the data set
```
mergedlabels$Activity <- factor(mergedlabels$Activity, levels = activity[,1], labels=activity[,2])
completedset <- cbind(mergedsubjects,mergedlabels,meanorstdset)
```
### Create a second, independent tidy data set with the average of each variable for each activity and each subject.
```
finaldataset <- completedset %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
```
### This final dataframe was output to a text file called "finaldataset.txt"
```
write.table(finaldataset, file="finaldataset.txt", row.name=FALSE)
```

