kml.SpatialPoints <- function(
  obj,
  file = paste(as.character(substitute(obj, parent.frame())), ".kml", sep=""),
  ...,
  overwrite = FALSE,
  kmz = FALSE
){

  kml_open(file = file, name = as.character(substitute(obj, parent.frame())), overwrite = overwrite)

  kml_layer(obj = obj, file = file, ...)

  kml_close(file = file)

  if (kmz)
    kml_compress(file)
}

setMethod("kml", "SpatialPoints", kml.SpatialPoints)
