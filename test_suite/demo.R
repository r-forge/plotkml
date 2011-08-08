# will be publicly available soon !
library(plotKML)
library(gstat)
library(maptools)
library(RColorBrewer)

# system("Rcmd build D:/R/plotKML/working/pkg")
## fails
# copying to build directory failed
# Warning message:
# running command 'Rcmd build D:/R/plotKML/working/pkg' had status 1 

# system("R CMD INSTALL D:/R/plotKML/working/pkg")
## TH: Finally manged to install on Windows machine 

## Alternative, load functions manually:
# source('../pkg/R/AAAA.R')
# source('../pkg/R/aesthetics.R')
# source('../pkg/R/altitude.R')
# source('../pkg/R/check_projection.R')
# source('../pkg/R/layer.SpatialPoints.R')
# source('../pkg/R/layer.SpatialPolygons.R')
# source('../pkg/R/layer.SpatialLines.R')
# source('../pkg/R/layer.Raster.R')
# source('../pkg/R/kml.R')
# source('../pkg/R/utils.R')
# source('../pkg/R/attributes.R')
# source('../pkg/R/reproject.R')

##
## KML authoring
##

# Entering a set of spatial data
#

## 1. meuse data set ----------------------------------------------------------
# They are not lat-long - but plotKML can take good care of it!
data(meuse)
data(meuse.grid)
# SpatialPoints dataset
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")
# SpatialPixels
coordinates(meuse.grid) <- ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) <- TRUE


# Simple example: one layer
kml(meuse.grid, colour = dist, file = "foo.kml", overwrite = TRUE)

# Playing with two aesthetics in one plot (size and colour)
kml(meuse, colour = log(zinc), size = cadmium, file = "foo.kml", overwrite = TRUE)

# new icon:
kml(meuse, colour = zinc, file = "foo_ball.kml", shape = "http://plotkml.r-forge.r-project.org/3Dball.png", overwrite=TRUE) 

# attributes from @data
kml(meuse, colour = zinc, file = "foo_attr.kml", overwrite=TRUE, balloon=TRUE)


# multi-layer example:
# start output
kml_open('foo.kml', overwrite = TRUE)

# SpatialPixelsDataFrame
kml_layer(meuse.grid, colour = exp(dist)) 

# (the formula is just showing that we can enter formulas)

# SpatialPointsDataFrame
kml_layer(meuse, colour = soil, balloon=TRUE) 

# note that the default colour ramps are different wether it is continous or categorical data

# Close file
kml_close()
## ----------------------------------------------------------------------------



## 2. SpatialPolygons dataset ------------------------------------------------
nc <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
nc.geo <- spTransform(nc, CRS("+proj=longlat +datum=WGS84"))

# single layer documents
kml(nc.geo, file='01-polygons.kml')
kml(nc.geo, colour=AREA, colour_scale=brewer.pal(n=5, name="Blues"))


# Multi-layer KML
pts <- spsample(nc.geo, n = 50, type='random')
kml_open("04-multi.kml")
kml_layer(nc.geo, colour = AREA, colour_scale=brewer.pal(n=5, name="Blues"))
kml_layer(pts, colour = "purple")
kml_close()

## ----------------------------------------------------------------------------


## 3. SpatialLines -----------------------------------------------------------
rm(volcano)
volcano <- ContourLines2SLDF(contourLines(volcano))
proj4string(volcano) <- CRS("+init=epsg:4326") # of course this is stupid
volcano$altitude <- as.numeric(as.character(volcano$level))

kml(volcano, file='03-lines.kml', colour=altitude, colour_scale = terrain.colors(10))

## ----------------------------------------------------------------------------