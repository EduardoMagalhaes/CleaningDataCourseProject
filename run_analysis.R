## Getting and Clenaning Data Course Project
##
## run_analysis.R
##
## by Eduardo Magalhaes Barbosa
##
## Please, for aditional information see readme.md and CoodBook 
## at https://github.com/EduardoMagalhaes/CleaningDataCourseProject.git


## This script does the following:

## 1 - Merges the training and the test sets to create one data set.
## 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3 - Uses descriptive activity names to name the activities in the data set
## 4 - Appropriately labels the data set with descriptive variable names. 
## 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#########################################################################################
## STEP 1                                                                              ##
## Merges the training and the test sets to create one data set.                       ##
#########################################################################################

## Load the DataFrames using read.table(). Notice the activity_labels were loaded without using string as factors

activity_labels <- read.table("../UCIHARDataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)
features <- read.table("../UCIHARDataset/features.txt", quote="\"")
X_test <- read.table("../UCIHARDataset/test/X_test.txt", quote="\"")
X_train <- read.table("../UCIHARDataset/train/X_train.txt", quote="\"")
subject_test <- read.table("../UCIHARDataset/test/subject_test.txt", quote="\"")
subject_train <- read.table("../UCIHARDataset/train/subject_train.txt", quote="\"")
y_test <- read.table("../UCIHARDataset/test/y_test.txt", quote="\"")
y_train <- read.table("../UCIHARDataset/train/y_train.txt", quote="\"")

## Give meaningfull name to the collumns on each DataFrame. This will also help tiying the DataFrames alltogether later on.

colnames(activity_labels) <- c("ActivityCode", "ActivityName")
colnames(features) <- c("featurescode", "featuresname")
colnames(X_test) <- features$featuresname
colnames(X_train) <- features$featuresname
colnames(subject_test) <- c("SubjectID")
colnames(subject_train) <- c("SubjectID")
colnames(y_test) <- c("ActivityCode")
colnames(y_train) <- c("ActivityCode")


## Include Subject and Activy Code on both Test and Train Datasets

X_train$SubjectID <- subject_train$SubjectID    ## Include Subject ID into X_Train
X_test$SubjectID <- subject_test$SubjectID  ## Include Subject ID into X_Test

X_test$ActivityCode <- y_test$ActivityCode ## Include activity code into X_Test
X_train$ActivityCode <- y_train$ActivityCode  ## Include activity code ID into X_Train

## Combine X_test and X_train into a single DataFrame X_table

X_table <- rbind(X_test, X_train)

#########################################################################################
## STEP 2                                                                              ##
## Extracts only the measurements on the mean and standard dev for each measurement    ##
#########################################################################################

## Look for collumn names and identify those with "std", "mean", "Mean", "ActivityCode" and "SubjectID"

CollumnsToKeep <- c(grep("*std*", names(X_table)),grep("*Mean*", names(X_table)),grep("*mean*", names(X_table)),grep("ActivityCode", names(X_table)),grep("SubjectID", names(X_table)))

## Rebuild the X_table DataFrame, keeping only selected collums

X_table <- X_table[,CollumnsToKeep]    


#########################################################################################
## STEP 3                                                                              ##
## Uses descriptive activity names to name the activities in the data set              ##
#########################################################################################

## 3 -  We want to replace the Activity Codes by the Activy Names Uses descriptive activity names to name the activities in the data set

for (i in 1:nrow(activity_labels))      {  # We´ll do a loop on all of 6 Acitvities codes
    
  X_table$ActivityCode[X_table$ActivityCode==i] <- activity_labels$ActivityName[i]  # and replace all AcitivyCodes that match the loop with ActiviyNames
  
}

#########################################################################################
## STEP 4                                                                              ##
## Appropriately labels the data set with descriptive variable names                   ##
#########################################################################################

for (i in 1:length(names(X_table))){   ## Walkthru all collumn names on our DataFrame
  
  CleanNames = c(0)    # Local temp variable to store cleaned name
  CleanNames <-  gsub("-|\\()", "", names(X_table[i]))        # Clean "-|\\()" from variables
  CleanNames <-  gsub("^t","Time",CleanNames)                 # Replace starting t with Time
  CleanNames <-  gsub("\\(","",CleanNames)                    # Clean "(" from variables
  CleanNames <-  gsub("\\)","",CleanNames)                    # Clean ")" from variables
  CleanNames <-  gsub("^f","Frequency",CleanNames)            # Replace starting f with Frequency
  CleanNames <-  gsub("Acc","Acceleration",CleanNames)        # Replace Acc with Acceleration
  CleanNames <-  gsub("std","StandardDeviation",CleanNames)   # Replace std with StandardDeviation 
  CleanNames <-  gsub("mean","Mean",CleanNames)               # Replace neam with Mean
  CleanNames <-  gsub("^a","A",CleanNames)                    # Replace starting a with A
  CleanNames <-  gsub(",g","G",CleanNames)                    # Replace starting g with G
  
  colnames(X_table)[i] <- CleanNames # assign cleaned name to the variable
  
}

#########################################################################################
## STEP 5                                                                              ##
## Creates a second, independent tidy data set with the average of each variable for   ##
## each activity and each subject.                                                     ##
#########################################################################################

## We´ll using reshaping data functions melt and dcast 
##Each variable forms a column
##Each observation forms a row
##Each table/file stores data about one kind of observation (e.g. people/hospitals).

## First we´ll melt the X_table taking SubjectID and ActivityCode as fixed ID Variables and all other collumns 
## from X_table (collumns 1 to 86) will be measurement variables
DLAMelt <- melt(X_table,id=c("SubjectID","ActivityCode"),measure.vars=colnames(X_table[1:86]))

## Them we´ll use dcast function with SubjectID + ActivityCode as fixed ids and calc the mean of all variables
TidyDLA <- dcast(DLAMelt, SubjectID + ActivityCode ~ variable, mean)

## Last thing to do is to save the tidy dataframe to the disk, same directory of source data.

write.table(TidyDLA, "../UCIHARDataset/TidyDLA.txt", sep="\t", row.name=FALSE)

## Script Ends
 
