# Altitude (points, polygons, lines, raster)
#
# Returns an altitude vector and a altitudeMode string
kml_altitude <- function(obj, altitude = NA) {

  # Testing what has been given by the user
  if (is.character(altitude)) {
    # The character describes the name of a column
    altitude <- obj[[altitude]]
  }
  else if (is.numeric(altitude)) {
    # If it is numeric this is a single altitude for all points
    altitude <- rep(altitude, length.out = length(obj))
  }
  else if (is.na(altitude)) {
    altitude <- rep(.all_kml_aesthetics[["altitude"]], length.out = length(obj))
  }
  else
    stop("Bad altitude value")

  altitude
}

# Guesses the appropriate altitudeMode tag
#
kml_altitude_mode <- function(altitude){
  if (is.numeric(altitude)) {
    altitude_mode <- "relativeToGround"
  }
  else if (all(is.na(altitude))) {
    altitude_mode <- "clampToGround"
  }
  altitude_mode
}