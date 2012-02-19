\name{kml_layer.SpatialPoints}
\alias{kml_layer.SpatialPoints}
\alias{SpatialPoints}
\title{Export spatial points to KML}
\description{Writes object of class \code{"SpatialPoints*"} to KML with a possibility to parse attribute variables using several aesthetics arguments. }
\usage{
kml_layer.SpatialPoints(obj, extrude = TRUE, z.scale = 1, 
        LabelScale = get("LabelScale", envir = plotKML.opts), 
        metadata = NULL, html.table = NULL, TimeSpan.begin = "",
        TimeSpan.end = "", \dots)
}
\arguments{
  \item{obj}{object of class \code{"SpatialPoints*"}}
  \item{extrude}{logical; specifies whether to connect the point to the ground with a line}
  \item{z.scale}{numeric; exaggeration in vertical dimension}
  \item{LabelScale}{numeric; scale factor for size of labels}
  \item{metadata}{(optional) specify the metadata object}
  \item{html.table}{(optional) specify the description block (html) for each point}
  \item{TimeSpan.begin}{(optional) beginning of the referent time period}
  \item{TimeSpan.end}{(optional) end of the referent time period}
  \item{\dots}{additional style arguments (see \code{\link{aesthetics}})}
}
\details{\code{TimeSpan.begin} and \code{TimeSpan.end} are optional TimeStamp vectors (\code{yyyy-mm-ddThh:mm:sszzzzzz}). For observations at point support (a single moment in time), use the same time values for both \code{TimeSpan.begin} and \code{TimeSpan.end}. \code{TimeSpan.begin} and \code{TimeSpan.end} can be either a single value or a vector of values. \cr
Optional aesthetics arguments are \code{shapes} (icons), \code{colour}, \code{sizes}, \code{altitude} (if not a 3D object; variable to be used to specify altitude above ground), \code{altitudeMode} (altitude mode type (\code{clampToGround}, \code{relativeToGround} or \code{absolute}). Although this function can be used to plot over five variables, more than three aesthetics arguments is not recommended (e.g. limit to size and colour).
}
\author{Pierre Roudier, Tomislav Hengl and Dylan Beaudette }
\seealso{ \code{\link{kml_layer.STIDFtraj}} }
\examples{
data(eberg)
data(SAGA_pal)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
names(eberg)
\dontrun{
# subset to 20 percent:
eberg <- eberg[runif(nrow(eberg))<.2,]
# KML plot measured CLAY content:
kml(eberg, labels = CLAY)
shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png"
kml(eberg, shape = shape, colour = SILT, labels = "", colour_scale = SAGA_pal[[1]])
# Two variables at the same time:
kml(eberg, shape = shape, size = CLAY, colour = SILT, labels = "")
# Two aesthetics elements are effective in emphasizing hot-spots:
kml(eberg, shape = shape, altitude = CLAY*10, extrude = TRUE, colour = CLAY, labels = CLAY, kmz = TRUE)
}
}
\keyword{ ~KML}
\keyword{ SpatialPoints}

