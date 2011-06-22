# Altitude (points, polygons, lines, raster)
#
# Returns an altitude vector and a altitudeMode string
kml_altitude <- function(obj, altitude = NA, altitude.default = 10){

  # Testing what has been given by the user
  if (is.character(altitude)) {
    # The character describes the name of a column
    altitude.mode <- "absolute"
    altitude <- obj[[altitude]]
  }
  else if (is.numeric(altitude)) {
    # If it is numeric this is a single altitude for all points
    altitude.mode <- "relativeToGround"
    altitude <- rep(altitude, length.out = nrow(obj))
  }
  else if (is.na(altitude)) {
    altitude.mode <- "clampToGround"
    altitude <- rep(altitude.default, length.out = nrow(obj))
  }
  else   
    stop("Bad altitude value")

  list(altitude = altitude, altitude.mode = altitude.mode)
}
