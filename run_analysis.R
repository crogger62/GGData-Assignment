#
# run_analysis.R
#
run_analysis <- function(workdir = "/Users/clewis/Craig/Academic/Hopkins/Data Science/3. Getting and Cleaning Data/Assignment") {

# First we read in all of the files
# workdir is the directory where data can be found
# bouild out the relevant directories
#
  datadir<-paste0(workdir,"//UCI HAR Dataset//")
  testdir<-paste0(datadir,"test//")
  traindir<-paste0(datadir,"train//")
#  
# InertialSignals - we do not need these for this analysis; they are in the data set but needed
#   these are avaialble for later use
#
  testIntertialdir<-paste0(testdir,"UCI HAR Dataset//test//Inertial Signals//")
  trainIntertialdir<-paste0(traindir,"UCI HAR Dataset//train//Inertial Signals//")
  

# Files in test/train directory
#  subject_test.txt subject_train.txt
#  X_test.txt X_train.txt
#  y_test.txt y_train.txt 
#  Intertial Signals\
#    body_acc_x_test.txt
#    body_acc_y_test.txt
#    body_acc_z_test.txt
#    body_gyro_x_test.txt
#    body_gyro_y_test.txt
#    body_gyro_z_test.txt
#    total_acc_x_test.txt
#    total_acc_y_test.txt
#    total_acc_z_test.txt


#  
# Read activity labels from activity_labels.txt and name columns: activity and label columns
#

activityLabels<-read.table(paste0(datadir,"activity_labels.txt"))
names(activityLabels)[1]<-"activity"
names(activityLabels)[2]<-"label"

#
# Read Features from features.txt and label columns
#
featuresTable<-read.table(paste0(datadir,"features.txt"))
names(featuresTable)[1]<-"feature"
names(featuresTable)[2]<-"label"

# 
# Read test data - start with the list of subjects, then the X variables and then the y/activity labels
#
# for debugging >- print("building test")
#
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

# for debugging >- print("built test")
#
# Since the training and test data are symmetric we'll do the same thing for the training data
# read training data - start with list of subjects, then X variabels and the y/activity label
#
# for debugging >- print("building train")
train_subjects<-read.table(paste0(traindir,"subject_train.txt"))
train_y<-read.table(paste0(traindir,"y_train.txt"))
train_X<-read.table(paste0(traindir,"X_train.txt"))
# fix activityLabels
labeled_train_y<-rep("",nrow(train_y))
for (i in 1:nrow(train_y)) { 
  this_activity<-train_y[i,1]
  this_activity_label<-activityLabels[this_activity,2]
  labeled_train_y[i]<-as.character(this_activity_label)
}
# create training table
tidy_train_table<-cbind(train_subjects,"TRAIN",train_y,train_X)
names(tidy_train_table)[2]<-"Test/Train"
names(tidy_train_table)[3]<-"Activities"
# for debugging >- print("built train")

#
# Create the table merging test and train datas
#
tidy_table<-rbind(tidy_test_table,tidy_train_table)

# Name the columns
# Start with the subject in column 1
names(tidy_table)[1]<-"Subject"
# Next column, test/train set in preceding steps
#
# Column 4 - 564 are the observations
# Take these from the features table
# Next column are the labels - take form the activity labels table
for (i in 1:nrow(featuresTable)) {
  #fixedLabels in columns
  fixedLabel<-as.character(featuresTable$label[i])
  names(tidy_table)[i+3]<-fixedLabel
}

# tidy_table - this is the mreged data set of test and train data with subject, activity, dataset (TEST/TRAIN), and the features labeled

# To extract the mean/std columns we use grep to identify the appropriate column names
# note we just find all the" "mean" and "std" columns
# we build a new table that includes the Subject, Activities, TEST/TRAIN and the appropriate feature labels with "mean"/"std"
meanLabels <- grep("mean",names(tidy_table))
stdLabels <-grep("std",names(tidy_table))

# build out a data frame and start to label columns
mean_std_table<-data.frame(rep(0,nrow(tidy_table)))
mean_std_table[1:3]<-tidy_table[1:3]
names(mean_std_table)[1]<-"Subject"

# move over the columns for "mean" and label it
table_index=4
for(i in 1:length(meanLabels)) { 
  mean_std_table[,table_index]<-tidy_table[,meanLabels[i]]
  names(mean_std_table)[table_index]<-names(tidy_table)[meanLabels[i]]
  table_index=table_index + 1
}

# move over the columns for "std" and label it
for(i in 1:length(stdLabels)) { 
  mean_std_table[,table_index]<-tidy_table[,stdLabels[i]]
  names(mean_std_table)[table_index]<-names(tidy_table)[stdLabels[i]]
  table_index=table_index + 1
  
}

# this is the number of columns in the mean/std table
mean_std_table_width<-length(stdLabels) + length(meanLabels)
# tidy_data_set with means/stds completed

# now for each activity and each subject output the average 
# we will use 'filter' from dplyr
library(dplyr)
# grab a list of the unique Subjectw
uniqueSubject<-unique(mean_std_table$Subject)

# recall activityLabels$label contains list of activity labels

table_index<-1              # we don't end up using this

# This will be the table of subjects by activity and the average of measurements
# we make this a narrow table of the format
# Activity(character label) + the number of the Subject + the label of the feature + the mean of the feature
mean_by_subject_activity<-data.frame(Activity=character(),Subject=numeric(),
                                      Measurement=character(),Mean=numeric())
#
# loop through the activities and the unique Subjects
#
for (i in 1:length(activityLabels$label)) {
  for (j in 1:length(uniqueSubject)){
      thisActivity<-activityLabels$label[i]            # this is the Activity
      thisSubject<-uniqueSubject[j]                    # this is the Subject
                                                       # create a table using filter of all the measurements of this subject create this activity
      tempTable<-filter(mean_std_table,
                        mean_std_table$Subject == thisSubject & mean_std_table$Activities == thisActivity)
  
                          # sometimes a Subject did not conduct an activity
      if (nrow(tempTable)>0) {
       for(k in 1:mean_std_table_width) {
          thisLabel<-names(tempTable)[k+3]            # extract the label of the measurement
          thisMean<-mean(tempTable[[k+3]])            # compute the mean
                                                      # add to the table
          mean_by_subject_activity <-rbind(mean_by_subject_activity,
               data.frame("Activity"= thisActivity, "Subject"= thisSubject, 
                       "Measurement"=thisLabel, "Mean"=thisMean))
          }
       }   
    }
  }
      # and write the table for assignment
write.table(mean_by_subject_activity,"mean_by_subject_activity.txt",row.name=FALSE)

}

