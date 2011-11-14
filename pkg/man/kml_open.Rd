\name{kml_open}
\alias{kml_open}
\alias{kml_close}
\title{Opens / closes a KML file connection}
\description{
Opens a KML file in write mode and initiates the KML header. The same file connection is further accessible by other \code{kml_*()} functions such as \code{kml_layer()} and \code{kml_close()}. This allows creation of customized multi-layered KML files.
}
\usage{
kml_open(file, name = file, overwrite = FALSE, 
kml.url = get("kml_url", envir = plotKML.opts))
}
\arguments{
  \item{file}{either a character string naming a file.}
  \item{name}{A name for the KML file to be created.}
  \item{overwrite}{Logical. If TRUE, "name" will be overwritten if it exists.}
  \item{kml.url}{URL of the KML standard to be used.}
}
\author{Pierre Roudier and Dylan Beaudette}
\seealso{ \code{\link{kml}}, \code{\link{kml_layer}} }
\examples{

}
\keyword{ ~KML}

