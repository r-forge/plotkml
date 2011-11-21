\name{geopath}
\alias{geopath}
\title{Geopath --- shortest trajectory line between two geographic locations}
\description{Derives a SpatialLines class object showing the shortest path between geographic locations and based on the Haversine Formula for Great Circle distance.}
\usage{
geopath(lon1, lon2, lat1, lat2, ID, n.points, print.geo = FALSE)
}
\arguments{
  \item{lon1}{longitude coordinate of the first point}
  \item{lon2}{longitude coordinate of the second point}
  \item{lat1}{latitude coordinate of the first point}
  \item{lat2}{latitude coordinate of the second point}
  \item{ID}{point ID vector}
  \item{n.points}{number of intermediate points}
  \item{print.geo}{prints the distance and bearing}
}
\details{The formula to derive number of points between the start and end point is: \code{round(sqrt(distc)/sqrt(2), 0)} where \code{distc} is the Great Circle Distance.}
\value{Bearing is expressed in degrees from north. Distance is expressed in kilometers (Great Circle Distance).}
\references{
\itemize{
\item fossil package (\url{http://CRAN.R-project.org/package=fossil})
\item Haversine formula from Math Forums (\url{http://mathforum.org/dr.math/})
}
}
\author{ Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{ \code{\link{kml_layer.SpatialLines}}, \code{\link{kml_layer.STIDFtraj}}, \code{fossil::earth.bear}}
\examples{
ams.ny <- geopath(lon1=4.892222, lon2=-74.005973, lat1=52.373056, lat2=40.714353, print.geo=TRUE)
kml(ams.ny)}
\keyword{ ~path }
\keyword{ ~bearing }
