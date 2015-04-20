#
# run_analysis.R
#
run_analysis <- function(workdir = "/Users/clewis/Craig/Academic/Hopkins/Data Science/3. Getting and Cleaning Data/Assignment") {

# workdir is where we 
  datadir<-paste0(workdir,"//UCI HAR Dataset//")
  testdir<-paste0(datadir,"test//")
  traindir<-paste0(datadir,"train//")
  # may not need these
  testIntertialdir<-paste0(testdir,"UCI HAR Dataset//test//Inertial Signals//")
  trainIntertialdir<-paste0(traindir,"UCI HAR Dataset//train//Inertial Signals//")
  

# Files in test/train directory
#subject_test.txt subject_train.txt
#X_test.txt X_train.txt
#y_test.txt y_train.txt 
#Intertial Signals\
#  body_acc_x_test.txt
#  body_acc_y_test.txt
#  body_acc_z_test.txt
#  body_gyro_x_test.txt
#  body_gyro_y_test.txt
#  body_gyro_z_test.txt
#  total_acc_x_test.txt
#  total_acc_y_test.txt
#  total_acc_z_test.txt


#  
# Read activity labels from activity_labels.txt and name columns: activity and label
#

activityLabels<-read.table(paste0(datadir,"activity_labels.txt"))
names(activityLabels)[1]<-"activity"
names(activityLabels)[2]<-"label"

#
# Read Features fro features.txt 
#
featuresTable<-read.table(paste0(datadir,"features.txt"))
names(featuresTable)[1]<-"feature"
names(featuresTable)[2]<-"label"

# 
# Read test data - start with the list of subjects, then the X variables and then the y/activity labels
#
print("building test\n")
test_subjects<-read.table(paste0(testdir,"subject_test.txt"))
test_X<-read.table(paste0(testdir,"X_test.txt"))
test_y<-read.table(paste0(testdir,"y_test.txt"))
#
# we want the names of the activities, not the number so we'll build another vector with the names
#
labeled_test_y<-rep("",nrow(test_y))
for (i in 1:nrow(test_y)) { 
  this_activity<-test_y[i,1]
  this_activity_label<-activityLabels[this_activity,2]
  labeled_test_y[i]<-as.character(this_activity_label)
}
#
# Merge the test subject column, a column indicating that this is the TEST data set, the activities, labeled and the test data
#
tidy_test_table<-cbind(test_subjects,"TEST",labeled_test_y,test_X)
# 
# label these columns in the test table so that we can merge it with the training table below
names(tidy_test_table)[2]<-"Test/Train"
names(tidy_test_table)[3]<-"Activities"

print("built test\n")
#
# Since the training and test data are symmetric we'll do the same thing for the training data
# read training data - start with list of subjects, then X variabels and the y/activity label
#
print("Building train\n")
train_subjects<-read.table(paste0(traindir,"subject_train.txt"))
train_y<-read.table(paste0(traindir,"y_train.txt"))
train_X<-read.table(paste0(traindir,"X_train.txt"))

labeled_train_y<-rep("",nrow(train_y))
for (i in 1:nrow(train_y)) { 
  this_activity<-train_y[i,1]
  this_activity_label<-activityLabels[this_activity,2]
  labeled_train_y[i]<-as.character(this_activity_label)
}

tidy_train_table<-cbind(train_subjects,"TRAIN",train_y,train_X)
names(tidy_train_table)[2]<-"Test/Train"
names(tidy_train_table)[3]<-"Activities"
print("Built train\n")

#
# Create the table merging test and train datas
#
tidy_table<-rbind(tidy_test_table,tidy_train_table)

# Name the columns
# Start with the subject in column 1
names(tidy_table)[1]<-"Subject"
# Next column, test/train set in preceding steps

names(tidy_train_table)[1]<-"Subjects"

#
# Column 4 - 564 are the observations
# Take these from the features table
# Next column are the labels - take form the activity labels table
for (i in 1:nrow(featuresTable)) {
  #fixedLabels in columns
  fixedLabel<-as.character(featuresTable$label[i])
#  fixedLabel<-gsub("\\(\\)","",fixedLabel) ## remove parens
#  fixedLabel<-gsub("-","_",fixedLabel)  ##replace dash and commas with underscores
#  fixedLabel<-gsub(",","_",fixedLabel)  ##replace dash and commas with underscores
#  fixedLabel<-make.names(fixedLabel)
  names(tidy_table)[i+3]<-fixedLabel
}

# tidy_table - this is the mreged data set

# Now get the mean/std
meanLabels <- grep("mean",names(tidy_table))
stdLabels <-grep("std",names(tidy_table))

mean_std_table<-data.frame(rep(0,nrow(tidy_table)))
mean_std_table[1:3]<-tidy_table[1:3]
names(mean_std_table)[1]<-"Subject"

table_index=4
for(i in 1:length(meanLabels)) { 
  mean_std_table[,table_index]<-tidy_table[,meanLabels[i]]
  names(mean_std_table)[table_index]<-names(tidy_table)[meanLabels[i]]
  table_index=table_index + 1
}

for(i in 1:length(stdLabels)) { 
  mean_std_table[,table_index]<-tidy_table[,stdLabels[i]]
  names(mean_std_table)[table_index]<-names(tidy_table)[stdLabels[i]]
  table_index=table_index + 1
  
}
# tidy_data_set with means/stds
#write.file(mean_std_table,"mean_std_table.txt",row.name=FALSE)

library(dplyr)
6 activities
30 subjects


}
