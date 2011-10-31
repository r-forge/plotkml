# Purpose        : Extracts PROJ4 parameters and checks if they are compatible with ref_CRS
# Maintainer     : Pierre Roudier (pierre.roudier@landcare.nz);
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Dylan Beaudette (debeaudette@ucdavis.edu);  
# Dev Status     : Alpha
# Note           : p4s_parameters list of proj4 parameter/value strings; Uses the string parsing functionality from the 'plyr' package;

.extractProjValue <- function(p4s_parameters, param){
  
  # Locating the current PROJ4 parameter
  query <- ldply(p4s_parameters, str_locate, pattern = param)
  idx <- which(!is.na(query[, 1]) & !is.na(query[, 2]))
  
  # If the PROJ4 parameter is found we extract its value
  if (length(idx) > 0) {
    # Selecting the good param string
    param_value <- p4s_parameters[idx]
    # Extract the parameter value
    value <- strsplit(param_value, param)[[1]]
    value <- value[value != ""]
  }
  else { stop(paste("Proj4string does not contain", param, "parameter. See 'CRS-methods' for more details."))
  }

  return(value)
}


## parse string:
parse_proj4 <- function(p4s, params){

  if(missing(params)) {
  ref_CRS = get("ref_CRS", envir = plotKML.opts)
  value <- strsplit(ref_CRS, "\\+")[[1]]
  value <- value[value != ""]
  param_names <- sapply(strsplit(value, "="), function(x){x[1]})
  params <- as.list(paste("\\+", sapply(strsplit(value, "="), function(x){x[1]}), "=", sep="")) 
  }

  # Splitting the whole PROJ4 string
  p4s_parameters <- str_split(p4s, " ")[[1]]
  # Extraction of the values of parameters specified above
  res <- laply(params, .extractProjValue, p4s_parameters = p4s_parameters)
  # colnames for better looking result
  names(res) <- param_names

  return(res)
}

## Get proj4string from an object
getCRS.Spatial <- function(obj) {
  CRSargs(CRS(proj4string(obj)))
}

setMethod("getCRS", "Spatial", getCRS.Spatial)

getCRS.Raster <- function(obj) {
  CRSargs(projection(obj, asText = FALSE))
}

setMethod("getCRS", "Raster", getCRS.Raster)

## check proj4string
check_projection <- function(obj, logical = TRUE, ref_CRS = get("ref_CRS", envir = plotKML.opts)){
  
  # Using PROJ.4 to get the PROJ4 string
  p4s <- getCRS(obj)

  # Parsing the PROJ4 string for proj and datum values
  params <- parse_proj4(p4s)

  # the default target proj4 string:
  value <- strsplit(ref_CRS, "\\+")[[1]]
  value <- value[value != ""]
  target_params <- stringr::str_trim(sapply(strsplit(value, "="), function(x){x[2]}))
  names(target_params) <- sapply(strsplit(value, "="), function(x){x[1]})

  # if already projection type is missing the string is invalid
  if(params["proj"] != ""){  

  # If test fails
  if (sum(is.na(match(params, target_params)))>0) {
    if (!logical)
      stop(paste("'", ref_CRS, "' coordinate system required."))
    else
      res <- FALSE
  }
  # If test succeed
  else
    res <- TRUE
  }
  
  else {
    stop("A valid proj4string required. See 'CRS-methods' for more details.")
    }

  return(res)
}

# end of script;