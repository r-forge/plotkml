\name{kml_legend.whitening}
\alias{legend.whitening}
\title{ legend.whitening
%%  ~~function to do ... ~~
}
\description{ Produces a PNG legend file for screen overlay (legend for colours produced using the whitening technique).
}
\usage{
kml_legend.whitening(legend.res = 0.01, width=120, height=300, pointsize = 14, x.lim, e.lim, leg.asp = height/width, legend.file = "whitening_legend.png", matte="")
}

\arguments{
  \item{legend.res}{ Resolution on a 0-1 scale
}
  \item{width}{ Image width
}
  \item{height}{ Image height
}
  \item{pointsize}{ Point size in units for text
}
  \item{x.lim}{ Upper and lower limits for target variable
}
  \item{e.lim}{ Upper and lower limits for the normalized error
}
  \item{leg.asp}{ Legend aspect
}
  \item{legend.file}{ File name
}
  \item{matte}{ Fix transparency using ImageMagick?
}
}
\details{ In order to force transparency, the algorithm uses \href{http://www.imagemagick.org/script/download.php}{ImageMagick} convert function. This is an external package and needs to be installed separately. 
}

\references{
Hengl, T., Heuvelink, G.M.B., Stein, A., 2004. A generic framework for spatial prediction of soil variables based on regression-kriging. Geoderma 122 (1-2): 75–93.

\url{http://www.imagemagick.org}
}
\author{ Tomislav Hengl
}

\seealso{ \code{\link{whitening}}
}
\examples{
kml_legend.whitening(x.lim=c(5,20), e.lim=c(.6,1), matte=TRUE)
# creates a PNG in the currect directory;
}
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
