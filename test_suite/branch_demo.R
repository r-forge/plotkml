
source('../pkg/R/AAAA.R')
source('../pkg/R/aesthetics.R')
source('../pkg/R/altitude.R')
source('../pkg/R/check_projection.R')
source('../pkg/R/layer.SpatialPoints.R')
source('../pkg/R/layer.SpatialPolygons.R')
source('../pkg/R/layer.SpatialLines.R')
source('../pkg/R/layer.Raster.R')
source('../pkg/R/kml.R')
source('../pkg/R/utils.R')
source('../pkg/R/attributes.R')
source('../pkg/R/reproject.R')

# SoilProfileCollection
# ------------------------------------

source('../branches/views/R/layer.SoilProfileCollection.R')

# library(aqp)
## Load functions from r-forge:
source(url('http://r-forge.r-project.org/scm/viewvc.php/*checkout*/branches/aqp_S4/R/Class-SoilProfile.R?root=aqp'))
source(url('http://r-forge.r-project.org/scm/viewvc.php/*checkout*/branches/aqp_S4/R/Class-SoilProfileCollection.R?root=aqp'))
source(url('http://r-forge.r-project.org/scm/viewvc.php/*checkout*/branches/aqp_S4/R/SoilProfile-methods.R?root=aqp'))
source(url('http://r-forge.r-project.org/scm/viewvc.php/*checkout*/branches/aqp_S4/R/SoilProfileCollection-methods.R?root=aqp'))
source(url('http://r-forge.r-project.org/scm/viewvc.php/*checkout*/branches/aqp_S4/R/setters.R?root=aqp'))

sp <- sp1[sp1$id == 'P001', ]
spc <- sp1
# some fake site data (Dylan's hometown)
spc$x <- unlist(dlply(spc, .(id), function(x){n <- nrow(x); rep(-121.33+runif(1), length.out=n)}))
spc$y <- unlist(dlply(spc, .(id), function(x){n <- nrow(x); rep(38.02+runif(1), length.out=n)}))

# Initialization
depths(sp) <- id ~ top + bottom             # SoilProfile
depths(spc) <- id ~ top + bottom            # SoilProfileCollection
site(spc) <- ~  x + y

str(spc, max.level=2)

## Site slot SHOULD BE a SpatialPointsDataFrame?
# spc.sp <- spc@site
# coordinates(spc.sp) <- ~x+y
# proj4string(spc.sp) <- CRS("+proj=longlat +datum=WGS84")
## Doesn't work:
# spc@site <- spc.sp

# start output
kml_open("spc.kml", overwrite = TRUE)
# plot Munsell values per horizon:
kml_layer(spc, var.name="field_ph", labels=spc@ids, max.depth=200, file = "spc.kml") 
kml_close()



# Trajectory type data
# ------------------------------------

source('../branches/views/R/layer.STIDFtraj.R')

require(spacetime)
require(adehabitatLT)
# from: adehabitat/demo/managltraj.r
data(puechabonsp)
# locations:
locs = puechabonsp$relocs
xy = coordinates(locs)
### Conversion of the date to the format POSIX
da = as.character(locs$Date)
da = as.POSIXct(strptime(as.character(locs$Date),"%y%m%d"), tz = "GMT")
## object of class "ltraj"
ltr = as.ltraj(xy, da, id = locs$Name)
foo = function(dt) dt > 100*3600*24
## The function foo returns TRUE if dt is longer than 100 days
## We use it to cut ltr:
l2 = cutltraj(ltr, "foo(dt)", nextr = TRUE)
stidfTrj = as(l2, "STIDFtraj")
stidfTrj$id <- as.factor(stidfTrj$id)
# plot(stidfTrj, col = c("red", "green", "blue", "darkgreen", "black"), axes=TRUE)
proj4string(stidfTrj@sp) <- CRS("+proj=utm +zone=31 +ellps=WGS84 +datum=WGS84 +units=m +no_defs") 

# start output
kml_open("puechabon.kml", overwrite = TRUE)
# trajectories:
kml_layer(obj=stidfTrj, id.name="id", colour=log1p(dist), colour_scale=rev(rainbow(65)[1:48])) 
kml_close(); kml_compress("puechabon.kml")


# end of script;