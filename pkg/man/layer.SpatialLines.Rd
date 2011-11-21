\name{kml_layer.SpatialLines}
\alias{kml_layer.SpatialLines}
\alias{SpatialLines}
\title{Exports objects of type SpatialLines* to KML}
\description{Writes object of type SpatialLines* to KML with several aesthetics arguments. }
\usage{
kml_layer.SpatialLines(obj, extrude = FALSE, z.scale = 1, spMetadata = NULL, 
  html.table = NULL, ...)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{spMetadata}{(optional) specify the metadata object}
  \item{html.table}{optional description block (html) for each GPS point (vertices)}
  \item{...}{additional style arguments (see \code{\link{aesthetics}})}
  \item{labels}{variable to be used to attach labels to spatial lines}
  \item{colour}{variable to be used to color spatial lines}
  \item{width}{variable to be used to specify the width of spatial lines}
  \item{altitude}{if not a 3D object; variable to be used to specify altitude above ground}
  \item{altitudeMode}{altitude mode type (\code{clampToGround}, \code{relativeToGround} or \code{absolute})}
}
\details{Only colour and width (aesthetics) are recommended when visualizing SpatialLines.}
\author{Pierre Roudier (\email{pierre.roudier@landcare.nz}), Tomislav Hengl (\email{tom.hengl@wur.nl}), Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{kml_layer.SpatialPolygons}} }
\examples{
data(eberg_contours)
data(SAGA_pal)
names(eberg_contours)
\dontrun{
# KML plot with elevations used as 'colour' argument:
kml(eberg_contours, colour_scale=SAGA_pal[[1]], colour=Z)}
}
\keyword{ ~KML}
\keyword{ SpatialLines}

