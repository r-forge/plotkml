# Purpose        : Functions for generation and export of (spatial) metadata
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Status         : working version
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/], which can be converted to "ISO 19139" XML schema (these metadata fullfill all required fields) 


# Write metadata to a KML file:
#                               
kml_metadata <- function(
    x,  # metadata data frame
    style = "html",
    file.connection,
    fix.enc = TRUE,
    cwidth = 150,
    twidth = 500
    )
    {
    ## Assuming html style only:
    if(style=="html"){
    
    ## TH: Temporary solution
    if(missing(file.connection)) {  
    file <- paste(deparse(substitute(x)), ".html", sep="")
    assign('file.out', file(file, 'w', blocking=TRUE))
    file.connection <- get('file.out')
    }    
         
    # write to html:
    cat('<table width="', twidth, '" border="0" cellspacing="5" cellpadding="10">', sep="", file = file.connection, append = TRUE)
    cat('\t<caption>', file = file.connection, append = TRUE)
    cat('\t\tLayer description:', file = file.connection, append = TRUE)
    cat('\t</caption>', file = file.connection, append = TRUE)
    
    for(i_md in 1:length(names(x))) {
        cat('\t<tr>', file = file.connection, append = TRUE)
        cat('\t\t<th width="', cwidth, '" scope="col"><div align="left">', names(x)[i_md], '</div></th>', sep="", file = file.connection, append = TRUE)
        cat('\t\t<th scope="col"><div align="left">', x[i_md], '</div></th>', sep="", file = file.connection, append = TRUE)
        cat('\t</tr>', file = file.connection, append = TRUE)
    }
    cat('</table>', file = file.connection, append = TRUE)
    
    }
    # else     
    
    if(missing(file.connection)) {
    close(file.connection)
    }
}    


## Generate a Layer description file that can be parsed to KML <description>
#
get_metadata <- function(
    obj,   # some space-time R object
    ### Different objects have different structures, but let's assume sp objects;
    var.name,  # targe variable
    style = "html",
    xml.file = paste(deparse(substitute(obj)), ".xml", sep=""), # optional metadata file in FGDC format
    # generate columns from object properties:
    Layer_description = "",
    R_object_name = deparse(substitute(obj)),
    R_class_type = class(obj)[1],
    R_class_package_URL = paste("http://cran.r-project.org/web/packages/", attr(class(obj), "package"), "/", sep=""),
    R_script = "",
    Target_variable_description = "",
    Target_variable_type = class(obj@data[,var.name]),
    Display_minimum = "",
    Display_maximum = "",
    color_pallete_name = "",
    Value_units = "",
    Numeric_resolution = "",
    proj4_string = proj4string(obj),
    Reference_units,
    West_bounding_coordinates,
    East_bounding_coordinates,
    North_bounding_coordinates,
    South_bounding_coordinates,
    Positional_error_radius = "",
    Publication_author = "",
    Publication_date = "",
    Title = "",
    Source_URL = "",
    Source_OCLC_number = "",
    Abstract = "",
    Purpose = "",
    Temporal_extent_begin = "",
    Temporal_extent_end = "",
    Currentness_reference = "",
    Progress = "",
    Maintenance_updates = "",
    Keywords = "",
    Access_constraints = "",
    Data_owner = "",
    Enduser_license_URL = "http://creativecommons.org/licenses/by/3.0/",
    Use_constraints = "",
    Metadata_report_generated_on = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ"),
    Contact_metadata_producer, 
    Organization_metadata_producer,
    Address_metadata_producer = "",
    City_metadata_producer = "",
    State_or_province_metadata_producer = "",
    Postal_code_metadata_producer = "",
    Country_metadata_producer = "",
    E_mail_metadata_producer = "",
    Metadata_MEF_URL = "",
    Metadata_standard_name = "",
    Metadata_standard_version = ""     
    )
    {
    
    # Read metadata from an external XML file (minimum required metadata):
    if(!is.na(file.info(xml.file)$size)){
    met <- read.metadata(xml.file)
    
    R_script  <- met[attr(met, "names")=="R_script"][[1]]
    Positional_error_radius <- met[attr(met, "names")=="Positional_error_radius"][[1]]
    Publication_author <- met[attr(met, "names")=="Publication_author"][[1]]
    Publication_date <- met[attr(met, "names")=="Publication_date"][[1]]
    Title <- met[attr(met, "names")=="Title"][[1]]
    Source_URL <- met[attr(met, "names")=="Source_URL"][[1]]
    Source_OCLC_number <- met[attr(met, "names")=="Source_OCLC_number"][[1]]
    Abstract <- met[attr(met, "names")=="Abstract"][[1]]
    Purpose <- met[attr(met, "names")=="Purpose"][[1]]
    Temporal_extent_begin <- met[attr(met, "names")=="Temporal_extent_begin"][[1]]
    Temporal_extent_end <- met[attr(met, "names")=="Temporal_extent_end"][[1]]
    Currentness_reference <- met[attr(met, "names")=="Currentness_reference"][[1]]
    Progress <- met[attr(met, "names")=="Progress"][[1]]
    Maintenance_updates <- met[attr(met, "names")=="Maintenance_updates"][[1]]
    Keywords <- met[attr(met, "names")=="Keywords"][[1]]
    Access_constraints <- met[attr(met, "names")=="Access_constraints"][[1]]
    Data_owner <- met[attr(met, "names")=="Data_owner"][[1]]
    Use_constraints <- met[attr(met, "names")=="Use_constraints"][[1]]
    Contact_metadata_producer <- met[attr(met, "names")=="Contact_metadata_producer"][[1]] 
    Organization_metadata_producer <- met[attr(met, "names")=="Organization_metadata_producer"][[1]]
    Address_metadata_producer <- met[attr(met, "names")=="Address_metadata_producer"][[1]]
    City_metadata_producer <- met[attr(met, "names")=="City_metadata_producer"][[1]]
    State_or_province_metadata_producer <- met[attr(met, "names")=="State_or_province_metadata_producer"][[1]]
    Postal_code_metadata_producer <- met[attr(met, "names")=="Postal_code_metadata_producer"][[1]]
    Country_metadata_producer <- met[attr(met, "names")=="Country_metadata_producer"][[1]]
    E_mail_metadata_producer <- met[attr(met, "names")=="E_mail_metadata_producer"][[1]]
    Metadata_standard_name <- met[attr(met, "names")=="Metadata_standard_name"][[1]]
    Metadata_standard_version <- met[attr(met, "names")=="Metadata_standard_version"][[1]]
    }
    else { stop("Could not locate the metadata file") }
    
    # Guess the missing columns:
    if(missing(var.name)) { var.name <- names(obj@data)[1] }
    if(missing(West_bounding_coordinates)) {
      check <- check_projection(obj, logical = TRUE)
      # Trying to reproject data if the check was not successful
      if (!check) {
      obj.ll <- reproject(obj)
      } 
      West_bounding_coordinates <- min(coordinates(obj.ll)[,1])
      East_bounding_coordinates <- max(coordinates(obj.ll)[,1])
      North_bounding_coordinates <- max(coordinates(obj.ll)[,2])
      South_bounding_coordinates <- min(coordinates(obj.ll)[,2])  
    }
    if(missing(Reference_units)&!check) { Reference_units <- "meters" }
    else { Reference_units <- "geographic degrees" }
    
    if(missing(Contact_metadata_producer)) { Contact_metadata_producer <- paste(Sys.getenv(c("USERNAME"))[[1]], "at", Sys.getenv(c("COMPUTERNAME"))[[1]]) }
    if(missing(Organization_metadata_producer)) { Organization_metadata_producer <- Sys.getenv(c("USERDNSDOMAIN"))[[1]] }

    # Merge all metadata together:
    md <- c(R_object_name, R_class_type, R_class_package_URL, R_script, var.name, Target_variable_description, Target_variable_type, Display_minimum, Display_maximum, color_pallete_name, Value_units, Numeric_resolution, proj4_string, Reference_units, West_bounding_coordinates, East_bounding_coordinates, North_bounding_coordinates, South_bounding_coordinates, Positional_error_radius, Publication_author, Publication_date, Title, Source_URL, Source_OCLC_number, Abstract, Purpose, Temporal_extent_begin, Temporal_extent_end, Currentness_reference, Progress, Maintenance_updates, Keywords, Data_owner, Enduser_license_URL, Access_constraints, Use_constraints, Metadata_report_generated_on, Contact_metadata_producer, Organization_metadata_producer, Address_metadata_producer, City_metadata_producer, State_or_province_metadata_producer, Postal_code_metadata_producer, Country_metadata_producer, E_mail_metadata_producer, Metadata_MEF_URL, Metadata_standard_name, Metadata_standard_version)
    names(md) <- c("R object name", "R class type", "R class package URL", "R script (lineage)", "Target variable", "Target variable description", "Target variable type", "Display minimum", "Display maximum", "Color pallete", "Value units", "Numeric resolution", "proj4string", "Reference units", "West bounding coordinates", "East bounding coordinates", "North bounding coordinates", "South bounding coordinates", "Positional error radius", "Author (citation)", "Publication date (citation)", "Title (citation)", "Source URL (citation)", "Source OCLC number (citation)", "Abstract (description)", "Purpose (description)", "Temporal extent begin", "Temporal extent end", "Currentness reference", "Progress (status)", "Maintenance updates", "Keywords", "Data owner",  "Enduser license URL", "Access constraints", "Use constraints", "Metadata report generated on", "Contact (metadata producer)", "Organization (metadata producer)", "Address (metadata producer)", "City (metadata producer)", "State or province (metadata producer)", "Postal code (metadata producer)", "Country (metadata producer)", "E-mail (metadata producer)", "Metadata MEF URL", "Metadata standard name", "Metadata standard version")
    
    return(md)
}


## Read the Federal Geographic Data Committee metadata file (.xml) [http://www.fgdc.gov/metadata/csdgm/]:

read.metadata <- function(xml.file){

    require(XML)
    ret <- xmlTreeParse(xml.file, useInternalNodes = TRUE)
    top <- xmlRoot(ret)
    
    # "idinfo"
    id1 <- which(names(top) %in% "idinfo")
    
    try(Publication_author <- xmlValue(top[[id1]][["citation"]][["citeinfo"]][["origin"]]), silent=TRUE)
    try(Publication_date <- xmlValue(top[[id1]][["citation"]][["citeinfo"]][["pubdate"]]), silent=TRUE)
    try(Title <- xmlValue(top[[id1]][["citation"]][["citeinfo"]][["title"]]), silent=TRUE) 
    try(Source_OCLC_number <- xmlValue(top[[id1]][["citation"]][["citeinfo"]][["onlink"]]), silent=TRUE)
    
    try(Abstract <- xmlValue(top[[id1]][["descript"]][["abstract"]]), silent=TRUE)
    try(Purpose <- xmlValue(top[[id1]][["descript"]][["purpose"]]), silent=TRUE)
    
    try(Temporal_extent_begin <- xmlValue(top[[id1]][["timeperd"]][["timeinfo"]][["rngdates"]][["begdate"]]), silent=TRUE)
    try(Temporal_extent_end <- xmlValue(top[[id1]][["timeperd"]][["timeinfo"]][["rngdates"]][["enddate"]]), silent=TRUE)
    try(Currentness_reference <- xmlValue(top[[id1]][["timeperd"]][["current"]]), silent=TRUE)
    try(Progress <- xmlValue(top[[id1]][["status"]][["progress"]]), silent=TRUE)
    try(Maintenance_updates <- xmlValue(top[[id1]][["status"]][["update"]]), silent=TRUE)
    try(Keywords <- xmlValue(top[[id1]][["keywords"]][["theme"]][["themekey"]]), silent=TRUE)
    
    try(Access_constraints <- xmlValue(top[[id1]][["accconst"]]), silent=TRUE)
    try(Use_constraints <- xmlValue(top[[id1]][["useconst"]]), silent=TRUE)

    try(West_bounding_coordinates <- xmlValue(top[[id1]][["spdom"]][["bounding"]][["westbc"]]), silent=TRUE)
    try(East_bounding_coordinates <- xmlValue(top[[id1]][["spdom"]][["bounding"]][["eastbc"]]), silent=TRUE)
    try(South_bounding_coordinates <- xmlValue(top[[id1]][["spdom"]][["bounding"]][["southbc"]]), silent=TRUE)
    try(North_bounding_coordinates <- xmlValue(top[[id1]][["spdom"]][["bounding"]][["northbc"]]), silent=TRUE)
    
    # "dataqual"    
    da1 <- which(names(top) %in% "dataqual")
    
    try(Positional_error_radius <- xmlValue(top[[da1]][["posacc"]][["horizpa"]][["qhorizpa"]][["horizpav"]]), silent=TRUE)
    try(R_script <- xmlValue(top[[da1]][["lineage"]][["srcinfo"]][["srccite"]][["citeinfo"]][["onlink"]]), silent=TRUE)
    
    # "spref" 
    ## TH: this is rather inefficient via metadata!
        
    # "eainfo"
        
    # "distinfo"
    di1 <- which(names(top) %in% "distinfo")
    
    try(Source_URL <- xmlValue(top[[di1]][["stdorder"]][["ordering"]]), silent=TRUE) 
    try(Data_owner <- xmlValue(top[[di1]][["distrib"]][["cntinfo"]][["cntorgp"]]), silent=TRUE)
    
    # "metainfo"
    me1 <- which(names(top) %in% "metainfo")
       
    try(Contact_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntperp"]][["cntper"]]), silent=TRUE)
    try(Organization_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntperp"]][["cntorg"]]), silent=TRUE)
    try(Address_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntaddr"]][["address"]]), silent=TRUE)
    try(City_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntaddr"]][["city"]]), silent=TRUE)
    try(State_or_province_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntaddr"]][["state"]]), silent=TRUE)
    try(Postal_code_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntaddr"]][["postal"]]), silent=TRUE)
    try(Country_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntaddr"]][["country"]]), silent=TRUE)
    try(E_mail_metadata_producer <- xmlValue(top[[me1]][["metc"]][["cntinfo"]][["cntemail"]]), silent=TRUE)

    try(Metadata_standard_name  <- xmlValue(top[[me1]][["metstdn"]]), silent=TRUE)
    try(Metadata_standard_version <- xmlValue(top[[me1]][["metstdv"]]), silent=TRUE)
    
    # Glue all fields together:
    ret <- c(R_script, West_bounding_coordinates, East_bounding_coordinates, North_bounding_coordinates, South_bounding_coordinates, Positional_error_radius, Publication_author, Publication_date, Title, Source_URL, Source_OCLC_number, Abstract, Purpose, Temporal_extent_begin, Temporal_extent_end, Currentness_reference, Progress, Maintenance_updates, Keywords, Data_owner, Access_constraints, Use_constraints, Contact_metadata_producer, Organization_metadata_producer, Address_metadata_producer, City_metadata_producer, State_or_province_metadata_producer, Postal_code_metadata_producer, Country_metadata_producer, E_mail_metadata_producer, Metadata_standard_name, Metadata_standard_version)
    names(ret) <- c("R_script", "West_bounding_coordinates", "East_bounding_coordinates", "North_bounding_coordinates", "South_bounding_coordinates", "Positional_error_radius", "Publication_author", "Publication_date", "Title", "Source_URL", "Source_OCLC_number", "Abstract", "Purpose", "Temporal_extent_begin", "Temporal_extent_end", "Currentness_reference", "Progress", "Maintenance_updates", "Keywords", "Data_owner", "Access_constraints", "Use_constraints", "Contact_metadata_producer", "Organization_metadata_producer", "Address_metadata_producer", "City_metadata_producer", "State_or_province_metadata_producer", "Postal_code_metadata_producer", "Country_metadata_producer", "E_mail_metadata_producer", "Metadata_standard_name", "Metadata_standard_version")
    
    return(ret)
}


# Write the metadata dataframe to Geonetwork MEF format as specified at [http://geonetwork-opensource.org/manuals/2.6.3/developer/mef/]
#
# metadata2MEF <- function(
#    md,  # metadata data.frame

#    )
#    {
    
# }    
