\name{mix5cols}
\alias{mix5cols}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mix5cols(color1, color2, color3, color4, color5, break1, break2, break3, no.col)
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
  \item{color4}{
%%     ~~Describe \code{color4} here~~
}
  \item{color5}{
%%     ~~Describe \code{color5} here~~
}
  \item{break1}{
%%     ~~Describe \code{break1} here~~
}
  \item{break2}{
%%     ~~Describe \code{break2} here~~
}
  \item{break3}{
%%     ~~Describe \code{break3} here~~
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
function(color1, color2, color3, color4, color5, break1, break2, break3, no.col) {
# Mixes five RGB colors into a pallette
if(missing(no.col)) { no.col <- 47 }
if(missing(break1)) { break1 <- 1/4 }
if(missing(break2)) { break2 <- 2/4 }
if(missing(break3)) { break3 <- 3/4 }
# Mixes three RGB colors into a pallette
no.col1 <- round((break1-0)*no.col, 0)
no.col2 <- round((break2-break1)*no.col, 0)
no.col3 <- round((break3-break2)*no.col, 0)
no.col4 <- round((1-break3)*no.col, 0)
col1_2 <- sapply(sapply(seq(0,1,by=1/no.col1)[-no.col1], mixcolor, color1, color2), hex)
col2_3 <- sapply(sapply(seq(0,1,by=1/no.col2)[-no.col2], mixcolor, color2, color3), hex)
col3_4 <- sapply(sapply(seq(0,1,by=1/no.col3)[-no.col3], mixcolor, color3, color4), hex)
col4_5 <- sapply(sapply(seq(0,1,by=1/no.col4), mixcolor, color4, color5), hex)
mixedcol <- c(col1_2, col2_3, col3_4, col4_5)
return(mixedcol)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
