# Aesthetics mapping
#
# 4 kinds of aesthetics are supported by plotKML:
#   - colour (points, polygons, lines, raster)
#   - opacity (points, polygons, lines, raster)
#   - size (points)
#   - width (lines)
#   - + elevation (though not stricktly speaking a aesthetic)
#
# These functions will generate the aesthetics vector in the format needed by
# the KML specs.

# List of available aesthetics is given .all_kml_aesthetics
# along with their default values
.all_kml_aesthetics <- list(
  colour = "black",
  whitening = "",
  alpha = 1,
  size = 2,
  width = 1,
  altitude = ""
)


# Creates a list of default values for
# every available aesthetic.
#
.kml_aes_default <- function(obj){

  require(plyr)

  res <- llply(.all_kml_aesthetics, rep, length.out = nrow(coordinates(obj)))

  for (i_aes in .all_kml_aesthetics) {
    res[[i_aes]] <- 
  }
}

# Maybe not useful - rather code it straight in
# the layer.* functions.
kml_aes <- function(obj, ...){
  
  # Getting parent call
  parent_call <- sys.call()[[sys.nframe() - 1]]

  # Deparse the current call
  parent_call <- structure(as.list(parent_call), class="uneval")
  called_options <- names(parent_call)
  ind_aes <- charmatch(called_options, names(.all_kml_aesthetics))
  called_aes <- names(.all_kml_aesthetics)[ind_aes[!is.na(ind_aes)]]

  # Make a data.frame: | option name | value |
  aes <- .kml_aes_default(obj)

  # Modify those default values for called aesthetics
  for (i_aes in 1:length(called_aes)) {
    cur_aes <- called_aes[i_aes]
    fun <- paste("kml_", cur_aes, sep = "")
    aes[[cur_aes]] <- do.call(fun, list(obj, ...))
  }
    
  aes
}



# Colour (points, polygons, lines, raster)
kml_colour <- function(obj, colour, col.region = rainbow(64), col.default = "black"){
  
}

# Opacity (points, polygons, lines, raster)
kml_alpha <- function(obj, alpha.default = 1){

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
