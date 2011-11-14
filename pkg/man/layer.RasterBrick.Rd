\name{kml_layer.RasterBrick}
\alias{RasterBrick}
\title{Export a time series of rasters to KML}
\description{Writes a series of images to png and creates ground overlays. }
\usage{
kml_layer.RasterBrick(obj, obj.title, id.name, dtime = 0, extrude = FALSE,
   z.scale = 1, metadata = FALSE, html.table = NULL)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{obj.title}{object title that will be inserted in the folder name}
  \item{dtime}{temporal support - point or block}
  \item{metadata}{logical; should metadata be printed?}
  \item{html.table}{optional description block (html) for each GPS point (vertices)}
  \item{tz = "GMT"}{time zone}
  \item{z.lim}{upper and lower limits (unique for all maps in the time series)}
}
\details{This method is recommended for numeric bands representing the same feature i.e. the same variable (time series of images). To export a stack of images of different type see \code{\link{kml_layer.Raster}}.
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{kml_layer.Raster}} }
\examples{
data(LST)
# time dimension defined via zvalue slot:
LST@zvalue[1:2]
\dontrun{
# subset to 5 images:
LSTs <- brick(raster(LST, 1), raster(LST, 2), raster(LST, 3))
LST.ll <- reproject(LST, program="FWTools")
LST.ll@zvalue = LST@zvalue
# KML plot with block temporal support of 8 days:
kml(LST.ll, colour_scale=SAGA_pal[[1]], dtime=8*24*60^2)}
}
\keyword{ ~KML}

