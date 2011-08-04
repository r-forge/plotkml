# Whitening (RGB) values
#
kml_whitening <- function(
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