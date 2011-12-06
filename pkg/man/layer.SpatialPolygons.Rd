\name{kml_layer.SpatialPolygons}
\alias{kml_layer.SpatialPolygons}
\alias{SpatialPolygons}
\title{Export spatial polygons to KML}
\description{Writes object of class \code{"SpatialPolygons*"} to KML with a possibility to parse attribute variables using several aesthetics arguments. }
\usage{
kml_layer.SpatialPolygons(obj, extrude = FALSE, tessellate = FALSE, outline = TRUE, 
   plot.labpt = FALSE, z.scale = 1, LabelScale = get("LabelScale", envir = plotKML.opts),
   metadata = NULL, html.table = NULL, TimeSpan.begin = "", TimeSpan.end = "", \dots)
}
\arguments{
  \item{obj}{object of class \code{"SpatialPolygons*"}}
  \item{extrude}{logical; specifies whether to connect the point to the ground with a line}
  \item{tessellate}{logical; specifies whether to connect the LinearRing to the ground}
  \item{outline}{logical; specifies whether to outline the polygon}
  \item{plot.labpt}{logical; specifies whether to add the label point (polygon centre)}
  \item{spMetadata}{(optional) specify the metadata object}
  \item{html.table}{optional description block (html) for each GPS point (vertices)}
  \item{TimeSpan.begin}{(optional) beginning of the referent time period}
  \item{TimeSpan.end}{(optional) end of the referent time period}
  \item{\dots}{additional style arguments (see \code{aesthetics})}
  \item{labels}{variable to be used to attach labels to polygon centres}
  \item{colour}{variable to be used to color polygons}
  \item{alpha}{variable to be used to set transparency}
  \item{altitude}{if not a 3D object; variable to be used to specify altitude above ground}
  \item{altitudeMode}{altitude mode type (\code{"clampToGround"}, \code{"relativeToGround"} or \code{"absolute"})}
}
\details{Label points are be default not plotted. We recommend adding the legend to attribute maps instead. Transparency can be set by using the alpha argument.\cr 
\code{TimeSpan.begin} and \code{TimeSpan.end} are optional TimeStamp vectors (\code{yyyy-mm-ddThh:mm:sszzzzzz}). Use the same time values for both \code{TimeSpan.begin} and \code{TimeSpan.end} if the measurements refer to a single moment in time. \code{TimeSpan.begin} and \code{TimeSpan.end} can be either a single value or a vector of values.}
\author{Pierre Roudier, Tomislav Hengl and Dylan Beaudette}
\seealso{ \code{\link{kml_layer.SpatialLines}}, \code{\link{kml_layer.STIDF}} }
\examples{
data(eberg_zones)
names(eberg_zones)
\dontrun{
# using random colors:
kml(eberg_zones)
# with labels:
kml(eberg_zones, plot.labpt = TRUE, labels = ZONES, kmz = TRUE)
}
}
\keyword{ ~KML}
\keyword{ SpatialPolygons}

