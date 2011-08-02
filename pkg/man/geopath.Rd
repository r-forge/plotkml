\name{geopath}
\alias{geopath}
\title{Path (shortest trajectory) between two geographic locations
}
\description{ Derives a SpatialLines class object between geographic locations based on the Haversine Formula for Great Circle distance.
}
\usage{
geopath(lon1, lon2, lat1, lat2, ID, n.points, print.geo = FALSE)
}
\arguments{
  \item{lon1}{ Longitude coordinate of the first point
}
  \item{lon2}{ Longitude coordinate of the second point
}
  \item{lat1}{ Latitude coordinate of the first point
}
  \item{lat2}{ Latitude coordinate of the second point
}
  \item{ID}{ Point ID vector
}
  \item{n.points}{ Number of intermediate points
}
  \item{print.geo}{ Prints the distance and bearing
}
}
\details{  The formula to derive number of points between start and end point is: \code{round(sqrt(distc)/sqrt(2), 0)} where \code{distc} is the Great Circle Distance.  
}
\value{ Bearing is expressed in degrees from north. Distance is expressed in kilometers (Great Circle Distance).
}
\author{ Tomislav Hengl
}
\note{
}

\seealso{ \code{\link{kml_layer.Trajetory}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
ams.ny <- geopath(lon1=4.892222, lon2=-74.005973, lat1=52.373056, lat2=40.714353, print.geo=TRUE)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
