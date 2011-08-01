# R functions for the plotKML package
# Author: Pierre Roudier & Tomislav Hengl
# contact: pierre.roudier@landcare.nz; tom.hengl@wur.nl
# Date : August 2011
# Version 0.1
# Licence GPL v3

.referenceCrs <- "+proj=longlat +datum=WGS84"

reproject.SpatialPoints <- function(obj, CRS = .referenceCrs, ...) {
  spTransform(x = obj, CRSobj = CRS(CRS))
}

setMethod("reproject", "SpatialPoints", reproject.SpatialPoints)
setMethod("reproject", "SpatialPolygons", reproject.SpatialPoints)
setMethod("reproject", "SpatialLines", reproject.SpatialPoints)

reproject.RasterStack <- function(obj, CRS = .referenceCrs, ...) {
  stack(llply(obj@layers, reproject, CRS = CRS, ...))
}

setMethod("reproject", "RasterStack", reproject.RasterStack)

reproject.RasterBrick <- function(obj, CRS = .referenceCrs, ...) {
  brick(llply(obj@layers, reproject, CRS = CRS, ...))
}

setMethod("reproject", "RasterStack", reproject.RasterStack)

reproject.RasterLayer <- function(obj, CRS = .referenceCrs, ...) {
  if (is.factor(obj))
    method <- "ngb"
  else
    method <- "bilinear"
  res <- projectRaster(obj, crs = CRS, method = method, progress='text', ...)
  layerNames(res) <- layerNames(obj)
  res
}

setMethod("reproject", "RasterLayer", reproject.RasterLayer)

reproject.SpatialPixels <- function(obj, CRS = .referenceCrs, FWTools = FALSE, mvFlag = -99999, ...) {
  # Locate GDALwarp:
  fw.path <- shortPathName(readRegistry("SOFTWARE\\WOW6432NODE\\FWTools")$Install_Dir)
  gdalwarp <- ifelse(.Platform$OS.type=="windows", paste(fw.path, "bin", "gdalwarp.exe", sep="\\"), "gdalwarp")
  
  # SpatialPixelsDataFrame
  if ("data" %in% slotNames(obj)) {
    i_nm <- which(sapply(obj@data, class) == 'numeric')

    # if multiple layers:
    if (ncol(obj) > 1) {

    if(FWTools==TRUE){
       for(i in 1:length(ncol(obj))){
       writeGDAL(obj[i], paste(names(obj)[i], ".tif", sep=""), "GTiff", mvFlag=mvFlag)
       unlink(paste(names(obj)[i], "_ll.sdat", sep=""))
       # reproject/resample using FWTools:
       cmd <- paste(gdalwarp, " ", names(obj)[i], ".tif ", names(obj)[i], "_ll.sdat -of \"SAGA\" -r bilinear -s_srs \"", proj4string(obj), "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep="")
       sss <- try(system(cmd), silent=TRUE)
      }
      res <- readGDAL(paste(names(obj)[1], "_ll.sdat", sep=""))
      names(res) <- names(obj)[i]
      for(i in 2:length(ncol(obj))){ res@data[,names(obj)[i]] <- readGDAL(paste(names(obj)[i], "_ll.sdat", sep=""))$band1  }
       
      }
      else{

      r <- stack(obj)
      res <- stack(llply(r@layers, reproject, CRS = CRS, ...))
      res <- as(res, "SpatialPixelsDataFrame")
    }
    }
    
    else {
      r <- raster(obj)
      res <- as(reproject(r, CRS = CRS, ...), "SpatialPixelsDataFrame")
    }

#     i_na <- unique(which(!is.na(res@data[, i_nm]), arr.ind = TRUE)[,1])
#     res <- res[i_na, ]
  }
  # SpatialPixels
  else {
    r <- raster(obj)
    res <- as(reproject(r, CRS = CRS, ...), "SpatialPixels")
  }

  res
}

setMethod("reproject", "SpatialPixels", reproject.SpatialPixels)