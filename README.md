# Coursera-Getting-and-Cleaning-Data
This Repository contains the asssignment of the Coursera R-training named 'Getting and Cleaning Data with R'

The assignment was to create a script that tidies a dataset. 
For a description of the dataset and its variables, check out
the file codebook.md.

This file describes what the script does.


======== Transformations of the R script tidy.R =========================================================
The script 
1. Takes the the obeservations of the two subsets "train" and "test".
2. Adds the column names to the observations
3. Adds per row in the subsets "train" and "test"the subjects and activity codes
4. Removes all columns from the two subsets "train" and "test"which do not contain the strings
   "std" or "mean", except for the newly attached columns "subject" and "activity".
5. Adds the two subsets "train" and "test"together into one dataframe "total".
6. Replaces the activity codes with the activity names.
7. Reorganize dataframe "total" so that the columns "subject" and "activity" come first and have the data grouped 
   by these two columns.
7. Based on the dataframe "total" a second dataframe "total_av" is created which takes the mean of all observations 
   per subject per activity


======== How to use the R script =========================================================

1. Download the raw data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Rename the zip-file "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" to phone.zip.
3. Unzip the file
3. Copy the R-script tidy.R to the folder above the folder "\phone".
4. Make sure you have downloaded the dplyr-package
5. Open the script in R-Studio and source it.

