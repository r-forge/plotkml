# Setting up environment variables for the plotKML package
# Author: Tomislav Hengl & Pierre Roudier
# contact:  tom.hengl@wur.nl & pierre.roudier@landcare.nz
# Date : August 2011
# Version 0.1
# Licence GPL v3

## looks for FWTools in the Windows Registry Hive,
## the Program Files directory and the usr/bin installation

# plotKML.options = function(kml.schema.uri, kml.simpleType, kml.complexType, convert, gdalwarp = "", gdal_translate = "") {
### This function needs fixing...
   
#    require(animation)
#    require(XML)
#   # xsd <- system.file("ogckml22.xsd", package = "plotKML")
#   xsd <- "http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd"
#   doc <- xmlTreeParse(xsd, isURL=TRUE) # The package should load this from a local file;
#   tmp <- xmlRoot(doc)
#   dd <-  xmlNamespaceDefinitions(tmp, recursive = TRUE)
#   sel <- tmp[which(names(xmlChildren(tmp))=="complexType")]
#   sel2 <- tmp[which(names(xmlChildren(tmp))=="simpleType")]
#   kml.schema.uri = dd$kml$uri
#   kml.simpleType = sapply(sel2, xmlGetAttr, "name") 
#   kml.complexType = sapply(sel, xmlGetAttr, "name")
#   convert = ani.options('convert')
#   .plotKML.opts <- list(kml.schema.uri, kml.simpleType, kml.complexType, convert, gdalwarp, gdal_translate)
#   return(.plotKML.opts)
# }


### Try to locate FWTools under various platforms:
fw.path <- function(gdalwarp = "", gdal_translate = ""){
  # Under Linux make sure you add path to gdalwarp by using e.g.:
  # export PATH=INSTALL_DIRECTORY/FWTools-2.*.*/bin_safe:$PATH
  if (.Platform$OS.type == "windows") {
     if (!inherits(try({ fw.path = utils::readRegistry("SOFTWARE\\WOW6432NODE\\FWTools")$Install_Dir }, silent = TRUE), "try-error")) 
      { if (nzchar(fw.path))  { 
      gdalwarp = shQuote(normalizePath(file.path(fw.path, "bin/gdalwarp.exe")))
      gdal_translate = shQuote(normalizePath(file.path(fw.path, "bin/gdal_translate.exe")))
      message(paste("Located FWTools from the Registry Hive: \"", fw.path, "\"", sep="")) 
              }
      }
      else if( nzchar(prog <- Sys.getenv("ProgramFiles")) &&
          length(fw.dir <- list.files(prog, "^FWTools.*")) &&
          length(fw.path <- list.files(file.path(prog, fw.dir), pattern = "^gdalwarp\\.exe$", full.names = TRUE, recursive = TRUE))  |
          length(fw.path2 <- list.files(file.path(prog, fw.dir), pattern = "^gdal_translate\\.exe$", full.names = TRUE, recursive = TRUE)) )
       {
      gdalwarp = shQuote(normalizePath(fw.path[1]))
      gdal_translate = shQuote(normalizePath(fw.path2[1]))
      message(paste("Located FWTools from the 'Program Files' directory: \"", fw.path, "\"", sep=""))
     }
     else if (nzchar(prog <- Sys.getenv("ProgramFiles(x86)")) &&
          length(fw.dir <- list.files(prog, "^FWTools.*")) &&
          length(fw.path <- list.files(file.path(prog, fw.dir), pattern = "^gdalwarp\\.exe$", full.names = TRUE, recursive = TRUE))  &&
          length(fw.path2 <- list.files(file.path(prog, fw.dir), pattern = "^gdal_translate\\.exe$", full.names = TRUE, recursive = TRUE))   )
       {
      gdalwarp = shQuote(normalizePath(fw.path[1]))
      gdal_translate = shQuote(normalizePath(fw.path2[1]))
      message(paste("Located FWTools from the 'Program Files' directory: \"", fw.path, "\"", sep=""))
     }
     
     else {
      warning("Could not locate FWTools! Install program and add it to the Windows registry. See http://fwtools.maptools.org for more info.")
      return()
       }
    } 
    else {
    if ( nzchar(grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="FWTools")) ) {
    fw.dir <- paths[grep(paths, pattern="FWTools")[1]]
    gdalwarp = "gdalwarp"
    gdal_translate = "gdal_translate"
    message(paste("Located FWTools from the path: \"", fw.dir, "\"", sep=""))
      }
    else { 
    warning("Install FWTools and add to PATH. See http://fwtools.maptools.org for more info.")
                    return()
      }
    }
    ## write it into plotKML.options() to save future efforts
    # plotKML.options(gdalwarp = gdalwarp, gdal_translate = gdal_translate)
    return(gdalwarp)
    return(gdal_translate)
}
