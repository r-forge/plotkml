# Purpose        : Generation of SpatialPhotoOverlay object 
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Dev Status     : Pre-Alpha
# Note           : Combination of the pixmap package and EXIF (Rexif) package functionality;


## Generate SpatialPhotoOverlay object:
spPhoto <- function(
   filename,
   obj,
   pixmap,
   exif.info = NULL,
   ImageWidth = 0,
   ImageHeight = 0,
   bands = rep(rep(1, ImageHeight*ImageWidth), 3),
   bbox = c(0,0,3/36000*ImageWidth,3/36000*ImageHeight),
   DateTime = "",
   ExposureTime = "",
   FocalLength = "50 mm", 
   Flash = "No Flash",
   rotation = 0, 
   leftFov = -30,
   rightFov = 30,
   bottomFov = -30,
   topFov = 30,
   near = 50, # in meters;
   shape = c("rectangle", "cylinder", "sphere")[1],
   range = 1000, # m;
   tilt = 90,
   heading = 0,
   roll = 0,
   test.filename = TRUE
   ){

  require(pixmap)  
  
  if(test.filename==TRUE){
    try(con.file <- file(filename))
    if(!any(class(con.file) %in% "url")){   
      if(is.na(file.info(filename)$size)){
      stop(paste("File", filename, "could not be located."))      
      }
    }
    else{
    require(RCurl)
    z <- getURI(filename, .opts=curlOptions(header=TRUE, nobody=TRUE, transfertext=TRUE, failonerror=FALSE))
      if(!length(x <- grep(z, pattern="404 Not Found"))==0){
      stop(paste("File", filename, "could not be located."))
      }
      pixmap <- pixmapRGB(bands, ImageHeight, ImageWidth, bbox = bbox) 
    }    
  }
    
  # Local copy or in memory
  if(!missing(pixmap)&missing(filename)){
    filename = ""
  }

  # if missing the coordinate system assume latlon:
  if(!missing(obj)){
  if(is.na(proj4string(obj))) { proj4string(obj) <- CRS(get("ref_CRS", envir = plotKML.opts)) }
  }

  # if missing EXIF data:
  if(is.null(exif.info)){
    exif.info <- as.list(data.frame(DateTime, ExposureTime, FocalLength, Flash))
  }
  else{ 
    # try to guess coordinates from EXIF data:
    if(missing(obj)&any(names(exif.info) %in% "GPSLongitude")){
      if(any(names(exif.info) %in% "GPSAltitude")){
      x <- as.numeric(strsplit(exif.info$GPSAltitude, "/")[[1]])
      try(exif.info$GPSAltitude <- ifelse(length(x)>1, x[1]/x[2], x))
      }
      else {
      exif.info$GPSAltitude <- 0
      }
    obj <- data.frame(lon=as.numeric(exif.info$GPSLongitude), lat=as.numeric(exif.info$GPSLatitude), alt=as.numeric(exif.info$GPSAltitude))
    coordinates(obj) <- ~lon+lat+alt
    proj4string(obj) <- CRS(get("ref_CRS", envir = plotKML.opts))
    
    # correct the ViewVolume:
    exif.info$ImageWidth <- as.numeric(exif.info$ImageWidth)
    exif.info$ImageHeight <- as.numeric(exif.info$ImageHeight)
    asp = exif.info$ImageWidth / exif.info$ImageHeight
    leftFov = leftFov * asp
    rightFov = rightFov * asp
    
    # format the DateTime field:
    exif.info$DateTime <- format(as.POSIXct(exif.info$DateTime, format="%Y:%m:%d %H:%M:%S", tz="GMT"), "%Y-%m-%dT%H:%M:%SZ")
    
    }
    else {
    stop("GPS Longitude/Latitude tags not available from the exif.info object.")
    }  
  }
  
  # Get the heading (if available):
  if(any(names(exif.info) %in% "GPSImgDirection")){
      x <- as.numeric(strsplit(exif.info$GPSImgDirection, "/")[[1]])
      try(exif.info$GPSImgDirection <- ifelse(length(x)>1, x[1]/x[2], x))
      heading = exif.info$GPSImgDirection
  }
  
  # Photo geometry:
  PhotoOverlay <- as.list(data.frame(rotation, leftFov, rightFov, bottomFov, topFov, near, shape, range, tilt, heading, roll))
  
  # make a SpatialPhotoOverlay object:
  spPh <- new("SpatialPhotoOverlay",  filename = filename, pixmap = pixmap, exif.info = exif.info, PhotoOverlay = PhotoOverlay, sp = obj) 
  return(spPh)    
}



## Get EXIF info from Wikimedia:
getWikiMedia.ImageInfo <- function(imagename, APIsource = "http://commons.wikimedia.org/w/api.php", module = "imageinfo", details = c("url", "metadata", "size", "extlinks"), testURL = TRUE){ 
  
  if(testURL == TRUE){
    require(RCurl)
    z <- getURI(paste("http://commons.wikimedia.org/wiki/File:", imagename, sep=""), .opts=curlOptions(header=TRUE, nobody=TRUE, transfertext=TRUE, failonerror=FALSE))
      if(!length(x <- grep(z, pattern="404 Not Found"))==0){
      stop(paste("File", imagename, "could not be located at http://commons.wikimedia.org"))
      }
  }
  
  options(warn = -1)
  # Get the image URL:
  xml.lst <- NULL
  for(j in 1:length(details)){
    if(details[j]=="url"|details[j]=="metadata"|details[j]=="size"){
    xml.api = xmlParse(readLines(paste(APIsource, "?action=query&titles=File:", imagename, "&prop=", module, "&iiprop=", details[j], "&format=xml", sep="")))
    x <- xmlToList(xml.api[["//ii"]], addAttributes=TRUE)
    if(names(x)=="metadata"){
      exif.info <- sapply(xml.api["//metadata[@value]"], xmlGetAttr, "value")
      names(exif.info) <- sapply(xml.api["//metadata[@name]"], xmlGetAttr, "name")
      xml.lst[[j]] <- as.list(data.frame(as.list(exif.info), stringsAsFactors=FALSE))
      }
      else {
      xml.lst[[j]] <- as.list(x)
      }
    }
    else {
    if(details[j]=="extlinks"){
    xml.api = xmlParse(readLines(paste(APIsource, "?action=query&titles=File:", imagename, "&prop=", details[j], "&format=xml", sep="")))    
    geo.tag <- sapply(xml.api["//extlinks/el"], xmlValue)
    geo.tag <- geo.tag[c(grep(geo.tag, pattern="http://toolserver.org/~geohack/"), grep(geo.tag, pattern="maps.google"))]
    if(!length(geo.tag)==0){
      x <- strsplit(strsplit(geo.tag[2], "ll=")[[1]][2], "&")[[1]][1]
      names(geo.tag) <- c("toolserver.org", "maps.google.com")
      xml.lst[[j]] <- as.list(geo.tag)
      # manually enterred metadata:
      Longitude <- strsplit(x, ",")[[1]][2]
      Latitude <- strsplit(x, ",")[[1]][1]
      }
    }
    else {
    stop("Currently reads only 'url', 'metadata' and 'extlinks' information.")
    }
    }

    names(xml.lst)[j] <- details[j] 
  }

  xml.lst[["metadata"]]$GPSLongitude <- Longitude
  xml.lst[["metadata"]]$GPSLatitude <- Latitude
  # rewrite metadata with the Wikimedia specs (more reliable):
  xml.lst[["metadata"]]$ImageWidth <- xml.lst[["size"]]$width
  xml.lst[["metadata"]]$ImageHeight <- xml.lst[["size"]]$height    
  
  return(xml.lst)
}  
  

# end of script; 
