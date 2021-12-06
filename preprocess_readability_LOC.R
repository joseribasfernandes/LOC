# Author: Jose Ribas Fernandes
# Date: Dec 2021
# Goal: This scripts extracts readility scores for each letter

preprocess_readability_LOC <- function()
  

postalcode <- data.frame(matrix(ncol = 1, nrow = 10524))
for (i in 1:10524){
  print(i)
  p <- pdf_text(toString(loc[i,2]))[1]
  
  # Using this package templated letters have the postal code between Postal Code:  \r\nFacsimile:
  postalcode[i,1] <- gsub(".* Postal Code:(.*) \\r\\nFacsimile.*", "\\1", p)
}
