kml_layer.SpatialLines <- function(
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
  lines_names<- aes[["labels"]]
  colours <- aes[["colour"]]
  width <- aes[["width"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Folder and name of the points folder
  cat("<Folder>\n", file = file.connection, append = TRUE)
  cat("<name>", title, "</name>\n", sep = "", file = file.connection, append = TRUE)

  # Styles
  # ======
  for (i.line in 1:length(obj)) {  # for each line
    write(paste('\t<Style id="', 'line', i.line,'">', sep = ""), file.connection, append = TRUE)
    write("\t\t<LineStyle>", file.connection, append = TRUE)
    write(paste('\t\t\t<color>', colours[i.line], '</color>', sep = ""), file.connection, append = TRUE)
    write(paste('\t\t\t<width>', width[i.line], '</width>', sep = ""), file.connection, append = TRUE)
    write("\t\t</LineStyle>", file.connection, append = TRUE)
    # balloon
    cat("\t\t<BalloonStyle>\n", file = file.connection, append = TRUE)
    cat("\t\t\t<text>$[description]</text>\n", file = file.connection, append = TRUE)
    cat("\t\t</BalloonStyle>\n", file = file.connection, append = TRUE)
    write("\t</Style>", file.connection, append = TRUE)
  }

  # Writing lines
  # =============
  for (i.line in 1:length(obj)) {  # for each line

    current.line.coords <- obj@lines[[i.line]]@Lines[[1]]@coords
    current.line.length <- nrow(current.line.coords)
    current.line.id <- lines_names[i.line]

    write("\t<Placemark>", file.connection, append = TRUE)
    write(paste("\t\t<name>", current.line.id, "</name>", sep = ""), file.connection, append = TRUE)
    write(paste('\t\t<styleUrl>#line', i.line, '</styleUrl>', sep = ""), file.connection, append = TRUE)

    # Add description with attributes
    if (balloon & ("data" %in% slotNames(obj)))
      .df_to_kml_html_table(obj@data[i.line, ])

    write("\t\t<LineString>", file.connection, append = TRUE)

    write(paste('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file.connection, append = TRUE)
    write("\t\t\t<coordinates>", file.connection, append = TRUE)

    # For each vertice in the current line
    for (i.point in 1:current.line.length) {
      write(paste('\t\t\t\t', current.line.coords[i.point, 1], ",", current.line.coords[i.point, 2], ',', altitude[i.point], sep = ""), file.connection, append = TRUE)
    }

    write("\t\t\t</coordinates>", file.connection, append = TRUE)
    write("\t\t</LineString>", file.connection, append = TRUE)
    write("\t</Placemark>", file.connection, append = TRUE)
  }

  # Closing the folder
  cat("</Folder>\n", file = file.connection, append = TRUE)
}

setMethod("kml_layer", "SpatialLines", kml_layer.SpatialLines)
