# Purpose        : Find paths to external packages;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl)
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz)
# Status         : tested and ready for CRAN
# Note           : This function helps establishing a link with external packages;
 

paths <- function(gdalwarp = "", gdal_translate = "", convert = "", saga_cmd = "", python = "", show.paths = TRUE){ 
     
     if(require(animation))
        convert <- ani.options("convert")
     
     if(require(RSAGA)) {
        saga_cmd <- shortPathName(normalizePath(paste(rsaga.env()$path, rsaga.env()$cmd, sep="/")))
        saga.version <- rsaga.get.version()
     }
     else
       saga_cmd <- NULL
    
    im.dir <- NULL
    if(is.null(convert)){
        if(.Platform$OS.type == "windows") {
        # get paths and check for ImageMagick
        paths <- strsplit(Sys.getenv('PATH')[[1]], ";")[[1]]
        x <- grep(paths, pattern="Magick")
        
        # if present
        if(!length(x) == 0) {
        im.dir <- paths[grep(paths, pattern="ImageMagick")[1]]
        convert = shQuote(normalizePath(file.path(im.dir, "convert.exe")))
        message(system(convert,  show.output.on.console = FALSE, intern = TRUE)[1])
        }
        } # end checking for Imagemagick on Windows
        
        # check for all other OS:
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



# end of script;

