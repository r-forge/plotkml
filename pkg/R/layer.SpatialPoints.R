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
kml_layer.SpatialPoints <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  z.scale = 1,
  LabelScale = 0.7,
  ...
  ){

  # Checking the projection is geo
  check <- check_projection(obj, logical = FALSE)

  # Trying to reproject data if the check was not successful
#   if (!check)
#     obj <- reproject(obj)

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  points_names<- aes[["name"]]
  colours <- aes[["colour"]]
  shapes <- aes[["shape"]]
  sizes <- aes[["size"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]

  # Folder and name of the points folder
  cat("<Folder>\n", file = file, append = TRUE)
  cat("<name>", title, "</name>\n", sep = "", file = file, append = TRUE)

  # Writing points styles
  # =====================
  for (i_pt in 1:length(obj)) {
    cat('\t<Style id="','pnt', i_pt,'">\n',sep = "", file = file, append = TRUE)

    # Label
    cat("\t\t<LabelStyle>\n", file = file, append = TRUE)
    cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = file, append = TRUE)
    cat("\t\t</LabelStyle>\n", file = file, append = TRUE)

    # Icon
    cat("\t\t<IconStyle>\n", file = file, append = TRUE)

    # Aesthetics
    cat('\t\t\t<color>', colours[i_pt], '</color>\n', sep = "", file = file, append = TRUE)
    cat("\t\t\t<scale>", sizes[i_pt], "</scale>\n", sep = "", file = file, append = TRUE)
    cat("\t\t\t<Icon>\n", file = file, append = TRUE)
    cat('\t\t\t\t<href>', shapes[i_pt], '</href>\n', sep = "", file = file, append = TRUE)
    cat("\t\t\t</Icon>\n", file = file, append = TRUE)
    cat("\t\t</IconStyle>\n", file = file, append = TRUE)
    cat("\t</Style>\n", file = file, append = TRUE)
  }

  # Writing points coordinates
  # ==========================
  for (i_pt in 1:length(obj)) {
    cat("\t<Placemark>\n", file = file, append = TRUE)
    cat("\t\t<name>", points_names[i_pt],"</name>\n", sep = "", file = file, append = TRUE)
    cat("\t\t<styleUrl>#pnt", i_pt,"</styleUrl>\n", sep = "", file = file, append = TRUE)
    cat("\t\t<Point>\n", file = file, append = TRUE)

    # If there's altitude information to be represented
#     if (sd(altitude, na.rm = TRUE) > 0) {
      cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep = "", file = file, append = TRUE)
      cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep = "", file = file, append = TRUE)
#     }

    cat("\t\t\t<coordinates>", coordinates(obj)[i_pt, 1], ",", coordinates(obj)[i_pt, 2], ",", altitude[i_pt] * z.scale,"</coordinates>\n", sep = "", file = file, append = TRUE)
    cat("\t\t</Point>\n", file = file, append = TRUE)
    cat("\t</Placemark>\n", file = file, append = TRUE)

  }

  # Closing the folder
  cat("</Folder>\n", file = file, append = TRUE)

}

setMethod("kml_layer", "SpatialPoints", kml_layer.SpatialPoints)
