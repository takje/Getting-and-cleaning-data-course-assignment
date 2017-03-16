## create a tempfile to store the downloaded zip file and assign it to "sourceSet"
sourceSet <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", sourceSet)

## unzip the file
sourceSet <- unzip(sourceSet)

## check the structure of the file
str(sourceSet)

## view the list of files
sourceSet

## read the required files
features <- fread(sourceSet[[2]])
str(features)
activityLabel <- fread(sourceSet[[1]])
str(activityLabel)
testSubject <- fread(sourceSet[[14]])
str(testSubject)
testX <- fread(sourceSet[[15]])
str(testX)
testY <- fread(sourceSet[[16]])
str(testY)
trainSubject <- fread(sourceSet[[26]])
str(trainSubject)
trainX <- fread(sourceSet[[27]])
str(trainX)
trainY <- fread(sourceSet[[28]])
str(trainY)

## merge the files
dataSubject <- rbind(testSubject, trainSubject)
dataActivity <- rbind(testY, trainY)
dataFeatures <- rbind(testX, trainX)

## merge all in one dataset
fullSet <- cbind(dataActivity, dataSubject, dataFeatures)

## assign names to columns
names(fullSet) <- c(c("activity", "subject"), as.character(features$V2))

## Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdSet <- fullSet[, .SD, .SDcols = names(fullSet) %like% "activity|subject|mean\\(\\)|std\\(\\)"] 

## Uses descriptive activity names to name the activities in the data set
meanStdSet$activity <- activityLabel$V2[meanStdSet$activity]

## Appropriately labels the data set with descriptive variable names.
names(meanStdSet)<-gsub("^t", "time", names(meanStdSet))
names(meanStdSet)<-gsub("^f", "freqency", names(meanStdSet))
names(meanStdSet)<-gsub("Acc", "Accelerometer", names(meanStdSet))
names(meanStdSet)<-gsub("Gyro", "Gyroscope", names(meanStdSet))
names(meanStdSet)<-gsub("Mag", "Magnitude", names(meanStdSet))

## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
## Get the average-
tidyData <- meanStdSet[, lapply(.SD, mean), by = c("activity", "subject")]

## create a new set of data
write.table(tidyData, file = "tidy.txt", row.names = FALSE)