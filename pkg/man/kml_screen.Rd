\name{kml_screen}
\alias{kml_screen}
\title{Add a screen overlay}
\description{Puts a selected image file (map legend or logo) as Screen overlay.}
\usage{
kml_screen(image.file, sname = "", position = c("UL","ML","LL","BC","LR","MR","UR","TC")[1],
  overlayXY, screenXY, xyunits = c("fraction", "pixels", "insetPixels")[1], rotation = 0, size = c(0,0) )
}
\arguments{
  \item{image.file}{image file to be used for screen overlay}
  \item{sname}{screen overlay name}
  \item{position}{one of the nine standard positions}
  \item{overlayXY}{manually specified tie point on the overlay image e.g. \code{overlayXY = 'x="0" y="1"'}}
  \item{screenXY}{manually specified matching tie point on the scren e.g. \code{screenXY = 'x="0" y="1"'}}
  \item{xyunits}{values of the XY units ((\code{"pixels"}, \code{"fraction"}, or \code{"insetPixels"})}
  \item{rotation}{(optional) rotation in degrees clock-wise}
  \item{size}{size correction in \emph{x} and \emph{y} direction}
}
\details{If nothing else is specified the function looks for some of the nine typical positions: \code{"UL"} (upper left), \code{"ML"} (middle left), \code{"LL"} (lower left), \code{"BC"} (bottom centre), \code{"LR"} (lower right), \code{"MR"} (middle right), \code{"UR"} (upper right), and \code{"TC"} (top centre). The \emph{x} and \emph{y} values can be specified in three different ways: as pixels (\code{"pixels"}), as fractions of the image (\code{"fraction"}), or as inset pixels (\code{"insetPixels"}) --- an offset in pixels from the upper right corner of the image.}
\note{The function, by default, calculates with fractions. If you change the \code{xyunits} type, all other elements need to be expressed in the same units.}
\references{
\itemize{
\item KML Reference (\url{http://code.google.com/apis/kml/documentation/})
}
}
\author{ Tomislav Hengl (tom.hengl@wur.nl) }
\seealso{ \code{\link{kml}}
}
\examples{
data(eberg_zones)
\dontrun{
kml_open("eberg_zones.kml")
kml_layer(eberg_zones)
logo = "http://meta.isric.org/images/ISRIC_right.png"
kml_screen(image.file = logo, position = "TC", sname = "ISRIC logo")
kml_close("eberg_zones.kml")
kml_compress("eberg_zones.kml")}
}
