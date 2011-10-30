\name{baranja}
\docType{data}
\encoding{UTF-8}
\alias{baranja_elev}
\alias{baranja_stream}
\title{Baranja hill case study}
\description{Baranja hill is a 4 by 4 km large study area in the Baranja region, eastern Croatia (corresponds to a size of an aerial photograph). This data set has been extensively used to describe various DEM modelling and analysis steps (Hengl and Reuter, 2008; Hengl et al., 2010). \cr
\code{baranja_elev} is a \code{SpatialPointsDataFrame} object that contains 6370 observations of elevations (from field survey and digitized from the stereo images). \code{baranja_stream} contains \emph{observed} probabilities of streams (digitized from the 1:5000 topo map).}
\usage{data(baranja_elev)}
\author{ Tomislav Hengl (\email{tom.hengl@wur.nl}). }
\references{
Hengl, T., Reuter, H.I. (eds), (2008) \href{http://geomorphometry.org/book}{Geomorphometry: Concepts, Software, Applications}. Developments in Soil Science, vol. 33, Elsevier, 772 p.\cr 
Hengl, T., Heuvelink, G. B. M., van Loon, E. E., (2010) \href{http://dx.doi.org/10.5194/hess-14-1153-2010}{On the uncertainty of stream networks derived from elevation data: the error propagation approach}. Hydrology and Earth System Sciences, 14:1153-1165.\cr
\url{http://geomorphometry.org/content/baranja-hill}
}
\note{ Consider using the 30~m resolution grid (see \code{baranja_stream}) to produce the output maps. 
}
\examples{
data(baranja_elev)
data(baranja_stream)
\dontshow{str(baranja_stream)}
coordinates(baranja_stream) <- ~x+y
gridded(baranja_stream) <- TRUE
proj4string(baranja_stream) <- baranja_elev@proj4string
\dontshow{str(baranja_stream)}
baranja_stream@grid
\dontrun{spplot(baranja_stream[1], sp.layout=list("sp.points", baranja_elev, col="black", pch="+"))}
}
\keyword{datasets}
