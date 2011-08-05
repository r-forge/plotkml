\name{munsell2kml}
\alias{munsell2kml}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Munsell color codes to FBGR conversion}
\description{ Converts Munsell color codes to hexadecimal FBGR color codes as specified in the \href{http://code.google.com/apis/kml/documentation/kmlreference.html}{KML reference}.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
munsell2kml(the_hue, the_chroma, the_value, transp = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{the_hue}{ The Hue value i.e. colour type. 
}
  \item{the_chroma}{ The colour intensity. 
}
  \item{the_value}{ Colour brightness.
}
  \item{alpha}{ Transparency level in range 0 (full trasparency) to 1 (no trasparency). 
}
}
\details{ Munsell colour codes are in format e.g. \code{10YR_4_3} where \code{10YR} is Hue, \code{4} is Chroma and \code{3} is Value and \code{_} is the delimiter. FBGR is a six characters long description of transparency, Blue, Green and Red color intensities in form (\code{aabbggrr}) where aa=alpha (00 to ff); bb=blue (00 to ff); gg=green (00 to ff); rr=red (00 to ff). 
}
\references{
\item KML Reference: \url{http://code.google.com/apis/kml/documentation/kmlreference.html}

\item Munsell color system: \url{http://en.wikipedia.org/wiki/Munsell_color_system}
%% ~put references to the literature/web site here ~
}
\author{  Tomislav Hengl \& Dylan Beaudette
}
\note{
}

\seealso{ \code{\link{mix3cols}}, \code{\link{mix5cols}}, \code{\link{whitening}}
}
\examples{
x <- expand.grid(hue=c('10YR', '7.5YR', '5YR', '2.5R'), value=2:8, chroma=1:8, KEEP.OUT.ATTRS=FALSE)
str(x)
x$FBGR <- munsell2kml(x$hue, x$chroma, x$value)
x$FBGR[1:5]
}
