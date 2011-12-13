# Purpose        : Convert a vector map to a raster and (optional) write to a file;
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl); 
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : tested
# Note           : The output pixel size is determined using simple cartographic principles (see [http://dx.doi.org/10.1016/j.cageo.2005.11.008]);


vect2rast <- function(obj, field = names(obj)[1], cell.size, bbox, file.name, silent = FALSE, ...){
    
    if(class(obj)=="SpatialPointsDataFrame"|class(obj)=="SpatialLinesDataFrame"|class(obj)=="SpatialPolygonsDataFrame"){
    require(maptools)
    require(rgdal)
    require(raster)
    
    if(missing(bbox)) { bbox <- obj@bbox }
    # make an empty raster based on extent:
    if(missing(cell.size)) { 
    # print warning:
    if(length(obj)>1000){
    warning("Automated derivation of suitable cell size can be time consuming and is sensible to cartographic artifacts.", immediate. = TRUE)
    }
    
    if(class(obj)=="SpatialPointsDataFrame"){
    require(spatstat)
    x <- as(obj[field], "ppp")
    nd <- nndist(x$x, x$y)
    ndb <- boxplot(nd, plot=FALSE)
    cell.size <- signif(ndb$stats[3]/2, 2)
    if(silent==FALSE){message(paste("Estimated nearest neighbour distance (point pattern):", cell.size*2))}
    }
    
    if(class(obj)=="SpatialLinesDataFrame"){
    require(spatstat)
    x <- as(as(obj[field], "SpatialLines"), "psp")
    nd <- nndist.psp(x)  # this can be time consuming!
    ndb <- boxplot(nd, plot=FALSE)
    cell.size <- signif(ndb$stats[3]/2, 2)
    if(silent==FALSE){message(paste("Estimated nearest neighbour distance (line segments):", cell.size*2))}
    }
    
    if(class(obj)=="SpatialPolygonsDataFrame"){
    x <- sapply(obj@polygons, slot, "area")
    cell.size <- signif(sqrt(median(x))/2, 2)
    if(silent==FALSE){message(paste("Estimated median polygon size:", cell.size*2))}
    }
    }
    
    x <- GridTopology(cellcentre.offset=bbox[,1], cellsize=c(cell.size,cell.size), cells.dim=c(round(abs(diff(bbox[1,])/cell.size), 0), ncols=round(abs(diff(bbox[2,])/cell.size), 0)))
    r.sp <- SpatialGrid(x, proj4string = obj@proj4string)
    r <- raster(r.sp)
    # convert factors to integers:
    if(is.factor(obj@data[,field])){
       obj@data[,field] <- as.integer(obj@data[,field])
    }
    # rasterize - convert vector to raster map:    
    in.r <- rasterize(obj, r, field = field)
    res <- as(in.r, "SpatialGridDataFrame")
    names(res) = field
    
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