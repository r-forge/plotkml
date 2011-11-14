\name{SAGA_pal}
\docType{data}
\encoding{latin1}
\alias{color_palettes}
\alias{SAGA_pal}
\alias{R_pal}
\title{Various colour palettes for visualization of numeric variables}
\description{ \code{SAGA_pal} contains 22 colour palettes imported from SAGA GIS. \code{R_pal} 10 standard colour palettes used in R to visualize continuous and binary variables. Each colour palette consists of 20 colours in the hexadecimal system. Use \code{display.pal} function to plot different sets of palettes.}
\usage{
data(SAGA_pal)
data(R_pal)
}
\author{\href{http://www.saga-gis.org}{SAGA GIS} has been created by the SAGA GIS development team (lead by J. \enc{Böhner}{Boehner} and O. Conrad, from the Institute of Geography, University of Hamburg, Germany). The colour palettes have been exported from SAGA (as \code{".sprm"} SAGA parameter files) and ported to R. All palletes were prepared by Tomislav Hengl (\email{tom.hengl@wur.nl}).}
\references{
\itemize{
\item Rogowitz, B.E., Treinish, L.A., (1998, December). \href{http://dx.doi.org/10.1109/6.736450}{Data visualization: the end of the rainbow}. Spectrum, IEEE, 35(12):52-59 
\item Borland, D. and Russell, M. T. II, (2007). Rainbow Color Map (Still) Considered Harmful. In: Visualization Viewpoints, (Edt) Rhyne, T.-M., pp. 14-17.
\item \url{http://cran.r-project.org/web/packages/RColorBrewer/}
\item \url{http://cran.r-project.org/web/packages/colorspace/}
}
}
\note{\code{rainbow_75}, \code{heat colors}, \code{terrain_colors}, \code{topo_colors}, and \code{bpy_colors} are the standard color palettes used in R to visualize numeric/continuous variables. \code{soc_pal}, \code{pH_pal} and \code{tex_pal} palettes are suitable for visualization of soil variables (soil organic carbon, pH and soil texture). \code{blue_grey_red} is recommended for visualition of binary variables (values in the range 0-1), and \code{grey_black} is a white-to-black type color palette that contains no white color (hence it will not confuse low values with NA values in the PNG/GIF files).\cr 
Possibly the most used palettes for visualization of numeric variables are \code{rev(rainbow(65)[1:48])} and \code{SAGA_pal[[1]]} (SAGA default palette). Although many users will likely use \code{SG_COLORS_DEFAULT} or \code{rainbow_75} as default palettes to visualize numeric variables, it is worth mentioning that in the data visualisation literature (and the cartography literature in particular), the rainbow (sometimes also called spectral) colour ramp is generally recognized as a \emph{bad choice} for visualization of sequential/continuous variables (Rogowitz and Treinish, 1998; Borland and Russell, 2007).  
}
\seealso{\code{\link{worldgrids_pal}}, \code{\link{RColorBrewer::display.brewer.all}}}
\examples{
data(SAGA_pal)
\dontrun{
display.pal(SAGA_pal, sel=c(1,2,7,8,10,11,17,18,19,21,22))
dev.off()
display.pal(R_pal)
dev.off()
}
}
\keyword{colour palletes}
\keyword{SAGA GIS}
\keyword{datasets}
