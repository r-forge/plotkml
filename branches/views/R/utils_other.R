# Purpose        : Various utilitis for plotKML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl).edu)
# Contributions  : Pierre Roudier (pierre.roudier@landcare.nz); Dylan Beaudette (debeaudette@ucdavis
# Status         : not tested yet
# Note           : This functions should be included in the utils.R on the trunk

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

# Whitening (RGB) values
#
whitening <- function(
   x,      # target variable
   xvar,   # associated uncertainty
   x.lim = c(min(x, na.rm=TRUE), max(x, na.rm=TRUE)), 
   e.lim = c(.4,1), 
   global.var = var(x, na.rm=TRUE), 
   col.type = "RGB")  # output col.type can be "RGB" or "hex" 
   {
   require(colorspace)
   
   # Derive the normalized error:
   er <- sqrt(xvar)/sqrt(global.var)
   # Strech the values (z) to the inspection range:
   tz <- (x-x.lim[1])/(x.lim[2]-x.lim[1])
   tz <- ifelse(tz<=0, 0, ifelse(tz>1, 1, tz))
   # Derive the Hues:
   f1 <- -90-tz*300
   f2 <- ifelse(f1<=-360, f1+360, f1)
   H <- ifelse(f2>=0, f2, (f2+360))
   # Strech the error values (e) to the inspection range:
   er <- (er-e.lim[1])/(e.lim[2]-e.lim[1])
   er <- ifelse(er<=0, 0, ifelse(er>1, 1, er))
   # Derive the saturation and intensity images:
   S <- 1-er
   V <- 0.5*(1+er)
   
   # Convert the HSV values to RGB and put them as R, G, B bands:
   if(col.type=="hex"){
      out.cols <- hex(HSV(H, S, V))
      return(out.cols)
   }
   else { 
      out.cols <- as(HSV(H, S, V), "RGB")
      return(out.cols)
} 
} 

## From 2 points to a geo-path
geopath <- function(lon1, lon2, lat1, lat2, ID, n.points, print.geo = FALSE) {
require(fossil)  # Haversine Formula for Great Circle distance
# lon / lat = geographical coordinates on WGS84
# n.points = number of intermediate points

   p.1 <- matrix(c(lon1, lat1), ncol=2, dimnames=list(1,c("lon","lat")))  # source
   p.2 <- matrix(c(lon2, lat2), ncol=2, dimnames=list(1,c("lon","lat")))  # destination
   distc <- deg.dist(lat1=p.1[,2], long1=p.1[,1], lat2=p.2[,2], long2=p.2[,1])  # in km
   bearingc <- earth.bear(lat1=p.1[,2], long1=p.1[,1], lat2=p.2[,2], long2=p.2[,1])  # bearing in degrees from north
   # estimate the number of points based on the distance (the higher the distance, less points we need): 
   if(missing(ID)) { ID <- paste(ifelse(lon1<0, "W", "E"), abs(round(lon1,0)), ifelse(lat1<0, "S", "N"), abs(round(lat1,0)), ifelse(lon2<0, "W", "E"), abs(round(lon2,0)), ifelse(lat2<0, "S", "N"), abs(round(lat2,0)), sep="") }
   if(missing(n.points)) {
   n.points <- round(sqrt(distc)/sqrt(2), 0)
  }
  if(!is.nan(n.points)) { if(n.points>0) {
     pnts <- t(sapply(1:n.points/(n.points+1)*distc, FUN=new.lat.long, lat=p.1[,2], lon=p.1[,1], bearing=bearingc))[,c(2,1)] # intermediate points
   # some lines are crossing the whole globe (>180 or <-180 longitudes) and need to be split in two:
  if(is.matrix(pnts)){ if(max(LineLength(pnts, sum=FALSE))>100) {  
    breakp <- which.max(abs(pnts[,1]-c(pnts[-1,1], pnts[length(pnts[,1]),1])))
    pnts1 <- pnts[1:breakp,]
    pnts2 <- pnts[(breakp+1):length(pnts[,1]),]  
    routes <- Lines(list(Line(matrix(rbind(p.1, pnts1),ncol=2)), Line(matrix(rbind(pnts2, p.2),ncol=2))), ID=as.character(ID))
   } 
   
   else {
   routes <- Lines(list(Line(matrix(rbind(p.1, pnts, p.2),ncol=2))), ID=as.character(ID)) } 
} } 
   # create SpatialLines:
   path <- SpatialLines(list(routes), CRS("+proj=longlat +datum=WGS84"))
   }
  if(print.geo==TRUE) {
  print(paste("Distance:", round(distc,1)))
  print(paste("Bearing:", round(bearingc,1)))
  } 
  return(path)
}

## From Munsell colour codes to FBGR codes:
Munsell2KML <- function(
  x, 
  Munsell, 
  transp = "dd"
  ){
  require(aqp)
  for(i in 1:length(x[,Munsell])){
  x[i,"Hue"] <- strsplit(as.character(x[i, Munsell]), "_")[[1]][1]
  x[i,"Chroma"] <- as.numeric(strsplit(as.character(x[i, Munsell]), "_")[[1]][2]) 
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