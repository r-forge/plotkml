\name{kml_open}
\alias{kml_open}
\alias{kml_close}
\title{Opens / closes a KML file connection}
\description{
Opens a KML file in write mode and initiates the KML header. It is then setting up a file connection accessible by other kml_*() function such as kml_layer() and kml_close() to create customized multi-layered KML files.
}
\usage{
kml_open(file, name = file, overwrite = FALSE, kml.url = "http://www.opengis.net/kml/2.2")
}
\arguments{
  \item{file}{either a character string naming a file.}
  \item{name}{A name for the KML file to be created.}
  \item{overwrite}{Logical. If TRUE, "name" will be overwritten if it exists.}
  \item{kml.url}{URL of the KML standard to be used.}
}
\author{Pierre Roudier and Dylan Beaudette}
\seealso{
\code{\link{kml}}, \code{\link{kml_layer}}
}
\examples{

}
\keyword{ ~KML}

