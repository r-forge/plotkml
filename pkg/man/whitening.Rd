\name{whitening}
\alias{whitening}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Whitening
%%  ~~function to do ... ~~
}
\description{ Derivation of the whitening colour, which is used to visualize uncertainty in the data.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
whitening(x, xvar, z.lim = c(min(x, na.rm=TRUE), max(x, na.rm=TRUE)),  e.lim = c(.4,1), global.var = var(x, na.rm=TRUE), col.type = "RGB"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ Numeric vector
%%     ~~Describe \code{x} here~~
}
  \item{xvar}{ Associated uncertainty (variance)
%%     ~~Describe \code{var.name} here~~
}
  \item{x.lim}{ Upper and lower limits for x
%%     ~~Describe \code{x.lim} here~~
}
  \item{e.lim}{ Upper and lower limits for the normalized standard deviation
%%     ~~Describe \code{e.lim} here~~
}
  \item{global.var}{ Global variance
%%     ~~Describe \code{global.var} here~~
}
  \item{col.type}{ Color scheme ("hex" or "RGB")
%%     ~~Describe \code{col.type} here~~
}
}
\details{ Calculation of the whitening colour is based on the Hue-Saturation-Intensity (HSI) color model and mixing of colours. The HSI is a psychologically appealing color model: hue is used to visualize values and whitening (paleness) is used to visualize the uncertainty. Unlike standard legends for continuous variables, this legend has two axis - one for value range and one for uncertainty range.
The standard range for \code{e.lim} is 0.4 and 1.0 (maximum). This assumes that a satisfactory prediction is when the model explains more than 85\% of the total variation (normalized error = 40\%). Otherwise, if the value of the normalized error get above 80\%, the model accounts for less than 50\% of variability.
%%  ~~ If necessary, more details than the description above ~~
}

\references{
%% ~put references to the literature/web site here ~
Hengl, T., Heuvelink, G.M.B., Stein, A., 2004. A generic framework for spatial prediction of soil variables based on regression-kriging. Geoderma 122 (1-2): 75–93.
}
\author{ Tomislav Hengl
%%  ~~who you are~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ \code{\link{kml_legend.whitening}}, \code{\link{col2kml}}, \code{\link{kml2hex}}, \code{\link{hex2kml}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
whitening(x=15, xvar=5, x.lim=c(10,20), global.var=7)
# significant color;
whitening(x=15, xvar=5, x.lim=c(10,20), global.var=4)
# error exceeds global.var -> totally white;
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
