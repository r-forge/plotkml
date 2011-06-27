# List of available aesthetics is given .all_kml_aesthetics
# along with their default values
.all_kml_aesthetics <- list(
  colour = "black",
  fill = "white",
  shape = "http://maps.google.com/mapfiles/kml/shapes/donut.png",
  whitening = "",
  alpha = 1,
  size = 2,
  width = 1,
  altitude = NA
)

# Parsing a call
#
.parse_call_for_aes <- function(call){
  called_options <- names(call)
  ind_aes <- charmatch(called_options, names(.all_kml_aesthetics))

  names(.all_kml_aesthetics)[ind_aes[!is.na(ind_aes)]]
}

# Applying aesthetics
#
kml_aes <- function(obj, ...){

  # Getting parent call
  parent_call <- sys.calls()[[sys.nframe() - 1]]
  parent_call <- structure(as.list(parent_call), class="uneval")
  parent_call <- c(parent_call, list(...))
  # Parse the current call
  called_aes <- .parse_call_for_aes(parent_call)

  aes <- list()

  # Colour
  if ("colour" %in% called_aes) {
    aes[['colour']] <- kml_colour(obj, colour, ...)
    # Whitening
#     if ("whitening" %in% called_aes) {
#       aes[['colour']] <- kml_whitening(obj, whitening, aes[['colour']], ...)
#     }
  }
  else {
    aes[['colour']] <- rep(.all_kml_aesthetics[["colour"]], length.out = nrow(coordinates(obj)))
  }

  # Shape
  if ("shape" %in% called_aes) {
    aes[["shape"]] <- kml_shape(obj, shape, ...)
  }
  else {
    aes[["shape"]] <- rep(.all_kml_aesthetics[["shape"]], length.out = nrow(coordinates(obj)))
  }

  # Size
  if ("size" %in% called_aes) {
    aes[['size']] <- kml_size(obj, size, ...)
  }
  else {
    aes[['size']] <- rep(.all_kml_aesthetics[["size"]], length.out = nrow(coordinates(obj)))
  }

  # Width
  if ("width" %in% called_aes) {
    aes[['width']] <- kml_width(obj, width, ...)
  }
  else {
    aes[['width']] <- rep(.all_kml_aesthetics[["width"]], length.out = nrow(coordinates(obj)))
  }

  # Alpha
  if ("alpha" %in% called_aes) {
    aes[['alpha']] <- kml_alpha(obj, alpha, ...)
  }
  else {
    aes[['alpha']] <- rep(.all_kml_aesthetics[["alpha"]], length.out = nrow(coordinates(obj)))
  }

  # Altitude
  if ("altitude" %in% called_aes) {
    aes[['altitude']] <- kml_altitude(obj, altitude, ...)
  }
  else {
    aes[['altitude']] <- rep(.all_kml_aesthetics[["altitude"]], length.out = nrow(coordinates(obj)))
  }

  # AltitudeMode
  aes[["altitudeMode"]] <- kml_altitude_mode(aes[['altitude']])

  aes
}

# Colour (points, polygons, lines, raster)
kml_colour <- function(obj, colour, ..., col.region = rainbow(64)){

  x <- obj[[colour]]

  # If the scale is continuous
  if (is.numeric(x)) {
    limits <- range(x, na.rm = TRUE, finite = TRUE)
    brks <- seq(limits[1], limits[2], length.out = length(col.region))
    grps <- cut(x, breaks = brks, include.lowest = TRUE)
    cols <- hex2kml(col.region[grps])
  }
  # If discrete scale
  else {

  }

  cols
}

# Shape (points)
kml_shape <- function(obj, shape, ...){

}

# Opacity (points, polygons, lines, raster)
kml_alpha <- function(obj, alpha, colours, ...){

  x <- obj[[alpha]]

  if (is.numeric(x)) {
    limits <- range(x, na.rm = TRUE, finite = TRUE)
    brks <- seq(limits[1], limits[2], length.out = length(colours))
    grps <- cut(x, breaks = brks, include.lowest = TRUE)
#     alphas <-
  }

  cols
}

# Whitening of a given coloured layer (update of the colour vector)
kml_whitening <- function(obj, whitening, col.vect){

}

# Size (points)
kml_size <- function(obj, size, size.min = 0.25, size.max = 4, size.default = 2){

  if (!is.na(size) & "data" %in% slotNames(obj)) {
    # If data is numeric
    if (is.numeric(obj[[size]])) {
      max.value <- max(obj[[size]], na.rm = TRUE)
      size.values <- (obj[[size]] / max.value) * size.max + size.min
    }
    # Otherwise: factor, character, logical, ...
    else {
      if (!is.factor(obj[[size]]))
        obj[[size]] <- factor(obj[[size]])

      # compute number of levels
      nl <- nlevels(obj[[size]])
      # compute the different size values
      sizes.levels <- seq(size.min, size.max, length.out = nl)
      # affect them to the factor
      sizes.values <- cut(obj[[size]], breaks = quantile(obj[[size]], probs=seq(0, 1, length.out = nl + 1)), labels = sizes.levels, include.lowest = TRUE)
      sizes.values <- as.numeric(as.character(sizes.values))
    }
  }
  # If no size aesthetic is asked, or if no data slot
  else
    size.values <- rep(size.default, length.out = nrow(obj))

  size.values
}

# Width (lines)
kml_width <- function(obj, width, width.min = 0.1, width.max = 5, width.default = 1){

}
