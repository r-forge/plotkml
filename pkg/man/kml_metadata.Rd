\name{kml_metadata}
\alias{kml_metadata}
\title{Add metadata table to the active layer}
\description{Adds a selection of metadata to the description box of an active layer.}
\usage{
kml_metadata(obj, sel, fix.enc = TRUE, cwidth = 150, twidth = 500,
    full.names = "", delim.sign = "_", asText = FALSE)
}
\arguments{
  \item{obj}{object of class \code{"SpatialMetadata"}}
  \item{sel}{a selection of metadata fields (see below)}
  \item{fix.enc}{logical; species whether the text in the XML file should be converted to UTF8}
  \item{cwidth}{html column width for the field names}
  \item{twidth}{html total table width}
  \item{full.names}{(optional) character vector; a list of full metadata names (field names)}
  \item{delim.sign}{delimiter symbol}
  \item{asText}{logical; return the output as XML or characters}
}
\details{The \code{kml_metadata} function, by default, prints out only a number of selected metadata fields: \code{"Citation_title"}, \code{"Abstract"}, \code{"Object_Count"}, \code{"Beginning_Date"}, \code{"Ending_Date"}, \code{"Data_Order_URL"}, \code{"Other_Citation_Details"}, \code{"Citation_URL"}, \code{"Data_Set_Credit"}, \code{"Data_Distributing_Organization"}, \code{"Format_Information_Content"}, \code{"Native_Data_Set_Environment"}. See \code{data(mdnames)} for a complete list of metadata fields. }
\author{ Tomislav Hengl }
\seealso{ \code{\link{spMetadata}}}
