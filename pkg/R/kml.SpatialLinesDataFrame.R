kml.SpatialLinesDataFrame <- function(
  # Options on the object to plot
  obj, 
  file = "lines.kml",
  colour = NA,
  line.width = NA,
  elevation = NA,

  # Colour scheme
  col.region = rainbow(64),
  col.default = "white",

  # KML options  
  line.width.default = 1, 
  line.width.min = 0.3, 
  line.width.max = 4, 
  extrude = FALSE, 
  tessellate = FALSE, 
  LabelScale = 0.7,  

  kmz = FALSE, 
  kml.url = "http://www.opengis.net/kml/2.2",

  progress = FALSE
){

  # Checking the projection is geo
  if (is.na(proj4string(obj)) | proj4string(obj) != " +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
    stop('plotKML <3 "+proj=longlat +datum=WGS84"')

  # If the user wants a KMZ, we store the KML in a tmp file
  if (kmz) {
    if (require(Rcompression)) {
      kmz.name <- file
      file <- tempfile()
    }
    else 
      stop("On-the-fly KMZ generation requires the Rcompression package. Alternatively, you can zip the KML file yourself and rename it KMZ.")
  }

  # creating the file and opening it in writing mode
  kml <- file(file, "w",  blocking = FALSE)

  # Lines names
  if (is.na(colour) | !(colour %in% names(obj)))
    lines.names <- 1:nrow(obj)
  else
    lines.names <- obj[[colour]]
  
  # Computing colours values vector
  if (!is.na(colour)) {
    if (colour %in% names(obj)) {
      if (is.numeric(obj[[colour]])) {
        minvar.colour <- min(obj[[colour]], na.rm = TRUE)
        maxvar.colour <- max(obj[[colour]], na.rm = TRUE)
        brks <- seq(min(obj[[colour]], na.rm = TRUE), max(obj[[colour]], na.rm = TRUE), length.out = length(col.region))
        grps <- cut(obj[[colour]], breaks = brks, include.lowest = TRUE)
        colour.values <- col.region[grps]
      }
    }
    else
      colour.values <- rep(tolower(col2hcl(col.region)), length.out = nrow(obj))
  }
  else
    colour.values <- rep(tolower(col2hcl(col.default)), length.out = nrow(obj))

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
  }
  else   
    stop("Bad elevation value")

  # Writing header (Maybe to be externalised in a dedicated function
  # as I guess it'd be used in other bits of code)
  # ==============
  write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", kml)
  write(paste('<kml xmlns=\"', kml.url, '\">', sep = ""), kml, append = TRUE)
  write("\t<Document>", kml, append = TRUE)
  write(paste("<name>", as.character(substitute(obj, env = parent.frame())), "</name>", sep = ""), kml, append = TRUE)
  write("<open>1</open>", kml, append = TRUE)

  # Optionaly initiates progress bar
  if (progress) {
    cat('Writing points to KML file...\n')
    pb <- txtProgressBar(min = 0, max = nrow(obj), style = 3)
  }

  # Writing lines
  # =============
  for (i.line in 1:nrow(obj)) {  # for each line

    current.line.coords <- obj@lines[[i.line]]@Lines[[1]]@coords
    current.line.length <- nrow(current.line.coords)
    current.line.id <- lines.names[i.line]

    if (!is.na(colour)) {
      write(paste('  <Style id="', 'line', i.line,'">', sep = ""), kml, append = TRUE)
      write("          <LineStyle>", kml, append = TRUE)
      write(paste('  <color>', colour.values[i.line], '</color>', sep = ""), kml, append = TRUE)
      write(paste('  <width>', line.width.default, '</width>', sep = ""), kml, append = TRUE)
      write("		</LineStyle>", kml, append = TRUE)
      write("		</Style>", kml, append = TRUE) 
    }
#     # write(" <Folder>", kml, append = TRUE)

    write("\t<Placemark>", kml, append = TRUE)
    write(paste("\t\t<name>", current.line.id, "</name>", sep = ""), kml, append = TRUE)
    write(paste('   <styleUrl>#line', i.line, '</styleUrl>', sep = ""), kml, append = TRUE)
    write("\t\t<LineString>", kml, append = TRUE)
    write(paste('		<extrude>', as.numeric(extrude), '</extrude>', sep = ""), kml, append = TRUE)
    write(paste('		<tessellate>', as.numeric(tessellate), '</tessellate>', sep = ""), kml, append = TRUE)
    write(paste('\t\t\t<altitudeMode>', elevation.mode, '</altitudeMode>', sep = ""), kml, append = TRUE)
    write("\t\t\t<coordinates>", kml, append = TRUE) 

    # For each vertice in the current line
    for (i.point in 1:current.line.length) {
      write(paste('\t\t\t\t', current.line.coords[i.point, 1], current.line.coords[i.point, 2], elevation[i.point], sep = ", "), kml, append = TRUE)
    }
    
    write("\t\t\t</coordinates>", kml, append = TRUE)      
    write("\t\t</LineString>", kml, append = TRUE)
    write("\t</Placemark>", kml, append = TRUE)

    # Update progress bar
    if (progress) 
      setTxtProgressBar(pb, i)
  }

    # Closing progress bar
    if (progress) 
      close(pb)

  # Closing file
#     cat("</Folder>\n", file = kml, append = TRUE)
  cat("</Document>\n", file = kml, append = TRUE)
  cat("</kml>\n", file = kml, append = TRUE)
  close(kml)

  if (kmz) {
    file.remove(kmz.name)
    zip(kmz.name, file)
    file.remove(file)
  }
}

setMethod("kml", "SpatialLinesDataFrame", kml.SpatialLinesDataFrame) 

