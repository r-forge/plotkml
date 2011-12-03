\name{kml_open}
\alias{kml_open}
\alias{kml_close}
\title{Opens / closes a KML file connection}
\description{Opens a KML file in write mode and initiates the KML header. The same file connection is further accessible by other \code{kml_*()} functions such as \code{kml_layer()} and \code{kml_close()}. This allows creation of customized multi-layered KML files.}
\usage{
kml_open(file.name, folder.name = file.name,
  open = TRUE, overwrite = TRUE, kml_xsd, ...)
}
\arguments{
  \item{file.name}{KML file name}
  \item{folder.name}{character string; KML folder name}
  \item{overwrite}{logical; If TRUE, "name" will be overwritten if it exists}
  \item{kml_xsd}{URL of the KML scheme to be used}
  \item{\dots}{other arguments}
}
\author{Pierre Roudier and Dylan Beaudette}
\details{See plotKML package homepage / vignette for more examples.}
\seealso{ \code{\link{kml}}, \code{\link{kml.Spatial}} }
\examples{
data(eberg_grid)
kml_open("eberg_grid_DEM.kml")
kml_layer(eberg_grid, colour=DEM)
kml_close("eberg_grid_DEM.kml")
# print the result:
xmlRoot(xmlTreeParse("eberg_grid_DEM.kml"))[["Document"]]}
\keyword{ ~KML}

