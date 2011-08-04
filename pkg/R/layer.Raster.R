kml_layer.Raster <- function(
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

  # Parsing the call for "colour"
  call <- substitute(list(...))
  call <- as.list(call)[-1]

  # Parse the current call
  colour <- charmatch("colour", names(call))

  if (is.na(colour))
    stop("No attribute to map. Please use the colour=... option.")

  if (is.call(call[["colour"]])) {
    data <- data.frame(getValues(obj))
    names(data) <- layerNames(obj)
    data <- eval(call[["colour"]], data)
    obj <- raster(obj)
    values(obj) <- data
  }
  else if (is.name(call[["colour"]])) {
    i_layer <- which(layerNames(obj) == as.character(call[["colour"]]))
    if (nlayers(obj) > 1) {
      obj <- raster(obj, layer = i_layer)
    }
  }
  else if (is.numeric(call[["colour"]])) {
    i_layer <- call[["colour"]]
    if (nlayers(obj) > 1) {
      obj <- raster(obj, layer = i_layer)
    }
  }
  else if (is.character(call[["colour"]])) {
    i_layer <- which(layerNames(obj) == call[["colour"]])
    if (nlayers(obj) > 1) {
      obj <- raster(obj, layer = i_layer)
    }
  }
#   # missing colour
#   else {
#     # Plotting the first layer
#   }

  data <- getValues(obj)

#   altitude <- eval(call[["altitude"]], obj@data)
  altitude <- kml_altitude(obj, altitude = NULL)
  altitudeMode <- kml_altitude_mode(altitude)

  pal <- charmatch("colour_scale", names(call))
  if (!is.na(pal))
    pal <- eval(call[["colour_scale"]])
  else {
    if (!is.factor(obj))
      pal <- .colour_scale_numeric
    else
      pal <- .colour_scale_factor
  }

  colour_scale <- colorRampPalette(pal)(length(data))

    # Transparency
  alpha <- charmatch("alpha", names(call))
  if (!is.na(alpha)) {
    # - constant transparency
    # - raster index if a Stack
    # - name of a layer if a Stack
    colour_scale <- kml_alpha(obj, alpha = eval(call[["alpha"]], obj@data), colours = colour_scale, RGBA = TRUE)
  }

  # Creating a SpatialPixelsDataFrame object to be plotted
  call_name <- deparse(call[["colour"]])

  # Creating the PNG file
  raster_name <- paste(summary(file.connection)$description, ".png", sep = "")

  # Plotting the image
  png(file = raster_name, bg = "transparent") # , width = grd$width, height = grd$height)
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(obj, col = colour_scale, frame.plot = FALSE)
  dev.off()

  # Folder and name of the points folder
  cat("<Folder>\n", file = file.connection, append = TRUE)
  cat("<name>", call_name, "</name>\n", sep = "", file = file.connection, append = TRUE)

  # write into the a KML file:
  write('<GroundOverlay>', file.connection, append = TRUE)
  write(paste('<name>', call_name, '</name>', sep=""), file.connection, append = TRUE)

  write(paste('<altitude>', altitude, '</altitude>', sep = ""), file.connection, append = TRUE)
  write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file.connection, append = TRUE)

  # Using the previously generated raster file
  write('<Icon>', file.connection, append = TRUE)
  write(paste('<href>', raster_name, '</href>', sep = ""), file.connection, append = TRUE)
  write('</Icon>', file.connection, append = TRUE)

  # Bounding box used to drape the raster file
  write('<LatLonBox>', file.connection, append = TRUE)
  write(paste('<north>', bbox(extent(obj))[2, 2], '</north>', sep = ""), file.connection, append = TRUE)
  write(paste('<south>', bbox(extent(obj))[2, 1], '</south>', sep = ""), file.connection, append = TRUE)
  write(paste('<east>', bbox(extent(obj))[1, 2], '</east>', sep = ""), file.connection, append = TRUE)
  write(paste('<west>', bbox(extent(obj))[1, 1], '</west>', sep = ""), file.connection, append = TRUE)
  write('</LatLonBox>', file.connection, append = TRUE)

  write('</GroundOverlay>', file.connection, append = TRUE)

  # Closing the folder
  cat("</Folder>\n", file = file.connection, append = TRUE)
}

setMethod("kml_layer", "Raster", kml_layer.Raster)
