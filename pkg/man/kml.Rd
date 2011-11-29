\name{kml}
\alias{kml}
\title{
Wrapper function to plot any Spatial* or Raster* object in a KML file.
}
\description{
This function allows the user to plot any Spatial* object (from the sp package) or Raster* object (from the raster package) to be plotted in a KML file. Various \emph{aesthetics}, i.e. ways to represent information, are provided (colour, transparency, size, shape, etc.). Their availability depends on the class of the object to plot.
}
\usage{kml(obj, folder.name, file.name, overwrite = TRUE, kmz = FALSE, \dots)}
\arguments{
  \item{obj}{object inheriting from the \code{Spatial*} or the \code{Raster*} classes}
  \item{folder.name}{folder name text}
  \item{file.name}{output file name (*.kml)}
  \item{overwrite}{logical; overwrites the existing file}
  \item{kmz}{logical; specifies whether to compress the kml file}
\item{\dots}{Arguments interpreted in the context of \code{kml()} (see details below)}
}
\value{A KML file located as per the file option.}
\author{Pierre Roudier (\email{pierre.roudier@landcare.nz}), Tomislav Hengl (\email{tom.hengl@wur.nl}), Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
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
kml(eberg, colour = SAND, size = CLAY, alpha = 0.75, file = "eberg-1.kml")}
# Plotting a SpatialPixelsDataFrame or a Raster* object
data(eberg_grid)
\dontrun{
kml(eberg_grid, colour = DEM, file = "eberg_grid-0.kml")}
}
\keyword{ ~KML }
