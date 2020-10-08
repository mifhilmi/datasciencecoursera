#install.packages("reshape2")
library(reshape2)
# reshape2 library will be used in "melt" and "dcast" functions below (number 5)
# if reshape2 package is not installed yet, use install.packages("reshape2") to install

# read training data set (X_train.txt) and label (y_train.txt)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data set (X_test.txt) and label (y_test.txt)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")  


# 1. Merges the training and the test sets to create one data set.

# merge vertically using rbind
X_merged <- rbind(X_train, X_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)

# add feature names as a new column 
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features$V2
colnames(X_merged) <- features


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

merged_subset <- X_merged[ , grep("mean|std", colnames(X_merged))]


# 3. Uses descriptive activity names to name the activities in the data set

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
y_merged$activity <- activity_labels[y_merged$V1, 2]


# 4. Appropriately labels the data set with descriptive variable names.

names(y_merged) <- c("ActivityID", "Activity")
names(subject_merged) <- "SubjectID"


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# merge all data into a single data set using column bind
merged_all <- cbind(subject_merged, y_merged, X_merged)
labels_all <- c("SubjectID", "ActivityID", "Activity")

# data_labels = colnames in merged_all but not in labels_all
data_labels = setdiff(colnames(merged_all), labels_all)
# melt to convert into a molten dataframe
melted_data = melt(merged_all, id = labels_all, measure.vars = data_labels, na.rm=TRUE)
# convert data between wide and long forms
tidy_data = dcast(melted_data, SubjectID + Activity ~ variable, mean)

# write table into a file
write.table(tidy_data, file = "./tidy_data.txt", row.names = F, quote = F, sep = "\t")
