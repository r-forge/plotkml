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

# set the environmental variables:
plotKML.env(show.env = FALSE)
