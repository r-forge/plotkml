RGB2FBGR <-
function(R, G, B, transp) {
# See: http://code.google.com/intl/nl-NL/apis/kml/documentation/kmlreference.html#color
# transp = 00 to ff
# generate Google colors:
R <- round(R*100, 0)
B <- round(B*100, 0)
G <- round(G*100, 0)
if(missing(transp)) { transp <- "dd" } # very little transparency
FBGR <- paste(transp, ifelse(B<10, paste("0", B, sep=""),
ifelse(B==100, "ff", B)), ifelse(G<10, paste("0", G, sep=""),
ifelse(G==100, "ff", G)), ifelse(R<10, paste("0", R, sep=""),
ifelse(R==100, "ff", R)), sep="")
return(FBGR)
}

