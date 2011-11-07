# Purpose        : Generic methods to produce a KML from a sp-type objects
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Dev Status     : Alpha
# Note           : Calls a number of lower level functions;

kml.Spatial <- function(
  obj,
  file.name = set.file.extension(deparse(substitute(obj, env=parent.frame())), ".kml"),
  obj.name = "plotKML Spatial object",
  obj.title = deparse(substitute(obj, env=parent.frame())),
  ...,
  overwrite = TRUE,
  kmz = FALSE
){

  kml_open(obj.name = obj.name)

  kml_layer(obj = obj, obj.title = obj.title, ...)

  kml_close(file.name = file.name, overwrite = overwrite)

  if (kmz == TRUE){
    kml_compress(file.name)
  }
}

setMethod("kml", "Spatial", kml.Spatial)
setMethod("kml", "Raster", kml.Spatial)
