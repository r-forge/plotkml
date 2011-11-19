# Purpose        : Write polygon-objects (SpatialPolygons) to KML;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : pre-alpha
# Note           : this operation can be time consuming with large grids!;

kml_layer.SpatialPolygons <- function(
  # options on the object to plot
  obj,
  obj.title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  tessellate = FALSE,
  outline = TRUE,
  plot.labpt = FALSE,
  z.scale = 1,
  LabelScale = get("LabelScale", envir = plotKML.opts),
  metadata = FALSE,
  html.table = NULL,
  ...
  ){
  
  # invisible file connection
  kml.out <- get('kml.out', env=plotKML.fileIO)
  
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
  pl1b = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2b <- newXMLNode("name", "labpt", parent = pl1b)

  # Insert metadata:
  if(metadata==TRUE){
    sp.md <- spMetadata(obj, xml.file=set.file.extension(obj.title, ".xml"), generate.missing = FALSE)
    md.txt <- kml_metadata(sp.md, asText = TRUE)
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
  txts <- sprintf('<Style id="poly%s"><PolyStyle><color>%s</color><outline>%s</outline><fill>%s</fill></PolyStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:length(obj), colours, rep(as.numeric(outline), pv), as.numeric(unlist(!hole)))
  parseXMLAndAdd(txts, parent=pl1)
  }
  else {
  txts <- sprintf('<Style id="poly%s"><PolyStyle><colorMode>random</colorMode><outline>%s</outline><fill>%s</fill></PolyStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:length(obj), rep(as.numeric(outline), pv), as.numeric(unlist(!hole)))
  parseXMLAndAdd(txts, parent=pl1)
  }

  # Point styles
  # ==============
  if(plot.labpt == TRUE){
  txtsp <- sprintf('<Style id="pnt%s"><LabelStyle><scale>%.1f</scale></LabelStyle><IconStyle><color>ffffffff</color><scale>%s</scale><Icon><href>%s</href></Icon></IconStyle><BalloonStyle><text>$[description]</text></BalloonStyle></Style>', 1:pv, rep(LabelScale, pv), sizes, shapes)
  parseXMLAndAdd(txtsp, parent=pl1b)
  # Writing labpt
  # ================  
  txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%s</coordinates></Point></Placemark>', poly_names, 1:length(obj), rep(as.numeric(extrude), pv), rep(altitudeMode, pv), paste(unlist(labpt)))  
  parseXMLAndAdd(txtc, parent=pl1b)
  }

  # Writing polygons
  # ================
  
  if(length(html.table)>0){   
  # Add attributes:
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><description><![CDATA[%s]]></description><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:length(obj), html.table, rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))
  }
  # without attributes:
  else{
      txt <- sprintf('<Placemark><name>%s</name><styleUrl>#poly%s</styleUrl><Polygon><extrude>%.0f</extrude><tessellate>%.0f</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', poly_names, 1:length(obj), rep(as.numeric(extrude), pv), rep(as.numeric(tessellate), pv), rep(altitudeMode, pv), paste(unlist(coords)))  
  }

  parseXMLAndAdd(txt, parent=pl1)

  # save results: 
  assign('kml.out', kml.out, env=plotKML.fileIO)

}

setMethod("kml_layer", "SpatialPolygons", kml_layer.SpatialPolygons)
