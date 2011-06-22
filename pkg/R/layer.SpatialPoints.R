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
  altitude = NA, 

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
  altitude.default = 10,
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
  aes <- kml_aes(obj, ...)

  # read the relevant aesthetics
  size.values <- aes[["size"]]
  colours.values <- aes[["colour"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]

#   # Computing the size values vector
#   if (!is.na(size)) {
#     if (is.numeric(obj[[size]])) {
#       maxvar.size <- max(obj[[size]], na.rm = TRUE)
#       size.values <- (obj[[size]] / maxvar.size) * plt.size.max + plt.size.min
#     }
#   }
# 
#   # Computing colours values vector
#   if (!is.na(colour)) {
#     if (is.numeric(obj[[colour]])) {
#       minvar.colour <- min(obj[[colour]], na.rm = TRUE)
#       maxvar.colour <- max(obj[[colour]], na.rm = TRUE)
#       brks <- seq(min(obj[[colour]], na.rm = TRUE), max(obj[[colour]], na.rm = TRUE), length.out = length(col.region))
#       grps <- cut(obj[[colour]], breaks = brks, include.lowest = TRUE)
#       colour.values <- col.region[grps]
#     }
#   }
# 
#   # Computing the elevation values vector
#   if (is.character(elevation)) {
#     # The character describes the name of a column
#     elevation.mode <- "absolute"
#     elevation <- obj[[elevation]]
#   }
#   else if (is.numeric(elevation)) {
#     # If it is numeric this is a single elevation for all points
#     elevation.mode <- "relativeToGround"
#     elevation <- rep(elevation, length.out = nrow(obj))
#   }
#   else if (is.na(elevation)) {
#     elevation.mode <- "clampToGround"
#     elevation <- rep(elevation.default, length.out = nrow(obj))
#   }
#   else   
#     stop("Bad elevation value")

  # Folder and name of the points folder
  cat("<Folder>\n", file = file, append = TRUE)
  cat("<name>", as.character(substitute(obj, env = parent.frame())),"</name>\n", sep = "", file = file, append = TRUE)

  # Writing points styles
  # =====================
  for (i_pt in 1:nrow(obj)) {
    cat('\t<Style id="','pnt', i_pt,'">\n',sep = "", file = file, append = TRUE)

    # Label
    cat("\t\t<LabelStyle>\n", file = file, append = TRUE)     
    cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = file, append = TRUE)
    cat("\t\t</LabelStyle>\n", file = file, append = TRUE)

    # Icon
    cat("\t\t<IconStyle>\n", file = file, append = TRUE)

    # Aesthetics
    cat('\t\t\t<color>', colour.values[i_pt], '</color>\n', sep = "", file = file, append = TRUE)
    cat("\t\t\t<scale>", size.values[i_pt], "</scale>\n", sep = "", file = file, append = TRUE)
    cat("\t\t\t<Icon>\n", file = file, append = TRUE)
    cat('\t\t\t\t<href>', icon, '</href>\n', sep = "", file = file, append = TRUE)
    cat("\t\t\t</Icon>\n", file = file, append = TRUE)
    cat("\t\t</IconStyle>\n", file = file, append = TRUE)
    cat("\t</Style>\n", file = file, append = TRUE)
  }

  # Writing points coordinates
  # ==========================
  for (i_pt in 1:nrow(obj)) {
    cat("\t<Placemark>\n", file = file, append = TRUE)
    cat("\t\t<name>", points.names[i_pt],"</name>\n", sep = "", file = file, append = TRUE)
    cat("\t\t<styleUrl>#pnt", i_pt,"</styleUrl>\n", sep = "", file = file, append = TRUE)
    cat("\t\t<Point>\n", file = file, append = TRUE)

    # If there's altitude information to be represented
    if (sd(altitude, na.rm = TRUE) > 0) {
      cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep = "", file = file, append = TRUE)
      cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep = "", file = file, append = TRUE)
    }

    cat("\t\t\t<coordinates>", coordinates(obj)[i_pt, 1], ",", coordinates(obj)[i_pt, 2], ",", altitude[i_pt]*z.scale,"</coordinates>\n", sep = "", file = file, append = TRUE)
    cat("\t\t</Point>\n", file = file, append = TRUE)
    cat("\t</Placemark>\n", file = file, append = TRUE)

  }

  # Closing the folder
  cat("</Folder>\n", file = file, append = TRUE)
  
}
