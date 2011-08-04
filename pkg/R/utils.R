# R functions for the plotKML package
# Author: Pierre Roudier & Tomislav Hengl
# contact: pierre.roudier@landcareresearch.co.nz.nz; tom.hengl@wur.nl

#' Open a new KML canvas
#'
#' @param file KML file name
#' @param name KML name
#' @param kml.url KML specification URL
kml_open <- function(
  file,
  name = file,
  overwrite = FALSE,
  kml.url = "http://www.opengis.net/kml/2.2"
  ){

  if (file.exists(file) & !overwrite) {
     stop(paste("File", file, "exists. Set the overwrite option to TRUE if you want to overwrite that file, or choose a different name for it."))
  }

  # init connection to file: consider using 'file.name' instead of 'file'
  assign('kml.file.out', file(file, 'w', blocking=TRUE), env=plotKML.fileIO)
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  # header
  cat("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", file = file.connection)
  cat('<kml xmlns=\"', kml.url, '\">\n', sep = "", file = file.connection, append = TRUE)
  cat("<Document>\n", file = file.connection, append = TRUE)
  cat("<name>", name, "</name>\n", sep = "", file = file.connection, append = TRUE)
  cat("<open>1</open>\n", file = file.connection, append = TRUE)
}

#' Closes the current KML canvas
#'
#' @param file KML file name to be closed
kml_close <- function(){
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  cat("</Document>\n", file = file.connection, append = TRUE)
  cat("</kml>\n", file = file.connection, append = TRUE)
  close(file.connection)
}

#' Compresses a KML into a KMZ
#'
#' @param file KML file name to be compressed
#' @param zip If there is no zip program on your path (on windows),
#'  you can supply the full path to a zip.exe here, in order to make
#'  a KMZ file
#' @param imagefile an image file to put in the archive (for rasters)
#' @param rm Should the kml file be removed?
#'
#' @author Code adapted by Pierre Roudier from the KML() function in Robert
#'  Hijmans's package raster.
kml_compress <- function(file, zip = "", imagefile = "", rm = FALSE){

  require(stringr)

  # Changing the extension to KMZ
  extension <- str_extract(file, pattern="*\\..*$")
  kmz <- str_replace(file, extension, ".kmz") # switch the extension to kmz

  # If no zip command is specified we use the generic one
  if (zip == "") {
      zip <- Sys.getenv("R_ZIPCMD", "zip")
  }

  # Build the command
  cmd <- paste(zip, kmz, file, imagefile, collapse = " ")
  # execute the command
  execute_cmd <- try(system(cmd, intern = TRUE), silent = TRUE)

  # Error handling
  if (is(execute_cmd, "try-error")) {
    if (missing(zip))
      stop("KMZ generation failed. Your zip utility has not been found. You can specify it manually using the zip = ... option.")
    else
      stop("KMZ generation failed. Wrong command passed to zip = ... option.")
  }
  # Otherwise removing temp files
  else {
    # if file creation successful
    if (file.exists(kmz) & rm) {
      x <- file.remove(file, imagefile)
    }
  }

}

# convert R colours to KML colours
#
# KML colour follow the scheme #aabbggrr
#
col2kml <- function(colour){

  # Getting the HEX code
  res <- rgb(t(col2rgb(colour, alpha = TRUE))/255, alpha = TRUE)
  # Converting from HEX to KML
  res <- hex2kml(res)

  res
}

# Convert hex colours to KML specs
#
hex2kml <- function(hex){
  require(stringr)
  require(plyr)

  res <- aaply(hex, 1, function(hex){
    if (str_length(hex) == 9) # if alpha is present
      res <- paste("#", str_sub(tolower(hex), 8, 9), str_sub(tolower(hex), 6, 7), str_sub(tolower(hex), 4, 5), str_sub(tolower(hex), 2, 3), sep = "")
    else
      res <- paste("#ff", str_sub(tolower(hex), 6, 7), str_sub(tolower(hex), 4, 5), str_sub(tolower(hex), 2, 3), sep = "")
    res
    }
  )

  as.vector(res)
}

# KML spec is alpha-BGR
#
kml2hex <- function(kml) {
  require(stringr)
  require(plyr)

  res <- aaply(kml, 1, function(x){
    res <- paste("#", str_sub(toupper(x), 8, 9), str_sub(toupper(x), 6, 7), str_sub(toupper(x), 4, 5), str_sub(toupper(x), 2, 3), sep = "")
    res
    }
  )

  as.vector(res)
}
