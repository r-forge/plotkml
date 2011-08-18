# Purpose        : Functions for generation and export of (spatial) metadata
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Status         : working version
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/], which are based on the "ISO 19139" 

# Generate a Layer description file that can be parsed to KML <description>
#
get_metadata <- function(
    obj,   # some space-time R object
    ### Different objects have different structures, but let's assume sp objects;
    var.name,  # targe variable
    style = "html",
    file.connection,
    # generate columns from object properties:
    Layer_description = "",
    R_object_name = as.character(substitute(obj, env = parent.frame())),
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
    Positional_error_radius ="",
    Originator = "",
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
    Enduser_license_URL = "",
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
    Metadata_standard_name = "Content Standard for Digital Geospatial Metadata",
    Metadata_standard_version = "FGDC-STD-001-1998"     
    )
    {
    
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

    md <- c(R_object_name, R_class_type, R_class_package_URL, R_script, var.name, Target_variable_description, Target_variable_type, Display_minimum, Display_maximum, color_pallete_name, Value_units, Numeric_resolution, proj4_string, Reference_units, West_bounding_coordinates, East_bounding_coordinates, North_bounding_coordinates, South_bounding_coordinates, Positional_error_radius, Originator, Publication_date, Title, Source_URL, Source_OCLC_number, Abstract, Purpose, Temporal_extent_begin, Temporal_extent_end, Currentness_reference, Progress, Maintenance_updates, Keywords, Data_owner, Enduser_license_URL, Access_constraints, Use_constraints, Metadata_report_generated_on, Contact_metadata_producer, Organization_metadata_producer, Address_metadata_producer, City_metadata_producer, State_or_province_metadata_producer, Postal_code_metadata_producer, Country_metadata_producer, E_mail_metadata_producer, Metadata_MEF_URL, Metadata_standard_name, Metadata_standard_version)
    names(md) <- c("R object name", "R class type", "R class package URL", "R script (lineage)", "Target variable", "Target variable description", "Target variable type", "Display minimum", "Display maximum", "Color pallete", "Value units", "Numeric resolution", "proj4string", "Reference units", "West bounding coordinates", "East bounding coordinates", "North bounding coordinates", "South bounding coordinates", "Positional error radius", "Originator (citation)", "Publication date (citation)", "Title (citation)", "Source URL (citation)", "Source OCLC number (citation)", "Abstract (description)", "Purpose (description)", "Temporal extent begin", "Temporal extent end", "Currentness reference", "Progress (status)", "Maintenance updates", "Keywords", "Data owner",  "Enduser license URL", "Access constraints", "Use constraints", "Metadata report generated on", "Contact (metadata producer)", "Organization (metadata producer)", "Address (metadata producer)", "City (metadata producer)", "State or province (metadata producer)", "Postal code (metadata producer)", "Country (metadata producer)", "E-mail (metadata producer)", "Metadata MEF URL", "Metadata standard name", "Metadata standard version")
    return(md)
}

# Write metadata to a file:
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
    file <- paste(as.character(substitute(x, env = parent.frame())), ".html", sep="")
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


# Write the metadata dataframe to Geonetwork MEF format as specified at [http://geonetwork-opensource.org/manuals/2.6.3/developer/mef/]
#
# metadata2MEF <- function(
#    md,  # metadata data.frame

#    )
#    {
    
# }    
