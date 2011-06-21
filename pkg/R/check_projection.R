.extractProjValue <- function(p4s_parameters, param){
  query <- ldply(p4s_parameters, str_locate, pattern = param)
  idx <- which(!is.na(query[, 1]) & !is.na(query[, 2]))
  
  if (length(idx) > 0) {
    # Selecting the good param string
    param_value <- p4s_parameters[idx]
    # Extract the parameter value
    value <- str_split(param_value, param)[[1]]
    value <- value[value != ""]
  }
  else
    value <- ""

  value
}


#' Parses the PROJ.4 string to check if 
#' the projection is KML-compatible
#'
#' @param p4s the PROJ.4 string of the object to be parsed
#'
parse_proj4 <- function(p4s){

  require(stringr)
  require(plyr)

  params <- list("\\+proj=", "\\+datum=")
  p4s_parameters <- str_split(p4s, " ")[[1]]
  res <- laply(params, .extractProjValue, p4s_parameters = p4s_parameters)
  names(res) <- c("proj", "datum")
  res
}

check_projection <- function(obj, logical = TRUE){
  
  require(rgdal)

  p4s <- CRSargs(CRS(proj4string(obj)))
  params <- parse_proj4(p4s)

  if (params["proj"] != "longlat" | params["datum"] != "WGS84") {
    if (!logical)
      stop("Wrong projection.")
    else
      res <- FALSE
  }
  else
    res <- TRUE

  res
}