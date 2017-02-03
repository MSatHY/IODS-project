# Markus Selin; 3.2.2017; OpenDataScience course, RStudio Exercise 2, part "data wrangling" 

# Installing the R packages needed for the code to work:
install.packages("pacman")
library(pacman)
p_load(dplyr)

# Reading the data table:
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Examining the table:
str(lrn14)
dim(lrn14)

# Commenting the results:
# Table contains values of 60 variables from 183 cases.
# 59 variables get integer values.
# One variable (gender) is either 1 ("F") or 2 ("M").

# Next: 
# Create an analysis dataset with the variables 
# gender, age, attitude, deep, stra, surf and points 
# by combining questions in the learning2014 data

# 1. producing variables deep, surf and stra (deep, surface and strategic learning)

# 1.1 Select the columns related to deep learning and create column 'deep' by averaging
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# 1.2 select the columns related to surface learning and create column 'surf' by averaging
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# 1.3 select the columns related to strategic learning and create column 'stra' by averaging
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# 2. Creating dataset (data.frame) "analysis" 

# 2.1 Selecting the data for further analysis:
analysis_questions <- c( "gender", "Age" , "Attitude", "deep", "stra", "surf" , "Points")
analysis <- select(lrn14, one_of(analysis_questions))

# 2.2 Selecting rows where "Points" is greater than zero
analysis <- filter(analysis, Points > 0)

# Examining the new (analysis) dataset:
str(analysis)
dim(analysis)

# 2.3 Renaming variables (as requested in the excercise):
colnames(analysis)[2] <- "age"
colnames(analysis)[3] <- "attitude"
colnames(analysis)[7] <- "points"
 
# Examining the new (analysis) dataset:
str(analysis)
dim(analysis)

# 3. Writing the table and checking the readability

# 3.1 Writing
write.table(analysis, file = "learning2014.txt", append = F, quote = F, sep="\t")

# 3.2 Checking readability
reading_test <- read.table("learning2014.txt", sep="\t", header=TRUE)
str(reading_test)
head(reading_test)
