\name{reproject.grid}
\alias{reproject.grid}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
reproject.grid(SGDF, var.name, file.name, mvFlag, FWTools, error.name, r.method, global.var)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SGDF}{
%%     ~~Describe \code{SGDF} here~~
}
  \item{var.name}{
%%     ~~Describe \code{var.name} here~~
}
  \item{file.name}{
%%     ~~Describe \code{file.name} here~~
}
  \item{mvFlag}{
%%     ~~Describe \code{mvFlag} here~~
}
  \item{FWTools}{
%%     ~~Describe \code{FWTools} here~~
}
  \item{error.name}{
%%     ~~Describe \code{error.name} here~~
}
  \item{r.method}{
%%     ~~Describe \code{r.method} here~~
}
  \item{global.var}{
%%     ~~Describe \code{global.var} here~~
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
function(SGDF, var.name, file.name, mvFlag, FWTools, error.name, r.method, global.var) {
# FWTools is an external application but more suited for large grids
# error.name = estimated error of the target variable (0 if not specified otherwise);
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(missing(mvFlag)) { mvFlag <- -99999 }
if(missing(r.method)) { r.method <- "bilinear" }
if(missing(FWTools)) { FWTools <- FALSE }
if(missing(file.name)) { file.name <- var.name }
if(!is.na(proj4string(SGDF))){  #2
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84"){ #3
# distinguish between numeric and factor variables
if(is.factor(SGDF@data[,var.name])){
if(FWTools==TRUE){
SGDF@data[,"factor"] <- as.integer(SGDF@data[,var.name])
writeGDAL(SGDF["factor"], set.file.extension(file.name, ".tif"), "GTiff", mvFlag=mvFlag)
unlink(paste(file.name, "_ll.sdat", sep=""))
# reproject/resample using FWTools:
system(paste(gdalwarp, " ", file.name, ".tif ", file.name, "_ll.sdat -of \"SAGA\" -r near -s_srs \"", proj4string(SGDF), "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep="")) 
  }
# reproject/resample using raster package:
SGDF.r <- raster(SGDF[var.name])
SGDF.r <- projectRaster(SGDF.r, crs="+proj=longlat +datum=WGS84", method="ngb") 
  }
else { if(!missing(error.name)) { # if there is no error map then we assume that the map is perfect!
if(missing(global.var)&is.numeric(SGDF@data[,var.name])) { global.var <- var(SGDF@data[,var.name], na.rm=TRUE) }
SGDF@data[,var.name] <- ifelse(SGDF@data[,error.name]>global.var, NA, SGDF@data[,var.name])
  }
if(FWTools==TRUE){
writeGDAL(SGDF[var.name], set.file.extension(file.name, ".tif"), "GTiff", mvFlag=mvFlag)
unlink(paste(file.name, "_ll.sdat", sep="")) 
system(paste(gdalwarp, " ", file.name, ".tif ", file.name, "_ll.sdat -of \"SAGA\" -r ", r.method, " -s_srs \"", proj4string(SGDF), "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep=""))
  }
else { 
SGDF.r <- raster(SGDF[var.name])
SGDF.r <- projectRaster(SGDF.r, crs="+proj=longlat +datum=WGS84", method="bilinear") 
  }
  } 
# finished reprojecting
if(FWTools==TRUE) { 
SGDF.ll <- readGDAL(paste(file.name, "_ll.sdat", sep=""))
  }
else { 
SGDF.ll <- as(SGDF.r, "SpatialGridDataFrame")
names(SGDF.ll) <- var.name
 } 
return(SGDF.ll)   }
else { warning('no reprojection required') } } 
else { stop("proj4 string required")  }   } 
else { stop("first argument should be of class SGDF") }  
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
