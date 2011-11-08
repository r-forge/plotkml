\name{dailymeteo}
\docType{data}
\encoding{UTF-8}
\alias{HRtemp08}
\alias{HRprec08}
\alias{LST}
\title{Daily temperatures and precipitation for Croatia for year 2008}
\description{The daily measurements of temperature (thermometers) and precipitation (rain gauges) for year 2008 obtained from the \href{http://meteo.hr}{Croatian National Meteorological Service}. All data is projected in the \href{http://spatialreference.org/ref/epsg/32633/}{UTM zone 33N} system.\cr 
\code{HRtemp08} contains 56,608 measurements of temperature (159 stations by 365 days); \code{HRprec08} contains 175,059 measurements of precipitation sums (489 stations by 365 days); \code{LST} is a spatial sub-sample (Istra region) of 46 time series of MODIS LST images (estimated Land Surface Temperature in degrees C) at 1 km resolution prepared as a \code{"RasterBrick"} object. The \code{"zvalue"} slot in the \code{LST} object is the dateTime column expressed as yyyy-mm-ddThh:mm:sszzzzzz, where T is the separator between the date and the time, and the time zone is either Z (for UTC) or zzzzzz, which represents \enc{±}{+-}hh:mm in relation to UTC. The temporal support of these images is 8-days.
}
\format{
The \code{HRtemp08} data frame contains the following columns:
  \describe{
	\item{NAME}{name of the meteorological station}
	\item{Lon}{a numeric vector; x-coordiante / longitude in the WGS84 system}
	\item{Lat}{a numeric vector; y-coordinate / latitude in the WGS84 system}
	\item{DATE}{'Date' class vector}
	\item{TEMP}{Daily temperature measurements in degree C}
  }
} 
\usage{data(HRtemp08)}
\author{ Tomislav Hengl (\email{tom.hengl@wur.nl}) and Melita Percec Tadic (\email{melita@cirus.dhz.hr}) }
\references{
\itemize{
\item Hengl, T., Heuvelink, G.B.M., Percec Tadic, M., Pebesma, E., (2011) \href{http://dx.doi.org/10.1007/s00704-011-0464-2}{Spatio-temporal prediction of daily temperatures using time-series of MODIS LST images}. Theoretical and Applied Climatology.
\item \url{http://spatial-analyst.net/book/HRclim2008}
}
}
\note{ The precision of the temperature readings in \code{HRtemp08} is tenth of degree C. On most climatological stations temperature is measured three times a day, at 7 a.m., 1 p.m. and 9 p.m. The daily mean can be calculated as a weighted average. The precipitation estimates in mm (\code{HRprec08}) are collected in a bottle within the rain gauge and readings are usually manual by an observer at 7 a.m. The precipitation collected in the morning refer to the precipitation for previous 24 hours.\cr
The time series of 46 day-time and night-time 8-day composite LST images (MOD11A2 product bands \code{1} and \code{5}) was obtained from the NASA's FTP server (\url{ftp://e4ftl01u.ecs.nasa.gov}). The 8-day composite images were created by patching together images from a period of \enc{±}{+-}4 days, so that the proportion of clouds can be reduced to a minimum.  
}
\examples{
data(HRtemp08)
data(HRprec08)
data(LST)
\dontrun{
## Plot temperatures, precipitation and MODIS images in Google Earth:
}
}
\keyword{datasets}
