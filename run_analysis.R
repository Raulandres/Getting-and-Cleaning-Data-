install.packages("data.table")
library(data.table)
install.packages("reshape2")
library(reshape2)

##################################
#READ THE TEST  AND TRAINING FILE#    
##################################

# Test file
X_test <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/test/X_test.txt", quote="\"")
Y_test <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/test/Y_test.txt", quote="\"")
subject_test <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/test/subject_test.txt", quote="\"")
test_data <- cbind(as.data.table(subject_test), Y_test, X_test)

# Train file
X_train <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/train/X_train.txt", quote="\"")
Y_train <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/train/Y_train.txt", quote="\"")
subject_train <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/train/subject_train.txt", quote="\"")
train_data <- cbind(as.data.table(subject_train), Y_train, X_train)

# Read the measures date
features <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/features.txt", quote="\"")
measures_features <- grepl("mean|std",features[,2])
table(measures_features)

#Read the activity labels 
activity_labels <- read.table("~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/UCI HAR Dataset/activity_labels.txt", quote="\"")
activity <- activity_labels[,2]


#########################################
#data names and filter measures X files #
#########################################

#test data
names(X_test) = features[,2]
X_test = X_test[,measures_features]

#test train
names(X_train) = features[,2]
X_train = X_train[,measures_features]


#################################
##merge activity in Y files    ##
#################################

# Test file
Y_test[,2] = activity[Y_test[,1]]
names(Y_test) = c("ID_ACT", "ACT")

# train file
Y_train[,2] = activity[Y_train[,1]]
names(Y_train) = c("ID_ACT", "ACT")

##########################
### name subject files ###
##########################

# Test file
names(subject_test) = "subject"

# Train file 
names(subject_train) = "subject"


##################
### merge data ###
##################

test_data <-  cbind(as.data.table(subject_test),Y_test, X_test)
train_data <- cbind(as.data.table(subject_train),Y_train,X_train)

##################
### total data ###
##################

total_data = rbind(test_data, train_data)
labels   = c("subject", "ID_ACT", "ACT")
data_labels = setdiff(colnames(total_data),labels)
melt_data      = melt(total_data, id =labels, measure.vars = data_labels)

##################################################################
### Calculate mean and creates a second, independent tidy data ###
##################################################################

tidy_data   = dcast(melt_data, subject + ACT ~ variable, mean)

write.table(tidy_data, file = "~/COURSERA/CLEAN_ANALISIS/SEMANA_4/BASE/tidy_data.txt",row.name=FALSE)



