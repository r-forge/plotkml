# Purpose        : Various utilitis for plotKML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl).edu)
# Contributions  : Pierre Roudier (pierre.roudier@landcare.nz); Dylan Beaudette (debeaudette@ucdavis
# Status         : not tested yet
# Note           : This functions should be included in the utils.R on the trunk

# Whitening (RGB) values
#
whitening <- function(
   x,      # target variable
   xvar,   # associated uncertainty
   x.lim = c(min(x, na.rm=TRUE), max(x, na.rm=TRUE)), 
   e.lim = c(.4,1), 
   global.var = var(x, na.rm=TRUE), 
   col.type = "RGB")  # output col.type can be "RGB" or "hex" 
   {
   require(colorspace)
   
   # Derive the normalized error:
   er <- sqrt(xvar)/sqrt(global.var)
   # Strech the values (z) to the inspection range:
   tz <- (x-x.lim[1])/(x.lim[2]-x.lim[1])
   tz <- ifelse(tz<=0, 0, ifelse(tz>1, 1, tz))
   # Derive the Hues:
   f1 <- -90-tz*300
   f2 <- ifelse(f1<=-360, f1+360, f1)
   H <- ifelse(f2>=0, f2, (f2+360))
   # Strech the error values (e) to the inspection range:
   er <- (er-e.lim[1])/(e.lim[2]-e.lim[1])
   er <- ifelse(er<=0, 0, ifelse(er>1, 1, er))
   # Derive the saturation and intensity images:
   S <- 1-er
   V <- 0.5*(1+er)
   
   # Convert the HSV values to RGB and put them as R, G, B bands:
   if(col.type=="hex"){
      out.cols <- hex(HSV(H, S, V))
      return(out.cols)
   }
   else { 
      out.cols <- as(HSV(H, S, V), "RGB")
      return(out.cols)
} 
} 

## From 2 points to a geo-path
geopath <- function(lon1, lon2, lat1, lat2, ID, n.points, print.geo = FALSE) {
    require(fossil)  # Haversine Formula for Great Circle distance
    # lon / lat = geographical coordinates on WGS84
    # n.points = number of intermediate points

    p.1 <- matrix(c(lon1, lat1), ncol=2, dimnames=list(1,c("lon","lat")))  # source
    p.2 <- matrix(c(lon2, lat2), ncol=2, dimnames=list(1,c("lon","lat")))  # destination
    distc <- deg.dist(lat1=p.1[,2], long1=p.1[,1], lat2=p.2[,2], long2=p.2[,1])  # in km
    bearingc <- earth.bear(lat1=p.1[,2], long1=p.1[,1], lat2=p.2[,2], long2=p.2[,1])  # bearing in degrees from north
    # estimate the number of points based on the distance (the higher the distance, less points we need): 
    if(missing(ID)) { ID <- paste(ifelse(lon1<0, "W", "E"), abs(round(lon1,0)), ifelse(lat1<0, "S", "N"), abs(round(lat1,0)), ifelse(lon2<0, "W", "E"), abs(round(lon2,0)), ifelse(lat2<0, "S", "N"), abs(round(lat2,0)), sep="") }
    if(missing(n.points)) {
        n.points <- round(sqrt(distc)/sqrt(2), 0)
        }
    if(!is.nan(n.points)) { if(n.points>0) {
     pnts <- t(sapply(1:n.points/(n.points+1)*distc, FUN=new.lat.long, lat=p.1[,2], lon=p.1[,1], bearing=bearingc))[,c(2,1)] # intermediate points
    # some lines are crossing the whole globe (>180 or <-180 longitudes) and need to be split in two:
    if(is.matrix(pnts)){ if(max(LineLength(pnts, sum=FALSE))>100) {  
    breakp <- which.max(abs(pnts[,1]-c(pnts[-1,1], pnts[length(pnts[,1]),1])))
    pnts1 <- pnts[1:breakp,]
    pnts2 <- pnts[(breakp+1):length(pnts[,1]),]  
    routes <- Lines(list(Line(matrix(rbind(p.1, pnts1),ncol=2)), Line(matrix(rbind(pnts2, p.2),ncol=2))), ID=as.character(ID))
    } 
   
      else {
       routes <- Lines(list(Line(matrix(rbind(p.1, pnts, p.2),ncol=2))), ID=as.character(ID)) } 
} } 
   # create SpatialLines:
   path <- SpatialLines(list(routes), CRS("+proj=longlat +datum=WGS84"))
   }
   if(print.geo==TRUE) {
   print(paste("Distance:", round(distc,1)))
   print(paste("Bearing:", round(bearingc,1)))
  } 
  return(path)
}

## From Munsell colour codes to FBGR codes:
munsell2kml <- function(
  the_hue, 
  the_chroma,
  the_value, 
  alpha = 1
  ){
  require(aqp)

  res <- hex2kml(munsell2rgb(the_hue, the_value, the_chroma, alpha=alpha))
  
  return(res)
}  


## Convert SGDF to a polygon map (grid cells):
# Not recommended for large grids!

grid2poly <- function(obj, reproject = TRUE, var.name, method = "sp"){

    if(missing(var.name)) { var.name <- names(obj)[1] }
    # print warning:
    warning("Operation not recommended for large grids (>>10e4 pixels).", immediate. = TRUE)
    
    if(method=="sp"){
        obj <- as(obj[var.name], "SpatialPixelsDataFrame")
        pol <- as.SpatialPolygons.SpatialPixels(obj)
    }
    
    if(method=="raster"){
        require(raster)
        r <- raster(obj[var.name])
        pol <- rasterToPolygons(r)
    }
    
    if(method=="RSAGA"){
        require(RSAGA)
        if(!rsaga.env()[["cmd"]]=="NULL"){
        require(maptools)
        # first write to a file:
        writeGDAL(obj[var.name], paste(var.name, ".sdat", sep=""), "SAGA")
        rsaga.geoprocessor(lib="shapes_grid", module=3, param=list(GRIDS=paste(var.name, ".sgrd", sep=""), SHAPES=paste(var.name, ".shp", sep=""), NODATA=TRUE, TYPE=1))
        pol <- readShapePoly(paste(var.name, ".shp", sep=""), proj4string=obj@proj4string)
        }
        else { stop("SAGA GIS path could not be located. See 'rsaga.env()' for more info.") }
    }
    
    # Checking projection:
    check <- check_projection(pol, logical = TRUE)

    # Trying to reproject data if the check was not successful
    if (!check&reproject==TRUE) {  pol <- reproject(pol)  }

    # Convert to SPolyDF:
    dm <- data.frame(obj@data[,var.name])
    names(dm) <- var.name
    pol <- SpatialPolygonsDataFrame(pol, dm, match.ID=FALSE)
    
    return(pol)
} 


## Read GPX files [http://www.topografix.com/gpx.asp] and convert to tables:
# gpx.schema = "http://www.topografix.com/GPX/1/1/gpx.xsd" 

readGPX <- function(
    gpx.file,
    metadata = TRUE,
    bounds = TRUE,
    waypoints = TRUE, # waypoint - point of interest, or named feature on a map.
    tracks = TRUE,  # track - an ordered list of points describing a path.
    routes = TRUE   # route - an ordered list of waypoints representing a series of turn points leading to a destination.
    )
    ## 
    {
    
    require(XML)  # http://www.omegahat.org/RSXML/Tour.pdf
    options(warn = -1)    

    if(metadata==TRUE) { metadata <- .readGPX.element(gpx.file, "name") }    
    if(bounds==TRUE) { bounds <- .readGPX.element(gpx.file, "bounds") }    
    if(waypoints==TRUE) { waypoints <- .readGPX.element(gpx.file, "wpt") }
    if(tracks==TRUE) { tracks <- .readGPX.element(gpx.file, "trk") }
    if(routes==TRUE) { routes <- .readGPX.element(gpx.file, "rte") }
        
    gpx <- list(metadata=metadata, bounds=bounds, waypoints=waypoints, tracks=tracks, routes=routes)
    return(gpx)
}    


## Read various elements from a gpx.file:

.readGPX.element <- function(gpx.file, element) {
    # element = "metadata", "wpt", "rte", "trk"
    
    require(XML)
    ret <- xmlTreeParse(gpx.file, useInternalNodes = TRUE)
    # top structure: 
    top <- xmlRoot(ret)
    
    # check if there is any content:
    if(any(grep(element, names(top)))) {
    
      # tracks:
      if(element=="trk"){   
      ret <- NULL
      nu <- which(names(top) %in% element)
      for(c in seq_along(nu)){
        lst <- which(names(top[[nu[c]]]) %in% "trkseg")
        nm <- names(top[[nu[c]]][[lst[1]]][[1]])
        ret[[c]] <- list(NULL)
          for(i in seq_along(lst)) {
          trkpt <- top[[nu[c]]][[lst[i]]]
          ret[[c]][[i]] <- data.frame(NULL)
          ## get columns (http://www.topografix.com/GPX/1/1/#type_wptType)
          lon <- as.numeric(xmlSApply(trkpt, xmlGetAttr, "lon"))
          lat <- as.numeric(xmlSApply(trkpt, xmlGetAttr, "lat"))
          ret[[c]][[i]][1:length(lon),"lon"] <- lon
          ret[[c]][[i]][1:length(lat),"lat"] <- lat
          if(!nm[[1]]=="NULL"){
             for(j in 1:length(nm)){
                xm <- as.character(sapply(sapply(xmlChildren(trkpt), function(x) x[[nm[[j]]]]), xmlValue))
                ret[[c]][[i]][1:length(xm), nm[[j]]] <- xm 
                }
          } 
          }
        names(ret[[c]]) <- xmlValue(top[[nu[c]]][["name"]])
       }   
      }
    
      if(element=="wpt"){
      ret <- data.frame(NULL)
      nu <- which(names(top) %in% element)
      nm <- names(top[[nu[1]]])
      for(i in seq_along(nu)) {
        # coordinates:
        ret[i, "lon"] <- as.numeric(xmlGetAttr(top[[nu[i]]], "lon"))
        ret[i, "lat"] <- as.numeric(xmlGetAttr(top[[nu[i]]], "lat"))
        if(!nm[[1]]=="NULL"){
          for(j in 1:length(nm)){
            ret[i, nm[[j]]] <- xmlValue(xmlChildren(top[[nu[i]]])[[nm[[j]]]])
          }  
          }
       }
      }
    
      if(element=="rte"){
      ret <- NULL
      nu <- which(names(top) %in% element)
      for(c in seq_along(nu)){
        ret[[c]] <- data.frame(NULL)
        lst <- which(names(top[[nu[c]]]) %in% "rtept")
        nm <- names(top[[nu[c]]][[lst[1]]])
        for(i in seq_along(lst)) {
          rtept <- top[[nu[c]]][[lst[i]]]
          ret[[c]][i, "lon"] <- as.numeric(xmlGetAttr(rtept, "lon"))
          ret[[c]][i, "lat"] <- as.numeric(xmlGetAttr(rtept, "lat"))
          if(!nm[[1]]=="NULL"){
             for(j in c("name","cmt","desc","sym","type")){
                try(ret[[c]][i, j] <- xmlValue(rtept[[j]]), silent = TRUE)
                }
          } 
        }
        names(ret)[c] <- xmlValue(top[[nu[c]]][["name"]])
        }
      }
      
      # bounds
      if(element=="bounds"){
      nu <- which(names(top) %in% element)
      ret <- matrix(rep(NA, 4), nrow=2, dimnames = list(c("lat", "lon"), c("min", "max")))
      # coordinates:
      ret[1,1] <- as.numeric(xmlGetAttr(top[[nu[1]]], "minlon"))
      ret[1,2] <- as.numeric(xmlGetAttr(top[[nu[1]]], "maxlon"))
      ret[2,1] <- as.numeric(xmlGetAttr(top[[nu[1]]], "minlat"))
      ret[2,2] <- as.numeric(xmlGetAttr(top[[nu[1]]], "maxlat"))
      }
          
      # metadata
      if(element=="name"){
      lst <- c("name","desc","author","email","url","urlname","time")
      nu <- which(names(top) %in% lst)
      if(!nu[[1]]=="NULL"){      
      ret <- data.frame(NULL)
      for(i in seq_along(lst)) {
        try(ret[1,lst[i]] <- xmlValue(top[[nu[[i]]]]), silent = TRUE)
        }
      }
      }
         
    }
    else { ret <- NULL }

    return(ret)
}

