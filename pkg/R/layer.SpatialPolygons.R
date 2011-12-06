# Purpose        : Write polygon-objects (SpatialPolygons) to KML;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : pre-alpha
# Note           : this operation can be time consuming for large grids!;

kml_layer.SpatialPolygons <- function(
  obj,
  extrude = TRUE,
  tessellate = FALSE,
  outline = TRUE,
  plot.labpt = FALSE,
  z.scale = 1,
  LabelScale = get("LabelScale", envir = plotKML.opts),
  metadata = NULL,
  html.table = NULL,
  TimeSpan.begin = "",
  TimeSpan.end = "",
  ...
  ){
  
  # invisible file connection
  kml.out <- get("kml.out", env=plotKML.fileIO)
  
  # Checking the projection is geo
  check <- check_projection(obj, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check) {  obj <- reproject(obj)  }

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  poly_names <- aes[["labels"]]
  colours <- aes[["colour"]]
  sizes <- aes[["size"]]
  shapes <- aes[["shape"]]
  altitude <- aes[["altitude"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]

  # Parse ATTRIBUTE TABLE (for each placemark):
  if (balloon & ("data" %in% slotNames(obj))){
      html.table <- .df2htmltable(obj@data)
  }
  
  # Folder and name of the points folder
  pl1 = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", paste(class(obj)), parent = pl1)
  if(plot.labpt==TRUE){
  pl1b = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2b <- newXMLNode("name", "labpt", parent = pl1b)
  }

  # Insert metadata:
  if(!is.null(metadata)){
    md.txt <- kml_metadata(metadata, asText = TRUE)
    txt <- sprintf('<description><![CDATA[%s]]></description>', md.txt)
    parseXMLAndAdd(txt, parent=pl1)
  }
  message("Parsing to KML...")  

  # process polygons:
  pv <- length(obj@polygons)
  # parse coordinates:
  coords <- NULL
  hole <- NULL
  labpt <- NULL
  for (i.poly in 1:pv) { 
    xyz <- slot(slot(obj@polygons[[i.poly]], "Polygons")[[1]], "coords")
    cxyz <- slot(slot(obj@polygons[[i.poly]], "Polygons")[[1]], "labpt")
    hole[[i.poly]] <- slot(slot(obj@polygons[[i.poly]], "Polygons")[[1]], "hole")
      if(ncol(xyz)==2){  xyz <- cbind(xyz, rep(altitude[i.poly], nrow(xyz)))  }
    coords[[i.poly]] <- paste(xyz[,1], ',', xyz[,2], ',', xyz[,3], collapse='\n ', sep = "")
    labpt[[i.poly]] <- paste(cxyz[1], ',', cxyz[2], ',', altitude[i.poly], collapse='\n ', sep = "")
  }


  # Polygon styles
  # ==============
  if(!length(unique(colours))==1){
  txts <- sprintf('<Style id="poly%s"><PolyStyle><color>%s</color><outline>%s</outline><fill>%s</fill></PolyStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:pv, colours, rep(as.numeric(outline), pv), as.numeric(unlist(!hole)))
  parseXMLAndAdd(txts, parent=pl1)
  }
  else {
  txts <- sprintf('<Style id="poly%s"><PolyStyle><colorMode>random</colorMode><outline>%s</outline><fill>%s</fill></PolyStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:pv, rep(as.numeric(outline), pv), as.numeric(unlist(!hole)))
  parseXMLAndAdd(txts, parent=pl1)
  }

  # Point styles
  # ==============
  if(plot.labpt == TRUE){
  txtsp <- sprintf('<Style id="pnt%s"><LabelStyle><scale>%.1f</scale></LabelStyle><IconStyle><color>ffffffff</color><scale>%s</scale><Icon><href>%s</href></Icon></IconStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:pv, rep(LabelScale, pv), sizes, shapes)
  parseXMLAndAdd(txtsp, parent=pl1b)

  # Writing labpt
  # ================  
  if(nzchar(TimeSpan.begin[1])&nzchar(TimeSpan.end[1])){
      if(identical(TimeSpan.begin, TimeSpan.end)){
      when = TimeSpan.begin
      if(length(when)==1){ when = rep(when, pv) }
      txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><TimeStamp><when>%s</when></TimeStamp><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%s</coordinates></Point></Placemark>', poly_names, 1:pv, when, rep(as.numeric(extrude), pv), rep(altitudeMode, pv), paste(unlist(labpt)))  
      } 
      else{
      if(length(TimeSpan.begin)==1){ TimeSpan.begin = rep(TimeSpan.begin, pv) }
      if(length(TimeSpan.end)==1){ TimeSpan.end = rep(TimeSpan.end, pv) }
      txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><TimeSpan><begin>%s</begin><end>%s</end></TimeSpan><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%s</coordinates></Point></Placemark>', poly_names, 1:pv, TimeSpan.begin, TimeSpan.end, rep(as.numeric(extrude), pv), rep(altitudeMode, pv), paste(unlist(labpt)))
      }
  }
      else{      
      txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%s</coordinates></Point></Placemark>', poly_names, 1:pv, rep(as.numeric(extrude), pv), rep(altitudeMode, pv), paste(unlist(labpt)))
  }

  parseXMLAndAdd(txtc, parent=pl1b)

  }

  # Writing polygons
  # ================
  
  if(length(html.table)>0){   
  # with attributes:
    if(nzchar(TimeSpan.begin[1])&nzchar(TimeSpan.end[1])){
      if(identical(TimeSpan.begin, TimeSpan.end)){
      when = TimeSpan.begin
      if(length(when)==1){ when = rep(when, pv) }
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><TimeStamp><when>%s</when></TimeStamp><description><![CDATA[%s]]></description><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, when, html.table, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))
      } 
      else{
      if(length(TimeSpan.begin)==1){ TimeSpan.begin = rep(TimeSpan.begin, pv) }
      if(length(TimeSpan.end)==1){ TimeSpan.end = rep(TimeSpan.end, pv) }
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><description><TimeSpan><begin>%s</begin><end>%s</end></TimeSpan><![CDATA[%s]]></description><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, TimeSpan.begin, TimeSpan.end, html.table, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))
      }
  }
      else{ 
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><description><![CDATA[%s]]></description><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, html.table, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords))) 
  }
  }

  # without attributes:
  else{
      if(nzchar(TimeSpan.begin[1])&nzchar(TimeSpan.end[1])){
      if(identical(TimeSpan.begin, TimeSpan.end)){
      when = TimeSpan.begin
      if(length(when)==1){ when = rep(when, pv) }
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><TimeStamp><when>%s</when></TimeStamp><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, when, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))  
     }
      else {
      if(length(TimeSpan.begin)==1){ TimeSpan.begin = rep(TimeSpan.begin, pv) }
      if(length(TimeSpan.end)==1){ TimeSpan.end = rep(TimeSpan.end, pv) }   
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><TimeSpan><begin>%s</begin><end>%s</end></TimeSpan><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, TimeSpan.begin, TimeSpan.end, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))     
      }     
  }
      else{
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:pv, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))
            }
  }

  parseXMLAndAdd(txt, parent=pl1)

  # save results: 
  assign("kml.out", kml.out, env=plotKML.fileIO)

}

setMethod("kml_layer", "SpatialPolygons", kml_layer.SpatialPolygons)
