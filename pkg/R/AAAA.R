if (!isGeneric("kml_layer"))
  setGeneric("kml_layer", function(obj, ...)
    standardGeneric("kml_layer")
  )

if (!isGeneric("kml"))
  setGeneric("kml", function(obj, ...)
    standardGeneric("kml")
  )

if (!isGeneric("reproject"))
  setGeneric("reproject", function(obj, CRS, ...)
    standardGeneric("reproject")
  )