\name{write.legend.png}
\alias{write.legend.png}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Prints legends (png) for continuous and factor-type variables for Google Earth plots
%%  ~~function to do ... ~~
}
\description{ Makes a png file with legend to be used as a screen overlay in Google Earth 
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
write.legend.png(x, var.type, var.name, legend.file.name, legend.pal, z.lim, factor.labels)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ sp-class object (Grid, Pixel, Polygons, Lines)
%%     ~~Describe \code{x} here~~
}
  \item{var.type}{ variable type - \code{factor} or \code{numeric}
%%     ~~Describe \code{var.type} here~~
}
  \item{var.name}{ column name specifying variable of interest
%%     ~~Describe \code{var.name} here~~
}
  \item{legend.file.name}{ output file name
%%     ~~Describe \code{legend.file.name} here~~
}
  \item{legend.pal}{ color pallette to be used for the legend
%%     ~~Describe \code{legend.pal} here~~
}
  \item{z.lim}{ vector with upper and lower limits
%%     ~~Describe \code{z.lim} here~~
}
  \item{factor.labels}{ text labels in the case of \code{factor} variable
%%     ~~Describe \code{factor.labels} here~~
}
}
\details{ The default size of the legend file is width=120, height=240. For factor variables with high number of categories legend might strech over the whole screen.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{ Tomislav Hengl, Pierre Roudier \& Dylan Beaudette
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ \code{\link{mix3cols}}, \code{\link{mix5cols}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
## numeric:
write.legend.png(meuse.grid, var.name="dist")
## factor (set palette):
write.legend.png(meuse.grid, var.name="ffreq", legend.pal=c("black","orange","blue"))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
