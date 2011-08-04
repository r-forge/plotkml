# This file gathers the layer() methods. kml.compress(), kml.open() and kml.close() are in kml.utils.R
#
kml_layer.SpatialPoints <- function(
  # options on the object to plot
  obj,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  z.scale = 1,
  LabelScale = 0.7,
  ...
  ){
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  # Checking the projection is geo
  check <- check_projection(obj, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check)
    obj <- reproject(obj)

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  points_names <- aes[["labels"]]
  colours <- aes[["colour"]]
  shapes <- aes[["shape"]]
  sizes <- aes[["size"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Folder and name of the points folder
  cat("<Folder>\n", file = file.connection, append = TRUE)
  cat("<name>", title, "</name>\n", sep = "", file = file.connection, append = TRUE)

  # Writing points styles
  # =====================
  for (i_pt in 1:length(obj)) {
    cat('\t<Style id="','pnt', i_pt,'">\n',sep = "", file = file.connection, append = TRUE)

    # Label
    cat("\t\t<LabelStyle>\n", file = file.connection, append = TRUE)
    cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = file.connection, append = TRUE)
    cat("\t\t</LabelStyle>\n", file = file.connection, append = TRUE)

    # Icon
    cat("\t\t<IconStyle>\n", file = file.connection, append = TRUE)

    # Aesthetics
    cat('\t\t\t<color>', colours[i_pt], '</color>\n', sep = "", file = file.connection, append = TRUE)
    cat("\t\t\t<scale>", sizes[i_pt], "</scale>\n", sep = "", file = file.connection, append = TRUE)
    cat("\t\t\t<Icon>\n", file = file.connection, append = TRUE)
    cat('\t\t\t\t<href>', shapes[i_pt], '</href>\n', sep = "", file = file.connection, append = TRUE)
    cat("\t\t\t</Icon>\n", file = file.connection, append = TRUE)
    cat("\t\t</IconStyle>\n", file = file.connection, append = TRUE)
    cat("\t</Style>\n", file = file.connection, append = TRUE)
  }

  # Writing points coordinates
  # ==========================
  for (i_pt in 1:length(obj)) {
    cat("\t<Placemark>\n", file = file.connection, append = TRUE)
    cat("\t\t<name>", points_names[i_pt],"</name>\n", sep = "", file = file.connection, append = TRUE)

    # Add description with attributes
    if (balloon & ("data" %in% slotNames(obj)))
      .df_to_kml_html_table(obj@data[i_pt, ])

    cat("\t\t<styleUrl>#pnt", i_pt,"</styleUrl>\n", sep = "", file = file.connection, append = TRUE)
    cat("\t\t<Point>\n", file = file.connection, append = TRUE)

    # If there's altitude information to be represented
#     if (sd(altitude, na.rm = TRUE) > 0) {
      cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep = "", file = file.connection, append = TRUE)
      cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep = "", file = file.connection, append = TRUE)
#     }

    cat("\t\t\t<coordinates>", coordinates(obj)[i_pt, 1], ",", coordinates(obj)[i_pt, 2], ",", altitude[i_pt] * z.scale,"</coordinates>\n", sep = "", file = file.connection, append = TRUE)
    cat("\t\t</Point>\n", file = file.connection, append = TRUE)
    cat("\t</Placemark>\n", file = file.connection, append = TRUE)

  }

  # Closing the folder
  cat("</Folder>\n", file = file.connection, append = TRUE)

}

setMethod("kml_layer", "SpatialPoints", kml_layer.SpatialPoints)
