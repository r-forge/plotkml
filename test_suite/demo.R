# will be publicly available soon !
library(plotKML)


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

# Simple example: one layer
# -------------------------
kml(meuse.grid, colour = dist, file = "foo.kml", overwrite = TRUE)

# Playing with two aesthetics in one plot (size and colour)
kml(meuse, colour = log(zinc), size = cadmium, file = "foo.kml", overwrite = TRUE)

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

# have fun ;-)

# done!

