# Purpose        : Writing of "Photo" objects to KML
# Maintainer     : Dylan Beaudette (debeaudette@ucdavis.edu)
# Contributions  : Tomislav Hengl (tom.hengl@wur.nl); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : The output KML depends on the Google Sketch-up dae file which is generated below;


kml_layer.Photo <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  z.scale = 1,
  x.min = 0,  # intercept
  x.scale,
  camera.distance,
  tilt = 90, 
  heading = 0, 
  roll = 0,
  ...
  ){