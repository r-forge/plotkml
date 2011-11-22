# Purpose        : Export of (spatial) metadata
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Dev Status     : Pre-Alpha
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/], which can be converted to "ISO 19139" XML schema;


## Generate a SLD file (using the default legend):
# [http://docs.geoserver.org/stable/en/user/styling/sld-introduction.html]
metadata2SLD <- function(
    spMd,  # SpatialMetadata
    obj.name = deparse(substitute(spMd)),
    sld.file = set.file.extension(obj.name, ".sld"),
    Citation_title = xmlValue(spMd@xml[["//title"]]),
    Format_Information_Content = xmlValue(spMd@xml[["//formcont"]]),
    ColorMap_type = "intervals",
    opacity = 1
    ){
    
#    if(Format_Information_Content == "SpatialPixelsDataFrame"){
    l1 = newXMLNode("StyledLayerDescriptor", attrs=c(version="1.0.0"), namespaceDefinitions=c("xsi:schemaLocation"="http://www.opengis.net/sld StyledLayerDescriptor.xsd", "sld"="http://www.opengis.net/sld", "ogc"="http://www.opengis.net/ogc", "gml"="http://www.opengis.net/gml"))
    l2 <- newXMLNode("NamedLayer", parent = l1)
    l3 <- newXMLNode("Name", paste(Citation_title, "(", Format_Information_Content, ")"), parent = l2)
    l3b <- newXMLNode("UserStyle", parent = l2)
    l4 <- newXMLNode("Title", paste(obj.name, "style", sep="_"), parent = l3b)
    l4b <- newXMLNode("FeatureTypeStyle", parent = l3b)
    l5 <- newXMLNode("Rule", parent = l4b)
    l6 <- newXMLNode("RasterSymbolizer", parent = l5)
    l7 <- newXMLNode("ColorMap", attrs=c(type=ColorMap_type), parent = l6)
    txt <- sprintf('<ColorMapEntry color="#%s" quantity="%.2f" label="%s" opacity="%.1f"/>', spMd@palette@color, spMd@palette@bounds[-1], spMd@palette@names, rep(opacity, length(spMd@palette@color)))
    parseXMLAndAdd(txt, l7)
    saveXML(l1, sld.file)
#    }
}


## Write the metadata dataframe to Geonetwork MEF format as specified at [http://geonetwork-opensource.org/manuals/2.6.3/developer/mef/]
#
# metadata2MEF <- function(
#    xml,  # metadata slot

#    )
#    {
    
# }    

# connect all methods and classes:
setMethod("metadata2SLD", signature="SpatialMetadata", definition=metadata2SLD)

# end of script;