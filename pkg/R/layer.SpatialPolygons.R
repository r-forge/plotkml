kml_layer.SpatialPolygons <- function(
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
  poly_names <- aes[["labels"]]
  colours <- aes[["colour"]]
  sizes <- aes[["size"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Folder and name of the points folder
  cat("<Folder>\n", file = file.connection, append = TRUE)
  cat("<name>", title, "</name>\n", sep = "", file = file.connection, append = TRUE)

  # Style
  # =====
  for (i.poly in 1:length(obj)) {  # for each line
    write(paste('\t<Style id="', 'poly', i.poly,'">', sep = ""), file.connection, append = TRUE)
    write("\t\t<PolyStyle>", file.connection, append = TRUE)
    write(paste('\t\t\t<color>', colours[i.poly], '</color>', sep = ""), file.connection, append = TRUE)
    write("\t\t</PolyStyle>", file.connection, append = TRUE)
    # balloon
    cat("\t\t<BalloonStyle>\n", file = file.connection, append = TRUE)
    cat("\t\t\t<text>$[description]</text>\n", file = file.connection, append = TRUE)
    cat("\t\t</BalloonStyle>\n", file = file.connection, append = TRUE)
    write("\t</Style>", file.connection, append = TRUE)
  }

  # Writing polygons
  # ================
  for (i.poly in 1:length(obj)) {  # for each line

    current.poly.coords <- obj@polygons[[i.poly]]@Polygons[[1]]@coords
    current.poly.is.hole <- obj@polygons[[i.poly]]@Polygons[[1]]@hole
    current.poly.length <- nrow(current.poly.coords)
    current.poly.id <- poly_names[i.poly] # obj@polygons[[i.poly]]@ID

    # Placemark
    write("\t<Placemark>", file.connection, append = TRUE)
    write(paste("\t\t<name>", current.poly.id, "</name>", sep = ""), file.connection, append = TRUE)
    write(paste('\t\t<styleUrl>#poly', i.poly, '</styleUrl>', sep = ""), file.connection, append = TRUE)

    # Add description with attributes
    if (balloon & ("data" %in% slotNames(obj)))
      .df_to_kml_html_table(obj@data[i.poly, ])

    write("\t\t<Polygon>", file.connection, append = TRUE)
    write(paste('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file.connection, append = TRUE)

    write("\t\t<outerBoundaryIs>", file.connection, append = TRUE)
    write("\t\t<LinearRing>", file.connection, append = TRUE)

    # Vertices coordinates:
    write("\t\t\t<coordinates>", file.connection, append = TRUE)
    # For each vertice in the current line
    for (i.point in 1:current.poly.length) {
      write(paste('\t\t\t\t', current.poly.coords[i.point, 1], ',', current.poly.coords[i.point, 2], ',', altitude[i.point], sep = ""), file.connection, append = TRUE)
    }
    write("\t\t\t</coordinates>", file.connection, append = TRUE)

    write("\t\t</LinearRing>", file.connection, append = TRUE)
    write("\t\t</outerBoundaryIs>", file.connection, append = TRUE)

    write("\t\t</Polygon>", file.connection, append = TRUE)
    write("\t</Placemark>", file.connection, append = TRUE)
  }
  # Closing the folder
  cat("</Folder>\n", file = file.connection, append = TRUE)
}

setMethod("kml_layer", "SpatialPolygons", kml_layer.SpatialPolygons)
