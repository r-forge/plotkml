\name{kml}
\alias{kml}
\title{Write any \code{Spatial*}-derived or \code{Raster*} object to a KML file}
\description{
Writes any \code{Spatial*} object (from the sp package) or \code{Raster*} object (from the raster package) to a KML file. Various \emph{aesthetics}, i.e. ways to represent target variables, can be set via colour, transparency, size, width, shape arguments. Their availability depends on the class of the object to plot.
}
\usage{kml(obj, folder.name, file.name, overwrite = TRUE, kmz = FALSE, \dots)}
\arguments{
  \item{obj}{object inheriting from the \code{Spatial*} or the \code{Raster*} classes}
  \item{folder.name}{folder name text}
  \item{file.name}{output file name (*.kml)}
  \item{overwrite}{logical; overwrites the existing file}
  \item{kmz}{logical; specifies whether to compress the kml file}
\item{\dots}{additional aesthetics arguments (see details below)}
}
\value{A KML file. By default the object name with ".kml" extension.}
\author{Pierre Roudier, Tomislav Hengl and Dylan Beaudette}
\seealso{
\code{\link{kml_open}}, \code{\link{kml_close}}, \code{\link{kml_compress}}
}
\examples{
# Plotting a SpatialPointsDataFrame object
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
\dontrun{
# Simple plot
kml(eberg, file = "eberg-0.kml")
# Plot using aesthetics
kml(eberg, colour = SAND, size = CLAY, alpha = 0.75, file = "eberg-1.kml")}
# Plotting a SpatialPixelsDataFrame or a Raster* object
data(eberg_grid)
\dontrun{
kml(eberg_grid, colour = DEM, file = "eberg_grid-0.kml")
}
}
\keyword{ ~KML }
