# Purpose        : Automated generation of INSPIRE-compliant metadata for (spatial) datasets
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Michael Blaschek (blaschek@geographie.uni-kiel.de);
# Dev Status     : Pre-Alpha
# Note           : Based on the INSPIRE Metadata Implementing Rules [http://inspire.jrc.ec.europa.eu/documents/Metadata/MD_IR_and_ISO_20131029.pdf]

## internal methods:
#setMethod("GetNames", "SpatialMetadata", function(obj){paste(obj@field.names)})
#setMethod("GetPalette", "SpatialMetadata", function(obj){obj@palette})

# Generate a spMetadata class object:
spMetadata_inspire <- function(
  obj,   
  xml.file, # optional metadata file in iso format
  generate.missing = T,
  Target_variable,
  Citation_title,
  Abstract,
  Lineage,
  Use_Limitation,
  MD_Organisation_name,
  MD_Mail_address,
  Organisation_name,
  Mail_address,
  Responsible_Party_Role = c("resourceProvider", "custodian", "owner", "user", "distributor", 
    "originator", "pointOfContact", "principalInvestigator", "processor", "publisher", "author"),
  Language = c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", "fre", "ger", "gre", "hun",
    "gle", "ita", "lav", "lit", "mlt", "pol", "por", "rum", "slo", "slv", "spa", "swe"),
  MD_Language = c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", "fre", "ger", "gre", "hun",
    "gle", "ita", "lav", "lit", "mlt", "pol", "por", "rum", "slo", "slv", "spa", "swe"),
  Topic_Category = c("geoscientificInformation", "farming", "biota", "boundaries", "climatologyMeteorologyAtmosphere", 
    "economy", "elevation", "environment", "health", "imageryBaseMapsEarthCover", "intelligenceMilitary", 
    "inlandWaters", "location", "oceans", "planningCadastre", "society", "structure", "transportation", 
    "utilitiesCommunication"),
  Access_Constr = c("otherRestrictions", "copyright", "patent", "patentPending", "trademark", 
    "license", "intellectualPropertyRights", "restricted"),
  Other_Constr,
  Spatial_Resolution_Denom,
  Spatial_Resolution_Distance,
  Spatial_Resolution_Unit,
  Conformity_Spec_Title,
  Conformity_Date,
  Conformity_Date_Type = c("publication", "creation", "revision"),
  Conformity_Degree = F,
  Resource_Locator,
  Resource_Identifier,
  Resource_Identifier_CodeSpace,
  Keywords,
  Thesaurus_Title,
  Thesaurus_Date,
  Thesaurus_Date_Type = c("publication", "creation", "revision"),
  Temporal_Reference_Date,
  Temporal_Reference_Date_Type = c("publication", "creation", "revision"),
  Temp_Extent_Beg,
  Temp_Extent_End
)
{
  # use the first column for metadata: 
  if(missing(Target_variable)){ Target_variable <- names(obj)[1] }
  if(!("data" %in% slotNames(obj))){
    stop("'Data' slot required")
  }  
  if(!(Target_variable %in% names(obj@data))){
    stop("'Target_variable' not available in the attribute table")
  }
  
  # checks whether a valid e-mail address has been provided..
  if(missing(MD_Mail_address) || "@" %in% strsplit(MD_Mail_address, "")[[1]] == F){
    stop("'MD_Mail_address' is missing or invalid: Please provide an e-mail address of the metadata point of contact.")
  }
  
  # checks the presence of either an equivalent scale or resolution distance..
  if(missing(Spatial_Resolution_Denom) && missing(Spatial_Resolution_Distance)){
    stop("Please specify either 'Spatial_Resolution_Denom' or 'Spatial_Resolution_Distance'.")
  }
  
  # checks the presence of at least one keyword from the INSPIRE spatial data themes..
  insp.themes <- c("Coordinate reference systems", "Geographical grid systems", "Geographical names", 
    "Administrative units", "Addresses", "Cadastral parcels", "Transport networks", "Hydrography", 
    "Protected sites", "Elevation", "Land cover", "Orthoimagery", "Geology", "Statistical units", 
    "Buildings", "Soil", "Land use", "Human health and safety", "Utility and governmental services", 
    "Environmental monitoring facilities", "Production and industrial facilities", "Agricultural and aquaculture facilities", 
    "Population distribution - demography", "Area management/restriction/regulation zones and reporting units", 
    "Natural risk zones", "Atmospheric conditions", "Meteorological geographical features", 
    "Oceanographic geographical features", "Sea regions", "Bio-geographical regions", 
    "Habitats and biotopes", "Species distribution", "Energy resources", "Mineral resources")
  if(missing(Keywords) || Keywords[1] %in% insp.themes == F){
    stop("'Keywords' is missing or invalid: Please specify at least one keyword from the INSPIRE spatial data themes list.")
  }
  
  if(missing(xml.file)){ xml.file <- set.file.extension(normalizeFilename(deparse(substitute(obj, env = parent.frame()))), ".xml") } # set.file.extension requires RSAGA package
  
  if(generate.missing == T){
    inspire <- xmlTreeParse(system.file("INSPIRE_ISO19139.xml", package = "plotKML"), useInternalNodes = T)
    top <- xmlRoot(inspire)
    nx <- names(unlist(xmlToList(top, addAttributes = F)))
  }
  
  # if the metadata file does not exit, use the template:
  if(!is.na(file.info(xml.file)$size)){
    message(paste("Reading the metadata file: ", xml.file, sep=""))
    ret <- xmlTreeParse(xml.file)  
    a <- xmlTreeParse(xml.file, useInternalNodes = T)
  } else {  
    warning(paste("Could not locate ", xml.file, ". Using INSPIRE_ISO19139.xml.", sep = ""), call. = F)
    ret <- xmlTreeParse(system.file("INSPIRE_ISO19139.xml", package = "plotKML"), addAttributeNamespaces = T)
    a <- xmlTreeParse(system.file("INSPIRE_ISO19139.xml", package = "plotKML"), useInternalNodes = T)
  }  
  
  ml <- xmlRoot(ret)
  
  if(generate.missing == T){
    # compare the actual xml file and the template:
    cross <- compareXMLDocs(a = a, b = inspire)
    
    # merge the existing metadata file with INSPIRE and add missing nodes:
    if(length(cross[["inB"]]) > 0){
      for(i in 1:length(cross[["inB"]])){
        # position of the missing node in the target doc:
        nodn <- attr(cross[["inB"]], "dimnames")[[1]][i]
        x_l <- strsplit(nx[grep(nodn, nx)], "\\.")[[1]]
        
        # TH: This is not the best implementation :(  -> it takes ca 3-5 seconds
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
    }
    
    message("Generating metadata...")
    # resource title..
    # first if-else statement tackles empty nodes in source-xml files
    if(length(xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["title"]][["CharacterString"]])) == 0L) {
      if(missing(Citation_title)) {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- normalizeFilename(deparse(substitute(obj)))
      }
      else {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- Citation_title
      }
    } else {
      if(missing(Citation_title)) {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- normalizeFilename(deparse(substitute(obj)))
      }
      else {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- Citation_title
      }
    }
    
    # resource abstract..
    if(missing(Abstract)) {
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["abstract"]][["CharacterString"]]) <- Abstract
    }
    
    # lineage statement..
    if(missing(Lineage)) {
    } else {
      xmlValue(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["lineage"]][["LI_Lineage"]][["statement"]][["CharacterString"]]) <- Lineage
    }
    
    # use limitation..
    if(missing(Use_Limitation)) {
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["resourceConstraints"]][["MD_Constraints"]][["useLimitation"]][["CharacterString"]]) <- Use_Limitation
    }
    
    # metadata point of contact..
    if(missing(MD_Organisation_name)) {
    } else {
      xmlValue(ml[["contact"]][["CI_ResponsibleParty"]][["organisationName"]][["CharacterString"]]) <- MD_Organisation_name
    }
    xmlValue(ml[["contact"]][["CI_ResponsibleParty"]][["contactInfo"]][["CI_Contact"]][["address"]][["CI_Address"]][["electronicMailAddress"]][["CharacterString"]]) <- MD_Mail_address
    
    # dataset responsible party..
    # if not provided, the metadata point of contact organisation will be taken (if available)
    if(missing(Organisation_name)) {
      if(missing(MD_Organisation_name)) {
      } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["organisationName"]][["CharacterString"]]) <- MD_Organisation_name
      }
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["organisationName"]][["CharacterString"]]) <- Organisation_name
    }
    if(missing(Mail_address)) {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["contactInfo"]][["CI_Contact"]][["address"]][["CI_Address"]][["electronicMailAddress"]][["CharacterString"]]) <- MD_Mail_address
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["contactInfo"]][["CI_Contact"]][["address"]][["CI_Address"]][["electronicMailAddress"]][["CharacterString"]]) <- Mail_address
    }
    Responsible_Party_Role <- match.arg(Responsible_Party_Role)
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["role"]][["CI_RoleCode"]]) <- Responsible_Party_Role
    xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][["pointOfContact"]][["CI_ResponsibleParty"]][["role"]][["CI_RoleCode"]])[[2]] <- Responsible_Party_Role
    
    # metadata language.. (EU only)
    MD_Language <- match.arg(MD_Language)
    xmlValue(ml[["language"]][["LanguageCode"]]) <- MD_Language
    xmlAttrs(ml[["language"]][["LanguageCode"]])[[2]] <- MD_Language
 
    # dataset language.. (EU only)
    Language <- match.arg(Language)
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["language"]][["LanguageCode"]]) <- Language
    xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][["language"]][["LanguageCode"]])[[2]] <- Language
    
    # dataset topic category (more than one allowed)..
    Topic_Category <- match.arg(Topic_Category, several.ok = T)
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["topicCategory"]][["MD_TopicCategoryCode"]]) <- Topic_Category[1]
    if (length(Topic_Category) > 1) {
      xi <- length(Topic_Category) - 1; xi
      xt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "topicCategory")[1]); xt
      xm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]]); xm
      j <- 0
      for (i in (xt + 1):xm) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xm + xi + j][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][i][[1]]
        j <- j + 1
      }
      for (i in 2:length(Topic_Category)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][["topicCategory"]]
        #xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][length(ml[["identificationInfo"]][["MD_DataIdentification"]])][[1]][["MD_TopicCategoryCode"]]) <- Topic_Category[i]
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]][["MD_TopicCategoryCode"]]) <- Topic_Category[i]
      }
    }
    
    # spatial resolution (more than one allowed)..
    if(missing(Spatial_Resolution_Denom)) {
      ml[["identificationInfo"]][["MD_DataIdentification"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]], kids = "spatialResolution")
      #xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["spatialResolution"]][["MD_Resolution"]][["equivalentScale"]][["MD_RepresentativeFraction"]][["denominator"]][["Integer"]]) <- NULL
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["spatialResolution"]][["MD_Resolution"]][["equivalentScale"]][["MD_RepresentativeFraction"]][["denominator"]][["Integer"]]) <- Spatial_Resolution_Denom[1]
    
      if (length(Spatial_Resolution_Denom) > 1) {
      xi <- length(Spatial_Resolution_Denom) - 1; xi
      xt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[1]); xt
      xm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]]); xm
      j <- 0
      for (i in xm:(xt + 1)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xm + xi - j][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][i][[1]]
        j <- j + 1
      }
      for (i in 2:length(Spatial_Resolution_Denom)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][["spatialResolution"]]
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]][["MD_Resolution"]][["equivalentScale"]][["MD_RepresentativeFraction"]][["denominator"]][["Integer"]]) <- Spatial_Resolution_Denom[i]
      }
      }
    }  
        
    if(missing(Spatial_Resolution_Distance)) {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution"))]][["spatialResolution"]][["MD_Resolution"]][["distance"]][["Distance"]]) <- NULL
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution"))]][["spatialResolution"]][["MD_Resolution"]][["distance"]][["Distance"]]) <- Spatial_Resolution_Distance[1]
      if(missing(Spatial_Resolution_Unit)){
      } else {
        xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution"))]][["spatialResolution"]][["MD_Resolution"]][["distance"]][["Distance"]])[[1]] <- paste("#", Spatial_Resolution_Unit, sep = "")
      }
    }
    
    if (length(Spatial_Resolution_Distance) > 1) {
      xi <- length(Spatial_Resolution_Distance) - 1; xi
      xt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution"))]); xt
      xm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]]); xm
      j <- 0
      for (i in xm:(xt + 1)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xm + xi - j][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][i][[1]]
        j <- j + 1
      }
      for (i in 2:length(Spatial_Resolution_Distance)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "spatialResolution"))]][[1]]
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + i - 1][[1]][["MD_Resolution"]][["distance"]][["Distance"]]) <- Spatial_Resolution_Distance[i]
      }
    }
    
    # conformity statement..
    Conformity_Date_Type <- match.arg(Conformity_Date_Type)
    if(missing(Conformity_Spec_Title)) {
    } else {
      xmlValue(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["specification"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- Conformity_Spec_Title
    }
    if(missing(Conformity_Date)) {
    } else {
      xmlValue(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["specification"]][["CI_Citation"]][["date"]][["CI_Date"]][["date"]][["Date"]]) <- Conformity_Date
    }
    xmlValue(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["specification"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]]) <- Conformity_Date_Type
    xmlAttrs(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["specification"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]])[[2]] <- Conformity_Date_Type
    
    if(missing(Conformity_Degree)){
    } else {
      if(Conformity_Degree == T){
        ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]] <- removeAttributes(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]])
        ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]] <- addChildren(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]], kids = list(xmlNode("gco:Boolean", "true")))
      } else {
        ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]] <- removeAttributes(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]])
        ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]] <- addChildren(ml[["dataQualityInfo"]][["DQ_DataQuality"]][["report"]][["DQ_DomainConsistency"]][["result"]][["DQ_ConformanceResult"]][["pass"]], kids = list(xmlNode("gco:Boolean", "false")))
      }
    }
    
    # resource locator..
    if(missing(Resource_Locator)){
      xmlValue(ml[["distributionInfo"]][["MD_Distribution"]][["transferOptions"]][["MD_DigitalTransferOptions"]][["onLine"]][["CI_OnlineResource"]][["linkage"]][["URL"]]) <- ""
    } else {
      try.connection <- try(url(Resource_Locator, open = 'rb'))
      try.error <- inherits(try.connection, "try-error")
      if(try.error == T){
        stop("'Resource_Locator' points to an invalid URL: Please provide a valid linkage or leave this argument empty.")
      } else {
        xmlValue(ml[["distributionInfo"]][["MD_Distribution"]][["transferOptions"]][["MD_DigitalTransferOptions"]][["onLine"]][["CI_OnlineResource"]][["linkage"]][["URL"]]) <- Resource_Locator
      }
    }
    
    # temporal reference..
    if(missing(Temporal_Reference_Date)) {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]][["CI_Date"]][["date"]][["Date"]]) <- format(Sys.Date(), "%Y-%m-%d")
    } else {
      if(missing(Temporal_Reference_Date_Type)) {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]][["CI_Date"]][["date"]][["Date"]]) <- Temporal_Reference_Date[1]
        Temporal_Reference_Date_Type <- rep("publication", length(which(!is.na(Temporal_Reference_Date) == T)))
      } else {
        # only one creation date is allowed according to INSPIRE --> keep only the first creation date available
        if(length(which(Temporal_Reference_Date_Type == "creation")) > 1) {
          Temporal_Reference_Date[which(Temporal_Reference_Date_Type == "creation")[2:length(which(Temporal_Reference_Date_Type == "creation"))]] <- NA
        }
        # only the latest revision date is allowed according to INSPIRE --> delete all revision dates but the most recent
        if(length(which(Temporal_Reference_Date_Type == "revision")) > 1) {
          Temporal_Reference_Date[which(Temporal_Reference_Date == rev(sort(as.Date(Temporal_Reference_Date[which(Temporal_Reference_Date_Type == "revision")])))[2:length(which(Temporal_Reference_Date_Type == "revision"))])] <- NA
        }
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]][["CI_Date"]][["date"]][["Date"]]) <- Temporal_Reference_Date[which(!is.na(Temporal_Reference_Date))[1]]
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]]) <- Temporal_Reference_Date_Type[which(!is.na(Temporal_Reference_Date))[1]]
        xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]])[[2]] <- Temporal_Reference_Date_Type[which(!is.na(Temporal_Reference_Date))[1]]
      }
      if(length(which(!is.na(Temporal_Reference_Date) == T)) > 1) {
        xi <- length(which(!is.na(Temporal_Reference_Date) == T)) - 1; xi
        xt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]]) == "date")[1]); xt
        xm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]]); xm
        j <- 0
        for (z in xm:(xt + 1)) {
          ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][xm + xi - j][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][z][[1]]
          j <- j + 1
        }
        for (k in 2:length(which(!is.na(Temporal_Reference_Date) == T))) {
          ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][xt + k - 1][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["date"]]
          xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][xt + k - 1][[1]][["CI_Date"]][["date"]][["Date"]]) <- Temporal_Reference_Date[which(!is.na(Temporal_Reference_Date))[k]]
          xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][xt + k - 1][[1]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]]) <- Temporal_Reference_Date_Type[which(!is.na(Temporal_Reference_Date))[k]]
          xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][xt + k - 1][[1]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]])[[2]] <- Temporal_Reference_Date_Type[which(!is.na(Temporal_Reference_Date))[k]]        
        }
      }
    }
    
    # temporal extent (optional, if temporal reference is set!)..
    if(missing(Temp_Extent_Beg)) {
      ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]], kids = "temporalElement")
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]][["beginPosition"]]) <- Temp_Extent_Beg[1]
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]][["endPosition"]]) <- Temp_Extent_End[1]
      xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]])[[1]] <- paste("ID", UUIDgenerate(use.time = F), sep = "")
      if(length(Temp_Extent_Beg) > 1) {
        for (i in 2:length(Temp_Extent_Beg)) {
          ml[["identificationInfo"]][["MD_DataIdentification"]] <- addChildren(ml[["identificationInfo"]][["MD_DataIdentification"]], kids = list(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]]))
          xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "extent")[i]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]][["beginPosition"]]) <- Temp_Extent_Beg[i]
          xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "extent")[i]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]][["endPosition"]]) <- Temp_Extent_End[i]
          xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "extent")[i]][["extent"]][["EX_Extent"]][["temporalElement"]][["EX_TemporalExtent"]][["extent"]][["TimePeriod"]])[[1]] <- paste("ID", UUIDgenerate(use.time = F), sep = "")
          ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "extent")[i]][["extent"]][["EX_Extent"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "extent")[i]][["extent"]][["EX_Extent"]], kids = "geographicElement")
        }
      }
    }
        
    # unique resource identifier.. (requires package 'uuid')
    if(missing(Resource_Identifier_CodeSpace)) {
      if(missing(Resource_Identifier)) {
        ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]], kids = "RS_Identifier")
        ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]] <- addChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]], kids = list(xmlNode("gmd:MD_Identifier", xmlNode("gmd:code", xmlNode("gco:CharacterString", UUIDgenerate(use.time = F))))))
      } else {
        ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]], kids = "RS_Identifier")
        ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]] <- addChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]], kids = list(xmlNode("gmd:MD_Identifier", xmlNode("gmd:code", xmlNode("gco:CharacterString", Resource_Identifier)))))
      }
    } else {
      if(missing(Resource_Identifier)) {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]][["RS_Identifier"]][["code"]][["CharacterString"]]) <- UUIDgenerate(use.time = F) # version 4 UUID
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]][["RS_Identifier"]][["codeSpace"]][["CharacterString"]]) <- Resource_Identifier_CodeSpace
      } else {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]][["RS_Identifier"]][["code"]][["CharacterString"]]) <- Resource_Identifier
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["citation"]][["CI_Citation"]][["identifier"]][["RS_Identifier"]][["codeSpace"]][["CharacterString"]]) <- Resource_Identifier_CodeSpace
      }
    }
        
    # keywords..
    insp.themes <- c("Coordinate reference systems", "Geographical grid systems", "Geographical names", 
    "Administrative units", "Addresses", "Cadastral parcels", "Transport networks", "Hydrography", 
    "Protected sites", "Elevation", "Land cover", "Orthoimagery", "Geology", "Statistical units", 
    "Buildings", "Soil", "Land use", "Human health and safety", "Utility and governmental services", 
    "Environmental monitoring facilities", "Production and industrial facilities", "Agricultural and aquaculture facilities", 
    "Population distribution - demography", "Area management/restriction/regulation zones and reporting units", 
    "Natural risk zones", "Atmospheric conditions", "Meteorological geographical features", 
    "Oceanographic geographical features", "Sea regions", "Bio-geographical regions", 
    "Habitats and biotopes", "Species distribution", "Energy resources", "Mineral resources")
    # stop if first keyword is not one of the INSPIRE spatial data themes or missing at all
    if(missing(Keywords) || !(Keywords[1] %in% insp.themes)){
      stop("'Keywords' is missing or invalid: The first keyword must be from the INSPIRE spatial data themes list.")
    } else {
      if(length(Keywords) > 1) {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]][["CharacterString"]]) <- Keywords[1]
        if(missing(Thesaurus_Title) || missing(Thesaurus_Date) || missing(Thesaurus_Date_Type) || length(Thesaurus_Title) != length(Thesaurus_Date) || length(Thesaurus_Title) != length(Thesaurus_Date_Type)) {
          xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]][["CharacterString"]]) <- Keywords[2]
          if(length(Keywords) > 2) {
            for (i in 3:length(Keywords)) {
              ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]][["descriptiveKeywords"]][["MD_Keywords"]] <- addChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]][["descriptiveKeywords"]][["MD_Keywords"]], kids = list(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]]))
              xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]][["descriptiveKeywords"]][["MD_Keywords"]][i - 1][["keyword"]][["CharacterString"]]) <- Keywords[i]
            }
          }
        } else {
          for (i in 1:length(Thesaurus_Title)) {
            if(is.na(Thesaurus_Title[i]) || is.na(Thesaurus_Date[i]) || is.na(Thesaurus_Date_Type[i])) {
              Thesaurus_Title[i] <- NA
            }
          }
          for (i in 1:length(unique(Thesaurus_Title[!is.na(Thesaurus_Title)]))) {
            xi <- length(unique(Thesaurus_Title[!is.na(Thesaurus_Title)])); xi
            xt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[1]); xt
            xm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]]); xm
            j <- 0
            for (z in xm:(xt + 1)) {
              ml[["identificationInfo"]][["MD_DataIdentification"]][xm + xi - j][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][z][[1]]
              j <- j + 1
            }
            for (k in 1:length(unique(Thesaurus_Title[!is.na(Thesaurus_Title)]))) {
              ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k] <- ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[1][[1]]]
              xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][["keyword"]][["CharacterString"]]) <- Keywords[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[1] + 1]
              xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][["thesaurusName"]][["CI_Citation"]][["title"]][["CharacterString"]]) <- Thesaurus_Title[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[1]]
              xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][["thesaurusName"]][["CI_Citation"]][["date"]][["CI_Date"]][["date"]][["Date"]]) <- Thesaurus_Date[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[1]]
              xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][["thesaurusName"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]]) <- Thesaurus_Date_Type[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[1]]
              xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][["thesaurusName"]][["CI_Citation"]][["date"]][["CI_Date"]][["dateType"]][["CI_DateTypeCode"]])[[2]] <- Thesaurus_Date_Type[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[1]]  
              if(length(which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])) > 1) {
                for (z in 2:length(which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k]))) {
                  xii <- length(which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])) - 1; xii
                  xtt <- as.vector(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]]) == "keyword")[1]); xtt
                  xmm <- xmlSize(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]]); xmm
                  jj <- 0
                  for (zz in xmm:(xtt + 1)) {
                    ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][xmm + xii - jj][[1]] <- ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][zz][[1]]
                    jj <- jj + 1
                  }
                  ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][xtt + z - 1] <- ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][[1]][["MD_Keywords"]]) == "keyword")[1][[1]]]
                  xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][xt + k][["descriptiveKeywords"]][["MD_Keywords"]][z][["keyword"]][["CharacterString"]]) <- Keywords[which(Thesaurus_Title == unique(Thesaurus_Title[!is.na(Thesaurus_Title)])[k])[z] + 1]
                }
              }
            }  
          }
          pos.na <- which(is.na(Thesaurus_Title)); pos.na
          if(length(pos.na) != 0L) {
            xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords"))]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]][["CharacterString"]]) <- Keywords[pos.na[1] + 1]
            if(length(pos.na) > 1) {
              for (i in 2:length(pos.na)) {
                ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords"))]][["descriptiveKeywords"]][["MD_Keywords"]] <- addChildren(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords"))]][["descriptiveKeywords"]][["MD_Keywords"]], kids = list(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords"))]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]]))
                xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[length(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords"))]][["descriptiveKeywords"]][["MD_Keywords"]][i][["keyword"]][["CharacterString"]]) <- Keywords[pos.na[i] + 1]
              }
            }
          }
        }
      } else {
        xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["descriptiveKeywords"]][["MD_Keywords"]][["keyword"]][["CharacterString"]]) <- Keywords[1]
        ml[["identificationInfo"]][["MD_DataIdentification"]] <- removeChildren(ml[["identificationInfo"]][["MD_DataIdentification"]], kids = as.numeric(which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "descriptiveKeywords")[2]))
      }
    }
        
    # limitations on public access.. 
    Access_Constr <- match.arg(Access_Constr)
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "resourceConstraints")[2]][[1]][["MD_LegalConstraints"]][["accessConstraints"]][["MD_RestrictionCode"]]) <- Access_Constr
    xmlAttrs(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "resourceConstraints")[2]][[1]][["MD_LegalConstraints"]][["accessConstraints"]][["MD_RestrictionCode"]])[[2]] <- Access_Constr
    
    if (Access_Constr == "otherRestrictions") {
      if(missing(Other_Constr)) {
      } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "resourceConstraints")[2]][[1]][["MD_LegalConstraints"]][["otherConstraints"]][["CharacterString"]]) <- Other_Constr
      }
    } else {
      xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][which(names(ml[["identificationInfo"]][["MD_DataIdentification"]]) == "resourceConstraints")[2]][[1]][["MD_LegalConstraints"]][["otherConstraints"]][["CharacterString"]]) <- ""
    }
        
    # metadata file identifier.. (requires package 'uuid')
    xmlValue(ml[["fileIdentifier"]][["CharacterString"]]) <- UUIDgenerate(use.time = F) # version 4 UUID
    
    # current date (automated)..
    xmlValue(ml[["dateStamp"]][["Date"]]) <- format(Sys.Date(), "%Y-%m-%d")
    
    # estimate the bounding box (automated)..
    message("Estimating the bounding box coordinates...")
    obj.ll <- reproject(obj)
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["geographicElement"]][["EX_GeographicBoundingBox"]][["westBoundLongitude"]][["Decimal"]]) <- min(coordinates(obj.ll)[,1])
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["geographicElement"]][["EX_GeographicBoundingBox"]][["eastBoundLongitude"]][["Decimal"]]) <- max(coordinates(obj.ll)[,1])
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["geographicElement"]][["EX_GeographicBoundingBox"]][["northBoundLatitude"]][["Decimal"]]) <- max(coordinates(obj.ll)[,2])
    xmlValue(ml[["identificationInfo"]][["MD_DataIdentification"]][["extent"]][["EX_Extent"]][["geographicElement"]][["EX_GeographicBoundingBox"]][["southBoundLatitude"]][["Decimal"]]) <- min(coordinates(obj.ll)[,2]) 
    
  } # end generate.missing
  
  # generate metadata doc:
  f = tempfile()
  saveXML(ml, f)
  doc = xmlInternalTreeParse(f)
}
# end of script
