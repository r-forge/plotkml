.referenceCrs <- "+proj=longlat +datum=WGS84"

reproject.SpatialPoints <- function(obj, ...) {
  spTransform(obj, CRS(.referenceCrs))
}

setMethod("reproject", "SpatialPoints", reproject.SpatialPoints)
setMethod("reproject", "SpatialPolygons", reproject.SpatialPoints)
setMethod("reproject", "SpatialLines", reproject.SpatialPoints)

reproject.Raster <- function(obj, ...) {
  if (obj@data@isfactor)
    method <- "ngb"
  else
    method <- "bilinear"
  projectRaster(obj, crs = .referenceCrs, method = method, ...)
}

setMethod("reproject", "Raster", reproject.Raster)

reproject.SpatialPixels <- function(obj, ...) {
  # SpatialPixelsDataFrame
  if ("data" %in% slotNames(obj)) {
    if (ncol(obj) > 1) {
      r <- stack(obj)
      res <- stack(llply(r@layers, reproject, ...))
      res <- as(res, "SpatialPixelsDataFrame")
    }
    else {
      r <- raster(obj)
      res <- as(reproject(r, ...), "SpatialPixelsDataFrame")
    }
    names(res) <- names(obj)
  }
  # SpatialPixels
  else {
    r <- raster(obj)
    res <- as(reproject(r, ...), "SpatialPixels")
  }

  res
}

setMethod("reproject", "SpatialPixels", reproject.SpatialPixels)