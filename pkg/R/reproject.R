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

reproject.SpatialPixels <- function(obj, CRS = .referenceCrs, ...) {

  # SpatialPixelsDataFrame
  if ("data" %in% slotNames(obj)) {
    i_nm <- which(sapply(obj@data, class) == 'numeric')

    # if multiple layers:
    if (ncol(obj) > 1) {

      r <- stack(obj)
      res <- stack(llply(r@layers, reproject, CRS = CRS, ...))
      res <- as(res, "SpatialPixelsDataFrame")
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