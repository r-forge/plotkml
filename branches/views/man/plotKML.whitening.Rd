\name{plotKML.whitening}
\alias{plotKML.whitening}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plotKML.whitening(SGDF, var.name, var.type, file.name, z.lim, e.lim, above.ground, error.name, global.var, mvFlag, kml.legend, legend.res, altitudeMode, make.kml, kmz)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SGDF}{
%%     ~~Describe \code{SGDF} here~~
}
  \item{var.name}{
%%     ~~Describe \code{var.name} here~~
}
  \item{var.type}{
%%     ~~Describe \code{var.type} here~~
}
  \item{file.name}{
%%     ~~Describe \code{file.name} here~~
}
  \item{z.lim}{
%%     ~~Describe \code{z.lim} here~~
}
  \item{e.lim}{
%%     ~~Describe \code{e.lim} here~~
}
  \item{above.ground}{
%%     ~~Describe \code{above.ground} here~~
}
  \item{error.name}{
%%     ~~Describe \code{error.name} here~~
}
  \item{global.var}{
%%     ~~Describe \code{global.var} here~~
}
  \item{mvFlag}{
%%     ~~Describe \code{mvFlag} here~~
}
  \item{kml.legend}{
%%     ~~Describe \code{kml.legend} here~~
}
  \item{legend.res}{
%%     ~~Describe \code{legend.res} here~~
}
  \item{altitudeMode}{
%%     ~~Describe \code{altitudeMode} here~~
}
  \item{make.kml}{
%%     ~~Describe \code{make.kml} here~~
}
  \item{kmz}{
%%     ~~Describe \code{kmz} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(SGDF, var.name, var.type, file.name, z.lim, e.lim, above.ground, error.name, global.var, mvFlag, kml.legend, legend.res, altitudeMode, make.kml, kmz){
# SGDF = SpatialGridDataFrame with a complete proj4 string;
# var.name = name of the target variable;
# zlim = upper and lower limits of interest for visualization e.g. c(0,1)
# error.name = estimated error of the target variable (0 if not specified otherwise);
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(!is.na(proj4string(SGDF))){  #2
if(missing(mvFlag)) { mvFlag <- -99999 }
if(missing(var.type)) { var.type <- "numeric" }
if(missing(z.lim)&var.type=="numeric") { z.lim <- c(quantile(SGDF@data[,var.name], 0.025, na.rm=TRUE), quantile(SGDF@data[,var.name], 0.975, na.rm=TRUE)) }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(file.name)) { file.name <- var.name }
if(missing(make.kml)) { make.kml <- TRUE }
if(missing(e.lim)) { e.lim <- c(.4,1) }
if(missing(kml.legend)) { kml.legend <- TRUE }
if(missing(legend.res)) { legend.res <- 0.01 }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(global.var)&is.numeric(SGDF@data[,var.name])) { global.var <- var(SGDF@data[,var.name], na.rm=TRUE) }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(kmz)) { kmz <- FALSE }
# reproject to WGS84 system:
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84"){ #3
# reproject/resample using raster package:
SGDF.r1 <- raster(SGDF[var.name])
SGDF.r2 <- raster(SGDF[error.name])
SGDF.r <- projectRaster(SGDF.r1, crs="+proj=longlat +datum=WGS84")
SGDF.e <- projectRaster(SGDF.r2, crs="+proj=longlat +datum=WGS84")
SGDF.ll <- as(SGDF.r, "SpatialGridDataFrame")
names(SGDF.ll@data) <- var.name
SGDF.ll@data[,error.name] <- SGDF.e@data@values
warning('projected to "+proj=longlat +datum=WGS84"')
  }
else { SGDF.ll <- SGDF }
# estimate colors using whitening:
SGDF.ll$w <- whitening.col(x=SGDF.ll@data, var.name=var.name, error.name=error.name, z.lim=z.lim, e.lim=e.lim, global.var=global.var, col.type="hex")
# generate a PNG:
png(file=paste(file.name, ".png", sep=""), width=SGDF.ll@grid@cells.dim[1], height=SGDF.ll@grid@cells.dim[2], bg=NA)
par(mar=c(0,0,0,0), xaxs="i", yaxs="i", xaxt="n", yaxt="n")
mx <- as.vector(t(as.matrix(SGDF.ll["w"])))
x <- pixmapIndexed(data=1:length(mx), nrow=SGDF.ll@grid@cells.dim[2], ncol=SGDF.ll@grid@cells.dim[1], col=mx)
plot(x, bg=NA, axes=FALSE) # bbox=c(SGDF.ll@bbox[2,1], SGDF.ll@bbox[1,1], SGDF.ll@bbox[2,2], SGDF.ll@bbox[1,2])
dev.off()
## There is a bug in Google Earth that does not allow transparency of pngs:
# http://groups.google.com/group/earth-free/browse_thread/thread/1cd6bc29a2b6eb76/62724be63547fab7
# Solution: add transparency using ImageMagick:
system(paste(im.convert, ' ', file.name, ".png", ' -matte -transparent "#FFFFFF" ', file.name, ".png", sep=""))
if(kml.legend==TRUE&make.kml==TRUE){
# write a KML with a legend:
filename <- file(paste(file.name, "_w.kml", sep=""), "w")
write('<?xml version="1.0" encoding="UTF-8"?>', file=filename)
write('<kml xmlns="http://www.opengis.net/kml/2.2">', filename, append = TRUE)
write('<Document>', filename, append = TRUE)
write(paste('<name>', file.name, '</name>', sep=""), filename, append = TRUE)
write('<GroundOverlay>', filename, append = TRUE)
write(paste('<name>Ground overlay: ', file.name, '</name>', sep=""), filename, append = TRUE)
write(paste('<description>Values range: ', signif(z.lim[1], 2),' to ', signif(z.lim[2], 2),'</description>', sep=""), filename, append = TRUE)
write(paste('<altitude>', above.ground, '</altitude>', sep=""), filename, append = TRUE) 
write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', file.name, ".png", '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write('<LatLonBox>', filename, append = TRUE)
write(paste('<north>', SGDF.ll@bbox[2,2], '</north>', sep=""), filename, append = TRUE)
write(paste('<south>', SGDF.ll@bbox[2,1], '</south>', sep=""), filename, append = TRUE)
write(paste('<east>', SGDF.ll@bbox[1,2], '</east>', sep=""), filename, append = TRUE)
write(paste('<west>', SGDF.ll@bbox[1,1], '</west>', sep=""), filename, append = TRUE)
write('</LatLonBox>', filename, append = TRUE)
write('</GroundOverlay>', filename, append = TRUE)
if(make.legend==TRUE) {
xlg <- seq(.01,1,by=legend.res)
ylg <- seq(.01,1,by=legend.res)
legend.2D <- expand.grid(xlg, ylg, KEEP.OUT.ATTRS=FALSE)
# Hues
legend.2D$tmpf1 <- -90-legend.2D[,2]*300
legend.2D$tmpf2 <- ifelse(legend.2D$tmpf1<=-360, legend.2D$tmpf1+360, legend.2D$tmpf1)
legend.2D$H <- ifelse(legend.2D$tmpf2>=0, legend.2D$tmpf2, (legend.2D$tmpf2+360))
# Saturation
legend.2D$S <- 1-legend.2D[,1]
# Intensity
legend.2D$V <- 0.5+legend.2D[,1]/2
legendimg <- as.vector(t(matrix(hex(HSV(rev(legend.2D$H), legend.2D$S, legend.2D$V)), nrow=length(ylg), ncol=length(xlg))))
legendimg.plt <- pixmapIndexed(data=1:length(legendimg), nrow=length(ylg), ncol=length(xlg), bbox=c(e.lim[1],z.lim[1],e.lim[2],z.lim[2]), col=legendimg)
# par(las = 0)
png(file=paste(file.name, "_legend.png", sep=""), width=160, height=300, bg="transparent", pointsize=14)
par(mar=c(3.5,2.5,1,0))
plot(legendimg.plt, axes=FALSE, col.lab=rgb(0.99,0.99,0.99), bg=NA, asp=1/2.5)
axis(side=1, at=e.lim, cex=.8, col.axis=rgb(0.99,0.99,0.99), col.lab=rgb(0.99,0.99,0.99))
axis(side=2, at=signif(z.lim,3), cex=.8, col.axis=rgb(0.99,0.99,0.99), col.lab=rgb(0.99,0.99,0.99))
dev.off()
system(paste(im.convert, ' ', file.name, "_legend.png", ' -matte -transparent "#FFFFFF" ', file.name, "_legend.png", sep=""))
write('<ScreenOverlay>', filename, append = TRUE)
write('<name>Legend</name>', filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', file.name, '_legend.png</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write(paste('<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<size x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write('</ScreenOverlay>', filename, append = TRUE)
  }
write('</Document>', filename, append = TRUE)
write('</kml>', filename, append = TRUE)
close(filename) 
  }
if(kmz==TRUE){
unlink(paste(file.name, ".kmz", sep=""))
zip(paste(file.name, ".kmz", sep=""), paste(file.name, ".kml", sep=""))
if(plot.type=="poly") { unlink(paste(file.name, ".kml", sep="")) }
  }  }
else { stop("proj4 string required")  }  }  
else { stop("first argument should be of class SGDF") } 
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
