\name{reproject}
\alias{reproject}
\alias{reproject.SpatialPoints}
\alias{reproject.SpatialPixels}
\alias{reproject.RasterLayer}
\alias{reproject.RasterStack}
\alias{reproject.RasterBrick}
\title{Reprojects data to a given coordinate reference system}
\description{This function reprojects spatial data to a given coordinate reference system (CRS), defaulted to geographic coordinates.}
\usage{reproject(obj, ...)}
\arguments{
  \item{obj}{A Spatial* or Raster* object}
  \item{\dots}{Arguments evaluated in the context of function projectRaster from the raster package}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\references{
%% ~put references to the literature/web site here ~
}
\author{Pierre Roudier and Dylan Beaudette}
\note{
}
\section{Warning}{\code{obj} needs to have a proper proj4 string (CRS), other wise \code{reproject} will not run.}
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
\dontrun{eberg_grid.geo <- reproject(eberg_grid)}
}
\keyword{ ~projection}
