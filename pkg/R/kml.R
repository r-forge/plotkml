kml.Spatial <- function(
  obj,
  file = paste(as.character(substitute(obj, parent.frame())), ".kml", sep=""),
  ...,
  overwrite = FALSE,
  kmz = FALSE
){

  kml_open(file = file, name = as.character(substitute(obj, parent.frame())), overwrite = overwrite)

  kml_layer(obj = obj, ...)

  kml_close()

  if (kmz)
    kml_compress(file)
}

setMethod("kml", "Spatial", kml.Spatial)
setMethod("kml", "Raster", kml.Spatial)
