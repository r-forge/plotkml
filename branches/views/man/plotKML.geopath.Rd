\name{plotKML.geopath}
\alias{plotKML.geopath}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plotKML.geopath(SLDF, ID.name, elev, file.name, icon, icon.url, line.size, IconColor, altitudeMode, above.ground, visibility, extrude, tessellate, LineWidth, LabelScale, kmz)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SLDF}{
%%     ~~Describe \code{SLDF} here~~
}
  \item{ID.name}{
%%     ~~Describe \code{ID.name} here~~
}
  \item{elev}{
%%     ~~Describe \code{elev} here~~
}
  \item{file.name}{
%%     ~~Describe \code{file.name} here~~
}
  \item{icon}{
%%     ~~Describe \code{icon} here~~
}
  \item{icon.url}{
%%     ~~Describe \code{icon.url} here~~
}
  \item{line.size}{
%%     ~~Describe \code{line.size} here~~
}
  \item{IconColor}{
%%     ~~Describe \code{IconColor} here~~
}
  \item{altitudeMode}{
%%     ~~Describe \code{altitudeMode} here~~
}
  \item{above.ground}{
%%     ~~Describe \code{above.ground} here~~
}
  \item{visibility}{
%%     ~~Describe \code{visibility} here~~
}
  \item{extrude}{
%%     ~~Describe \code{extrude} here~~
}
  \item{tessellate}{
%%     ~~Describe \code{tessellate} here~~
}
  \item{LineWidth}{
%%     ~~Describe \code{LineWidth} here~~
}
  \item{LabelScale}{
%%     ~~Describe \code{LabelScale} here~~
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
function(SLDF, ID.name, elev, file.name, icon, icon.url, line.size, IconColor, altitudeMode, above.ground, visibility, extrude, tessellate, LineWidth, LabelScale, kmz){
if(class(SLDF)[1]=="SpatialLinesDataFrame"){ #1
if(!is.na(proj4string(SLDF))){  #2
if(!proj4string(SLDF)=="+proj=longlat +datum=WGS84"){ #3
warning('projected to "+proj=longlat +datum=WGS84"')
SLDF <- spTransform(SLDF, CRS("+proj=longlat +datum=WGS84")) }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(ID.name)) { ID.name <- paste(SLDF@data[,1]) }
if(missing(file.name)) { file.name <- paste(names(SLDF)[1]) }
if(missing(LineWidth)) { LineWidth <- 4}
if(missing(extrude)) { extrude <- 1 }
if(missing(visibility)) { visibility <- 1 }
if(missing(tessellate)) { tessellate <- 1 }
if(missing(icon)) { icon <- "icon61.png" }
if(missing(icon.url)) { icon.url <- "http://maps.google.com/mapfiles/kml/pal4/" }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(LabelScale)) { LabelScale <- .8 } 
if(missing(kmz)) { kmz <- FALSE }
if(missing(IconColor)) { IconColor <- rep("ff0000ff", length(ID.name)) }
filename <- file(paste(file.name, ".kml", sep=""), "w",  blocking=FALSE)
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", filename)
write(paste('<kml xmlns=\"', kml.url, '\">', sep=""), filename, append = TRUE)
write("  <Document>", filename, append = TRUE)
write(paste("<name>", ID.name[j], "</name>", sep=""), filename, append = TRUE)
write("<open>1</open>", filename, append = TRUE)
for(j in 1:length(ID.name)){
for (p.i in c(1,length(SLDF@lines[[j]]@Lines[[1]]@coords[,1]))) {
  write(paste('  <Style id="','pnt', p.i,'">',sep=""), filename, append = TRUE)
  write("    <LabelStyle>", filename, append = TRUE)     
  write(paste('     <scale>', LabelScale, '</scale>', sep=""), filename, append = TRUE)
  write("    </LabelStyle>", filename, append = TRUE)
  write("		<IconStyle>", filename, append = TRUE)
  write(paste('  <color>', IconColor[j], '</color>', sep=""), filename, append = TRUE)
  write("			<Icon>", filename, append = TRUE)
  write(paste('				<href>', icon.url, icon, '</href>', sep=""), filename, append = TRUE)
  write("			</Icon>", filename, append = TRUE)
  write("		</IconStyle>", filename, append = TRUE)
  write("	</Style>", filename, append = TRUE)
  }
  write(paste('  <Style id="', 'line', j,'">',sep=""), filename, append = TRUE)
  write("          <LineStyle>", filename, append = TRUE)
  write(paste('  <color>', IconColor[j], '</color>',sep=""), filename, append = TRUE)
  write(paste('  <width>', LineWidth, '</width>',sep=""), filename, append = TRUE)
  write("		</LineStyle>", filename, append = TRUE)
  write("		<PolyStyle>", filename, append = TRUE)
  write(paste('  <color>', IconColor[j], '</color>',sep=""), filename, append = TRUE)
  write("		</PolyStyle>", filename, append = TRUE)
  write("		</Style>", filename, append = TRUE) 
# write(" <Folder>", filename, append = TRUE)
for(j in 1:length(ID.name)){
write("		  <Placemark>", filename, append = TRUE)
write(paste("<name>", ID.name[j], "</name>", sep=""), filename, append = TRUE)
write(paste('   <styleUrl>#line', j, '</styleUrl>', sep=""), filename, append = TRUE)
write("		 <LineString>", filename, append = TRUE)
write(paste('		<extrude>', extrude, '</extrude>', sep=""), filename, append = TRUE)
write(paste('		<tessellate>', tessellate, '</tessellate>',sep=""), filename, append = TRUE)
write(paste('     <altitudeMode>', altitudeMode, '</altitudeMode>',sep=""), filename, append = TRUE)
print('writing points to KML file')
if(ncol(SLDF@lines[[j]]@Lines[[1]]@coords)==3&missing(elev)){ 
  elev <- SLDF@lines[[j]]@Lines[[1]]@coords[,3] 
  }
if(ncol(SLDF@lines[[j]]@Lines[[1]]@coords)<3&missing(elev)){
  elev <- rep(above.ground, length(SLDF@lines[[j]]@Lines[[1]]@coords[,1]))
  }
### create a progress bar:
pb <- txtProgressBar(min=0, max=length(SLDF@lines[[j]]@Lines[[1]]@coords[,1]), style=3)
 write("      <coordinates>", filename, append = TRUE) 
for (i in 1:length(SLDF@lines[[j]]@Lines[[1]]@coords[,1])) {
 write(paste('      ', SLDF@lines[[j]]@Lines[[1]]@coords[i,1],',',SLDF@lines[[j]]@Lines[[1]]@coords[i,2],',',elev[i], sep=""), filename, append = TRUE)
# update progress bar
setTxtProgressBar(pb, i)
  }
write("      </coordinates>", filename, append = TRUE) 
close(pb)
write("     </LineString>", filename, append = TRUE)
write("   </Placemark>", filename, append = TRUE)
  }
## first and last point:      
for (p.i in c(1,length(SLDF@lines[[j]]@Lines[[1]]@coords[,1]))) {
write("    <Placemark>", filename, append = TRUE)
write(paste("  <name>", if(p.i==1){paste("begin")} else {paste("end")}, "</name>", sep=""), filename, append = TRUE)
write(paste("  <styleUrl>#pnt",p.i,"</styleUrl>", sep=""), filename, append = TRUE)
write(paste('    <visibility>', 1,'</visibility>', sep=""), filename, append = TRUE)
write("    <Point>", filename, append = TRUE)
write(paste('   <altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write(paste('     <coordinates>', SLDF@lines[[j]]@Lines[[1]]@coords[p.i,1],",",SLDF@lines[[j]]@Lines[[1]]@coords[p.i,2],",", elev[p.i], '</coordinates>', sep=""), filename, append = TRUE)
write("   </Point>", filename, append = TRUE)
write(" </Placemark>", filename, append = TRUE) 
  } }    
## close the file:         
# write("</Folder>", filename, append = TRUE)
write("</Document>", filename, append = TRUE)
write("</kml>", filename, append = TRUE)
close(filename)
if(kmz==TRUE){
unlink(paste(file.name, ".kmz", sep=""))
zip(paste(file.name, ".kmz", sep=""), paste(file.name, ".kml", sep=""))
unlink(paste(file.name, ".kml", sep="")) }
  } 
else { stop("proj4 string required") } } 
else { stop("first argument should be of class SLDF") } 
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
