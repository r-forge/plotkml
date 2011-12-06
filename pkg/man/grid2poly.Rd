\name{grid2poly}
\alias{grid2poly}
\title{Converts a gridded map to a polygon map}
\description{Converts a SpatialGridDataFrame object to a polygon map with each available grid node represented with a polygon. To allow further export to KML, \code{grid2poly} will, by default, convert any projected coordinates to the lat-lon system (geographic coordinates in the WGS84 system).}
\usage{
grid2poly(obj, var.name, reproject = TRUE, tmp.file = TRUE,  
    method = c("raster", "sp", "RSAGA")[1], saga_lib = "shapes_grid", 
    saga_module = 3, \dots)
}
\arguments{
  \item{obj}{SpatialGridDataFrame object}
  \item{var.name}{target variable column name}
  \item{reproject}{logical; reproject coordinates to lat lon system?}
  \item{method}{decide to convert grids to polygons either using \code{"sp"}, \code{"raster"} or \code{"RSAGA"} packages}
  \item{saga_lib}{string; SAGA GIS library name}
  \item{saga_module}{SAGA GIS module number; see \code{?rsaga_get_modules} for more details}
  \item{\dots}{additional arguments that can be parsed to the \code{rasterToPolygons} command}
}
\details{\code{grid2poly} is not recommended for large grids (>>10e4 pixels). Consider splitting large input grids into tiles before running \code{grid2poly}. For converting large grids to polygons we recommend using SAGA GIS (\code{method = "RSAGA"}).}
\author{Tomislav Hengl }
\seealso{\code{\link{vect2rast}}, \code{raster::rasterToPolygons}}
\examples{
data(eberg_grid)
data(SAGA_pal)
\dontrun{
system.time(dem_poly <- grid2poly(eberg_grid, "DEM", method = "raster"))
system.time(dem_poly <- grid2poly(eberg_grid, "DEM", method = "sp"))
system.time(dem_poly <- grid2poly(eberg_grid, "DEM", method = "RSAGA"))
# spplot (plotting large polygons in R = not a good idea):
spplot(dem_poly, col.regions = SAGA_pal[[1]])
# plotKML:
kml(dem_poly, colour_scale = SAGA_pal[[1]], colour = DEM, kmz = TRUE)
}
}
\keyword{polygon}
\keyword{grid cell}
