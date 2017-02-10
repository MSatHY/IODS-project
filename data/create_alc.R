# Markus Selin; 10.2.2017; Script for Rstudio Excericise 3 part "Data wrangling" (for combining data found from https://archive.ics.uci.edu/ml/machine-learning-databases/00356/) 

# loading libraries
library(dplyr)

# reading the data files
setwd("C:\\Users\\Markus\\Documents\\OpenDataScience\\IODS-project\\data")
math <- read.csv("student-mat.csv", sep = ";" , header=TRUE)
por <- read.csv("student-por.csv", sep = ";" , header=TRUE)

# Exploring data
str(math)      # factors and integers
dim(math)      # 395 students and 33 variables
str(por)      # factors and integers
dim(por)      # 649 students and 33 variables


# Joining data (inner_join = keep only students present in both datasets)
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".mat",".por"))

# Exploring the joined data
colnames(math_por) # suffixes work as they should
str(math_por)      # factors and integers
dim(math_por)      # 382 students and 53 variables

# ----------------------------------------------------------------------
# START: DUBLICATED FROM DATA CAMP "2. Logistic regression - The if-else structure"
# ----------------------------------------------------------------------

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

# ----------------------------------------------------------------------
# END: DUBLICATED FROM DATA CAMP "2. Logistic regression - The if-else structure"
# ----------------------------------------------------------------------

# Combining alcohol use and making a logical variable for high use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

# Check-up
glimpse(alc) # seems to work
dim(alc)     # 382 obsevations from 35 variables

# 3.1 Writing
write.table(alc, file = "student_alc.txt", append = F, quote = F, sep="\t")

# 3.2 Checking readability
reading_test <- read.table("student_alc.txt", sep="\t", header=TRUE)
str(reading_test)
head(reading_test)
glimpse(reading_test)
dim(reading_test)
