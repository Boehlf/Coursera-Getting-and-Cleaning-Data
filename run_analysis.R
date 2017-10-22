#############################################################################################
##
## The downloaded zip is renamed to phone.zip and upacked in the working directory
## The set contains contains observations of 30 subjectsm nummered 1 to 30, each
## doing 6 different activieties. 
## Each of these activities is measured a (irregular) number of times (e.g. subject 5
## is measured 52 times lying down and 56 times standing,
## whereas subject 1 is observed 53 times standing and 50 times laying)
## 
## The observations are divided over two datasets each stored in two folder trees starting 
## at \\train and \\test. Each dataset consists of multiple files and subfolders.
##
## We have subjects (subject_test.txt and subject_train.txt), a list of the activities (y_test and y_train)
## and the observations, X_train.txt and X_test.txt. Each of the three files has the same number of rows,
## so it is assumed that they can be fit together.
##
## The translations for the activity_codes can be found in the file activity.txt
##
## With regards to the observation files, each of these has been the result of specific observations
## per different types of measurement. Deeper in the folder tree of the datasets test and train are
## the files per type of activity. We leave those files and work under the assumption 
## that X_train.txt and Y_train.txt have been correctly constructed from the subsets. 
## The names for the columns of the observations can be found in a folder above \test and \train
## and is called features.txt.
##
##
## Strategy
##
## 0. Set the working directory to that of the folder in which the R-script is located.
##    and load the dplyr package (working under the assumption that this package allready 
##    has been downloaded).
## 1. Load in the the files of the datasets from \test and \train as well as the file containing
##    the column headers, features.txt and the activities, activities.txt
## 2. Than we add the column names to the obeservations
## 3. Piece each of the datasets together in two dataframes, resp. test and train, each whith there activities 
##    and subjects.
## 4. Filter out the column names we need and change the dataframes accordingly
## 5. Add the two dataframes together (simply join them with a rowbind, they contain the same
##    number of columns but a different  sub-set of the 30 subjects) in a dataframe called 
##    total.
## 6. Add te activity names from activity.txt by merging with the dataframe total over the activity code.
## 7. Do some optical re-arrangements to the dataframe total, so that if you view it,
##    the subject- and activity-column is displayed first.
## 8. Create a new dataframe called total_av based on total, by grouping by resp. the columns
##    subject and activity and for each group of these two combined keys we take the average
##    of the other columns.
## 9. clean up all variables we used to create the two dataframes.
##
######################

### 0. Set the working directory to that of the folder in which the R-script is located.

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)

#### 1. Reading in the files from the datasets test and train
# First load in the observations from the test dataset in a dataframe test
test<- read.table(".\\phone\\UCI HAR Dataset\\test\\X_test.txt")

# Then we read in the subjects from the test dataset 
subject_test<- scan(".\\phone\\UCI HAR Dataset\\test\\subject_test.txt")

# Next we read in the activities
test_activity<-scan(".\\phone\\UCI HAR Dataset\\test\\y_test.txt")

# Next we do the same for the train data except for the column names, as that is the same file
train<- read.table(".\\phone\\UCI HAR Dataset\\train\\X_train.txt")
subject_train<- scan(".\\phone\\UCI HAR Dataset\\train\\subject_train.txt")
train_activity<-scan(".\\phone\\UCI HAR Dataset\\train\\y_train.txt")

# Then we read in the column names
header<-read.table(".\\phone\\UCI HAR Dataset\\features.txt")

# And finally the activities.
activity<- read.table(".\\phone\\UCI HAR Dataset\\activity_labels.txt")


## 2. Next we add the column_names from the vector 'labels' to the two dataframes
names(train)<- header$V2
names(test)<-header$V2

## 3. Next we'll add two column 'activity' and 'subject' to both dataframes 'train' and 'test', 
## coming from the files we scaned in 
train$activity<-train_activity
train$subject<-subject_train
test$activity<-test_activity
test$subject<-subject_test


## 4. Next we create a vector with all columns contain either "mean" or "std" and conncatenate these 
# into one vector. We use the dataframe test for this (though we could also have used train).
# As we've added the columns subject and activity, both not containing the search-string
# "std" or "mean" we need to add thos columns manually to the vector with the columns we want to keep.
tmpcol1<-grep("std", names(test),ignore.case = TRUE )
tmpcol2<-grep("mean", names(test),ignore.case = TRUE )
tmpcol=c(tmpcol1, tmpcol2)


col_selection<-names(test)[tmpcol]
tmpcol <- c( "subject","activity", col_selection)

# After which we remove the columns not containing a reference to "std" or "mean"
test1<-test[tmpcol]
train1<- train[tmpcol]

## 5. Next we append/merge the two dataframes 'train' and 'test'
total<-rbind(test1,train1)
#total <-merge(test1,train1, by.x="subject", by.y="subject")


# Next we'll add the activity_codes in de dataframe total with the corresponding values
# from the activity dataframe.
total<-merge(total,activity, by.x = "activity", by.y = "V1")


##########

total$activity <- NULL
colnames(total)[colnames(total) == 'V2'] <- 'activity'

# For readability purposes, we drop the column activity and rename V2 to activity and 
# reorder the columns so that subject and activity are next to one another.
total<-total[ ,c(1,88, 2:87)]
total<-arrange(total,subject)


# Next we create a second data frame, called total_av, derived from total 
# by ordering on subject and activity and taking the mean of all other columns

total_av <- total %>% group_by(subject, activity) %>% summarise_all(funs(mean))

# Clean up the obsolete objects
rm(activity)
remove(header)
rm(test)
rm(test1)
rm(train)
rm(train1)
rm(col_selection)
rm(test_activity)
rm(train_activity)
rm(subject_train)
rm(subject_test)
rm(tmpcol)
rm(tmpcol1)
rm(tmpcol2)