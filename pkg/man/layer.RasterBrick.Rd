\name{kml_layer.RasterBrick}
\alias{kml_layer.RasterBrick}
\alias{RasterBrick}
\title{Exports a time series of images to KML}
\description{Writes a series of images to png and creates ground overlays. Works only with \code{"RasterBrick"} class objects with time dimension specified via the \code{"@zvalue"}.}
\usage{
kml_layer.RasterBrick(obj, dtime = "", extrude = FALSE, tz = "GMT", z.lim = c("min", "max"),
   colour_scale = get("colour_scale_numeric", envir = plotKML.opts),
   metadata = NULL, html.table = NULL,  \dots)
}
\arguments{
  \item{obj}{object of class \code{"RasterBrick"} (a time series of images)}
  \item{dtime}{temporal support (point or block) expressed in seconds}
  \item{extrude}{logical}
  \item{tz = "GMT"}{referent time zone}
  \item{z.lim}{upper and lower limits (unique for all maps in the time series); by default -- the absolute minimum and maximum in values}
  \item{colour_scale}{color palette; by default using the color scale for numeric variables}
  \item{metadata}{(optional) specify the metadata object}
  \item{html.table}{(optional) description block (html) for each raster layer}
  \item{\dots}{additional style arguments (see \code{aesthetics})}
}
\details{This method is recommended for visualization of numeric bands representing the same variable i.e. time series of images. To export a stack of images of different type see \code{\link{kml_layer.Raster}}. If the \code{"@zvalue"} slot is empty, dates will be added by subtracting days from the current day with 1--day increments.
}
\author{Tomislav Hengl (\email{tom.hengl@wur.nl})}
\seealso{ \code{\link{kml}}, \code{\link{kml_open}}, \code{\link{kml_layer.Raster}} }
\examples{
data(LST)
data(SAGA_pal)
# time dimension defined via zvalue slot:
LST@zvalue[c(1,12,24)]
\dontrun{
# subset to 3 images:
LSTs <- brick(raster(LST, 1), raster(LST, 12), raster(LST, 24))
LST_ll <- reproject(LSTs, program="FWTools")
# copy the dates:
LST_ll@zvalue <- LST@zvalue[c(1,12,24)]
# KML plot with block temporal support of 8 days:
kml(LST_ll, colour_scale=SAGA_pal[[1]], dtime=8*24*60^2)}
}
\keyword{ ~KML}
\keyword{ RasterBrick}

