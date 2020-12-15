#  run_analysis.R

library(tidyverse)
library(dplyr)
library(stringr)

d<-"D:/Learn Data Science/Getting-and-Cleaning-Data/UCI HAR Dataset"
setwd(d)

### define activity vector ###
acName <- c("WALKING","WALK_UP","WALK_DN","SITTING","STANDING","LAYING")

####### read features file ###
features <- read.table("features.txt", col.names = c("nos","variables"))

####### read test data files ###
s_test <- read.table("./test/subject_test.txt",col.names = "subjectid")
y_test <- read.table("./test/Y_test.txt",col.names = "activity") %>% 
      mutate(activity = acName[activity])
x_test <- read.table("./test/X_test.txt",col.names = tolower(features$variables)) %>% 
      select(contains("mean") | contains("std"))

###### combine test data files ###
test <- cbind(s_test,y_test,x_test)

####### read train data files ###
s_train <- read.table("./train/subject_train.txt",col.names = "subjectid")
y_train <- read.table("./train/Y_train.txt",col.names = "activity") %>% 
      mutate(activity = acName[activity])
x_train <- read.table("./train/X_train.txt",col.names = tolower(features$variables)) %>% 
      select(contains("mean") | contains("std"))

### combine train data files ###
train <- cbind(s_train,y_train,x_train)

### merge test and train data frames ##
combined <- merge(test,train,all = TRUE)

##### create data set with the average of each variable for each subject andactivity.
tidy <- combined %>% group_by(subjectid,activity) %>% summarize_all(mean)

write.table(tidy,file = "tidy.txt", row.name=FALSE)

