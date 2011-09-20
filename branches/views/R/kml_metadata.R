# Purpose        : Functions for generation and export of (spatial) metadata
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Status         : working version
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/], which can be converted to "ISO 19139" XML schema;

## Color palette:
setClass(".palette", representation (type = 'character', bounds = 'vector', color = 'character', names = 'character'), validity <- function(x) {
   if(!class(x@bounds)=="numeric")
      return('vector with (upper and lower limits) required')
   if((length(x@bounds)-1)!=length(x@color)|(length(x@bounds)-1)!=length(x@names))
      return('size of bounds, color and names elements must be equal')
   if(any(nchar(x@color)>9|nchar(x@color)<7))
      return('colors in hex system required') 
})

## A new class for SpatialMetadata:
setClass("SpatialMetadata", representation(xml = "XMLInternalDocument", field.names = "character", palette = ".palette", sp = "Spatial"), validity <- function(obj) {
    require(raster)
    require(XML)
    require(sp)
    if(!xmlName(xmlRoot(obj@xml))=="metadata")
      return("xml file tagged 'metadata' required")
    if(!length(.getXMLnames(obj@xml))==length(obj@field.names))
      return("length of field names does not match the column names in xml slot")
    if(!class(obj@field.names)=="character")
      return("field names as character vector required")      
})

setGeneric("metadata", function(obj) standardGeneric("metadata"))
setGeneric("field.names", function(obj) standardGeneric("field.names"))
setGeneric(".palette", function(obj) standardGeneric(".palette"))
setMethod("metadata", signature = "SpatialMetadata", function(obj) obj@xml)
setMethod("field.names", signature = "SpatialMetadata", function(obj) paste(obj@field.names))
setMethod(".palette", signature = "SpatialMetadata", function(obj) paste(obj@.palette))

## Get formatted names of Nodes:
# TH: This is not a perfect implementation (it assumes only 5 levels!)
.getXMLnames <- function(xml, delim.sign="_", makeunique = TRUE, max.level = as.integer(5))
{   
    if(max.level > 5|max.level < 1|!is.integer(max.level)){
        stop("maximum level must integer in range 1:5")
    }
    else{
    l1 <- NULL; l2 <- NULL; l3 <- NULL; l4 <- NULL; l5 <- NULL; l6 <- NULL
    # check the size of metadata entries (assuming max five levels):
    l1 <- sapply(sapply(unlist(sapply(xmlChildren(xmlRoot(xml)), xmlChildren)), xmlChildren), names)
    # names:
    l1 <- l1[sapply(l1, function(x) !is.na(x[1]))]
    l1 <- l1[sapply(l1, function(x) x[1]=="text")]
    if(max.level >= 2){
    # values: 
    try(l2 <- sapply(sapply(unlist(sapply(unlist(sapply(xmlChildren(xmlRoot(xml)), xmlChildren)), xmlChildren)), xmlChildren), names) )
    try(l2 <- l2[sapply(l2, function(x) !is.na(x[1]))] )
    try(l2 <- l2[sapply(l2, function(x) x[1]=="text")] )
    }
    if(max.level >= 3){
    try(l3 <- sapply(sapply(unlist(sapply(unlist(sapply(unlist(sapply(xmlChildren(xmlRoot(xml)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren), names) )
    try(l3 <- l3[sapply(l3, function(x) !is.na(x[1]))] )
    try(l3 <- l3[sapply(l3, function(x) x[1]=="text")] )
    }
    if(max.level >= 4){
    try(l4 <- sapply(sapply(unlist(sapply(unlist(sapply(unlist(sapply(unlist(sapply(xmlChildren(xmlRoot(xml)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren), names) )
    try(l4 <- l4[sapply(l4, function(x) !is.na(x[1]))] )
    try(l4 <- l4[sapply(l4, function(x) x[1]=="text")] )
    }
    if(max.level == 5){
    try(l5 <- sapply(sapply(unlist(sapply(unlist(sapply(unlist(sapply(unlist(sapply(unlist(sapply(xmlChildren(xmlRoot(xml)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren)), xmlChildren), names) ) 
    try(l5 <- l5[sapply(l5, function(x) !is.na(x[1]))] ) 
    try(l5 <- l5[sapply(l5, function(x) x[1]=="text")] ) 
    }
    # merge and sort all names:
    ll <- attr(unlist(c(l1, l2, l3, l4, l5)), "names")
    ll <- ll[order(ll)]
    # generate short name by using the last four node names:
    ll <- sapply(ll, strsplit, "\\.")
    ll <- sapply(ll, paste, collapse=delim.sign, sep="")
    # make unique names:
    if(makeunique==TRUE) {  ll <- make.unique(ll) }
    else { ll <- unique(ll) }
    }
    
    return(ll)
}


## Read the Federal Geographic Data Committee metadata file (.xml) [http://www.fgdc.gov/metadata/csdgm/] and convert to a table format:

read.metadata <- function(xml.file){

    require(XML)
    ret <- xmlTreeParse(xml.file, useInternalNodes = TRUE)
    top <- xmlRoot(ret)
    metadata <- .getXMLnames(ret, makeunique = FALSE)    

    # read each field one by one:
    met <- data.frame(metadata, stringsAsFactors = FALSE)
    for(j in 1:length(metadata)){
        # check level:
        lv <- strsplit(metadata[j], "_")[[1]]
        if(length(lv)==2){
        try(met[j,"value"] <- xmlValue(top[[lv[1]]][[lv[2]]]), silent=TRUE)
        }
        if(length(lv)==3){
        try(met[j,"value"] <- xmlValue(top[[lv[1]]][[lv[2]]][[lv[3]]]), silent=TRUE)
        }
        if(length(lv)==4){
        try(met[j,"value"] <- xmlValue(top[[lv[1]]][[lv[2]]][[lv[3]]][[lv[4]]]), silent=TRUE)
        }
        if(length(lv)==5){
        try(met[j,"value"] <- xmlValue(top[[lv[1]]][[lv[2]]][[lv[3]]][[lv[4]]][[lv[5]]]), silent=TRUE)
        }  
        if(length(lv)==6){
        try(met[j,"value"] <- xmlValue(top[[lv[1]]][[lv[2]]][[lv[3]]][[lv[4]]][[lv[5]]][[lv[6]]]), silent=TRUE)
        }  
    }
    
    # pass more friendly names:
    data(mdnames)
    met <- merge(met, mdnames[,c("metadata","field.names")], by="metadata", all.y=FALSE)
    
    return(met)
}


## Generate a Layer description file that can be parsed to KML <description>
#
spMetadata <- function(
    obj,   # some space-time R object with @data slot
    ### Different objects have different structures, but let's assume sp objects;
    Target_variable = names(obj@data)[1],  # targe variable
    Attribute_Measurement_Resolution = 1, # numeric resolution
    Attribute_Units_of_Measure = "NA", # measurement units
    bounds,
    colour_scale = NULL,
    legend.names,
    Indirect_Spatial_Reference,
    xml.file = paste(deparse(substitute(obj)), ".xml", sep=""), # optional metadata file in FGDC format
    Enduser_license_URL = "http://creativecommons.org/licenses/by/3.0/"    
    )
    {
    
    require(XML)
    require(colorspace)
    require(rjson)
    require(ggplot2)
    # Metadata template:
    fgdc <- xmlTreeParse(system.file("FGDC.xml", package="plotKML"), useInternalNodes = TRUE)
    top <- xmlRoot(fgdc)
    
    # Read metadata from an external XML file (minimum required metadata):
    if(!is.na(file.info(xml.file)$size)){
        ret <- xmlTreeParse(xml.file)
    }
    else {  ## if no file exists, load the template xml file:
        warning("could not locate the metadata file")
        ret <- fgdc
    }
    
    ml <- xmlRoot(ret)
    
    # add node names for all five levels (if not available):
    if(any(!names(top) %in% names(ml))){
        mn <- paste(names(top)[which(!names(top) %in% names(ml))])
        for(i in 1:length(mn)){
            ml <- append.XMLNode(ml, xmlNode(mn[i], "")) 
        }
    }
    # add nodes other levels:
    for(l2 in names(top)){
    if(!is.null(names(top[[l2]])))
    for(l3 in names(top[[l2]])){
    if(!is.null(names(top[[l2]][[l3]])))
    for(l4 in names(top[[l2]][[l3]])){
    if(!is.null(names(top[[l2]][[l3]][[l4]])))
    for(l5 in names(top[[l2]][[l3]][[l4]])){
    
    if(any(!names(top[[l2]]) %in% names(ml[[l2]]))){
        mn <- names(top[[l2]])[which(!names(top[[l2]]) %in% names(ml[[l2]]))]
        for(i in 1:length(mn)){
            ml[[l2]] <- append.XMLNode(ml[[l2]], xmlNode(mn[i], ""))
        }
    } 

    if(any(!names(top[[l2]][[l3]]) %in% names(ml[[l2]][[l3]]))){
        mn <- names(top[[l2]][[l3]])[which(!names(top[[l2]][[l3]]) %in% names(ml[[l2]][[l3]]))]
        for(i in 1:length(mn)){
            ml[[l2]][[l3]] <- append.XMLNode(ml[[l2]][[l3]], xmlNode(mn[i], ""))
        }
    }
    
    if(any(!names(top[[l2]][[l3]][[l4]]) %in% names(ml[[l2]][[l3]][[l4]]))){
        mn <- names(top[[l2]][[l3]][[l4]])[which(!names(top[[l2]][[l3]][[l4]]) %in% names(ml[[l2]][[l3]][[l4]]))]
        for(i in 1:length(mn)){
            ml[[l2]][[l3]][[l4]] <- append.XMLNode(ml[[l2]][[l3]][[l4]], xmlNode(mn[i], ""))
        }
    }
    
    if(any(!names(top[[l2]][[l3]][[l4]][[l5]]) %in% names(ml[[l2]][[l3]][[l4]][[l5]]))){
        mn <- names(top[[l2]][[l3]][[l4]][[l5]])[which(!names(top[[l2]][[l3]][[l4]][[l5]]) %in% names(ml[[l2]][[l3]][[l4]][[l5]]))]
        for(i in 1:length(mn)){
            ml[[l2]][[l3]][[l4]][[l5]] <- append.XMLNode(ml[[l2]][[l3]][[l4]][[l5]], xmlNode(mn[i], ""))
        }
    }
    }}}}
  
        
    # Automatically generate metadata:
    
    xmlValue(ml[["idinfo"]][["citation"]][["citeinfo"]][["title"]]) <- deparse(substitute(obj)) 
    xmlValue(ml[["distinfo"]][["stdorder"]][["digform"]][["digtinfo"]][["formcont"]]) <- class(obj)[1]
    xmlValue(ml[["eainfo"]][["overview"]][["eadetcit"]]) <- paste("http://cran.r-project.org/web/packages/", attr(class(obj), "package"), "/", sep="")
    
    xmlValue(ml[["eainfo"]][["detailed"]][["enttyp"]][["enttypl"]]) <- class(obj@data[,Target_variable])
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["rdommin"]]) <- range(obj@data[,Target_variable], na.rm=TRUE)[1] 
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["rdommax"]]) <- range(obj@data[,Target_variable], na.rm=TRUE)[2]
    xmlValue(ml[["metainfo"]][["metd"]]) <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ")    
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdef"]]) <- Target_variable
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["attrmres"]]) <- Attribute_Measurement_Resolution
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["attrunit"]]) <- Attribute_Units_of_Measure
    xmlValue(ml[["distinfo"]][["stdorder"]][["digform"]][["digtinfo"]][["transize"]] <-  paste(object.size(obj@data[,Target_variable]), "bytes (uncompressed)")
    
    # estimate the bounding box:
    check <- check_projection(obj, logical = TRUE)
      # Trying to reproject data if the check was not successful
      if (!check) {
      obj.ll <- reproject(obj)
      } 
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["westbc"]]) <- min(coordinates(obj.ll)[,1])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["eastbc"]]) <- max(coordinates(obj.ll)[,1])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["northbc"]]) <- max(coordinates(obj.ll)[,2])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["southbc"]]) <- min(coordinates(obj.ll)[,2])  
      if (!check) {
    xmlValue(ml[["spref"]][["horizsys"]][["geograph"]][["geogunit"]]) <- "Decimal degrees" 
    } else {
    xmlValue(ml[["spref"]][["horizsys"]][["geograph"]][["geogunit"]]) <- "meters" 
    }    
    
    if(missing(Indirect_Spatial_Reference)){
    googleurl <- url(paste("http://maps.googleapis.com/maps/api/geocode/json?latlng=",  mean(obj.ll@bbox[,1]), ",", mean(obj.ll@bbox[,2]), "&sensor=false", sep=""))
    Indirect_Spatial_Reference <- fromJSON(file=googleurl)[["results"]][[1]][["formatted_address"]]
    }
        
    xmlValue(ml[["spdoinfo"]][["indspref"]]) <- Indirect_Spatial_Reference
    xmlValue(ml[["idinfo"]][["native"]]) <- paste("Produced using", R.version$version.string, "running on", Sys.info()[["sysname"]], Sys.info()[["release"]])
    xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntorg"]]) <- paste(Sys.getenv(c("USERNAME"))[[1]], "at", Sys.getenv(c("COMPUTERNAME"))[[1]])
    xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntper"]]) <- Sys.getenv(c("USERDNSDOMAIN"))[[1]] 

    #load friendly metadata names:
    data(mdnames)
    metadata <- .getXMLnames(ml, makeunique = FALSE)     
    field.names <- merge(metadata, mdnames[,c("metadata","field.names")], by="metadata", all.y=FALSE)[,"field.names"]
    
    # color palette:
    if(missing(bounds)){
    if(is.numeric(obj@data[,Target_variable])){
        bounds <- seq(range(obj@data[,Target_variable], na.rm=TRUE)[1], range(obj@data[,Target_variable], na.rm=TRUE)[2], Attribute_Measurement_Resolution)  ## half the numeric resolution!
        if(missing(legend.names)) { legend.names <- as.character((bounds[-1]+bounds[-length(bounds)])/2) }
    } 
    else { 
    if(is.factor(obj@data[,Target_variable])) {
        bounds <- c(0, seq_along(levels(obj@data[,Target_variable])))
        if(missing(legend.names)) { legend.names <- as.character(levels(obj@data[,Target_variable])) }
    }   
    } }
    
    # generate a palette:
    pal <- colorRamp(colour_scale, space = "rgb", interpolate = "linear")
    data <- ggplot2::rescale(bounds, clip=TRUE)
    color <- rgb(pal(data)/255)
    cols <- new(".palette", type=class(obj@data[,Target_variable]), bounds=bounds, color = color, names = legend.names)
    
    # make a spMetadata object:
    spmd <- new("SpatialMetadata",  xml=xml, field.names=field.names, .palette=pal, sp=as(obj, "Spatial"))
    return(spmd)
}


# Write metadata to a KML/HTML file:
#                               
kml_metadata <- function(
    obj,  # SpatialMetadata
    style = "html",
    sel,
    file.connection,
    fix.enc = TRUE,
    cwidth = 150,
    twidth = 500
    )
    {
    
    ## Assuming html style:
    if(style=="html"){
    
    ## TH: Temporary solution
    if(missing(file.connection)) {  
    file <- paste(deparse(substitute(x)), ".html", sep="")
    assign('file.out', file(file, 'w', blocking=TRUE))
    file.connection <- get('file.out')
    }    
    
    ## selected columns:
    if(missing(sel)) { 
      data(mdnames)
      sel <- mdnames[,]
    }
         
    # write to html:
    cat('<table width="', twidth, '" border="0" cellspacing="5" cellpadding="10">', sep="", file = file.connection, append = TRUE)
    cat('\t<caption>', file = file.connection, append = TRUE)
    cat('\t\tLayer description:', file = file.connection, append = TRUE)
    cat('\t</caption>', file = file.connection, append = TRUE)
    
    mx <- field.names(obj)[field.names(obj) %in% sel]
    xml <- ??
    # add proj4string column:
    mx <- c(mx[1:12], "proj4string", mx[13:length(mx)])
    xml <- c(xml[1:12], proj4string(x@sp), xml[13:length(xml)])
    
    for(i_md in 1:length(xml)) {
        cat('\t<tr>', file = file.connection, append = TRUE)
        cat('\t\t<th width="', cwidth, '" scope="col"><div align="left">', mx[i_md], '</div></th>', sep="", file = file.connection, append = TRUE)
        cat('\t\t<th scope="col"><div align="left">', xml[i_md], '</div></th>', sep="", file = file.connection, append = TRUE)
        cat('\t</tr>', file = file.connection, append = TRUE)
    }
    cat('</table>', file = file.connection, append = TRUE)
    
    }
    # else     
    
    if(missing(file.connection)) {
    close(file.connection)
    }
} 


    

## Write the metadata dataframe to Geonetwork MEF format as specified at [http://geonetwork-opensource.org/manuals/2.6.3/developer/mef/]
#
# metadata2MEF <- function(
#    xml,  # metadata slot

#    )
#    {
    
# }    


## Generate a SLD file (using the default legend):