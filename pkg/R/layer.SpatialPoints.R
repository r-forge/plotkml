# R function for the plotKML package
# Author: Pierre Roudier, Tomislav Hengl
# contact: pierre.roudier@gmail.com & tom.hengl@wur.nl
# Date : July 2011
# Version 0.1
# Licence GPL v3


# This gathers the layer() methods. kml_compress(), kml_open() and kml_close() are in utils.R
#
kml_layer.SpatialPoints <- function(
  # options on the object to plot
  obj,
  var.name = as.character(substitute(obj, env = parent.frame())),
  file,
  filename,
  shapes.url = "http://plotkml.r-forge.r-project.org/", #"http://maps.google.com/mapfiles/kml/shapes/donut.png"
  colour.pal = "",
  extrude = TRUE,
  z.scale = 1,
  LabelScale = 0.7,
  ...
  ){

  # Checking the projection is geo
  check <- check_projection(obj)

  # Trying to reproject data if the check was not successful
   if (!check)
   {  obj <- spTransform(obj, CRS("+proj=longlat +datum=WGS84")) }

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)
  

  # Read the relevant aesthetics
  points_names <- aes[["placemark.name"]]
  colours <- aes[["colours"]]
  shapes <- aes[["shape"]]
  sizes <- aes[["size"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Folder and name of the points folder
  cat("<Folder>\n", file = filename, append = TRUE)
  cat("<name>", var.name, "</name>\n", sep = "", file = filename, append = TRUE)

  # Writing points styles
  # =====================
  for (i_pt in 1:length(obj)) {
    cat('\t<Style id="','pnt', i_pt,'">\n',sep = "", file = filename, append = TRUE)

    # Label
    cat("\t\t<LabelStyle>\n", file = filename, append = TRUE)
    cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = filename, append = TRUE)
    cat("\t\t</LabelStyle>\n", file = filename, append = TRUE)

    # Icon
    cat("\t\t<IconStyle>\n", file = filename, append = TRUE)

    # Aesthetics
    cat('\t\t\t<color>', colours[i_pt], '</color>\n', sep = "", file = filename, append = TRUE)
    cat("\t\t\t<scale>", sizes[i_pt], "</scale>\n", sep = "", file = filename, append = TRUE)
    cat("\t\t\t<Icon>\n", file = filename, append = TRUE)
    cat('\t\t\t\t<href>', shapes.url[i_pt], shapes[i_pt], '</href>\n', sep = "", file = filename, append = TRUE)
    cat("\t\t\t</Icon>\n", file = filename, append = TRUE)
    cat("\t\t</IconStyle>\n", file = filename, append = TRUE)
    cat("\t</Style>\n", file = filename, append = TRUE)
  }

  # Writing points coordinates
  # ==========================
  # create a progress bar:
  pb <- txtProgressBar(min=0, max=length(obj), style=3)
  for (i_pt in 1:length(obj)) {
    cat("\t<Placemark>\n", file = filename, append = TRUE)
    cat("\t\t<name>", points_names[i_pt], "</name>\n", sep="", file = filename, append = TRUE)

    # Add description with attributes
    if (balloon & ("data" %in% slotNames(obj)))
      .df_to_kml_html_table(obj@data[i_pt, ], file = filename)

    cat("\t\t<styleUrl>#pnt", i_pt,"</styleUrl>\n", sep="", file = filename, append = TRUE)
    cat("\t\t<Point>\n", file = filename, append = TRUE)

    # If there's altitude information to be represented
#     if (sd(altitude, na.rm = TRUE) > 0) {
      cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep="", file = filename, append = TRUE)
      cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', file = filename, append = TRUE)
#     }

    cat("\t\t\t<coordinates>", coordinates(obj)[i_pt, 1], ",", coordinates(obj)[i_pt, 2], ",", altitude[i_pt] * z.scale,"</coordinates>\n", sep="", file = filename, append = TRUE)
    cat("\t\t</Point>\n", file = filename, append = TRUE)
    cat("\t</Placemark>\n", file = filename, append = TRUE)
  # update progress bar
  setTxtProgressBar(pb, i_pt)
  }
  close(pb)

  # Writing the legend file

  if(!summary(colours %in% colours[1])[[3]]==0) {
  # write a PNG:
  kml_legend(x=obj[[var.name]], var.name=var.name, legend.file=paste(var.name, '_legend.png', sep=""), legend.pal=colour.pal)
  cat('\t<ScreenOverlay>\n', file = filename, append = TRUE)
  cat('\t\t<name>Legend</name>\n', file = filename, append = TRUE)
  cat('\t\t<Icon>\n', file = filename, append = TRUE)
  cat('\t\t\t<href>', var.name, '_legend.png', '</href>\n', sep="", file = filename, append = TRUE)
  cat('\t\t</Icon>\n', file = filename, append = TRUE)
  cat('\t\t<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>\n', file = filename, append = TRUE)
  cat('\t\t<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>\n', file = filename, append = TRUE)
  cat('\t\t<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>\n', file = filename, append = TRUE)
  cat('\t\t<size x="0" y="0" xunits="fraction" yunits="fraction"/>\n', file = filename, append = TRUE)
  cat('\t</ScreenOverlay>\n', file = filename, append = TRUE)
}
  
  # Closing the folder
  cat("</Folder>\n", file = filename, append = TRUE)

}

setMethod("kml_layer", "SpatialPoints", kml_layer.SpatialPoints)
