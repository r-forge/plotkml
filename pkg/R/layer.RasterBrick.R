# Purpose        : Writes a time series of rasters to a KML (all with the same legend);
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Pierre Roudier (pierre.roudier@landcare.nz); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : pre-alpha
# Note           : this function is only suitable for writing time-series of data i.e. multiple realizations of the same variables; we assume that the time dimension is set via the @zvalue slot

kml_layer.RasterBrick <- function(
  obj,  # RasterBrick object;
  obj.title = deparse(substitute(obj, env = parent.frame())),
  dtime = 0, # time support in seconds
  colour_scale = get("colour_scale_numeric", envir = plotKML.opts),
  z.scale = 1,
  home_url = get("home_url", envir = plotKML.opts),
  LabelScale = get("LabelScale", envir = plotKML.opts),
  metadata = FALSE,
  attribute.table = NULL,
  tz = "GMT",
  z.lim = c(mean(obj@data@min, na.rm=TRUE), mean(obj@data@max, na.rm=TRUE)),
  ...
  ){
  
  if(!is.numeric(obj@data@values)){
  stop('Values of class "numeric" required.') 
  }
  if(nchar(obj@zvalue)==0){
  stop('Vector of DateTime values or numbers required for slot @zvalue.')
  }
  
  # Get our invisible file connection from custom environment
  kml.out <- get('kml.out', env=plotKML.fileIO)
  
  # Checking the projection is geo
  check <- check_projection(obj, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check) { obj <- reproject(obj) }

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)   

  # Read the relevant aesthetics     
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # optional elevations:
  altitude <- kml_altitude(obj, altitude = NULL)
  altitudeMode <- kml_altitude_mode(altitude)

  # Format the time slot for writing to KML:
  if(!any(class(obj@zvalue) %in% "POSIXct")){
  DateTime <- as.POSIXct(obj@zvalue, "%Y-%m-%dT%H:%M:%SZ", tz=tz)
  }
  else 
  { DateTime = obj@zvalue }
  
  if(dtime==0) {  
    when <- DateTime
  }
  else {
    ftime <- mean(diff(unclass(DateTime)))    # estimate the time support (if not indicated)
    TimeSpan.begin <- format(as.POSIXct(unclass(DateTime) - ftime/2, origin="1970-01-01"), "%Y-%m-%dT%H:%M:%SZ")
    TimeSpan.end <- format(as.POSIXct(unclass(DateTime) + ftime/2, origin="1970-01-01"), "%Y-%m-%dT%H:%M:%SZ")
  }

  # Parse ATTRIBUTE TABLE (for each placemark):
  if (balloon & ("layernames" %in% slotNames(obj))){
      html.table <- .df2htmltable(data.frame(layernames=obj@layernames, zvalue=obj@zvalue, unit=obj@unit))
  }

  # Name of the object
  pl1 = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", obj.title, parent=pl1)
  
  # Insert metadata:
  if(metadata==TRUE){
    obj.sp <- as(obj, "SpatialGridDataFrame")
    sp.md <- spMetadata(obj.sp, xml.file=set.file.extension(obj.title, ".xml"), generate.missing = FALSE)
    md.txt <- kml_metadata(sp.md, asText = TRUE)
    txt <- sprintf('<description><![CDATA[%s]]></description>', md.txt)
    parseXMLAndAdd(txt, parent=pl1)
  }

  # Creating the PNG files using standard z.lim's:
  raster_name <- set.file.extension(obj@layernames, ".png")

  # Plotting the image
  for(j in 1:length(raster_name)){
  png(file = raster_name[j], bg = "transparent")
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(raster(obj, j), col = colour_scale, zlim = z.lim, frame.plot = FALSE)
  dev.off()
  }


  # Ground overlays:
  # =============
  if(length(html.table)>0 & dtime==0){
    txtr <- sprintf('<GroundOverlay><name>%s</name><description><![CDATA[%s]]></description><TimeStamp><when>%s</when></TimeStamp><altitude>%.0f</altitude><altitudeMode>%s</altitudeMode><Icon><href>%s</href></Icon><LatLonBox><north>%.5f</north><south>%.5f</south><east>%.5f</east><west>%.5f</west></LatLonBox></GroundOverlay>', obj@layernames, html.table, when, rep(altitude, length(raster_name)), rep(altitudeMode, length(raster_name)), paste(raster_name), rep(bbox(extent(obj))[2, 2], length(raster_name)), rep(bbox(extent(obj))[2, 1], length(raster_name)), rep(bbox(extent(obj))[1, 2], length(raster_name)), rep(bbox(extent(obj))[1, 1], length(raster_name))) 
  }
  else {
  if(length(html.table)>0 & !dtime==0){  # with attributes / block temporal support 
    txtr <- sprintf('<GroundOverlay><name>%s</name><description><![CDATA[%s]]></description><TimeSpan><begin>%s</begin><end>%s</end></TimeSpan><altitude>%.0f</altitude><altitudeMode>%s</altitudeMode><Icon><href>%s</href></Icon><LatLonBox><north>%.5f</north><south>%.5f</south><east>%.5f</east><west>%.5f</west></LatLonBox></GroundOverlay>', obj@layernames, html.table, TimeSpan.begin, TimeSpan.end, rep(altitude, length(raster_name)), rep(altitudeMode, length(raster_name)), paste(raster_name), rep(bbox(extent(obj))[2, 2], length(raster_name)), rep(bbox(extent(obj))[2, 1], length(raster_name)), rep(bbox(extent(obj))[1, 2], length(raster_name)), rep(bbox(extent(obj))[1, 1], length(raster_name)))
  }
  else {
  if(is.null(html.table) & !dtime==0){   # no attributes / block temporal support 
    txtr <- sprintf('<GroundOverlay><name>%s</name><TimeSpan><begin>%s</begin><end>%s</end></TimeSpan><altitude>%.0f</altitude><altitudeMode>%s</altitudeMode><Icon><href>%s</href></Icon><LatLonBox><north>%.5f</north><south>%.5f</south><east>%.5f</east><west>%.5f</west></LatLonBox></GroundOverlay>', obj@layernames, TimeSpan.begin, TimeSpan.end, rep(altitude, length(raster_name)), rep(altitudeMode, length(raster_name)), paste(raster_name), rep(bbox(extent(obj))[2, 2], length(raster_name)), rep(bbox(extent(obj))[2, 1], length(raster_name)), rep(bbox(extent(obj))[1, 2], length(raster_name)), rep(bbox(extent(obj))[1, 1], length(raster_name)))
  }
  else {  # no attributes / point temporal support 
     txtr <- sprintf('<GroundOverlay><name>%s</name><TimeStamp><when>%s</when></TimeStamp><altitude>%.0f</altitude><altitudeMode>%s</altitudeMode><Icon><href>%s</href></Icon><LatLonBox><north>%.5f</north><south>%.5f</south><east>%.5f</east><west>%.5f</west></LatLonBox></GroundOverlay>', obj@layernames, when, rep(altitude, length(raster_name)), rep(altitudeMode, length(raster_name)), paste(raster_name), rep(bbox(extent(obj))[2, 2], length(raster_name)), rep(bbox(extent(obj))[2, 1], length(raster_name)), rep(bbox(extent(obj))[1, 2], length(raster_name)), rep(bbox(extent(obj))[1, 1], length(raster_name)))
  }}}

  parseXMLAndAdd(txtr, parent=pl1)
  
  # save results: 
  assign('kml.out', kml.out, env=plotKML.fileIO)
  
}

setMethod("kml_layer", "RasterBrick", kml_layer.RasterBrick)

# end of script;