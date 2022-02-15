library(dplyr)
#obtain data
features <- read.table("./specData/UCI HAR Dataset/features.txt", header=FALSE,col.names = c("n", "functions"))
activity <- read.table("./specData/UCI HAR Dataset/activity_labels.txt", header=FALSE, col.names =c("actvnum","activity"))
subjecttest <- read.table("./specData/UCI HAR Dataset/test/subject_test.txt",header=FALSE,dec=".",col.names="Subject")
subjecttrain <- read.table("./specData/UCI HAR Dataset/train/subject_train.txt",header=FALSE,dec=".",col.names = "Subject")
xtest <- read.table("./specData/UCI HAR Dataset/test/X_test.txt",header=FALSE,col.names=features$functions)
xtrain <- read.table("./specData/UCI HAR Dataset/train/X_train.txt",header=FALSE,col.names=features$functions)
ytest <- read.table("./specData/UCI HAR Dataset/test/y_test.txt",header=FALSE,dec=".",col.names="actvnum")
ytrain <- read.table("./specData/UCI HAR Dataset/train/y_train.txt",header=FALSE,dec=".",col.names="actvnum")

#combine training and test data
testbound <- cbind(subjecttest, ytest, xtest)
trainbound <- cbind(subjecttrain, ytrain, xtrain)
bound <- rbind(testbound, trainbound)

#get Subject from activity number
bound2 <- merge(activity,bound, by.x="actvnum", by.y="actvnum", all=TRUE)
head(bound2)


#extract mean/std deviation
clname <-colnames(bound2)
clindex <- grep("mean|std", clname)
TidyData <-bound[c(1,2,clindex)]

#rename activities
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub(".meanFreq", "MeanFrequency", names(TidyData))
names(TidyData) <- gsub(".mean", "Mean", names(TidyData))
names(TidyData) <- gsub(".std", "StandardDeviation", names(TidyData))
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))

#summarise information
TidyData2 <- TidyData %>%
  group_by(activity, subject) %>%
  summarise_all(list(mean))
