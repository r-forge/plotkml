\name{vector2raster}
\alias{vector2raster}
\alias{points2raster}
\alias{lines2raster}
\alias{poly2raster}
\title{Converts Points, Lines and Polygons to rasters}
\description{This function converts any Spatial-PointsDataFrame, -LinesDataFrame, or -PolygonsDataFrame object to a raster map, and (optional) writes it to an external file (GDAL-supported formats). The cell size for output raster map is by default determined based on the density/size of features in the vector map.}
\usage{
vector2raster(obj, var.name = names(obj)[1], 
cell.size, bbox, file.name, ...)
}
\arguments{
  \item{obj}{Spatial-PointsDataFrame,-LinesDataFrame or -PolygonsDataFrame object.}
  \item{var.name}{Target variables in the \code{"data"} slot.}
  \item{cell.size}{(Optional) grid cell size in the output raster map.}
  \item{bbox}{(Optional) output bounding box (class \code{"bbox"}) for cropping the data.}
  \item{file.name}{(Optional) file name to export the resulting raster map.}
  \item{...}{Additional arguments to be parsed to the \code{rasterize} command.}
}
\details{
This function basically extends the \code{\link{rasterize}} function available in the raster package. \code{vector2raster}, however, requires no input from the user's side.\cr
The optimal grid cell size is estimated based on the density/size of features in the map: (a) in the case of SpatialPoints cell size is determined as half the mean distance between the nearest points; (b) in the case of SpatialLines half cell size is determined as half the mean distance between the lines; (c) in the case of polygon data cell size is determined as half the median size (area) of polygons of interest. For more details see Hengl (2006).
}
\references{
\itemize{
\item Hengl T., (2006) \href{http://dx.doi.org/10.1016/j.cageo.2005.11.008}{Finding the right pixel size}. Computers and Geosciences, 32(9): 1283-1298.
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{\link{raster::rasterize}}}
\examples{
data(eberg)

\dontrun{
x <- vector2raster(eberg)
image(x)
}
}
\keyword{rasterize}
