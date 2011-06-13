plotKML.bubble <-
function(SPDF, var.name, LON, LAT, file.name, icon, icon.url, plt.size, plt.size0, IconColor, altitudeMode, above.ground, extrude, z.scale, LabelScale, signif.digits, TimeSpan.begin, TimeSpan.end, kmz){
if(class(SPDF)[1]=="SpatialPointsDataFrame"){ #1
if(!is.na(proj4string(SPDF))){  #2
if(!(proj4string(SGDF)=="+proj=longlat +datum=WGS84"|proj4string(SGDF)==" +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")){ #3
warning('projected to "+proj=longlat +datum=WGS84"')
SPDF <- spTransform(SPDF, CRS("+proj=longlat +datum=WGS84"))
if(missing(LON)) { LON <- coordinates(SPDF)[,1] }
if(missing(LAT)) { LAT <- coordinates(SPDF)[,2] }
if(missing(file.name)) { file.name <- paste(var.name, "_bubble_plot", sep="") }
if(missing(icon)) { icon <- "donut.png" }
if(missing(icon.url)) { icon.url <- "http://maps.google.com/mapfiles/kml/shapes/" }
if(missing(plt.size)) { plt.size <- 2 }
if(missing(plt.size0)) { plt.size0 <- 0.3 }
if(missing(altitudeMode)) { altitudeMode <- "absolute" }
if(missing(above.ground)) { above.ground <- rep(10, length(SPDF@data[,var.name])) }
if(missing(z.scale)) { z.scale <- 1 }
if(missing(extrude)) { extrude <- 1 }
if(missing(LabelScale)) { LabelScale <- 0.7 }
if(missing(signif.digits)) { signif.digits <- 3 }
if(missing(IconColor)) { IconColor <- rep("ff0000ff", length(SPDF@data[,var.name])) }
if(missing(kmz)) { kmz <- FALSE }
# maximum value:
if(is.numeric(SPDF@data[,var.name])){
maxvar <- max(SPDF@data[,var.name], na.rm=TRUE)
}
filename <- file(paste(file.name, ".kml", sep=""), "w",  blocking=FALSE)
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", filename)
write(paste('<kml xmlns=\"', kml.url, '\">', sep=""), filename, append = TRUE)
write("<Document>", filename, append = TRUE)
write(paste("<name>", var.name, "</name>", sep=""), filename, append = TRUE)
write("<open>1</open>", filename, append = TRUE)
for (i in 1:length(SPDF@data[[1]])) {
  write(paste('  <Style id="','pnt', i,'">',sep=""), filename, append = TRUE)
  write("    <LabelStyle>", filename, append = TRUE)     
  write(paste('     <scale>', LabelScale, '</scale>', sep=""), filename, append = TRUE)
  write("    </LabelStyle>", filename, append = TRUE)
  write("		<IconStyle>", filename, append = TRUE)
  write(paste('  <color>', IconColor[i], '</color>', sep=""), filename, append = TRUE)
if(!is.numeric(SPDF@data[,var.name])) { 
  write(paste("			<scale>", plt.size, "</scale>", sep=""), filename, append = TRUE)
  }
  else {
  write(paste("			<scale>", SPDF@data[i,var.name]/maxvar*plt.size+plt.size0, "</scale>", sep=""), filename, append = TRUE)  }
  write("			<Icon>", filename, append = TRUE)
  write(paste('				<href>', icon.url, icon, '</href>', sep=""), filename, append = TRUE)
  write("			</Icon>", filename, append = TRUE)
  write("		</IconStyle>", filename, append = TRUE)
  write("	</Style>", filename, append = TRUE)
}
write("<Folder>", filename, append = TRUE)
write(paste("<name>", icon, " icon for ", var.name,"</name>", sep=""), filename, append = TRUE)
print('writing points to KML file')
### create a progress bar:
pb <- txtProgressBar(min=0, max=length(SPDF@data[[1]]), style=3)
for (i in 1:length(SPDF@data[[1]])) {
  write("  <Placemark>", filename, append = TRUE)
if(is.numeric(SPDF@data[,var.name])){
  write(paste("  <name>", signif(SPDF@data[i,var.name], signif.digits),"</name>", sep=""), filename, append = TRUE)
} else {
    write(paste("  <name>", SPDF@data[i,var.name], "</name>", sep=""), filename, append = TRUE)
}
  write(paste("  <styleUrl>#pnt",i,"</styleUrl>", sep=""), filename, append = TRUE)
  if(!missing(TimeSpan.begin)&!missing(TimeSpan.end)) { 
  write('    <TimeSpan>', filename, append=TRUE)
  write(paste('   <begin>', TimeSpan.begin[i],'</begin>',sep=""), filename, append=TRUE)
  write(paste('   <end>', TimeSpan.end[i],'</end>',sep=""), filename, append=TRUE)
  write('    </TimeSpan>', filename, append=TRUE) 
  }
  write("    <Point>", filename, append = TRUE)
  if(sd(above.ground, na.rm=TRUE)>0) {
  write(paste('    <extrude>', extrude, '</extrude>', sep=""), filename, append = TRUE)
  write(paste('    <altitudeMode>', altitudeMode, '</altitudeMode>', sep=""), filename, append = TRUE)
  }
  write(paste("      <coordinates>",LON[i],",",LAT[i],",",above.ground[i]*z.scale,"</coordinates>", sep=""), filename, append = TRUE)
  write("    </Point>", filename, append = TRUE)
  write("    </Placemark>", filename, append = TRUE)
# update progress bar
setTxtProgressBar(pb, i)
}
write("</Folder>", filename, append = TRUE)
write("</Document>", filename, append = TRUE)
write("</kml>", filename, append = TRUE)
close(pb)
close(filename)
if(kmz==TRUE){
unlink(paste(file.name, ".kmz", sep=""))
zip(paste(file.name, ".kmz", sep=""), paste(file.name, ".kml", sep=""))
unlink(paste(file.name, ".kml", sep="")) }
}
else { stop("proj4 string required") } } }
else { stop("first argument should be of class SPDF") } 
}

