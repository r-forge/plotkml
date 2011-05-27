write.grid2gif.KML <-
function(SGDF, var.name, var.type, file.name, col.pal, above.ground, altitudeMode, make.legend, make.kml, z.lim) {
# Writes a SGDF to ground overlay 
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(!is.na(proj4string(SGDF))){  #2
if(!proj4string(SGDF)=="+proj=longlat +datum=WGS84"){ #3
if(min(SGDF@data[,var.name], na.rm=TRUE)>-1&max(SGDF@data[,var.name], na.rm=TRUE)<256){
# if all requirements are met, proceed with conversion
if(missing(var.type)) { var.type <- "numeric" }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(make.legend)) { make.legend <- FALSE }
if(missing(make.kml)) { make.kml <- FALSE }
if(missing(file.name)) { file.name <- var.name }
if(missing(col.pal)) { col.no <- 48; col.pal <-  c(grey(0), rev(rainbow(65)[1:col.no]), rep(grey(1), 256-col.no))  }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(z.lim)&var.type=="numeric") { z.lim <- c(quantile(SGDF@data[,var.name], 0.025, na.rm=TRUE), quantile(SGDF@data[,var.name], 0.975, na.rm=TRUE)) }
# write a GIF:
write.gif(image=t(as.matrix(SGDF[var.name])), filename=paste(file.name, "_ll.gif", sep=""), col=col.pal, transparent=0)
# write a KML file:
if(make.kml==TRUE){
filename <- file(paste(file.name, "_gif.kml", sep=""), "w")
write('<?xml version="1.0" encoding="UTF-8"?>', file=filename)
write('<kml xmlns="http://www.opengis.net/kml/2.2">', filename, append = TRUE)
write('<Document>', filename, append = TRUE)
write(paste('<name>', file.name, '</name>', sep=""), filename, append = TRUE)
write('<GroundOverlay>', filename, append = TRUE)
write(paste('<name>Ground overlay: ', file.name, '</name>', sep=""), filename, append = TRUE)
if(var.type=="numeric"){
write(paste('<description>Values range: ', signif(z.lim[1], 2),' to ', signif(z.lim[2], 2),'</description>', sep=""), filename, append = TRUE)
}
else {
write(paste('<description>Levels: ', length(col.pal), '</description>', sep=""), filename, append = TRUE)
}
write(paste('<altitude>', above.ground, '</altitude>', sep=""), filename, append = TRUE) 
write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', file.name, "_ll.gif", '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write('<LatLonBox>', filename, append = TRUE)
write(paste('<north>', SGDF@bbox[2,2], '</north>', sep=""), filename, append = TRUE)
write(paste('<south>', SGDF@bbox[2,1], '</south>', sep=""), filename, append = TRUE)
write(paste('<east>', SGDF@bbox[1,2], '</east>', sep=""), filename, append = TRUE)
write(paste('<west>', SGDF@bbox[1,1], '</west>', sep=""), filename, append = TRUE)
write('</LatLonBox>', filename, append = TRUE)
write('</GroundOverlay>', filename, append = TRUE)
if(make.legend==TRUE) {
if(is.factor(SGDF@data[,var.name])|var.type=="factor"){
write.legend.gif(x=SGDF, var.type="factor", var.name=var.name, legend.file.name=paste(file.name, '_legend.png', sep=""), legend.pal=col.pal)
}
else { 
write.legend.gif(x=SGDF, var.name=var.name, legend.file.name=paste(file.name, '_legend.png', sep=""), legend.pal=col.pal, z.lim=z.lim)
}
}
write('<ScreenOverlay>', filename, append = TRUE)
write('<name>Legend</name>', filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', file.name, '_legend.png</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write(paste('<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<size x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write('</ScreenOverlay>', filename, append = TRUE)
write('</Document>', filename, append = TRUE)
write('</kml>', filename, append = TRUE)
close(filename) 
}
}
else { stop("values must be in range 0:255") }  
}
else { stop("proj4 +proj=longlat +datum=WGS84 required") } 
}
else { stop("proj4 string required") }
}
else { stop("first argument should be of class SGDF") } 
}

