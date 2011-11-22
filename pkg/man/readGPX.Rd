\name{readGPX}
\alias{readGPX}
\title{Imports GPX (GPS track) files}
\description{Read various elements from a \preformatted{*.gpx} file --- metadata, waypoints, tracks and routes --- and converts them to dataframes.}
\usage{readGPX(gpx.file, metadata = TRUE, bounds = TRUE,
    waypoints = TRUE, tracks = TRUE, routes = TRUE)
}
\arguments{
  \item{gpx.file}{location of the gpx.file}
  \item{metada}{logical; species whether the metadata should be imported}
  \item{bounds}{logical; species whether the bounding box coordinates should be imported}
  \item{waypoint}{logical; species whether all waypoints should be imported}
  \item{track}{logical; species whether all tracks should be imported}
  \item{route}{logical; species whether all routes should be imported}
}
\details{\bold{Waypoint} is a point of interest, or named feature on a map. \bold{Track} is an ordered list of points describing a path. \bold{Route} is an ordered list of waypoints representing a series of turn points leading to a destination.
}
\references{
\itemize{
\item GPX data format (\url{http://www.topografix.com/gpx.asp})
\item XML tutorial (\url{http://www.omegahat.org/RSXML/Tour.pdf})
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{rgdal::readOGR}, \code{kml_layer.STIDFtraj}}
\examples{
\dontrun{
gpxbtour <- readGPX(system.file("btour.gpx", package="plotKML"))
str(gpxbtour)
fells_loop <- readGPX("http://www.topografix.com/fells_loop.gpx")
str(fells_loop)}
}
\keyword{GPX}
\keyword{GPS log}
\keyword{trajectory}
