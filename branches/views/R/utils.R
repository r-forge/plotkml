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

  if (file.exists(file) & !overwrite)
    stop(paste("File", file, "exists. Set the overwrite option to TRUE if you want to overwrite that file, or choose a different name for it."))

  file.create(file)

  # header
  cat("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", file = file)
  cat('<kml xmlns=\"', kml.url, '\">\n', sep = "", file = file, append = TRUE)
  cat("<Document>\n", file= file, append = TRUE)
  cat("<name>", name, "</name>\n", sep = "", file = file, append = TRUE)
  cat("<open>1</open>\n", file = file, append = TRUE)
}

#' Closes the current KML canvas
#'
#' @param file KML file name to be closed
kml_close <- function(
  file
  ){
  cat("</Document>\n", file = file, append = TRUE)
  cat("</kml>\n", file = file, append = TRUE)
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
  kmz <- file
  kmz <- str_replace(file, ".kml", ".kmz") # switch the extension to kmz

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

# Returns a vector of names for each element (pt, line, polygon)
# to be written in a KML folder
kml_names <- function(obj, ...){
  # Introduce a names= option/aes?
  # Try to find existing rownames

  # Otherwise select aes that came first in the fun call

  # and use its values as rownames.

  # Temporary solution - more fancy stuff could be done of course
  if ("data" %in% slotNames(obj))
    nm <- rownames(obj@data)
  else
    nm <- as.character(1:nrow(coordinates(obj)))
  nm
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
