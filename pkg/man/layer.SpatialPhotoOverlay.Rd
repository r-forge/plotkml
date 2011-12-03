\name{kml_layer.SpatialPhotoOverlay}
\alias{kml_layer.SpatialPhotoOverlay}
\alias{SpatialPhotoOverlay}
\title{Exports objects of type SpatialPhotoOverlay to KML}
\description{Writes object of type SpatialPhotoOverlay to KML together with a COLLADA 3D model file (optional).}
\usage{
kml_layer.SpatialPhotoOverlay(obj, method = c("PhotoOverlay", "monolith")[1], 
  PhotoOverlay.shape = obj@PhotoOverlay$shape, href = obj@filename, coords,
  dae.name = "", heading = obj@PhotoOverlay$heading, tilt = obj@PhotoOverlay$tilt,
  roll = obj@PhotoOverlay$roll, near = obj@PhotoOverlay$near, range = obj@PhotoOverlay$range,
  leftFov = obj@PhotoOverlay$leftFov, rightFov = obj@PhotoOverlay$rightFov, bottomFov = obj@PhotoOverlay$bottomFov, 
  topFov = obj@PhotoOverlay$topFov, altitudeMode = "clampToGround", block.size = 100,
  max.depth = 300, scale.x = 1, scale.y = 1, scale.z = 1, refreshMode = "once", \dots)
}
\arguments{
  \item{obj}{object of class \code{"SpatialPhotoOverlay"} (a photograph with spatial coordinates, metadata and orientation)}
  \item{method}{visualization type: either \code{"PhotoOverlay"} or \code{"monolith"}}
  \item{PhotoOverlay.shape}{PhotoOverlay shape value (KML)}
  \item{href}{location of the image file}
  \item{dae.name}{(optional) COLLADA 3D model file name (without the extension)}
  \item{\dots}{a list of PhotoOverlay related arguments}
  \item{block.size}{width of the block (100 m by default)}
  \item{max.depth}{300 m by default}
  \item{html.table}{(optional) specify the description block (html) for each point}
  \item{\dots}{other additional arguments}
}
\details{The default widht and height (100 m and 300 m) were selected based on empirical testing (level of detail in the background imagery in Google Earth). User specified coordinates can be passed via the \code{cords} argument. For more info see \code{\link{makeCOLLADA.rectangle}}.
}
\references{
\itemize{
\item KML Reference (\url{http://code.google.com/apis/kml/documentation/kmlreference.html})
}
}
\author{Tomislav Hengl }
\seealso{ \code{\link{spPhoto}}, \code{\link{getWikiMedia.ImageInfo}} }
\examples{
\dontrun{
imagename = "Soil_monolith.jpg"
x1 <- getWikiMedia.ImageInfo(imagename)
sm <- spPhoto(filename = x1$url$url, exif.info = x1$metadata)
kml_open("sm.kml")
kml_layer(sm, method="monolith")
kml_close("sm.kml")
kml_compress("sm.kml", files="Soil_monolith_jpg.dae")}
}
\keyword{ ~KML}
\keyword{ SpatialPoints}

