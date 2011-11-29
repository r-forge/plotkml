\name{kml_layer.SoilProfileCollection}
\alias{kml_layer.SoilProfileCollection}
\alias{SoilProfileCollection}
\title{Exports objects of type SoilProfileCollection to KML}
\description{Writes object of type SoilProfileCollection (a number of soil profiles with site and horizon data) to KML. Several attributes such as horizontal and vertical exaggeration can be passed via arguments. }
\usage{
kml_layer.SoilProfileCollection(obj, var.name, site_names = obj@site[,1],
  z.scale = 1, x.min = 0, x.scale, max.depth = 300, plot.points = TRUE, 
  LabelScale, IconColor = "ff0000ff", shape = paste(get("home_url", envir = plotKML.opts), "circlesquare.png", sep=""), 
  visibility = TRUE, extrude = TRUE, tessellate = TRUE, camera.distance = .01, 
  altitudeMode = "relativeToGround", tilt = 90, heading = 0, roll = 0, 
  metadata = NULL, html.table = NULL, \dots)
}
\arguments{
  \item{obj}{object of class \code{"SoilProfileCollection"} (package \href{http://CRAN.R-project.org/package=aqp}{aqp})}
  \item{var.name}{target column name in the \code{horizons} slot}
  \item{site_names}{site names as listed in the site table}
  \item{z.scale}{exaggeration in vertical dimension}
  \item{x.min}{offset in longitude direction (in decimal degrees)}  
  \item{x.scale}{exaggeration in horizontal direction}
  \item{max.depth}{maximum height/depht of a profile in cm}
  \item{plot.points}{logical; specifies whether to plot horizon centres with attribute values}
  \item{camera.distance}{distance from a profile in arc degrees}
  \item{altitudeMode}{by default \code{relativeToGround}}
  \item{tilt}{angle between the direction of the LookAt position and the normal to the surface of the earth} 
  \item{heading}{orientation towards north} 
  \item{roll}{rotation about the y axis}
  \item{\dots}{additional style arguments}
}
\details{Horizon depths are typically expressed in cm, hence the default exaggeration factor (\code{z.scale}) is 10. It is highly recommended to turn off the terrain layer in Google Earth, otherwise Google Earth will deform the plots in areas of high relief.}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl}), Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}} }
\examples{
install.packages("aqp", repos="http://R-Forge.R-project.org")
library(aqp)
data(ca630)
# Promote to SoilProfileCollection
ca <- join(ca630$lab, ca630$site, type='inner')
depths(ca) <- pedon_key ~ hzn_top + hzn_bot
# extract site data
site(ca) <- ~ mlra + ssa + lon + lat + cntrl_depth_to_top + cntrl_depth_to_bot + sampled_taxon_name
# generate SpatialPoints
coordinates(ca) <- ~ lon + lat
# assign CRS data
proj4string(ca) <- "+proj=latlong +datum=NAD83"
\dontrun{
# plot changes in base saturation by sum of cations method (pH 8.2):
kml(ca, method = "depth_function", file.name = "ca_bs_8_2.kml", var.name="bs_8.2", balloon = TRUE)
# plot changes in cation exchange capacity by sum of cations method (pH 8.2):
kml(ca, file.name = "ca_CEC8_2.kml", var.name="CEC8.2", IconColor = "#ff009000")
# plot soil profile as 'block':
kml(ca, file.name = "ca_CEC8_2_block.kml", var.name="CEC8.2", balloon = TRUE)}
}
\keyword{ ~KML}
\keyword{ soil}

