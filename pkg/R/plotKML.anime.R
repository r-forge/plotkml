plotKML.anime <-
function(SGDF, var.list, file.name, z.lim, col.pal, above.ground, imageMagick, mvFlag, r.method, make.legend, kml.legend, altitudeMode, FWTools, make.kml, im.delay, im.loop, TimeSpan.begin, TimeSpan.end, kmz){
# SGDF = SpatialGridDataFrame with a complete proj4 string;
# var.list = list of grids of interest for visualization;
# zlim = upper and lower limits of interest for visualization e.g. c(0,1)
# imageMagick = should all gifs be put into a single file?;
# above.ground = could be a single number or a vector of depths;
if(class(SGDF)[1]=="SpatialGridDataFrame"){ #1
if(!is.na(proj4string(SGDF))){  #2
if(missing(mvFlag)) { mvFlag <- -99999 }
if(missing(z.lim)) { z.lim <- c(quantile(SGDF@data[,var.list[1]], 0.025, na.rm=TRUE), quantile(SGDF@data[,var.list[1]], 0.975, na.rm=TRUE)) }
if(missing(r.method)) { r.method <- "bilinear" }
if(missing(above.ground)) { above.ground <- rep(10, length(var.list)) }
if(missing(FWTools)) { FWTools <- FALSE }
if(missing(imageMagick)) { imageMagick <- FALSE }
if(missing(im.delay)) { im.delay <- 80 }
if(missing(im.loop)) { im.loop <- 0 }
if(missing(file.name)) { file.name <- var.name }
if(missing(make.kml)) { make.kml <- TRUE }
if(missing(kml.legend)) { kml.legend <- TRUE }
if(missing(altitudeMode)) { altitudeMode <- "clampToGround" }
if(missing(above.ground)) { above.ground <- 10 }
if(missing(col.pal)) { col.no <- 48; col.pal <- rev(rainbow(65)[1:col.no]) }
col.no <- length(col.pal)
gif.pal <- c(grey(0), col.pal, rep(grey(1), 256-col.no)) # add colors for transparent pixels and undefined values
if(missing(kmz)) { kmz <- FALSE }
# export maps to GIF in a loop:
pb <- txtProgressBar(min=0, max=length(var.list), style=3)
for(i in 1:length(var.list)){
# reproject to WGS84 system if necessary:
if(!check_projection(SGDF)){ #3
SGDF.ll <- reproject.grid(SGDF=SGDF, var.name=var.list[i], file.name=file.name, mvFlag=mvFlag, FWTools=FWTools, r.method=r.method)
# warning('projected to "+proj=longlat +datum=WGS84"')
}
else { SGDF.ll <- SGDF }
# code the values
breaks.var <- c(-99999, seq(from=z.lim[1], to=z.lim[2], length.out=col.no-1), max(SGDF@data[,var.list[i]], na.rm=TRUE)+sd(SGDF.ll@data[,var.list[i]], na.rm=TRUE)/col.no)
SGDF.ll$mask <- as.integer(cut(SGDF.ll@data[,var.list[i]], breaks=breaks.var, include.lowest=TRUE))
SGDF.ll$mask <- ifelse(is.na(SGDF.ll$mask), 0, SGDF.ll$mask)
write.grid2gif.KML(SGDF=SGDF.ll, var.name="mask", file.name=var.list[i], z.lim=z.lim, col.pal=gif.pal, above.ground=above.ground, altitudeMode=altitudeMode, make.legend=FALSE, make.kml=FALSE)
setTxtProgressBar(pb, i)
}
close(pb)
# write legend separately:
if(kml.legend==TRUE){
write.legend.gif(x=SGDF.ll, var.name=var.list[1], var.type="numeric", legend.file.name=paste(var.list[1], "_legend.png", sep=""), legend.pal=col.pal, z.lim=z.lim)
}
# make a KML:
if(make.kml==TRUE){
if(imageMagick==TRUE){
# put all gifs into a single file:
gif.list <- paste(var.list, "_ll.gif", sep="")
# for scripting possibilities see [http://www.imagemagick.org/Usage/anim_basics/];
system(paste(im.convert, ' ', paste(gif.list, collapse=" ", sep=""), ' -delay ', im.delay, ' -dispose Background -loop ', im.loop, ' ', file.name, '_ani.gif', sep=""))
system(paste(im.identify, ' ', file.name, '_ani.gif', sep=""))
# write a KML:
filename <- file(paste(file.name, "_ani.kml", sep=""), "w")
write('<?xml version="1.0" encoding="UTF-8"?>', file=filename)
write('<kml xmlns="http://www.opengis.net/kml/2.2">', filename, append = TRUE)
write('<Document>', filename, append = TRUE)
write(paste('<name>', file.name, '</name>', sep=""), filename, append = TRUE)
write('<GroundOverlay>', filename, append = TRUE)
write(paste('<name>Animated gif: ', file.name, '</name>', sep=""), filename, append = TRUE)
write('<description>', filename, append = TRUE)
write("  <![CDATA[", filename, append = TRUE)
write(paste('Values range: ', signif(z.lim[1], 2),' to ', signif(z.lim[2], 2), sep=""), filename, append = TRUE) 
write(paste('<img align="bottom" alt="animated gif" src="',  file.name, '_ani.gif">', sep=""), filename, append = TRUE)  
write("  ]]>", filename, append = TRUE)
write('</description>', filename, append = TRUE)
write(paste('<altitude>', above.ground[1], '</altitude>', sep=""), filename, append = TRUE) 
write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>',  file.name, '_ani.gif', '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write('<LatLonBox>', filename, append = TRUE)
write(paste('<north>', SGDF.ll@bbox[2,2], '</north>', sep=""), filename, append = TRUE)
write(paste('<south>', SGDF.ll@bbox[2,1], '</south>', sep=""), filename, append = TRUE)
write(paste('<east>', SGDF.ll@bbox[1,2], '</east>', sep=""), filename, append = TRUE)
write(paste('<west>', SGDF.ll@bbox[1,1], '</west>', sep=""), filename, append = TRUE)
write('</LatLonBox>', filename, append = TRUE)
write('</GroundOverlay>', filename, append = TRUE)
if(kml.legend==TRUE) {
write('<ScreenOverlay>', filename, append = TRUE)
write('<name>Legend</name>', filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', var.list[1], '_legend.png', '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write(paste('<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<size x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write('</ScreenOverlay>', filename, append = TRUE)
}
write('</Document>', filename, append = TRUE)
write('</kml>', filename, append = TRUE)
close(filename) 
}
else { 
# write a with a list of maps:
if(missing(TimeSpan.begin)) { TimeSpan.begin <- 1:length(var.list) }
if(missing(TimeSpan.end)) { TimeSpan.end <- (1:length(var.list))+1 }
filename <- file(paste(file.name, "_ani.kml", sep=""), "w")
write('<?xml version="1.0" encoding="UTF-8"?>', file=filename)
write('<kml xmlns="http://www.opengis.net/kml/2.2">', filename, append = TRUE)
write('<Document>', filename, append = TRUE)
write('<Folder>', filename, append = TRUE)
write(paste('<name>Time series: ', file.name, '</name>', sep=""), filename, append = TRUE)
write(paste('<description>Values range: ', signif(z.lim[1], 2),' to ', signif(z.lim[2], 2),'</description>', sep=""), filename, append = TRUE)
for(i in 1:length(var.list)){
write('<GroundOverlay>', filename, append = TRUE)
write(paste('   <name>',var.list[i],'</name>',sep=""), filename, append=TRUE)
write('    <TimeSpan>', filename, append=TRUE)
write(paste('   <begin>', TimeSpan.begin[i], '</begin>',sep=""), filename, append=TRUE)
write(paste('   <end>', TimeSpan.end[i], '</end>',sep=""), filename, append=TRUE)
write('    </TimeSpan>', filename, append=TRUE)
write(paste('<altitude>', above.ground[i], '</altitude>', sep=""), filename, append = TRUE) 
write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>',  gif.list[i], '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write('<LatLonBox>', filename, append = TRUE)
write(paste('<north>', SGDF.ll@bbox[2,2], '</north>', sep=""), filename, append = TRUE)
write(paste('<south>', SGDF.ll@bbox[2,1], '</south>', sep=""), filename, append = TRUE)
write(paste('<east>', SGDF.ll@bbox[1,2], '</east>', sep=""), filename, append = TRUE)
write(paste('<west>', SGDF.ll@bbox[1,1], '</west>', sep=""), filename, append = TRUE)
write('</LatLonBox>', filename, append = TRUE)
write('</GroundOverlay>', filename, append = TRUE)
}
if(kml.legend==TRUE) {
write('<ScreenOverlay>', filename, append = TRUE)
write('<name>Legend</name>', filename, append = TRUE)
write('<Icon>', filename, append = TRUE)
write(paste('<href>', var.list[1], '_legend.png', '</href>', sep=""), filename, append = TRUE)
write('</Icon>', filename, append = TRUE)
write(paste('<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write(paste('<size x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), filename, append = TRUE)
write('</ScreenOverlay>', filename, append = TRUE)
}
write('</Folder>', filename, append = TRUE)
write('</Document>', filename, append = TRUE)
write('</kml>', filename, append = TRUE)
close(filename)
} }
if(kmz==TRUE){
unlink(paste(file.name, "_ani.kml", sep=""))
zip(paste(file.name, "_ani.kmz", sep=""), paste(file.name, "_ani.kml", sep=""))
if(plot.type=="poly") { unlink(paste(file.name, "_ani.kml", sep="")) }
} }
else { stop("proj4 string required")  }   } 
else { stop("first argument should be of class SGDF") } 
}

