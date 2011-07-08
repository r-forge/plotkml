# R function for the plotKML package
# Author: Tomislav Hengl
# contact: tom.hengl@wur.nl
# Date : July 2011
# Version 0.1
# Licence GPL v3

mix5cols <- function(
  color1, 
  color2, 
  color3, 
  color4, 
  color5, 
  break1 = 1/4, 
  break2 = 2/4, 
  break3 = 3/4, 
  no.col = 47
  ){
  # Dependencies
  require(colorspace)
  if(break1 <= 0 | break1 >= 1 | break2 <= 0 | break2 >= 1 | break3 <= 0 | break3 >= 1 | break2 > break3 | break1 > break2) {
  stop('breaks must be in the (0--1) range; break3 must be > break2 > break1')
  }
  else {
  # Mixes three RGB colors into a pallette
  no.col1 <- round(break1*no.col, 0)
  if(no.col1==0) {no.col1 <- no.col1+1}
  no.col2 <- round((break2-break1)*no.col, 0)
  if(no.col2==no.col1) {no.col2 <- no.col2+1}
  no.col3 <- round((break3-break2)*no.col, 0)
  if(no.col3==no.col2) {no.col3 <- no.col3+1}
  no.col4 <- round((1-break3)*no.col, 0)
  if(no.col4==no.col) {no.col4 <- no.col4-1} 
  col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
  col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
  col3_4 <- sapply(sapply(seq(0,1,by=1/no.col3)[-no.col3], mixcolor, color3, color4), hex)
  col4_5 <- sapply(sapply(seq(0,1,by=1/no.col4), mixcolor, color4, color5), hex)
  mixedcol <- c(col1_2, col2_3, col3_4, col4_5)
  return(mixedcol)
  }
}
