plotKML.soilblock <-
function(SPDF, ID, LON, LAT, which.record, soil.cols, pedon.size, x.min, hor.name, upperdepth.name, lowerdepth.name, plot.points, file.name, max.depth, altitudeMode, z.scale, LabelScale, IconScale, Linewidth, tilt, heading, roll, icon, icon.url, IconColor, kmz){ 
# SPDF = SpatialPointsDataFrame with a complete proj4 string - should contain one point only!
# hor.name = name of the target variable (in format x_A, x_B);
# which.record = which record you wont to plot?
# LON/LAT = longitude / latitude column names;
# upperdepth / lowedepth = depth columns in cm!;
# soil.cols = name of the column with fill color for polygons in FGBR format;
# x.scale = scaling factor in X direction;
# pedon.size = size of block - 3rcsec or 100 by 100 m;
if(class(SPDF)[1]=="SpatialPointsDataFrame"){ #1
if(!is.na(proj4string(SPDF))){  #2
if(!proj4string(SPDF)=="+proj=longlat +datum=WGS84"){ #3
warning('projected to "+proj=longlat +datum=WGS84"')
SPDF <- spTransform(SPDF, CRS("+proj=longlat +datum=WGS84"))
}
if(missing(soil.cols)) { colorMode <- "random" } else { colorMode <- "normal" }
if(missing(which.record)) { which.record <- 1 }
if(missing(LON)) { LON <- coordinates(SPDF)[which.record,1] }
if(missing(LAT)) { LAT <- coordinates(SPDF)[which.record,2] }
if(missing(ID)) { ID <- "GSSN" }
if(missing(file.name)) { file.name <- hor.name }
if(missing(altitudeMode)) { altitudeMode <- "absolute" }
if(missing(icon)) { icon <- "donut.png" }
if(missing(icon.url)) { icon.url <- "http://maps.google.com/mapfiles/kml/shapes/" }
if(missing(IconColor)) { IconColor <- "ff0000ff" }
if(missing(LabelScale)) { LabelScale <- 0.5 }
if(missing(IconScale)) { IconScale <- 0.3 }
if(missing(Linewidth)) { Linewidth <- 2 }
if(missing(plot.points)) { plot.points <- TRUE }
if(missing(IconColor)) { IconColor <- "ff0000ff" }
if(missing(pedon.size)) { pedon.size <- 3/3600 }
if(missing(x.min)) { x.min <- pedon.size/100 }
if(missing(z.scale)) { z.scale <- 1 }
if(missing(tilt)) { tilt <- 60 }
if(missing(heading)) { heading <- 180 }
if(missing(roll)) { roll <- 0 }
if(missing(max.depth)) { max.depth <- 300 }
if(missing(kmz)) { kmz <- FALSE }
# select all columns at different depths:
sel <- grep(names(SPDF@data), pattern=hor.name)
sel.names <- sort(names(SPDF@data)[sel])
selu <- grep(names(SPDF@data), pattern=upperdepth.name)
selu.names <- sort(names(SPDF@data)[selu])
sell <- grep(names(SPDF@data), pattern=lowerdepth.name)
sell.names <- sort(names(SPDF@data)[sell])
selc <- grep(names(SPDF@data), pattern=soil.cols)
selc.names <- sort(names(SPDF@data)[selc])
# write measured horizons as voxels:
filename <- file(paste("soilblock_", file.name, ".kml", sep=""), "w")
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", filename)
write(paste('<kml xmlns=\"', kml.url, '\">', sep=""), filename, append = TRUE)
write("<Document>", filename, append = TRUE)
write(paste("<name>Profile voxel: ", hor.name, "</name>", sep=""), filename, append = TRUE)
write("<open>1</open>", filename, append = TRUE)
print('writing points to KML file')
# mask out the NA horizons:
hor.no <- which(!is.na(SPDF@data[which.record,sel.names]))
### create a progress bar:
pb <- txtProgressBar(min=0, max=length(hor.no), style=3)
for(j in hor.no){
if(plot.points==TRUE){
# style for points: 
write(paste('  <Style id="','pnt', which.record, '_', j,'">',sep=""), filename, append = TRUE)
write("    <LabelStyle>", filename, append = TRUE)     
write(paste('     <scale>', LabelScale, '</scale>', sep=""), filename, append = TRUE)
write("    </LabelStyle>", filename, append = TRUE)
write("		<IconStyle>", filename, append = TRUE)
write(paste('  <color>', IconColor, '</color>', sep=""), filename, append = TRUE)
write(paste('			<scale>', IconScale, '</scale>', sep=""), filename, append = TRUE)  
write("			<Icon>", filename, append = TRUE)
write(paste('				<href>', icon.url, icon, '</href>', sep=""), filename, append = TRUE)             
write("			</Icon>", filename, append = TRUE)
write("		</IconStyle>", filename, append = TRUE)
write("	</Style>", filename, append = TRUE)
}
# style for blocks:
write(paste('  <Style id="','pol', which.record, '_', j,'">',sep=""), filename, append = TRUE)  
write("    <LineStyle>", filename, append = TRUE)
write(paste('        <width>', Linewidth, '</width>', sep=""), filename, append = TRUE)
write("      </LineStyle>", filename, append = TRUE)
write("      <PolyStyle>", filename, append = TRUE)
if(colorMode=="random") {
write(paste('        <colorMode>', colorMode, '</colorMode>', sep=""), filename, append = TRUE)  
write("        <color>ffffffff</color>", filename, append = TRUE)
}
else {        
write(paste('      <color>', SPDF@data[which.record,selc.names[j]], '</color>', sep=""), filename, append = TRUE)  
}
write("      </PolyStyle>", filename, append = TRUE)
write("    </Style>", filename, append = TRUE)
# update progress bar
setTxtProgressBar(pb, j)
}
write("<Folder>", filename, append = TRUE)
write("<name>soil profile</name>", filename, append = TRUE)
# mask out the NA horizons:
for(j in hor.no){
if(plot.points==TRUE){
# add values of the target variable at the center of the horizon:
write("  <Placemark>", filename, append = TRUE)
write(paste("  <name>", signif(SPDF@data[which.record,sel.names[j]], 3), "</name>", sep=""), filename, append = TRUE)
write(paste("  <styleUrl>#pnt", which.record, "_", j,"</styleUrl>", sep=""), filename, append = TRUE)
write("    <Point>", filename, append = TRUE)
write("    <extrude>0</extrude>", filename, append = TRUE)
write(paste("      <altitudeMode>", altitudeMode, "</altitudeMode>", sep=""), filename, append = TRUE)
write(paste("      <coordinates>", LON, ",", LAT+((pedon.size/2)*sqrt(2)+x.min), ",", max.depth - (SPDF@data[which.record,selu.names[j]]+(SPDF@data[which.record,sell.names[j]]-SPDF@data[which.record,selu.names[j]])/2), "</coordinates>", sep=""), filename, append = TRUE) # center of horizon
write("    </Point>", filename, append = TRUE)
write(" </Placemark>", filename, append = TRUE)
}
# Horizons as polygons (fill color is the true soil color):
write("  <Placemark>", filename, append = TRUE)
write("  <visibility>1</visibility>", filename, append = TRUE)
write(paste("  <styleUrl>#pol", which.record, "_", j,"</styleUrl>", sep=""), filename, append = TRUE)
write("    <Polygon>", filename, append = TRUE)
write(" 			<tessellate>1</tessellate>", filename, append = TRUE)
write(paste("      <altitudeMode>", altitudeMode, "</altitudeMode>", sep=""), filename, append = TRUE)
write("      <outerBoundaryIs>", filename, append = TRUE)
write("        <LinearRing>", filename, append = TRUE)
write("          <coordinates>", filename, append = TRUE)
write(paste("              ", LON-pedon.size/2,",", LAT+((pedon.size/2)*sqrt(2)+x.min),",", max.depth-SPDF@data[which.record,selu.names[j]], sep=""), filename, append = TRUE)  # H point1
write(paste("              ", LON+pedon.size/2,",", LAT+((pedon.size/2)*sqrt(2)+x.min),",", max.depth-SPDF@data[which.record,selu.names[j]], sep=""), filename, append = TRUE)  # H point2
write(paste("              ", LON+pedon.size/2,",", LAT+((pedon.size/2)*sqrt(2)+x.min),",", max.depth-SPDF@data[which.record,sell.names[j]], sep=""), filename, append = TRUE)  # H point3
write(paste("              ", LON-pedon.size/2,",", LAT+((pedon.size/2)*sqrt(2)+x.min),",", max.depth-SPDF@data[which.record,sell.names[j]], sep=""), filename, append = TRUE)  # H point4
# close the polygon:
write(paste("              ", LON-pedon.size/2,",", LAT+((pedon.size/2)*sqrt(2)+x.min),",", max.depth-SPDF@data[which.record,selu.names[j]], sep=""), filename, append = TRUE)  # H point1
write("          </coordinates>", filename, append = TRUE)
write("        </LinearRing>", filename, append = TRUE)
write("      </outerBoundaryIs>", filename, append = TRUE)
write("    </Polygon>", filename, append = TRUE)
write("  </Placemark>", filename, append = TRUE)
}
# 100 x 100 m block at the center of the profile:
write(" <Placemark>", filename, append = TRUE)
write(paste("    <name>", SPDF@data[which.record,ID], "</name>", sep=""), filename, append = TRUE)
write("  <visibility>1</visibility>", filename, append = TRUE)
write("    <Polygon>", filename, append = TRUE)
write(" 			<tessellate>1</tessellate>", filename, append = TRUE)
write("    <extrude>1</extrude>", filename, append = TRUE)
write(paste("      <altitudeMode>", altitudeMode, "</altitudeMode>", sep=""), filename, append = TRUE)
write("      <outerBoundaryIs>", filename, append = TRUE)
write("        <LinearRing>", filename, append = TRUE)
write("          <coordinates>", filename, append = TRUE)
write(paste("         ", LON-pedon.size/2,",", LAT-(pedon.size/2)*sqrt(2),",", max.depth, sep=""), filename, append = TRUE)  # p1
write(paste("         ", LON+pedon.size/2,",", LAT-(pedon.size/2)*sqrt(2),",", max.depth, sep=""), filename, append = TRUE)  # p2
write(paste("         ", LON+pedon.size/2,",", LAT+(pedon.size/2)*sqrt(2),",", max.depth, sep=""), filename, append = TRUE)  # p3
write(paste("         ", LON-pedon.size/2,",", LAT+(pedon.size/2)*sqrt(2),",", max.depth, sep=""), filename, append = TRUE)  # p4
# close the polygon:
write(paste("         ", LON-pedon.size/2,",", LAT-(pedon.size/2)*sqrt(2),",", max.depth, sep=""), filename, append = TRUE)  # p1
write("          </coordinates>", filename, append = TRUE)
write("        </LinearRing>", filename, append = TRUE)
write("      </outerBoundaryIs>", filename, append = TRUE)
write("    </Polygon>", filename, append = TRUE)
write("  </Placemark>", filename, append = TRUE)
write("</Folder>", filename, append = TRUE)
write("   <Camera>", filename, append = TRUE)
write(paste('      <longitude>', LON[1], '</longitude>', sep=""), filename, append = TRUE) 
write(paste('      <latitude>', LAT[1]+0.008, '</latitude>', sep=""), filename, append = TRUE) 
write(paste('        <altitude>', 1.8*max.depth, '</altitude>', sep=""), filename, append = TRUE) 
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

