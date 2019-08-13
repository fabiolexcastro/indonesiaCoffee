
# Load libraries ----------------------------------------------------------
require(tabulizer)
require(tidyverse)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------
pdf <- '../pdf/Kopi-Split.pdf'
out <- extract_tables(pdf)

# Processin each dataframe ------------------------------------------------
df1 <- as.data.frame(out[[1]])
df1 <- df1[5:nrow(df1),]
write.csv(df1, '../tbl/df1.csv', row.names = FALSE)

df2 <- as.data.frame(out[[16]])
df2 <- df2[5:nrow(df2),]
write.csv(df2, '../tbl/df2.csv', row.names = FALSE)

# Arabica
pd1 <- '../pdf/arabica1.pdf'
out <- extract_tables(pd1)
df1 <- as.data.frame(out[[1]])
df1 <- df1[5:nrow(df1),]
write.csv(df1, '../tbl/arabica1.csv', row.names = FALSE)

myFunction <- function(pth){
  pd1 <- pth
  out <- extract_tables(pd1)
  df1 <- as.data.frame(out[[1]])
  df1 <- df1[5:nrow(df1),]
  write.csv(df1, paste0('../tbl/', gsub('.pdf', '', basename(pth)), '.csv'), row.names = FALSE)
}

myFunction(pth = '../pdf/arabica1.pdf')
myFunction(pth = '../pdf/arabica2.pdf')
myFunction(pth = '../pdf/arabica3.pdf')

myFunction(pth = '../pdf/robusta1.pdf')
myFunction(pth = '../pdf/robusta2.pdf')
myFunction(pth = '../pdf/robusta3.pdf')



