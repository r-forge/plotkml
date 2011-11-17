# Purpose        : Generic methods to produce a KML from a sp/raster-type objects
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Dev Status     : Alpha
# Note           : kml.Spatial function can only be called on a single spatial object;

kml.Spatial <- function(
  obj,
  folder.name = deparse(substitute(obj, env=parent.frame())),
  file.name = paste(deparse(substitute(obj, env=parent.frame())), ".kml", sep=""),
  overwrite = TRUE,
  kmz = get("kmz", envir = plotKML.opts),
  ...
){

  kml_open(folder.name = folder.name, overwrite = overwrite, file.name = file.name)

  kml_layer(obj = obj, obj.title = folder.name, ...)

  kml_close(file.name = file.name)

  if (kmz == TRUE){
    kml_compress(file.name)
  }
}

setMethod("kml", "Spatial", kml.Spatial)
setMethod("kml", "Raster", kml.Spatial)
