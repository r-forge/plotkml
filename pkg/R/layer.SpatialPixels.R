kml_layer.SpatialPixels <- function(
  # options on the object to plot
  obj,
  extrude = TRUE,
  z.scale = 1,
  LabelScale = 0.7,
  ...
  ){

  # converting object to Raster*
  if (ncol(obj) > 1)
    obj <- as(obj, "RasterStack")
  else
    obj <- as(obj, "RasterLayer")

  kml_layer(obj, obj.title = deparse(substitute(obj, env = parent.frame())), ...)

}

setMethod("kml_layer", "SpatialPixels", kml_layer.SpatialPixels)
