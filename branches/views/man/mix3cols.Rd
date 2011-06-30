\name{mix3cols}
\alias{mix3cols}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mix3cols(color1, color2, color3, break1, no.col)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{color1}{
%%     ~~Describe \code{color1} here~~
}
  \item{color2}{
%%     ~~Describe \code{color2} here~~
}
  \item{color3}{
%%     ~~Describe \code{color3} here~~
}
  \item{break1}{
%%     ~~Describe \code{break1} here~~
}
  \item{no.col}{
%%     ~~Describe \code{no.col} here~~
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
function(color1, color2, color3, break1, no.col) {
# Mixes three RGB colors into a pallette
if(missing(no.col)) { no.col <- 47 }
if(missing(break1)) { break1 <- 1/2 }
no.col1 <- round((break1-0)*no.col, 0)
no.col2 <- round((1-break1)*no.col, 0)
col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
mixedcol <- c(col1_2, col2_3)
return(mixedcol)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
