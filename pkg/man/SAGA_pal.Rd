\name{SAGA_pal}
\title{SAGA colour palettes}
\description{
22 colour palettes used by SAGA GIS. Each colour palette consists of 20 colours in the hexadecimal system. 
}
\usage{
data(SAGA_pal)
}
\author{SAGA GIS has been created by the SAGA GIS development team (lead by J. Bohner and O. Conrad, from the Institute of Geography, University of Hamburg, Germany). The colour palettes have been exported from SAGA (as ".sprm" SAGA parameter files) and ported to R by Tomislav Hengl.}
\references{
\url{http://www.saga-gis.org}
}
\note{In the data visualisation literature (and the cartography literature in particular), the rainbow (sometimes also called spectral) colour ramp is generally recognized as a bad choice for visualization of sequential/continuous variables. For more info see: Rogowitz, B.E., Treinish, L.A., (1998, December). Data visualization: the end of the rainbow. Spectrum, IEEE, 35(12):52-59 (\url{http://dx.doi.org/10.1109/6.736450}) and/or Borland, D. and Russell, M. T. II, (2007). Rainbow Color Map (Still) Considered Harmful. In: Visualization Viewpoints, (Edt) Rhyne, T.-M., pp. 14-17. 
}
\seealso{\link{R_pal}, \link{worldgrids_pal}}
\keyword{color palletes}
\examples{
data(SAGA_pal)
display.pal(SAGA_pal, sel=c(1,2,7,8,10,11,17,18,19,21,22))
}
