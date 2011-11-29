\name{spPhoto}
\alias{spPhoto}
\alias{SpatialPhotoOverlay}
\alias{getWikiMedia.ImageInfo}
\title{Generate an object of class \code{"SpatialPhotoOverlay"}.}
\description{
\code{spPhoto} method can be used to wrap pixel map (image), \href{http://en.wikipedia.org/wiki/Exchangeable_image_file_format}{EXIF} (Exchangeable Image File format) data, location information (standing point, \code{"SpatialPoints"}), and \code{PhotoOverlay} (geometry) parameters to create an object of class \code{"SpatialPhotoOverlay"}. This object can then be easily parsed to KML and visualized in Google Earth.\cr
\code{getWikiMedia.ImageInfo} function fetches the EXIF data via the \href{http://www.mediawiki.org/wiki/API}{Wikimedia API} for any donated image. The resulting EXIF data (named list) can then be further used to construct the \code{"SpatialPhotoOverlay"} object.
}
\usage{spPhoto(filename, obj, pixmap, exif.info = NULL, ImageWidth = 0, ImageHeight = 0,
   bands = rep(rep(1, ImageHeight*ImageWidth), 3), bbox = c(0,0,3/36000*ImageWidth,3/36000*ImageHeight),
   DateTime = "", ExposureTime = "", FocalLength = "50 mm", Flash = "No Flash", rotation = 0, 
   leftFov = -30, rightFov = 30, bottomFov = -30, topFov = 30, near = 50,
   shape = c("rectangle", "cylinder", "sphere")[1], range = .01, tilt = 90, heading = 0, roll = 0,
   test.filename = TRUE)
}
\arguments{
  \item{filename}{file name with extension (ideally an URL)}
  \item{obj}{object of class "SpatialPoints" with a single point}
  \item{pixmap}{object of class "pixmapRGB" (see package pixmap)}
  \item{exif.info}{named list containing all available EXIF metadata}
  \item{ImageWidth}{(optional) image width in pixels}
  \item{ImageHeight}{(optional) image height in pixels}
  \item{bands}{(optional) RGB bands as vectors (see \code{pixmap::pixmapRGB})}
  \item{bbox}{(optional) bounding box coordinates (by default 1 pixel is about 1 m in arc degrees)}  
  \item{DateTime}{(optional) usually available from the camera EXIF data}
  \item{ExposureTime}{(optional) usually available from the camera EXIF data}
  \item{FocalLength}{(optional) usually available from the camera EXIF data}
  \item{Flash}{(optional) usually available from the camera EXIF data}
  \item{rotation}{(optional) rotation angle in 0--90 degrees}
  \item{leftFov}{(optional) angle, in degrees, between the camera's viewing direction and the left side of the view volume (-180 -- 0)}
  \item{rightFov}{(optional) angle, in degrees, between the camera's viewing direction and the right side of the view volume (0 -- 180)}
  \item{bottomFov}{(optional) angle, in degrees, between the camera's viewing direction and the bottom side of the view volume (-90 -- 0)}
  \item{topFov}{(optional) angle, in degrees, between the camera's viewing direction and the top side of the view volume (0 -- 90)}
  \item{near}{(optional) measurement in meters along the viewing direction from the camera viewpoint to the PhotoOverlay shape}
  \item{shape}{(optional) shape type --- rectangle (standard photograph), cylinder (for panoramas), or sphere (for spherical panoramas)}
  \item{range}{(optional) distance from the camera to the placemark}
  \item{tilt}{(optional) rotation, in degrees, of the camera around the X axis}
  \item{heading}{(optional) direction (azimuth) of the camera, in degrees (0 -- 360)}
  \item{roll}{(optional) rotation about the y axis, in degrees (0 -- 180)}
  \item{test.filename}{logical; species whether a test should be first performed that the file name really exists (recommended)}
}
\useage{getWikiMedia.ImageInfo(imagename, APIsource = "http://commons.wikimedia.org/w/api.php", 
    module = "imageinfo", details = c("url", "metadata", "extlinks"), testURL = TRUE)
}
\arguments{
  \item{imagename}{Wikimedia commons unique image title}
  \item{APIsource}{location of the API service}
  \item{module}{default module}
  \item{details}{detailed parameters of interest}
  \item{testURL}{logical; species if the program should first test whether the image exist at all (recommended)}
}
\details{The most effective way to import a field photograph to \code{SpatialPhotoOverlay} for parsing to KML is to: (\strong{a}) use the EXIF tool to \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{add any important tags} into the image file, (\strong{b}) once all important tags have been added, it can be uploaded to a public portal such as the Wikimedia Commons, (\strong{c}) further use only the image unique name following the examples below. Some examples of how to embed EXIF tags into an image file are available \href{http://commons.wikimedia.org/wiki/Commons:EXIF}{here}. To geocode an uploaded image consider adding \code{{{location|lat deg|lat min|lat sec|NS|long deg|long min|long sec|EW}}} tag to the file description.\cr 
You can also consider importing images to R by using the \code{pixmap} package, and reading the technical information via e.g. the \href{http://www.omegahat.org/Rexif/}{\code{Rexif}} package. If the image is taken using a GPS enabled camera, by getting the EXIF metadata you can generate the complete \code{SpatialPhotoOverlay} object with minimum user interaction. Otherwise, you need to at least specify: file name, and location of the focal point of the camera (i.e. create a \code{"SpatialPoints"} object).
}
\references{
\itemize{
\item EXIF tool (\url{http://www.sno.phy.queensu.ca/~phil/exiftool/})
\item Wikimedia API (\url{http://www.mediawiki.org/wiki/API})
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{ \code{pixmap::pixmapRGB}, \code{\link{kml_layer}}}
\examples{
\dontrun{
## Two examples with images on Wikimedia Commons
# (a) Soil monolith (manually entered coordinates):
imagename = "Soil_monolith.jpg"
# Import EXIF data using the Wikimedia API:
x1 <- getWikiMedia.ImageInfo(imagename)
# Create a SpatialPhotoOverlay:
sm <- spPhoto(filename = x1$url$url, exif.info = x1$metadata)
# Plot it in Google Earth
kml(sm, type="monolith")
# (b) PhotoOverlay (geotagged photo):
imagename = "Africa_Museum_Nijmegen.jpg"
x2 <- getWikiMedia.ImageInfo(imagename)
af <- spPhoto(filename = x2$url$url, exif.info = x2$metadata)
kml(af)}
\keyword{ ~KML }
\keyword{ photo}
\keyword{ EXIF}