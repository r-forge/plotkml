\name{LST}
\docType{data}
\encoding{latin1}
\title{Time series of MODIS LST images (estimated Land Surface Temperature in degrees C) at 1 km resolution}
\description{\code{LST} contains a spatial sub-sample (Istra region in Croatia) of 46 time series of MODIS LST images (estimated Land Surface Temperature in degrees C) at 1 km resolution. The \code{"zvalue"} slot in the \code{LST} object is the dateTime column expressed as yyyy-mm-ddThh:mm:sszzzzzz, where T is the separator between the date and the time, and the time zone is either Z (for UTC) or zzzzzz, which represents \enc{±}{+-}hh:mm in relation to UTC. The temporal support of these images is 8-days.
}
\usage{data(LST)}
\format{
The \code{LST} is \code{"RasterBrick"} object with the following layers:
  \describe{
	\item{\code{LST2008_01_01}}{8-day MODIS LST mosaick for period 2007-12-29 to 2008-01-04}
	\item{\code{LST2008_01_09}}{8-day MODIS LST mosaick for period 2008-01-05 to 2008-01-13}
	\item{\code{...}}{...}
  }
} 
\author{ Tomislav Hengl (\email{tom.hengl@wur.nl}) and Melita Percec Tadic (\email{melita@cirus.dhz.hr}) }
\references{
\itemize{
\item Hengl, T., Heuvelink, G.B.M., Percec Tadic, M., Pebesma, E., (2011) \href{http://dx.doi.org/10.1007/s00704-011-0464-2}{Spatio-temporal prediction of daily temperatures using time-series of MODIS LST images}. Theoretical and Applied Climatology.
\item MODIS products (\url{https://lpdaac.usgs.gov/lpdaac/products/modis_products_table/})
}
}
\note{Time series of 46 day-time and night-time 8-day composite LST images (\href{https://lpdaac.usgs.gov/lpdaac/products/modis_products_table/land_surface_temperature_emissivity/8_day_l3_global_1km/mod11a2}{MOD11A2} product bands \code{1} and \code{5}) was obtained from the NASA's FTP server (\url{ftp://e4ftl01u.ecs.nasa.gov}). The original 8-day composite images were created by patching together images from a period of \enc{±}{+-}4 days, so that the proportion of clouds can be reduced to a minimum.}
\examples{
data(LST)
\dontrun{
## Plot temperatures, precipitation and MODIS images in Google Earth:

# to obtain the complete data set for whole Croatia use:
load(url("http://plotkml.r-forge.r-project.org/MODLST.rda"))}
}
\keyword{datasets}
