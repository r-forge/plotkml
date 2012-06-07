\name{SpatialMaxEntOutput-class}
\docType{class}
\alias{SpatialMaxEntOutput-class}
\title{A class for outputs of analysis produced using the dismo package (MaxEnt)}
\description{A class containing input and output data produced by running the "MaxEnt" (Maximum Entropy) species distribution modeling. Object of this class can be directly visualized in Google Earth by using the \code{\link{plotKML-methods}}.}
\section{Slots}{
  \describe{
    \item{\code{sciname}:}{object of class \code{"character"}; vector of species name compatible with the rgbif package; usually latin "genus" and "species" name}
    \item{\code{occurrences}:}{object of class \code{"SpatialPoints"}; occurrence-only records}
    \item{\code{TimeSpan.begin}:}{object of class \code{"POSIXct"}; begin of sampling}
    \item{\code{TimeSpan.end}:}{object of class \code{"POSIXct"}; end of sampling}
    \item{\code{maxent}:}{object of class \code{"MaxEnt"} (species distribution model); produced as an output of the \code{dismo::maxent} function}
    \item{\code{sp.domain}:}{object of class \code{"SpatialPolygonsDataFrame"}; assumed spatial domain that can be set by the user or estimated by MaxEnt (see examples below)}
    \item{\code{predicted}:}{object of class \code{"RasterLayer"}; contains results of prediction produced using the MaxEnt software}
  }
}
\section{Methods}{
  \describe{
	\item{plotKML}{\code{signature(obj = "SpatialMaxEntOutput")}: plots all MaxEnt output objects in Google Earth}
  }
}
\note{MaxEnt requires the \code{maxent.jar} file to be in the 'java' folder of the dismo package (see: \code{system.file("java", package="dismo")}). For more info refer to the dismo package documentation.
}
\references{
\itemize{
\item Hijmans, R.J, Elith, J., (2012) \href{http://cran.r-project.org/web/packages/dismo/vignettes/sdm.pdf}{Species distribution modeling with R}. CRAN, Vignette for the dismo package, 72 p.  
\item dismo package (\url{http://CRAN.R-project.org/package=dismo})
\item rgbif package (\url{http://CRAN.R-project.org/package=rgbif})
}
}
\author{ Tomislav Hengl }
\seealso{ \code{dismo::maxent}, \code{rgbif::taxonsearch} 
}
\examples{ 
# load occurences:
data(bigfoot)
aea.prj <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 
+x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
coordinates(bigfoot) <- ~Lon+Lat
proj4string(bigfoot) <- CRS("+proj=latlon +datum=WGS84")
bigfoot.aea <- spTransform(bigfoot, CRS(aea.prj))
# Load the covariates:
data(USAWgrids)
gridded(USAWgrids) <- ~s1+s2
proj4string(USAWgrids) <- CRS(aea.prj)
\dontrun{# USA borders:
library(maps)
state.m = map('state', plot=FALSE, fill=TRUE)
IDs <- sapply(strsplit(state.m$names, ":"), function(x) x[1])
library(maptools)
states <- as(map2SpatialPolygons(state.m, IDs=IDs), "SpatialLines")
proj4string(states) <- CRS("+proj=latlon +datum=NAD83")
states.aea <- spTransform(states, CRS(aea.prj))
# subset to area of interest:
sel.ov <- !is.na(overlay(USAWgrids, bigfoot.aea))
# run species distribution modelling:
sel.grids <- c("globedem","nlights03","sdroads","gcarb","twi","globcov")
library(dismo)
# MaxEnt requires the maxent.jar file to run:
jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
if (file.exists(jar)) {
  predictors <- stack(USAWgrids[sel.grids])
  # prepare the occurrence only records:
  xy <- data.frame(bigfoot.aea@coords[sel.ov,])
  # fit a MaxEnt model (can take few minutes!):
  me <- maxent(predictors, xy, factors='globcov')
  # predict distribution of Big Foot:
  bigfoot.pr <- predict(me, predictors, progress='window')
  par(mfrow=c(1,2))
  plot(bigfoot.pr, main='MaxEnt predictions', axes=FALSE)
  lines(states.aea)
  points(bigfoot.aea[sel.ov,], pch="+", cex=.5)
  # run cross-validation
  fold <- kfold(xy, k=5)
  # randomly take 20% of observations:
  xy.test <- xy[fold == 1,]
  bg <- randomPoints(predictors, 1000)  
  ev <- evaluate(me, p=xy.test, a=bg, x=predictors)
  # this allows estimation of the threshold probability:
  threshold <- ev@t[which.max(ev@TPR + ev@TNR)]
  # which allows us to derive the potential homerange for this species:
  plot(bigfoot.pr > threshold, main='presence/absence', axes=FALSE, legend=FALSE)
  lines(states.aea)
  dev.off()
  # prepare data for plotKML:
  hr <- calc(bigfoot.pr, fun=function(x){ifelse(x>threshold, 1, NA)})
  bigfoot.hr <- rasterToPolygons(hr, dissolve=TRUE) # takes time!
  occ <- SpatialPoints(bigfoot.aea[sel.ov,]); proj4string(occ) = CRS(aea.prj)
  # create an object of type "SpatialMaxEntOutput":
  bigfoot.smo <- new("SpatialMaxEntOutput", sciname = "Sasquatch", occurrences = occ, 
     TimeSpan.begin = min(bigfoot@data[sel.ov,"DATE"]), 
     TimeSpan.end = max(bigfoot@data[sel.ov,"DATE"]), 
     maxent = me, sp.domain = bigfoot.hr, predicted = bigfoot.pr)
  # str(bigfoot.smo, max.level=2)
  # plot the whole SDM project in Google Earth:
  data(R_pal)
  icon = "http://plotkml.r-forge.r-project.org/bigfoot.png"
  plotKML(bigfoot.smo, colour_scale = R_pal[["bpy_colors"]], shape = icon)
}
}
}
\keyword{classes}
