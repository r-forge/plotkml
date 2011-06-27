setMethod("kml", "SpatialPointsDataFrame", function(
  # options on the object to plot
  obj,
  file = paste(as.character(substitute(obj, parent.frame())), ".kml", sep=""),
  ...,
  kmz = FALSE
){

  kml_open(file = file, name = as.character(substitute(obj, parent.frame())))

  layer.SpatialPoints(obj = obj, file = file, ...)

  kml_close(file = file)

  if (kmz)
    kml_compress(file)
})
