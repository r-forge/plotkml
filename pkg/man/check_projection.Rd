\name{check_projection}
\alias{check_projection}
\alias{parse_proj4}
\title{Extracts the proj4 parameters and checks if the projection matches the referent CRS}
\description{Function \code{parse_proj4} gets the proj4 string from a space-time object and \code{check_projection} checks if the input projection is compatible with the referent projection system. The referent system is by default the `latlon' projection with `WGS84' datum (KML-compatible coordinates).}
\usage{check_projection(obj, logical = TRUE, ref_CRS = get("ref_CRS", envir = plotKML.opts))}
\arguments{
  \item{obj}{object of class \code{Spatial*} or \code{Raster*}}
  \item{logical}{logical; if TRUE, a logical value is returned, if FALSE, an error is thrown if the test failed}
  \item{ref_CRS}{the referent coordinate system.}
}
\details{
A cartographic projection is KML compatible if: (a) geographical coordinates are used, and (b) that relate to the WGS84 ellispoid (\code{"+proj=longlat +datum=WGS84"}). You can also set your own local referent projection system by specifiying \code{plotKML.env(ref_CRS = ...)}.
}
\references{
WGS84 (\url{http://spatialreference.org/ref/epsg/4326/})
}
\author{Pierre Roudier (\email{pierre.roudier@gmail.com}), Tomislav Hengl (\email{tom.hengl@wur.nl}), and Dylan Beaudette (\email{debeaudette@ucdavis.edu)}}
\section{Warning}{\code{obj} needs to have a proper proj4 string (CRS), otherwise \code{check_projection} will not run.}
\seealso{\code{\link{reproject}}, \code{rgdal::CRS-class}}
\examples{
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
check_projection(eberg)
# not yet ready for export to KML;
parse_proj4(proj4string(eberg))
eberg.geo <- reproject(eberg)
check_projection(eberg.geo)
# now ready for export;
}
\keyword{ ~projection}
