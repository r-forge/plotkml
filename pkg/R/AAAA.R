# Purpose        : Initial settings;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl)
# Contributions  : Pierre Roudier (pierre.roudier@landcare.nz); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Dev Status     : Pre-Alpha
# Note           : for more info see [http://cran.r-project.org/doc/manuals/R-exts.html];

################## NEW plotKML CLASSES ##############

## Color palette:
setClass("sp.palette", representation (type = 'character', bounds = 'vector', color = 'character', names = 'character', icons = 'character'), validity <- function(x) {
   if(!class(x@bounds)=="numeric")
      return('vector with (upper and lower limits) required')
   if((length(x@bounds)-1)!=length(x@color)|(length(x@bounds)-1)!=length(x@names))
      return('size of bounds-1, colors and element names must be equal')
   if(any(nchar(x@color)>9|nchar(x@color)<7))
      return('colors in hex system required') 
})

## A new class for SpatialMetadata:
setClass("SpatialMetadata", representation(xml = "XMLInternalDocument", field.names = "character", palette = "sp.palette", sp = "Spatial"), validity <- function(obj) {
    if(!xmlName(xmlRoot(obj@xml))=="metadata")
      return("xml file tagged 'metadata' required")
    if(!length(.getXMLnames(obj@xml))==length(obj@field.names))
      return("length of field names does not match the column names in xml slot")
    if(!class(obj@field.names)=="character")
      return("field names as character vector required")      
})

## set generic functions:
if (!isGeneric("metadata"))
  setGeneric("metadata", function(obj, ...) standardGeneric("metadata")
  )

if (!isGeneric("field.names"))  
  setGeneric("field.names", function(obj) standardGeneric("field.names")
  )

if (!isGeneric("sp.palette"))
  setGeneric("sp.palette", function(obj) standardGeneric("sp.palette")
  )

if (!isGeneric("metadata2SLD"))
  setGeneric("metadata2SLD", function(obj) standardGeneric("metadata2SLD")
  )

if (!isGeneric("kml_layer"))
  setGeneric("kml_layer", function(obj, ...) standardGeneric("kml_layer")
  )

if (!isGeneric("kml_metadata"))
  setGeneric("kml_metadata", function(obj, ...) standardGeneric("kml_metadata")
  )

if (!isGeneric("kml"))
  setGeneric("kml", function(obj, ...)  standardGeneric("kml")
  )

if (!isGeneric("getCRS"))
  setGeneric("getCRS", function(obj, ...)  standardGeneric("getCRS")
  )

if (!isGeneric("reproject"))
  setGeneric("reproject", function(obj, ...)  standardGeneric("reproject")
  )

if (!isGeneric("grid2poly"))
  setGeneric("grid2poly", function(obj, ...)  standardGeneric("grid2poly")
  )

################## STANDARD ENVIRONMENTS ##############

## setup our environment for storing file handles and the like
plotKML.fileIO <- new.env(hash=TRUE)

## setup the plotKML environment:
plotKML.opts <- new.env(hash=TRUE)

## Standard settings:
plotKML.env <- function(
    colour_scale_numeric = '',
    colour_scale_factor = '',
    ref_CRS,
    NAflag,
    icon,
    LabelScale,
    license_url,
    metadata,
    kmz,
    kml_xsd,
    kml_url,
    kml_gx,
    gpx_xsd,
    fgdc_xsd,
    convert,
    gdalwarp,
    gdal_translate,
    python,
    home_url,
    googleAPIkey,
    show.env = TRUE,
    silent = TRUE
    ){
    
    if(missing(colour_scale_numeric)) { colour_scale_numeric <- rev(brewer.pal(n = 5, name = "Spectral")) }
    if(missing(colour_scale_factor)) { colour_scale_factor <- brewer.pal(n = 6, name = "Set1") }
    if(missing(ref_CRS)) { ref_CRS <- "+proj=longlat +datum=WGS84" }
    if(missing(NAflag)) { NAflag <- -99999 }
    if(missing(icon)) { icon <- "cross.png" }
    if(missing(LabelScale)) { LabelScale <- .7 }
    if(missing(license_url)) { license_url <- "http://creativecommons.org/licenses/by/3.0/" }
    if(missing(metadata)) { metadata <- FALSE }
    if(missing(kmz)) { kmz <- FALSE }
    if(missing(kml_xsd)) { kml_xsd <- "http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd" }
    if(missing(kml_url)) { kml_url <- "http://www.opengis.net/kml/2.2/" }
    if(missing(kml_gx)) { kml_gx <- "http://www.google.com/kml/ext/2.2" }
    if(missing(gpx_xsd)) { gpx_xsd <- "http://www.topografix.com/GPX/1/1/gpx.xsd" }
    if(missing(fgdc_xsd)) { fgdc_xsd <- "http://fgdcxml.sourceforge.net/schema/fgdc-std-012-2002/fgdc-std-012-2002.xsd" }
    
    if(!silent){
    pts <- paths(show.paths = TRUE)
    }
    else {
    pts <- data.frame(gdalwarp="", gdal_translate="", convert="", python="", saga_cmd="", stringsAsFactors = FALSE)
    }
    
    if(missing(convert)) { convert <- pts$convert[[1]] }
    if(missing(gdalwarp)) { gdalwarp <- pts$gdalwarp[[1]] }
    if(missing(gdal_translate)) { gdal_translate <- pts$gdal_translate[[1]] }
    if(missing(python)) { python <- pts$python[[1]] }
    if(missing(home_url)) { home_url <- "http://plotkml.r-forge.r-project.org/" }
    if(missing(googleAPIkey)) { googleAPIkey <- "ABQIAAAAqHzabFRj8QwDECupLUR4-hT53Nvo2rq6JtI9-sNzq2yJTiKUYBRN5VP8pfrIcMaRo0pNDvBhWJUQCA" }
 
    assign("colour_scale_numeric", colour_scale_numeric, envir=plotKML.opts)
    assign("colour_scale_factor", colour_scale_factor, envir=plotKML.opts)
    assign("ref_CRS", ref_CRS, envir=plotKML.opts)
    assign("NAflag", NAflag, envir=plotKML.opts)
    assign("icon", icon, envir=plotKML.opts)
    assign("LabelScale", LabelScale, envir=plotKML.opts)
    assign("license_url", license_url, envir=plotKML.opts)
    assign("metadata", metadata, envir=plotKML.opts)
    assign("kmz", kmz, envir=plotKML.opts)
    assign("kml_xsd", kml_xsd, envir=plotKML.opts)
    assign("kml_url", kml_url, envir=plotKML.opts)
    assign("kml_gx", kml_gx, envir=plotKML.opts)
    assign("gpx_xsd", gpx_xsd, envir=plotKML.opts)
    assign("fgdc_xsd", fgdc_xsd, envir=plotKML.opts)
    assign("convert", convert, envir=plotKML.opts)
    assign("gdalwarp", gdalwarp, envir=plotKML.opts)
    assign("gdal_translate", gdal_translate, envir=plotKML.opts)
    assign("python", python, envir=plotKML.opts)
    assign("home_url", home_url, envir=plotKML.opts)
    assign("googleAPIkey", googleAPIkey, envir=plotKML.opts)
    
    plotKML.opts <- list(colour_scale_numeric, colour_scale_factor, ref_CRS, NAflag, icon, LabelScale, license_url, metadata, kmz, kml_xsd, kml_url, kml_gx, gpx_xsd, fgdc_xsd, convert, gdalwarp, gdal_translate, python, home_url, googleAPIkey)
    names(plotKML.opts) <- c("colour scale for numeric variables", "colour scale for factor variables", "referent CRS", "NA flag value", "default icon", "default label size", "default license url", "print metadata", "compress to kmz", "kml xsd URL", "kml URL", "kml gx URL", "gpx xsd URL", "fgdc xsd URL", "location of convert program", "location of gdalwarp program", "location of gdal_translate program", "location of python program", "data repository URL", "google API key")
    
    if(show.env){  return(plotKML.opts)  }
 
}

# load plotKML.opts with some basic information
plotKML.env(show.env = FALSE)
# (!) this will not attempt to locate external software because this could be time consuming;

# end of script;
