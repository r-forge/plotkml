\name{plotKML.env}
\alias{plotKML.env}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plotKML.env(gdalwarp, saga_cmd, im.convert, im.identify, google.earth, kml.url)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gdalwarp}{
%%     ~~Describe \code{gdalwarp} here~~
}
  \item{saga_cmd}{
%%     ~~Describe \code{saga_cmd} here~~
}
  \item{im.convert}{
%%     ~~Describe \code{im.convert} here~~
}
  \item{im.identify}{
%%     ~~Describe \code{im.identify} here~~
}
  \item{google.earth}{
%%     ~~Describe \code{google.earth} here~~
}
  \item{kml.url}{
%%     ~~Describe \code{kml.url} here~~
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
function(gdalwarp, saga_cmd, im.convert, im.identify, google.earth, kml.url) {
# Locate external packages:
message("Traying to locate paths automatically...", appendLF=TRUE)
if(.Platform$OS.type=="windows"){
p.path <- ifelse(length(dir(path="C:/PROGRA~2"))>0, "C:/PROGRA~2", "C:/PROGRA~1")
if(missing(gdalwarp)) {
fw.path <- dir(p.path, full.names=FALSE)[grep(pattern="FWTools", dir(p.path, full.names=FALSE))]
gdalwarp <- gsub("/", "\\\\", dir(path=paste(p.path, fw.path, sep="/"), pattern="gdalwarp.exe", recursive=TRUE, full.names=TRUE))
gdal_translate <- gsub("/", "\\\\", dir(path=paste(p.path, fw.path, sep="/"), pattern="gdal_translate.exe", recursive=TRUE, full.names=TRUE))
if(nchar(gdalwarp)==0) { stop("FWTools missing : download and install to program files")}
  }
if(missing(saga_cmd)) {
saga_cmd <- rsaga.env()$path
if(nchar(saga_cmd)==0) { stop("SAGA binaries missing : download and install to default location") }
  }
if(missing(im.convert)) {
im.path <- dir("C:/PROGRA~1", full.names=FALSE)[grep(pattern="ImageMagick", dir("C:/PROGRA~1", full.names=FALSE))]
im.convert <- gsub("/", "\\\\", dir(path=paste("C:/PROGRA~1", im.path, sep="/"), pattern="convert.exe", recursive=TRUE, full.names=TRUE))
  }
if(missing(im.identify)) {
im.identify <- gsub("/", "\\\\", dir(path=paste("C:/PROGRA~1", im.path, sep="/"), pattern="identify.exe", recursive=TRUE, full.names=TRUE))
  }
if(missing(google.earth)) {
ge.path <- dir("C:/PROGRA~1", full.names=FALSE)[grep(pattern="Google", dir("C:/PROGRA~1", full.names=FALSE))]
google.earth <- gsub("/", "\\\\", dir(path=paste("C:/PROGRA~1", ge.path, sep="/"), pattern="googleearth.exe$", recursive=TRUE, full.names=TRUE))
  }
if(missing(kml.url)) {
kml.url <- "http://www.opengis.net/kml/2.2"
  }
return(list(gdalwarp, gdal_translate, saga_cmd, im.convert, im.identify, kml.url))
  }
else { stop("Manually set paths to gdalwarp, saga_cmd and ImageMagick") }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
