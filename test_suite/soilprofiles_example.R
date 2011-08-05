
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
# this will automatically close the file

# end of script;