# Purpose        : Parsing "SoilPhotoOverlay" objects to KML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl)
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : plots either a monolith or a PhotoOverlay;


kml_layer.SpatialPhotoOverlay <- function(
  obj,
  type = c("PhotoOverlay", "monolith")[1],
  shape = obj@PhotoOverlay$shape,
  href = obj@filename,
  heading = obj@PhotoOverlay$heading,
  tilt = obj@PhotoOverlay$tilt,
  roll = obj@PhotoOverlay$roll,    
  near = obj@PhotoOverlay$near,
  leftFov = obj@PhotoOverlay$leftFov, 
  rightFov = obj@PhotoOverlay$rightFov, 
  bottomFov = obj@PhotoOverlay$bottomFov, 
  topFov = obj@PhotoOverlay$topFov, 
  altitudeMode = "clampToGround",
  inch.dim = 3/3600,  # 3-arcsecs or 100 m  
  ...
  ){

  # get our invisible file connection from custom evnrionment
  kml.out <- get("kml.out", env=plotKML.fileIO)
  
  # check the projection:
  check <- check_projection(obj@sp, logical = TRUE) 

  # Trying to reproject data if the check was not successful
  if (!check) { obj@sp <- reproject(obj@sp) }  
  
  LON <- as.vector(coordinates(obj@sp)[,1])
  LAT <- as.vector(coordinates(obj@sp)[,2])
  ALT <- as.vector(coordinates(obj@sp)[,3])
  if(ALT == 0|is.na(ALT)) {
    ALT = 5
    }
    else {
    altitudeMode = "absolute"
    } 

  # unique image ID:
  x <- strsplit(obj@filename, "/")[[1]]
  image.id <- x[length(x)]

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  # altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Parse ATTRIBUTE TABLE (EXIF data):
  if ((is.logical(balloon) | class(balloon) %in% c('character','numeric')) & ("exif.info" %in% slotNames(obj))){
     html.table <- .df2htmltable(data.frame(obj@exif.info)) 
  }

  # Object name and description:
  pl1 = newXMLNode("PhotoOverlay", attrs = c("id" = image.id), parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", paste(class(obj)), parent = pl1)
  txtd <- sprintf('<description><![CDATA[%s]]></description>', html.table) 
  parseXMLAndAdd(txtd, parent=pl1) 

  # Add a Camera view location:
  # ==========================    
  txtv <- sprintf('<Camera><longitude>%.6f</longitude><latitude>%.6f</latitude><altitude>%f</altitude><heading>%.1f</heading><tilt>%.1f</tilt><roll>%.1f</roll></Camera>', LON, LAT, ALT, heading, tilt, roll) 
  parseXMLAndAdd(txtv, parent=pl1)

  # Simple PhotoOverlay
  if(type=="PhotoOverlay"){
  
  pl3 <- newXMLNode("Icon", parent = pl1)
  pl4 <- newXMLNode("href", href, parent = pl3)
  
  # Add ViewVolume info:
  # ==========================    
  txtw <- sprintf('<ViewVolume><leftFov>%.1f</leftFov><rightFov>%.1f</rightFov><bottomFov>%.1f</bottomFov><topFov>%.1f</topFov><near>%.1f</near></ViewVolume>', leftFov, rightFov, bottomFov, topFov, near) 
  parseXMLAndAdd(txtw, parent=pl1)

  }

  # Location of the camera
  # ========================== 
  txtc <- sprintf('<Point><altitudeMode>%s</altitudeMode><coordinates>%.5f,%.5f,%.0f</coordinates></Point>', altitudeMode, LAT, LON, ALT)   
  parseXMLAndAdd(txtc, parent=pl1)

  # save results: 
  assign("kml.out", kml.out, env=plotKML.fileIO)
}

    
setMethod("kml_layer", "SpatialPhotoOverlay", kml_layer.SpatialPhotoOverlay)

# end of script;