# Purpose        : Writing of Trajectory-type objects to KML
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz);
# Status         : not tested yet
# Note           : This uses the Space time irregular data frame class objects from the spacetime package;

kml_layer.STIDFtraj <- function(
  # options on the object to plot
  obj,
  file,
  title = as.character(substitute(obj, env = parent.frame())),
  extrude = TRUE,
  
  ...
  ){