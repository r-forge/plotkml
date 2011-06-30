\name{RGB2FBGR}
\alias{RGB2FBGR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
RGB2FBGR(R, G, B, transp)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{R}{
%%     ~~Describe \code{R} here~~
}
  \item{G}{
%%     ~~Describe \code{G} here~~
}
  \item{B}{
%%     ~~Describe \code{B} here~~
}
  \item{transp}{
%%     ~~Describe \code{transp} here~~
}
}
\details{
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
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(R, G, B, transp) {
# See: http://code.google.com/intl/nl-NL/apis/kml/documentation/kmlreference.html#color
# transp = 00 to ff
# generate Google colors:
R <- round(R*100, 0)
B <- round(B*100, 0)
G <- round(G*100, 0)
if(missing(transp)) { transp <- "dd" } # very little transparency
FBGR <- paste(transp, ifelse(B<10, paste("0", B, sep=""),
ifelse(B==100, "ff", B)), ifelse(G<10, paste("0", G, sep=""),
ifelse(G==100, "ff", G)), ifelse(R<10, paste("0", R, sep=""),
ifelse(R==100, "ff", R)), sep="")
return(FBGR)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
