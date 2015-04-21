
Getting & Cleaning Data - Course Assignment
Code book

This Codebook describes the steps needed to process data from the Human Activity 
Recognition Using Smartphones Dataset as described in the course assignment. The Codebook 
describes the variables, the data and the transformations needed to clean up the data. 

Data was downloaded from the following website: 
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The scripts assume that the file is unzipped into a working directory on the workstation. 
The directory file structure is as follows (workdir is the top most directory for the 
unzipped contents). 
	
	directory structure
		workdir -> 
			datadir -> 		
				activity labels.txt - list of activities -
				features_info.txt - descirbes variables 
				features.txt - list of features 561 x 2
				README.txt - describes data set
				test -> 
					subject.txt - file of subjects - 2947 x 1
					X_test.txt - test set data - - 2947 x 561
					y_test.txt - test labels - 2947 x 1 
					Inertial Signals -> tbd
				train
					subject_train.txt - file of subjects - 7352 x 1
					X_train.txt - training set data 7352 x 561
					y_train.txt - training set labels - 7352 x 1 -
					Inertial Signals -> tbd
	
The README.txt file includes additional information regarding the data set. 
Note the Inertial Signals directories found in the test and train directories are not used
for this exercise as they are not required in the course assignment. 

The objectives for processing the data are: 

    1) Merges the training and the test sets to create one data set.
    2) Extracts only the measurements on the mean and standard deviation for each 
    	measurement. 
    3) Uses descriptive activity names to name the activities in the data set
    4) Appropriately labels the data set with descriptive variable names. 
    5) Creates a second, independent tidy data set with the average variable
       for each activity and each subject.
    6) Writes the data set to a file: mean_by_subject_activity.txt in the current 
       directory(as shown by get_wd) 

Here are the steps required to complete this assignment: 
				
1) Merges the training and the test sets to create one data set.

The script to run is: run_analysis(workdir=<directory where files were unzipped>)
This script assumes the data appears in the original structure

There is initial setup work to set the directory names into variable names for convenience.

Read Activity Labels - The first step is to read the list of activity_labels form the 
activity_labels.txt file. There are six consecutively numbered rows in the file. The 
data is read into a data.frame using read.table function. The names for the data.frame
columns are then set.

Read Features - The next step reads in the features.txt file into a data.frame using 
read.table. There are 561 feature labels in this file. The names for the features data
frame are then set.

Read Test data - Next the subject_test.txt, X_test.txt and y_test.txt files are read. 

*  subject_test.txt is a list of the subjects used to carry out the measurements. 
*  X_test.txt are the activities carried out by the subject. There is one number for each 
feature (so there are 561 per row matching the feature.txt file length)
* y_test.txt file consists of numbers that correspond to the activity labels so 
another data.frame is built out replacing the numbers from y_test with the corresponding
labels from Activity labels.  This new table is called labeled_train_y

A data frame of the test results is then built by column binding:
   test_subject + "TEST" + labeled_train_y (labels associated with y_test) + X_test 
The column names are then set

Read Train data - This step repeats the step for Test data except that "TRAIN" is used in
building out the data frame rather than "TEST

Now there is one data set comprised of the Test and the Train data sets including the
subjects, their activities and the 561 measurements labeled according to features.txt.

phew

2) Extracts only the measurements on the mean and standard deviation for each measurement

To start, we identify the features that include the phrases "mean" and "std" by using
grep to search the names of the table built in step 1. These are extracted into two 
different vectors corresponding to the mean and the std. 

Next the subjects, activities and Test/Train column are copied into a new data.frame. 
The script then column binds first the feature vectors for the mean (using the vectors
in the preceding paragraph). This is repeated for the std feature vectors 

Now there is a new data.frame that includes:
  test_subject + "TEST"/"TRAIN" + Activity Label + Feature data corresponding to mean/std

3) Uses descriptive activity names to name the activities in the data set
In reading the test/train data sets, there is an explicit step to replace the number (found
in y_test.txt) with the corresponding label in the Activity Label file. These remain all
the way through to the last processing step.

4) Appropriately labels the data set with descriptive variable names. 
Throughout this script the columns are named as follows:
  subjects are labled subjects when initially read and this label remains as they are copied
  activity label columns is called "Activities"
  TEST/TRAIN column is called "Test/Train"
  The 561 columns of features data are labeled based on the entires in the features.txt file
  in one to one correspondence. Sadly, there are duplicate column names in this list making
  some processing difficult however since the end result did not rely on these columns, the
  duplicates were ignored (left as is) in the data set.
  
5) Creates a second, independent tidy data set with the average variable  for each activity 
and each subject.  

To build this data set we want to output as follows:

Subject + Activity Labeled + Feature Label + mean of the feature variables corresponding 
												to the Subject & Activity
												
To do this the dplyr library is loaded so we can use the filter command. 
First we know there are six Activities (nrow of activityLabels) and we can use unique to
get the number of subjects (30). Next we run through all six activities and all thirty
(6 x 30) and use filter to extract the record that are for a Subject and an Activity.  
Note there are cases where the Subject did not complete an activity so we check for this. 

Next we go through the list of mean/std columns (also copied over) and calculate the mean. 
With this we have the Subject, Activity Label, Feature Label (name of column) and the 
calculated mean. This is added to a data frame.

To complete this exercise the data frame created in the preceding step is written to a 
file and has been uploaded as part of the submission to this assignment. 
