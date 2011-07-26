.referenceCrs <- "+proj=longlat +datum=WGS84"

reproject.SpatialPoints <- function(obj, CRS = .referenceCrs, ...) {
  spTransform(x = obj, CRSobj = CRS(CRS))
}

setMethod("reproject", "SpatialPoints", reproject.SpatialPoints)
setMethod("reproject", "SpatialPolygons", reproject.SpatialPoints)
setMethod("reproject", "SpatialLines", reproject.SpatialPoints)

reproject.Raster <- function(obj, CRS = .referenceCrs, ...) {
  if (obj@data@isfactor)
    method <- "ngb"
  else
    method <- "bilinear"
  projectRaster(obj, crs = CRS, method = method, ...)
}

setMethod("reproject", "Raster", reproject.Raster)

reproject.SpatialPixels <- function(obj, CRS = .referenceCrs, ...) {
  # SpatialPixelsDataFrame
  if ("data" %in% slotNames(obj)) {
    if (ncol(obj) > 1) {
      r <- stack(obj)
      res <- stack(llply(r@layers, reproject, CRS = CRS, ...))
      res <- as(res, "SpatialPixelsDataFrame")
    }
    else {
      r <- raster(obj)
      res <- as(reproject(r, CRS = CRS, ...), "SpatialPixelsDataFrame")
    }
    names(res) <- names(obj)
  }
  # SpatialPixels
  else {
    r <- raster(obj)
    res <- as(reproject(r, CRS = CRS, ...), "SpatialPixels")
  }

  res
}

setMethod("reproject", "SpatialPixels", reproject.SpatialPixels)