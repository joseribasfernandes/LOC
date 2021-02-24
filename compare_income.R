# Author: Jose Ribas Fernandes
# Date: Feb 2021
# Goal: This scripts compares incomes for a sample of letters of comment using census 2016 data
# 

packages <- c("openxlsx", "testit", "pacman", "stringi")
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

#Get the list of letters of comment
fileToRead <- paste(homeDir,'/RawData/','LOCpostalcode.csv', sep = '')
loc        <- read.csv(fileToRead)

fileToRead <- paste(homeDir,'/RawData/','income.csv', sep = '')
income     <- read.csv(fileToRead)

#----------Clean data-------------#

#first get only forward sortation area and remove what is not a postal code
loc <- loc[1:320,]
loc$Postal.code <- substr(loc$Postal.code, 0, 3)
loc <- loc[loc$Postal.code!="no ",]
loc <- loc[!is.na(loc$Postal.code),]
loc <- loc[loc$Postal.code!="not",]
loc <- loc[loc$Postal.code!="us",]
loc <- loc[loc$Postal.code!="Hai",]

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

#plot it
hist(prCER, xlab = "Percentiles of income distribution in Canada", ylab = "# of letters", main = "Income percentiles of letters of comment")

#now plot it
#boxplot(CANADAincome,CERincome, horizontal = TRUE, names = c("Canada", "CER"), xlab = "Income per capita ($1000)", main = "Income Distributions Canada and CER")

#different plot
plot(ecdf(prCER), main = "Cumulative distribution of income percentiles for CER's letters", xlab = "Income percentile of Canada", ylab = "Cumulative frequency")
abline(a = 0, b = 1)

#now get a violin plot
# create a giant violin plot
#p <- answers %>%
# #  mutate(text = fct_reorder(text, value)) %>% # Reorder data
#   ggplot( aes(x=text, y=value, fill=text, color=text)) +
#   geom_violin(width=2.1, size=0.2) +
#   scale_fill_viridis(discrete=TRUE) +
#   scale_color_viridis(discrete=TRUE) +
#   theme_ipsum() +
#   theme(legend.position="none") +
#   coord_flip() + # This switch X and Y axis and allows to get the horizontal version
#   xlab("") +
#   ylab("Score")
# 
# p

