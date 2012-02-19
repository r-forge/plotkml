# Purpose        : Open and close KML file;
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Tomislav Hengl (tom.hengl@wur.nl); 
# Status         : tested
# Note           : See [http://code.google.com/apis/kml/documentation/kmlreference.html] for more info.

kml_open <- function(
  file.name,
  folder.name = file.name,
  kml_open = TRUE,
  kml_visibility = TRUE,
  overwrite = TRUE,
  use.Google_gx = FALSE,
  kml_xsd = get("kml_xsd", envir = plotKML.opts),
  xmlns = get("kml_url", envir = plotKML.opts),
  xmlns_gx = get("kml_gx", envir = plotKML.opts),
  ...
  ){

  if (file.exists(file.name) & overwrite==FALSE) {
    stop(paste("File", file.name, "already exists. Set the overwrite option to TRUE or choose a different name."))
  }

  # header
  if(use.Google_gx){
    kml.out <- newXMLNode("kml", attrs=c(version="1.0"), namespaceDefinitions = c("xsd"=kml_xsd, "xmlns"=xmlns, "xmlns:gx"=xmlns_gx))
  }
  else {
    kml.out <- newXMLNode("kml", attrs=c(version="1.0"), namespaceDefinitions = c("xsd"=kml_xsd, "xmlns"=xmlns))
  }
  
  h2 <- newXMLNode("Document", parent = kml.out)
  h3 <- newXMLNode("name", folder.name, parent = h2)
  if(kml_visibility==FALSE){
    h4 <- newXMLNode("visibility", as.numeric(kml_visibility), parent = h2)
  }
  h5 <- newXMLNode("open", as.numeric(kml_open), parent = h2)
  
  # init connection to an XML object: 
  assign("kml.out", kml.out, env=plotKML.fileIO)
  message("KML file header opened for parsing...")
  
}

## Closes the current KML canvas
kml_close <- function(file.name, overwrite = FALSE, ...){
  
  require(RSAGA) 
  # get our invisible file connection from custom evnrionment
  kml.out <- get("kml.out", env=plotKML.fileIO)
  saveXML(kml.out, file.name)
  message(paste("Closing", set.file.extension(file.name, ".kml")))
  
}

# end of script;