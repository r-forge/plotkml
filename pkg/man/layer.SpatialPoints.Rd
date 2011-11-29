\name{kml_layer.SpatialPoints}
\alias{kml_layer.SpatialPoints}
\alias{SpatialPoints}
\title{Exports objects of type SpatialPoints* to KML}
\description{Writes object of type SpatialPoints* to KML with several aesthetics arguments. }
\usage{
kml_layer.SpatialPoints(obj, extrude = FALSE, 
    LabelScale = get("LabelScale", envir = plotKML.opts), z.scale = 1, 
    metadata = NULL, html.table = NULL, \dots)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{extrude}{logical; specifies whether to connect the point to the ground with a line}
  \item{LabelScale}{numeric; default size of the labels}
  \item{metadata}{(optional) specify the metadata object}
  \item{html.table}{(optional) specify the description block (html) for each point}
  \item{\dots}{additional style arguments (see \code{\link{aesthetics}})}
  \item{labels}{variable to be used to attach labels to spatial lines}
  \item{shapes}{variable to be used to attach icons}
  \item{colour}{variable to be used to color spatial lines}
  \item{sizes}{variable to be used control size of icons}
  \item{altitude}{if not a 3D object; variable to be used to specify altitude above ground}
  \item{altitudeMode}{altitude mode type (\code{clampToGround}, \code{relativeToGround} or \code{absolute})}
}
\details{Although this function can be used to plot over five variables, it is highly recommended that you use a maximum of two or three aesthetics arguments (e.g. size and colour).
}
\author{Pierre Roudier (\email{pierre.roudier@landcare.nz}), Tomislav Hengl (\email{tom.hengl@wur.nl}), Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}} }
\examples{
data(eberg)
data(SAGA_pal)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
names(eberg)
\dontrun{
# subset:
eberg <- eberg[runif(nrow(eberg))<.2,]
# KML plot measured CLAY content:
kml(eberg, labels=CLAY)
shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png"
kml(eberg, shape = shape, colour = SILT, labels = "", colour_scale = SAGA_pal[[1]])
# Two variables at the same time:
kml(eberg, shape = shape, size = CLAY, colour = SILT, labels = "")
# Elevation used for visualization 
# two aesthetics elements emphasize hot-spots:
kml(eberg, shape = shape, altitude = CLAY*10, extrude = TRUE, colour = CLAY, labels = CLAY)}
}
\keyword{ ~KML}
\keyword{ SpatialPoints}

