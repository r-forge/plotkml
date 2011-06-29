Munsell2FBGR <- function(x, Munsell, transp) {
# Munsell = munsell color codes column;
# merge munsell color codes in format "7.5R_2_4" and RGB values:
if(missing(transp)) { transp <- "dd" }
for(i in 1:length(x[,Munsell])){
x[i, "Hue"] <- strsplit(as.character(x[i, Munsell]), "_")[[1]][1]
x[i, "Chroma"] <- as.numeric(strsplit(as.character(x[i, Munsell]), "_")[[1]][2]) 
x[i,"Value"] <- as.numeric(strsplit(as.character(x[i, Munsell]), "_")[[1]][3])
}
mcolor.RGB <- munsell2rgb(the_hue=x$Hue, the_chroma=x$Chroma, the_value=x$Value, return_triplets=TRUE)
mcolor.RGB$Rc <- round(mcolor.RGB$r*100, 0)
mcolor.RGB$Gc <- round(mcolor.RGB$g*100, 0)
mcolor.RGB$Bc <- round(mcolor.RGB$b*100, 0)
# reformat colors suited for Google Earth:
Bc <- ifelse(mcolor.RGB$Bc<10, paste("0", mcolor.RGB$Bc, sep=""), ifelse(mcolor.RGB$Bc==100, "ff", mcolor.RGB$Bc))
Gc <- ifelse(mcolor.RGB$Gc<10, paste("0", mcolor.RGB$Gc, sep=""), ifelse(mcolor.RGB$Gc==100, "ff", mcolor.RGB$Gc))
Rc <- ifelse(mcolor.RGB$Rc<10, paste("0", mcolor.RGB$Rc, sep=""), ifelse(mcolor.RGB$Rc==100, "ff", mcolor.RGB$Rc))
FBGR <- paste(transp, Bc, Gc, Rc, sep="")
return(FBGR)
}

