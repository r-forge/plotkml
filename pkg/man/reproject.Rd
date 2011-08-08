\name{reproject}
\alias{reproject}
\alias{reproject.SpatialPoints}
\alias{reproject.SpatialPixels}
\alias{reproject.RasterLayer}
\alias{reproject.RasterStack}
\alias{reproject.RasterBrick}


\title{Reprojects data to a givan coordinate reference system}

\description{This function reprojects spatial data to a given coordinate reference system (CRS), defaulted to geographic coordinates.}

\usage{reproject(obj, ...)}

\arguments{
  \item{obj}{A Spatial* or Raster* object}
  \item{\dots}{Arguments evaluated in the context of function projectRaster from the raster package}
}

\details{
%%  ~~ If necessary, more details than the description above ~~
}

\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}

\references{
%% ~put references to the literature/web site here ~
}

\author{Pierre Roudier and Dylan Beaudette}

\note{
%%  ~~further notes~~
}

\section{Warning }{\code{obj} needs to have been affected a CRS, other wise \code{reproject} could not be applied properly.}

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}

\examples{
# Example on vector data
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
eberg.geo <- reproject(eberg)

# Example on raster data
data(eberg_grid)
# NOT RUN
# eberg_grid.geo <- reproject(eberg_grid)
}

\keyword{ ~projection}
