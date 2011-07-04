.kml_write_raster <- function(obj, colours, file_name) {

#   require(maptools)

   # Building SpatialGrid for PNG generation
#   grd <- GE_SpatialGrid(obj, asp = NA, maxPixels=1000)
  
  img <-  as.image.SpatialGridDataFrame(obj, attr=2)

#   raster <- sampleRegular(raster, size = maxpixels, asRaster = TRUE)
#   imagefile <- filename
#   extension(imagefile) <- ".png"
#   kmlfile <- filename
#   extension(kmlfile) <- ".kml"
#   png(filename = imagefile, width = ncol(raster), height = nrow(raster), bg = "transparent")
#   par(mar = c(0, 0, 0, 0))
#   image(raster, col = col, axes = FALSE)
#   dev.off()

  # Creating the PNG file
  raster_name <- paste(file_name, ".png", sep = "")

  png(file = raster_name, bg = "transparent") # , width = grd$width, height = grd$height)
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(img)
#   plot(obj, xlim = grd$xlim, ylim = grd$ylim, setParUsrBB = TRUE)
  dev.off()

  raster_name
}

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
  check <- check_projection(obj, logical = FALSE)

  # Trying to reproject data if the check was not successful
#   if (!check)
#     obj <- reproject(obj)

  # Parsing the call for aesthetics
#   aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
#   colours <- aes[["colour"]]
#   altitude <- aes[["altitude"]]
#   altitudeMode <- aes[["altitudeMode"]]

  # Parsing the call for "colour"
  call <- substitute(list(...))
  call <- as.list(call)[-1]

  # Parse the current call
  colour <- charmatch("colour", names(call))
  if (is.na(colour))
    stop("No attribute to map. Please use the colour=... option.")
  
  colour <- as.character(call[['colour']])

  if (!(colour %in% names(obj@data)))
    stop("Bad attribute.")
  else
    raster_name <- .kml_write_raster(obj, colour, file)

  # Folder and name of the points folder
  cat("<Folder>\n", file = file, append = TRUE)
  cat("<name>", title, "</name>\n", sep = "", file = file, append = TRUE)

  # write a raster file
  raster_name <- .kml_write_raster(obj, colours, file_name = file)

  # write into the a KML file:
  write('<GroundOverlay>', file, append = TRUE)
  write(paste('<name>', title, '</name>', sep=""), file, append = TRUE)

  write(paste('<altitude>', altitude, '</altitude>', sep = ""), file, append = TRUE) 
  write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), file, append = TRUE)

  # Using the previously generated raster file 
  write('<Icon>', file, append = TRUE)
  write(paste('<href>', raster_name, '</href>', sep = ""), file, append = TRUE)
  write('</Icon>', file, append = TRUE)

  # Bounding box used to drape the raster file
  write('<LatLonBox>', file, append = TRUE)
  write(paste('<north>', obj@bbox[2, 2], '</north>', sep = ""), file, append = TRUE)
  write(paste('<south>', obj@bbox[2, 1], '</south>', sep = ""), file, append = TRUE)
  write(paste('<east>', obj@bbox[1, 2], '</east>', sep = ""), file, append = TRUE)
  write(paste('<west>', obj@bbox[1, 1], '</west>', sep = ""), file, append = TRUE)
  write('</LatLonBox>', file, append = TRUE)

  write('</GroundOverlay>', file, append = TRUE)

  # Closing the folder
  cat("</Folder>\n", file = file, append = TRUE)
}

setMethod("kml_layer", "SpatialPixels", kml_layer.SpatialPixels)
