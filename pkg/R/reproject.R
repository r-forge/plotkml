.referenceCrs <- "+proj=longlat +datum=WGS84"

reproject.SpatialPoints <- function(obj, ...) {
  spTransform(obj, CRS(.referenceCrs))
}

setMethod("reproject", "SpatialPoints", reproject.SpatialPoints)
setMethod("reproject", "SpatialPolygons", reproject.SpatialPoints)
setMethod("reproject", "SpatialLines", reproject.SpatialPoints)

reproject.Raster <- function(obj, ...) {
  projectRaster(obj, crs = .referenceCrs, ...)
}

setMethod("reproject", "Raster", reproject.Raster)

reproject.SpatialPixels <- function(obj, ...) {
  # SpatialPixelsDataFrame
  if ("data" %in% slotNames(obj)) {
    if (ncol(obj) > 1)
      r <- stack(obj)
    else
      r <- raster(obj)
    res <- as(reproject(r, ...), "SpatialPixelsDataFrame")
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