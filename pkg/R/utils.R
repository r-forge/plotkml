# R function for the plotKML package
# Author: Pierre Roudier, Tomislav Hengl
# contact: pierre.roudier@gmail.com & tom.hengl@wur.nl
# Date : July 2011
# Version 0.1
# Licence GPL v3

#' Open a new KML canvas
#'
#' @param file KML file name
#' @param name KML name
#' @param kml.url KML specification URL
kml_open <- function(
  file,
  filename,
  name = strsplit(file, ".")[1],
  overwrite = TRUE,
  kml.url = "http://www.opengis.net/kml/2.2",
  ...
  ){

  if (file.exists(file) & !overwrite) {
    stop(paste("File", file, "exists. Set the overwrite option to TRUE if you want to overwrite that file, or choose a different name for it."))
}

#  file.create(file)
## The fastest way to write to a KML is to first connect to a file, then close it on the end.

  # header
  cat("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", file = filename)
  cat('<kml xmlns=\"', kml.url, '\">\n', sep = "", file = filename, append = TRUE)
  cat("<Document>\n", file = filename, append = TRUE)
  cat("<name>", name, "</name>\n", sep = "", file = filename, append = TRUE)
  cat("<open>1</open>\n", file = filename, append = TRUE)
}

#' Closes the current KML canvas
#'
#' @param file KML file name to be closed
kml_close <- function(
  file,
  filename
  ){
  cat("</Document>\n", file = filename, append = TRUE)
  cat("</kml>\n", file = filename, append = TRUE)
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


