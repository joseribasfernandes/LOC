# Author: Jose Ribas Fernandes
# Date: Dec 2021
# Goal: This scripts compares incomes for a sample of letters of comment using census 2016 data. 
# Approach: Take Forward Sortation Areas (first three letters of postal code) for letters of comment, get the income per capita (Total income/population) and compare
# it with all forward sortation areas

preprocess_income_LOC <- function() 

#Clear workspace
rm(list = ls())

#Set the directory 
homeDir    <- getwd()
assert("Directory incorrectly set.",grep("/LOC",homeDir) == 1)


#Get the list of letters of comment
dataFile   <- 'LoC-with-Dates-ORIGINAL.csv' 
fileToRead <- paste(homeDir,'/RawData/',dataFile, sep = '')
loc        <- read.csv(fileToRead)

fileToRead <- paste(homeDir,'/RawData/','income.csv', sep = '')
income     <- read.csv(fileToRead)

#----------Clean data-------------#

#first get only forward sortation area and remove what is not a postal code
loc$Postal.code <- substr(loc$Postal.code, 0, 3)
loc <- loc[loc$Include=="Y",]


#get CER income
CERincome <- income$Income.per.capita[match(loc$Postal.code, income$FSA)]
CERincome <- CERincome[!is.na(CERincome)]
CERincome[- grep("DIV", CERincome)]
CERincome <- as.double(as.character(CERincome))/1000

#now get income distribution for all of Canada
df2 <- income[rep(seq_along(income$Total), income$Total), ]
CANADAincome <- as.double(as.character(df2$Income.per.capita))/1000

# get percentile rank
perc.rank <- function(x) trunc(rank(x))/length(x)
pr <- perc.rank(CANADAincome)
prCER <- pr[match(CERincome, CANADAincome)]

fileName <- paste(homeDir,"/ProcessedData/", "prCER_income.csv",sep = "")
write.csv(x = prCER,file = fileName, row.names = FALSE)

