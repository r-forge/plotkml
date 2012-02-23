\name{kml-methods}
\docType{methods}
\alias{kml}
\alias{kml-methods}
\alias{plotKML.fileIO}
\alias{kml.Spatial}
\alias{kml,Raster-method}
\alias{kml,STIDF-method}
\alias{kml,SoilProfileCollection-method}
\alias{kml,Spatial-method}
\alias{kml,SpatialPhotoOverlay-method}
\title{Write to a KML file}
\description{
Writes any \code{Spatial*} object (from the sp package) or \code{Raster*} object (from the raster package) to a KML file via the \code{plotKML.fileIO} environment. Various \emph{aesthetics} parameters can be set via \code{colour}, \code{alpha}, \code{size}, \code{shape} arguments. Their availability depends on the class of the object to plot.
}
\usage{kml(obj, \dots)}
\arguments{
  \item{obj}{object inheriting from the \code{Spatial*} or the \code{Raster*} classes}
  \item{\dots}{additional aesthetics arguments (see details below)}
}
\value{A KML file. By default parses the object name and adds a ".kml" extension.}
\details{To \code{kml} you can also pass \code{folder.name}, \code{file.name} (output file name *.kml), \code{overwrite} (logical; overwrites the existing file) and \code{kmz} (logical; specifies whether to compress the kml file) arguments.
}
\author{Pierre Roudier, Tomislav Hengl and Dylan Beaudette}
\seealso{
\code{\link{kml_open}}, \code{\link{kml_aes}}, \code{\link{kml_close}}, \code{\link{kml_compress}}
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
kml(eberg, colour = SAND, size = CLAY, alpha = 0.75, file = "eberg-1.kml")
}
# Plotting a SpatialPixelsDataFrame or a Raster* object
data(eberg_grid)
coordinates(eberg_grid) <- ~x+y
gridded(eberg_grid) <- TRUE
proj4string(eberg_grid) <- CRS("+init=epsg:31467")
\dontrun{
kml(eberg_grid, colour = DEM, file = "eberg_grid-0.kml")
}
}
\keyword{spatial}
\keyword{methods}