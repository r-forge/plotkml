# Purpose        : Automatic reprojection of vector and raster features to geographic coordinates;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : tested
# Note           : bounding box and cell size are estimated by the program;

setMethod("reproject", "SpatialPoints", reproject.SpatialPoints)
setMethod("reproject", "SpatialPolygons", reproject.SpatialPoints)
setMethod("reproject", "SpatialLines", reproject.SpatialPoints)
setMethod("reproject", "RasterStack", reproject.RasterStack)
setMethod("reproject", "RasterLayer", reproject.RasterLayer)
setMethod("reproject", "SpatialGrid", reproject.SpatialPixels)
setMethod("reproject", "SpatialPixels", reproject.SpatialPixels)


reproject.SpatialPoints <- function(obj, CRS = get("ref_CRS", envir = plotKML.opts), ...) {
  res <- spTransform(x = obj, CRSobj = CRS(CRS))
  return(res)
}


reproject.RasterStack <- function(obj, CRS = get("ref_CRS", envir = plotKML.opts), ...) {
  stack(lapply(obj@layers, reproject, CRS = CRS, ...))
}


reproject.RasterBrick <- function(obj, CRS = get("ref_CRS", envir = plotKML.opts), ...) {
  brick(lapply(obj@layers, reproject, CRS = CRS, ...))
}


reproject.RasterLayer <- function(obj, CRS = get("ref_CRS", envir = plotKML.opts), program = "raster", tmp.file = TRUE, NAflag = get("NAflag", envir = plotKML.opts), ...) {

  if (is.factor(obj)){  
  method <- "ngb" }
  else {  
  method <- "bilinear" }
  
  if(program=="raster"){
  res <- projectRaster(obj, crs = CRS, method = method, progress='text', ...)
  layerNames(res) <- layerNames(obj)
  }
  
  if(program=="FWTools"){
  gdalwarp <- get("gdalwarp", envir = plotKML.opts)
  
  # look for FWTools path:  
  if(!nzchar(gdalwarp)){
  plotKML.env(silent = FALSE)
  gdalwarp <- get("gdalwarp", envir = plotKML.opts)
  }
  
  if(tmp.file==TRUE){
        tf <- tempfile() 
        }
        else { 
        tf <- deparse(substitute(obj))
        }
  
  if(nzchar(gdalwarp)){
  if(method == "ngb") { method <- "near" }
  writeRaster(obj, paste(tf, ".tif", sep=""), overwrite=TRUE, NAflag=NAflag)
  # resample to WGS84 system:
  system(paste(gdalwarp, " ", tf, ".tif", " -t_srs \"", ref_CRS, "\" ", tf, "_ll.tif -dstnodata \"", NAflag, "\" ", " -r ", method, sep=""))
  res <- readGDAL(paste(tf, "_ll.tif", sep=""), silent = TRUE)
  names(res) <- layerNames(obj)
  res <- as(res, "SpatialPixelsDataFrame")
  }
  else {
  stop("Could not locate FWTools. See 'plotKML.env()' for more info.") }
  }
  
  return(res)
}


reproject.SpatialPixels <- function(obj, CRS = get("ref_CRS", envir = plotKML.opts), tmp.file = TRUE, program = "raster", NAflag = get("NAflag", envir = plotKML.opts), ...) {

  if(program=="raster"){

    # if multiple layers:
    if (ncol(obj) > 1) {

      r <- stack(obj)
      r <- stack(lapply(r@layers, reproject, CRS = CRS, ...))
      res <- as(r, "SpatialGridDataFrame")
      res <- as(res, "SpatialPixelsDataFrame")
      names(res) <- names(obj)
    }

    # single layer:
    else {
      r <- raster(obj)
      res <- as(reproject(r, CRS = CRS, ...), "SpatialPixelsDataFrame")
      names(res) <- names(obj)
    }
  }
  
  if(program=="FWTools"){
  gdalwarp <- get("gdalwarp", envir = plotKML.opts)
  
  # look for FWTools path:  
  if(!nzchar(gdalwarp)){
  plotKML.env(silent = FALSE)
  gdalwarp <- get("gdalwarp", envir = plotKML.opts)
  }
  
  if(nzchar(gdalwarp)){
  
    for(i in 1:ncol(obj)){
  
    if(tmp.file==TRUE){
        tf <- tempfile() 
        }
        else { 
        tf <- paste(deparse(substitute(obj)), names(obj)[i], sep="_")
        }

        # write SPDF to a file:
        if(is.factor(obj@data[,i])){
        x <- obj[i]
        x@data[,1] <- as.integer(x@data[,1])
        writeGDAL(x, paste(tf, ".tif", sep=""), "GTiff")
        }        
        else {
        writeGDAL(obj[i], paste(tf, ".tif", sep=""), "GTiff")
        }
        
        # resample to WGS84 system:
        if(is.factor(obj@data[,i])){
        system(paste(gdalwarp, " ", tf, ".tif", " -t_srs \"", ref_CRS, "\" ", tf, "_ll.tif -dstnodata \"", NAflag, "\" -r near", sep=""), show.output.on.console = FALSE)
        }
        else {
        system(paste(gdalwarp, " ", tf, ".tif", " -t_srs \"", ref_CRS, "\" ", tf, "_ll.tif -dstnodata \"", NAflag, "\" -r bilinear", sep=""), show.output.on.console = FALSE)
        }
        if(i==1){
        res <- readGDAL(paste(tf, "_ll.tif", sep=""), silent = TRUE)
        names(res) <- names(obj)[i]
        }
        else{
        res@data[names(obj)[i]] <- readGDAL(paste(tf, "_ll.tif", sep=""), silent = TRUE)$band1
        }
        
        # reformat to original factors:
        if(is.factor(obj@data[,i])){
        res@data[,i] <- factor(res@data[,i], levels=levels(obj@data[,i]))
        }
      }
  } 
  
  else {
  stop("Could not locate FWTools. See 'plotKML.env()' for more info.") }
  
  } 
  
  res <- as(res, "SpatialPixelsDataFrame")
  return(res)
}

# end of script;