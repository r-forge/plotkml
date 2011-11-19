\name{kml_layer.SpatialPolygons}
\alias{SpatialPolygons}
\title{Exports objects of type SpatialPolygons* to KML}
\description{Writes object of type SpatialPolygons* to KML with several aesthetics arguments. }
\usage{
kml_layer.SpatialPolygons(obj, obj.title, extrude = FALSE, tessellate = FALSE,
   outline = TRUE, plot.labpt = FALSE, z.scale = 1, LabelScale = get("LabelScale", envir = plotKML.opts),
   metadata = FALSE, html.table = NULL, ...)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{obj.title}{object title that will be inserted in the folder name}
  \item{extrude}{logical; specifies whether to connect the point to the ground with a line}
  \item{tessellate}{logical; specifies whether to connect the LinearRing to the ground}
  \item{outline}{logical; specifies whether to outline the polygon}
  \item{plot.labpt}{logical; specifies whether to add the label point (polygon centre)}
  \item{metadata}{logical; specifies whether to print metadata in the description box}
  \item{html.table}{optional description block (html) for each GPS point (vertices)}
  \item{...}{additional style arguments (see \code{\link{aesthetics}})}
  \item{labels}{variable to be used to attach labels to polygon centres}
  \item{colour}{variable to be used to color polygons}
  \item{alpha}{variable to be used to set transparency}
  \item{altitude}{if not a 3D object; variable to be used to specify altitude above ground}
  \item{altitudeMode}{altitude mode type (\code{clampToGround}, \code{relativeToGround} or \code{absolute})}
}
\details{Label points are be default not plotted (we recommend adding the legend to attribute maps instead). Transparency can be set by using the alpha argument.}
\author{Pierre Roudier (\email{pierre.roudier@landcare.nz}), Tomislav Hengl (\email{tom.hengl@wur.nl}), Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{kml_layer.SpatialLines}} }
\examples{
data(eberg_zones)
names(eberg_zones)
\dontrun{
# Random colors:
kml(eberg_zones)
kml(eberg_zones, plot.labpt = TRUE, labels = ZONES)
# Soil mapping zones:
kml(eberg_zones, colour = ZONES)}
}
\keyword{ ~KML}
\keyword{ SpatialPolygons}
