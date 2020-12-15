##############
CodeBook
##############


The script is divided into five (5) major sections;
1. Initialization of environment, variables and vectors 
2. read and transforms the "test" data sets that crates test data frame
3. read and transforms the "training" data sets that creates train data frame
4. merge the transformed test and training data sets into tidy data frame
5. write the tidy data frame into tidy.txt file

First we download and extract into the drive the zip file from the link 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Then in R studio, the working directory was set to the root of the data set which is 
"UCI HAR Dataset" where test and train are sub directories.

      setwd(".../UCI HAR Dataset")
      
The following libraries were also loaded:
      tidyverse
      dplyr
      stringr
      
The original data set use activitity codes 1 to 6 that corresponds to 
      activities;
      1 - WALKING
      2 - WALKING UP
      3 - WALKING DOWN
      4 - SITTING
      5 - STANDING
      6 - LAYING
so, in our script we created a vector "acName" that maps each activity codes index 
to its literals which will be use later to replace the activity codes,

      acName <- c("WALKING","WALK_UP","WALK_DN","SITTING","STANDING","LAYING")

The 561 variables were identified in the file "features.txt" and described in 
"features_info.txt". The script reads the features.txt into the features data frame 
to define the column variables of the merged data set.

      features <- read.table("features.txt", col.names = c("nos","variables"))

After, seting up the activity verctor and features vector, at this point the script 
reads the corresponding test data sets;

subjects data sets is the subject Id codes where the 2947 rows of observation was taken;

      s_test <- read.table("./test/subject_test.txt",col.names = "subjectid")

the activity codes were read into y_test the using piping the script transforms the 
activity codes into its literal using mutate function and previously defined 
activity vector acName.

      y_test <- read.table("./test/Y_test.txt",col.names = "activity") %>% 
      mutate(activity = acName[activity])

then finally the test observation was read into x_test data frame while defining 
the column names as the defined in features vector piping into selecting the 
variables mean and standard deviation.

      x_test <- read.table("./test/X_test.txt",col.names = tolower(features$variables)) %>% 
      select(contains("mean") | contains("std"))

then test subject, activity and observations data sets were combined into one single 
test data frame;

      test <- cbind(s_test,y_test,x_test)
      
Then, similarly the train data sets were read following the same transformation as the 
test data sets;

      ####### read train data files ###
      s_train <- read.table("./train/subject_train.txt",col.names = "subjectid")
      y_train <- read.table("./train/Y_train.txt",col.names = "activity") %>% 
            mutate(activity = acName[activity])
      x_train <- read.table("./train/X_train.txt",col.names = tolower(features$variables)) %>% 
            select(contains("mean") | contains("std"))

      ### combine train data files ###
      train <- cbind(s_train,y_train,x_train)

To create one big data frame the script merge the test and train data sets then
compute the average for all columns for each subject on each activity.

      combined <- merge(test,train,all = TRUE)
      
      tidy <- combined %>% group_by(subjectid,activity) %>% summarize_all(mean)

then finally write the tidy data frame into a text file.

      write.table(tidy,file = "tidy.txt", row.name=FALSE)


      