\name{R_pal}
\alias{R_pal}
\title{Common colour palettes used in R}
\description{
10 standard colour palettes used in R to visualize continuous and binary variables. Each colour palette consists of 20 colours in the hexadecimal system. 
}
\usage{
data(R_pal)
}
\author{Tomislav Hengl (tom.hengl@wur.nl)}
\references{
\url{http://cran.r-project.org/web/packages/RColorBrewer/}

\url{http://cran.r-project.org/web/packages/colorspace/}
}
\note{"Rainbow", "heat colors", "terrain colors", "topo colors", and "bpy colors" are the standard color palettes used in R to visualize numeric/continuous variables. "SOC", "pH" and "tex" palettes are suitable for visualization of soil variables (soil organic carbon, pH and soil texture). "Blue grey and red" is the ideal palette for visualition of binary variables (in the scale 0-1), and "grey black" is a black and white color palette that contains no white color (hence can it will not confuse low values with NA values in the PNG/GIF files).}
\seealso{\link{SAGA_pal}, \link{worldgrids_pal}}
\keyword{colour palletes}
\examples{
data(R_pal)
display.pal(R_pal)
}
