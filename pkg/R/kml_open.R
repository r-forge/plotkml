# Purpose        : Open and close KML file;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Status         : tested
# Note           : These low-level functions can be nicely combined to create user-tailored KML writing functionality;

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

## Closes the current KML canvas
kml_close <- function(){
  
  # get our invisible file connection from custom evnrionment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  cat("</Document>\n", file = file.connection, append = TRUE)
  cat("</kml>\n", file = file.connection, append = TRUE)
  close(file.connection)
}