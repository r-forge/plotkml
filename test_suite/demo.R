# will be publicly available soon !
library(plotKML)
library(gstat)
library(maptools)

##
## KML authoring
##

# Entering a set of spatial data
#
# SpatialPoints dataset
data(meuse)
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")
# SpatialPixels
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) <- TRUE
# They are not lat-long - but plotKML can take good care of it!

# SpatialPolygons dataset
nc <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
nc.geo <- spTransform(nc, CRS("+proj=longlat +datum=WGS84"))

# SpatialLines
data(volcano)
volcano <- ContourLines2SLDF(contourLines(volcano))
proj4string(volcano) <- CRS("+init=epsg:4326") # of course this is stupid
volcano$altitude <- as.numeric(as.character(volcano$level))

# Simple example: one layer
# -------------------------
# this is broken in r139
kml(meuse.grid, colour = dist, file = "foo.kml", overwrite = TRUE)

# Playing with two aesthetics in one plot (size and colour)
kml(meuse, colour = log(zinc), size = cadmium, file = "foo.kml", overwrite = TRUE)

# new icon:
kml(meuse, colour = zinc, file = "foo_ball.kml", shape = "http://plotkml.r-forge.r-project.org/3Dball.png", overwrite=TRUE) 


# More elaborated example: multi-layer
# ------------------------------------

# start output
kml_open("foo.kml", overwrite = TRUE)

# SpatialPixelsDataFrame
kml_layer(meuse.grid, colour = exp(dist), file = "foo.kml") 

# (the formula is just showing that we can enter formulas)

# SpatialPointsDataFrame
kml_layer(meuse, colour = soil, file = "foo.kml") 

# note that the default colour ramps are differnt wether it is continous or categorical data

# Close file
kml_close(file = "foo.kml")

# SpatialPolygons
kml(nc.geo, '01-polygons.kml')
library(RColorBrewer)
kml(nc.geo, '02-polygons.kml', colour=AREA,
colour_scale=brewer.pal(n=5, name="Blues"))

# SpatialLines
kml(volcano, file='03-lines.kml', colour=altitude, colour_scale =
terrain.colors(10))

# Multi-layer KML
pts <- spsample(nc.geo, n = 50, type='random')
kml_open("04-multi.kml")
kml_layer(nc.geo, file = "04-multi.kml", colour = AREA,
colour_scale=brewer.pal(n=5, name="Blues"))
kml_layer(pts, file = "04-multi.kml", colour = "purple")
kml_close("04-multi.kml")

# have fun ;-)

# done!

