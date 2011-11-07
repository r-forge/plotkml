# Purpose        : Insertion of metadata into a KML file
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Dev Status     : Pre-Alpha
# Note           : Based on the US gov sp metadata standards [http://www.fgdc.gov/metadata/csdgm/];


## Write metadata to a KML file:                             
kml_metadata <- function(
    spMd,   # SpatialMetadata
    sel,
    fix.enc = TRUE,
    cwidth = 150,
    twidth = 500,
    full.names,
    delim.sign = "_",
    asText = FALSE
    ){
        
    if(missing(full.names)){
      data(mdnames)      
      full.names = mdnames      
    }
    
    nx <- unlist(xmlToList(metadata(spMd), addAttributes=FALSE))
    # convert to a table:
    met <- data.frame(metadata=gsub("\\.", delim.sign, attr(nx, "names")), value=paste(nx), stringsAsFactors = FALSE)
    # add more friendly names:
    metm <- merge(x=met, y=full.names[,c("metadata","field.names")], by="metadata", all.x=TRUE)
        
    # selected columns:
    if(missing(sel)) {
      sel = c("idinfo_citation_citeinfo_title", "idinfo_descript_abstract", "spdoinfo_ptvctinf_sdtsterm_ptvctcnt", "idinfo_timeperd_timeinfo_rngdates_begdate", "idinfo_timeperd_timeinfo_rngdates_enddate",  
       "distinfo_stdorder_digform_digtopt_onlinopt_computer_networka_networkr", "idinfo_citation_citeinfo_othercit", "idinfo_citation_citeinfo_onlink", "idinfo_datacred", "distinfo_distrib_cntinfo_cntorgp_cntorg", "distinfo_stdorder_digform_digtinfo_formcont", "idinfo_native")
    }
    selm <- data.frame(metadata = sel, order.no=1:length(sel))
    md <- merge(selm, metm, by="metadata", all.x=TRUE)
    md <- md[order(md$order.no),] 
    
    # write to html:
    l1 <- newXMLNode("table", attrs=c(width=twidth, border="0", cellspacing="5", cellpadding="10"))
    l2 <- newXMLNode("caption", "Spatial metadata summary:", parent = l1)
    txt <- sprintf('<tr><th width="%.0f" scope="col"><div align="left"><strong>%s</strong></div></th><th scope="col"><div align="left"><strong>%s</strong></div></th></tr>', rep(cwidth, nrow(md)), paste(md$field.names), paste(md$value))
    parseXMLAndAdd(txt, l1)
    
    if(asText==TRUE){ 
      md.txt <- saveXML(l1)
      return(md.txt)
    }
    else {  
      return(l1) 
    }
}

setMethod("kml_metadata", "SpatialMetadata", kml_metadata)
setMethod("metadata", signature = "SpatialMetadata", function(obj) obj@xml)
setMethod("field.names", signature = "SpatialMetadata", function(obj) paste(obj@field.names))
setMethod("sp.palette", signature = "SpatialMetadata", function(obj) paste(obj@palette))

# end of script;