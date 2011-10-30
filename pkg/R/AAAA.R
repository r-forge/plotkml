# Purpose        : Initial settings;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : tested
# Note           : for more info see [http://cran.r-project.org/doc/manuals/R-exts.html];

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

# setup the plotKML environment:
plotKML.opts <- new.env(hash=TRUE)


# end of script;
