# Purpose        : Various utilitis for plotKML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl)
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz)
# Status         : not tested yet
# Note           : This function helps establishing a link with external packages and settings


## looks for FWTools in the Windows Registry Hive,
## the Program Files directory and the usr/bin installation

### Try to locate FWTools under various platforms:
paths <- function(gdalwarp = "", gdal_translate = "", convert = ""){
    # Under Linux make sure you add path to gdalwarp by using e.g.:
    # export PATH=INSTALL_DIRECTORY/FWTools-2.*.*/bin_safe:$PATH
  
     require(animation)
     convert <- ani.options("convert")
     
    if(is.null(convert)){
        if(.Platform$OS.type == "windows") {
        if(nzchar(grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ";")[[1]], pattern="Magick"))) {
        im.dir <- paths[grep(paths, pattern="ImageMagick")[1]]
        convert = shQuote(normalizePath(file.path(im.dir, "convert.exe")))
        message(paste("Located ImageMagick from the path: \"", im.dir, "\"", sep=""))
        }}
        else{
        if(nzchar(grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="Magick"))) {
        im.dir <- paths[grep(paths, pattern="Magick")[1]]
        convert = "convert"
        message(paste("Located ImageMagick from the path: \"", im.dir, "\"", sep=""))
    }}}
    else { 
    warning("Install ImageMagick and add to PATH. See http://imagemagick.org for more info.")
      }  
  
  if(.Platform$OS.type == "windows") {

     if(!inherits(try({ fw.path = utils::readRegistry("SOFTWARE\\WOW6432NODE\\FWTools")$Install_Dir }, silent = TRUE), "try-error")) 
      { if (nzchar(fw.path))  { 
      gdalwarp = shQuote(normalizePath(file.path(fw.path, "bin/gdalwarp.exe")))
      gdal_translate = shQuote(normalizePath(file.path(fw.path, "bin/gdal_translate.exe")))
      message(paste("Located FWTools from the Registry Hive: \"", fw.path, "\"", sep="")) 
              }
      }
      else if(nzchar(prog <- Sys.getenv("ProgramFiles")) &&
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
    
    if(nzchar(grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="FWTools"))) {
    fw.dir <- paths[grep(paths, pattern="FWTools")[1]]
    gdalwarp = "gdalwarp"
    gdal_translate = "gdal_translate"
    message(paste("Located FWTools from the path: \"", fw.dir, "\"", sep=""))
      }
    else { 
    warning("Install FWTools and add to PATH. See http://fwtools.maptools.org for more info.")
      }
    }

    lt <- data.frame(gdalwarp, gdal_translate, convert, stringsAsFactors = FALSE)
    return(lt)
}

## Standard settings:
plotKML.env <- function(
    colour_scale_numeric,
    colour_scale_factor,
    xsd,
    convert,
    gdalwarp,
    gdal_translate,
    googleAPIkey
    ){
    
    require(RColorBrewer)
    
    plotKML.opts <<- new.env(hash=TRUE)
    
    if(missing(colour_scale_numeric)) { colour_scale_numeric <- rev(brewer.pal(n = 5, name = "Spectral")) }
    if(missing(colour_scale_factor)) { colour_scale_factor <- brewer.pal(n = 6, name = "Set1") }
    if(missing(xsd)) { xsd <- "http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd" }
    fw <- paths()
    if(missing(convert)) { convert <- fw$convert[[1]] }
    if(missing(gdalwarp)) { gdalwarp <- fw$gdalwarp[[1]] }
    if(missing(gdal_translate)) { gdal_translate <- fw$gdal_translate[[1]] }
    if(missing(googleAPIkey)) { googleAPIkey <- "ABQIAAAAqHzabFRj8QwDECupLUR4-hT53Nvo2rq6JtI9-sNzq2yJTiKUYBRN5VP8pfrIcMaRo0pNDvBhWJUQCA" }
 
    assign("colour_scale_numeric", colour_scale_numeric, envir=plotKML.opts)
    assign("colour_scale_factor", colour_scale_factor, envir=plotKML.opts)
    assign("xsd", xsd, envir=plotKML.opts)
    assign("convert", convert, envir=plotKML.opts)
    assign("gdalwarp", gdalwarp, envir=plotKML.opts)
    assign("gdal_translate", gdal_translate, envir=plotKML.opts)
    assign("googleAPIkey", googleAPIkey, envir=plotKML.opts)
    
    .plotKML.opts <- list(colour_scale_numeric, colour_scale_factor, xsd, convert, gdalwarp, gdal_translate, googleAPIkey)
    names(.plotKML.opts) <- c("colour_scale_numeric", "colour_scale_factor", "xsd", "convert", "gdalwarp", "gdal_translate", "googleAPIkey")
    return(.plotKML.opts)
}

## Optional: put "library(plotKML); plotKML.env(...)" in your "/etc/Rprofile.site"

