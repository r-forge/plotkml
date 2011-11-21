\name{reproject}
\alias{reproject}
\alias{reproject.SpatialPoints}
\alias{reproject.SpatialGrid}
\alias{reproject.RasterLayer}
\alias{reproject.RasterStack}
\alias{reproject.RasterBrick}
\title{Reprojects data to a given coordinate reference system}
\description{This wrapper function reprojects any vector or raster spatial data to some referent coordinate system (geographic coordinates on the World Geodetic System of 1984 / WGS84 datum).}
\usage{reproject(obj, CRS = get("ref_CRS", envir = plotKML.opts), ..., program = "raster")}
\arguments{
  \item{obj}{Spatial* or Raster* object}
  \item{CRS}{proj4string; see also \code{\link{rgdal::CRS-class}}}
  \item{\dots}{arguments evaluated in the context of function \code{projectRaster} from the raster package}
  \item{program}{default method used for reprojecting vectors / grids; \code{"raster"} or \code{"FWTools"}}
}
\details{
In the case of raster and/or gridded maps, by selecting \code{program = "FWTools"} \code{gdalwarp} functionality is initiated. This requires that \href{http://fwtools.maptools.org}{FWTools} are installed and listed via \code{paths()}. FWTools includes OpenEV, GDAL, MapServer, PROJ.4 and OGDI.
}
\references{
\itemize{
\item Raster package (\url{http://CRAN.R-project.org/package=raster})
\item FWTools (\url{http://fwtools.maptools.org})
}
}
\author{Pierre Roudier (\email{pierre.roudier@gmail.com}), Tomislav Hengl (\email{tom.hengl@wur.nl}) and Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\section{Warning}{\code{obj} needs to have a proper proj4 string (CRS), otherwise \code{reproject} will not run.}
\seealso{\code{\link{paths}}, \code{raster::projectRaster}, \code{rgdal::spTransform}}
\examples{
# Example with vector data
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
eberg.geo <- reproject(eberg)
# Example with raster data
data(eberg_grid)
\dontrun{
eberg_grid.geo <- reproject(eberg_grid)}
# Using FWTools:
\dontrun{
eberg_grid.geo <- reproject(eberg_grid, program = "FWTools")}
# Optional: compare processing times:
system.time(eberg_grid_ll <- reproject(eberg_grid[1]))
system.time(eberg_grid_ll <- reproject(eberg_grid[1], program="FWTools"))}
\keyword{ ~projection}
\keyword{ proj4}
\keyword{ WGS84}
