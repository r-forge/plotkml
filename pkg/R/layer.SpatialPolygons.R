kml_layer.SpatialPolygons <- function(
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

  # Style
  # =====
  for (i.poly in 1:length(obj)) {  # for each line
    write(paste('\t<Style id="', 'poly', i.poly,'">', sep = ""), file, append = TRUE)
    write("\t\t<PolyStyle>", file, append = TRUE)
    write(paste('\t\t\t<color>', colours[i.poly], '</color>', sep = ""), file, append = TRUE)
    write("\t\t</PolyStyle>", file, append = TRUE)
    write("\t</Style>", file, append = TRUE) 
  }

  # Writing polygons
  # ================
  for (i.poly in 1:length(obj)) {  # for each line

    current.poly.coords <- obj@polygons[[i.poly]]@Polygons[[1]]@coords
    current.poly.is.hole <- obj@polygons[[i.poly]]@Polygons[[1]]@hole
    current.poly.length <- nrow(current.poly.coords)
    current.poly.id <- obj@polygons[[i.poly]]@ID
    
    # Placemark
    write("\t<Placemark>", file, append = TRUE)
    write(paste("\t\t<name>", current.poly.id, "</name>", sep = ""), file, append = TRUE)
    write(paste('\t\t<styleUrl>#poly', i.poly, '</styleUrl>', sep = ""), file, append = TRUE)

    write("\t\t<Polygon>", file, append = TRUE)
    write(paste('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file, append = TRUE)

    write("\t\t<outerBoundaryIs>", file, append = TRUE)
    write("\t\t<LinearRing>", file, append = TRUE)

    # Vertices coordinates:
    write("\t\t\t<coordinates>", file, append = TRUE) 
    # For each vertice in the current line
    for (i.point in 1:current.poly.length) {
      write(paste('\t\t\t\t', current.poly.coords[i.point, 1], ',', current.poly.coords[i.point, 2], ',', altitude[i.point], sep = ""), file, append = TRUE)
    }
    write("\t\t\t</coordinates>", file, append = TRUE)      

    write("\t\t</LinearRing>", file, append = TRUE)
    write("\t\t</outerBoundaryIs>", file, append = TRUE)

    write("\t\t</Polygon>", file, append = TRUE)
    write("\t</Placemark>", file, append = TRUE)
  }
  # Closing the folder
  cat("</Folder>\n", file = file, append = TRUE)
}

setMethod("kml_layer", "SpatialPolygons", kml_layer.SpatialPolygons)
