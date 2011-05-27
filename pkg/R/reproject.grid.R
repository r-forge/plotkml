reproject.grid <-
function(SGDF, var.name, file.name, mvFlag, FWTools, error.name, r.method, global.var) {
# FWTools is an external application but more suited for large grids
# error.name = estimated error of the target variable (0 if not specified otherwise);
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(missing(mvFlag)) { mvFlag <- -99999 }
if(missing(r.method)) { r.method <- "bilinear" }
if(missing(FWTools)) { FWTools <- FALSE }
if(missing(file.name)) { file.name <- var.name }
if(!is.na(proj4string(SGDF))){  #2
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84"){ #3
# distinguish between numeric and factor variables
if(is.factor(SGDF@data[,var.name])){
if(FWTools==TRUE){
SGDF@data[,"factor"] <- as.integer(SGDF@data[,var.name])
writeGDAL(SGDF["factor"], set.file.extension(file.name, ".tif"), "GTiff", mvFlag=mvFlag)
unlink(paste(file.name, "_ll.sdat", sep=""))
# reproject/resample using FWTools:
system(paste(gdalwarp, " ", file.name, ".tif ", file.name, "_ll.sdat -of \"SAGA\" -r near -s_srs \"", proj4string(SGDF), "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep="")) 
}
# reproject/resample using raster package:
SGDF.r <- raster(SGDF[var.name])
SGDF.r <- projectRaster(SGDF.r, crs="+proj=longlat +datum=WGS84", method="ngb") 
}
else { if(!missing(error.name)) { # if there is no error map then we assume that the map is perfect!
if(missing(global.var)&is.numeric(SGDF@data[,var.name])) { global.var <- var(SGDF@data[,var.name], na.rm=TRUE) }
SGDF@data[,var.name] <- ifelse(SGDF@data[,error.name]>global.var, NA, SGDF@data[,var.name])
}
if(FWTools==TRUE){
writeGDAL(SGDF[var.name], set.file.extension(file.name, ".tif"), "GTiff", mvFlag=mvFlag)
unlink(paste(file.name, "_ll.sdat", sep="")) 
system(paste(gdalwarp, " ", file.name, ".tif ", file.name, "_ll.sdat -of \"SAGA\" -r ", r.method, " -s_srs \"", proj4string(SGDF), "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep=""))
}
else { 
SGDF.r <- raster(SGDF[var.name])
SGDF.r <- projectRaster(SGDF.r, crs="+proj=longlat +datum=WGS84", method="bilinear") 
}
} 
# finished reprojecting
if(FWTools==TRUE) { 
SGDF.ll <- readGDAL(paste(file.name, "_ll.sdat", sep=""))
}
else { 
SGDF.ll <- as(SGDF.r, "SpatialGridDataFrame")
names(SGDF.ll) <- var.name
 } 
return(SGDF.ll)   }
else { warning('no reprojection required') } } 
else { stop("proj4 string required")  }   } 
else { stop("first argument should be of class SGDF") }  
}

