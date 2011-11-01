# Purpose        : Functions for generation of (spatial) metadata
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Dev Status     : Pre-Alpha
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/], which can be converted to "ISO 19139" XML schema;


## Read metadata from a xml.file
read.metadata <- function(xml.file, delim.sign = "_", full.names = mdnames){

    ret <- xmlTreeParse(xml.file, useInternalNodes = TRUE)
    top <- xmlRoot(ret)
    nx <- unlist(xmlToList(top, addAttributes=FALSE))
    # convert to a table:
    met <- data.frame(metadata=gsub("\\.", delim.sign, names(nx)), value=paste(nx))
    # add more friendly names:
    metm <- merge(met, full.names[,c("metadata","field.names")], by="metadata", all.x=TRUE)
    
    return(metm[,c(1,3,2)])
}


## Generate a spMetadata class object:
spMetadata.Spatial <- function(
    obj,   # some space-time R object with @data slot
    Citation_title,
    Target_variable = names(obj@data)[1],  # targe variable
    Attribute_Measurement_Resolution = 1, # numeric resolution
    Attribute_Units_of_Measure = "NA", # measurement units
    signif.digit = 3,
    bounds,
    colour_scale = NULL,
    legend_names,
    Indirect_Spatial_Reference = "",
    xml.file = paste(deparse(substitute(obj)), ".xml", sep=""), # optional metadata file in the FGDC format
    Enduser_license_URL = get("license_url", envir = plotKML.opts)    
    )
    {
    
    # Metadata template:
    fgdc <- xmlTreeParse(system.file("FGDC.xml", package="plotKML"), useInternalNodes = TRUE)
    top <- xmlRoot(fgdc)
    nx <- names(unlist(xmlToList(top, addAttributes=FALSE)))
    
    # If the metadata file does not exit, use the template:
    if(!is.na(file.info(xml.file)$size)){
        ret <- xmlTreeParse(xml.file)
    }
    else {  
        warning(paste("Could not locate", xml.file, ". Using the FGDC.xml template to prepare metadata. See 'spMetadata' for more details."))
        ret <- fgdc
    }
    
    ml <- xmlRoot(ret)  
    
    # compare the actual xml file and the template:
    cross <- compareXMLDocs(a=xmlTreeParse(xml.file, useInternalNodes = TRUE), b=fgdc)
            
    # add missing nodes:
    for(i in 1:length(cross[["inB"]])){
        # position of the missing node in the target doc:
        nodn <- attr(cross[["inB"]], "dimnames")[[1]][i]
        x_l <- strsplit(nx[grep(nodn, nx)], "\\.")[[1]]
        for(j in 1:length(x_l)){
          if(j==1 & !x_l[j] %in% names(ml)) { ml <- append.XMLNode(ml, xmlNode(x_l[j], "")) }
          if(j==2 & !x_l[j] %in% names(ml[[x_l[1]]])) { ml[[x_l[1]]] <- append.XMLNode(ml[[x_l[1]]], xmlNode(x_l[j], "")) }
          if(j==3 & !x_l[j] %in% names(ml[[x_l[1]]][[x_l[2]]])) { ml[[x_l[1]]][[x_l[2]]] <- append.XMLNode(ml[[x_l[1]]][[x_l[2]]], xmlNode(x_l[j], "")) }
          if(j==4 & !x_l[j] %in% names(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]])) { ml[[x_l[1]]][[x_l[2]]][[x_l[3]]] <- append.XMLNode(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]], xmlNode(x_l[j], "")) }    
          if(j==5 & !x_l[j] %in% names(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]])) { ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]] <- append.XMLNode(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]], xmlNode(x_l[j], "")) } 
          if(j==6 & !x_l[j] %in% names(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]])) { ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]] <- append.XMLNode(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]], xmlNode(x_l[j], "")) }
          if(j==7 & !x_l[j] %in% names(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]][[x_l[6]]])) { ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]][[x_l[6]]] <- append.XMLNode(ml[[x_l[1]]][[x_l[2]]][[x_l[3]]][[x_l[4]]][[x_l[5]]][[x_l[6]]], xmlNode(x_l[j], "")) }
        }
    }
            
    # Automatically generate metadata:
    
    if(xmlValue(ml[["idinfo"]][["citation"]][["citeinfo"]][["title"]]) == "") {
    if(missing(Citation_title)) {
      xmlValue(ml[["idinfo"]][["citation"]][["citeinfo"]][["title"]]) <- deparse(substitute(obj))
      }
      else { 
      xmlValue(ml[["idinfo"]][["citation"]][["citeinfo"]][["title"]]) <- Citation_title
      }
    } 
    xmlValue(ml[["distinfo"]][["stdorder"]][["digform"]][["digtinfo"]][["formcont"]]) <- class(obj)[1]
    xmlValue(ml[["eainfo"]][["overview"]][["eadetcit"]]) <- paste("http://CRAN.R-project.org/package=", attr(class(obj), "package"), "/", sep="")
    
    xmlValue(ml[["eainfo"]][["detailed"]][["enttyp"]][["enttypl"]]) <- class(obj@data[,Target_variable])
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["rdommin"]]) <- range(obj@data[,Target_variable], na.rm=TRUE)[1] 
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["rdommax"]]) <- range(obj@data[,Target_variable], na.rm=TRUE)[2]  
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdef"]]) <- Target_variable
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["attrmres"]]) <- Attribute_Measurement_Resolution
    xmlValue(ml[["eainfo"]][["detailed"]][["attr"]][["attrdomv"]][["rdom"]][["attrunit"]]) <- Attribute_Units_of_Measure
    xmlValue(ml[["distinfo"]][["stdorder"]][["digform"]][["digtinfo"]][["transize"]]) <-  paste(signif(object.size(obj@data[, Target_variable])/1024, 4), "Kb (uncompressed)")
    if(xmlValue(ml[["metainfo"]][["metd"]]) == "") {
    xmlValue(ml[["metainfo"]][["metd"]]) <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ")
    }
    
    # estimate the bounding box:
    obj.ll <- reproject(obj)
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["westbc"]]) <- min(coordinates(obj.ll)[,1])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["eastbc"]]) <- max(coordinates(obj.ll)[,1])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["northbc"]]) <- max(coordinates(obj.ll)[,2])
    xmlValue(ml[["idinfo"]][["spdom"]][["bounding"]][["southbc"]]) <- min(coordinates(obj.ll)[,2])  
    xmlValue(ml[["spref"]][["horizsys"]][["geograph"]][["geogunit"]]) <- "Decimal degrees"
    
    if(Indirect_Spatial_Reference == ""){
    googleurl <- url(paste("http://maps.googleapis.com/maps/api/geocode/json?latlng=",  mean(obj.ll@bbox[,1]), ",", mean(obj.ll@bbox[,2]), "&sensor=false", sep=""))
    try(Indirect_Spatial_Reference <- fromJSON(file=googleurl)[["results"]][[1]][["formatted_address"]])
    }
        
    xmlValue(ml[["spdoinfo"]][["indspref"]]) <- Indirect_Spatial_Reference
    xmlValue(ml[["idinfo"]][["native"]]) <- paste(R.version$version.string, "running on", Sys.info()[["sysname"]], Sys.info()[["release"]])
    if(xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntorg"]]) == ""){
    xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntorg"]]) <- Sys.getenv(c("USERDNSDOMAIN"))[[1]]  
    }
    if(xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntper"]]) == ""){
    xmlValue(ml[["metainfo"]][["metc"]][["cntinfo"]][["cntperp"]][["cntper"]]) <- paste(Sys.getenv(c("USERNAME"))[[1]], "(username)", Sys.getenv(c("COMPUTERNAME"))[[1]], "(computer name)")
    }

    # attach friendly metadata names:
    ny <- unlist(xmlToList(ml, addAttributes=FALSE))
    # convert to a table:
    met <- data.frame(metadata=gsub("\\.", "_", names(ny)), value=paste(ny))
    field_names <- merge(met, mdnames[,c("metadata","field.names")], by="metadata", all.x=TRUE)[,"field.names"]
    
    # color palette:
    if(missing(bounds)){
    if(is.numeric(obj@data[,Target_variable])){
        bounds <- seq(range(obj@data[,Target_variable], na.rm=TRUE)[1], range(obj@data[,Target_variable], na.rm=TRUE)[2], Attribute_Measurement_Resolution/2)  ## half the numeric resolution!
        bounds.c <- signif((bounds[-1]+bounds[-length(bounds)])/2, signif.digit)
        if(missing(legend_names)) { legend_names <- as.character(bounds.c) }
    } 
    else { 
    if(is.factor(obj@data[,Target_variable])) {
        bounds <- c(0, seq_along(levels(obj@data[,Target_variable])))
        if(missing(legend_names)) { legend_names <- as.character(levels(obj@data[,Target_variable])) }
    }   
    } }
    
    # generate a palette:
    cols <- colorRamp(colour_scale, space = "rgb", interpolate = "linear")
    cdata <- ggplot2::rescale(bounds.c, clip=TRUE)
    color <- rgb(cols(cdata)/255)
    pal <- new("sp.palette", type=class(obj@data[,Target_variable]), bounds=bounds, color = color, names = legend_names)
    
    # make a spMetadata object:
    spmd <- new("SpatialMetadata",  xml=xml, field.names=field_names, palette=pal, sp=as(obj, "Spatial"))
    return(spmd)
}

setMethod("spMetadata", "Spatial", spMetadata.Spatial)

# end of script;