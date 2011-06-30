\name{twopoints2path}
\alias{twopoints2path}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
twopoints2path(lon1, lon2, lat1, lat2, ID, n.points, print.geo)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{lon1}{
%%     ~~Describe \code{lon1} here~~
}
  \item{lon2}{
%%     ~~Describe \code{lon2} here~~
}
  \item{lat1}{
%%     ~~Describe \code{lat1} here~~
}
  \item{lat2}{
%%     ~~Describe \code{lat2} here~~
}
  \item{ID}{
%%     ~~Describe \code{ID} here~~
}
  \item{n.points}{
%%     ~~Describe \code{n.points} here~~
}
  \item{print.geo}{
%%     ~~Describe \code{print.geo} here~~
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
function(lon1, lon2, lat1, lat2, ID, n.points, print.geo) {
# lon / lat = geographical coordinates on WGS84
# n.points = number of intermediate points (derived by the model)
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
  } else {
routes <- Lines(list(Line(matrix(rbind(p.1, pnts, p.2),ncol=2))), ID=as.character(ID)) } 
  } } 
# create SpatialLines:
path <- SpatialLines(list(routes), CRS("+proj=longlat +datum=WGS84"))
  }
return(path)
if(missing(print.geo)) { print.geo <- TRUE } 
if(print.geo==TRUE) {
print(paste("Distance:", distc))
print(paste("Bearing:", bearingc))
  }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
