# Purpose        : Parsing SpatialPoints layer to KML
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl);
# Status         : Pre-alpha
# Note           : This file gathers the layer() methods. kml.compress(), kml.open() and kml.close();


kml_layer.SpatialPoints <- function(
  obj,
  obj.title,
  extrude = TRUE,
  z.scale = 1,
  LabelScale = get("LabelScale", envir = plotKML.opts),
  metadata = TRUE,
  attribute.table = NULL,
  ...
  ){
  
  # invisible file connection
  kml.out <- get('kml.out', env=plotKML.fileIO)
  
  # Checking the projection
  check <- check_projection(obj, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check) {  obj <- reproject(obj)  }

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  points_names <- aes[["labels"]]
  colours <- aes[["colour"]]
  shapes <- aes[["shape"]]
  sizes <- aes[["size"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # ATTRIBUTE TABLE (for each placemark):
  if ((is.logical(balloon) | class(balloon) %in% c('character','numeric')) & ("data" %in% slotNames(obj))){
      # get selected table data:
      att.names <- sapply(names(obj@data), function(i) { paste('<span style="font-weight: bold; color: #000000; padding: 3px;">', as.character(i), '</span>:&nbsp;', sep = '') } )    
      att.values <- as.vector(t(sapply(obj@data, function(i) { paste('<span style="color: #000000; padding:3px;">', as.character(i), '</span><br>', sep = '') })))
      # combine by interleaving:
      att <- matrix(paste(att.names, att.values, sep="\n"), ncol=length(names(obj@data)), byrow=TRUE)
      attribute.table <- apply(att, 1, paste, collapse="\n") 
  }

  # Folder and name of the points folder
  pl1 = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", obj.title, parent = pl1)

  # Insert metadata:
  if(metadata==TRUE){
    sp.md <- spMetadata(obj, xml.file=set.file.extension(obj.title, ".xml"), generate.missing = FALSE)
    md.txt <- kml_metadata(sp.md, asText = TRUE)
    txt <- sprintf('<description><![CDATA[%s]]></description>', md.txt)
    parseXMLAndAdd(txt, parent=pl1)
  }
  message("Parsing to KML...")
  # Writing points styles
  # =====================
  txts <- sprintf('<Style id="pnt%s"><LabelStyle><scale>%.1f</scale></LabelStyle><IconStyle><color>%s</color><scale>%s</scale><Icon><href>%s</href></Icon></IconStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:length(obj), rep(LabelScale, length(obj)), colours, sizes, shapes)
  parseXMLAndAdd(txts, parent=pl1)
  # Writing points coordinates
  # ==========================
  if(length(attribute.table)>0){   
  # Add attributes:
      txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><description><![CDATA[%s]]></description><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%.4f,%.4f,%.0f</coordinates></Point></Placemark>', points_names, 1:length(obj), attribute.table, rep(as.numeric(extrude), length(obj)), rep(altitudeMode, length(obj)), coordinates(obj)[, 1], coordinates(obj)[, 2], altitude)
  }
  # without attributes:
  else{
      txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%.4f,%.4f,%.0f</coordinates></Point></Placemark>', points_names, 1:length(obj), rep(as.numeric(extrude), length(obj)), rep(altitudeMode, length(obj)), coordinates(obj)[, 1], coordinates(obj)[, 2], altitude)     
  }
  parseXMLAndAdd(txtc, parent=pl1)

  # save results: 
  assign('kml.out', kml.out, env=plotKML.fileIO)

}

setMethod("kml_layer", "SpatialPoints", kml_layer.SpatialPoints)

# end of script;
