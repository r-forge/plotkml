\name{grid2poly}
\alias{grid2poly}
\alias{grid2poly.SpatialGridDataFrame}
\title{Converts Gridded map to a polygon map}
\description{This function converts a SpatialGridDataFrame object to a polygon map with each not-NA grid node represented with an unique polygon. By default, it will convert any projected coordinates to the lat lon system (geographic coordinates in the WGS84 system), to allow further export to KML.}
\usage{
grid2poly(obj, var.name, reproject = TRUE, tmp.file = TRUE,  
method = "raster", saga_lib = "shapes_grid", saga_module = 3, ... )
}
\arguments{
  \item{obj}{SpatialGridDataFrame object}
  \item{var.name}{target variable column name}
  \item{reproject}{logical; reproject coordinates to lat lon system?}
  \item{method}{decide to convert grids to polygons either using \code{"sp"}, \code{"raster"} or \code{"RSAGA"} packages.}
  \item{saga_lib}{string; SAGA GIS library name.}
  \item{saga_module}{SAGA GIS module number; see \code{?rsaga_get_modules} for more details}
  \item{...}{additional arguments that can be parsed to the \code{rasterToPolygons} command}
}
\details{
This operation is not recommended for large grids (>>10e4 pixels). Consider splitting large input grids into tiles before running \code{grid2poly}. Conversion of large grids to polygons is more efficient by using SAGA GIS (\code{method = "RSAGA"}).
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{\link{vect2rast}}, \code{\link{raster::rasterToPolygons}}}
\examples{
data(eberg_grid)
data(SAGA_pal)
\dontrun{
x <- grid2poly(eberg_grid, "DEM")
spplot(x, col.regions=SAGA_pal[[1]])}
}
\keyword{polygon}
\keyword{grid}
