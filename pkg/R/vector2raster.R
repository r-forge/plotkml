# Purpose        : Convert a vector map to a raster and (optional) write to a file;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl); 
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : tested
# Note           : The output pixel size is determined using simple cartographic principles (see [http://dx.doi.org/10.1016/j.cageo.2005.11.008]);


vector2raster <- function(obj, var.name = names(obj)[1], cell.size, bbox, file.name, ...){
    
    if(class(obj)=="SpatialPointsDataFrame"|class(obj)=="SpatialLinesDataFrame"|class(obj)=="SpatialPolygonsDataFrame"){
    require(maptools)
    require(rgdal)
    require(raster)
    
    if(missing(bbox)) { bbox <- obj@bbox }
    # make an empty raster based on extent:
    if(missing(cell.size)) { 
    # print warning:
    warning("Automated derivation of suitable cell size can be time consuming and is sensible to cartographic artifacts.", immediate. = TRUE)
    
    if(class(obj)=="SpatialPointsDataFrame"){
    require(spatstat)
    x <- as(obj[var.name], "ppp")
    nd <- nndist(x$x, x$y)
    ndb <- boxplot(nd, plot=FALSE)
    cell.size <- signif(ndb$stats[3]/2, 2)
    }
    
    if(class(obj)=="SpatialLinesDataFrame"){
    require(spatstat)
    x <- as(as(obj[var.name], "SpatialLines"), "psp")
    nd <- nndist.psp(x)  # this can be time consuming!
    ndb <- boxplot(nd, plot=FALSE)
    cell.size <- signif(ndb$stats[3]/2, 2) 
    }
    
    if(class(obj)=="SpatialPolygonsDataFrame"){
    x <- sapply(obj@polygons, slot, "area")
    cell.size <- signif(sqrt(median(x))/2, 2)
    }
    }
    
    x <- GridTopology(cellcentre.offset=bbox[,1], cellsize=c(cell.size,cell.size), cells.dim=c(round(abs(diff(bbox[1,])/cell.size), 0), ncols=round(abs(diff(bbox[2,])/cell.size), 0)))
    r.sp <- SpatialGrid(x, proj4string = obj@proj4string)
    r <- raster(r.sp)
    # rasterize - convert vector to raster map:
    in.r <- rasterize(obj[var.name], r)
    res <- as(in.r, "SpatialGridDataFrame")
    
    if(!missing(file.name)){
    writeRaster(in.r, filename=file.name, overwrite=TRUE)
    }
    
    return(res)
        
    }
    else {
    stop("Object of type Spatial-Points, -Lines or -Polygons required.")
    }
}

# end of script;