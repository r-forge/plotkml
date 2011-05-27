mix3cols <-
function(color1, color2, color3, break1, no.col) {
# Mixes three RGB colors into a pallette
if(missing(no.col)) { no.col <- 47 }
if(missing(break1)) { break1 <- 1/2 }
no.col1 <- round((break1-0)*no.col, 0)
no.col2 <- round((1-break1)*no.col, 0)
col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
mixedcol <- c(col1_2, col2_3)
return(mixedcol)
}

