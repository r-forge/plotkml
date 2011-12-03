\name{dailymeteo}
\docType{data}
\encoding{latin1}
\alias{HRtemp08}
\alias{HRprec08}
\title{Daily temperatures and precipitation for Croatia for year 2008}
\description{The daily measurements of temperature (thermometers) and precipitation (rain gauges) for year 2008 kindly contributed by the \href{http://meteo.hr}{Croatian National Meteorological Service}. All data is projected in the \href{http://spatialreference.org/ref/epsg/32633/}{UTM zone 33N} system. 
\code{HRtemp08} contains 56,608 measurements of temperature (159 stations by 365 days); \code{HRprec08} contains 175,059 measurements of precipitation sums (489 stations by 365 days). 
}
\usage{data(HRtemp08)}
\format{
The \code{HRtemp08}/\code{HRprec08} data frames contain the following columns:
  \describe{
	\item{\code{NAME}}{name of the meteorological station}
	\item{\code{Lon}}{a numeric vector; x-coordiante / longitude in the WGS84 system}
	\item{\code{Lat}}{a numeric vector; y-coordinate / latitude in the WGS84 system}
	\item{\code{DATE}}{'Date' class vector}
	\item{\code{TEMP}/\code{PREC}}{daily temperature measurements in degree C / cummulative precipitation in mm measured the day before}
  }
} 
\author{ Tomislav Hengl and Melita Percec Tadic }
\references{
\itemize{
\item Hengl, T., Heuvelink, G.B.M., Percec Tadic, M., Pebesma, E., (2011) \href{http://dx.doi.org/10.1007/s00704-011-0464-2}{Spatio-temporal prediction of daily temperatures using time-series of MODIS LST images}. Theoretical and Applied Climatology.
\item \url{http://spatial-analyst.net/book/HRclim2008}
}
}
\note{ The precision of the temperature readings in \code{HRtemp08} is tenth of degree C. On most climatological stations temperature is measured three times a day, at 7 a.m., 1 p.m. and 9 p.m. The daily mean can be calculated as a weighted average. The precipitation estimates in mm (\code{HRprec08}) are collected in a bottle within the rain gauge and readings are usually manual by an observer at 7 a.m. The precipitation collected in the morning refer to the precipitation for previous 24 hours.
}
\examples{
data(HRtemp08)
HRtemp08[1,]
p1 = newXMLNode("Placemark")
begin <- format(HRtemp08[1,"DATE"]-.5, "\%Y-\%m-\%dT\%H:\%M:\%SZ")
end <- format(HRtemp08[1,"DATE"]+.5, "\%Y-\%m-\%dT\%H:\%M:\%SZ")
txt <- sprintf('<name>\%s</name><TimeStamp><begin>\%s</begin><end>\%s</end></TimeStamp><Point><coordinates>\%.4f,\%.4f,\%.0f</coordinates></Point>', HRtemp08[1,"NAME"], begin, end, HRtemp08[1,"Lon"], HRtemp08[1,"Lat"], 0)
parseXMLAndAdd(txt, parent=p1)
p1
\dontrun{
## Load precipitation data:
load(url("http://plotkml.r-forge.r-project.org/HRprec08.rda"))
## Plot measured temperatures and precipitation in Google Earth:
}
}
\keyword{datasets}
