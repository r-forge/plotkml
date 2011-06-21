#' Extracts the values of PROJ4 parameters
#'
#' @param p4s_parameters list of proj4 parameter/value strings
#' @param param proj4 string parameter to be extracted
#'
#' @author Pierre Roudier
.extractProjValue <- function(p4s_parameters, param){
  
  # Locating the current PROJ4 parameter
  query <- ldply(p4s_parameters, str_locate, pattern = param)
  idx <- which(!is.na(query[, 1]) & !is.na(query[, 2]))
  
  # If the PROJ4 parameter is found we extract its value
  if (length(idx) > 0) {
    # Selecting the good param string
    param_value <- p4s_parameters[idx]
    # Extract the parameter value
    value <- str_split(param_value, param)[[1]]
    value <- value[value != ""]
  }
  # Otherwise an empty string is returned
  else
    value <- ""

  value
}


#' Parses the PROJ.4 string to check if 
#' the projection is KML-compatible
#'
#' @param p4s the PROJ.4 string of the object to be parsed
#' @value an array with projection and datum values
#'
#' @author Pierre Roudier
#'
parse_proj4 <- function(p4s){

  # Dependencies
  require(stringr)
  require(plyr)

  # Tested PROJ4 params
  params <- list("\\+proj=", "\\+datum=")
  # Splitting the whole PROJ4 string
  p4s_parameters <- str_split(p4s, " ")[[1]]
  # Extraction of the values of parameters specified above
  res <- laply(params, .extractProjValue, p4s_parameters = p4s_parameters)
  # colnames for better looking result
  names(res) <- c("proj", "datum")

  res
}

#' Checks that the projection is geographic and the datum is WGS84
#' for KML creation
#'
#' @param obj a sp object
#' @param logical if TRUE, a logical value is returned. If FALSE, an error is thrown if the test failed.
#'
#' @author Pierre Roudier
#'
check_projection <- function(obj, logical = TRUE){
  
  # Dependencies
  require(rgdal)

  # Using PROJ.4 to get the PROJ4 string
  p4s <- CRSargs(CRS(proj4string(obj)))

  # Parsing the PROJ4 string for proj and datum values
  params <- parse_proj4(p4s)

  # If test fails
  if (params["proj"] != "longlat" | params["datum"] != "WGS84") {
    if (!logical)
      stop("Wrong projection.")
    else
      res <- FALSE
  }
  # If test succeed
  else
    res <- TRUE

  res
}