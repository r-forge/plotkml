# Creates an image and the KML code to include it in the KML file
.write.kml.image <- function(
  obj, 
  var.name,
  col.pal,
  kml.file, 
  layer.name = NA
  ){

  # write a GIF:
  write.gif(image = t(as.matrix(obj[[var.name]])), filename = paste(file.name, "_ll.gif", sep = ""), col = col.pal, transparent = 0)

  # write into the a KML file:
  write('<GroundOverlay>', kml.file, append = TRUE)
  write(paste('<name>Ground overlay: ', layer.name, '</name>', sep=""), kml.file, append = TRUE)

  if (var.type == "numeric"){
    write(paste('<description>Values range: ', signif(z.lim[1], 2),' to ', signif(z.lim[2], 2),'</description>', sep = ""), kml.file, append = TRUE)
  }
  else {
    write(paste('<description>Levels: ', length(colours), '</description>', sep = ""), kml.file, append = TRUE)
  }

  write(paste('<altitude>', above.ground, '</altitude>', sep = ""), kml.file, append = TRUE) 
  write(paste('<altitudeMode>', altitudeMode, '</altitudeMode>', sep = ""), kml.file, append = TRUE)
  write('<Icon>', kml.file, append = TRUE)
  write(paste('<href>', file.name, "_ll.gif", '</href>', sep = ""), kml.file, append = TRUE)
  write('</Icon>', kml.file, append = TRUE)
  write('<LatLonBox>', kml.file, append = TRUE)
  write(paste('<north>', obj@bbox[2, 2], '</north>', sep = ""), kml.file, append = TRUE)
  write(paste('<south>', obj@bbox[2, 1], '</south>', sep = ""), kml.file, append = TRUE)
  write(paste('<east>', obj@bbox[1, 2], '</east>', sep = ""), kml.file, append = TRUE)
  write(paste('<west>', obj@bbox[1, 1], '</west>', sep = ""), kml.file, append = TRUE)
  write('</LatLonBox>', kml.file, append = TRUE)
  write('</GroundOverlay>', kml.file, append = TRUE)

  if (make.legend) {
    if (is.factor(obj@data[,var.name])|var.type=="factor"){
      write.legend.gif(x = obj, var.type = "factor", var.name = var.name, legend.file.name = paste(file.name, '_legend.png', sep = ""), legend.pal = col.pal)
    }
    else { 
      write.legend.gif(x=obj, var.name=var.name, legend.file.name=paste(file.name, '_legend.png', sep=""), legend.pal=col.pal, z.lim=z.lim)
    }
  }

  write('<ScreenOverlay>', kml.file, append = TRUE)
  write('<name>Legend</name>', kml.file, append = TRUE)
  write('<Icon>', kml.file, append = TRUE)
  write(paste('<href>', file.name, '_legend.png</href>', sep=""), kml.file, append = TRUE)
  write('</Icon>', kml.file, append = TRUE)
  write(paste('<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), kml.file, append = TRUE)
  write(paste('<screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>', sep=""), kml.file, append = TRUE)
  write(paste('<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), kml.file, append = TRUE)
  write(paste('<size x="0" y="0" xunits="fraction" yunits="fraction"/>', sep=""), kml.file, append = TRUE)
  write('</ScreenOverlay>', kml.file, append = TRUE)
}

# Creates polygons out of a raster and thee KML code to include it in the KML file
.write.kml.poly <- function(){
}


kml.SpatialPixels <- function(
  obj, 
  var.name, 
  var.type = "numeric", 
  file.name = var.name, 
  z.lim = z.lim <- c(quantile(obj@data[,var.name], 0.025, na.rm=TRUE), quantile(obj@data[,var.name], 0.975, na.rm=TRUE)), 
  col.pal = rainbow(64), 
  above.ground = 10, 
  factor.labels, 
  error.name, 
  global.var = var(obj@data[,var.name], na.rm = TRUE), 
  plot.type = 'gif', 
  mvFlag = -99999, 
  r.method = 'bilinear', 
  kml.legend = TRUE, 
  altitudeMode = "clampToGround", 
  FWTools = FALSE, 
  make.kml = TRUE, 
  kmz = FALSE
){

  col.no <- length(col.pal)
  gif.pal <- c(grey(0), col.pal, rep(grey(1), 256-col.no)) # add colors for transparent pixels and undefined values

  

  # check if it factor or numeric and then code the values
  if (is.factor(obj@data[[var.name]]) | var.type == "factor"){
    obj$mask <- ifelse(is.na(obj@data[[var.name]]), 0, as.integer(obj@data[[var.name]]))
  }
  else { 
    breaks.var <- c(-99999, seq(from = z.lim[1], to = z.lim[2], length.out = col.no - 1), max(obj@data[[var.name]], na.rm = TRUE) + sd(obj@data[[var.name]], na.rm = TRUE) / col.no)
    obj$mask <- as.integer(cut(obj@data[[var.name]], breaks = breaks.var, include.lowest = TRUE))
    obj$mask <- ifelse(is.na(obj$mask), 0, obj$mask)
  }

  if (kml.legend & make.kml){
    if (is.factor(obj@data[[var.name]]) | var.type == "factor"){
      if (missing(factor.labels)) {
        factor.labels <- levels(obj@data[[var.name]]) 
      }
      write.legend.gif(x = obj, var.type = "factor", var.name = var.name, legend.file.name = paste(var.name, "_legend.png", sep = ""), factor.labels = factor.labels, legend.pal = col.pal)
    }
    else { 
      write.legend.gif(x = obj, var.name = var.name, legend.file.name = paste(var.name, "_legend.png", sep = ""), legend.pal = col.pal, z.lim = z.lim)
    }
  }

  if(plot.type == "gif"){
    # write a GIF with defined transparency:
    if(is.factor(obj@data[[var.name]]) | var.type == "factor") {
      write.grid2gif.KML(obj = obj, var.type = var.type, var.name = "mask", file.name = var.name, col.pal = gif.pal, above.ground = above.ground, altitudeMode = altitudeMode, make.legend = FALSE, make.kml)
    } 
    else {
      write.grid2gif.KML(obj = obj, var.type = var.type, var.name = "mask", file.name = var.name, z.lim = z.lim, col.pal = gif.pal, above.ground = above.ground, altitudeMode = altitudeMode, make.legend = FALSE, make.kml)  
    }
  }
  else {
    if(plot.type == "poly"){
      # write a KML as polygons:
      if(is.factor(obj@data[[var.name]]) | var.type == "factor") {
        write.grid2poly.KML(obj = obj, var.type = var.type, var.name = var.name, file.name = var.name, col.pal = col.pal, above.ground = above.ground, altitudeMode = altitudeMode, make.legend = FALSE)
      }
      else {
        if(!missing(error.name)) { 
          obj@data[[var.name]] <- ifelse(obj@data[[error.name]] > global.var, NA, obj@data[[var.name]]) 
        }
        write.grid2poly.KML(obj = obj, var.type = var.type, var.name = var.name, file.name = var.name, z.lim = z.lim, col.pal = col.pal, above.ground = above.ground, altitudeMode = altitudeMode, make.legend = FALSE)
      }
    }
  }  
}
