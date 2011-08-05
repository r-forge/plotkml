# Purpose        : Writing of "SoilProfileCollection" objects to KML
# Maintainer     : Dylan Beaudette (debeaudette@ucdavis.edu)
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : This file gathers the layer() methods. kml.compress(), kml.open() and kml.close() are in kml.utils.R

kml_layer.SoilProfileCollection <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  z.scale = 1,
  x.min = 0,  # intercept
  x.scale,
  LabelScale = 0.6,
  IconColor = "ff0000ff",
  shape = "http://plotkml.r-forge.r-project.org/circle.png",
  visibility = TRUE,
  tessellate = TRUE,
  camera.distance = .01,
  altitudeMode = "relativeToGround",
  var.name,
  tilt = 90, 
  heading = 0, 
  roll = 0,
  max.depth = 300,
  plot.points = TRUE,
  ...
  ){

  # Checking the projection is geo
#  check <- check_projection(obj@site, logical = TRUE) ## The @site slot HAS TO BE a SpatialPoints(DataFrame) class!

  # Trying to reproject data if the check was not successful
#  if (!check) { obj@site <- reproject(obj@site) }  ## TH: This would work for SPDF
  
#  LON <- coordinates(obj@site)[,1]
#  LAT <- coordinates(obj@site)[,2]  

### Temporary solution:
  
  LON <- obj@site[,1]
  LAT <- obj@site[,2]  

  if(missing(x.scale)) {   # scaling factor in x direction (estimate automatically)
     x.range <- range(do.call(rbind, lapply(obj@profiles, slot, "horizons"))[,var.name], na.rm=TRUE)
     x.scale <- 0.003/diff(x.range)
  if(missing(x.min)) {   x.min <- x.range[1]-diff(x.range)/100 }
  }

  # Parsing the call for aesthetics
  aes <- kml_aes(obj, ...)

  # Read the relevant aesthetics
  points_names <- aes[["labels"]]
  balloon <- aes[["balloon"]]
  ## TH : This view probably does not need many aestetics?

  # Open new folder
  cat('<Folder>\n', file = file, append = TRUE)
  cat('<name>', title, '</name>\n', sep = "", file = file, append = TRUE)

  if(plot.points==TRUE){
  # Writing points styles
  # =====================
    
    # for each site:
    for (i_site in 1:length(obj)) {
    # select columns of interest:
    sel <- grep(names(obj@profiles[[i_site]]@horizons), pattern=var.name)
    # mask out the NA horizons:
    prof.na <- which(!is.na(obj@profiles[[i_site]]@horizons[,sel]))
  
      if(length(prof.na)>0){
      for (i_pt in prof.na) {
      
      cat('\t<Style id="','pnt', i_site, '_', i_pt, '">\n',sep = "", file = file, append = TRUE)

      # Label
      cat('\t\t<LabelStyle>\n', file = file, append = TRUE)
      cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = file, append = TRUE)
      cat('\t\t</LabelStyle>\n', file = file, append = TRUE)

      # Icon
      cat('\t\t<IconStyle>\n', file = file, append = TRUE)

      # Aesthetics
      cat('\t\t\t<color>', IconColor, '</color>\n', sep = "", file = file, append = TRUE)
      cat('\t\t\t<scale>', LabelScale, '</scale>\n', sep = "", file = file, append = TRUE)
      cat('\t\t\t<Icon>\n', file = file, append = TRUE)
      cat('\t\t\t\t<href>', shape, '</href>\n', sep = "", file = file, append = TRUE)
      cat('\t\t\t</Icon>\n', file = file, append = TRUE)
      cat('\t\t</IconStyle>\n', file = file, append = TRUE)
      cat('\t</Style>\n', file = file, append = TRUE)
      }
      }
      
    }

    # Coordinates of points 
    # ==========================
    
    cat('<Folder>\n', file = file, append = TRUE)
      
    for (i_site in 1:length(obj)) {
      # select columns of interest:
      sel <- grep(names(obj@profiles[[i_site]]@horizons), pattern=var.name)
      # mask out the NA horizons:
      prof.na <- which(!is.na(obj@profiles[[i_site]]@horizons[,sel]))
  
      if(length(prof.na)>0){
      for (i_pt in prof.na) {
  
      cat('\t<Placemark>\n', file = file, append = TRUE)
      cat('\t\t<name>', signif(obj@profiles[[i_site]]@horizons[i_pt,sel], 3), '</name>\n', sep="", file = file, append = TRUE)
      cat('\t\t<styleUrl>#pnt', i_site, '_', i_pt,'</styleUrl>\n', sep="", file = file, append = TRUE)
      cat('\t\t<Point>\n', file = file, append = TRUE)
      cat('\t\t\t<extrude>', as.integer(extrude), '</extrude>\n', sep="", file = file, append = TRUE)
      cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep="", file = file, append = TRUE)
      
      # Coordinates of labels:
      cat('\t\t\t<coordinates>', round(LON[i_site]+x.scale*(obj@profiles[[i_site]]@horizons[i_pt,sel]-x.min), 6), ',', LAT[i_site], ',', max.depth - (obj@profiles[[i_site]]@depths[i_pt,1]+(obj@profiles[[i_site]]@depths[i_pt,2]-obj@profiles[[i_site]]@depths[i_pt,1])/2), '</coordinates>\n', sep="", file = file, append = TRUE)

      cat('\t\t</Point>\n', file = file, append = TRUE)
      cat('\t</Placemark>\n', file = file, append = TRUE)
      }  
    }
    }

    cat('</Folder>\n', file = file, append = TRUE)  
  }

    
    # Write Polygons for each horizon:   

      # create a progress bar:
      pb <- txtProgressBar(min=0, max=length(obj), style=3)

      for (i_site in 1:length(obj)) {
      # select columns of interest:
      sel <- grep(names(obj@profiles[[i_site]]@horizons), pattern=var.name)

        # mask out the NA horizons:
        prof.na <- which(!is.na(obj@profiles[[i_site]]@horizons[,sel]))
  
        if(length(prof.na)>0){      
        cat('\t<Placemark>\n', file = file, append = TRUE)
        cat('\t\t<name>', points_names[i_site], '</name>\n', sep="", file = file, append = TRUE)
        cat('\t\t<visibility>', as.integer(visibility), '</visibility>\n', sep="", file = file, append = TRUE)
        cat('\t\t<Polygon>\n', file = file, append = TRUE)
        cat('\t\t\t<tessellate>', as.integer(tessellate), '</tessellate>\n', sep="", file = file, append = TRUE)
        cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep="", file = file, append = TRUE)
        cat('\t\t\t<outerBoundaryIs>\n', file = file, append = TRUE)
        cat('\t\t\t<LinearRing>\n', file = file, append = TRUE)
        # write points in the polygon:
        cat('\t\t\t\t<coordinates>\n', file = file, append = TRUE)
  
        # write values of target variable as polygons:

        for (i_pt in prof.na) {
          cat('\t\t\t\t\t', round(LON[i_site]+x.scale*(obj@profiles[[i_site]]@horizons[i_pt,sel]-x.min), 6),',', LAT[i_site],',', max.depth-obj@profiles[[i_site]]@depths[i_pt,1], '\n', sep="", file = file, append = TRUE)  # upper horizon border
          cat('\t\t\t\t\t', round(LON[i_site]+x.scale*(obj@profiles[[i_site]]@horizons[i_pt,sel]-x.min), 6), ',', LAT[i_site],',', max.depth-obj@profiles[[i_site]]@depths[i_pt,2], '\n', sep="", file = file, append = TRUE)  # lower horizon border
          }
        # close the polygon:
        cat('\t\t\t\t\t', LON[i_site],',', LAT[i_site],',', max.depth-obj@profiles[[i_site]]@depths[i_pt,2], '\n', sep="", file = file, append = TRUE)  # last point
        cat('\t\t\t\t\t', LON[i_site],',', LAT[i_site],',', max.depth-obj@profiles[[i_site]]@depths[prof.na[1],1], '\n', sep="", file = file, append = TRUE)  # origin
        cat('\t\t\t\t\t', round(LON[i_site]+x.scale*(obj@profiles[[i_site]]@horizons[prof.na[1],sel]-x.min), 6),',', LAT[i_site],',', max.depth-obj@profiles[[i_site]]@depths[prof.na[1],1], '\n', sep="", file = file, append = TRUE)  # first point 
        cat('\t\t\t\t</coordinates>\n', file = file, append = TRUE)
        cat('\t\t\t</LinearRing>\n', file = file, append = TRUE)
        cat('\t\t\t</outerBoundaryIs>\n', file = file, append = TRUE)
        cat('\t\t</Polygon>\n', file = file, append = TRUE)
        cat('\t</Placemark>\n', file = file, append = TRUE)
      }
        # update progress bar
        setTxtProgressBar(pb, i_site)
      }

    # close the progress bar:
    close(pb)

  # Closing the folder
  cat('</Folder>\n', file = file, append = TRUE)

    cat('\t<Camera>\n', file = file, append = TRUE)
    cat('\t\t<longitude>', LON[1], '</longitude>\n', sep="", file = file, append = TRUE) 
    cat('\t\t<latitude>', LAT[1]-camera.distance, '</latitude>\n', sep="", file = file, append = TRUE) 
    cat('\t\t<altitude>', max.depth, '</altitude>\n', sep="", file = file, append = TRUE) 
    cat('\t\t<heading>', heading, '</heading>\n', sep="", file = file, append = TRUE) 
    cat('\t\t<tilt>', tilt, '</tilt>\n', sep="", file = file, append = TRUE) 
    cat('\t\t<roll>', roll, '</roll>\n', sep="", file = file, append = TRUE) 
    cat('\t</Camera>\n', file = file, append = TRUE)
    cat('</Document>\n', file = file, append = TRUE)
    cat('</kml>\n', file = file, append = TRUE)

}
    
setMethod("kml_layer", "SoilProfileCollection", kml_layer.SoilProfileCollection)
