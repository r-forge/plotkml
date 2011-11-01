\name{spMetadata}
\alias{spMetadata}
\alias{kml_metadata}
\alias{read.metadata}
\alias{metadata2MEF}
\alias{metadata2SLD}
\title{Functions for reading, generating and writing Spatial metadata.}
\description{
The \code{read.metadata} function can be used to read the formatted metadata (.xml), prepared following to the \href{http://www.fgdc.gov/metadata/csdgm/}{Federal Geographic Data Committee (FGDC) Content Standard for Digital Geospatial Metadata}, and convert them to a more readble dataframe format.\cr
The \code{spMetadata} function will try to generate missing metadata (bounding box, location info, session info, metadata creator info) for any \preformatted{Spatial*} object (from the sp package) or Raster* object (from the raster package). The resulting object of class \preformatted{"spMetadata"} can be used e.g. to generate a Layer description document, that can be parsed to KML \preformatted{<description>} by using the \code{kml_metadata} function.\cr
The \code{metadata2MEF} and \code{metadata2SLD} are two additional functions for exporting generated metadata to Metadata Exchange Format (\bold{MEF}) and Styled Layer Description (\bold{SLD}) formats.\cr
To prepare an original metadata xml file for the layer of interest, consider first downloading the \href{http://plotkml.r-forge.r-project.org/FGDC.xml}{FGDC.xml} template file and then enter the missing fields using the \bold{Tkme}: Another editor for formal metadata, by Peter N. Schweitzer (U.S. Geological Survey).
}
\usage{spMetadata(obj, ...)}
\arguments{
  \item{obj}{An object inheriting from the Spatial or the BasicRaster classes.}
\item{\dots}{Arguments interpreted in the context of kml() (see Details below)}
}
\details{
\code{spMetadata} tries to locate a metadata file in the working directory, if no \code{.xml} file exists, it will load the template xml file available in the system folder (\code{system.file("FGDC.xml", package="plotKML")}). The \code{FGDC.xml} file contains minimum required metadata entries with description and examples. \cr
By default, \link{plotKML} sets the Creative Commons license, but this can be manually adjusted (see examples bellow).
}
\value{The spMetadata function tries to generate the most usefull information, so that any user of the KML file can easily find out about the input data and procedures followed to generate the file. Typical metadata entries include e.g.:
\item{\preformatted{ml[["idinfo"]][["native"]]}}{Session info e.g.: Produced using R version 2.12.2 (2011-02-25) running on Windows 7 x64.}
\item{\preformatted{ml[["spdoinfo"]][["indspref"]]}}{Indirect spatial reference estimated using the \href{http://code.google.com/apis/maps/documentation/webservices/}{Google Maps API Web Services
}.}
\item{\preformatted{ml[["idinfo"]][["spdom"]][["bounding"]]}}{Bounding box in the WGS84 geographical coordinates estimated by reprojecting the original bounding box.}
}
\references{
\itemize{
\item The Federal Geographic Data Committee, (2006) FGDC Don't Duck Metadata - A short reference guide for writing quality metadata. Vers. 1, \url{http://www.fgdc.gov/metadata/documents/MetadataQuickGuide.pdf}
\item Content Standard for Digital Geospatial Metadata (\url{http://www.fgdc.gov/metadata/csdgm/})
\item Template metadata file (\url{http://plotkml.r-forge.r-project.org/FGDC.xml})
\item Tkme metadata editor (\url{http://geology.usgs.gov/tools/metadata/tools/doc/tkme.html})
\item Creative Commons license (\url{http://creativecommons.org/licenses/})
}
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl}), Pierre Roudier, and Dylan Beaudette (\email{debeaudette@ucdavis.edu})}
\seealso{ \code{\link{sp::Spatial}}, \code{\link{kml_layer}}}
\examples{
# Read metadata from the system file:

\dontrun{
# Generate missing metadata

# Export to MEF / SLD files

}
}
\keyword{ ~KML }
\keyword{ metadata}