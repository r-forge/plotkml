\name{metadata2SLD}
\alias{metadata2SLD.SpatialPixels}
\title{Create a Styled Layer Description (\bold{SLD}) file}
\description{Creates a Styled Layer Description (\bold{SLD}) file, that can be attached to a spatial layer contributed to \href{http://docs.geoserver.org/stable/en/user/styling/sld-introduction.html}{GeoServer}. This basically writes the \code{"sp.pallete"} object (legend entries, titles and colors) to an external file.}
\usage{
metadata2SLD(obj, obj.name = deparse(substitute(obj)), 
  sld.file = set.file.extension(obj.name, ".sld"), 
  Citation_title = xmlValue(obj@xml[["//title"]]), 
  ColorMap_type = "intervals", opacity = 1)
}
\arguments{
  \item{obj}{object of class \code{"SpatialMetadata"}}
  \item{obj.name}{object name to be inserted in the description tab}
  \item{sld.file}{external SLD file}
  \item{Citation_title}{full description of the layer}
  \item{ColorMap_type}{html total table width}
  \item{opacity}{optional opacity index (0-1)}
}
\details{The structure of the SLD file is determined by the object class (Point, Polygon, SpatialPixels). }
\author{ Tomislav Hengl }
\seealso{ \code{\link{spMetadata}}
}
