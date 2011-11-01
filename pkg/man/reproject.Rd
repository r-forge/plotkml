\name{reproject}
\alias{reproject}
\alias{reproject.SpatialPoints}
\alias{reproject.SpatialPixels}
\alias{reproject.RasterLayer}
\alias{reproject.RasterStack}
\alias{reproject.RasterBrick}
\title{Reprojects data to a given coordinate reference system}
\description{This function reprojects spatial data to a given coordinate reference system (CRS), defaulted to geographic coordinates.}
\usage{reproject(obj, CRS = get("ref_CRS", envir = plotKML.opts), ..., program = "raster")}
\arguments{
  \item{obj}{A Spatial* or Raster* object.}
  \item{CRS}{Proj4string. See also \code{\link{rgdal::CRS-class}}.}
  \item{\dots}{Arguments evaluated in the context of function projectRaster from the raster package.}
  \item{program}{Default method used for reprojecting vectors / grids.}
}
\details{
In the case of raster and/or gridded maps, by selecting \code{program = "FWTools"} \code{gdalwarp} functionality is initiated.
}
\references{
Raster package (\url{http://CRAN.R-project.org/package=raster})
}
\author{Pierre Roudier (\email{pierre.roudier@gmail.com}), Tomislav Hengl (\email{tom.hengl@wur.nl}) and Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\section{Warning}{\code{obj} needs to have a proper proj4 string (CRS), otherwise \code{reproject} will not run.}
\seealso{\code{\link{raster::projectRaster}}}
\examples{
# Example with vector data
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
eberg.geo <- reproject(eberg)
# Example with raster data
data(eberg_grid)
\dontrun{eberg_grid.geo <- reproject(eberg_grid)}
# Using FWTools:
\dontrun{eberg_grid.geo <- reproject(eberg_grid, program = "FWTools")}
# Optional: compare processing times:
system.time(eberg_grid_ll <- reproject(eberg_grid[1]))
system.time(eberg_grid_ll <- reproject(eberg_grid[1], program="FWTools"))
}
\keyword{ ~projection}
