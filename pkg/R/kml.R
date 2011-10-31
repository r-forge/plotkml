# Purpose        : Generic methods to produce a KML from a sp-type objects
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Dev Status     : Alpha
# Note           : Calls a number of lower level functions;

kml.Spatial <- function(
  obj,
  file = paste(as.character(substitute(obj, parent.frame())), ".kml", sep=""),
  name = as.character(substitute(obj, parent.frame())),
  ...,
  overwrite = FALSE,
  kmz = FALSE
){

  kml_open(file = file, name = name, overwrite = overwrite)

  kml_layer(obj = obj, ...)

  kml_close()

  if (kmz)
    kml_compress(file)
}

setMethod("kml", "Spatial", kml.Spatial)
setMethod("kml", "Raster", kml.Spatial)
