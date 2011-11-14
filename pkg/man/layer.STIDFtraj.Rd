\name{kml_layer.STIDFtraj}
\alias{STIDFtraj}
\title{Parse a space-time trajectory object to KML}
\description{Writes a space-time trajectory object to a KML file and (optional) attaches attributes.
}
\usage{
kml_layer.STIDFtraj(obj, obj.title, id.name, dtime = 0, extrude = FALSE,
  start.icon, end.icon, LabelScale, z.scale = 1, metadata = FALSE, html.table = NULL)
}
\arguments{
  \item{obj}{space-time object of class \code{"STIDFraj"} (spatio-temporal irregular data.frames trajectory)}
  \item{obj.title}{object title that will be inserted in the folder name}
  \item{id.name}{trajectory ID column name}
  \item{dtime}{temporal support - point or block}
  \item{extrude}{logical; extrude GPS vertices?}
  \item{start.icon}{start icon name (3Dballyellow.png)}
  \item{end.icon}{destination icon name (golfhole.png)}
  \item{LabelScale}{the default size of icons}
  \item{z.scale}{vertical exaggeration}
  \item{metadata}{logical; should metadata be printed?}
  \item{html.table}{optional description block (html) for each GPS point (vertices)}
}
\details{The dateTime is defined as yyyy-mm-ddThh:mm:sszzzzzz, where T is the separator between the date and the time, and the time zone is either Z (for UTC) or zzzzzz, which represents \\enc{±}{+-}hh:mm in relation to UTC. For more info on how Time Stamps work see \url{http://kml-samples.googlecode.com}. If the time is measured at block support, then \code{<TimeStamp><begin> </begin><end> </end></TimeStamp>} times will be inserted. Temporal support (\eqn{\Delta t}{dt}) is estimated using the \code{xts::periodicity} function (median time between observations). The begin time is then derived as \eqn{t_1 = t - .5\cdot \Delta t}{t1 = t - .5 d t}.
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{readGPX}} }
\examples{
data(gpxbtour)
# format the time column:
gpxbtour$ctime <- as.POSIXct(gpxbtour$time, format="\%Y-\%m-\%dT\%H:\%M:\%SZ")
coordinates(gpxbtour) <- ~lon+lat
proj4string(gpxbtour) <- CRS("+proj=longlat +datum=WGS84")
\dontrun{
# derive distance from origin:
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
kml_open("gpxbtour_speed.kml")
# plot trajectory with speed as colour attribute:
kml_layer(obj=gpx.st, colour=speed, z.lim=c(18,32))
# close KML:
kml_close("gpxbtour_speed.kml")
kml_compress("gpxbtour_speed.kml")}
}
\keyword{ ~KML}

