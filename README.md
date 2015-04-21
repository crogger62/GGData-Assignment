
Readme.md - Readme file for Coursera/Hopkins Getting and Cleaning Data course assignment

This readme explains how the script run_analysis() can be executed in order to obtain and
clean the data to complete the assignment. 

The assignment details can be found here: 
https://class.coursera.org/getdata-013/human_grading/view/courses/973500/assessments/3/submissions

Prior to running the script, the data for the assignment should be donwnloaded from here:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  
The file should be unzipped to a local directory on the computer. This will result in the 
following directory:
	directory structure
		workdir -> 
			datadir -> 		
				activity labels.txt - list of activities
				features_info.txt - describes variables 
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
				
The workdir\README.txt file describes the data in additional detail. 

To begin cleaning process, execute the script 
	run_analysis(workdir=<topmost directory where the zip file was extracted>)

The following is accomplished: 
    1) Merges the training and the test sets to create one data set.
    2) Extracts only the measurements on the mean and standard deviation for each 
    	measurement. 
    3) Uses descriptive activity names to name the activities in the data set
    4) Appropriately labels the data set with descriptive variable names. 
    5) Creates a second, independent tidy data set with the average variable
       for each activity and each subject.
    6) Writes the data set to a file: mean_by_subject_activity.txt in the current 
       directory(as shown by get_wd) 
       
The mean_by_subject_activity.txt is then uploaded to the course website as part of the
assignment. 

This file can be opened in Excel by opening it as a delimited file using spaces (" ") as
the delimiter.




1