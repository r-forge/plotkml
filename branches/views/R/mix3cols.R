# R function for the plotKML package
# Author: Tomislav Hengl
# contact: tom.hengl@wur.nl
# Date : July 2011
# Version 0.1
# Licence GPL v3

mix3cols <- function(
  color1, 
  color2, 
  color3, 
  break1 = 1/2, 
  no.col = 47
  ){
  # Dependencies
  require(colorspace)
  if(break1 <= 0 | break1 >= 1) {
  stop('break1 must be in the (0--1) range')
  }
  else {
  # round the breaks:
  no.col1 <- round(break1*no.col, 0)
  if(no.col1==0) {no.col1 <- no.col1+1}
  no.col2 <- round((1-break1)*no.col, 0)
  if(no.col2==no.col) {no.col2 <- no.col2-1}  
  col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
  col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
  mixedcol <- c(col1_2, col2_3)
  return(mixedcol)
  }
}
