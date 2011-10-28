\name{plotKML.env}
\alias{plotKML.env}
\alias{paths}
\title{plotKML specific environmental variables / paths}
\description{The function automatically looks for FWTools, ImageMagick, Python, SAGA GIS, in the Windows Registry Hive, the Program Files directory or the usr/bin installation (Unix).}
\usage{plotKML.env(colour_scale_numeric = "", colour_scale_factor = "", ref_CRS = "",\cr
    kml_xsd = "", gpx_xsd = "", convert = "", gdalwarp = "", gdal_translate = "",\cr
    python = "", home_url = "", googleAPIkey = "", show.env = TRUE)}
\arguments{
  \item{colour_scale_numeric}{Default colour scheme for numeric variables.}
  \item{colour_scale_factor}{Default colour scheme for factor variables.}
  \item{NAflag}{The default missing value flag (usually \code{"-99999"}).}
  \item{ref_CRS}{Referent CRS proj4string (usually \code{"+proj=longlat +datum=WGS84"})}
  \item{kml_xsd}{Default KML scheme URL.}
  \item{gpx_xsd}{Default GPX scheme URL.}
  \item{convert}{Path to ImageMagick convert program.}
  \item{gdalwarp}{Path to FWTools gdalwarp program.}
  \item{gdal_translate}{Path to FWTools gdalwarp program.}
  \item{python}{Path to Python program.}
  \item{home_url}{Default location of all icons and auxiliary files.}
  \item{googleAPIkey}{(optional) Google API key required for some operations.}
}
\details{ The function will try to locate external software tools under either Windows or Unix platform and then save the results to \code{plotKML.opts} environment. \link{plotKML} does not look automatically for software paths (unless you specify this manually in your \preformatted{"Rprofile.site"}). \cr 
The external software tools are not required by default and most of operations in \link{plotKML} can be run without using them. FWTools, SAGA GIS and Python are highly recommended, however, for processing large data sets.
}
\references{
ImageMagick (\url{http://imagemagick.org})\cr
FWTools (\url{http://fwtools.maptools.org})\cr
SAGA GIS (\url{http://www.saga-gis.org})\cr
Python (\url{http://python.org})\cr
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\note{ To further customize plotKML options, consider putting \code{library(plotKML); plotKML.env(..., show.env = FALSE)} in your \preformatted{"/etc/Rprofile.site"}.
}
\section{Warning}{Under Linux OS make sure you add path to executable program by using e.g.:\cr 
\code{export PATH=INSTALL_DIRECTORY/FWTools-2.*.*/bin_safe:$PATH}
}
\examples{
\dontrun{
pts <- paths()
pts
# look for paths:
plotKML.env(silent = FALSE)
gdalwarp <- get("gdalwarp", envir = plotKML.opts)
system(paste(gdalwarp, "--help-general")) 
gdal.formats <- system(paste(gdalwarp, "--formats"), intern = TRUE)
}
plotKML.env(show.env = FALSE)
get("home_url", envir = plotKML.opts)
}
\keyword{ ~paths}
\keyword{environmental variables}
