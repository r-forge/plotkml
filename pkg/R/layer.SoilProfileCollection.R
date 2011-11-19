# Purpose        : Parsing "SoilProfileCollection" objects to KML
# Maintainer     : Dylan Beaudette (debeaudette@ucdavis.edu)
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : Requires aqp package


kml_layer.SoilProfileCollection <- function(
  obj,
  obj.title,
  var.name,
  site_names = obj@site[,1],
  z.scale = 1,
  x.min = 0,  
  x.scale,
  max.depth = 300,
  plot.points = TRUE,
  LabelScale = get("LabelScale", envir = plotKML.opts)*.7,
  IconColor = "#ff0000ff",
  shape = paste(get("home_url", envir = plotKML.opts), "circlesquare.png", sep=""),
  visibility = TRUE,
  extrude = TRUE,
  tessellate = TRUE,
  camera.distance = .01,
  altitudeMode = "relativeToGround",
  tilt = 90, 
  heading = 0, 
  roll = 0,
  metadata = get("metadata", envir = plotKML.opts),
  html.table = NULL,
  ...)
{

  # TH: at the moment works only with numeric variables:
  if(!is.numeric(obj@horizons[,var.name])) {
  stop('"var.name" argument requires a numeric variable.')
  }

  # get our invisible file connection from custom evnrionment
  kml.out <- get("kml.out", env=plotKML.fileIO)
  
  # check the projection:
  check <- check_projection(obj@sp, logical = TRUE) 

  # Trying to reproject data if the check was not successful
  if (!check) { obj@sp <- reproject(obj@sp) }  
  
  LON <- as.vector(coordinates(obj@sp)[,1])
  LAT <- as.vector(coordinates(obj@sp)[,2])
  site_names <- paste(obj@site[,obj@idcol])

  if(missing(x.scale)) {   # scaling factor in x direction (estimate automatically)
     x.range <- range(obj@horizons[,var.name], na.rm=TRUE)
     x.scale <- 0.003/diff(x.range)
  if(missing(x.min)) {   x.min <- x.range[1]-diff(x.range)/100 }
  }

  ## This one uses no aesthetics
  # aes <- kml_aes(obj, ...)


  # Folder and name of the points folder
  pl1 = newXMLNode("Folder", parent=kml.out[["Document"]])
  pl2 <- newXMLNode("name", paste(class(obj)), parent = pl1)
  pl2c = newXMLNode("Folder", parent=pl1)
  pl3c <- newXMLNode("name", "plots", parent = pl2c)

  # Insert metadata:
  if(metadata==TRUE){
    sp.md <- spMetadata(obj, xml.file=set.file.extension(obj.title, ".xml"), generate.missing = FALSE)
    md.txt <- kml_metadata(sp.md, asText = TRUE)
    txt <- sprintf('<description><![CDATA[%s]]></description>', md.txt)
    parseXMLAndAdd(txt, parent=pl1)
  }
  message("Parsing to KML...")

  if(plot.points==TRUE){
  pl2b = newXMLNode("Folder", parent=pl1)
  pl3b <- newXMLNode("name", "points", parent = pl2b)
  }

  # Calculate 3D coordinates
  # ==========================  

  # for each site:
  coords <- NULL
  coords.pol <- NULL
  points_names <- NULL
  prof.na <- NULL
  
  for(i.site in 1:length(obj@site[,obj@idcol])) {
  # select columns of interest:
  sel <- grep(names(obj@horizons), pattern=var.name)
  # mask out the NA horizons:
  prof.na[[i.site]] <- which(obj@horizons[obj@idcol]==site_names[i.site] & !is.na(obj@horizons[,sel]))
  xval <- obj@horizons[prof.na[[i.site]],sel]
  htop <- obj@horizons[prof.na[[i.site]],obj@depthcols[1]]
  hbot <- obj@horizons[prof.na[[i.site]],obj@depthcols[2]]
  
    if(plot.points==TRUE){
    points_names[[i.site]] <- signif(xval, 3)
    X <- round(LON[i.site]+x.scale*(xval-x.min), 6)
    Y <- rep(LAT[i.site], length(prof.na[[i.site]]))
    # horizon centre:
    Z <- max.depth - (htop+(hbot-htop)/2)
    coords[[i.site]] <- paste(X, ',', Y, ',', z.scale*Z, collapse='\n ', sep = "")
    }
  # horizon polygons:
  Xp <- round(c(as.vector(t(matrix(rep(LON[i.site]+x.scale*(xval-x.min), 2), ncol=2))), rep(LON[i.site], 2)), 6)
  Yp <- rep(LAT[i.site], length(Xp))
  Zp <- c(as.vector(t(matrix(c(max.depth-htop, max.depth-hbot), ncol=2))), max.depth-hbot[length(hbot)], max.depth-htop[1])
  X0 <- round(LON[i.site]+x.scale*(xval[1]-x.min), 6)
  Y0 <- LAT[i.site]
  Z0 <- max.depth-htop[1]
  coords.pol[[i.site]] <- paste(c(Xp, X0), ',', c(Yp, Y0), ',', z.scale*c(Zp, Z0), collapse='\n ', sep = "")

}
  # mask out empty profiles:


  if(plot.points==TRUE){
  # Writing points styles
  # =====================    
  selp <- !sapply(prof.na, function(x){length(x)==0})
  lp <- length(unlist(prof.na))
  txts <- sprintf('<Style id="pnt%s"><LabelStyle><scale>%.1f</scale></LabelStyle><IconStyle><color>%s</color><scale>%s</scale><Icon><href>%s</href></Icon></IconStyle></Style>', paste(1:lp), rep(LabelScale, lp), rep(IconColor, lp), rep(LabelScale, lp), rep(shape, lp))
  parseXMLAndAdd(txts, parent=pl2b)  
   
  # Coordinates of points 
  # ========================== 
  txtc <- sprintf('<Placemark><name>%s</name><styleUrl>#pnt%s</styleUrl><Point><extrude>%.0f</extrude><altitudeMode>%s</altitudeMode><coordinates>%s</coordinates></Point></Placemark>', paste(unlist(points_names)), paste(1:lp), rep(as.numeric(extrude), lp), rep(altitudeMode, lp), unlist(strsplit(unlist(coords[selp]), "\n")))   
  parseXMLAndAdd(txtc, parent=pl2b)
  }
 
  # Write Polygons for each site
  # ==========================  
  txt <- sprintf('<Placemark><name>%s</name><visibility>%s</visibility><Polygon><tessellate>%s</tessellate><altitudeMode>%s</altitudeMode><outerBoundaryIs><LinearRing><coordinates>%s</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>', site_names, rep(as.numeric(visibility), length(site_names)), rep(as.numeric(tessellate), length(site_names)), rep(altitudeMode, length(site_names)), paste(unlist(coords.pol)))     
  parseXMLAndAdd(txt, parent=pl2c)

  # Add a Camera view location:
  # ==========================    
  txtv <- sprintf('<Camera><longitude>%.6f</longitude><latitude>%.6f</latitude><altitude>%f</altitude><heading>%.1f</heading><tilt>%.1f</tilt><roll>%.1f</roll></Camera>', LON[1], LAT[1]-camera.distance, max.depth, heading, tilt, roll) 
  parseXMLAndAdd(txtv, parent=pl1)

  # save results: 
  assign("kml.out", kml.out, env=plotKML.fileIO)
}

    
setMethod("kml_layer", "SoilProfileCollection", kml_layer.SoilProfileCollection)
