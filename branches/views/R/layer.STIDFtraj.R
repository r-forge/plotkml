# Purpose        : Writing of Trajectory-type objects to KML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Pierre Roudier (pierre.roudier@landcare.nz); Dylan Beaudette (debeaudette@ucdavis.edu); 
# Status         : not tested yet
# Note           : This method works only wit the Space time irregular data frame class objects from the spacetime package;

kml_layer.STIDFtraj <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  start.icon = "http://plotkml.r-forge.r-project.org/3Dballyellow.png",
  end.icon = "http://plotkml.r-forge.r-project.org/golfhole.png",
  icon.scale = 0.5,
  z.scale = 1,
  tessellate = FALSE,
  plot.points = FALSE,
  lsmooth = FALSE,
  densify.by = 2,
  dtime,
  id.name,   # Line ID (has to be a factor type column)  
  ## TH: Normally we should be able to pass the ID column via "labels"
  span = .3, # the smaller the span the lower the smoothing (chance that the fitted spline will go through the observed point)
  ...
  ){
  
  # get our invisible file connection from custom environment
  file.connection <- get('kml.file.out', env=plotKML.fileIO)
  
  # Checking the projection is geo
  check <- check_projection(obj@sp, logical = TRUE)

  # Trying to reproject data if the check was not successful
  if (!check)
    obj@sp <- reproject(obj@sp)

  # Parsing the call for aesthetics
  aes <- kml_aes(obj@data, ...)   

  # Read the relevant aesthetics  ## TH: I am not sure if these are still usefull / at least I do not know how to use them.
  lines_names <- aes[["labels"]]  
  colours <- aes[["colour"]]   
  width <- aes[["width"]]
  altitudeMode <- aes[["altitudeMode"]]
  balloon <- aes[["balloon"]]
  
  # object ID names / coordinate names
  lv <- levels(obj@data[,id.name])
  nc <- attr(obj@sp@coords, "dimname")[[2]]
   
  # Format the time slot for writing to KML:
  if(missing(dtime)) {  ftime <- periodicity(obj@time)  }  # estimate the time support (if not indicated)
  TimeSpan.begin <- format(as.POSIXct(unclass(as.POSIXct(time(obj@time))) - ftime$frequency/2, origin="1970-01-01"), "%Y-%m-%d %X")
  TimeSpan.end <- format(as.POSIXct(unclass(as.POSIXct(time(obj@time))) + ftime$frequency/2, origin="1970-01-01"), "%Y-%m-%d %X")
  # The dateTime is defined as yyyy-mm-ddThh:mm:sszzzzzz, where T is the separator between the date and the time, and the time zone is either Z (for UTC) or zzzzzz, which represents ±hh:mm in relation to UTC.

  # Folder and name of the points folder
  cat('<Folder>\n', file = file.connection, append = TRUE)
  cat('<name>', title, '</name>\n', sep = "", file = file.connection, append = TRUE)

  # Sorting lines
  # =============
 
  current.line.coords <- NULL
  ldist <- NULL
  # scale time dimension so the numbers are app similar:
  t.scale <- mean(diff(t(obj@sp@bbox)))/diff(range(unclass(as.POSIXct(time(obj@time)))))
  
  for (i.line in 1:length(lv)) {  # for each line

    cfd <- data.frame(coordinates(obj@sp[obj@data[,id.name]==lv[i.line],]))
    # convert to a line object (this assumes that the points are sorted chronologically!)
    cl <- Line(cfd)
    # line length:
    ldist[[i.line]] <- LineLength(cl, longlat=TRUE, sum=TRUE) 
    current.line.coords[[i.line]] <- cfd[,nc]
    if(length(nc)<3){
    current.line.coords[[i.line]][,3] <- rep(0, length(cfd[,1])) 
    }
  }

  # Styles - lines:
  # ======
  for (i.line in 1:length(lv)) {
  
    cat('\t<Style id="', 'line_', i.line,'">\n', sep = "", file.connection, append = TRUE)
    cat('\t\t<LineStyle>\n', file.connection, append = TRUE)
    cat('\t\t\t<color>', colours[i.line], '</color>\n', sep = "", file.connection, append = TRUE)
    cat('\t\t\t<width>', width[i.line], '</width>\n', sep = "", file.connection, append = TRUE)
    cat('\t\t</LineStyle>\n', file.connection, append = TRUE)
    # balloon
    cat('\t\t<BalloonStyle>\n', file = file.connection, append = TRUE)
    cat('\t\t\t<text>$[description]</text>\n', file = file.connection, append = TRUE)
    cat('\t\t</BalloonStyle>\n', file = file.connection, append = TRUE)
    cat('\t</Style>\n', file.connection, append = TRUE)
  
    # Styles - points:
    # ======
  
    for(i.point in 1:length(current.line.coords[[i.line]][,1])) { # for each point
    
    cat('\t<Style id="pnt_', i.point,'">\n', sep = "", file.connection, append = TRUE)
    cat('\t\t<IconStyle>\n', file.connection, append = TRUE)
    cat('\t\t\t<color>"ff0000ff"</color>\n', file.connection, append = TRUE)
    cat('\t\t\t<scale>', icon.scale, '</scale>\n', sep = "", file.connection, append = TRUE)
    cat('\t\t\t<Icon>\n', file.connection, append = TRUE)
        if(i.point < length(current.line.coords[[i.line]][,1])){
        cat('\t\t\t\t<href>', start.icon, '</href>\n', sep="", file.connection, append = TRUE) 
        } 
        else {
        # the last point:
        cat('\t\t\t\t<href>', end.icon, '</href>\n', sep="", file.connection, append = TRUE)
        }
    cat('\t\t\t</Icon>\n', file.connection, append = TRUE)
    cat('\t\t</IconStyle>\n', file.connection, append = TRUE)
    cat('\t</Style>\n', file.connection, append = TRUE)
    
    }
   } # end styles;
      
   # Writing observed vertices
   # =============
   
   for (i.line in 1:length(lv)) {
   
    for(i.point in 1:length(current.line.coords[[i.line]][,1])) {
    cat('\t<Placemark>\n', file.connection, append = TRUE)
    cat('\t\t<styleUrl>#pnt_', i.point, '</styleUrl>\n', sep="", file.connection, append = TRUE)
    cat('\t\t<TimeSpan>\n', file.connection, append=TRUE)
    cat('\t\t\t<begin>', TimeSpan.begin[i.point],'</begin>\n', sep="", file.connection, append=TRUE)
    cat('\t\t\t<end>', TimeSpan.end[i.point],'</end>\n', sep="", file.connection, append=TRUE)
    cat('\t\t</TimeSpan>\n', file.connection, append=TRUE) 
    cat('\t\t<Point>\n', file.connection, append = TRUE)
    cat('\t\t\t<extrude>', as.integer(extrude), '</extrude>\n', sep="", file.connection, append = TRUE)
    cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>\n', sep="", file.connection, append = TRUE)  
    cat('\t\t\t<coordinates>', current.line.coords[[i.line]][i.point,1],',', current.line.coords[[i.line]][i.point,2],',', current.line.coords[[i.line]][i.point,3]*z.scale, '</coordinates>\n', sep="", file.connection, append = TRUE)
    cat('\t\t</Point>\n', file.connection, append = TRUE)
    cat('\t</Placemark>\n', file.connection, append = TRUE)
    }
    
    }

    # Writing Lines
   # =============

   ### create a progress bar:
   pb <- txtProgressBar(min=0, max=length(lv), style=3)

   for (i.line in 1:length(lv)) {
   
    cat('\t<Placemark>\n', file.connection, append = TRUE)
    cat('\t\t<name>', lv[i.line], ' (length: ', ldist[[i.line]],')</name>\n', sep = "", file.connection, append = TRUE)
    cat('\t\t<styleUrl>#line_', i.line, '</styleUrl>\n', sep = "", file.connection, append = TRUE)

    # Add description with attributes
    if (balloon & ("data" %in% slotNames(obj)))
      .df_to_kml_html_table(obj@data[i.line, ])

    cat('\t\t<LineString>', file.connection, append = TRUE)
    cat('\t\t\t<altitudeMode>', altitudeMode, '</altitudeMode>', sep = "", file.connection, append = TRUE)
    cat('\t\t\t\t<coordinates>', file.connection, append = TRUE)
       # For each vertice in the current line
    for (i.point in 1:length(current.line.coords[[i.line]][,1])) {
      cat('\t\t\t\t', current.line.coords[[i.line]][i.point, 1], ',', current.line.coords[[i.line]][i.point, 2], ',', current.line.coords[[i.line]][i.point,3], '\n', sep = "", file.connection, append = TRUE)
    }
    cat('\t\t\t</coordinates>\n', file.connection, append = TRUE)
    cat('\t\t</LineString>\n', file.connection, append = TRUE)
    cat('\t</Placemark>\n', file.connection, append = TRUE)
   }
   
  close(pb)

  # Closing the folder
  cat('</Folder>\n', file = file.connection, append = TRUE)
}

setMethod("kml_layer", "STIDFtraj", kml_layer.STIDFtraj)