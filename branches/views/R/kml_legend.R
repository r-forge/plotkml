# Purpose        : Writing of PNG files / legends
# Maintainer     : Dylan Beaudette (debeaudette@ucdavis.edu)
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : Function for plotting of legends for factor-type data needs to be improved

# Generate PNG legend (1D)
#
kml_legend <- function(
  x, 
  var.type = "numeric", 
  legend.file, 
  legend.pal = rev(rainbow(65)[1:48]), 
  z.lim = c(quantile(x, 0.025, na.rm=TRUE), quantile(x, 0.975, na.rm=TRUE)), 
  factor.labels,
  ...
  ){

  require(colorspace)
  require(plotrix)
  
  ## Factor-type variables:
    if(class(x) == "factor" | var.type=="factor") {
 
    z.lim <- NA
    if(missing(factor.labels)){ col.no <- length(levels(as.factor(x)))  }
    else { col.no <- length(factor.labels) }
 
    if(missing(factor.labels)) {
    ### NOTE : This is a not a perfect implementation for a factor with a lot of categories!
    leg.width <- max(nchar(levels(as.factor(x))))*5+70  # 5 pix per character
    leg.height <- length(levels(as.factor(x)))*40 # 20 pix per class
    }
 
    else {
    leg.width <- max(nchar(factor.labels))*10+70  # 10 pix per character
    leg.height <- length(factor.labels)*40 # 20 pix per class
    }
 
    png(file=legend.file, width=leg.width, height=leg.height, bg="transparent", pointsize=14)
    # c(bottom, left, top, right)
    par(mar=c(.5,0,.5,1))
    plot(x=rep(1, col.no), y=1:col.no, axes=FALSE, xlab='', ylab='', pch=15, cex=4, col=legend.pal)
  
      if(missing(factor.labels)) {
      text(x=rep(1, col.no), y=1:col.no, labels=levels(as.factor(x)), cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
      }
  
       else { 
      text(x=rep(1, col.no), y=1:col.no, labels=factor.labels, cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
    }
  
   dev.off()
}

  ### Numeric-type variables:
  else {
  if(class(x) == "numeric") {
  png(file=legend.file, width=120, height=240, bg="transparent", pointsize=14)
  par(mar=c(.5,0,.5,4))
  plot(x=0:5, y=0:5, asp=3, type="n", axes=FALSE, xlab='', ylab='')
  # get the 2-4 significant digits
  lower.lim <- z.lim[1]
  upper.lim <- z.lim[2]
  col.labels <- signif(c(lower.lim, (upper.lim-lower.lim)/2, upper.lim), 2)
  color.legend(xl=0, yb=0, xr=5, yt=5, legend=col.labels, rect.col=legend.pal, gradient="y", align="rb", cex=1.4, col=rgb(0.99,0.99,0.99))
  
  dev.off()
  }
  else { stop("Numeric or factor vector required") }
}
}

# Generate PNG legend for whitening (2D)
#
kml_legend.whitening <- function(
  legend.res = 0.01, 
  width=120, 
  height=300, 
  pointsize = 14, 
  x.lim, 
  e.lim, 
  leg.asp = 0.3*width/height,
  legend.file = "whitening_legend.png",
  matte="") 
  {
  
  require(colorspace)
  require(pixmap)
  require(animation)
   
  xlg <- seq(.01,1,by=legend.res)
  ylg <- seq(.01,1,by=legend.res)
  # empty grid
  leg <- expand.grid(xlg, ylg, KEEP.OUT.ATTRS=FALSE)
  # Hues
  f1 <- -90-leg[,2]*300
  f2 <- ifelse(f1<=-360, f1+360, f1)
  H <- ifelse(f2>=0, f2, (f2+360))
  # Saturation
  S <- 1-leg[,1]
  # Intensity
  V <- 0.5+leg[,1]/2
  HSV <- as.vector(t(matrix(hex(HSV(rev(H), S, V)), nrow=length(ylg), ncol=length(xlg))))
  leg.plt <- pixmapIndexed(data=1:length(HSV), nrow=length(ylg), ncol=length(xlg), bbox=c(e.lim[1], x.lim[1], e.lim[2], x.lim[2]), col=HSV)
  # par(las = 0)
  png(file=legend.file, width=width, height=height, bg="transparent", pointsize=pointsize)
  par(mar=c(2.5,2.5,0.5,0))
  plot(leg.plt, axes=FALSE, col.lab=rgb(0.99,0.99,0.99), bg=NA, asp=leg.asp)
  axis(side=1, at=e.lim, cex=.8, col.axis=rgb(0.99,0.99,0.99), col.lab=rgb(0.99,0.99,0.99))
  axis(side=2, at=signif(x.lim, 3), cex=.8, col.axis=rgb(0.99,0.99,0.99), col.lab=rgb(0.99,0.99,0.99))
  dev.off()
 
  ## Force transparency (requires ImageMagick):
 	if(matte!= "") {
    # get the path of ImageMagick using the animation package:
    im.convert <- ani.options('convert')
    cmd <- paste(im.convert, ' ', legend.file, ' -matte -transparent "#FFFFFF" ', legend.file, sep="")
    sss <- try(system(cmd, intern=TRUE), silent=TRUE) 
   }
}
