if (!isGeneric("layer"))
  setGeneric("layer", function(obj, ...)
    standardGeneric("layer")
  )

if (!isGeneric("kml"))
  setGeneric("kml", function(obj, ...)
    standardGeneric("kml")
  )