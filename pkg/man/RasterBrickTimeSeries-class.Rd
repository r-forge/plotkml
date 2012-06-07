\name{RasterBrickTimeSeries-class}
\docType{class}
\alias{RasterBrickTimeSeries-class}
\alias{plotKML,RasterBrickTimeSeries}
\title{A class for a time series of regular grids}
\description{A class containing list of rasters, begin, end times and sample points to allow exploration of the values. Objects of this class can be directly visualized in Google Earth by using the \code{\link{plotKML-methods}}.}
\section{Slots}{
  \describe{    
    \item{\code{sampled}:}{object of class \code{"SpatialPoints"}; one or more points that can be used to visualize how the values of the feature change through time}
    \item{\code{rasters}:}{object of class \code{"RasterBrick"}; a time-series of raster objects}
    \item{\code{TimeSpan.begin}:}{object of class \code{"POSIXct"}; begin of sampling for each raster map}
    \item{\code{TimeSpan.end}:}{object of class \code{"POSIXct"}; end of sampling for each raster map}
  }
}
\section{Methods}{
  \describe{
	\item{plotKML}{\code{signature(obj = "RasterBrickTimeSeries")}: plots time-series of rasters in Google Earth}
  }
}
\author{ Tomislav Hengl }
\seealso{ \code{\link{RasterBrickSimulations-class}}, \code{\link{plotKML-methods}}
}
\keyword{classes}
