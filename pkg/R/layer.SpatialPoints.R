# This is the definition file for layer methods
# =============================================
#
# The layer() method is part of the set of core functions
# for KML generation.
#
# The idea is to have, beside the kml() methods for sp objects,
# basic function to build a KML file layer by layer.
# 
# It should allow to do something like:
#   > kml.open(file = "/tmp/foo.kml")
#   > layer(meuse, colour = log(zinc), col.region = rainbow(64)) # layer.SpatialPointsDataFrame is called
#   > layer(meuse.grid, colour = attr, col.region = topo.colours(64)) # layer.SpatialPixelsDataFrame is called
#   > kml.compress(file = "/tmp/foo.kml") # if needed - generates "/tmp/foo.kmz" instead of "/tmp/foo.kml"
#   > kml.close(file = "/tmp/foo.kml")
# 
# This should allow the user to writeany sp object in a KML file AND to use several folders.
# Of course, kml() methods would just be wrappers around these. There would be:
#   - layer.SpatialPoints(DataFrame)
#   - layer.SpatialPolygons(DataFrame)
#   - layer.SpatialPixels(DataFrame)
#   - layer.SpatialLines(DataFrame)
# One can also imagine to add:
#   - kml.legend(), called within a layer() method, to generate a legend for the current folder
#   - kml.text(), to put text somewhere, anytime.
#
# This file gathers the layer() methods. kml.compress(), kml.open() and kml.close() are in kml.utils.R
#
layer.SpatialPoints <- function(
  # options on the object to plot
  obj, 
  file = "points.kml",
  size = as.character(NA),
  colour = as.character(NA),
  elevation = NA, 

  # color scheme
  col.region = rainbow(64),
  col.default = "red",
  #size scheme
  plt.size.default = 1, 
  plt.size.max = 2,
  plt.size.min = 0.3,

  # KML options
  icon = "http://maps.google.com/mapfiles/kml/shapes/donut.png", 
  extrude = TRUE, 
  z.scale = 1, 
  elevation.default = 10,
  LabelScale = 0.7, 
  kmz = FALSE,
  kml.url = "http://www.opengis.net/kml/2.2",

  # user interaction
  progress = FALSE
){

  # Checking the projection is geo
  check_projection(obj)
  
  # Points names
  points.names <- kml_names(obj)

  # Parsing the call for aesthetics
  # and process them. This would give
  # us the whole set of aesthetics vectors
  #
  # This has to be a S4 method so that
  # only the aesthetics compatible with
  # the obj class will be generated.
  #
  # Finally, the aesthetics vectors would
  # be used using the following form:
  #   size.values <- aes[["size"]]
  #   colour.values <- aes[["colour"]]

  # Computing the size values vector
  if (!is.na(size)) {
    if (is.numeric(obj[[size]])) {
      maxvar.size <- max(obj[[size]], na.rm = TRUE)
      size.values <- (obj[[size]] / maxvar.size) * plt.size.max + plt.size.min
    }
  }

  # Computing colours values vector
  if (!is.na(colour)) {
    if (is.numeric(obj[[colour]])) {
      minvar.colour <- min(obj[[colour]], na.rm = TRUE)
      maxvar.colour <- max(obj[[colour]], na.rm = TRUE)
      brks <- seq(min(obj[[colour]], na.rm = TRUE), max(obj[[colour]], na.rm = TRUE), length.out = length(col.region))
      grps <- cut(obj[[colour]], breaks = brks, include.lowest = TRUE)
      colour.values <- col.region[grps]
    }
  }

  # Computing the elevation values vector
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

  # Folder and name of the points folder
  cat("<Folder>\n", file = kml, append = TRUE)
  cat("<name>", as.character(substitute(obj, env = parent.frame())),"</name>\n", sep = "", file = kml, append = TRUE)

  # Writing points styles
  # =====================
  for (i in 1:nrow(obj)) {
    cat('\t<Style id="','pnt', i,'">\n',sep = "", file = kml, append = TRUE)
    cat("\t\t<LabelStyle>\n", file = kml, append = TRUE)     
    cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = kml, append = TRUE)
    cat("\t\t</LabelStyle>\n", file = kml, append = TRUE)
    cat("\t\t<IconStyle>\n", file = kml, append = TRUE)

    # If there is a particular variable to be represented by colour scale
    if (!is.na(colour) & is.numeric(obj[[colour]])) {
      cat('\t\t\t<color>', tolower(col2hcl(colour.values[i])), '</color>\n', sep = "", file = kml, append = TRUE)
    }
    else {
      cat('\t\t\t<color>', tolower(col2hcl(col.default)), '</color>\n', sep = "", file = kml, append = TRUE)
    }

    # If there is a particular variable to be represented by size scale
    if (!is.na(size) & is.numeric(obj[[size]])) {
      cat("\t\t\t<scale>", size.values[i], "</scale>\n", sep = "", file = kml, append = TRUE)
    }
    else {
      cat("\t\t\t<scale>", plt.size.default, "</scale>\n", sep = "", file = kml, append = TRUE)
    }

    cat("\t\t\t<Icon>\n", file = kml, append = TRUE)
    cat('\t\t\t\t<href>', icon, '</href>\n', sep = "", file = kml, append = TRUE)
    cat("\t\t\t</Icon>\n", file = kml, append = TRUE)
    cat("\t\t</IconStyle>\n", file = kml, append = TRUE)
    cat("\t</Style>\n", file = kml, append = TRUE)
  }

  # Writing points coordinates
  # ==========================
  for (i in 1:nrow(obj)) {
    cat("\t<Placemark>\n", file = kml, append = TRUE)
    cat("\t\t<name>", points.names[i],"</name>\n", sep = "", file = kml, append = TRUE)
    cat("\t\t<styleUrl>#pnt",i,"</styleUrl>\n", sep = "", file = kml, append = TRUE)
    cat("\t\t<Point>\n", file = kml, append = TRUE)

    # If there's elevation information to be represented
    if (sd(elevation, na.rm = TRUE) > 0) {
      cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep = "", file = kml, append = TRUE)
      cat('\t\t\t<altitudeMode>', elevation.mode, '</altitudeMode>\n', sep = "", file = kml, append = TRUE)
    }

    cat("\t\t\t<coordinates>", coordinates(obj)[i, 1], ",", coordinates(obj)[i, 2], ",", elevation[i]*z.scale,"</coordinates>\n", sep = "", file = kml, append = TRUE)
    cat("\t\t</Point>\n", file = kml, append = TRUE)
    cat("\t</Placemark>\n", file = kml, append = TRUE)

  }

  # Closing the folder
  cat("</Folder>\n", file = kml, append = TRUE)
  
}
