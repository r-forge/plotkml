# Purpose        : Write a raster layer to KML;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : pre-alpha
# Note           : Rasters can also be written as polygons; see "?grid2poly"

kml_layer.Raster <- function(
  obj,  
  obj.title = deparse(substitute(obj, env = parent.frame())),
  metadata = FALSE,
  ...
  ){

  # get our invisible file connection from custom evnrionment
  kml.out <- get('kml.out', env=plotKML.fileIO)

  # Checking the projection is geo
  check <- check_projection(obj, logical = TRUE)

  ## default colour palettes
  .colour_scale_numeric = get("colour_scale_numeric", envir = plotKML.opts)
  .colour_scale_factor = get("colour_scale_factor", envir = plotKML.opts)

  # Parsing the call for "colour"
  call <- substitute(list(...))
  call <- as.list(call)[-1]

  # Parse the current call
  colour <- charmatch("colour", names(call))

  if (is.na(colour))
    stop("No attribute to map. Please use the colour = ... option.")

  if (is.call(call[["colour"]])) {
    data <- data.frame(getValues(obj))
    data <- eval(call[["colour"]], data)
    obj <- raster(obj)
    values(obj) <- data
  }
  else if (is.name(call[["colour"]])) {
    if (nlayers(obj) > 1) {
      i_layer <- which(layerNames(obj) == as.character(call[["colour"]]))
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

  # Trying to reproject data if the check was not successful
  if (!check) {  obj <- reproject(obj) }
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
  raster_name <- set.file.extension(paste(obj.title, as.character(call[["colour"]]), sep="_"), ".png")

  # Plotting the image
  png(file = raster_name, bg = "transparent")
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(obj, col = colour_scale, frame.plot = FALSE)
  dev.off()

  ## There is a bug in Google Earth that does not allow transparency of pngs:
  # http://groups.google.com/group/earth-free/browse_thread/thread/1cd6bc29a2b6eb76/62724be63547fab7
  # Solution: add transparency using ImageMagick:
  convert <- get("convert", envir = plotKML.opts)
  if(nchar(convert)==0){
    plotKML.env(silent = FALSE)
    convert <- get("convert", envir = plotKML.opts)
  }
  if(nzchar(convert)){
    system(paste(convert, ' ', raster_name, ' -matte -transparent "#FFFFFF" ', raster_name, sep=""))
  }

  message("Parsing to KML...")
  # Folder name
  pl1 = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", paste(class(obj)), parent = pl1)

  # Insert metadata:
  if(metadata==TRUE){
    sp.md <- spMetadata(obj, xml.file=set.file.extension(obj.title, ".xml"), generate.missing = FALSE)
    md.txt <- kml_metadata(sp.md, asText = TRUE)
    txt <- sprintf('<description><![CDATA[%s]]></description>', md.txt)
    parseXMLAndAdd(txt, parent=pl1)
  }

  # Ground overlay
  # =====================
  pl2b <- newXMLNode("GroundOverlay", parent = pl1)
  pl3 <- newXMLNode("name", call_name, parent = pl2b)
  pl3b <- newXMLNode("altitude", altitude, parent = pl2b)
  pl3b <- newXMLNode("altitudeMode", altitudeMode, parent = pl2b)
  pl3c <- newXMLNode("Icon", parent = pl2b)
  pl4 <- newXMLNode("href", raster_name, parent = pl3c)
  pl3d <- newXMLNode("LatLonBox", parent = pl2b)
  pl4b <- newXMLNode("north", bbox(extent(obj))[2, 2], parent = pl3d)
  pl4c <- newXMLNode("south", bbox(extent(obj))[2, 1], parent = pl3d)
  pl4d <- newXMLNode("east", bbox(extent(obj))[1, 2], parent = pl3d)
  pl4e <- newXMLNode("west", bbox(extent(obj))[1, 1], parent = pl3d)
  
  # save results: 
  assign('kml.out', kml.out, env=plotKML.fileIO)
  
}

setMethod("kml_layer", "RasterLayer", kml_layer.Raster)
setMethod("kml_layer", "RasterStack", kml_layer.Raster)

# end of script;