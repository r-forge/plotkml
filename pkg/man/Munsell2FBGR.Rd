\name{Munsell2FBGR}
\alias{Munsell2FBGR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Munsell2FBGR}
\description{ Converts Munsell color codes to hexadecimal FBGR color codes as specified in the \href{http://code.google.com/apis/kml/documentation/kmlreference.html}{KML reference}.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Munsell2FBGR(x, Munsell, transp)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{  Data frame. 
%%     ~~Describe \code{x} here~~
}
  \item{Munsell}{  Munsell Color code column name. The column values need to be formatted as single characters e.g. \code{10YR_4_3} where \code{10YR} is Hue, \code{4} is Chroma and \code{3} is Value and \code{_} is the delimiter.
%%     ~~Describe \code{Munsell} here~~
}
  \item{transp}{  Transparency level in range 0-1.
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

\seealso{ \code{\link{mix3cols}}, \code{\link{mix5cols}}, \code{\link{whitening.col}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.
x <- expand.grid(hue=c('10YR', '7.5YR', '5YR', '2.5R'), value=2:8, chroma=1:8)
x$Munsell <- paste(d$hue, d$chroma, d$value, sep="_")[1:length(meuse@data[,1])]
x$FBGR <- Munsell2FBGR(x, "Munsell")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
