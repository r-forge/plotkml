\name{gpxbtour}
\title{GPS log of a bike ride}
\description{
GPS log of a bike tour from Wageningen to Muenster. The table contains 3228 records of GPS locations, speed and elevation.  
}
\format{
  The data frame contains the following columns:
  \describe{
    \item{lon}{geographic longitude}
    \item{lat}{geographic latitude}
     \item{ele}{GPS-estimated elevation in m}
	\item{speed}{GPS-estimated speed in km per hour}
  \item{time}{XML Schema time}
} 
} 
\usage{
data(gpxbtour)
}
\author{ Tomislav Hengl (tom.hengl@wur.nl) }
\note{ The log was produced using the GlobalSat GH-615 GPS watch. The data log (trackpoints) was first saved to GPX exchange format (\url{http://www.topografix.com/gpx.asp}) and then imported to R using the XML package and formatted to a data frame.
}
\seealso{\link{eberg_contours}}
\keyword{datasets}
\examples{
data(gpxbtour)
# str(gpxbtour)
## format the time column:
gpxbtour$ctime <- as.POSIXct(gpxbtour$time, format="\%Y-\%m-\%dT\%H:\%M:\%SZ")
coordinates(gpxbtour) <- ~lon+lat
proj4string(gpxbtour) <- CRS("+proj=longlat +datum=WGS84")
## derive distance from origin:
require(fossil)
xy <- as.list(data.frame(t(coordinates(gpxbtour))))
gpxbtour$dist.km <- sapply(xy, function(x) deg.dist(long1=x[1], lat1=x[2], long2=xy[[1]][1], lat2=xy[[1]][2]))
plot(gpxbtour$dist.km, gpxbtour$speed, type="l", xlab="Distance from origin in km", ylab="speed in km per hour")
# convert to a STIDFtraj class:
require(spacetime)
require(adehabitatLT)
gpx.ltraj <- as.ltraj(coordinates(gpxbtour), gpxbtour$ctime, id = "th")
gpx.st <- as(gpx.ltraj, "STIDFtraj")
gpx.st$speed <- gpxbtour$speed
gpx.st@sp@proj4string <- CRS("+proj=longlat +datum=WGS84")
# open KML file:
kml_open("gpxbtour.kml", overwrite = TRUE)
# plot trajectory with speed as colour attribute:
kml_layer(obj=gpx.st, colour=speed, z.lim=c(18,32))
# close KML:
kml_close()
kml_compress("gpxbtour.kml")
}
