if (!isGeneric("kml_layer"))
  setGeneric("kml_layer", function(obj, ...)
    standardGeneric("kml_layer")
  )

if (!isGeneric("kml"))
  setGeneric("kml", function(obj, ...)
    standardGeneric("kml")
  )

if (!isGeneric("getCRS"))
  setGeneric("getCRS", function(obj, ...)
    standardGeneric("getCRS")
  )

if (!isGeneric("reproject"))
  setGeneric("reproject", function(obj, ...)
    standardGeneric("reproject")
  )

# setup our environment for storing file handles and the like
plotKML.fileIO <- new.env(hash=TRUE)

## DEB: moved this from plotKML.otions.R
## not sure if this makes sense...
plotKML.opts <- new.env(hash=TRUE)

## temporary hack!
# load plotKML.opts with some basic information
assign("colour_scale_numeric", rev(brewer.pal(n = 5, name = "Spectral")), envir=plotKML.opts)
assign("colour_scale_factor", brewer.pal(n = 6, name = "Set1"), envir=plotKML.opts)
assign("ref_CRS", "+proj=longlat +datum=WGS84", envir=plotKML.opts)
assign("NAflag", -99999, envir=plotKML.opts)
assign("kml_xsd", "http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd", envir=plotKML.opts)
assign("gpx_xsd", "http://www.topografix.com/GPX/1/1/gpx.xsd", envir=plotKML.opts)
assign("convert", '', envir=plotKML.opts)
assign("gdalwarp", '', envir=plotKML.opts)
assign("gdal_translate", '', envir=plotKML.opts)
assign("python", '', envir=plotKML.opts)
assign("home_url", '', envir=plotKML.opts)
assign("googleAPIkey", '', envir=plotKML.opts)



## DEB: can't put this here, as the function has not been defined yet...
# set the environmental variables:
# plotKML.env(show.env = FALSE)
