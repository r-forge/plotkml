\name{plotKML.grid}
\alias{plotKML.grid}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plotKML.grid(SGDF, var.name, var.type, file.name, z.lim, col.pal, above.ground, factor.labels, error.name, global.var, plot.type, mvFlag, r.method, kml.legend, altitudeMode, FWTools, make.kml, kmz)
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
  \item{col.pal}{
%%     ~~Describe \code{col.pal} here~~
}
  \item{above.ground}{
%%     ~~Describe \code{above.ground} here~~
}
  \item{factor.labels}{
%%     ~~Describe \code{factor.labels} here~~
}
  \item{error.name}{
%%     ~~Describe \code{error.name} here~~
}
  \item{global.var}{
%%     ~~Describe \code{global.var} here~~
}
  \item{plot.type}{
%%     ~~Describe \code{plot.type} here~~
}
  \item{mvFlag}{
%%     ~~Describe \code{mvFlag} here~~
}
  \item{r.method}{
%%     ~~Describe \code{r.method} here~~
}
  \item{kml.legend}{
%%     ~~Describe \code{kml.legend} here~~
}
  \item{altitudeMode}{
%%     ~~Describe \code{altitudeMode} here~~
}
  \item{FWTools}{
%%     ~~Describe \code{FWTools} here~~
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
function(SGDF, var.name, var.type, file.name, z.lim, col.pal, above.ground, factor.labels, error.name, global.var, plot.type, mvFlag, r.method, kml.legend, altitudeMode, FWTools, make.kml, kmz){
# SGDF = SpatialGridDataFrame with a complete proj4 string;
# var.name = name of the target variable;
# zlim = upper and lower limits of interest for visualization e.g. c(0,1)
# error.name = estimated error of the target variable (0 if not specified otherwise);
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(!is.na(proj4string(SGDF))){  #2
if(missing(mvFlag)) { mvFlag <- -99999 }
if(missing(var.type)) { var.type <- "numeric" }
if(missing(z.lim)&var.type=="numeric") { z.lim <- c(quantile(SGDF@data[,var.name], 0.025, na.rm=TRUE), quantile(SGDF@data[,var.name], 0.975, na.rm=TRUE)) }
if(missing(r.method)) { r.method <- "bilinear" }
if(missing(plot.type)) { plot.type <- "gif" }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(FWTools)) { FWTools <- FALSE }
if(missing(file.name)) { file.name <- var.name }
if(missing(make.kml)) { make.kml <- TRUE }
if(missing(kml.legend)) { kml.legend <- TRUE }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(global.var)&is.numeric(SGDF@data[,var.name])) { global.var <- var(SGDF@data[,var.name], na.rm=TRUE) }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(col.pal)) { col.no <- 48; col.pal <- rev(rainbow(65)[1:col.no]) }
col.no <- length(col.pal)
gif.pal <- c(grey(0), col.pal, rep(grey(1), 256-col.no)) # add colors for transparent pixels and undefined values
if(missing(kmz)) { kmz <- FALSE }
# reproject to WGS84 system:
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84"){ #3
SGDF.ll <- reproject.grid(SGDF=SGDF, var.name=var.name, file.name=file.name, mvFlag=mvFlag, FWTools=FWTools, error.name=error.name, r.method=r.method)
warning('projected to "+proj=longlat +datum=WGS84"')
  }
else { 
SGDF.ll <- SGDF
  }
# check if it factor or numeric and then code the values
if(is.factor(SGDF@data[,var.name])|var.type=="factor"){
SGDF.ll$mask <- ifelse(is.na(SGDF.ll@data[,var.name]), 0, as.integer(SGDF.ll@data[,var.name]))
  }
else { 
breaks.var <- c(-99999, seq(from=z.lim[1], to=z.lim[2], length.out=col.no-1), max(SGDF.ll@data[,var.name], na.rm=TRUE)+sd(SGDF.ll@data[,var.name], na.rm=TRUE)/col.no)
SGDF.ll$mask <- as.integer(cut(SGDF.ll@data[,var.name], breaks=breaks.var, include.lowest=TRUE))
SGDF.ll$mask <- ifelse(is.na(SGDF.ll$mask), 0, SGDF.ll$mask)
  }
if(kml.legend==TRUE&make.kml==TRUE){
if(is.factor(SGDF@data[,var.name])|var.type=="factor"){
if(missing(factor.labels)) { factor.labels <- levels(SGDF@data[,var.name]) }
write.legend.gif(x=SGDF.ll, var.type="factor", var.name=var.name, legend.file.name=paste(var.name, "_legend.png", sep=""), factor.labels=factor.labels, legend.pal=col.pal)
  }
else {  write.legend.gif(x=SGDF.ll, var.name=var.name, legend.file.name=paste(var.name, "_legend.png", sep=""), legend.pal=col.pal, z.lim=z.lim)
  }
  }
if(plot.type=="gif"){
# write a GIF with defined transparency:
if(is.factor(SGDF@data[,var.name])|var.type=="factor") {
write.grid2gif.KML(SGDF=SGDF.ll, var.type=var.type, var.name="mask", file.name=var.name, col.pal=gif.pal, above.ground=above.ground, altitudeMode=altitudeMode, make.legend=FALSE, make.kml==TRUE)
  } 
else {
write.grid2gif.KML(SGDF=SGDF.ll, var.type=var.type, var.name="mask", file.name=var.name, z.lim=z.lim, col.pal=gif.pal, above.ground=above.ground, altitudeMode=altitudeMode, make.legend=FALSE, make.kml==TRUE)  
  }
  }
else {
if(plot.type=="poly"){
# write a KML as polygons:
if(is.factor(SGDF@data[,var.name])|var.type=="factor") {
write.grid2poly.KML(SGDF=SGDF, var.type=var.type, var.name=var.name, file.name=var.name, col.pal=col.pal, above.ground=above.ground, altitudeMode=altitudeMode, make.legend=FALSE)
  }
else {
if(!missing(error.name)) { SGDF@data[,var.name] <- ifelse(SGDF@data[,error.name]>global.var, NA, SGDF@data[,var.name]) }
write.grid2poly.KML(SGDF=SGDF, var.type=var.type, var.name=var.name, file.name=var.name, z.lim=z.lim, col.pal=col.pal, above.ground=above.ground, altitudeMode=altitudeMode, make.legend=FALSE)
  }
  }
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
