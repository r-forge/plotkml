\name{spMetadata_inspire}
\alias{spMetadata_inspire}
\title{Generate INSPIRE-compliant metadata from an sp object}
\description{The \code{spMetadata_inspire} function will try to generate missing metadata (bounding box, location info, session info, metadata creator info and similar) for any \code{Spatial*} object (from the sp package). It tries to generate metadata from an external file. If no metadata file is available, it tries to fill in missing columns based on the data properties and provided information.}
\usage{spMetadata_inspire(obj, xml.file, generate.missing = T, 
Target_variable, Citation_title, Abstract, Lineage, Use_Limitation, 
MD_Organisation_name, MD_Mail_address, Organisation_name, Mail_address, 
Responsible_Party_Role = c("resourceProvider", "custodian", "owner", 
"user", "distributor", "originator", "pointOfContact", 
"principalInvestigator", "processor", "publisher", "author"), 
Language = c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", 
"fre", "ger", "gre", "hun", "gle", "ita", "lav", "lit", "mlt", "pol", 
"por", "rum", "slo", "slv", "spa", "swe"), 
MD_Language = c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", 
"fre", "ger", "gre", "hun", "gle", "ita", "lav", "lit", "mlt", "pol", 
"por", "rum", "slo", "slv", "spa", "swe"), 
Topic_Category = c("geoscientificInformation", "farming", "biota", 
"boundaries", "climatologyMeteorologyAtmosphere", "economy", 
"elevation", "environment", "health", "imageryBaseMapsEarthCover", 
"intelligenceMilitary", "inlandWaters", "location", "oceans", 
"planningCadastre", "society", "structure", "transportation", 
"utilitiesCommunication"), 
Access_Constr = c("otherRestrictions", "copyright", "patent", "patentPending", 
"trademark", "license", "intellectualPropertyRights", "restricted"), 
Other_Constr, Spatial_Resolution_Denom, Spatial_Resolution_Distance, 
Spatial_Resolution_Unit, Conformity_Spec_Title, Conformity_Date, 
Conformity_Date_Type = c("publication", "creation", "revision"), 
Conformity_Degree = F, Resource_Locator, Resource_Identifier, 
Resource_Identifier_CodeSpace, Keywords, Thesaurus_Title, Thesaurus_Date, 
Thesaurus_Date_Type = c("publication", "creation", "revision"), 
Temporal_Reference_Date, 
Temporal_Reference_Date_Type = c("publication", "creation", "revision"), 
Temp_Extent_Beg, Temp_Extent_End)}
\arguments{
  \item{obj}{some \code{"Spatial"} class object with \code{"data"} slot}
  \item{xml.file}{character; optional XML metadata file in INSPIRE-ISO 19139 encoding}
  \item{generate.missing}{logical; specifies whether to automatically generate missing fields}
  \item{Citation_title}{character; title of the bibliographic reference for this data set}
  \item{Target_variable}{character; target variable name}
  \item{Abstract}{character; a brief narrative summary of the data set}
  \item{Lineage}{character; a short explanation of the data producers knowledge about the lineage of a dataset}
  \item{Use_Limitation}{character; defines the conditions for access and use of the dataset, e.g. "no conditions apply"}
  \item{MD_Organisation_name}{character; name of the organisation responsible for the metadata}
  \item{MD_Mail_address}{character; metadata contact e-mail address}
  \item{Organisation_name}{(optional) character; name of the organisation responsible for the dataset; if not provided, MD_Organisation_name is used}
  \item{Mail_address}{(optional) character; contact e-mail address; if not provided, MD_Mail_Address is used}
  \item{Responsible_Party_Role}{(optional) character; must be one of c("resourceProvider", "custodian", "owner", "user", "distributor", "originator", "pointOfContact", "principalInvestigator", "processor", "publisher", "author"); default = "resourceProvider"}
  \item{Language}{(optional) character; dataset language, restricted to EU only; thus, must be one of c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", "fre", "ger", "gre", "hun", "gle", "ita", "lav", "lit", "mlt", "pol", "por", "rum", "slo", "slv", "spa", "swe"); default = "eng"}
  \item{MD_Language}{(optional) character; metadata language, restricted to EU only; thus, must be one of c("eng", "bul", "hrv", "cze", "dan", "dut", "est", "fin", "fre", "ger", "gre", "hun", "gle", "ita", "lav", "lit", "mlt", "pol", "por", "rum", "slo", "slv", "spa", "swe"); default = "eng"}
  \item{Topic_Category}{(optional) a character vector; must be of c("geoscientificInformation", "farming", "biota", "boundaries", "climatologyMeteorologyAtmosphere", "economy", "elevation", "environment", "health", "imageryBaseMapsEarthCover", "intelligenceMilitary", "inlandWaters", "location", "oceans", "planningCadastre", "society", "structure", "transportation", "utilitiesCommunication"); default = "geoscientificInformation"}
  \item{Access_Constr}{(optional) character; must be one of c("otherRestrictions", "copyright", "patent", "patentPending", "trademark", "license", "intellectualPropertyRights", "restricted"); default = "otherRestrictions"}
  \item{Other_Constr}{(optional) character; other restrictions and legal prerequisites for accessing and using the dataset; define only if Access_Constr = "otherRestrictions"}
  \item{Spatial_Resolution_Denom}{a numeric vector; level of detail expressed as the scale denominator, e.g. 25000 for a 1:25K scale map; either Spatial_Resolution_Denom or Spatial_Resolution_Distance must be defined}
  \item{Spatial_Resolution_Distance}{a numeric vector; number expressing the ground sample distance, e.g. 0.25 (degrees); either Spatial_Resolution_Denom or Spatial_Resolution_Distance must be defined}
  \item{Spatial_Resolution_Unit}{(optional) character; a unit of measure of the corresponding distance values, e.g. "mm" for millimeter; default = "m"}
  \item{Conformity_Spec_Title}{(optional) character; product specification or user requirement against which data is being evaluated; must be a valid document in order to pass INSPIRE-compliance validation tests, e.g. "Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services"; needs to match the language-argument, i.e. here "eng" must be set, otherwise the resulting xml-document will not pass any INSPIRE-related validation tests}
  \item{Conformity_Date}{(optional) character; reference date of the product specification or user requirement against which data is being evaluated; follow the ISO 8601 standard, i.e. yyyy-mm-dd}
  \item{Conformity_Date_Type}{(optional) character; must be one of c("publication", "creation", "revision"); default = "publication"}
  \item{Conformity_Degree}{(optional) logical; true if conformant, false if not conformant; if conformity has not been evaluated (yet), leave empty}
  \item{Resource_Locator}{(optional) character; URL for online access, e.g. link to service capabilities document or website with further instructions}
  \item{Resource_Identifier}{(optional) character; value uniquely identifying an object within a namespace; the use of UUIDs is recommended}
  \item{Resource_Identifier_CodeSpace}{(optional) character; namespace related to the unique resource identifier, e.g. "http://www.lgi.geographie.uni-kiel.de:sardinian_testsites"}
  \item{Keywords}{a character vector; the first keyword must be one of \href{http://inspire.jrc.ec.europa.eu/index.cfm/pageid/2/list/7}{INSPIRE spatial data themes}}
  \item{Thesaurus_Title}{(optional) character vector; an originating controlled vocabulary, e.g. "GEMET - Concepts" or "AGROVOC"}
  \item{Thesaurus_Date}{(optional) character; reference date of the associated thesaurus; follow the ISO 8601 standard, i.e. yyyy-mm-dd}
  \item{Thesaurus_Date_Type}{(optional) character; must be one of c("publication", "creation", "revision"); default = "publication"}
  \item{Temporal_Reference_Date}{a character vector; reference date of the dataset; follow the ISO 8601 standard, i.e. yyyy-mm-dd}
  \item{Temporal_Reference_Date_Type}{(optional) character vector; must be one of c("publication", "creation", "revision"); default = "publication"}
  \item{Temp_Extent_Beg}{(optional, if temporal reference is set) character vector; begin of the time period covered by the content of the dataset; date (ISO 8601) or date-time object (ISO 19108), e.g. "2010-10-10" or "2012-10-10T11:12:13"}
  \item{Temp_Extent_End}{(optional, if temporal reference is set) character vector; end of the time period covered by the content of the dataset; date (ISO 8601) or date-time object (ISO 19108), e.g. "2010-10-10" or "2012-10-10T11:12:13"}}
\details{
\code{spMetadata_inspire} tries to locate a metadata file in the working directory (it looks for a metadata file with the same name as the object name). If no \code{.xml} file exists, it will load the template xml file available in the system folder. The \code{INSPIRE_ISO19139.xml} file contains typical metadata entries with description and examples. For practical purposes, one metadata object in plotKML can be associated with only one variable i.e. one column in the \code{"data"} slot (specified via \code{Target_variable}). Before committing the metadata file, try running the \href{http://inspire-geoportal.ec.europa.eu/validator2/}{INSPIRE Geoportal Metadata Validator}.\cr
\code{spMetadata_inspire} tries to automatically generate as much information as possible. Created metadata entries include e.g.:
\itemize{
\item \code{metadata[["fileIdentifier"]][["CharacterString"]]} --- Metadata file identifier (not mandatory for INSPIRE-compl.) created by UUIDgenerate from package UUID (version 4 UUID). 
\item \code{metadata[["dateStamp"]][["Date"]]} --- Metadata date stamp created using Sys.Date().
\item \code{metadata[["identificationInfo"]][["MD_DataIdentification"]]
[["extent"]][["EX_Extent"]][["geographicElement"]][["EX_GeographicBoundingBox"]]} --- Bounding box in the WGS84 geographical coordinates estimated by reprojecting the original bounding box.
}
}
\references{
\itemize{
\item INSPIRE, INS MD, Commission Regulation (EC) No 1205/2008 of 3 December 2008 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards metadata (Text with EEA relevance). See also Corrigendum to INSPIRE Metadata Regulation (\url{http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2008:326:0012:0030:EN:PDF})
\item INSPIRE, INS MDTG, INSPIRE Metadata Implementing Rules: Technical Guidelines based on EN ISO 19115 and EN ISO 19119, v1.3 (2013-10-29) (\url{http://inspire.jrc.ec.europa.eu/documents/Metadata/MD_IR_and_ISO_20131029.pdf})
\item GDI-DE, (2008) Deutsche Uebersetzung der Metadatenfelder des ISO 19115: Geographic information - Metadata. GDI-DE Koordinierungsstelle (\url{http://www.geoportal.de/SharedDocs/Downloads/DE/GDI-DE/Deutsche_Uebersetzung_der_ISO-Felder.pdf})
\item INSPIRE metadata xml-file following ISO/TS 19139 encodings (\url{http://plotkml.r-forge.r-project.org/INSPIRE_ISO19139.xml})
\item EN ISO 8601:2004, Data elements and interchange formats - Information interchange alt+45 Representation of dates and times
\item EN ISO 19108:2005, Geographic Information - Temporal Schema
\item ISO/TS 19139:2007, Geographic information - Metadata - XML schema implementation
}}
\author{Michael Blaschek and Tomislav Hengl}
\seealso{\code{\link{kml_metadata}}, \code{\link{SpatialMetadata-class}}, \code{\link{spMetadata.Spatial}}, \code{sp::Spatial}}
\examples{\dontrun{# read metadata from the system file:
x <- read.metadata(system.file("INSPIRE_ISO19139.xml", package="plotKML"))
str(x)
# generate missing metadata
data(eberg)
library(sp)
coordinates(eberg) <- ~X+Y
proj4string(eberg) <- CRS("+init=epsg:31467")
eberg.md <- spMetadata_inspire(
  obj = eberg, 
  Target_variable = "SNDMHT_A",
  Citation_title = "Sand content of the Ebergotzen soil mapping case study",
  Abstract = "Sand content from 3670 observations (augers) of 
    soil textures at depths 0-10 cm.",
  Lineage = "Texture by hand method can be used to determine 
    the content of soil earth fractions only to an accuracy of +- 5-10 prc",
  Use_Limitation = "unknown",
  MD_Organisation_name = "Christian-Albrechts-University Kiel, 
    Physical Geography - Landscape Ecology and Geoinformation Science",
  Organisation_name = "State Authority for Mining, 
    Energy and Geology, Hanover, Germany",
  MD_Mail_address = "blaschek@geographie.uni-kiel.de",
  Mail_address = "Ernst.Gehrt@lbeg.niedersachsen.de",
  MD_Language = "eng",
  Language = "eng",
  Topic_Category = c("geoscientificInformation", "environment"),
  Access_Constr = "copyright",
  Spatial_Resolution_Distance = 25,
  Spatial_Resolution_Unit = "m",
  Conformity_Spec_Title = "Commission Regulation (EU) No 1089/2010 of 
    23 November 2010 implementing Directive 2007/2/EC of the European 
    Parliament and of the Council as regards interoperability of spatial 
    data sets and services", 
  Conformity_Date = "2010-12-08", 
  #Conformity_Date_Type = "publication", 
  Conformity_Degree = T,
  Resource_Locator = "http://geomorphometry.org/content/ebergotzen",
  Resource_Identifier = "SNDMHT_A",
  Keywords = c("Soil", "Soil texture fraction"),
  Temporal_Reference_Date = "2009-08-20",
  Temporal_Reference_Date_Type = "publication")
# write the metadata to a file:
library(XML)
saveXML(eberg.md, file = paste(getwd(), "eberg_sand.xml", sep = '/'))
}}
\keyword{spatial}
\keyword{inspire}