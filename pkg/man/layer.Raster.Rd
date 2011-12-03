\name{kml_layer.Raster}
\alias{kml_layer.Raster}
\alias{RasterLayer}
\alias{RasterStack}
\alias{SpatialPixels}
\title{Exports a single or a stack of rasters to KML}
\description{Writes rasters to PNG images (ground overlays). Works with \code{"RasterLayer"}, \code{"SpatialGrid"}, \code{"SpatialPixels"} and \code{"RasterStack"} class objects. Target attributes can be specified using aesthetics arguments (\code{"colour"}).}
\usage{
kml_layer.Raster(obj, metadata = FALSE, plot.legend = TRUE, \dots
  colour_scale = get("colour_scale_numeric", envir = plotKML.opts), \dots)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{metadata}{(optional) specify the metadata object}
  \item{plot.legend}{logical; specify whether a map legend should be generated automatically}
  \item{\dots}{additional style arguments (see \code{\link{aesthetics}})}
  \item{colour_scale}{color palette; by default using the color scale for numeric variables}
  \item{alpha}{variable to be used to set transparency}
  \item{altitude}{if not a 3D object; variable to be used to specify altitude above ground}
  \item{altitudeMode}{altitude mode type (\code{"clampToGround"}, \code{"relativeToGround"} or \code{"absolute"})}  
}
\details{Google Earth does not properly handle a 24-bit PNG file which has a single transparent color (read more at \href{http://groups.google.com/group/earth-help/}{Google Earth Help}). To force transparency, plotKML will try to set it using the \code{-matte -transparent "\#FFFFFF"} option in the \href{http://www.imagemagick.org/Usage/masking/}{ImageMagick convert program} (ImageMagick needs to be installed separately and located using \code{plotKML.env()}).
}
\author{Tomislav Hengl, Pierre Roudier and Dylan Beaudette}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{kml_layer.RasterBrick}} }
\examples{
data(eberg_grid)
data(SAGA_pal)
\dontrun{
# KML plot with a single raster:
kml(eberg_grid, colour_scale = SAGA_pal[[1]], colour = TWI)}
}
\keyword{ ~KML}
\keyword{ RasterLayer}

