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
## This one runs slower on Win OS?

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

#
kml_legend <- function(
  x, 
  var.type = "numeric", 
  legend.file, 
  legend.pal = rev(rainbow(65))[1:48], 
  z.lim, 
  factor.labels,
  ...
  ){

  ## Factor-type variables:
  var.type <- class(xvar)
   if(var.type=="factor") {
    z.lim <- NA
    if(missing(factor.labels)){ col.no <- length(levels(as.factor(xvar)))  }
    else { col.no <- length(factor.labels) }
    if(missing(factor.labels)) {
    ### NOTE : This is a not a perfect implementation for a factor with a lot of categories!
    leg.width <- max(nchar(levels(as.factor(xvar))))*5+70  # 5 pix per character
    leg.height <- length(levels(as.factor(xvar)))*40 # 20 pix per class
    }
    else {
    leg.width <- max(nchar(factor.labels))*10+70  # 10 pix per character
    leg.height <- length(factor.labels)*40 # 20 pix per class
    }
    png(file=legend.file, width=leg.width, height=leg.height, bg="transparent", pointsize=14)
    # c(bottom, left, top, right)
    par(mar=c(.5,0,.5,1))
    plot(x=rep(1, col.no), y=1:col.no, axes=FALSE, xlab='', ylab='', pch=15, cex=4, col=legend.pal)
    if(missing(factor.labels)) {
    text(x=rep(1, col.no), y=1:col.no, labels=levels(as.factor(x)), cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
    }
    else { 
    text(x=rep(1, col.no), y=1:col.no, labels=factor.labels, cex=.8, pos=4, offset=1, col=rgb(0.99,0.99,0.99))
    }
  dev.off()
}

  ### Numeric-type variables:
  else {
  if(missing(z.lim)&class(xvar)=="numeric") { z.lim <- c(quantile(xvar, 0.025, na.rm=TRUE), quantile(xvar, 0.975, na.rm=TRUE)) }
  png(file=legend.file, width=120, height=240, bg="transparent", pointsize=14)
  par(mar=c(.5,0,.5,4))
  plot(x=0:5, y=0:5, asp=3, type="n", axes=FALSE, xlab='', ylab='')
  # get the 2-4 significant digits
  lower.lim <- z.lim[1]
  upper.lim <- z.lim[2]
  col.labels <- signif(c(lower.lim, (upper.lim-lower.lim)/2, upper.lim), 2)
  color.legend(xl=0, yb=0, xr=5, yt=5, legend=col.labels, rect.col=legend.pal, gradient="y", align="rb", cex=1.4, col=rgb(0.99,0.99,0.99))
  dev.off()
}
}
