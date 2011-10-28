# Purpose        : Environmental variables for plotKML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl)
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz)
# Status         : tested and ready for CRAN
# Note           : This function helps establishing a link with external packages and settings
 

paths <- function(gdalwarp = "", gdal_translate = "", convert = "", saga_cmd = "", python = "", show.paths = TRUE){ 
  
     require(RSAGA)
     require(animation)
     convert <- ani.options("convert")
     saga_cmd <- shortPathName(normalizePath(paste(rsaga.env()$path, rsaga.env()$cmd, sep="/")))
     saga.version <- rsaga.get.version()
     
    if(is.null(convert)){
        if(.Platform$OS.type == "windows") {
        if(!length(x <- grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ";")[[1]], pattern="Magick"))==0) {
        im.dir <- paths[grep(paths, pattern="ImageMagick")[1]]
        convert = shQuote(normalizePath(file.path(im.dir, "convert.exe")))
        message(system(convert,  show.output.on.console = FALSE, intern = TRUE)[1])
        # message(paste("Located ImageMagick from the path: \"", im.dir, "\"", sep=""))
        }}
        else{
        if(!length(x <- grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="Magick"))==0) {
        im.dir <- paths[grep(paths, pattern="Magick")[1]]
        convert = "convert"
        message(system(convert,  show.output.on.console = FALSE, intern = TRUE)[1])
        # message(paste("Located ImageMagick from the path: \"", im.dir, "\"", sep=""))
    }}
        if(is.null(im.dir)){ 
        warning("Install ImageMagick and add to PATH. See http://imagemagick.org for more info.")
        }
    }
    else { 
    message(system(convert,  show.output.on.console = FALSE, intern = TRUE)[1])
      }  
  
  if(.Platform$OS.type == "windows") {

     reg.paths <- names(utils::readRegistry("SOFTWARE"))
     # 64-bit software directory:
     x <- grep(reg.paths, pattern="WOW6432Node", ignore.case = TRUE)
     
     if(length(x)>0 & !inherits(try({ fw.path = utils::readRegistry(paste("SOFTWARE", reg.paths[x], "FWTools", sep="\\"))$Install_Dir }, silent = TRUE), "try-error")) {      
       if (nzchar(fw.path))  { 
      gdalwarp = shQuote(shortPathName(normalizePath(file.path(fw.path, "bin/gdalwarp.exe"))))
      gdal_translate = shQuote(shortPathName(normalizePath(file.path(fw.path, "bin/gdal_translate.exe"))))
      message(paste("Located FWTools from the Registry Hive: \"", shortPathName(fw.path), "\"", sep="")) 
              } } 

      else { if(nzchar(prog <- Sys.getenv("ProgramFiles")) &&
          length(fw.dir <- list.files(prog, "^FWTools.*")) &&
          length(fw.path <- list.files(file.path(prog, fw.dir), pattern = "^gdalwarp\\.exe$", full.names = TRUE, recursive = TRUE))  |
          length(fw.path2 <- list.files(file.path(prog, fw.dir), pattern = "^gdal_translate\\.exe$", full.names = TRUE, recursive = TRUE)) )
       {
      gdalwarp = shQuote(shortPathName(normalizePath(fw.path[1])))
      gdal_translate = shQuote(shortPathName(normalizePath(fw.path2[1])))
      message(paste("Located FWTools from the 'Program Files' directory: \"", shortPathName(fw.path), "\"", sep=""))
     } 
     else if(nzchar(prog <- Sys.getenv("ProgramFiles(x86)")) &&
          length(fw.dir <- list.files(prog, "^FWTools.*")) &&
          length(fw.path <- list.files(file.path(prog, fw.dir), pattern = "^gdalwarp\\.exe$", full.names = TRUE, recursive = TRUE))  &&
          length(fw.path2 <- list.files(file.path(prog, fw.dir), pattern = "^gdal_translate\\.exe$", full.names = TRUE, recursive = TRUE))   )
       {
      gdalwarp = shQuote(shortPathName(normalizePath(fw.path[1])))
      gdal_translate = shQuote(shortPathName(normalizePath(fw.path2[1])))
      message(paste("Located FWTools from the 'Program Files' directory: \"", shortPathName(fw.path), "\"", sep=""))
     } 
     
     else {
      warning("Could not locate FWTools! Install program and add it to the Windows registry. See http://fwtools.maptools.org for more info.")
      return()
       } }
      
      if(length(x)>0 & !inherits(try({ 
      py.paths <- utils::readRegistry(paste("SOFTWARE", reg.paths[x], "Python", sep="\\"), maxdepth=3)
      py.path = utils::readRegistry(paste("SOFTWARE", reg.paths[x], "Python", names(py.paths), names(py.paths[[1]]), "InstallPath", sep="\\"))[[1]] 
      }, silent = TRUE), "try-error")) {
      if (nzchar(py.path))  { 
      python = shQuote(shortPathName(normalizePath(file.path(py.path, "python.exe"))))
      message(paste("Located Python from the Registry Hive: \"", shortPathName(py.path), "\"", sep="")) 
      } 
      }
      else { 
      if(!inherits(try({ 
      py.paths <- utils::readRegistry(paste("SOFTWARE", "Python", sep="\\"), maxdepth=3)
      py.path = utils::readRegistry(paste("SOFTWARE", "Python", names(py.paths), names(py.paths[[1]]), "InstallPath", sep="\\"))[[1]] 
      }, silent = TRUE), "try-error")) {
      if (nzchar(py.path))  { 
      python = shQuote(shortPathName(normalizePath(file.path(py.path, "python.exe"))))
      message(paste("Located Python from the Registry Hive: \"", shortPathName(py.path), "\"", sep="")) 
      }
      } 
           
      else {
      warning("Could not locate Python! Install program and add it to the Windows registry. See http://python.org for more info.")
      return()
      }}
       
              
      if(is.null(saga_cmd)){
      if(nzchar(prog <- Sys.getenv("ProgramFiles")) &&
          length(saga.dir <- list.files(prog, "^SAGA*"))>0 &&
          length(saga_cmd <- list.files(file.path(prog, saga.dir), pattern = "^saga_cmd\\.exe$", full.names = TRUE, recursive = TRUE))>0  
          )
       {
      myenv <- rsaga.env(path=shQuote(normalizePath(saga.dir[1])))
      saga_cmd <- shortPathName(normalizePath(paste(myenv$path, myenv$cmd, sep="/")))
      saga.version <- myenv$version 
      message(paste("Located SAGA GIS ", saga.version, " from the 'Program Files' directory: \"", shortPathName(saga_cmd), "\"", sep=""))
     }
     else if (nzchar(prog <- Sys.getenv("ProgramFiles(x86)")) &&
          length(saga.dir <- list.files(prog, "^SAGA*"))>0 &&
          length(saga_cmd <- list.files(file.path(prog, saga.dir), pattern = "^saga_cmd\\.exe$", full.names = TRUE, recursive = TRUE))>0   
          )
       {
      myenv <- rsaga.env(path=shQuote(normalizePath(saga.dir[1])))
      saga_cmd <- shortPathName(normalizePath(paste(myenv$path, myenv$cmd, sep="/")))
      saga.version <- myenv$version 
      message(paste("Located SAGA GIS ", saga.version, " from the 'Program Files' directory: \"", shortPathName(saga_cmd), "\"", sep=""))
     }
      
      if(is.null(saga_cmd)){
      warning("Could not locate SAGA GIS! Install program and add it to the Windows registry. See http://www.saga-gis.org/en/ for more info.") 
      return()
      }   
     }
     else {
       message(paste("Located SAGA GIS ", saga.version, " from the 'Program Files' directory: \"", shortPathName(saga_cmd), "\"", sep=""))  }
     }
    
    ## UNIX:
    else {
    
    if(!length(x <- grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="FWTools"))==0) {
    fw.dir <- paths[grep(paths, pattern="FWTools")[1]]
    gdalwarp = "gdalwarp"
    gdal_translate = "gdal_translate"
    message(paste("Located FWTools from the path: \"", shortPathName(fw.dir), "\"", sep=""))
      }
    else { 
        warning("Install FWTools and add to PATH. See http://fwtools.maptools.org for more info.")
        return()
      }
    
    if(!length(x <- grep(paths <- strsplit(Sys.getenv('PATH')[[1]], ":")[[1]], pattern="Python"))==0) {
    py.dir <- paths[grep(paths, pattern="Python")[1]]
    python = "python"
    message(paste("Located Python from the path: \"", shortPathName(py.dir), "\"", sep=""))
      }
    else { 
        warning("Install Python and add to PATH. See http://python.org for more info.")
        return()
      }
    
    if(is.null(im.dir)){ 
        warning("Install ImageMagick and add to PATH. See http://imagemagick.org for more info.")
        return()
        }
    if(is.null(saga_cmd)){
        warning("Install SAGA GIS and add to PATH. See http://www.saga-gis.org for more info.")
        return()
        }
    }

    lt <- data.frame(gdalwarp, gdal_translate, convert, python, saga_cmd, stringsAsFactors = FALSE)
    if(show.paths){  return(lt)  }
}


## Standard settings:
plotKML.env <- function(
    colour_scale_numeric,
    colour_scale_factor,
    ref_CRS,
    NAflag,
    kml_xsd,
    gpx_xsd,
    convert,
    gdalwarp,
    gdal_translate,
    python,
    home_url,
    googleAPIkey,
    show.env = TRUE,
    silent = TRUE
    ){
    
    require(RColorBrewer)
    
    plotKML.opts <<- new.env(hash=TRUE)
    
    if(missing(colour_scale_numeric)) { colour_scale_numeric <- rev(brewer.pal(n = 5, name = "Spectral")) }
    if(missing(colour_scale_factor)) { colour_scale_factor <- brewer.pal(n = 6, name = "Set1") }
    if(missing(ref_CRS)) { ref_CRS <- "+proj=longlat +datum=WGS84" }
    if(missing(NAflag)) { NAflag <- -99999 }
    if(missing(kml_xsd)) { kml_xsd <- "http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd" }
    if(missing(gpx_xsd)) { gpx_xsd <- "http://www.topografix.com/GPX/1/1/gpx.xsd" }
    
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
    assign("kml_xsd", kml_xsd, envir=plotKML.opts)
    assign("gpx_xsd", gpx_xsd, envir=plotKML.opts)
    assign("convert", convert, envir=plotKML.opts)
    assign("gdalwarp", gdalwarp, envir=plotKML.opts)
    assign("gdal_translate", gdal_translate, envir=plotKML.opts)
    assign("python", python, envir=plotKML.opts)
    assign("home_url", home_url, envir=plotKML.opts)
    assign("googleAPIkey", googleAPIkey, envir=plotKML.opts)
    
    plotKML.opts <- list(colour_scale_numeric, colour_scale_factor, ref_CRS, NAflag, kml_xsd, gpx_xsd, convert, gdalwarp, gdal_translate, python, home_url, googleAPIkey)
    names(plotKML.opts) <- c("colour_scale_numeric", "colour_scale_factor", "ref_CRS", "NAflag", "kml_xsd", "gpx_xsd", "convert", "gdalwarp", "gdal_translate", "python", "home_url", "googleAPIkey")
    
    if(show.env){  return(plotKML.opts)  }  
}


# end of script;