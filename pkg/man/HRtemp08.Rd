\name{HRtemp08}
\docType{data}
\encoding{latin1}
\alias{HRtemp08}
\title{Daily temperatures for Croatia for year 2008}
\description{The daily measurements of temperature (thermometers) for year 2008 kindly contributed by the \href{http://meteo.hr}{Croatian National Meteorological Service}. \code{HRtemp08} contains 56,608 measurements of temperature (159 stations by 365 days). 
}
\usage{data(HRtemp08)}
\format{
The \code{HRtemp08} data frames contain the following columns:
  \describe{
	\item{\code{NAME}}{name of the meteorological station}
	\item{\code{Lon}}{a numeric vector; x-coordiante / longitude in the WGS84 system}
	\item{\code{Lat}}{a numeric vector; y-coordinate / latitude in the WGS84 system}
	\item{\code{DATE}}{'Date' class vector}
	\item{\code{TEMP}}{daily temperature measurements in degree C}
  }
}
\author{ Tomislav Hengl and Melita Percec Tadic }
\references{
\itemize{
\item Hengl, T., Heuvelink, G.B.M., Percec Tadic, M., Pebesma, E., (2011) \href{http://dx.doi.org/10.1007/s00704-011-0464-2}{Spatio-temporal prediction of daily temperatures using time-series of MODIS LST images}. Theoretical and Applied Climatology, 107(1-2): 265-277.
\item AGGM book datasets (\url{http://spatial-analyst.net/book/HRclim2008})
}
}
\note{ The precision of the temperature readings in \code{HRtemp08} is tenth of degree C. On most climatological stations temperature is measured three times a day, at 7 a.m., 1 p.m. and 9 p.m. The daily mean can be calculated as a weighted average. 
}
\seealso{ \code{\link{HRprec08}} }
\examples{
data(HRtemp08)
HRtemp08[1,]
library(XML)
p1 = newXMLNode("Placemark")
begin <- format(HRtemp08[1,"DATE"]-.5, "\%Y-\%m-\%dT\%H:\%M:\%SZ")
end <- format(HRtemp08[1,"DATE"]+.5, "\%Y-\%m-\%dT\%H:\%M:\%SZ")
txt <- sprintf('<name>\%s</name><TimeStamp><begin>\%s</begin><end>\%s</end></TimeStamp>
    <Point><coordinates>\%.4f,\%.4f,\%.0f</coordinates></Point>', HRtemp08[1,"NAME"], 
    begin, end, HRtemp08[1,"Lon"], HRtemp08[1,"Lat"], 0)
parseXMLAndAdd(txt, parent=p1)
p1

\dontrun{
## examples from: http://dx.doi.org/10.1007/s00704-011-0464-2 
library(spacetime)
library(gstat)
library(sp)
sp <- SpatialPoints(HRtemp08[,c("Lon","Lat")])
proj4string(sp) <- CRS("+proj=longlat +datum=WGS84")
HRtemp08.st <- STIDF(sp, time = HRtemp08$DATE-.5, data = HRtemp08[,c("NAME","TEMP")], endTime = as.POSIXct(HRtemp08$DATE+.5))

## Load covariates:
con <- url("http://dailymeteo.org/sites/default/files/HRgrid1km.rda")
load(con)
str(HRgrid1km)
sel.s <- c("HRdem","HRdsea","HRtwi","Lat","Lon")
## Prepare static covariates:
begin <- as.Date("2008-01-01")  
endTime <- as.POSIXct(as.Date("2008-12-31"))
sp.grid <- as(HRgrid1km, "SpatialPixels")
HRgrid1km.st0 <- STFDF(sp.grid, time=begin, 
    data=HRgrid1km@data[,sel.s], endTime=endTime)
## Prepare dynamic covariates:
sel.d <- which(!names(HRgrid1km) %in% sel.s)
dates <- sapply(names(HRgrid1km)[sel.d], 
     function(x){strsplit(x, "LST")[[1]][2]}
)
dates <- as.Date(dates, format="%Y_%m_%d")
## Sort values of MODIS LST bands:
m <- data.frame(MODIS.LST = as.vector(unlist(HRgrid1km@data[,sel.d])))
## >10M values!
## Create an object of type STFDF:
HRgrid1km.stD <- STFDF(sp.grid, time=dates-4, data=m, endTime=as.POSIXct(dates+4))

## Overlay:
HRtemp08.stxy <- spTransform(HRtemp08.st, CRS(proj4string(HRgrid1km)))
ov.s <- over(HRtemp08.stxy, HRgrid1km.st0)
ov.d <- over(HRtemp08.stxy, HRgrid1km.stD)
## Prepare the regression matrix:
regm <- do.call(cbind, list(HRtemp08.stxy@data, ov.s, ov.d))
## Estimate cumulative days:
regm$cday <- floor(unclass(HRtemp08.stxy@endTime)/86400-.5)
str(regm)
## Plot a single station:
scatter.smooth(regm$cday[regm$NAME=="Zavi<c5><be>an"], 
    regm$TEMP[regm$NAME=="Zavi<c5><be>an"], 
    xlab="Cumulative days", 
    ylab="Mean daily temperature (\260C)", 
    ylim=c(-12,28), main="GL039 (Zavi\236an)", 
    col="grey")
## We run PCA so we can later on filter all missing pixels in the MODIS.LST images:
pca <- prcomp(~HRdem+HRdsea+Lat+Lon+HRtwi+MODIS.LST, 
    data=regm, scale.=TRUE)
regm.pca <- cbind(regm[-pca$na.action,c("TEMP","cday")], 
    as.data.frame(pca$x))
## Fit a spatio-temporal regression model:
theta <- min(regm.pca$cday)
lm.HRtemp08 <- lm(TEMP~PC1+PC2+PC3+PC4+PC5+PC6 
     +cos((cday-theta)*pi/180), data=regm.pca)
summary(lm.HRtemp08)
}
}
\keyword{datasets}