kml_layer.SpatialPixels <- function(
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
  check <- check_projection(obj, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check)
    obj <- reproject(obj)

  # Parsing the call for "colour"
  call <- substitute(list(...))
  call <- as.list(call)[-1]

  # Parse the current call
  colour <- charmatch("colour", names(call))
  if (is.na(colour))
    stop("No attribute to map. Please use the colour=... option.")
  else
    data <- eval(call[["colour"]], envir = obj@data)

  altitude <- eval(call[["altitude"]], obj@data)
  altitude <- kml_altitude(obj, altitude = altitude)
  altitudeMode <- kml_altitude_mode(altitude)

  pal <- charmatch("colour_scale", names(call))
  if (!is.na(pal))
    pal <- eval(call[["colour_scale"]])
  else {
    if (is.numeric(data))
      pal <- .colour_scale_numeric
    else
      pal <- .colour_scale_factor
  }

  colour_scale <- colorRampPalette(pal)(length(data))

  # Transparency
  alpha <- charmatch("alpha", names(call))
  if (!is.na(alpha)) {
    colour_scale <- kml_alpha(obj, alpha = eval(call[["alpha"]], obj@data), colours = colour_scale, RGBA = TRUE)
  }

  # Creating a SpatialPixelsDataFrame object to be plotted
  call_name <- deparse(call[["colour"]])
  data <- data.frame(data)
  names(data) <- call_name

  # Building image object for PNG generation
  spdf <- SpatialPixelsDataFrame(points = coordinates(obj), data = data)
  img <- raster(spdf, layer = 1)

  # Creating the PNG file
  raster_name <- paste(file, ".png", sep = "")

  # Plotting the image
  png(file = raster_name, bg = "transparent") # , width = grd$width, height = grd$height)
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(img, col = colour_scale, frame.plot = FALSE)
  dev.off()

  # Folder and name of the points folder
  cat("<Folder>\n", file = file, append = TRUE)
  cat("<name>", call_name, "</name>\n", sep = "", file = file, append = TRUE)

  # write into the a KML file:
  write('<GroundOverlay>', file, append = TRUE)
  write(paste('<name>', call_name, '</name>', sep=""), file, append = TRUE)

  write(paste('<altitude>', altitude, '</altitude>', sep = ""), file, append = TRUE)
  write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file, append = TRUE)

  # Using the previously generated raster file
  write('<Icon>', file, append = TRUE)
  write(paste('<href>', raster_name, '</href>', sep = ""), file, append = TRUE)
  write('</Icon>', file, append = TRUE)

  # Bounding box used to drape the raster file
  write('<LatLonBox>', file, append = TRUE)
  write(paste('<north>', bbox(obj)[2, 2], '</north>', sep = ""), file, append = TRUE)
  write(paste('<south>', bbox(obj)[2, 1], '</south>', sep = ""), file, append = TRUE)
  write(paste('<east>', bbox(obj)[1, 2], '</east>', sep = ""), file, append = TRUE)
  write(paste('<west>', bbox(obj)[1, 1], '</west>', sep = ""), file, append = TRUE)
  write('</LatLonBox>', file, append = TRUE)

  write('</GroundOverlay>', file, append = TRUE)

  # Closing the folder
  cat("</Folder>\n", file = file, append = TRUE)
}

setMethod("kml_layer", "SpatialPixels", kml_layer.SpatialPixels)
