#·····································reading data················································
#
#NOTE: The first step of working with data in dplyr is to load the data into 'data frame tbl' 
#I'll use 'tbl_df()'
#
#Training data
xTrain <- tbl_df(read.table("./train/X_train.txt"))
yTrain <- tbl_df(read.table("./train/Y_train.txt"))
subjectTrain <- tbl_df(read.table("./train/subject_train.txt"))
#test data
xTest <- tbl_df(read.table("./test/X_test.txt"))
yTest <- tbl_df(read.table("./test/Y_test.txt"))
subjectTest <- tbl_df(read.table("./test/subject_test.txt"))
#Labels 
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("activityId","activity")
features_labels <- read.table("features.txt")
features <- as.character(features_labels[,2])
features <- c(features,"activityId","subjectId")

# 1) Merging the training and the test data sets and adding labels
# The training data
allTrainig <- cbind(xTrain,yTrain,subjectTrain)
# The test data
allTest <- cbind(xTest,yTest,subjectTest)
# All together
allData <- rbind(allTrainig, allTest)
colnames(allData) <- features


# 2) Extracting only measurements on the mean and std for each measurement
selectedFeature <- grep("-(mean|std)\\(\\)", colnames(allData))
selected <- c(selectedFeature, 562, 563) 
myData <- allData[, selected]


# 3) Using descriptive activity names to name the activities in the data set
myDataDescriptive <- merge(myData, activity_labels, by='activityId' ,all.x=TRUE)

# 4) Appropriately labels the data set with descriptive variable names.
names(myDataDescriptive)<-gsub("^t", "time", names(myDataDescriptive))
names(myDataDescriptive)<-gsub("^f", "frequency", names(myDataDescriptive))


# 5) From the data set in step 4, creates a second, independent 
#tidy data set with the average of each variable for each activity and each subject.
myDataDescriptive$activity <- as.factor(myDataDescriptive$activity)
myDataDescriptive$subjectId <- as.factor(myDataDescriptive$subjectId)
tidy <- aggregate(myDataDescriptive, by=list(activity = myDataDescriptive$activity, subject=myDataDescriptive$subjectId), mean)
write.table(tidy, file = "tidy.txt",row.name=FALSE)



