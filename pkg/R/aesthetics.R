# List of available aesthetics is given .all_kml_aesthetics
# along with their default values
.all_kml_aesthetics <- list(
  placemark.name = "",
  colours = "#ff000000",
  colour.pal = "",
  var.name = "",
  fill = "white",
  shape.url = "http://plotkml.r-forge.r-project.org/", #"http://maps.google.com/mapfiles/kml/shapes/donut.png"
  shape = "circle.png", 
  whitening = "",
  alpha = 1,
  size = 1,
  width = 1,
  altitude = 0,
  factor.labels = "",
  balloon = FALSE
)

# Parsing a call
#
.parse_call_for_aes <- function(call) {
  called_options <- names(call)
  ind_aes <- charmatch(called_options, names(.all_kml_aesthetics))

  names(.all_kml_aesthetics)[ind_aes[!is.na(ind_aes)]]
}

# Applying aesthetics
#
kml_aes <- function(obj, ...) {

  # Getting parent call
  parent_call <- substitute(list(...))
  parent_call <- as.list(parent_call)[-1]

  # Parse the current call
  called_aes <- .parse_call_for_aes(parent_call)

  aes <- list()

  # Names 
   if ("var.name" %in% called_aes & "data" %in% slotNames(obj)) {
   # If names defined using a column of data
      aes[['placemark.name']] <- as.character(obj[[parent_call[['var.name']]]])
   }
    
   else {
   if ("placemark.name" %in% called_aes) {
    # if names given as a vector
      placemark.name <- eval(parent_call[['placemark.name']])
      if (length(placemark.name) == length(obj))
        aes[['placemark.name']] <- as.character(placemark.name)
      else
        aes[['placemark.name']] <- rep(as.character(placemark.name), length.out = length(obj))
    }
    else {
    if (!("data" %in% slotNames(obj))) {
    aes[['placemark.name']] <- as.character(1:length(obj))
     }
    else
     aes[['placemark.name']] <- rownames(obj@data)
    }
   }

  # Colour
  if ("colour.pal" %in% called_aes & "data" %in% slotNames(obj)) {

    # If a column name has been used
    if ("var.name" %in% called_aes) {

     # Get the colour ramp
     aes[['colours']] <- kml_colour(obj, var.name = parent_call[['var.name']], colour.pal = parent_call[['colour.pal']])
 
    }
    # Otherwise use the default value
  else {
    if(length(parent_call[['colour.pal']])==1) {
        aes[['colours']] <- rep(.all_kml_aesthetics[["colours"]], length.out = length(obj))
    }
    else {  aes[['colours']] <- col2kml(parent_call[['colour.pal']])    }
  }
 }
   # Otherwise use the default colour ramp
  else {  aes[['colours']] <- kml_colour(obj, var.name = parent_call[['var.name']])  
  }


  # Whitening
#     if ("whitening" %in% called_aes) {
#       aes[['colours']] <- kml_whitening(obj, whitening, aes[['colours']], ...)
#     }

  # Shape.url
  if ("shape.url" %in% called_aes) {
    aes[["shape.url"]] <- kml_shape.url(obj, shape.url, ...)
  }
  else {
    aes[["shape.url"]] <- rep(.all_kml_aesthetics[["shape.url"]], length.out = length(obj))
  }
  
  # Shape
  if ("shape" %in% called_aes) {
    aes[["shape"]] <- kml_shape(obj, shape, ...)
  }
  else {
    aes[["shape"]] <- rep(.all_kml_aesthetics[["shape"]], length.out = length(obj))
  }

  # Size
  if ("size" %in% called_aes) {
    # If a column name as been used
    if (is.name(parent_call[['size']])){
      aes[['size']] <- kml_size(obj, size = as.character(parent_call[['size']]))
    }
    # Otherwise it is interpreted as a colour to use
    else {
      aes[['size']] <- rep(parent_call[['size']], length.out = length(obj))
    }
  }
  else {
    aes[['size']] <- rep(.all_kml_aesthetics[["size"]], length.out = length(obj))
  }

  # Width
  if ("width" %in% called_aes) {
    aes[['width']] <- kml_width(obj, width, ...)
  }
  else {
    aes[['width']] <- rep(.all_kml_aesthetics[["width"]], length.out = length(obj))
  }

  # Alpha
  if ("alpha" %in% called_aes) {
    aes[['alpha']] <- kml_alpha(obj, alpha, ...)
  }
  else {
    aes[['alpha']] <- rep(.all_kml_aesthetics[["alpha"]], length.out = length(obj))
  }

  # Altitude
  if ("altitude" %in% called_aes) {
    aes[['altitude']] <- kml_altitude(obj, altitude, ...)
  }
  else {
#     aes[['altitude']] <- rep(.all_kml_aesthetics[["altitude"]], length.out = length(obj))
    aes[['altitude']] <- kml_altitude(obj)
  }

  # AltitudeMode
  aes[["altitudeMode"]] <- kml_altitude_mode(aes[['altitude']])

  # Balloon (pop ups)
  if ("balloon" %in% called_aes) {
    aes[['balloon']] <- parent_call[['balloon']]
  }
  else {
    aes[['balloon']] <- .all_kml_aesthetics[["balloon"]]
  }
  # Values
  if ("values" %in% called_aes) {
   
  }
  aes
}

## Convert values to KML colours
# valid for: points, polygons, lines, raster)
kml_colour <- function(obj, var.name, colour.pal = rev(rainbow(65)[1:48])){

  require(ggplot2) # /!\ for the rescale function, soon to be in the scales package /!\
  require(colorRamps)

  # Vector of input values
  if (is.character(var.name))
    x <- obj[[as.character(var.name)]]
  else if (is.call(var.name))
    x <- eval(var.name, envir = obj@data)
  
  # If the scale is continuous
  if (is.numeric(x)) {
    pal <- colorRamp(colour.pal, space = "rgb", interpolate = "linear") # creates pal function
    xn <- ggplot2::rescale(x) # putting values between 0 and 1
    cols <- col2kml(rgb(pal(xn) / 255))
  }

  # Otherwise
  else {
    xf <- data.frame(flev=as.factor(x))
      if(missing(colour.pal)) {
      colour.pal <- rainbow(length(levels(xf$flev)))
      }  
    r.cols <- data.frame(flev=levels(xf$flev), cols=col2kml(colour.pal))
    cols <- merge(xf, r.cols, by="flev")$cols
  }

  cols
}


# Shape (points)
kml_shape <- function(obj, shape, ...){
  shape = rep(shape, length.out = length(obj))
}

# Shape.url (points)
kml_shape.url <- function(obj, shape.url, ...){
  shape.url = rep(shape.url, length.out = length(obj))
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
kml_size <- function(obj, size, size.min = 0.25, size.max = 4, size.default = 1){

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
    size.values <- rep(size.default, length.out = length(obj))

  size.values
}

# Width (lines)
kml_width <- function(obj, width, width.min = 0.1, width.max = 5, width.default = 1){

}
