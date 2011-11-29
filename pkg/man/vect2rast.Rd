\name{vect2rast}
\alias{vect2rast}
\alias{rasterize}
\title{Converts Points, Lines and Polygons to rasters}
\description{This function converts any Spatial-PointsDataFrame, -LinesDataFrame, or -PolygonsDataFrame object to a raster map, and (optional) writes it to an external file (GDAL-supported formats). The cell size for output raster map is by default determined based on the density/size of features in the vector map.}
\usage{
vect2rast(obj, var.name = names(obj)[1], cell.size, bbox, file.name, \dots)
}
\arguments{
  \item{obj}{Spatial-PointsDataFrame,-LinesDataFrame or -PolygonsDataFrame object}
  \item{var.name}{target variables in the \code{"data"} slot}
  \item{cell.size}{(optional) grid cell size in the output raster map}
  \item{bbox}{(optional) output bounding box (class \code{"bbox"}) for cropping the data}
  \item{file.name}{(optional) file name to export the resulting raster map}
  \item{\dots}{additional arguments to be passed to the \code{rasterize} command}
}
\details{
This function basically extends the \code{\link{rasterize}} function available in the raster package. the advantage of \code{vect2rast} is that it requires no input from the user's side i.e. it automatically determines the grid cell size based on the properties of the input data set.\cr
The optimal grid cell size is estimated based on the density/size of features in the map (\code{nndist} function in \href{http://www.spatstat.org}{spatstat} package): (a) in the case of SpatialPoints cell size is determined as half the mean distance between the nearest points; (b) in the case of SpatialLines half cell size is determined as half the mean distance between the lines; (c) in the case of polygon data cell size is determined as half the median size (area) of polygons of interest. For more details see \href{http://dx.doi.org/10.1016/j.cageo.2005.11.008}{Hengl (2006)}.
}
\references{
\itemize{
\item Hengl T., (2006) \href{http://dx.doi.org/10.1016/j.cageo.2005.11.008}{Finding the right pixel size}. Computers and Geosciences, 32(9): 1283-1298.
\item SpatStat package (\url{http://www.spatstat.org})
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{raster::rasterize}, \code{spatstat::nndist}}
\examples{
data(eberg)
coordinates(eberg) <- ~X+Y
\dontrun{
x <- vect2rast(eberg)
image(x)}
}
\keyword{rasterize}
\keyword{raster}
