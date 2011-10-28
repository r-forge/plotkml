# Doing a local install of the package for testing purposes
install.packages("plotKML", repos="http://R-Forge.R-project.org", lib.loc = ".")
# In case this does not work you need to source() all the *.R files located
# in ./plotKML/pkg/R/

## ========================== ##
##
## Loading testing data
##
## ========================== ##

## SpatialPointsDataFrame
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")

## SpatialPixelsDataFrame
data(eberg_grid)

## SpatialLinesDataFrame
data(eberg_contours)

## SpatialPolygons
require(maptools)
nc <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))

## RasterStack
eberg_raster <- stack(eberg_grid)

## ========================== ##
##
## Different modes available  ##
##
## ========================== ##

## Simple KML generation

# Point data
kml(eberg, file = "demo-01.kml", overwrite=TRUE)

# Polygon data
kml(nc, file = "demo-02.kml", overwrite=TRUE)

# Lines data
kml(eberg_contours, file = "demo-03.kml", overwrite=TRUE)

# Lines with attribute mapping
kml(eberg_contours, file = "demo-04.kml", colour = Z, overwrite=TRUE)

# Raster data
kml(eberg_grid, file = "demo-05.kml", colour = TWI, overwrite=TRUE)

# Other raster data class - with overwriting option
kml(eberg_raster, file = "demo-05.kml", colour = TWI, overwrite = TRUE)

## Advanced KML generation

# An example of multi-layer KML file
kml_open(file = "demo-06.kml", overwrite=TRUE)
# Adding a raster layer
kml_layer(eberg_grid, colour = TWI)
# Adding a vector layer
kml_layer(eberg, colour = CLAY)
# Closing the file
kml_close()

## ======================================= ##
##
## Different ways to represent information ##
##
## ======================================= ##

# There are various aesthetics available to represent a variable, 
# or simply used to customise your KML file

## Colour (vector data)
# Point data
kml(eberg, file = "demo-07.kml", colour = CLAY, overwrite=TRUE)
# Polygon data
kml(nc, file = "demo-08.kml", colour = AREA, overwrite=TRUE)
# Lines data
kml(eberg_contours, file = "demo-09.kml", colour = elevation, overwrite=TRUE)

## Colour (raster data)

# See previous example - the colour argument is still required for raster data

## Transparency
# Vector data
kml(eberg, file = "demo-10.kml", colour = CLAY, alpha = 0.5, overwrite=TRUE)
# Raster data
kml(eberg_grid, file = "demo-11.kml", colour = TWI, alpha = 0.75, overwrite=TRUE)

## Shape
# Point data
kml(eberg, file = "demo-12.kml", shape = "PLACE_URL_HERE", overwrite=TRUE)

## Size
kml(eberg, file = "demo-13.kml", size = 0.25, overwrite=TRUE)

## Mixing different aesthetics
kml(eberg, file = "demo-14.kml", colour = CLAY, size = 0.25, alpha = 0.75, shape = "PLACE_URL_HERE", overwrite=TRUE)

## ====================== ##
##
## Tweaking the KML plots ##
##
## ====================== ##

## Formula interface

# You can specify a transformation to the attribute to map:
kml(eberg, file = "demo-15.kml", colour = log1p(SAND), overwrite=TRUE)
kml(eberg_grid, file = "demo-16.kml", colour = sqrt(TWI + 1), overwrite=TRUE)

## Labels

# No labels
kml(eberg, file = "demo-17.kml", colour = SAND, labels = "", overwrite=TRUE)

# Constant labels
kml(eberg, file = "demo-18.kml", colour = SAND, labels = "hello world", overwrite=TRUE)

# Labels from a column
eberg$labs <- rep(letters[1:10], length.out = nrow(eberg))
kml(eberg, file = "demo-19.kml", colour = SAND, labels = labs, overwrite=TRUE)
eberg$labs <- NULL

## Colour scale

# Default colour scale is different wether the variable is continuous or not

# Continuous data
class(eberg_grid$TWI)
kml(eberg_grid, file = "demo-20.kml", colour = TWI, overwrite=TRUE)
# Categorical data
class(eberg_grid$Z)
kml(eberg_grid, file = "demo-21.kml", colour = Z, overwrite=TRUE)

# Specifying your own colour palette
kml(eberg_contours, file = "demo-22.kml", colour = elevation, colour_scale = topo.colors(10), overwrite=TRUE)