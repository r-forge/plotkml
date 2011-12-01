\name{getWikiMedia.ImageInfo}
\alias{getWikiMedia.ImageInfo}
\title{Gets EXIF information from the Wikimedia Commons multimedia repository}
\description{
\code{getWikiMedia.ImageInfo} function fetches the EXIF data via the \href{http://www.mediawiki.org/wiki/API}{Wikimedia API} for any donated image. The resulting EXIF data (named list) can then be further used to construct a \code{"SpatialPhotoOverlay"} object and then parsed to KML.
}
\usage{getWikiMedia.ImageInfo(imagename, APIsource = "http://commons.wikimedia.org/w/api.php", 
    module = "imageinfo", details = c("url", "metadata", "size", "extlinks"), testURL = TRUE)
}
\arguments{
  \item{imagename}{Wikimedia commons unique image title}
  \item{APIsource}{location of the API service}
  \item{module}{default module}
  \item{details}{detailed parameters of interest}
  \item{testURL}{logical; species if the program should first test whether the image exist at all (recommended)}
}
\details{Almost any image uploaded to Wikimedia will show a number of EXIF metadata. However, it is highly recommended that you embbed the most important/usefull tags yourself e.g. by using the \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{EXIF tool} (courtesy of Phil Harvey), before uploading files to Wikimedia. the \code{getWikiMedia.ImageInfo} function assumes that all required metadata has been entered by the user before the upload. Examples of how to embed EXIF tags into an image file are available \href{http://commons.wikimedia.org/wiki/Commons:EXIF}{here}. To geocode an uploaded image consider adding \code{{{location|lat deg|lat min|lat sec|NS|long deg|long min|long sec|EW}}} tag to the file description.\cr 
For a list of modules and parameters that can be used via \code{getWikiMedia.ImageInfo}, please refer to \href{http://www.mediawiki.org/wiki/API}{Wikimedia API manual}.
}
\references{
\itemize{
\item Wikimedia API (\url{http://www.mediawiki.org/wiki/API})
\item EXIF tool (\url{http://www.sno.phy.queensu.ca/~phil/exiftool/})
\item EXIF Tags (\url{http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html})
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{\code{\link{spPhoto}}, \code{Rexif::getExifPy}}
\examples{
\dontrun{
## Photo taken using a GPS-enabled camera:
imagename = "Africa_Museum_Nijmegen.jpg"
x <- getWikiMedia.ImageInfo(imagename)
x1$metadata}
## this results in a fairly complete list of metadata tags (including location and orientation);
}
\keyword{ ~KML }
\keyword{ wikimedia API }
\keyword{ EXIF }