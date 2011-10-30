\name{readGPX}
\alias{readGPX}
\alias{.readGPX.element}
\title{Imports GPX (GPS track) files to R}
\description{Read various elements from a \preformatted{*.gpx} file - metadata, waypoints, tracks and routes - and converts them to tables.}
\usage{readGPX(gpx.file, metadata = TRUE, bounds = TRUE,
    waypoints = TRUE, tracks = TRUE, routes = TRUE)
}
\arguments{
  \item{gpx.file}{Location of the gpx.file}
  \item{metada}{Logical; should the metadata be imported?}
  \item{bounds}{Logical; should bounding box coordinates be imported?}
  \item{waypoint}{Logical; should all waypoints be imported?}
  \item{track}{Logical; should all tracks be imported?}
  \item{route}{Logical; should all routes be imported?}
}
\details{\bold{Waypoint} is a point of interest, or named feature on a map. \bold{Track} is an ordered list of points describing a path. \bold{Route} is an ordered list of waypoints representing a series of turn points leading to a destination.
}
\references{
GPX data format (\url{http://www.topografix.com/gpx.asp})\cr
XML tutorial (\url{http://www.omegahat.org/RSXML/Tour.pdf})
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{\link{rgdal::readOGR}}, \code{\link{kml_layer.STIDFtraj}}}
\examples{
\dontrun{
gpxbtour <- readGPX(system.file("btour.gpx", package="plotKML"))
str(gpxbtour)

fells_loop <- readGPX("http://www.topografix.com/fells_loop.gpx")
str(fells_loop)
}
}
\keyword{GPX}
\keyword{GPS log}
\keyword{trajectory}
