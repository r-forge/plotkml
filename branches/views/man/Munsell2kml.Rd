\name{Munsell2FBGR}
\alias{Munsell2FBGR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Munsell color codes to FBGR conversion}
\description{ Converts Munsell color codes to hexadecimal FBGR color codes as specified in the \href{http://code.google.com/apis/kml/documentation/kmlreference.html}{KML reference}.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Munsell2FBGR(x, Munsell, transp = "dd")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{  data frame 
%%     ~~Describe \code{x} here~~
}
  \item{Munsell}{  Munsell Color code column name. The column values need to be formatted as single characters e.g. \code{10YR_4_3} where \code{10YR} is Hue, \code{4} is Chroma and \code{3} is Value and \code{_} is the delimiter.
%%     ~~Describe \code{Munsell} here~~
}
  \item{transp}{  transparency level in range 0-1
%%     ~~Describe \code{transp} here~~
}
}
\details{ FBGR is a six characters long description of transparency, Blue, Green and Red color intensities in form (\code{aabbggrr}) where aa=alpha (00 to ff); bb=blue (00 to ff); gg=green (00 to ff); rr=red (00 to ff). 
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
\item KML Reference: \url{http://code.google.com/apis/kml/documentation/kmlreference.html}

\item Munsell color system: \url{http://en.wikipedia.org/wiki/Munsell_color_system}
%% ~put references to the literature/web site here ~
}
\author{  Tomislav Hengl \& Dylan Beaudette
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ \code{\link{mix3cols}}, \code{\link{mix5cols}}, \code{\link{whitening}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
x <- expand.grid(hue=c('10YR', '7.5YR', '5YR', '2.5R'), value=2:8, chroma=1:8, KEEP.OUT.ATTRS=FALSE)
str(x)
x$Munsell <- paste(x$hue, x$chroma, x$value, sep="_")
x$FBGR <- Munsell2FBGR(x, "Munsell")
x$FBGR[1:5]
}
