\name{grid2poly}
\alias{grid2poly}
\alias{grid2poly.SpatialGridDataFrame}
\title{Converts Gridded map to a polygon map}
\description{This function converts a SpatialGridDataFrame object to a polygon map with each not-NA grid node represented with an unique polygon. By default, it will convert any projected coordinates to the lat lon system (geographic coordinates in the WGS84 system), to allow further export to KML.}
\usage{
grid2poly(obj, var.name, reproject = TRUE,  
saga_lib = "shapes_grid", saga_module = 3, method = "sp", ... )
}
\arguments{
  \item{obj}{SpatialGridDataFrame object.}
  \item{var.name}{Target variable column name.}
  \item{reproject}{Logical. Reproject coordinates to lat lon system?}
  \item{saga_lib}{SAGA GIS library.}
  \item{saga_module}{SAGA GIS module number. See \code{?rsaga_get_modules} for more details.}
  \item{method}{Convert grids to polygons either using \code{"sp"}, \code{"raster"} or \code{"RSAGA"} packages.}
  \item{...}{Additional arguments that can be parsed to the \code{rasterToPolygons} command.}
}
\details{
This operation is not recommended for large grids (>>10e4 pixels). Consider splitting large input grids into tiles before running \code{grid2poly}.\cr
Conversion of large grids to polygons is more efficient by using SAGA GIS (\code{method = "RSAGA"}).
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\link{\code{vector2raster}}, \link{\code{raster::rasterToPolygons}}}
\examples{
data(eberg_grid)
data(SAGA_pal)
\dontrun{
x <- grid2poly(eberg_grid, "DEM")
spplot(x, col.regions=SAGA_pal[[1]])
}
}
\keyword{polygon}
\keyword{grid}
