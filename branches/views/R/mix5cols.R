mix5cols <-
function(color1, color2, color3, color4, color5, break1, break2, break3, no.col) {
# Mixes five RGB colors into a pallette
if(missing(no.col)) { no.col <- 47 }
if(missing(break1)) { break1 <- 1/4 }
if(missing(break2)) { break2 <- 2/4 }
if(missing(break3)) { break3 <- 3/4 }
# Mixes three RGB colors into a pallette
no.col1 <- round((break1-0)*no.col, 0)
no.col2 <- round((break2-break1)*no.col, 0)
no.col3 <- round((break3-break2)*no.col, 0)
no.col4 <- round((1-break3)*no.col, 0)
col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
col3_4 <- sapply(sapply(seq(0,1,by=1/no.col3)[-no.col3], mixcolor, color3, color4), hex)
col4_5 <- sapply(sapply(seq(0,1,by=1/no.col4), mixcolor, color4, color5), hex)
mixedcol <- c(col1_2, col2_3, col3_4, col4_5)
return(mixedcol)
}

