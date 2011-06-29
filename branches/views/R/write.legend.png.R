write.legend.png <- function(
  # Options
  x, 
  var.type="numeric", 
  var.name, 
  legend.file.name, 
  legend.pal, 
  z.lim, 
  factor.labels
){
require(colorspace)
require(plotrix)
 if(class(x)[1]=="SpatialGridDataFrame"|class(x)[1]=="SpatialPixelsDataFrame"|class(x)[1]=="SpatialPolygonsDataFrame"|class(x)[1]=="SpatialLinesDataFrame"){
if(missing(legend.file.name)) { legend.file.name <- paste(var.name, "_legend.png", sep="") }
if(missing(legend.pal)) { col.no <- 48; legend.pal <- rev(rainbow(65)[1:col.no]) }
if(missing(var.type)) { var.type <- class(x@data[,var.name]) }

### Factor-type variables:
if(var.type=="factor") {
z.lim <- NA
if(missing(factor.labels)){ col.no <- length(levels(as.factor(x@data[,var.name])))  }
else { col.no <- length(factor.labels) }
if(missing(factor.labels)) {
### NOTE : This is a not a perfect implementation for a factor with a lot of categories!
leg.width <- max(nchar(levels(as.factor(x@data[,var.name]))))*5+70  # 5 pix per character
leg.height <- length(levels(as.factor(x@data[,var.name])))*40 # 20 pix per class
}
else {
leg.width <- max(nchar(factor.labels))*10+70  # 10 pix per character
leg.height <- length(factor.labels)*40 # 20 pix per class
}
png(file=legend.file.name, width=leg.width, height=leg.height, bg="transparent", pointsize=14)
# c(bottom, left, top, right)
par(mar=c(.5,0,.5,1))
plot(x=rep(1, col.no), y=1:col.no, axes=FALSE, xlab='', ylab='', pch=15, cex=4, col=legend.pal)
if(missing(factor.labels)) {
text(x=rep(1, col.no), y=1:col.no, labels=levels(as.factor(x@data[,var.name])), cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
}
else { 
text(x=rep(1, col.no), y=1:col.no, labels=factor.labels, cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
}
dev.off()
}

### Numeric-type variables:
else {
if(missing(z.lim)&class(x@data[,var.name])=="numeric") { z.lim <- c(quantile(x@data[,var.name], 0.025, na.rm=TRUE), quantile(x@data[,var.name], 0.975, na.rm=TRUE)) }
png(file=legend.file.name, width=120, height=240, bg="transparent", pointsize=14)
par(mar=c(.5,0,.5,4))
plot(x=0:5, y=0:5, asp=3, type="n", axes=FALSE, xlab='', ylab='')
colno <- legend.pal
# get the 2-4 significant digits
lower.lim <- z.lim[1]
upper.lim <- z.lim[2]
col.labels <- signif(c(lower.lim, (upper.lim-lower.lim)/2, upper.lim), 2)
color.legend(xl=0, yb=0, xr=5, yt=5, legend=col.labels, rect.col=colno, gradient="y", align="rb", cex=1.4, col=rgb(0.99,0.99,0.99))
dev.off()
}
}
else { stop("first argument should be of class sp (Grid, Pixel, Polygons, Lines)") } 
}