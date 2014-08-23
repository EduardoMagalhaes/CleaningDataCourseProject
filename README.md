## Cleaning Data Course Project

Coursera Getting and Cleaning Data Course Project 

by Eduardo Magalhaes Barbosa

### Deliverables:

1. A tidy data set as described below (**TidyDLA**)
1. A link to a Github repository with your script for performing the analysis
1. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
1. A README.md (this fie) in the repo with scripts. This repo explains how all of the scripts work and how they are connected.  

Following Project Course forum discussions, I put the high level description of processes, general data description in the readme.md file (this file) and details of variables, definition, range, type, etc at the Code Book.


### Process to Create a Tidy Dataset for DLA (Daily Living Activities)

An R script called run_analysis.R was created  and it does the following:
 
1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 
1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Now let´s get a deeper look into each one of those steps.

#####STEP 1
Merges the training and the test sets to create one data set.
Load the DataFrames using read.table(). Notice the activity_labels were loaded without using string as factors and we considered the "../UCIHARDataset" as the source directory.

Give meaningfull name to the collumns on each DataFrame. This will also help tiying the DataFrames alltogether later on.

The X_test and X_Team collumn names are given by the content of Feaxtures.txt dataset


Include Subject and Activy Code on both Test and Train Datasets


Combine X_test and X_train into a single DataFrame X_table

#####STEP 2
Extracts only the measurements on the mean and standard dev for each measurement    

Look for collumn names and identify those with "std", "mean", "Mean", "ActivityCode" and "SubjectID"


Rebuild the X_table DataFrame, keeping only selected collums

#####STEP 3
Uses descriptive activity names to name the activities in the data set

We want to replace the Activity Codes by the Activy Names Uses descriptive activity names to name the activities in the data set

#####STEP 4
Appropriately labels the data set with descriptive variable names. The original names are just too complex to undertand and doesn´t follow variables names guidelines, so we clened then as below:

- Clean "-|\\()" from variables
- Replace starting t with Time
- Clean "(" from variables
- Clean ")" from variables
- Replace starting f with Frequency
- Replace Acc with Acceleration
- Replace std with StandardDeviation 
- Replace neam with Mean
- Replace starting a with A
- Replace starting g with G

#####STEP 5
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

It was accomplish using reshaping data functions melt and dcast in order to meet tidy dataset requirements:
 
1. Each variable forms a column
1. Each observation forms a row
1. Each table/file stores data about one kind of observation (e.g. people/hospitals).
 
First  melt the X_table taking SubjectID and ActivityCode as fixed ID Variables and all other collumns 
from X_table (collumns 1 to 86) will be measurement variables
Them we´ll use dcast function with SubjectID + ActivityCode as fixed ids and calc the mean of all variables

Last thing to do is to save the tidy dataframe to the disk, same directory of source data.

Script Ends

