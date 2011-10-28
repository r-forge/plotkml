\name{kml}
\alias{kml}
\title{
Wrapper function to plot any Spatial* or Raster* object in a KML file.
}
\description{
This function allows the user to plot any Spatial* object (from the sp package) or Raster* object (from the raster package) to be plotted in a KML file. Various \emph{aesthetics}, i.e. ways to represent information, are provided (colour, transparency, size, shape, etc.). Their availability depends on the class of the object to plot.
}
\usage{kml(obj, ...)}
\arguments{
  \item{obj}{An object inheriting from the Spatial or the BasicRaster classes.}
\item{\dots}{Arguments interpreted in the context of kml() (see Details below)}
}
\value{A KML file located as per the file option.}
\author{Pierre Roudier, Tomislav Hengl, Dylan Beaudette}
\seealso{
\code{\link{kml_open}}, \code{\link{kml_close}}, \code{\link{kml_layer}}
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
\dontrun{
kml(eberg_grid, colour = DEM, file = "eberg_grid-0.kml")
}
}
\keyword{ ~KML }
