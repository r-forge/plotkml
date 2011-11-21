# Purpose        : Compresses KML file using the system zip program;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Status         : tested
# Note           : You can specify location of the zip program manually using the zip = ... option.;

kml_compress <- function(file.name, zip = "", imagefile = "", rm = FALSE){

  require(stringr)

  # Changing the extension to KMZ
  extension <- str_extract(file.name, pattern="*\\..*$")
  kmz <- str_replace(file.name, extension, ".kmz") # switch the extension to kmz

  # If no zip command is specified we use the generic one
  if (zip == "") {
      zip <- Sys.getenv("R_ZIPCMD", "zip")
  }

  # Build the command
  cmd <- paste(zip, kmz, file.name, imagefile, collapse = " ")
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
      x <- file.remove(file.name, imagefile)
    }
  }

}