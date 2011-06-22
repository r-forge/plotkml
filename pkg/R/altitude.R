# Elevation (points, polygons, lines, raster)
#
# Returns an elevation vector and a altitudeMode string
kml_elevation <- function(obj, elevation = NA, elevation.default = 10){

  # Testing what has been given by the user
  if (is.character(elevation)) {
    # The character describes the name of a column
    elevation.mode <- "absolute"
    elevation <- obj[[elevation]]
  }
  else if (is.numeric(elevation)) {
    # If it is numeric this is a single elevation for all points
    elevation.mode <- "relativeToGround"
    elevation <- rep(elevation, length.out = nrow(obj))
  }
  else if (is.na(elevation)) {
    elevation.mode <- "clampToGround"
    elevation <- rep(elevation.default, length.out = nrow(obj))
  }
  else   
    stop("Bad elevation value")

  list(elevation = elevation, elevation.mode = elevation.mode)
}
