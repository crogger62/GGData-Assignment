# GGData-Assignment

This will be my readme file
This one right here

1) Merges the training and the test sets to create one data set.
run_analysis (workdir)
	workdir is thd directory 
	
	tables:
	activityLabels - 6 rows x 2 columns
	featuresTable - 561 rows x 2
	
	
	directory structure
		workdir -> 
			datadir -> 		
				activity labels.txt - list of activities - 6 x 2
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
				
				
Rows represent a measurement - 7352+2947 = 10,299 rows
Columns consist of:
1) Subject  - the number of the subject who performed the activity
2) Label indicating if it is "TEST" or "TRAIN" depending on which data set it was pulled from
3) Y Measure - 1 of these - read in as numbers and used lookup in activity_labels 
4) X Measures - 561 of these

a rows consists of 
subject + "TEST/TRAIN" + y_test + x_test variables 
num + text lable + num + num(x561)

tidy_test_table is test_subjects + test_y + test_X
tidy_train_table is train_subjects + test_y + test_X


2) Extracts only the measurements on the mean and standard deviation for each measurement.

mean - 46 measurements in table
std - 33 measurements in table

Problems with duplicate column names and select:
	http://stackoverflow.com/questions/28549045/dplyr-select-error-found-duplicated-column-name

 
extract_Data <- select(.data = master_merge, subjectID, activity_ID,
                           contains("mean\\(\\)"), contains("std\\(\\)"))
    duplicates: your_merged_data_with_column_names[,400:420]


Maybe an answer to a different question: 
Before you assign the column names filter out the columns by getting a list of indices using
	meanStdColumns <- grep("mean|std", features$V2, value = FALSE)
and then assign the columns names using
	meanStdColumnsNames <- grep("mean|std", features$V2, value = TRUE)

Threads:
http://stackoverflow.com/questions/10689055/create-an-empty-data-frame
             http://stackoverflow.com/questions/10150579/adding-a-column-to-a-data-frame
             http://stackoverflow.com/questions/28549045/dplyr-select-error-found-duplicated-column-name
                   
                           
Wide vs narrow


4) 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

