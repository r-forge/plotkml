\name{mix5cols}
\alias{mix5cols}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Mix five colours
%%  ~~function to do ... ~~
}
\description{ Creates a colour ramp based on five input colours (RGB)
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mix5cols(color1, color2, color3, color4, color5, break1 = 1/4, break2 = 2/4, break3 = 3/4, no.col = 47)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{color1}{ first input colour (begin)
%%     ~~Describe \code{color1} here~~
}
  \item{color2}{ second input colour (intermediate) 
%%     ~~Describe \code{color2} here~~
}
  \item{color3}{ third input colour (intermediate) 
%%     ~~Describe \code{color3} here~~
}
  \item{color4}{ fourth input colour (intermediate) 
%%     ~~Describe \code{color4} here~~
}
  \item{color5}{ fifth input colour (end)
%%     ~~Describe \code{color5} here~~
}
  \item{break1}{ between the 1st ad 2nd colour (0--1 values)
%%     ~~Describe \code{break1} here~~
}
  \item{break2}{ break between the 2nd ad 3rd colour (0--1 values)
%%     ~~Describe \code{break2} here~~
}
  \item{break3}{ break between the 3rd ad 4th colour (0--1 values)
%%     ~~Describe \code{break3} here~~
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

\seealso{ \code{\link{mix3cols}}, \code{\link{hex}}, \code{\link{RGB}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
color1 <- RGB(0.706, 0.604, 0.804)
color2 <- RGB(0.663, 0.563, 0.663)
color3 <- RGB(0, 0.392, 0)
color4 <- RGB(0.0,0.1,0.0)
color5 <- RGB(0,0,0)
break1 <- .2
break2 <- .4
break3 <- .6
soc.pal <- mix5cols(color1, color2, color3, color4, color5, break1=break1, break2=break2, break3=break3)
windows.options(width=2, height=7)
par(mar=c(.5,0,.5,1))
plot(x=rep(1, length(soc.pal)), y=1:length(soc.pal), axes=FALSE, xlab='', ylab='', pch=15, cex=1.5, col=soc.pal)
no.break1 <- round(break1*length(soc.pal), 0)
no.break2 <- round(break2*length(soc.pal), 0)
no.break3 <- round(break3*length(soc.pal), 0)
labs <- c(soc.pal[1], soc.pal[no.break1], soc.pal[no.break2], soc.pal[no.break3], soc.pal[length(soc.pal)])
text(x=rep(1, length(labs)), y=c(1, no.break1, no.break2, no.break3, length(soc.pal)), labels=labs, cex=.8, pos=4, offset=1)
}

