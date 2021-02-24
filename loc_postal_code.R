# this scripts reads pdf files

packages <- c("pdftools", "openxlsx", "testit", "pacman", "stringi")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

#Load packages
library(pacman)
p_load(openxlsx, pdftools, testit, stringi)


#----------GETTING DATA_------------#
#Clear workspace
rm(list = ls())

#Set the directory 
homeDir    <- getwd()
assert("Directory incorrectly set.",grep("/LOC",homeDir) == 1)

#check if the raw files are present
assert("Raw data does not seem to be present. Create RawData folder and save necessary files.", dir.exists(paste(homeDir,"/RawData/", sep = "")) == 1)

#Get the list of letters of comment
fileToRead <- paste(homeDir,'/RawData/','LOCpostalcode.csv', sep = '')
loc        <- read.csv(fileToRead)

#----------Convert to text and extract postal code-------------#
postalcode <- data.frame(matrix(ncol = 1, nrow = 10524))
for (i in 1:10524){
  print(i)
p <- pdf_text(toString(loc[i,2]))[1]

# Using this package templated letters have the postal code between Postal Code:  \r\nFacsimile:
postalcode[i,1] <- gsub(".* Postal Code:(.*) \\r\\nFacsimile.*", "\\1", p)
}

