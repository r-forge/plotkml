# Purpose        : Convert SGDF to a polygon map (grid cells);
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Status         : working version
# Note           : Not recommended for large grids!;

grid2poly <- function(obj, reproject = TRUE, var.name, tmp.file = TRUE, method = "sp"){

    if(missing(var.name)) { var.name <- names(obj)[1] }
    # print warning:
    warning("Operation not recommended for large grids (>>10e4 pixels).", immediate. = TRUE)
    
    if(method=="sp"){
        obj <- as(obj[var.name], "SpatialPixelsDataFrame")
        pol <- as.SpatialPolygons.SpatialPixels(obj)
    }
    
    if(method=="raster"){
        require(raster)
        r <- raster(obj[var.name])
        pol <- rasterToPolygons(r)
    }
    
    if(method=="RSAGA"){
      require(RSAGA)
      if(!rsaga.env()[["cmd"]]=="NULL"){
      require(maptools)
        
        if(tmp.file==TRUE){
        tf <- tempfile() 
        }
        else { # first, write SGDF to a file:
        tf <- var.name
        }
        writeGDAL(obj[var.name], paste(tf, ".sdat", sep=""), "SAGA")
        rsaga.geoprocessor(lib="shapes_grid", module=3, param=list(GRIDS=paste(tf, ".sgrd", sep=""), SHAPES=paste(tf, ".shp", sep=""), NODATA=TRUE, TYPE=1), show.output.on.console = FALSE)
        pol <- readShapePoly(paste(tf, ".shp", sep=""), proj4string=obj@proj4string)
        }
        
        else { stop("SAGA GIS path could not be located. See 'rsaga.env()' for more info.") }
    }
    
    # Checking projection:
    check <- check_projection(pol, logical = TRUE)

    # Trying to reproject data if the check was not successful
    if (!check&reproject==TRUE) {  pol <- reproject(pol)  }

    # Convert to SPolyDF:
    dm <- data.frame(obj@data[,var.name])
    names(dm) <- var.name
    pol <- SpatialPolygonsDataFrame(pol, dm, match.ID=FALSE)
    
    return(pol)
} 

# enf of script;