kml.Spatial <- function(
  obj,
  file = paste(as.character(substitute(obj, parent.frame())), ".kml", sep=""),
  filename = file(file, "w"),
  ...,
  overwrite = TRUE,
  kmz = FALSE
){

  # Open the file for writing
  kml_open(file = file, filename = filename, name = as.character(substitute(obj, parent.frame())), overwrite = overwrite, ...)

  kml_layer(obj = obj, file = file, filename = filename, ...)

  kml_close(file = file, filename = filename)

  # Close the file
  close(filename)

  if (kmz)
    kml_compress(file)
}

setMethod("kml", "SpatialPoints", kml.Spatial)
setMethod("kml", "SpatialGrid", kml.Spatial)
setMethod("kml", "SpatialPolygons", kml.Spatial)
setMethod("kml", "SpatialLines", kml.Spatial)