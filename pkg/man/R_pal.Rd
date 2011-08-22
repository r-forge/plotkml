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
\note{\code{rainbow_75}, \code{heat colors}, \code{terrain_colors}, \code{topo_colors}, and \code{bpy_colors} are the standard color palettes used in R to visualize numeric/continuous variables. \code{soc_pal}, \code{pH_pal} and \code{tex_pal} palettes are suitable for visualization of soil variables (soil organic carbon, pH and soil texture). \code{blue_grey_red} recommended for visualition of binary variables (in the scale 0-1), and \code{grey_black} is a white-to-black type color palette that contains no white color (hence it will not confuse low values with NA values in the PNG/GIF files).}
\seealso{\link{SAGA_pal}, \link{worldgrids_pal}}
\keyword{colour palletes}
\examples{
display.pal(R_pal)
}
