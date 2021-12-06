# Author: Jose Ribas Fernandes
# Date: Feb 2021
# Goal: This scripts compares distribution for CER with distribution for canada in income, years education, and other dimensions, for a sample of letters of comment using census 2016 data. 
# Approach: Take Forward Sortation Areas (first three letters of postal code) for letters of comment, get the income per capita (Total income/population) and compare
# it with all forward sortation areas
# 

packages <- c("openxlsx", "testit", "pacman", "stringi", "pdftools")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

#Load packages
library(pacman)
p_load(openxlsx, testit, stringi)


#----------GETTING DATA_------------#
#Clear workspace
rm(list = ls())

#Set the directory 
homeDir    <- getwd()
assert("Directory incorrectly set.",grep("/LOC",homeDir) == 1)

#check if the raw files are present
assert("Raw data does not seem to be present. Create RawData folder and save necessary files.", dir.exists(paste(homeDir,"/RawData/", sep = "")) == 1)

#check if the processed files are present
processed <- file.exists(paste(homeDir,"/ProcessedData/","prCER_income.csv", sep = ""))

if (processed==FALSE){
#--------Income Analysis----------#
  source("preprocess_income_LOC.R")
} else {
    dataFile   <- 'prCER_income.csv' 
    fileToRead <- paste(homeDir,'/ProcessedData/',dataFile, sep = '')
    prCER_income  <- read.csv(fileToRead)
    prCER_income  <- prCER_income$x 
}
#----------Readability analysis-------------#
#check if the processed files are present
processed <- file.exists(paste(homeDir,"/ProcessedData/","prCER_readability.csv", sep = ""))

if (processed==FALSE){
  source("preprocess_readability_LOC.R")
} else {
  dataFile   <- 'prCER_readability.csv' 
  fileToRead <- paste(homeDir,'/ProcessedData/',dataFile, sep = '')
  prCER_readability   <- read.csv(fileToRead)
  prCER_readability   <- prCER$x 
}


#plot it
hist(prCER, xlab = "Percentiles of income distribution in Canada", ylab = "# of letters", main = "Income percentiles of letters of comment")

#now plot it. Commenting because this figure takes a while to load.
boxplot(CANADAincome,CERincome, horizontal = TRUE, names = c("Canada", "CER"), xlab = "Income per capita ($1000)", main = "Income Distributions Canada and CER")

#Plot Lorenz curve for income
plot(ecdf(prCER), main = "Cumulative distribution of income percentiles for CER's letters", xlab = "Income percentile of Canada", ylab = "Cumulative frequency")
abline(a = 0, b = 1)


