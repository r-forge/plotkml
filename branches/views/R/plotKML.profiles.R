plotKML.profiles <-
function(SPDF, ID, hor.name, upperdepth.name, lowerdepth.name, LON, LAT, file.name, max.depth, plot.points, altitudeMode, extrude, tessellate, x.scale, x.min, z.scale, LabelScale, icon, icon.url, IconColor, tilt, heading, roll, kmz){
require(Rcompression)
# SPDF = SpatialPointsDataFrame with a complete proj4 string;
# hor.name = name of the target variable (in format x_A, x_B);
# LON/LAT = longitude / latitude column names;
# DEPTH = depth column in cm!;
# fill.col = fill color for polygon in FGBR format;
# x.scale = scaling factor in X direction;
if(class(SPDF)[1]=="SpatialPointsDataFrame"){ #1
if(!is.na(proj4string(SPDF))){  #2
if(!proj4string(SPDF)=="+proj=longlat +datum=WGS84"){ #3
warning('projected to "+proj=longlat +datum=WGS84"')
SPDF <- spTransform(SPDF, CRS("+proj=longlat +datum=WGS84"))
}
if(missing(LON)) { LON <- coordinates(SPDF)[,1] }
if(missing(LAT)) { LAT <- coordinates(SPDF)[,2] }
if(missing(ID)) { ID <- 1:length(SPDF@data[,hor.name]) }
if(missing(file.name)) { file.name <- hor.name }
if(missing(altitudeMode)) { altitudeMode <- "relativeToGround" }
if(missing(icon)) { icon <- "donut.png" }
if(missing(icon.url)) { icon.url <- "http://maps.google.com/mapfiles/kml/shapes/" }
if(missing(IconColor)) { IconColor <- "ff0000ff" }
if(missing(LabelScale)) { LabelScale <- 0.5 }
if(missing(plot.points)) { plot.points <- TRUE }
if(missing(IconColor)) { IconColor <- "ff0000ff" }
if(missing(z.scale)) { z.scale <- 1 }
if(missing(x.scale)) { x.scale <- 1e-4 }
if(missing(x.min)) { x.min <- 0 } 
if(missing(tilt)) { tilt <- 90 }
if(missing(heading)) { heading <- 0 }
if(missing(roll)) { roll <- 0 }
if(missing(max.depth)) { max.depth <- 300 }
if(missing(extrude)) { extrude <- 1 }
if(missing(tessellate)) { tessellate <- 1 }
# if(missing(fill.col)) { fill.col <- rep("ff0000ff", nrow(SPDF@data)) }
if(missing(kmz)) { kmz <- FALSE }
# select all columns at different depths:
sel <- grep(names(SPDF@data), pattern=hor.name)
sel.names <- sort(names(SPDF@data)[sel])
selu <- grep(names(SPDF@data), pattern=upperdepth.name)
selu.names <- sort(names(SPDF@data)[selu])
sell <- grep(names(SPDF@data), pattern=lowerdepth.name)
sell.names <- sort(names(SPDF@data)[sell])
# write measured horizons as polygons:
filename <- file(paste(file.name, ".kml", sep=""), "w")
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", filename)
write(paste('<kml xmlns=\"', kml.url, '\">', sep=""), filename, append = TRUE)
write("<Document>", filename, append = TRUE)
write(paste("<name>Profile plot: ", hor.name, "</name>", sep=""), filename, append = TRUE)
write("<open>1</open>", filename, append = TRUE)
print('writing points to KML file')
### create a progress bar:
pb <- txtProgressBar(min=0, max=length(SPDF@data[[1]]), style=3)
if(plot.points==TRUE){
# for each site:
for (i in 1:nrow(SPDF@data)) {
# mask out the NA horizons:
prof.na <- which(!is.na(SPDF@data[i,sel.names]))
for(j in prof.na){ 
write(paste('  <Style id="','pnt', i, '_', j,'">',sep=""), filename, append = TRUE)
write("    <LabelStyle>", filename, append = TRUE)     
write(paste('     <scale>', LabelScale, '</scale>', sep=""), filename, append = TRUE)
write("    </LabelStyle>", filename, append = TRUE)
write("		<IconStyle>", filename, append = TRUE)
write(paste('  <color>', IconColor, '</color>', sep=""), filename, append = TRUE)
write(paste("			<scale>", LabelScale, "</scale>", sep=""), filename, append = TRUE)  
write("			<Icon>", filename, append = TRUE)
write(paste('				<href>', icon.url, icon, '</href>', sep=""), filename, append = TRUE)             
write("			</Icon>", filename, append = TRUE)
write("		</IconStyle>", filename, append = TRUE)
write("	</Style>", filename, append = TRUE)
} }
write("<Folder>", filename, append = TRUE)
for (i in 1:nrow(SPDF@data)) {
write("<name>measured</name>", filename, append = TRUE)
# mask out the NA horizons:
prof.na <- which(!is.na(SPDF@data[i,sel.names]))
for(j in prof.na){
  write("  <Placemark>", filename, append = TRUE)
  write(paste("  <name>", signif(SPDF@data[i,sel.names[j]], 3), "</name>", sep=""), filename, append = TRUE)
  write(paste("  <styleUrl>#pnt", i, "_", j,"</styleUrl>", sep=""), filename, append = TRUE)
  write("    <Point>", filename, append = TRUE)
  write("    <extrude>1</extrude>", filename, append = TRUE)
write(paste("      <altitudeMode>", altitudeMode, "</altitudeMode>", sep=""), filename, append = TRUE)
  write(paste("      <coordinates>", LON[i]+x.scale*(SPDF@data[i,sel.names[j]]-x.min), ",", LAT[i], ",", max.depth - (SPDF@data[i,selu.names[j]]+(SPDF@data[i,sell.names[j]]-SPDF@data[i,selu.names[j]])/2), "</coordinates>", sep=""), filename, append = TRUE)
  write("    </Point>", filename, append = TRUE)
  write(" </Placemark>", filename, append = TRUE)
}  }
write("</Folder>", filename, append = TRUE)
}
# write each site:
write("<Folder>", filename, append = TRUE)
for (i in 1:nrow(SPDF@data)) {
write("  <Placemark>", filename, append = TRUE)
write(paste("    <name>", SPDF@data[i,ID], "</name>", sep=""), filename, append = TRUE)
write("  <visibility>1</visibility>", filename, append = TRUE)
write("    <Polygon>", filename, append = TRUE)
write(paste(' 			<tessellate>', tessellate, '</tessellate>', sep=""), filename, append = TRUE)
write(paste("      <altitudeMode>", altitudeMode, "</altitudeMode>", sep=""), filename, append = TRUE)
write("      <outerBoundaryIs>", filename, append = TRUE)
write("        <LinearRing>", filename, append = TRUE)
# write points in the polygon:
write("          <coordinates>", filename, append = TRUE)
# write coordinates as polygons:
for(j in prof.na){
write(paste("              ", LON[i]+x.scale*(SPDF@data[i,sel.names[j]]-x.min),",", LAT[i],",", max.depth-SPDF@data[i,selu.names[j]], sep=""), filename, append = TRUE)  # upper horizon border
write(paste("              ", LON[i]+x.scale*(SPDF@data[i,sel.names[j]]-x.min),",", LAT[i],",", max.depth-SPDF@data[i,sell.names[j]], sep=""), filename, append = TRUE)  # lower horizon border
}
# close the polygon:
write(paste("              ", LON[i],",", LAT[i],",", max.depth-SPDF@data[i,sell.names[j]], sep=""), filename, append = TRUE)  # last point
write(paste("              ", LON[i],",", LAT[i],",", max.depth, sep=""), filename, append = TRUE)  # origin
write(paste("              ", LON[i]+x.scale*(SPDF@data[i,sel.names[1]]-x.min),",", LAT[i],",", max.depth-SPDF@data[i,selu.names[1]], sep=""), filename, append = TRUE) 
write("          </coordinates>", filename, append = TRUE)
write("        </LinearRing>", filename, append = TRUE)
write("      </outerBoundaryIs>", filename, append = TRUE)
write("    </Polygon>", filename, append = TRUE)
write("  </Placemark>", filename, append = TRUE)
# update progress bar
setTxtProgressBar(pb, i)
}
write("</Folder>", filename, append = TRUE)
write("   <Camera>", filename, append = TRUE)
write(paste('      <longitude>', LON[1], '</longitude>', sep=""), filename, append = TRUE) 
write(paste('      <latitude>', LAT[1]-0.01, '</latitude>', sep=""), filename, append = TRUE) 
write(paste('        <altitude>', max.depth, '</altitude>', sep=""), filename, append = TRUE) 
write(paste('        <heading>', heading, '</heading>', sep=""), filename, append = TRUE) 
write(paste('        <tilt>', tilt, '</tilt>', sep=""), filename, append = TRUE) 
write(paste('        <roll>', roll, '</roll>', sep=""), filename, append = TRUE) 
write(" </Camera>", filename, append = TRUE)
write("</Document>", filename, append = TRUE)
write("</kml>", filename, append = TRUE)
close(pb)
close(filename)
if(kmz==TRUE){
unlink(paste(file.name, ".kmz", sep=""))
zip(paste(file.name, ".kmz", sep=""), paste(file.name, ".kml", sep=""))
unlink(paste(file.name, ".kml", sep="")) 
}
}
else { stop("proj4 string required") } } 
else { stop("first argument should be of class SPDF") } 
}

