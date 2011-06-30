\name{write.grid2poly.KML}
\alias{write.grid2poly.KML}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
write.grid2poly.KML(SGDF, var.name, var.type, file.name, col.pal, above.ground, altitudeMode, make.legend, extrude, tessellate, z.lim, transp)
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
  \item{col.pal}{
%%     ~~Describe \code{col.pal} here~~
}
  \item{above.ground}{
%%     ~~Describe \code{above.ground} here~~
}
  \item{altitudeMode}{
%%     ~~Describe \code{altitudeMode} here~~
}
  \item{make.legend}{
%%     ~~Describe \code{make.legend} here~~
}
  \item{extrude}{
%%     ~~Describe \code{extrude} here~~
}
  \item{tessellate}{
%%     ~~Describe \code{tessellate} here~~
}
  \item{z.lim}{
%%     ~~Describe \code{z.lim} here~~
}
  \item{transp}{
%%     ~~Describe \code{transp} here~~
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
function(SGDF, var.name, var.type, file.name, col.pal, above.ground, altitudeMode, make.legend, extrude, tessellate, z.lim, transp) {
message("This function is not recommended for large grids!", appendLF=TRUE)
# Writes a SGDF to ground overlay 
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(!is.na(proj4string(SGDF))){  #2
# if all requirements are met, proceed with conversion
if(missing(var.type)) { var.type <- "numeric" }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(make.legend)) { make.legend <- FALSE }
if(missing(file.name)) { file.name <- var.name }
if(missing(extrude)) { extrude <- 1 }
if(missing(tessellate)) { tessellate <- 1 }
if(missing(col.pal)) { col.no <- 48; col.pal <- rev(rainbow(65)[1:col.no]) }
if(missing(transp)) { transp <- "dd" }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(z.lim)&var.type=="numeric") { z.lim <- c(quantile(SGDF@data[,var.name], 0.025, na.rm=TRUE), quantile(SGDF@data[,var.name], 0.975, na.rm=TRUE)) }
# convert grids to polygons:
SGDF.pix <- as(SGDF[var.name], "SpatialPixelsDataFrame")
## Maybe the "rasterToPolygons" in the raster package would be faster?
grd.poly <- as.SpatialPolygons.SpatialPixels(SGDF.pix)
proj4string(grd.poly) <- SGDF@proj4string
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84") { 
grd.poly.ll <- spTransform(grd.poly, CRS("+proj=longlat +datum=WGS84")) 
  }
else { grd.poly.ll <- grd.poly }
grd.spoly.ll <- SpatialPolygonsDataFrame(grd.poly.ll, data.frame(band1=SGDF.pix@data[,var.name]), match.ID=FALSE)
if(is.factor(grd.spoly.ll$band1)|var.type=="factor"){
grd.spoly.ll$mask <- ifelse(is.na(grd.spoly.ll@data[,"band1"]), 0, as.integer(grd.spoly.ll@data[,"band1"]))
  }
else { 
breaks.var <- c(-99999, seq(from=z.lim[1], to=z.lim[2], length.out=col.no-1), max(grd.spoly.ll@data[,"band1"], na.rm=TRUE)+sd(grd.spoly.ll@data[,"band1"], na.rm=TRUE)/col.no)
grd.spoly.ll$mask <- as.integer(cut(grd.spoly.ll@data[,"band1"], breaks=breaks.var, include.lowest=TRUE))
grd.spoly.ll$mask <- ifelse(is.na(grd.spoly.ll$mask), 0, grd.spoly.ll$mask)
  }
rgb.colors <- data.frame(t(col2rgb(col.pal)))
rgb.colors$FBGR <- RGB2FBGR(R=rgb.colors[,1]/255, G=rgb.colors[,2]/255, B=rgb.colors[,3]/255, transp=transp) 
ID.slot <- sapply(slot(grd.spoly.ll, "polygons"), function(x) slot(x, "ID"))
i.colors <- merge(data.frame(mask=grd.spoly.ll$mask, ID=ID.slot), data.frame(mask=0:length(rgb.colors$FBGR), FBGR=c("9dffffff", rgb.colors$FBGR)), by="mask", all.x=TRUE)
# write polygon by polygon:
filename <- file(paste(file.name, ".kml", sep=""), "w", blocking=FALSE)
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", filename)
write(paste('<kml xmlns=\"', kml.url, '\">', sep=""), filename, append = TRUE)
write("<Document>", filename, append = TRUE)
write(paste("<name>", file.name, "</name>", sep=" "), filename, append = TRUE)
write("<open>1</open>", filename, append = TRUE)
print('writing polygons to KML file')
### create a progress bar:
pb <- txtProgressBar(min=0, max=length(grd.spoly.ll@data[[1]]), style=3)
for (i in 1:length(i.colors$ID)) {
write(paste(' <Style id="','poly', i,'">',sep=""), filename, append = TRUE)
write(" <LineStyle>", filename, append = TRUE)
write(" <width>0.5</width>", filename, append = TRUE)
write(" </LineStyle>", filename, append = TRUE)
write(" <PolyStyle>", filename, append = TRUE)
write(paste(' <color>', i.colors$FBGR[i], '</color>', sep=""), filename, append = TRUE)
write(" </PolyStyle>", filename, append = TRUE)
write(" </Style>", filename, append = TRUE)
  }
write("<Folder>", filename, append = TRUE)
write(paste("<name>Poly ID: ", file.name,"</name>"), filename, append = TRUE)
for (i in 1:length(i.colors$ID)) {
write(" <Placemark>", filename, append = TRUE)
write(paste(' <name>', i.colors$ID[i], '</name>', sep=""), filename, append = TRUE)
write(" <visibility>1</visibility>", filename, append = TRUE)
write(paste(' <styleUrl>#poly', i, '</styleUrl>', sep=""), filename, append = TRUE)
write(" <Polygon>", filename, append = TRUE)
write(paste(' <tessellate>', tessellate, '</tessellate>', sep=""), filename, append = TRUE)
write(paste(' <altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write(" <outerBoundaryIs>", filename, append = TRUE)
write(" <LinearRing>", filename, append = TRUE)
write(" <coordinates>", filename, append = TRUE)
i.ID <- which(ID.slot \%in\% i.colors$ID[i])
write(paste(" ", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[1,1], ",", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[1,2], ",1", sep=""), filename, append = TRUE)
write(paste(" ", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[2,1], ",", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[2,2], ",1", sep=""), filename, append = TRUE)
write(paste(" ", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[3,1], ",", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[3,2], ",1", sep=""), filename, append = TRUE)
write(paste(" ", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[4,1], ",", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[4,2], ",1", sep=""), filename, append = TRUE)
write(paste(" ", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[5,1], ",", grd.spoly.ll@polygons[[i.ID]]@Polygons[[1]]@coords[5,2], ",1", sep=""), filename, append = TRUE)
write(" </coordinates>", filename, append = TRUE)
write(" </LinearRing>", filename, append = TRUE)
write(" </outerBoundaryIs>", filename, append = TRUE)
write(" </Polygon>", filename, append = TRUE)
write(" </Placemark>", filename, append = TRUE)
# update progress bar
setTxtProgressBar(pb, i)
  }
if(make.legend==TRUE) {
if(is.factor(SGDF@data[,var.name])|var.type=="factor"){
write.legend.gif(x=SGDF, var.type="factor", var.name=var.name, legend.file.name=paste(file.name, '_legend.png', sep=""), legend.pal=col.pal, z.lim=z.lim)
  }
else { write.legend.gif(x=SGDF, var.name=var.name, legend.file.name=paste(file.name, '_legend.png', sep=""), legend.pal=col.pal, z.lim=z.lim)
  }
  }
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
write("</Folder>", filename, append = TRUE)
write("</Document>", filename, append = TRUE)
write("</kml>", filename, append = TRUE)
close(pb)
close(filename)
  }
else { stop("proj4 string required") }
  }
else { stop("first argument should be of class SGDF") } 
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
