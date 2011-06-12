kml.SpatialPointsDataFrame <- function(

  # options on the object to plot
  obj, 

  file = "bubble_plot.kml",
  size = as.character(NA),
  colour = as.character(NA),

  # color scheme
  col.region = rainbow(64),
  col.default = "red",
  #size scheme
  plt.size.default = 1, 
  plt.size.max = 2,
  plt.size.min = 0.3,

  # KML options
  icon = "http://maps.google.com/mapfiles/kml/shapes/donut.png", 
  altitudeMode = "absolute", 
  above.ground = rep(10, nrow(obj)), 
  extrude = TRUE, 
  z.scale = 1, 
  LabelScale = 0.7, 
  kmz = FALSE,
  kml.url = "http://www.opengis.net/kml/2.2",

  # user interaction
  progress = FALSE
){

  # Checking the projection is geo
  if (proj4string(obj) != " +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
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

  # Points names
  if (is.na(size)) {
    if (is.na(colour))
      points.names <- 1:nrow(obj)
    else
      points.names <- obj[[colour]]
  }
  else {
    if (is.na(size))
      points.names <- 1:nrow(obj)
    else
      points.names <- obj[[size]]
  }
  
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

  # Writing header (Maybe to be externalised in a dedicated function
  # as I guess it'd be used in other bits of code)
  # ==============
  cat("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", file = kml)
  cat('<kml xmlns=\"', kml.url, '\">\n', sep = "", file = kml, append = TRUE)
  cat("<Document>\n", file= kml, append = TRUE)
  cat("<name>", as.character(substitute(obj)), "</name>\n", sep = "", file = kml, append = TRUE)
  cat("<open>1</open>\n", file = kml, append = TRUE)

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
      # NEED TO COMPUTE COLOUR OF THE CURRENT VALUE EARLIER
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

    # Folder and name of the points folder
    cat("<Folder>\n", file = kml, append = TRUE)
    cat("<name>", points.names[i],"</name>\n", sep = "", file = kml, append = TRUE)

    # Optionaly initiates progress bar
    if (progress) {
      cat('Writing points to KML file...\n')
      pb <- txtProgressBar(min = 0, max = nrow(obj), style = 3)
    }

    # Writing points coordinates
    # ==========================
    for (i in 1:nrow(obj)) {
      cat("\t<Placemark>\n", file = kml, append = TRUE)
      cat("\t\t<name>", points.names[i],"</name>\n", sep = "", file = kml, append = TRUE)
      cat("\t\t<styleUrl>#pnt",i,"</styleUrl>\n", sep = "", file = kml, append = TRUE)
      cat("\t\t<Point>\n", file = kml, append = TRUE)

      # If there's elevation information to be represented
      if (sd(above.ground, na.rm = TRUE) > 0) {
        cat('\t\t\t<extrude>', as.numeric(extrude), '</extrude>\n', sep = "", file = kml, append = TRUE)
        cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep = "", file = kml, append = TRUE)
      }

      cat("\t\t\t<coordinates>", coordinates(obj)[i, 1], ",", coordinates(obj)[i, 2], ",", above.ground[i]*z.scale,"</coordinates>\n", sep = "", file = kml, append = TRUE)
      cat("\t\t</Point>\n", file = kml, append = TRUE)
      cat("\t</Placemark>\n", file = kml, append = TRUE)

      # Update progress bar
      if (progress) 
        setTxtProgressBar(pb, i)
    }

    cat("</Folder>\n", file = kml, append = TRUE)
    cat("</Document>\n", file = kml, append = TRUE)
    cat("</kml>\n", file = kml, append = TRUE)

    # Closing progress bar
    if (progress) 
      close(pb)
  
    # Closing file
    close(kml)

    if (kmz) {
      file.remove(kmz.name)
      zip(kmz.name, file)
      file.remove(file)
    }
}
