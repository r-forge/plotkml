\name{readGPX}
\title{Read GPX files to R}
\description{ Reads tracks, waypoints, routes and metadata to R.}
\usage{
readGPX(gpx.file, metadata = TRUE, bounds = TRUE, waypoints = TRUE, tracks = TRUE,    routes = TRUE)
}
\arguments{
  \item{gpx.file}{ File location or connection (*.GPX file) }
  \item{metadata}{ Read metadata? (logical) }
  \item{bounds}{ Read bounds? (logical) }
  \item{waypoints}{ Read waypoints? (logical) }
  \item{tracks}{ Read tracks? (logical) }
  \item{routes}{ Read routes? (logical) }
}
\details{ GPX is the GPS Exchange format, an XML data format for the interchange of GPS data (waypoints, routes, and tracks). A waypoint is a point of interest, or named feature on a map. A route is an ordered list of waypoints representing a series of turn points leading to a destination. A track is an ordered list of points describing a path. }
\references{ \url{http://www.topografix.com/gpx.asp} }
\author{ Tomislav Hengl (tom.hengl@wur.nl) }
\note{ }
\seealso{ \code{\link{readOGR}}, \code{\link{pgirmess::gps2gpx}}, \code{\link{pgirmess::uploadGPX}}}
\examples{
con <- "http://www.topografix.com/fells_loop.gpx"
fells <- readGPX(con)
fells[["waypoints"]][1,]
}
