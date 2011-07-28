\name{mix3cols}
\alias{mix3cols}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Mix three colours
%%  ~~function to do ... ~~
}
\description{ Creates a colour ramp based on three input colours (RGB)
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mix3cols(color1, color2, color3, break1 = 1/2, no.col = 47)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{color1}{ first input colour (begin)
%%     ~~Describe \code{color1} here~~
}
  \item{color2}{ second input colour (intermediate) 
%%     ~~Describe \code{color2} here~~
}
  \item{color3}{ third input colour (end)
%%     ~~Describe \code{color3} here~~
}
  \item{break1}{ break between the 1st ad 2nd colour (0--1 values)
%%     ~~Describe \code{break1} here~~
}
  \item{no.col}{ total number of colours in the colour ramp
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
\author{ Tomislav Hengl
%%  ~~who you are~~
}
\note{ Colours need to be submitted as RGB values (\code{\link{RGB}}). The browse the hexadecimal strings (\code{\link{hex}}) look at e.g. Earl F. Glynn's \href{http://research.stowers-institute.org/efg/R/}{colour in R slides}. 
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ \code{\link{mix5cols}}, \code{\link{hex}}, \code{\link{RGB}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
color1 <- RGB(1,0.843,0)
color2 <- RGB(0.5451,0.353,0.169) 
color3 <- RGB(0,0,0)
break1 <- .6
tex.pal <- mix3cols(color1, color2, color3, break1=break1)
windows.options(width=2, height=7)
par(mar=c(.5,0,.5,1))
plot(x=rep(1, length(tex.pal)), y=1:length(tex.pal), axes=FALSE, xlab='', ylab='', pch=15, cex=1.5, col=tex.pal)
no.break1 <- round(break1*length(tex.pal), 0)
labs <- c(tex.pal[1], tex.pal[no.break1], tex.pal[length(tex.pal)])
text(x=rep(1, length(labs)), y=c(1, no.break1, length(tex.pal)), labels=labs, cex=.8, pos=4, offset=1)
}
