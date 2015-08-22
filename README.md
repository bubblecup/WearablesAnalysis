# Wearables Analysis
Course project for Coursera's Getting and Cleaning Data

## Repository contents
This repository contains 
* Run Analysis.R: R script file containing all the code needed to generate the tidy data submitted as part of the project deliverable on the course Web site
* Codebook.md: the code book describing the variables contained in the tidy data set
* This readme.md file

## Implementation approach
My approach to tidying the data was, broadly:
* Create the raw data set by combining subject, activity, and all feature variables with `cbind` for both train and test data respectively, and then merge train and test data using `rbind`. 
* Whittle the list of features to those containing the strings `main()` and `std()`, and slightly simplify the naming by dropping the parentheses `()`. I omitted the inertial data for both sets as it did not meet the criteria for containing mean or standard deviation data. 
* Create a new tidy data set with the aggregated mean for each measurement for every subject/activity combination. I did not change the feature names of the features to indicate an aggregated mean, as I thought that would only make the names confusing and unwieldy. (And in any case, the codebook exists to dispel any confusion about the variable's purpose.)


In terms of actual coding, the R script file is pretty verbosely commented, but it's worth noting a few things. I relied on the `diplyr` library to perform much of the analysis. In particular, I found the use of `summarise_each` to be invaluable, and for clarity I relied on the pipe operator `%>%` a lot.


