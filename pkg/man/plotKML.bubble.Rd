\name{plotKML.bubble}
\alias{plotKML.bubble}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Creates a bubble-type of plot for spatial point data.  
%%  ~~function to do ... ~~
}
\description{ Creates a bubble-type of plot for any \code{\link{SpatialPointsDataFrame}} with defined proj4 string in Google Earth.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plotKML.bubble(SPDF, var.name, LON, LAT, file.name, icon, icon.url, plt.size, plt.size0, IconColor, altitudeMode, above.ground, extrude, z.scale, LabelScale, signif.digits, TimeSpan.begin, TimeSpan.end, kmz)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SPDF}{ object of, or extending, class SpatialPointsDataFrame
%%     ~~Describe \code{SPDF} here~~
}
  \item{var.name}{ z-variable column name
%%     ~~Describe \code{var.name} here~~
}
  \item{LON}{ Longitude or x coordinates column name
%%     ~~Describe \code{LON} here~~
}
  \item{LAT}{ Latitude or y coordinates column name
%%     ~~Describe \code{LAT} here~~
}
  \item{file.name}{ Output file name
%%     ~~Describe \code{file.name} here~~
}
  \item{icon}{ File name of the icon used
%%     ~~Describe \code{icon} here~~
}
  \item{icon.url}{ URL location of the icon
%%     ~~Describe \code{icon.url} here~~
}
  \item{plt.size}{ Largest size of icon
%%     ~~Describe \code{plt.size} here~~
}
  \item{plt.size0}{ Smallest size of icon
%%     ~~Describe \code{plt.size0} here~~
}
  \item{IconColor}{ Colum name with Google formated colors
%%     ~~Describe \code{IconColor} here~~
}
  \item{altitudeMode}{ Altitude mode based on the KML tutorial
%%     ~~Describe \code{altitudeMode} here~~
}
  \item{above.ground}{ Elevation above ground or referent surface
%%     ~~Describe \code{above.ground} here~~
}
  \item{extrude}{ Extrude true or false
%%     ~~Describe \code{extrude} here~~
}
  \item{z.scale}{ Elevation exaggeration
%%     ~~Describe \code{z.scale} here~~
}
  \item{LabelScale}{ Scale of labels
%%     ~~Describe \code{LabelScale} here~~
}
  \item{signif.digits}{ Number of singificant digits for the labels
%%     ~~Describe \code{signif.digits} here~~
}
  \item{TimeSpan.begin}{ Vector of time/Date for begin period
%%     ~~Describe \code{TimeSpan.begin} here~~
}
  \item{TimeSpan.end}{ Vector of time/Date for end period
%%     ~~Describe \code{TimeSpan.end} here~~
}
  \item{kmz}{ Compress the output file true or false
%%     ~~Describe \code{kmz} here~~
}
}
\details{  The target variable \code{var.name} needs to be continuous i.e.\@ numeric, or factor type. The legend is not printed separately because the values (labels) are printed by default. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{\code{IconColor}}{The range of values for any one color is 0 to 255 (00 to ff). The order of expression is aabbggrr, where aa=alpha (00 to ff); bb=blue (00 to ff); gg=green (00 to ff); rr=red (00 to ff). For alpha, 00 is fully transparent and ff is fully opaque.}
\item{\code{icon}}{If not speciefied otherwise, \url{http://maps.google.com/mapfiles/kml/shapes/donut.png} is used.}
\item{\code{plt.size}}{If not specified otherwise \code{plt.size=2} is used.}
\item{\code{above.ground}}{If not specified 10 m is elevation is used.}
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{ Tomislav Hengl \& Dylan Beaudette
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{  \code{\link{plotKML.geopath}}, \code{\link{plotKML.profiles}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.
data(meuse)
NL_RD <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs"
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS(NL_RD)

## Bubble plot (2D):
plotKML.bubble(SPDF=meuse, var.name="zinc", kmz=TRUE)

## Icon in a local folder (2D):
plotKML.bubble(SPDF=meuse, var.name="om", file.name="om_cross_plot", LabelScale=.5, plt.size=0, icon.url="http://globalsoilmap.net/data/", icon="cross.png", kmz=TRUE)

## Bubble plot (3D, visually better):
plotKML.bubble(SPDF=meuse, var.name="zinc", file.name="zinc_bubble_plot_3D", LabelScale=.5, plt.size=2, above.ground=meuse$zinc, z.scale=0.3, kmz=TRUE)

## Bubble plot with time bar:
todayc <- floor(unclass(as.POSIXct(Sys.time()))/86400)[[1]]
meuse$rdates <- as.Date(as.POSIXct((todayc+runif(length(meuse$zinc))*1000)*86400, origin="1970-01-01"))  # generate random dates
plotKML.bubble(SPDF=meuse, var.name="zinc", file.name="zinc_bubble_plot_3Dt", TimeSpan.begin=meuse$rdates-1, TimeSpan.end=meuse$rdates+1, kmz=TRUE)

## Plot soil colors for profile data:
d <- expand.grid(hue=c('10YR', '7.5YR', '5YR', '2.5R'), value=2:8, chroma=1:8) # random colors
meuse$Munsell <- paste(d$hue, d$chroma, d$value, sep="_")[1:length(meuse@data[,1])]
meuse$FBGR <- Munsell2FBGR(meuse@data, "Munsell")
plotKML.bubble(SPDF=meuse, var.name="Munsell", file.name="zinc_Munsell_plot", icon.url="http://globalsoilmap.net/data/", icon="penta.png", IconColor=meuse$FBGR, plt.size=0.7, LabelScale=0, kmz=TRUE)

## Soil type class "1"
meuse$stype1 <- ifelse(meuse$soil==1, 1, 0)
plotKML.bubble(SPDF=meuse, var.name="stype1", file.name="zinc_stype1", icon.url="http://globalsoilmap.net/data/", plt.size=0.7, icon="cross.png", LabelScale=0, kmz=TRUE)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
