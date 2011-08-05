# Purpose        : Visualization of time-series of images (animations)
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : This uses the Space time full (space-time grid) data frame class objects from the spacetime package; all gridded layers MUST have the same legend!

kml_layer.STFDF <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  
  ...
  ){