\name{spMetadata}
\alias{spMetadata}
\alias{kml_metadata}
\alias{read.metadata}
\alias{metadata2SLD}
\title{Functions for reading, generating and saving Spatial metadata.}
\description{
The \code{read.metadata} function can be used to read the formatted metadata (\code{.xml}), prepared following to the \href{http://www.fgdc.gov/metadata/csdgm/}{Federal Geographic Data Committee (FGDC) Content Standard for Digital Geospatial Metadata}, and convert them to a more readble format (dataframe).\cr
The \code{spMetadata} function will try to generate missing metadata (bounding box, location info, session info, metadata creator info) for any \code{Spatial*} object (from the sp package) or Raster* object (from the raster package). The resulting object of class \code{"SpatialMetadata"} can be used e.g. to generate a Layer description documents, that can be parsed to KML \code{<description>} by using the \code{kml_metadata} function.\cr
The \code{metadata2SLD} function will generate a Styled Layer Description (\bold{SLD}) file, that can be attached to a spatial layer contributed to \href{http://docs.geoserver.org/stable/en/user/styling/sld-introduction.html}{GeoServer}. This basically writes the \code{"sp.pallete"} object (legend entries, titles and colors) to an external file.\cr
To prepare an original metadata xml file for the layer of interest, consider first downloading the \href{http://plotkml.r-forge.r-project.org/FGDC.xml}{FGDC.xml} template file, then enter the missing fields using e.g. the \bold{Tkme}: Another editor for formal metadata, by Peter N. Schweitzer (U.S. Geological Survey).
}
\usage{spMetadata(obj, xml.file = set.file.extension(deparse(substitute(obj)), ".xml"),  
    Citation_title, Target_variable, Attribute_Measurement_Resolution = 1,
    Attribute_Units_of_Measure = "NA", Enduser_license_URL = get("license_url", envir = plotKML.opts)
    generate.missing = TRUE, GoogleGeocode = FALSE, signif.digit = 3, colour_scale, 
    bounds, legend_names, icons, validate.schema = FALSE, ...)}
\arguments{
  \item{obj}{Some \code{"Spatial"} class object with \code{"data"} slot.}
  \item{xml.file}{Optional metadata file in the FGDC format. Function automatically looks for a metadata file with the same name as the object name.}
  \item{Citation_title}{One sentence title of the object.}
  \item{Target_variable}{Target variable i.e. column name in the data slot.}
  \item{Attribute_Measurement_Resolution}{Numeric resolution (typically estimated as half the measurement precision).}
  \item{Attribute_Units_of_Measure}{Physical units.}
  \item{Enduser_license_URL}{End-user license specification (URL).}
  \item{generate.missing}{(Logical) turns on the functionality for generating metadata automatically.}
  \item{GoogleGeocode}{(Logical) should R try to estimate Indirect Spatial Reference using Google maps API?}
  \item{signif.digit}{Significant digits to round the numbers in the palette slot.}
  \item{colour_scale}{Collor scheme.}
  \item{bounds}{Upper and lower limit bounds for the target variable.}
  \item{legend_names}{(Optional) manually inserted legend names.}
  \item{icons}{(Optional) manually inserted icon names for legend names.}
  \item{validate.schema}{(Logical) should R try to validate your xml file?}  
\item{\dots}{Arguments interpreted in the context of \code{kml()} (see Details below)}
}
\value{
\item{xml}{A metadata slot of class "XMLInternalDocument".}
\item{field.names}{Corresponding metadata column names.}
\item{palette}{Formal class "sp.palette" - contain legend names and colors.}
\item{sp}{Formal class "Spatial" - bounding box and projection system of the input object.}
}
\details{
\code{spMetadata} tries to locate a metadata file in the working directory, if no \code{.xml} file exists, it will load the template xml file available in the system folder (\code{system.file("FGDC.xml", package="plotKML")}). The \code{FGDC.xml} file contains typical metadata entries with description and examples. For practical purposes, one metadata object can typically be associated with only one variable i.e. one column in the \code{"data"} slot (specified via \code{Target_variable}). \cr
By default, plotKML uses the Creative Commons license, but this can be adjusted (see examples bellow).\cr
The \code{spMetadata} function tries to generate the most usefull information, so that a user can easily find out about the input data and procedures followed to generate the visualization (KML). Typical metadata entries include e.g.:
\itemize{
\item \code{metadata[["idinfo"]][["native"]]} - Session info e.g.: Produced using R version 2.12.2 (2011-02-25) running on Windows 7 x64.
\item \code{metadata[["spdoinfo"]][["indspref"]]} - Indirect spatial reference estimated using the \href{http://code.google.com/apis/maps/documentation/webservices/}{Google Maps API Web Services}.
\item \code{metadata[["idinfo"]][["spdom"]][["bounding"]]} - Bounding box in the WGS84 geographical coordinates estimated by reprojecting the original bounding box.
}
The \code{kml_metadata} function will, by default, print out only a number of selected metadata fields: \code{"Citation_title"}, \code{"Abstract"}, \code{"Object_Count"}, \code{"Beginning_Date"}, \code{"Ending_Date"}, \code{"Data_Order_URL"}, \code{"Other_Citation_Details"}, \code{"Citation_URL"}, \code{"Data_Set_Credit"}, \code{"Data_Distributing_Organization"}, \code{"Format_Information_Content"}, \code{"Native_Data_Set_Environment"}. See \code{data(mdnames)} for a complete list of metadata fields.
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
\seealso{ \code{sp::Spatial}, \code{\link{kml_layer}}}
\examples{
\dontrun{
# Read metadata from the system file and convert to a more redable format:
x <- read.metadata(system.file("FGDC.xml", package="plotKML"))
str(x)
}
\dontrun{
# Generate missing metadata
data(eberg)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
# No metadata file specified:
eberg.md <- spMetadata(eberg, Target_variable="SAND")
# With localy prepared metadata file:
eberg.md <- spMetadata(eberg, xml.file=system.file("eberg.xml", package="plotKML"), Target_variable="SAND")
# Print the results of validation (it needs internet connection):
eberg.md <- spMetadata(eberg, Target_variable="SAND", validate.schema = TRUE)
# Write the metadata as XML:
saveXML(metadata(eberg.md), "eberg_SAND.xml")
# Export to SLD format:
metadata2SLD(eberg.md, "eberg.sld")}
}
\keyword{ ~KML }
\keyword{ metadata}