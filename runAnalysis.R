library(dplyr)

runAnalysis <- function()
{
        # Read the data
        data.dirty <- rbind(readData("test"), readData("train")) %>%
                # Extract only the features we want
                extractFeatures %>%
                # Label activities for each observation
                left_join(getActivityLabels(), by="Activity") %>%
                # Remove Activity column containing the activity ID
                select(-Activity) %>% 
                # Reorder/rename columns
                select(Subject, Activity=Description, everything())
        # Create tidy data: the means of each measurement for each subject/activity combo
        data.tidy <- data.dirty %>% group_by(Subject, Activity) %>% summarise_each("mean")
        # Write to file
        write.table(data.tidy, file="data.tidy.txt", row.names=FALSE)
        invisible(data.tidy)
}

# Reads in either test or train data, assumed to be in working directory
readData <- function(subsetType="test")
{
        cbind(read.table(file.path(subsetType, paste("subject_",subsetType,".txt",sep="")),
                         col.names="Subject", stringsAsFactors=FALSE),
              read.table(file.path(subsetType, paste("y_",subsetType,".txt",sep="")), 
                         col.names="Activity", stringsAsFactors=FALSE),
              read.table(file.path(subsetType, paste("x_",subsetType,".txt",sep=""))))
}

# Extracts features corresponding to mean and std deviation measurements only
extractFeatures <- function(df)
{
        # Read in all features
        features <- read.table("features.txt", col.names=c("Feature", "Description"), 
                               stringsAsFactors=FALSE) %>% 
                # Filter out all that are not std deviation or mean
                filter(grepl("std()|mean()", Description))
        # Select only the features we want from df
        df <- select(df, 1:2, num_range("V",features[["Feature"]]))
        # Label the measurement variables from their description in the file
        names(df)[3:ncol(df)] <- sapply(features[["Description"]], 
                                        # Remove parentheses from feature descriptions
                                        function(x) gsub("()", "", x, fixed=TRUE))
        df
}

getActivityLabels <- function()
{
        read.table("activity_labels.txt", col.name=c("Activity","Description"),
                   stringsAsFactors=FALSE)
}

